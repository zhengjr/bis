unit BisAudioWave;

interface

uses Windows, Classes,
     MMSystem,
     WaveRecorders, WavePlayers, WaveMixer, WaveStorage, WaveUtils,
     WaveACM, WaveACMDrivers;

type
  TBisAudioLiveRecorder=class(TLiveAudioRecorder)
  private
    FStarting: Boolean;
    FStopping: Boolean;
  protected
    procedure DoActivate; override;
    procedure DoDeactivate; override;
  public
    constructor Create(AOwner: TComponent); override;
    function GetDeviceNameByID(ADeviceID: Cardinal): String;
    procedure FillDevices(Strings: TStrings);

    procedure Start(Wait: Boolean=false);
    procedure Stop(Wait: Boolean=false);
  end;

  TBisAudioLivePlayer=class(TLiveAudioPlayer)
  private
    FStarting: Boolean;
    FStopping: Boolean;
  protected
    procedure DoActivate; override;
    procedure DoDeactivate; override;
  public
    constructor Create(AOwner: TComponent); override;

    function GetDeviceNameByID(ADeviceID: Cardinal): String;
    procedure FillDevices(Strings: TStrings);

    procedure Start(Wait: Boolean=false);
    procedure Stop(Wait: Boolean=false);
  end;

  TBisAudioStockPlayerDataEvent=procedure (Sender: TObject; const Buffer: Pointer; BufferSize: DWord) of object;

  TBisAudioStockPlayer=class(TStockAudioPlayer)
  private
    FCounter: Integer;
    FLoopCount: Integer;
    FStream: TStream;
    FStartPos: Int64;
    FStarting: Boolean;
    FStopping: Boolean;
    FOnStop: TNotifyEvent;
    FOnData: TBisAudioStockPlayerDataEvent;
    FSpeedFactor: Single;
    procedure SetSpeedFactor(const Value: Single);
    procedure PlayStreamFromBegin;
  protected
    function GetActive: Boolean; override;
    procedure DoActivate; override;
    procedure DoDeactivate; override;
    procedure GetWaveFormat(var pWaveFormat: PWaveFormatEx; var FreeIt: Boolean); override;
    function GetWaveData(const Buffer: Pointer; BufferSize: DWORD; var NumLoops: DWORD): DWORD; override;
    procedure DoStop; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure PlayStream(Stream: TStream; LoopCount: Integer=MaxInt);
    procedure Stop(Wait: Boolean=false);

    property SpeedFactor: Single read FSpeedFactor write SetSpeedFactor;

    property OnStop: TNotifyEvent read FOnStop write FOnStop;
    property OnData: TBisAudioStockPlayerDataEvent read FOnData write FOnData;
  end;

  TBisAudioMixer=class(TAudioMixer)
  end;

  TBisAudioWave=class(TWave)
  end;

  TBisAudioWaveConverter=class(TWaveConverter)
  end;

  TBisAudioACMDrivers=class(TWaveACMDrivers)
  end;

implementation

uses SysUtils,
     BisThreads;

{ TBisAudioLiveRecorder }

constructor TBisAudioLiveRecorder.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  WaveThreadName:=Copy(ClassName,5,Length(ClassName)-4);
end;

function TBisAudioLiveRecorder.GetDeviceNameByID(ADeviceID: Cardinal): String;
var
  DevCaps: TWaveInCaps;
begin
  if WaveInGetDevCaps(ADeviceID, @DevCaps, SizeOf(DevCaps)) = MMSYSERR_NOERROR then
    Result := StrPas(DevCaps.szPname)
  else
    Result := '';
end;

procedure TBisAudioLiveRecorder.FillDevices(Strings: TStrings);
var
  i: Cardinal;
begin
  if Assigned(Strings) then begin
    Strings.BeginUpdate;
    try
      for i:=0 to NumDevs-1 do begin
        Strings.Add(GetDeviceNameByID(i));
      end;
    finally
      Strings.EndUpdate;
    end;
  end;
end;

procedure TBisAudioLiveRecorder.DoActivate;
begin
  inherited DoActivate;
  FStarting:=false;
end;

procedure TBisAudioLiveRecorder.DoDeactivate;
begin
  inherited DoDeactivate;
  FStopping:=false;
end;

procedure TBisAudioLiveRecorder.Start(Wait: Boolean);
begin
  if not Active and not FStarting then begin
    FStarting:=true;
    Active:=true;
    if Wait then
      WaitForStart;
  end;
end;

procedure TBisAudioLiveRecorder.Stop(Wait: Boolean);
begin
  if Active and not FStopping then begin
    FStopping:=true;
    Active:=false;
    if Wait then
      WaitForStop;
  end;
