unit Acm;

{******************************************************************************
 *
 *  ACMComponents
 *
 *
 *  Copyright(C) 2004 Mattia Massimo dhalsimmax@tin.it
 *  This file is part of ACMCOMPONENTS
 *
 *  ACMCOMPONENTS are free software; you can redistribute it and/or modify it
 *  under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *****************************************************************************}

interface

uses
  msacm,mmsystem,Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,SyncObjs;

Const
  acm_DefBufSize = 16384;

type
  TACMComponent = Class;

  TACMDataEvent = Procedure (Sender:TACMComponent;aDataPtr:Pointer;aDataSize:Cardinal) Of Object;

  TACMFormatChooser = Class;

  TACMComponent  = Class (TComponent)
   Private
    FLock: TRTLCriticalSection;
    FBufSize:Cardinal;
    FActive:Boolean;
    FDeviceID:HWaveOut;
    FHeaders:Array Of TWaveHdr;
    FHandle:HWave;
    FOnClose:TNotifyEvent;
    FOnOpen:TNotifyEvent;
    FOnData:TACMDataEvent;
    FFmtChooser:TACMFormatChooser;
    FNumBuffers:Byte;
    FAutoSize:Boolean;
    Procedure FSetBufferSize (aValue:Cardinal);
    Procedure FSetNumBuffers (aValue:Byte);
    Procedure FFreeBuffers;
    Procedure FCheck (ErrorMsg:String;Result:Cardinal);
    Procedure FSetActive (aValue:Boolean);
    Procedure FSetFmtChooser (aValue:TACMFormatChooser);
    Procedure FDoOnOpen;
    Procedure FDoOnClose;
    Procedure FDoOnCallBack(aHeader:PWavehdr);Virtual;Abstract;
    procedure Lock;
    procedure UnLock;
   Public
    Constructor Create (aOwner:TComponent);Override;
    Destructor Destroy;Override;
    Procedure Open;Virtual;
    Procedure Close;Virtual;Abstract;
   Published
    Property Active:Boolean Read FActive Write FSetActive;
    Property OnOpen:TNotifyEvent Read FOnOpen Write FOnOpen;
    Property OnClose:TNotifyEvent Read FOnClose Write FOnClose;
    Property OnData:TACMDataEvent Read FOnData Write FOnData;
    Property WaveFormatChooser:TACMFormatChooser Read FFmtChooser Write FSetFmtChooser;
    Property DeviceID:HWaveOut Read FDeviceID Write FDeviceID;
    Property BufferSize:Cardinal Read FBufSize Write FSetBufferSize;
    Property HeadersNum:Byte Read FNumBuffers Write FSetNumBuffers;
    Property AutoBufferSize:Boolean Read FAutoSize Write FAutoSize;
  End;

  TACMOut = Class(TACMComponent)
    Private
      Procedure FDoOnCallBack (aHeader:PWaveHdr);Override;
    Public
      procedure Open;Override;
      procedure PlayBack(Data:pointer;Size:DWORD);Overload;
      procedure PlayBack(S:TStream);Overload;
      procedure Close;Override;
    published
    end;

  TACMIn = Class (TACMComponent)
    Private
      FClosing:Boolean;
      Procedure FDoOnCallBack (aHeader:PWaveHdr);Override;
      Procedure FPrepareHeader (aHeader:PWaveHdr);
    Public
      procedure Open;Override;
      procedure Close;Override;
    published
    end;

   TACMFormatChooser = Class (TComponent)
                       Private
                        FFmtSize:Cardinal;
                        FOwner:TACMComponent;
                        FFmt:PWaveFormatEx;
                        Function IsValid:Boolean;Virtual;
                        Procedure FInitDefaultFormat;
                        Procedure FFreeFC;
                        Procedure FCheck (ErrorMsg:String;Result:Boolean);
                        Function FGetwFormatTag:Word;
                        Function FGetnChannels:Word;
                        Function FGetnSamplesPerSec:DWord;
                        Function FGetnAvgBytesPerSec:DWord;
                        Function FGetnBlockAlign:Word;
                        Function FGetwBitsPerSample:Word;
                        Function FGetCbSize:Word;
                        Function FGetExtraBytes:Pointer;
                        Procedure FSetwFormatTag(aValue:Word);
                        Procedure FSetnChannels(aValue:Word);
                        Procedure FSetnSamplesPerSec(aValue:DWord);
                        Procedure FSetnAvgBytesPerSec(aValue:DWord);
                        Procedure FSetnBlockAlign(aValue:Word);
                        Procedure FSetwBitsPerSample(aValue:Word);
                        Procedure FSetCbSize(aValue:Word);
                       Public
                        Constructor Create (aOwner:TComponent);Override;
                        Destructor Destroy;Override;
                        Procedure UseCB (SrcCB:Pointer;CbSize:Word);
                        Procedure SaveCB (DestCB:Pointer);
                        Procedure UseFormat (SrcFmt:PWaveFormatEx;Size:Cardinal);
                        Procedure SaveFormat (DestFmt:PWaveFormatEx);
                        Property WaveFormatEx:PWaveFormatEx Read FFmt;
                        Property WaveFormatSize:Cardinal Read FFmtSize;
                        Property Cb:Pointer Read FGetExtraBytes;
                        Property CbSize:Word Read FGetCbSize Write FSetCBSize;
                       Published
                        Property wFormatTag:Word Read FGetWFormatTag Write FSetWFormatTag;
                        Property nChannels:Word Read FGetnChannels Write FSetnChannels;
                        Property nSamplesPerSec:DWORD Read FGetnSamplesPerSec Write FSetnSamplesPerSec;
                        Property nAvgBytesPerSec:DWORD Read FGetnAvgBytesPerSec Write FSetnAvgBytesPerSec;
                        Property nBlockAlign:Word Read FGetnBlockAlign Write FSetnBlockAlign;
                        Property nBitsPerSample:Word Read FGetwBitsPerSample Write FSetwBitsPerSample;
                       End;


   TACMDlg = class(TACMFormatChooser)
    private
      FC:TACMFORMATCHOOSEA;
    Public
      Function Execute:Boolean;
    end;

