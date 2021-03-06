unit BisDtmf;

interface

uses Classes;

type
  TBisDtmfCodeEvent=procedure(Sender: TObject; const Code: Char) of object;

  TBisDtmfMd4 = array[1..4] of double;

  TBisDtmf=class(TComponent)
  private
    FSamplesPerSec: Integer;	// source sampling rate
    FBitsPerSample: Integer;		// source number of bits per sample
    FChannels: Integer; 	// source number of channels

    FNMX: Integer;                 	// num of samples in input buf
    FBMX: Integer;                 	// index of first sample
    FMX: array[0..1000-1] of Smallint;  	// input buf
    FNG: Integer;                    	// num of Goertzel cycles

    FKGL: TBisDtmfMd4;			// "Goertzel" F (697..941)
    FKGH: TBisDtmfMd4;     // "Goertzel" F (1209..1633)

    FSampleSize: Integer;   	// ms per Goertzel analyzis
    FQuality: Single;

    FState: Integer;
    FThreshold: Integer;
    FOnCode: TBisDtmfCodeEvent;

    function ProcessBuffer: Boolean;
  protected
    procedure DoCode(const Code: Char; const Param: Single; const LowFreq, HighFreq: Double); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function SetFormat(SamplesPerSec, BitsPerSample, Channels: Integer): Boolean;
    function Write(const Data: Pointer; Size: Integer): Boolean;
    function LoadFromStream(Stream: TStream): Boolean;
    
    property Threshold: Integer read FThreshold write FThreshold;
    property Quality: Single read FQuality write FQuality;

    property OnCode: TBisDtmfCodeEvent read FOnCode write FOnCode;
  end;


implementation

uses SysUtils, Math;


type

  TBisDtmfInfo=record     // Goertzel results
    S2:    Double;     // sum of squares
    MxGLH: Double;     // sum of squares for all harmonics
    MxGL:  Double;     // sum of squares for 697..941 harmonics
    MxGH:  Double;     // sum of squares for 1209..1633 harmonics
    MGLM:  Double;     // Max of 697..941
    MGHM:  Double;     // Max of 1209..1633
    IL: Integer;       // index of max from F 697..941
    IH: Integer;       // index of max from F 1209..1633)
    K1: Single;        // MxGLH/S2
    K2: Single;        // MxGL/MxGLH
    K3: Single;        // MxGH/MxGLH
    K4: Single;        // MGLM/MxGL
    K5: Single;        // MGHM/MxGH
    K6: Single;        // K1*K2*K3*K4*K5 - signal quality estimation
  end;


const
  
  DtmfFDL: TBisDtmfMd4=(697,   770,  852,  941);	// DTMF low freqs
  DtmfFDH: TBisDtmfMd4=(1209, 1336, 1477, 1633); 	// DTMF hi freqs
  DtmfTxDTMF='147*2580369#ABCD';	//	DTMF codes
  DtmfSamplesPerSec=8000;

  MaxIndex08=$7FFFFFFF;
  MaxIndex16=MaxIndex08 shr 1;

type
  TArray=array[0..MaxIndex08-1] of Byte;	/// array of bytes (unsigned 8 bits integer values)
  PArray=^TArray;					/// pointer to array of bytes (unsigned 8 bits integer values)

  TInt16Array=array[0..MaxIndex16-1] of Smallint;	/// array of signed 16 bit integers
  PInt16Array=^TInt16Array;					/// pointer to array of signed 16 bit integers

procedure LoadSample(); assembler;
{
	IN:	AL	- number of bits in sample (8, 16 or 32)
		ESI	- memory buffer pointer

	OUT:    EAX	- sample value (always 32 bit signed integer)

	AFFECTS:
		EAX
		ESI
}
asm

	cmp	al, 16
	je	@load_A16

	cmp	al, 8
	je	@load_A8

	cmp	al, 4
	je	@load_A4

  //@load_A32:
	lodsd			// eax = signed integer
	jmp	@exit

  @load_A4:
  	// not supported yet	
	jmp	@exit

  @load_A8:
	lodsb
	and	eax, 0FFh
	sub	eax, 080h
	sal	eax, 8		// eax = signed integer
	jmp	@exit

  @load_A16:
	lodsw
	cwde			// eax = signed integer
  @exit:
