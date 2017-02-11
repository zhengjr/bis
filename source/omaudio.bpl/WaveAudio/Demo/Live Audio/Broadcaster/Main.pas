{------------------------------------------------------------------------------}
{                                                                              }
{  Wave Audio Package - Audio Broadcasting Demo (Server)                       }
{  by Kambiz R. Khojasteh                                                      }
{                                                                              }
{  kambiz@delphiarea.com                                                       }
{  http://www.delphiarea.com                                                   }
{                                                                              }
{------------------------------------------------------------------------------}

unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, mmSystem, WaveUtils, WaveIO, WaveIn, WaveRecorders, Buttons, Contnrs,
  Spin, ComCtrls, ScktComp, WaveStorage, WavePlayers, 
  Acm, ExtCtrls, WaveMixer;

type
  TMainForm = class(TForm)
    gbBroadcasting: TGroupBox;
    lblFormat: TLabel;
    cbFormat: TComboBox;
    btnStop: TButton;
    btnStart: TButton;
    gbConnection: TGroupBox;
    lblClients: TLabel;
    lstClients: TListBox;
    lblLocalAddress: TLabel;
    edLocalAddress: TEdit;
    lblLocalPort: TLabel;
    seLocalPort: TSpinEdit;
    pbLevel: TProgressBar;
    EditFormat: TEdit;
    RadioGroupSource: TRadioGroup;
    LabelBytesSent: TLabel;
    TrackBar1: TTrackBar;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure tcpServerClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure tcpServerClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure tcpServerAccept(Sender: TObject; Socket: TCustomWinSocket);
    procedure tcpServerClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure tcpServerClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TrackBar1Change(Sender: TObject);
  private
    FFormat: PWaveFormatEx;
    FFormatSize: Integer;
    tcpServer: TServerSocket;
    AudioLevel: Integer;
    LiveAudioRecorder: TLiveAudioRecorder;
    LiveAudioPlayer: TLiveAudioPlayer;
    AudioMixer: TAudioMixer;
    MixerLine: TAudioMixerLine;
//    WaveFile: TWaveFile;
    FBytesSent: Integer;
    FBuffer: Pointer;
    FBufferSize: Integer;
    ACMDlg: TACMDlg;
    WaveStream: TWaveConverter;
    MemoryStream: TMemoryStream;
    procedure BuildAudioFormatList;
    procedure LiveAudioRecorderLevel(Sender: TObject; Level: Integer);
    procedure LiveAudioRecorderData(Sender: TObject; const Buffer: Pointer;
      BufferSize: Cardinal; var FreeIt: Boolean);
    procedure LiveAudioRecorderActivate(Sender: TObject);
    procedure LiveAudioRecorderDeactivate(Sender: TObject);
    procedure LiveAudioRecorderFormat(Sender: TObject; var pWaveFormat: PWaveFormatEx; var FreeIt: Boolean);
    procedure SendBuffer(Buffer: Pointer; BufferSize: Cardinal);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses
  WinSock,TypInfo;

{ Helper Functions }

function GetLocalHost: String;
var
  HostName: array[0..512] of AnsiChar;
begin
  if gethostname(HostName, SizeOf(HostName)) = 0 then
    Result := String(StrPas(HostName))
  else
    Result := 'localhost';
end;

function GetLocalIP: String;
var
  HostEntry: PHostEnt;
begin
  {$IFDEF UNICODE}
  HostEntry := gethostbyname(PAnsiChar(AnsiString(GetLocalHost)));
  {$ELSE}
  HostEntry := gethostbyname(PChar(GetLocalHost));
  {$ENDIF}
  if (HostEntry <> nil) and (HostEntry.h_addrtype = AF_INET) then
    Result := String(StrPas(inet_ntoa(PInAddr(HostEntry^.h_addr^)^)))
  else
    Result := '127.0.0.1';
end;

function DNSLookup(const HostName: String): String;
var
  IP: TInAddr;
  HostEntry: PHostEnt;
begin
  Result := HostName;
  {$IFDEF UNICODE}
  HostEntry := gethostbyname(PAnsiChar(AnsiString(HostName)));
  {$ELSE}
  HostEntry := gethostbyname(PChar(HostName));
  {$ENDIF}
  if (HostEntry <> nil) and (HostEntry.h_addrtype = AF_INET) then
  begin
    IP := PInAddr(HostEntry^.h_addr^)^;
    Result := String(StrPas(inet_ntoa(IP)));
  end;
end;

function ReverseDNSLookup(const IPAddress: String): String;
var
  IP: TInAddr;
  HostEntry: PHostEnt;
begin
  Result := IPAddress;
  {$IFDEF UNICODE}
  IP := TInAddr(inet_addr(PAnsiChar(AnsiString(IPAddress))));
  {$ELSE}
  IP := TInAddr(inet_addr(PChar(IPAddress)));
  {$ENDIF}
  if Integer(IP.S_addr) <> Integer(INADDR_NONE) then
  begin
    HostEntry := gethostbyaddr(@IP, 4, AF_INET);
    if HostEntry <> nil then
      Result := String(StrPas(HostEntry^.h_name));
  end;
end;

function FormatAddress(const HostName, IPAddress: String): String;
var
  Name, IP: String;
begin
  if IPAddress = '' then
    IP := DNSLookup(HostName)
  else
    IP := IPAddress;
  if HostName = '' then
    Name := ReverseDNSLookup(IP)
  else
    Name :=  HostName;
  if Name <> IP then
    Result := Format('%s <%s>', [Name, IP])
  else
    Result := Name;
end;

{ TMainForm }

procedure TMainForm.BuildAudioFormatList;
var
  pcm: TPCMFormat;
  WaveFormat: TWaveFormatEx;
begin
  with cbFormat.Items do
  begin
    BeginUpdate;
    try
      Clear;
      // by TSV
      for pcm := Low(TPCMFormat) to High(TPCMFormat) do
//      for pcm := Succ(Low(TPCMFormat)) to High(TPCMFormat) do
      begin
        if pcm=nonePCM then begin
          Add('none PCM');
        end else begin
          SetPCMAudioFormatS(@WaveFormat, pcm);
          Add(GetWaveAudioFormat(@WaveFormat));
        end;
      end;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  DestID,LineID: Integer;
begin
  ACMDlg:=TACMDlg.Create(Self);

  LiveAudioRecorder:=TLiveAudioRecorder.Create(Self);
  LiveAudioRecorder.DeviceID:=0;
  LiveAudioRecorder.Async:=false;
  LiveAudioRecorder.OnActivate:=LiveAudioRecorderActivate;
  LiveAudioRecorder.OnDeactivate:=LiveAudioRecorderDeactivate;
  LiveAudioRecorder.OnPause:=nil;
  LiveAudioRecorder.OnResume:=nil;
  LiveAudioRecorder.OnError:=nil;
  LiveAudioRecorder.OnLevel:=LiveAudioRecorderLevel;
  LiveAudioRecorder.OnFormat:=LiveAudioRecorderFormat;
  LiveAudioRecorder.OnData:=LiveAudioRecorderData;

//  WaveFile:=TWaveFile.Create(ExtractFilePath(Application.ExeName)+'test.wav',fmOpenRead or fmShareDenyRead);

  WaveStream:=TWaveConverter.Create;
  WaveStream.LoadFromFile(ExtractFilePath(Application.ExeName)+'test.wav');
//  WaveStream.ConvertToPCM(Mono8Bit8000Hz);

  MemoryStream:=TMemoryStream.Create;
  MemoryStream.LoadFromFile(ExtractFilePath(Application.ExeName)+'pcma8000.mem');

//  WaveFile.Free;

  LiveAudioRecorder.PCMFormat:=nonePCM;

  LiveAudioPlayer:=TLiveAudioPlayer.Create(Self);
  LiveAudioPlayer.Async:=0;
  LiveAudioPlayer.DeviceID:=0;

  TrackBar1.OnChange:=nil;
  TrackBar1.Enabled:=false;
  MixerLine:=nil;

  AudioMixer:=TAudioMixer.Create(Self);
  AudioMixer.MixerName:=LiveAudioRecorder.DeviceName;
  if AudioMixer.FindMixerLine(cmSrcMicrophone,DestID,LineID) then begin
    AudioMixer.DestinationID:=DestID;
    MixerLine:=AudioMixer.Lines[LineID];
 ///   if (MixerLine.TargetType=tgWaveIn) then begin
      TrackBar1.Enabled:=true;
      TrackBar1.Max:=100;
      TrackBar1.Position:=MixerLine.Volume;
 {   end else
      ShowMessage('Not found wave in');   }
  end else
    ShowMessage('Not found mixer line '+AudioMixer.MixerName);

  if Assigned(MixerLine) then
    Label1.Caption:=AudioMixer.MixerName+' / '+AudioMixer.Master.Name+' / '+GetEnumName(TypeInfo(TMixerLineComponentType),Integer(MixerLine.ComponentType));

  TrackBar1.OnChange:=TrackBar1Change;


  tcpServer := TServerSocket.Create(Self);
  with tcpServer do
  begin
    ServerType := stNonBlocking;
    OnClientConnect := tcpServerClientConnect;
    OnClientDisconnect := tcpServerClientDisconnect;
    OnAccept := tcpServerAccept;
    OnClientRead := tcpServerClientRead;
    OnClientError := tcpServerClientError;
  end;
  BuildAudioFormatList;
  cbFormat.ItemIndex := Ord(LiveAudioRecorder.PCMFormat);
  edLocalAddress.Text := FormatAddress(GetLocalHost, GetLocalIP);

  FFormat:=nil;
  FFormatSize:=0;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  LiveAudioPlayer.Active:=false;
  LiveAudioPlayer.WaitForStop;
  
  LiveAudioRecorder.Active := False;
  LiveAudioRecorder.WaitForStop;

  if Assigned(FFormat) then begin
    FreeMem(FFormat,FFormatSize);
    FFormat:=nil;
    FFormatSize:=0;
  end;

  if Assigned(FBuffer) then begin
    FreeMem(FBuffer,FBufferSize);
    FBuffer:=nil;
    FBufferSize:=0;
  end;

  MemoryStream.Free;
end;

procedure TMainForm.btnStartClick(Sender: TObject);
begin
  edLocalAddress.Text := FormatAddress(GetLocalHost, GetLocalIP);
  tcpServer.Port := seLocalPort.Value;
  EditFormat.Text:='';
  if RadioGroupSource.ItemIndex=0 then begin
    LiveAudioRecorder.PCMFormat := TPCMFormat(cbFormat.ItemIndex);
    if LiveAudioRecorder.PCMFormat = nonePCM then begin
      if ACMDlg.Execute then begin
        LiveAudioRecorder.Active := True;
      end;
    end else begin
      LiveAudioRecorder.Active := True;
    end;
  end else begin
    if ACMDlg.Execute then begin

        with TWaveFileConverter.Create(ExtractFilePath(Application.ExeName)+'pcma8000_.mem',fmCreate) do begin
          try
            BeginRewrite(ACMDlg.WaveFormatEx);
            Write(MemoryStream.Memory^,MemoryStream.Size);
            EndRewrite;
          finally
            Free;
          end;
        end;

      if WaveStream.ConvertTo(ACMDlg.WaveFormatEx) then begin

        WaveStream.SaveToFile(ExtractFilePath(Application.ExeName)+'test_.wav');
        with TFileStream.Create(ExtractFilePath(Application.ExeName)+'test_.mem',fmCreate) do begin
          try
            WaveStream.Stream.Position:=WaveStream.DataOffset;
            CopyFrom(WaveStream.Stream,WaveStream.DataSize);
          finally
            Free;
          end;
        end;

        FFormatSize:=SizeOf(ACMDlg.WaveFormatEx^)+ACMDlg.WaveFormatEx.cbSize;
        GetMem(FFormat,FFormatSize);
        CopyMemory(FFormat,ACMDlg.WaveFormatEx,FFormatSize);

        EditFormat.Text:=GetWaveAudioFormat(ACMDlg.WaveFormatEx);
        EditFormat.Font.Color:=clRed;
      end;
    end;
    btnStop.Visible := True;
    btnStart.Visible := False;
    cbFormat.Enabled := False;
    seLocalPort.Enabled := False;
    tcpServer.Active := True;
  end;
end;

procedure TMainForm.LiveAudioRecorderFormat(Sender: TObject; var pWaveFormat: PWaveFormatEx; var FreeIt: Boolean);
begin
  pWaveFormat:=ACMDlg.WaveFormatEx;

  FFormatSize:=SizeOf(pWaveFormat^)+pWaveFormat.cbSize;
  GetMem(FFormat,FFormatSize);
  CopyMemory(FFormat,pWaveFormat,FFormatSize);

  EditFormat.Text:=GetWaveAudioFormat(pWaveFormat);

  FreeIt:=false;
end;

procedure TMainForm.btnStopClick(Sender: TObject);
begin
  LiveAudioRecorder.Active := False;
end;

procedure TMainForm.LiveAudioRecorderActivate(Sender: TObject);
begin
  btnStop.Visible := True;
  btnStart.Visible := False;
  cbFormat.Enabled := False;
  seLocalPort.Enabled := False;
  tcpServer.Active := True;
end;

procedure TMainForm.LiveAudioRecorderDeactivate(Sender: TObject);
begin
  tcpServer.Active := False;
  btnStart.Visible := True;
  btnStop.Visible := False;
  cbFormat.Enabled := True;
  seLocalPort.Enabled := True;
  lstClients.Items.Clear;
end;

procedure TMainForm.LiveAudioRecorderLevel(Sender: TObject; Level: Integer);
begin
  AudioLevel := Level;
  pbLevel.Position := Level
end;

procedure TMainForm.SendBuffer(Buffer: Pointer; BufferSize: Cardinal);
var
  I: Integer;
begin
  for I := tcpServer.Socket.ActiveConnections - 1 downto 0 do
    with tcpServer.Socket.Connections[I] do
      if Data = Self then // the client is ready
        SendBuf(Buffer^, BufferSize);
end;

procedure TMainForm.LiveAudioRecorderData(Sender: TObject;
  const Buffer: Pointer; BufferSize: Cardinal; var FreeIt: Boolean);
begin
  FreeIt := True;
  SendBuffer(Buffer,BufferSize);
end;

procedure TMainForm.tcpServerClientConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  ClientName: String;
begin
  ClientName := FormatAddress(Socket.RemoteHost, Socket.RemoteAddress);
  lstClients.Items.AddObject(ClientName, Socket);
end;

procedure TMainForm.tcpServerClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
var
  Index: Integer;
begin
  Socket.Data := nil;
  Index := lstClients.Items.IndexOfObject(Socket);
  if Index >= 0 then lstClients.Items.Delete(Index);
end;

procedure TMainForm.tcpServerAccept(Sender: TObject; Socket: TCustomWinSocket);

type
  TWaveFormatInfo = packed record
    WaveFormatSize: Integer;
    WaveFormat: TWaveFormatEx;
    Extra: array[0..511] of byte;
  end;

var
  WFI: TWaveFormatInfo;
  WFISize: Integer;
begin
  if Assigned(FBuffer) then begin
    FreeMem(FBuffer,FBufferSize);
    FBuffer:=nil;
    FBufferSize:=0;
  end;

  if RadioGroupSource.ItemIndex=0 then begin
    if LiveAudioRecorder.PCMFormat=nonePCM then begin
      if Assigned(FFormat) then begin
        WFI.WaveFormatSize:=FFormatSize;
        CopyMemory(@WFI.WaveFormat,FFormat,FFormatSize);
        WFISize:=FFormatSize+SizeOf(WFI.WaveFormatSize);
      end;
    end else begin
{      SetPCMAudioFormatS(@WFI.WaveFormat, LiveAudioRecorder.PCMFormat);
      WFI.WaveFormatSize := SizeOf(WFI.WaveFormat)+WFI.WaveFormat.cbSize;
      WFISize:=SizeOf(WFI);}
    end;
  end else begin
{    if Assigned(FFormat) then begin
      WFI.WaveFormatSize:=FFormatSize;
      WFI.WaveFormat:=FFormat^;
      FBufferSize:=FFormatSize+SizeOf(WFI.WaveFormatSize);
      GetMem(FBuffer,FBufferSize);
      CopyMemory(FBuffer,@WFI.WaveFormat,SizeOf(WFI));
      CopyMemory(Pointer(Integer(FBuffer)+SizeOf(WFI)),Pointer(Integer(FFormat)+SizeOf(WFI.WaveFormat)),FFormat.cbSize);
    end;}
      if Assigned(FFormat) then begin
        ZeroMemory(@WFI,SizeOf(WFI));
        WFI.WaveFormatSize:=FFormatSize;
        CopyMemory(@WFI.WaveFormat,FFormat,FFormatSize);
        WFISize:=FFormatSize+SizeOf(WFI.WaveFormatSize);
      end;
   { SetPCMAudioFormatS(@WFI.WaveFormat, WaveStream.PCMFormat);
    WFI.WaveFormatSize := SizeOf(WFI.WaveFormat)+WFI.WaveFormat.cbSize;
    WFISize:=SizeOf(WFI);}
  end;
//  if Assigned(FBuffer) then begin
    if LiveAudioRecorder.Query(@WFI.WaveFormat) then begin
      Socket.SendBuf(WFI,WFISize);
    end;
//  end;
end;

{$IFDEF UNICODE}
// Delphi 2009 BUG:
// Socket.SendText writes AnsiString but Socket.ReceiveText reads WideString!
// Therefore we have to implement our own ReceiveText
procedure TMainForm.tcpServerClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  Text: AnsiString;
begin
  SetString(Text, nil, Socket.ReceiveLength);
  Socket.ReceiveBuf(PAnsiChar(Text)^, Length(Text));
  if Text = 'READY' then
    Socket.Data := Self;
end;
{$ELSE}
procedure TMainForm.tcpServerClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  I: Integer;
  Buffer: Pointer;
  BufferSize: Integer;
  L,M,D: Integer;
  DS: Integer;
  NewSize: Integer;
begin
  if Socket.ReceiveText = 'READY' then begin
    Socket.Data := Self;

    if RadioGroupSource.ItemIndex<>0 then begin

      FBytesSent:=0;
      if WaveStream.BeginRead then begin
        try
          DS:=WaveStream.DataSize;
          L:=512;
          M:=DS mod L;
          D:=DS div L;
          for i:=0 to D do begin
            Application.ProcessMessages;
            if i=D then
              BufferSize:=M
            else BufferSize:=L;
            GetMem(Buffer,BufferSize);
            try
              FillChar(Buffer^,BufferSize,1);
              NewSize:=WaveStream.Read(Buffer^,BufferSize);
              if WaveStream.Position>0 then begin
                SendBuffer(Buffer,NewSize);
                FBytesSent:=FBytesSent+NewSize;
                LabelBytesSent.Caption:=Format('BytesSent: %d',[FBytesSent]);
                LabelBytesSent.Update;
                Sleep(10);
              end;
            finally
              FreeMem(Buffer,BufferSize)
            end;
          end;
        finally
          WaveStream.EndRead;
        end;
      end;

    end;
  end;

end;
procedure TMainForm.TrackBar1Change(Sender: TObject);
begin
  if Assigned(MixerLine) then
    MixerLine.Volume:=TrackBar1.Position;
end;

{$ENDIF}

procedure TMainForm.tcpServerClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
var
  Index: Integer;
  ErrorStr: String;
begin
  Socket.Data := nil;
  Index := lstClients.Items.IndexOfObject(Socket);
  if Index >= 0 then
  begin
    if ErrorEvent = eeDisconnect then
      lstClients.Items.Delete(Index)
    else
    begin
      case ErrorEvent of
        eeGeneral: ErrorStr := 'General Error';
        eeSend: ErrorStr := 'Send Error';
        eeReceive: ErrorStr := 'Receive Error';
      else
        ErrorStr := 'Error';
      end;
      lstClients.Items.Strings[Index] := Format('%s - %s (%d)',
        [FormatAddress(Socket.RemoteHost, Socket.RemoteAddress), ErrorStr, ErrorCode]);
    end;
  end;
  ErrorCode := 0; // do not raise exception
end;

end.