Procedure Register;

implementation

Procedure WaveOutProc (Hwo:HWAVEOUT;uMsg:DWord;dwInstance:DWord;dwParam1:DWord;dwParam2:DWord); stdcall;

Begin
  With TACMComponent(dwInstance)
    Do
      Case uMsg Of
        WOM_OPEN:FDoOnOpen;
        WOM_CLOSE:FDoOnClose;
        WOM_DONE:FDoOnCallBack (PWaveHDR(dwParam1));
      End;
End;

Procedure WaveInProc (Hwo:HWAVEIN;uMsg:DWord;dwInstance:DWord;dwParam1:DWord;dwParam2:DWord); stdcall;

Begin
  With TACMComponent(dwInstance)
    Do
      Case uMsg Of
        WIM_OPEN:FDoOnOpen;
        WIM_CLOSE:FDoOnClose;
        WIM_DATA:FDoOnCallBack (PWaveHDR(dwParam1));
      End;
End;

Function Min (A,B:Cardinal):Cardinal;

Begin
  If A < B
    Then
      Result:=A
    Else
      Result:=B;
End;

Constructor TACMComponent.Create (aOwner:TComponent);

Begin
  Inherited Create (aOwner);
  InitializeCriticalSection(FLock);
  FActive:=False;
  FOnOpen:=Nil;
  FOnClose:=Nil;
  FDeviceID:=0;
  FNumBuffers:=0;
  FHeaders:=Nil;
  FSetNumBuffers(3);
  FSetBufferSize (acm_DefBufSize);
  FAutoSize:=True;
End;

Destructor TACMComponent.Destroy;

Begin
  Close;
  FFreeBuffers;
  WaveFormatChooser:=Nil;
  DeleteCriticalSection(FLock);
  Inherited;
End;

procedure TACMComponent.Lock;
begin
  EnterCriticalSection(FLock);
end;

procedure TACMComponent.UnLock;
begin
  LeaveCriticalSection(FLock);
end;

Procedure TACMComponent.FSetNumBuffers (aValue:Byte);

Var
  OldSize:Cardinal;

Begin
  If (FNumBuffers <> aValue) And (aValue >= 2)
    Then
      Begin
        Close;
        OldSize:=FBufSize;
        FFreeBuffers;
        SetLength (FHeaders,aValue);
        FNumBuffers:=aValue;
        FSetBufferSize (OldSize);
      End;
End;

Procedure TACMComponent.FSetFmtChooser (aValue:TACMFormatChooser);

Begin
  If FFmtChooser <> Nil
    Then
      FFmtChooser.FOwner:=Nil;
  FFmtChooser:=aValue;
  If FFMtChooser <> Nil
    Then
      FFmtChooser.FOwner:=Self;
End;

Procedure TACMComponent.Open;

Begin
  If FAutoSize And Not FActive And (FFmtChooser <> Nil)
    Then
      FSetBufferSize (FFmtChooser.nAvgBytesPerSec);