end;

procedure SaveSample(); assembler;
{
	IN:	BL	- 8, 16 or 32 bits in destination sample
		EAX	- sample value to store (always 32 bit signed integer)
		EDI	- memory buffer pointer

	OUT:    none

	AFFECTS:
		EAX
		EDI
}
asm
	push	ebx

	cmp	bl, 8
	je	@store_8

	cmp	bl, 16
	je	@store_16

	// store as 32 bit value
  //@store_32:
	stosd
	jmp	@exit

	// store as 16 bit value
  @store_16:
	mov	ebx, eax
	add	ebx, 08000h
	test	ebx, 080000000h
	jz	@store_16_01

	mov	eax, 08000h
	jmp	@store_16_w

  @store_16_01:
	test	eax, 080000000h
	jnz	@store_16_w

	mov	ebx, eax
	sub	ebx, 08000h
	test	ebx, 080000000h
	jnz	@store_16_w

	mov	eax, 07FFFh

  @store_16_w:
	stosw
	jmp	@exit

	// store as 8 bit value
  @store_8:
	sar	eax, 8
	add	eax, 080h
	test	eax, 080000000h
	jz	@store_8_01

	mov	eax, 0
	jmp	@store_8_b

  @store_8_01:
	cmp	eax, 0100h
	jb	@store_8_b

	mov	eax, 0FFh

  @store_8_b:
	stosb

  @exit:
	pop	ebx
end;

function WaveResample(bufSrc, bufDst: Pointer; samples,
                      numChannelsSrc, numChannelsDst, bitsSrc, bitsDst, rateSrc, rateDst: Cardinal): Cardinal;
const
  const_dstChannelMul = 100;
var
  step: double;
  next: double;
  u: Cardinal;
  srcChannel: Cardinal;
  dstChannelStep: Cardinal;
  sample: Cardinal;