end;

{ TBisAudioLivePlayer }

constructor TBisAudioLivePlayer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  WaveThreadName:=Copy(ClassName,5,Length(ClassName)-4);
end;

function TBisAudioLivePlayer.GetDeviceNameByID(ADeviceID: Cardinal): String;
var
  DevCaps: TWaveOutCaps;
begin
  if waveOutGetDevCaps(ADeviceID, @DevCaps, SizeOf(DevCaps)) = MMSYSERR_NOERROR then
    Result := StrPas(DevCaps.szPname)
  else
    Result := '';
end;

procedure TBisAudioLivePlayer.FillDevices(Strings: TStrings);
var
  i: Cardinal;
begin
  if Assigned(Strings) then begin
    Strings.BeginUpdate;
    try
      for i:=0 to NumDevs-1 do begin
        Strings.Add(GetDeviceNameByID(i));
      end;
    finally
      Strings.EndUpdate;
    end;
  end;
end;

procedure TBisAudioLivePlayer.DoActivate;
begin
  inherited DoActivate;
  FStarting:=false;
end;

procedure TBisAudioLivePlayer.DoDeactivate;
begin
  inherited DoDeactivate;
  FStopping:=false;
end;

procedure TBisAudioLivePlayer.Start(Wait: Boolean=false);
begin
  if not Active and not FStarting then begin
    FStarting:=true;
    Active:=true;
    if Wait then
      WaitForStart;
  end;
end;

procedure TBisAudioLivePlayer.Stop(Wait: Boolean=false);
begin
  if Active and not FStopping then begin
    FStopping:=true;
    Active:=false;
    if Wait then
      WaitForStop;
  end;
end;

{ TBisAudioStockPlayer }

constructor TBisAudioStockPlayer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCounter:=0;
  FSpeedFactor:=1.0;
end;

destructor TBisAudioStockPlayer.Destroy;
begin
  Stop;
  inherited Destroy;
end;

procedure TBisAudioStockPlayer.DoActivate;
begin
  inherited DoActivate;
  FStarting:=false;
  Inc(FCounter);
end;

procedure TBisAudioStockPlayer.PlayStreamFromBegin;
begin
  if Assigned(FStream) then begin
    FStream.Position:=FStartPos;
    inherited PlayStream(FStream);
  end;
end;

procedure TBisAudioStockPlayer.DoDeactivate;
begin
  inherited DoDeactivate;
  if (FCounter<FLoopCount) and not FStopping then begin
    if Assigned(FStream) then begin
      if not Async then
        PlayStreamFromBegin
      else
        TBisThread.StaticQueue(PlayStreamFromBegin);
    end;
  end else begin
    FStopping:=false;
    DoStop;
  end;
end;

procedure TBisAudioStockPlayer.DoStop;
begin
  if Assigned(FOnStop) then
    FOnStop(Self);
end;

function TBisAudioStockPlayer.GetActive: Boolean;
begin
  Result:=inherited GetActive;
end;

function TBisAudioStockPlayer.GetWaveData(const Buffer: Pointer; BufferSize: DWORD; var NumLoops: DWORD): DWORD;
begin
  Result:=inherited GetWaveData(Buffer,BufferSize,NumLoops);
  if Assigned(FOnData) then
    FOnData(Self,Buffer,Result);
end;

procedure TBisAudioStockPlayer.GetWaveFormat(var pWaveFormat: PWaveFormatEx; var FreeIt: Boolean);
begin
  inherited GetWaveFormat(pWaveFormat,FreeIt);
  if Assigned(pWaveFormat) then
    pWaveFormat.nSamplesPerSec:=Round(FSpeedFactor*pWaveFormat.nSamplesPerSec);
end;

procedure TBisAudioStockPlayer.PlayStream(Stream: TStream; LoopCount: Integer);
begin
  Stop(true);
  if not Active and not FStarting and
     Assigned(Stream) then begin
    FStarting:=true;
    FCounter:=0;
    FLoopCount:=LoopCount;
    FStream:=Stream;
    FStartPos:=Stream.Position;
    inherited PlayStream(Stream);
    WaitForStart;
  end;
end;

procedure TBisAudioStockPlayer.SetSpeedFactor(const Value: Single);
begin
  FSpeedFactor:=Value;
end;

procedure TBisAudioStockPlayer.Stop(Wait: Boolean=false);
begin
  if Active and not FStopping then begin
    FStopping:=true;
    Active:=false;
    if Wait then
      WaitForStop;
  end;
end;

end.