End;

Procedure TACMComponent.FSetActive (aValue:Boolean);

Begin
  If aValue
    Then
      Open
    Else
      Close;
End;

Procedure TACMComponent.FDoOnOpen;

Begin
  If Assigned (FOnOpen)
    Then
      FOnOpen (Self);
  FActive:=True;
End;

Procedure TACMComponent.FDoOnClose;

Begin
  If Assigned (FOnClose)
    Then
      FOnClose (Self);
  FActive:=False;
End;

Procedure TACMComponent.FCheck(ErrorMsg:String;Result:Cardinal);

Begin
  If Result <> 0
    Then
      Raise Exception.Create(Format ('%s: error number %u.',[ErrorMsg,Result]));
End;

Procedure TACMComponent.FSetBufferSize(aValue:Cardinal);

Var
  C:Integer;

Begin
  If (FBufSize <> aValue) And (Length(FHeaders)>0)
    Then
      Try
        Close;
        For C:=Low (FHEaders) to High (FHeaders)
          Do
            Begin
              FHeaders[C].dwFlags:=WHDR_DONE;
              FHeaders[C].dwUser:=0;
              If FBufSize <> 0
                Then
                  FreeMem (FHeaders[C].lpData,FBufSize);
              If aValue <> 0
                Then
                  GetMem (FHeaders[C].lpData,aValue);
            End;
        FBufSize := aValue;
       Except
        FSetBufferSize(0);
        Raise;
      End;
End;

Procedure TACMComponent.FFreeBuffers;

Begin
  FSetBufferSize (0);
end;

Procedure TACMOut.Open;
var
  Ret: MMRESULT;
begin
  Inherited;
  If Not FActive
    Then
      If (FFmtChooser <> Nil) And FFmtChooser.IsValid
        Then begin
          Ret:=WaveOutOpen(nil, FDeviceID, FFmtChooser.WaveFormatEx, 0, 0, WAVE_FORMAT_QUERY or WAVE_MAPPED);
          if Ret=0 then
            Ret:=WaveOutOpen (@FHandle,FDeviceID,FFmtChooser.WaveFormatEx,DWORD(@WaveOutProc),DWORD(Self),CALLBACK_FUNCTION or WAVE_MAPPED);

          FCheck('Cannot open wave out device',Ret);
        end;
end;

Procedure TACMOut.PlayBack( S:TStream );

Var
  C:Integer;
  StepSize:DWORD;

Begin
  If FActive
    Then
      Begin
        S.Seek(0,0);
        While S.Position+1 < S.Size
          Do
            Begin
              C:=Low (FHeaders);
              While (FHeaders[C].dwUser = 1) And (C <= High (FHeaders))
                Do
                  Inc (C);
              If C <= High (FHeaders)
                Then
                  Begin
                    StepSize:=Min(FBufSize,S.Size-S.Position+1);
                    S.Read(FHeaders[C].lpData^,StepSize);
                    FHeaders[C].dwBufferLength:=StepSize;
                    FHeaders[C].dwBytesRecorded:=StepSize;
                    FHeaders[C].dwUser:=1;
                    FHeaders[C].dwFlags:=0;
                    FHeaders[C].dwLoops:=0;
                    FCheck ('Cannot prepare header',WaveOutPrepareHeader (FHandle,@FHeaders[C],SizeOf(FHeaders[C])));
                    FCheck ('Cannot output header',WaveOutWrite(FHandle,@FHeaders[C],SizeOf(FHeaders[C])));
                  End;
            End;
      End;
End;

Procedure TACMOut.PlayBack( Data:Pointer; Size:DWORD);

Var
  C:Integer;
  StepSize:DWORD;

Begin
  If FActive
    Then
      While Size > 0
        Do
          Begin
            C:=Low(FHeaders);
            While (FHeaders[C].dwUser = 1) And (C <= High (FHeaders))
              Do
                Inc(C);
            If C <= High (FHeaders)
              Then
                Begin
                  StepSize:=Min(FBufSize,Size);
                  Move (Data^,FHeaders[C].lpData^,StepSize);
                  Size:=Size-StepSize;
                  Data:=Pointer(DWORD(Data)+StepSize);
                  FHeaders[C].dwBufferLength:=StepSize;
                  FHeaders[C].dwBytesRecorded:=StepSize;
                  FHeaders[C].dwUser:=1;
                  FHeaders[C].dwFlags:=0;
                  FHeaders[C].dwLoops:=0;
                  FCheck ('Cannot prepare header',WaveOutPrepareHeader (FHandle,@FHeaders[C],SizeOf(FHeaders[C])));
                  FCheck ('Cannot output header',WaveOutWrite(FHandle,@FHeaders[C],SizeOf(FHeaders[C])));
                End;
         End;