begin
  if (
      (nil = bufSrc) or
      (nil = bufDst) or
      (1 > bitsSrc) or
      (1 > bitsDst) or
      (1 > numChannelsSrc) or
      (1 > numChannelsDst) or
      (1 > samples) or
      (1 > rateSrc) or
      (1 > rateDst)
     ) then
    // invalid params
    result := 0
  else begin
    //
    if (
	(rateDst = rateSrc) and
	(numChannelsSrc = numChannelsDst) and
	(bitsSrc = bitsDst)
       ) then begin
      //
      result := samples * numChannelsSrc * bitsSrc shr 3;
      if ((bufSrc <> bufDst) and (0 < result)) then
	move(bufSrc^, bufDst^, result);
      //
      exit;	// nothing to do
    end;
    //
    next := 0;
    step := rateDst / rateSrc;
    //
    //dstChannelMul := 100;
    dstChannelStep := (numChannelsDst * const_dstChannelMul) div numChannelsSrc;

    asm
	push	esi
	push	edi
	push	ebx

	//cld			// should be
	mov	esi, bufSrc	// set source pointer
	mov	edi, bufDst	// set dest pointer
	mov	ecx, samples	// set samples counter
	mov	bl, byte ptr bitsDst	// set dest sample size
	mov	bh, byte ptr bitsSrc	// set source sample size

	fld	next		// push next on FPU stack
	xor	edx, edx	// EDX is a sample counter in dest buffer

	// --------- loop ends here ------
	
  @loop:
	push	ecx	// save ECX

	fadd	step	// go to next sample
	fist	u	// round the floating point value to unsigned
	fwait		//

	cmp	edx, u		// do we need to store this source sample into dest buffer?
	jae	@nextSrcSample	// if no, skip this sample

	// -- store this sample

  @storeSample:
	// save ESI since it could be required to store same sample several times
	push	esi
	push	edx

	xor	eax, eax
	mov	srcChannel, eax		// source channel counter
	mov	sample, eax		// sample value
	mov	edx, eax		// number of source channels mixed so far
	mov	ecx, eax		// dest channel number

  @loopSrcChannels:
	mov	al, bh
	call	loadSample		// get source sample value into EAX
	inc	srcChannel		// inc the source channel counter
	add	sample, eax		// mix this sample
	inc	edx			// inc number of mixed channels

  //@storeDstChannel:
	add	ecx, dstChannelStep		// go to next channel in dest buffer
	cmp	ecx, const_dstChannelMul	// should we store the source channel?
	jb	@nextSrcChannel			// if no, go to next source channel

	mov	eax, sample	// prepare to store the sample
	cmp	edx, 1		// should we care about mixing?
	je	@skipSampleDiv	// if no, skip division

        jmp     @skip

  @loop1:
        jmp @loop

  @skip:
	push	ecx
	mov	ecx, edx
	cdq
	idiv	ecx		// divide mixed sample on number of channels
				// this way we should avoid increasing the volume level
	pop	ecx

  @skipSampleDiv:
	mov	edx, ecx	// set number of dest channels we must fill

	xor	ecx, ecx
	mov	sample, ecx	// zero sample value

	mov	ecx, eax	// save EAX value

  @loopDstChannel:
	mov	eax, ecx	// restore EAX value
	// BL must be set to bits number
	call 	saveSample	// store samples into dest buffer

	sub	edx, const_dstChannelMul	// go to next dest channel
	cmp	edx, const_dstChannelMul	// do we have more channels?
	jae	@loopDstChannel			// if yes, store the sample into next dest channel

	xor	ecx, ecx	// zero dest channel number
	mov	edx, ecx	// zero number of source channels mixed so far

  @nextSrcChannel:
	mov	eax, srcChannel		//
	cmp	eax, numChannelsSrc	// do we have more source channels?
	jb	@loopSrcChannels	// if yes, go to next source channel

	pop	edx
	// restore original ESI
	pop	esi

	inc	edx	       	// go to next dest sample
	cmp	edx, u		// do we have more dest samples to fill?
	jb	@storeSample	// if yes, save this source sample just one more time

  @nextSrcSample:
	// here we need to go to the next source sample
	mov	eax, numChannelsSrc	// assuming there are no more than $FF channels
	imul	bh			// byte ptr bitsSrc
	cwde				// EAX <- AX
	shr 	eax, 3
	add	esi, eax		// move source pointer to next sample

  //@goLoop:
	pop	ecx		// restore source samples counter
	loop	@loop1		// and loop if there are more samples to handle

	// --------- loop ends here ------

	fstp	next	// pop next from FPU stack

	mov	eax, edi
	sub	eax, bufDst
	mov	u, eax

	pop	ebx
	pop	edi
	pop	esi
    end;
    //
    result := u;
  end;
end;

{ TBisDtmf }

constructor TBisDtmf.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FThreshold:=900;
  FSampleSize:=20;
  FQuality:=2.5;
  SetFormat(DtmfSamplesPerSec,16,1);
end;

destructor TBisDtmf.Destroy;
begin

  inherited Destroy;
end;

procedure TBisDtmf.DoCode(const Code: Char; const Param: Single; const LowFreq, HighFreq: Double);
begin
  if Assigned(FOnCode) then
    FOnCode(Self,Code);
end;

function TBisDtmf.SetFormat(SamplesPerSec, BitsPerSample, Channels: Integer): Boolean;
var
  i: Integer;
begin
  Result:=false;
  if ((0<SamplesPerSec) and (8<=BitsPerSample) and (1<=Channels)) then begin

    FSamplesPerSec:=SamplesPerSec;	// source sampling rate
    FBitsPerSample:=BitsPerSample;	// source num of bits per sample
    FChannels:=Channels;	// source number of channels

    for i:=Low(TBisDtmfMd4) to High(TBisDtmfMd4) do begin
      FKGL[i]:=2.0 * Cos(2.0 * Pi * DtmfFDL[i] / DtmfSamplesPerSec);
      FKGH[i]:=2.0 * Cos(2.0 * Pi * DtmfFDH[i] / DtmfSamplesPerSec);
    end;
      //
    FNG:=Round(FSampleSize * DtmfSamplesPerSec / 1000); // ms
    FNMX:=0;		// num of samples in buffer
    FBMX:=0;		// first sample index

    result:=true;
  end;
end;

function TBisDtmf.Write(const Data: Pointer; Size: Integer): Boolean;
var
  i: Integer;
  d: pInt16Array;
  dSize: Integer;
  num: Integer;
  nc: Integer;
  doConvert: Boolean;
begin
  Result:=false;
  if ((0 < Size) and Assigned(Data)) then begin

    num:=0;
    d:=nil;
    dSize:=0;
    FState:=0;

    if ((1=FChannels) and (DtmfSamplesPerSec=FSamplesPerSec)) then begin

      doConvert:=false;
      case (FBitsPerSample) of
        16: begin
          d:=data;
          num:=size shr 1;	// num of samples is twice less
        end;
        8: begin
          dSize:=size shl 1;
          d:=AllocMem(dSize);	// two bytes per each sample from original buf
          num:=size;
          for i:=0 to Size-1 do
            d[i]:=(Integer(pArray(data)[i]) - $80) * $100;
        end;
      else
	      doConvert:=true;
      end;

    end else
       doConvert:=true;

    if (doConvert) then begin

      num:=(Size div FChannels);
      if (FBitsPerSample=16) then
        num:=num shr 1;

      dSize:=num shl 1;
      d:=AllocMem(dSize);	// two bytes per sample

      WaveResample(Data,d,num,FChannels,1,FBitsPerSample,16,FSamplesPerSec,DtmfSamplesPerSec);
    end;

    if Assigned(d) then begin
      try
        while (0<num) do begin
          nc:=Min(Length(FMX)-FNMX,num);
          if (0 < nc) then begin
            Move(d^,FMX[FNMX],nc shl 1);
            Inc(FNMX,nc);
            if ProcessBuffer then
              break;
            Dec(num, nc);
          end else
            break;	// no more input data
        end;
        Result:=true;
      finally
        if (d<>Data) then
          ReallocMem(d,dSize);
      end;
    end;
    
  end;
end;

function TBisDtmf.LoadFromStream(Stream: TStream): Boolean;
var
  Data: Pointer;
  DataSize: Integer;
  OldPos: Int64;
begin
  Result:=false;
  if Assigned(Stream) then begin
    DataSize:=Stream.Size-Stream.Position;
    if DataSize>0 then begin
      OldPos:=Stream.Position;
      GetMem(Data,DataSize);
      try
        Stream.Read(Data^,DataSize);
        Result:=Write(Data,DataSize);
      finally
        FreeMem(Data);
        Stream.Position:=OldPos;
      end;
    end;
  end;
end;