End;

Procedure TACMOut.FDoOnCallBack(aHeader:PWaveHdr);

begin
  If FActive
    Then
      Begin
        If Assigned (FOnData)
          Then
            FOnData (Self,aHeader.lpData,aHeader.dwBufferLength);
        If (aHeader.dwFlags And WHDR_DONE) <> 0
          Then
            Begin
              FCheck ('Cannot unprepare header',WaveOutUnprepareHeader(FHandle,aHeader,sizeof(TWaveHdr)));
              aHeader.dwUser := 0;
            End;
      End;
end;

Procedure TACMOut.Close;

Begin
  Inherited;
  If FActive
    Then
      Begin
        Lock;
        try
          WaveOutReset (FHandle);
          WaveOutClose (FHandle);
        finally
          UnLock;
        end;
      End;
end;

Procedure TACMIn.Open;

Var
  C:Integer;
  Ret: MMRESULT;
Begin
  Inherited;
  If Not FActive
    Then
      If (FFmtChooser <> Nil) And FFmtChooser.IsValid
        Then
          Begin
            FClosing:=False;
            Ret:=WaveInOpen(nil,FDeviceID,FFmtChooser.WaveFormatEx,0,0,WAVE_FORMAT_QUERY or WAVE_MAPPED);
            if Ret=0 then
              Ret:=WaveInOpen (@FHandle,FDeviceID,FFmtChooser.WaveFormatEx,DWORD(@WaveInProc),DWORD(Self),CALLBACK_FUNCTION or WAVE_MAPPED);
            FCheck ('Cannot open wave in device',Ret);
            For C:=0 To FNumBuffers-1
              Do
                FPrepareHeader(@FHeaders[C]);
            FCheck ('Cannot start recording',WaveInStart (FHandle));
          End;
End;

Procedure TACMIn.Close;

Begin
  Inherited;
  If FActive
    Then
      Begin
        Lock;
        try
          FClosing:=True;
          waveInStop(FHandle);
          WaveInReset (FHandle);
          WaveInClose (FHandle);
        finally
          UnLock;
        end;
      End;
End;

Procedure TACMIn.FDoOnCallBack(aHeader:PWaveHdr);

Begin
  If FActive And Not FClosing
    Then
      Begin
        If Assigned (FOnData)
          Then
            FOnData (Self,aHeader.lpData,aHeader.dwBytesRecorded);
        FCheck ('Cannont unprepare header',WaveInUnprepareHeader(FHandle,aHeader,SizeOf (TWaveHdr)));
        FPrepareHeader(aHeader);
      End;
End;

Procedure TACMIn.FPrepareHeader (aHeader:PWaveHdr);

Begin
  aHeader.dwBufferLength:=FBufSize;
  aHeader.dwFlags:=0;
  FCheck ('Cannot prepare header',WaveInPrepareHeader (FHandle,aHeader,SizeOf(aHeader^)));
  FCheck ('Cannot add header',WaveInAddBuffer (FHandle,aHeader,SizeOf (aHeader^)));
End;

Constructor TACMFormatChooser.Create(aOwner:TComponent);

Begin
  Inherited;
  FFmtSize:=0;
  FFmt:=Nil;
  FInitDefaultFormat;
  FOwner:=Nil;
End;

Destructor TACMFormatChooser.Destroy;

Begin
  FFreeFC;
  If FOwner <> Nil
    Then
      Begin
        FOwner.WaveFormatChooser:=Nil;
        FOwner:=Nil;
      End;
  Inherited;
End;

Procedure TACMFormatChooser.FCheck(ErrorMsg:String;Result:Boolean);

Begin
  If Result
    Then
      Raise Exception.Create(Format ('%s: error number %u.',[ErrorMsg,Result]));
End;


Procedure TACMFormatChooser.FInitDefaultFormat;

Begin
  acmMetrics(0, ACM_METRIC_MAX_SIZE_FORMAT, FFmtSize);
  If FFmtSize <> 0
    Then
      Begin
        GetMem(FFmt,FFmtSize);
        FFmt.wFormatTag := $31;   //WAVE_FORMAT_GSM610; set default format to GSM6.10
        FFmt.nChannels := 1;     //mono
        FFmt.nSamplesPerSec := 8000;
        FFmt.nAvgBytesPerSec:= 8000; { for buffer estimation }
        FFmt.nBlockAlign:=1;      { block size of data }
        FFmt.wbitspersample := 8;
      End;