function TBisDtmf.ProcessBuffer: Boolean;
var
  MGL: TBisDtmfMd4;
  MGH: TBisDtmfMd4;
  InfoO: TBisDtmfInfo;
  InfoI: TBisDtmfInfo;

  // Goertzel
  procedure RunG;
  var
    i1, i2: Integer;
    XI: Double;
    S0: Double;
    SM1L: TBisDtmfMd4;
    SM1H: TBisDtmfMd4;
    SM2L: TBisDtmfMd4;
    SM2H: TBisDtmfMd4;
  begin
    for i1 := Low(TBisDtmfMd4) to High(TBisDtmfMd4) do begin
      SM1L[i1] := 0.0;
      SM1H[i1] := 0.0;
      SM2L[i1] := 0.0;
      SM2H[i1] := 0.0;
    end;

    InfoI.S2 := 0.0;
    for i1 := 0 to FNG - 1 do begin

      XI := FMX[FBMX + i1];
      InfoI.S2 := InfoI.S2 + XI * XI;

      for i2 := Low(TBisDtmfMd4) to High(TBisDtmfMd4) do begin
        S0 := XI + FKGL[i2] * SM1L[i2] - SM2L[i2];
        SM2L[i2] := SM1L[i2];
        SM1L[i2] := S0;
        S0 := XI + FKGH[i2] * SM1H[i2] - SM2H[i2];
        SM2H[i2] := SM1H[i2];
        SM1H[i2] := S0;
      end;
    end;

    for i1 := Low(TBisDtmfMd4) to High(TBisDtmfMd4) do begin
      MGL[i1] := Sqrt(SM1L[i1] * SM1L[i1] + SM2L[i1] * SM2L[i1] - FKGL[i1] * SM1L[i1] * SM2L[i1]) / FNG;
      MGH[i1] := Sqrt(SM1H[i1] * SM1H[i1] + SM2H[i1] * SM2H[i1] - FKGH[i1] * SM1H[i1] * SM2H[i1]) / FNG;
    end;

    InfoI.MxGL  := Sqrt(MGL[1] * MGL[1] + MGL[2] * MGL[2] + MGL[3] * MGL[3] + MGL[4] * MGL[4]);
    InfoI.MxGH  := Sqrt(MGH[1] * MGH[1] + MGH[2] * MGH[2] + MGH[3] * MGH[3] + MGH[4] * MGH[4]);
    InfoI.MxGLH := Sqrt(InfoI.MxGL * InfoI.MxGL + InfoI.MxGH * InfoI.MxGH);
    InfoI.S2    := Sqrt(InfoI.S2) / FNG;
  end;

  procedure DecodeDTMF;
  var
    IDTMF: Integer;

    procedure RunK;   
    var
      i1: Integer;
      Max: Double;
    begin
      Max := -1.0;
      for i1 := Low(TBisDtmfMd4) to High(TBisDtmfMd4) do begin
        if (MGL[i1] > Max) then begin
          Max := MGL[i1];
          InfoI.IL := i1;
        end;
      end;

      Max := -1.0;
      for i1:=Low(TBisDtmfMd4) to High(TBisDtmfMd4) do begin
        if (MGH[i1] > Max) then begin
          Max := MGH[i1];
          InfoI.IH := i1;
        end;
      end;

      InfoI.K1 := InfoI.MxGLH / InfoI.S2;
      InfoI.K2 := InfoI.MxGL / InfoI.MxGLH;
      InfoI.K3 := InfoI.MxGH / InfoI.MxGLH;
      InfoI.K4 := MGL[InfoI.IL] / InfoI.MxGL;
      InfoI.K5 := MGH[InfoI.IH] / InfoI.MxGH;
      InfoI.K6 := InfoI.K1 * InfoI.K2 * InfoI.K3 * InfoI.K4 * InfoI.K5;
    end;

  begin
    case (FState) of
      0: begin
        if (InfoI.MxGLH > FThreshold) then begin
          RunK;
          FState:=1;
          InfoO.MxGLH := 0.0;
        end;
      end;
      1: begin
        if (InfoI.MxGLH > InfoO.MxGLH) then begin
          RunK;
          InfoO := InfoI;
        end	else begin
          if (InfoO.K6 >= FQuality) then begin
            IDTMF := (InfoO.IH - 1) * 4 + InfoO.IL;
            DoCode(DtmfTxDTMF[IDTMF],InfoO.K6,InfoO.S2,0.0);
            InfoO.MxGLH := 0.0;
            FState:= 2;
            Result:=true;
          end;
        end;
      end;
      2: begin
        if (InfoI.MxGLH < FThreshold) then
          FState:=0;
      end;
    end;
  end;

begin
  Result:=false;
  
  while (FNMX - FBMX >= FNG) do begin
    RunG;
    DecodeDTMF;
    FBMX := FBMX + (FNG shr 1);       // shift first sample index by half of NG size
  end;

  if (FNMX > 0) then begin
    if (0 < FBMX) then begin

      if (FBMX < FNMX) then
        Move(FMX[FBMX], FMX[0], (FNMX - FBMX) shl 1);	// move tail to buffer's head

      Dec(FNMX, FBMX);
      FBMX := 0;    // reset first sample index
      
    end;
  end;
end;

end.