End;

Procedure TACMFormatChooser.FFreeFC;

Begin
  If FFMtSize <> 0
    Then
      Begin
        FreeMem (FFmt,FFmtSize);
        FFmt:=Nil;
        FFMTSize:=0;
      End;
End;

Function TACMFormatChooser.IsValid:Boolean;

Begin
  Result:=(FFmtSize <> 0) And (FFmt <> Nil);
End;

Function TACMFormatChooser.FGetwFormatTag:Word;

Begin
  Result:=FFmt.wFormatTag;
End;

Function TACMFormatChooser.FGetnChannels:Word;

Begin
  Result:=FFmt.nChannels;
End;

Function TACMFormatChooser.FGetnSamplesPerSec:DWord;

Begin
  Result:=FFmt.nSamplesPerSec;
End;

Function TACMFormatChooser.FGetnAvgBytesPerSec:DWord;

Begin
  Result:=FFmt.nAvgBytesPerSec;
End;

Function TACMFormatChooser.FGetnBlockAlign:Word;

Begin
  Result:=FFmt.nBlockAlign;
End;

Function TACMFormatChooser.FGetwBitsPerSample:Word;

Begin
  Result:=FFmt.wBitsPerSample;
End;

Function TACMFormatChooser.FGetCbSize:Word;

Begin
  Result:=FFmt.cbSize;
End;

Function TACMFormatChooser.FGetExtraBytes:Pointer;

Begin
  Result:=Pointer(Cardinal(FFmt)+SizeOf (TWaveFormatEx));
End;

Procedure TACMFormatChooser.FSetwFormatTag(aValue:Word);

Begin
  FFmt.wFormatTag:=aValue;
End;

Procedure TACMFormatChooser.FSetnChannels(aValue:Word);

Begin
  FFmt.nChannels:=aValue;
End;

Procedure TACMFormatChooser.FSetnSamplesPerSec(aValue:DWord);

Begin
  FFmt.nSamplesPerSec:=aValue;
End;

Procedure TACMFormatChooser.FSetnAvgBytesPerSec(aValue:DWord);

Begin
  FFmt.nAvgBytesPerSec:=aValue;
End;

Procedure TACMFormatChooser.FSetnBlockAlign(aValue:Word);

Begin
  FFmt.nBlockAlign:=aValue;
End;

Procedure TACMFormatChooser.FSetwBitsPerSample(aValue:Word);

Begin
  FFmt.wBitsPerSample:=aValue;
End;

Procedure TACMFormatChooser.FSetCBSize (aValue:Word);

Begin
  FFmt.CbSize:= aValue;
End;

Procedure TACMFormatChooser.SaveCB(DestCB:Pointer);

Begin
  Move (CB^,DestCB^,FFmt.cbSize);
End;

Procedure TACMFormatChooser.UseCB(SrcCB:Pointer;CBSize:Word);

Begin
  FCheck ('Cannot use the given CB extra bytes, the size is too large for all of the installed codecs',CBSize > (FFmtSize-sizeof (TWaveFormatEx)));
  Move (SrcCB^,FFmt^,CBSize);
End;

Procedure TACMFormatChooser.UseFormat(SrcFmt:PWaveFormatEx;Size:Cardinal);

Begin
  FCheck ('Cannot use the given PWaveFormat, the size is too large for all of the installed codecs',Size > FFmtSize);
 // FFreeFC;
  FillChar(FFmt^,FFmtSize,0);
  Move (SrcFmt^,FFmt^,Size);
End;

Procedure TACMFormatChooser.SaveFormat(DestFmt:PWaveFormatEx);

Begin
  Move (FFmt^,DestFmt^,FFmtSize);
End;

Function TACMDlg.Execute:Boolean;
Begin
  If FFMtSize <> 0
    Then
      Begin
        FC.cbStruct := SizeOf(FC);
        FC.cbWfx    := FFMtSize;
        FC.fdwStyle := ACMFORMATCHOOSE_STYLEF_INITTOWFXSTRUCT;
        FC.pwfx     := FFmt;
        Result:=acmFormatChoose(fc) = MMSYSERR_NOERROR;
      End
    Else
      Result:=False;
end;

procedure Register;
begin
  RegisterComponents('ACMComponents', [TACMOut,TACMIn,TACMFormatChooser,TACMDlg]);
end;

end.