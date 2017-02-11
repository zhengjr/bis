unit BisCallPhoneFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Contnrs, DB, ZLib, ExtCtrls, ImgList, ActnList, StdActns,
  Tabs, ComCtrls, Buttons, Menus, ActnPopup, MMSystem, SyncObjs,
  WaveUtils, WaveMixer, WaveACMDrivers,
  IdUDPServer, IdGlobal, IdSocketHandle, IdException,
  BisFm, BisEvents, BisCrypter, BisValues, BisThreads, BisLocks, BisDataParams,
  BisRtp, BisRtpAcmDrivers, BisLogger, BisNotifyEvents,
  BisAudioWave,

  BisCallPhoneMessages, 
  BisCallPhoneFrm, BisControls;

type
  TBisCallPhoneChannels=class;

  TBisCallPhoneChannel=class;

  TBisCallPhoneChannelUDPServer=class(TIdUDPServer)
  protected
    function GetBinding: TIdSocketHandle; override;
  end;

  TBisCallPhoneChannelState=(csNothing,csRinning,csProcessing,csHolding,csFinished);

  TBisCallPhoneChannel=class(TObject)
  private
    FChannels: TBisCallPhoneChannels;
    FRequests: TBisCallPhoneRequests;
    FFrame: TBisCallPhoneFrame;
    FServer: TBisCallPhoneChannelUDPServer;
    FTimeoutThread: TBisWaitThread;

    FCallId: Variant;

    FId: String;
    FState: TBisCallPhoneChannelState;
    FProcessExists: Boolean;

    FLocalIP: String;
    FLocalPort: Integer;
    FLocalUseCompressor: Boolean;
    FLocalCompressorLevel: TCompressionLevel;
    FLocalUseCrypter: Boolean;
    FLocalCrypterKey: String;
    FLocalCrypterAlgorithm: TBisCipherAlgorithm;
    FLocalCrypterMode: TBisCipherMode;

    FSequence: Word;
    FTimeStamp: LongWord;
    FSSRCIdentifier: LongWord;

    FRemoteSessionId: Variant;
    FRemoteIP: String;
    FRemotePort: Integer;
    FRemoteUseCompressor: Boolean;
    FRemoteCompressorLevel: TCompressionLevel;
    FRemoteUseCrypter: Boolean;
    FRemoteCrypterKey: String;
    FRemoteCrypterAlgorithm: TBisCipherAlgorithm;
    FRemoteCrypterMode: TBisCipherMode;
    FRemoteDataPort: Integer;

    FRemoteDriverFormat: TWaveAcmDriverFormat;
    FRemotePayloadType: TBisRtpPacketPayloadType;
    FRemoteDataSize: Word;
    FRemotePacketTime: Word;

    FStatus: String;

    procedure LoggerWrite(Message: String; LoggerType: TBisLoggerType);
    procedure TimeoutThreadTimeout(Thread: TBisWaitThread);
    procedure Finish;

    procedure FrameClose(Sender: TObject);
    procedure FrameSelect(Sender: TObject);
    procedure FrameHold(Sender: TObject);
    function FrameGetCallId(Frame: TBisCallPhoneFrame): Variant;

    procedure ServerUDPRead(Sender: TObject; AData: TIdBytes; ABinding: TIdSocketHandle);
    procedure ServerUDPException(Sender: TObject; ABinding: TIdSocketHandle; const AMessage: String; const AExceptionClass: TClass);
    function GetActive: Boolean;
    function DataPort: Integer;

    function CompressString(S: String; Level: TCompressionLevel): String;
    procedure SendData(const Data: Pointer; const DataSize: Cardinal);
    function SendEvent(Event: String): Boolean;

    procedure ServerDisable;
    function TryServerActive: Boolean;

    function GetServerSessionId: Variant;
    function GetRemoteEventParams(SessionId: Variant): Boolean;
    function GetCallInfo(CallIdOrPhone: Variant): Boolean;
    function TransformPhone(Phone: Variant): Variant;
    function ApplyCallResult: Boolean;
    
    function DialRequest(Request: TBisCallPhoneRequest): Boolean;
    function AnswerRequest(Request: TBisCallPhoneRequest): Boolean;
    function HangupRequest(Request: TBisCallPhoneRequest): Boolean;

    function DialResponse(Response: TBisCallPhoneResponse; var FreeChannel: Boolean): Boolean;
    function AnswerResponse(Response: TBisCallPhoneResponse; var FreeChannel: Boolean): Boolean;
    function HangupResponse(Response: TBisCallPhoneResponse; var FreeChannel: Boolean): Boolean;
    function HoldResponse(Response: TBisCallPhoneResponse; var FreeChannel: Boolean): Boolean;
    function UnHoldResponse(Response: TBisCallPhoneResponse; var FreeChannel: Boolean): Boolean;

  public
    constructor Create(AChannels: TBisCallPhoneChannels);
    destructor Destroy; override;

    procedure Close;
    procedure Dial(Acceptor: String; AcceptorType: TBisCallPhoneAcceptorType);
    procedure Answer;
    procedure Hangup;
    procedure Hold;
    procedure UnHold;

    property Active: Boolean read GetActive;
    property Status: String read FStatus;
  end;

  TBisCallPhoneForm=class;

  TBisCallPhoneChannels=class(TObjectList)
  private
    FForm: TBisCallPhoneForm;
    FIP: String;
    FPort: Integer;
    FUseCompressor: Boolean;
    FCompressorLevel: TCompressionLevel;
    FUseCrypter: Boolean;
    FCrypterKey: String;
    FCrypterAlgorithm: TBisCipherAlgorithm;
    FCrypterMode: TBisCipherMode;
    FEventResult: TBisEvent;
    FEventDial: TBisEvent;
    FEventAnswer: TBisEvent;
    FEventHangup: TBisEvent;
    FLastNum: Integer;
    FFreeOnLast: Boolean;
    function ActiveExists(Channel: TBisCallPhoneChannel): Boolean;
    function GetFrameTop(AFrame: TBisCallPhoneFrame): Integer;
    function GetItem(Index: Integer): TBisCallPhoneChannel;
    procedure ReOrderFrames;
    procedure SetFrameProps(Channel: TBisCallPhoneChannel);
    function ResultHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
    function AnswerHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
    function DialHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
    function HangupHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
    function GetNum: Integer;
  public
    constructor Create(Form: TBisCallPhoneForm);
    destructor Destroy; override;
    function CanAdd: Boolean;
    function Add(Id: String; Incoming: Boolean): TBisCallPhoneChannel;
    function AddIncoming(Request: TBisCallPhoneRequest): TBisCallPhoneChannel;
    function AddOutgoing: TBisCallPhoneChannel;
    function Find(Id: String): TBisCallPhoneChannel;
    procedure ExcludeHold(Channel: TBisCallPhoneChannel);
    function Height: Integer;
    procedure Remove(Channel: TBisCallPhoneChannel);
    function CanClose: Boolean;
    function GetCurrent: TBisCallPhoneChannel;
    function ActiveCount: Integer;

    property Items[Index: Integer]: TBisCallPhoneChannel read GetItem; default;

  end;

  TBisCallPhoneFormMusicMode=(mmRing,mmDial);

  TBisCallPhoneForm = class(TBisForm)
    TabSet: TTabSet;
    ImageList: TImageList;
    PanelControl: TPanel;
    PageControl: TPageControl;
    TabSheetPhone: TTabSheet;
    ButtonMicOff: TSpeedButton;
    ButtonBreak: TSpeedButton;
    ButtonSelect: TBitBtn;
    ComboBoxAcceptorType: TComboBox;
    ButtonDial: TBitBtn;
    TabSheetOptions: TTabSheet;
    LabelPlayerDevice: TLabel;
    LabelRecorderDevice: TLabel;
    LabelMaxChannels: TLabel;
    LabelTransparent: TLabel;
    ComboBoxPlayerDevice: TComboBox;
    ComboBoxRecorderDevice: TComboBox;
    TrackBarPlayer: TTrackBar;
    TrackBarRecorder: TTrackBar;
    EditMaxChannels: TEdit;
    UpDownMaxChannels: TUpDown;
    TrackBarTransparent: TTrackBar;
    StatusBar: TStatusBar;
    ComboBoxAcceptor: TComboBox;
    LabelNoChannels: TLabel;
    LabelBuffer: TLabel;
    EditBuffer: TEdit;
    UpDownBuffer: TUpDown;
    EditBufferCount: TEdit;
    UpDownBufferCount: TUpDown;
    CheckBoxAutoAnswer: TCheckBox;
    TimerAutoAnswer: TTimer;
    EditAutoAnswer: TEdit;
    UpDownAutoAnswer: TUpDown;
    procedure TabSetChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
    procedure ButtonSelectClick(Sender: TObject);
    procedure ComboBoxAcceptorTypeChange(Sender: TObject);
    procedure ButtonMicOffClick(Sender: TObject);
    procedure ButtonBreakClick(Sender: TObject);
    procedure TrackBarPlayerChange(Sender: TObject);
    procedure ComboBoxPlayerDeviceChange(Sender: TObject);
    procedure ComboBoxRecorderDeviceChange(Sender: TObject);
    procedure TrackBarRecorderChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TrackBarTransparentChange(Sender: TObject);
    procedure ButtonDialClick(Sender: TObject);
    procedure EditMaxChannelsChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ComboBoxAcceptorChange(Sender: TObject);
    procedure TimerAutoAnswerTimer(Sender: TObject);
    procedure CheckBoxAutoAnswerClick(Sender: TObject);
    procedure ComboBoxAcceptorKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FCurrentChannel: TBisCallPhoneChannel;
    FLastRingChannel: TBisCallPhoneChannel;

    FPhone: String;
    FComputer: String;
    FAccount: String;
    FSession: String;
    FAccountId: Variant;
    FSessionId: Variant;
    FBeforeShowed: Boolean;
    FVoicePlayerLock: TCriticalSection;
    FOldAcceptorType: TBisCallPhoneAcceptorType;
    FDrivers: TBisRtpAcmDrivers;
    FRecorder: TBisAudioLiveRecorder;
    FRecorderMixer: TBisAudioMixer;
    FRecorderMixerLine: TAudioMixerLine;
    FRecorderBufferSize: Cardinal;
    FVoicePlayerStream: TMemoryStream;
    FVoicePlayer: TBisAudioLivePlayer;
    FVoicePlayerBufferSize: Cardinal;
    FMusicPlayer: TBisAudioStockPlayer;
    FPlayerMixerLine: TAudioMixerLine;
    FPlayerMixer: TBisAudioMixer;
    FChannels: TBisCallPhoneChannels;
    FOldPlayerIndex: Integer;
    FOldRecorderIndex: Integer;
    FOldPlayerDeviceCaption: String;
    FOldRecorderDeviceCaption: String;
    FRingStream: TMemoryStream;
    FDialStream: TMemoryStream;
    FResponseTimeout: Cardinal;
    FMicOff: Boolean;
    FSilence: TBytes;
    FAfterLoginEvent: TBisNotifyEvent;

    FSMicEnabled: String;
    FSMicDisabled: String;
    FSBreakEnabled: String;
    FSBreakDisabled: String;

    procedure AfterLogin(Sender: TObject);
    
    function GetAcceptorType: TBisCallPhoneAcceptorType;
    procedure SetAcceptorType(Value: TBisCallPhoneAcceptorType);
    function GetAcceptor: String;
    procedure SetAcceptor(Value: String);
    procedure UpdateMicOffButton;
    procedure UpdateBreakButton;
    procedure UpdateTrackBarPlayer;
    procedure UpdateTrackBarRecorder;
    procedure UpdateHeight;
    procedure UpdateChannel(Channel: TBisCallPhoneChannel);
    procedure ConnectionUpdate(AEnabled: Boolean);
    procedure GetLocalEventParams;

    procedure AudioError(Sender: TObject);
    function VoicePlayerData(Sender: TObject; const Buffer: Pointer; BufferSize: Cardinal; var NumLoops: Cardinal): Cardinal;
    procedure InData(Channel: TBisCallPhoneChannel; const Data: Pointer; const DataSize: Cardinal);
    procedure RecorderFormat(Sender: TObject; var pWaveFormat: PWaveFormatEx; var FreeIt: Boolean);
    procedure RecorderData(Sender: TObject; const Buffer: Pointer; BufferSize: Cardinal; var FreeIt: Boolean);

    procedure VoicePlayerStreamClear;
    procedure RecorderStart(Channel: TBisCallPhoneChannel);
    procedure VoicePlayerStart(Channel: TBisCallPhoneChannel);
    procedure MusicPlayerStart(Mode: TBisCallPhoneFormMusicMode);

    procedure ChannelRing(Channel: TBisCallPhoneChannel);
    procedure ChannelDial(Channel: TBisCallPhoneChannel);
    procedure ChannelProcess(Channel: TBisCallPhoneChannel);
    procedure ChannelFinish(Channel: TBisCallPhoneChannel);
    procedure ChannelActivate(Channel: TBisCallPhoneChannel);
    procedure ChannelDeactivate(Channel: TBisCallPhoneChannel);
  protected
    procedure ReadProfileParams; override;
    procedure WriteProfileParams; override;
    procedure ReadDataParams(DataParams: TBisDataValueParams); override;
    class function GetCallPhoneFrameClass: TBisCallPhoneFrameClass; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure BeforeShow; override;

    function CanSelectAccountPhone: Boolean;
    procedure SelectAccountPhone;
    function CanSelectAccount: Boolean;
    procedure SelectAccount;
    function CanSelectComputer: Boolean;
    procedure SelectComputer;
    function CanSelectSession: Boolean;
    procedure SelectSession;
    function CanDial: Boolean;
    procedure Dial;

    procedure UpdateDialButton;

    property AcceptorType: TBisCallPhoneAcceptorType read GetAcceptorType write SetAcceptorType;
    property Acceptor: String read GetAcceptor write SetAcceptor;

  published
    property SMicEnabled: String read FSMicEnabled write FSMicEnabled;
    property SMicDisabled: String read FSMicDisabled write FSMicDisabled;
    property SBreakEnabled: String read FSBreakEnabled write FSBreakEnabled;
    property SBreakDisabled: String read FSBreakDisabled write FSBreakDisabled;
  end;

  TBisCallPhoneFormIface=class(TBisFormIface)
  private
    FNumber: String;
    function GetCallId: Variant;
    function GetLastForm: TBisCallPhoneForm;
    function GetPhone: String;
  protected
    function CreateForm: TBisForm; override;
    function CanChangeShowType: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Dial(Number: String);

    property CallId: Variant read GetCallId;
    property Phone: String read GetPhone;
    property LastForm: TBisCallPhoneForm read GetLastForm;
  end;

var
  BisCallPhoneForm: TBisCallPhoneForm;

implementation

uses Math,
     IdUDPClient,
     WaveIO,
     BisCore, BisProvider, BisUtils, BisDialogs, BisConfig, BisIfaces, BisDataFm,
     BisParamEditDataSelect, BisDataSet, BisParam, BisFilterGroups,
     BisNetUtils, BisConnectionUtils, BisCryptUtils,
     BisAudioFormatFm,
     BisDesignDataAccountsFm, BisDesignDataRolesAndAccountsFm, BisDesignDataSessionsFm,
     BisCallConsts;

{$R *.dfm}

function GetEventParams(SessionId: Variant;
                        var IP: String; var Port: Integer;
                        var UseCompressor: Boolean; var CompressorLevel: TCompressionLevel;
                        var UseCrypter: Boolean; var CrypterKey: String;
                        var CrypterAlgorithm: TBisCipherAlgorithm; var CrypterMode: TBisCipherMode): Boolean;
var
  P: TBisProvider;
begin
  Result:=false;
  if not Result then begin
    P:=TBisProvider.Create(nil);
    try
      P.UseShowError:=false;
      P.UseWaitCursor:=false;
      P.ProviderName:='GET_EVENT_PARAMS';
      with P.Params do begin
        AddInvisible('SESSION_ID').Value:=SessionId;
        AddInvisible('IP',ptOutput);
        AddInvisible('PORT',ptOutput);
        AddInvisible('USE_CRYPTER',ptOutput);
        AddInvisible('CRYPTER_KEY',ptOutput);
        AddInvisible('CRYPTER_ALGORITHM',ptOutput);
        AddInvisible('CRYPTER_MODE',ptOutput);
        AddInvisible('USE_COMPRESSOR',ptOutput);
        AddInvisible('COMPRESSOR_LEVEL',ptOutput);
      end;
      P.Execute;
      if P.Success then begin
        IP:=P.ParamByName('IP').AsString;
        Port:=P.ParamByName('PORT').AsInteger;
        UseCrypter:=Boolean(P.ParamByName('USE_CRYPTER').AsInteger);
        CrypterKey:=P.ParamByName('CRYPTER_KEY').AsString;
        CrypterAlgorithm:=TBisCipherAlgorithm(P.ParamByName('CRYPTER_ALGORITHM').AsInteger);
        CrypterMode:=TBisCipherMode(P.ParamByName('CRYPTER_MODE').AsInteger);
        UseCompressor:=Boolean(P.ParamByName('USE_COMPRESSOR').AsInteger);
        CompressorLevel:=TCompressionLevel(P.ParamByName('COMPRESSOR_LEVEL').AsInteger);
        Result:=Trim(IP)<>'';
      end;
    finally
      P.Free;
    end;
  end;
end;


{ TBisCallPhoneFormIface }

constructor TBisCallPhoneFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallPhoneForm;
  Permissions.Enabled:=true;
  OnlyOneForm:=true;
  ShowType:=stDefault;
  FNumber:='';
end;

function TBisCallPhoneFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(LastForm) then begin
    if FNumber<>'' then begin
      with LastForm do begin
        SetAcceptorType(atPhone);
        SetAcceptor(FNumber);
      end;
      FNumber:='';
    end;
  end;
end;

function TBisCallPhoneFormIface.CanChangeShowType: Boolean;
begin
  Result:=false;
end;

function TBisCallPhoneFormIface.GetLastForm: TBisCallPhoneForm;
begin
  Result:=TBisCallPhoneForm(inherited LastForm);
end;

procedure TBisCallPhoneFormIface.Dial(Number: String);
var
  Last: TBisCallPhoneForm;
begin
  Last:=LastForm;
  if not Assigned(Last) then begin
    FNumber:=Trim(Number);
    Show;
  end else begin
    Last.SetAcceptorType(atPhone);
    Last.SetAcceptor(Number);
    Last.Dial;
  end;
end;

function TBisCallPhoneFormIface.GetCallId: Variant;
var
  Last: TBisCallPhoneForm;
  Channel: TBisCallPhoneChannel;
begin
  Result:=Null;
  Last:=LastForm;
  if Assigned(Last) then begin
    Channel:=Last.FChannels.GetCurrent;
    if Assigned(Channel) then
      Result:=Channel.FCallId;
  end;
end;

function TBisCallPhoneFormIface.GetPhone: String;
var
  Last: TBisCallPhoneForm;
  Channel: TBisCallPhoneChannel;
begin
  Result:='';
  Last:=LastForm;
  if Assigned(Last) then begin
    Channel:=Last.FChannels.GetCurrent;
    if Assigned(Channel) and Assigned(Channel.FFrame) then
      Result:=Channel.FFrame.LabelName.Caption;
  end;
end;

{ TBisCallPhoneChannelUDPServer }

function TBisCallPhoneChannelUDPServer.GetBinding: TIdSocketHandle;
begin
  Result:=inherited GetBinding;
  if Assigned(FListenerThread) then begin
    FListenerThread.Priority:=tpHighest;
  end;
end;

type
  TBisCallPhoneResponseTimeoutThread=class(TBisWaitThread)
  end;

{ TBisCallPhoneChannel }

constructor TBisCallPhoneChannel.Create(AChannels: TBisCallPhoneChannels);
begin
  inherited Create;
  FChannels:=AChannels;

  FFrame:=FChannels.FForm.GetCallPhoneFrameClass.Create(nil);
  FFrame.OnClose:=FrameClose;
  FFrame.OnSelect:=FrameSelect;
  FFrame.OnHold:=FrameHold;
  FFrame.OnGetCallId:=FrameGetCallId;

  FRequests:=TBisCallPhoneRequests.Create;

  FServer:=TBisCallPhoneChannelUDPServer.Create(nil);
  FServer.ThreadedEvent:=true;
  FServer.ThreadName:='CallPhoneChannelIn';
  FServer.OnUDPRead:=ServerUDPRead;
  FServer.OnUDPException:=ServerUDPException;

  FCallId:=Null;

  FTimeoutThread:=TBisCallPhoneResponseTimeoutThread.Create;
  FTimeoutThread.Timeout:=AChannels.FForm.FResponseTimeout;
  FTimeoutThread.OnTimeout:=TimeoutThreadTimeout;
  FTimeoutThread.RestrictByZero:=true;
  FTimeoutThread.StopOnDestroy:=true;

  Randomize;
  FSequence:=Random(MaxByte);
  FSSRCIdentifier:=Random(MaxInt);

end;

destructor TBisCallPhoneChannel.Destroy;
begin
  FTimeoutThread.Free;
  FServer.OnUDPRead:=nil;
  FServer.Free;
  FRequests.Free;
  FFrame.Free;
  FChannels:=nil;
  inherited Destroy;
end;

procedure TBisCallPhoneChannel.LoggerWrite(Message: String; LoggerType: TBisLoggerType);
begin
  if Assigned(FChannels) and Assigned(FChannels.FForm) then
    FChannels.FForm.LoggerWrite(Message,LoggerType);
end;

procedure TBisCallPhoneChannel.Finish;
begin
  if FState<>csFinished then begin
    FState:=csFinished;
    FFrame.Disable;
    FFrame.Finished:=true;
    FChannels.FForm.ChannelFinish(Self);
    ServerDisable;
  end;
end;

procedure TBisCallPhoneChannel.TimeoutThreadTimeout(Thread: TBisWaitThread);
begin
  if FState<>csFinished then
    Thread.Synchronize(Finish);
end;

procedure TBisCallPhoneChannel.FrameSelect(Sender: TObject);
begin
  if Assigned(FChannels) then begin
    FChannels.ExcludeHold(Self);
    case FState of
      csNothing: ;
      csRinning: begin
        if FFrame.Incoming then
          Answer;
      end;
      csProcessing: ;
      csHolding: Unhold;
      csFinished: ;
    end;
  end;
end;

procedure TBisCallPhoneChannel.FrameClose(Sender: TObject);
begin
  if Assigned(FChannels) then begin
    case FState of
      csNothing: FChannels.Remove(Self);
      csRinning,csProcessing,csHolding: Hangup;
      csFinished: begin
        if ApplyCallResult then
          FChannels.Remove(Self);
      end;
    end;
  end;
end;

procedure TBisCallPhoneChannel.FrameHold(Sender: TObject);
begin
  if Assigned(FChannels) then begin
    case FState of
      csNothing: ;
      csRinning: ;
      csProcessing: Hold;
      csHolding: ;
      csFinished: ;
    end;
  end;
end;

function TBisCallPhoneChannel.GetActive: Boolean;
begin
  Result:=FServer.Active and (FServer.Bindings.Count=1) and Assigned(FFrame);
end;

function TBisCallPhoneChannel.FrameGetCallId(Frame: TBisCallPhoneFrame): Variant;
begin
  Result:=FCallId;
end;

procedure TBisCallPhoneChannel.ServerUDPException(Sender: TObject; ABinding: TIdSocketHandle; const AMessage: String;
                                                  const AExceptionClass: TClass);
begin
  LoggerWrite(AMessage,ltError);
end;

procedure TBisCallPhoneChannel.ServerUDPRead(Sender: TObject; AData: TIdBytes; ABinding: TIdSocketHandle);
var
  Packet: TBisRtpPacket;
begin
  if (Length(AData)>0) and (FState in [csProcessing]) and
     Assigned(FChannels) and Assigned(FChannels.FForm) then begin
    try
      Packet:=TBisRtpPacket.Create;
      try
        Packet.Parse(AData);
        if (Packet.Version=vSecond) and
           (Packet.PayloadType=FRemotePayloadType) then begin

          if FLocalUseCrypter then
            Packet.Payload:=CrypterDecodeBytes(FLocalCrypterKey,Packet.Payload,
                                               FLocalCrypterAlgorithm,FLocalCrypterMode);

          if (Length(Packet.Payload)=FRemoteDataSize) then begin
            FChannels.FForm.InData(Self,Packet.Payload,FRemoteDataSize);
          end;
        end;
      finally
        Packet.Free;
      end;
    except
      On E: Exception do
        LoggerWrite(E.Message,ltError);
    end;
  end;
end;

function TBisCallPhoneChannel.DataPort: Integer;
begin
  Result:=0;
  if FServer.Bindings.Count>0 then
    Result:=FServer.Bindings[0].Port;
end;

procedure TBisCallPhoneChannel.Close;
begin
  if (FState in [csHolding,csProcessing,csFinished]) and
     (Assigned(FFrame) and FFrame.Incoming and not FFrame.Flashing) then begin
    if FFrame.QueryCallResultId then begin
      if FState=csFinished then
        ApplyCallResult
      else
        Hangup;
    end;
  end else
    Hangup;
end;

function TBisCallPhoneChannel.CompressString(S: String; Level: TCompressionLevel): String;
var
  Zip: TCompressionStream;
  TempStream: TMemoryStream;
begin
  TempStream:=TMemoryStream.Create;
  try
    Zip:=TCompressionStream.Create(Level,TempStream);
    try
      Zip.Write(Pointer(S)^,Length(S));
    finally
      Zip.Free;
    end;
    TempStream.Position:=0;
    SetLength(Result,TempStream.Size);
    TempStream.Read(Pointer(Result)^,Length(Result))
  finally
    TempStream.Free;
  end;
end;

procedure TBisCallPhoneChannel.SendData(const Data: Pointer; const DataSize: Cardinal);
var
  S: String;
  Packet: TBisRtpPacket;
begin
  if (DataSize>0) and (FState in [csProcessing]) then begin
    Packet:=TBisRtpPacket.Create;
    try
      Packet.Version:=vSecond;
      Packet.Padding:=false;
      Packet.Extension:=false;
      Packet.Marker:=false;
      Packet.PayloadType:=FRemotePayloadType;
      Packet.Sequence:=FSequence;
      Packet.TimeStamp:=FTimeStamp;
      Packet.SSRCIdentifier:=FSSRCIdentifier;
      Packet.ExternalHeader:=ToBytes('');

      SetLength(S,DataSize);
      Move(Data^,Pointer(S)^,DataSize);

      if FRemoteUseCrypter then
        S:=CrypterEncodeString(FRemoteCrypterKey,S,
                               FRemoteCrypterAlgorithm,FRemoteCrypterMode);   

      Packet.SetPayload(S);

      if Packet.GetData(S) then begin
        FServer.Send(FRemoteIP,FRemoteDataPort,S);
        Inc(FSequence);
        Inc(FTimeStamp,DataSize);
      end;
    finally
      Packet.Free;
    end;
  end;
end;

function TBisCallPhoneChannel.SendEvent(Event: String): Boolean;
var
  Udp: TIdUDPClient;
  S: String;
begin
  Result:=false;
  if (Event<>'') and Assigned(FChannels) and Assigned(FChannels.FForm) then begin
    Udp:=TIdUDPClient.Create(nil);
    try
      S:=Event;

      LoggerWrite(S,ltInformation);

      if FRemoteUseCompressor then
        S:=CompressString(S,FRemoteCompressorLevel);

      if FRemoteUseCrypter then
        S:=CrypterEncodeString(FRemoteCrypterKey,S,
                               FRemoteCrypterAlgorithm,FRemoteCrypterMode);

      Udp.Host:=FRemoteIP;
      Udp.Port:=FRemotePort;
      Udp.BufferSize:=Length(S);
      Udp.Connect;
      Udp.Send(S);

      Result:=true;
    finally
      Udp.Free;
    end;
  end;
end;

function TBisCallPhoneChannel.GetServerSessionId: Variant;
var
  P: TBisProvider;
begin
  Result:=Null;
  P:=TBisProvider.Create(nil);
  try
    P.UseWaitCursor:=false;
    P.ProviderName:='GET_CALL_SERVER_SESSION_ID';
    P.Params.AddInvisible('SERVER_SESSION_ID',ptOutput);
    P.Execute;
    if P.Success then
      Result:=P.ParamByName('SERVER_SESSION_ID').Value;
  finally
    P.Free;
  end;
end;

function TBisCallPhoneChannel.GetRemoteEventParams(SessionId: Variant): Boolean;
begin
  Result:=GetEventParams(SessionId,
                         FRemoteIP,FRemotePort,FRemoteUseCompressor,FRemoteCompressorLevel,
                         FRemoteUseCrypter,FRemoteCrypterKey,FRemoteCrypterAlgorithm,FRemoteCrypterMode);
end;

function TBisCallPhoneChannel.GetCallInfo(CallIdOrPhone: Variant): Boolean;
var
  P: TBisProvider;
begin
  Result:=false;
  if not VarIsNull(CallIdOrPhone) then begin
    P:=TBisProvider.Create(nil);
    try
      P.UseWaitCursor:=false;
      P.ProviderName:='GET_CALL_INFO';
      with P.Params do begin
        AddInvisible('CALL_INFO').Value:=CallIdOrPhone;
        AddInvisible('CALL_REAL_NAME',ptOutput);
        AddInvisible('CALL_NAME',ptOutput);
        AddInvisible('CALL_GROUP',ptOutput);
        AddInvisible('CALL_DESCRIPTION',ptOutput);
        AddInvisible('CALL_NAME_DESCRIPTION',ptOutput);
        AddInvisible('CALL_LINE_NAME',ptOutput);
      end;
      P.Execute;
      if P.Success then begin
        FFrame.CallRealName:=P.ParamByName('CALL_REAL_NAME').AsString;
        FFrame.CallName:=P.ParamByName('CALL_NAME').AsString;
        FFrame.CallGroup:=P.ParamByName('CALL_GROUP').AsString;
        FFrame.CallDescription:=P.ParamByName('CALL_DESCRIPTION').AsString;
        FFrame.CallNameDescription:=P.ParamByName('CALL_NAME_DESCRIPTION').AsString;
        FFrame.CallLineName:=P.ParamByName('CALL_LINE_NAME').AsString;
        Result:=true;
      end;
    finally
      P.Free;
    end;
  end;
end;

function TBisCallPhoneChannel.TransformPhone(Phone: Variant): Variant;
var
  P: TBisProvider;
begin
  Result:=Phone;
  P:=TBisProvider.Create(nil);
  try
    P.UseWaitCursor:=false;
    P.ProviderName:='TRANSFORM_PHONE';
    with P.Params do begin
      AddInvisible('IN_PHONE').Value:=Phone;
      AddInvisible('OUT_PHONE',ptOutput);
    end;
    P.Execute;
    if P.Success then
      Result:=P.ParamByName('OUT_PHONE').Value;
  finally
    P.Free;
  end;
end;

function TBisCallPhoneChannel.ApplyCallResult: Boolean;
var
  P: TBisProvider;
begin
  Result:=true;
  if not VarIsNull(FCallId) and
     (Assigned(FFrame) and FFrame.CallResultQueried) and
     (FFrame.Incoming) and (FState=csFinished) then begin
    Result:=false; 
    P:=TBisProvider.Create(nil);
    try
      P.UseWaitCursor:=false;
      P.UseShowError:=false;
      P.ProviderName:='APPLY_CALL_RESULT';
      with P.Params do begin
        AddInvisible('CALL_ID').Value:=FCallId;
        AddInvisible('CALL_RESULT_ID').Value:=FFrame.CallResultId;
      end;
      try
        P.Execute;
        if P.Success then begin
          FCallId:=Null;
          Result:=true;
        end;
      except
        On E: Exception do
          LoggerWrite(E.Message,ltError);
      end;
    finally
      P.Free;
    end;
  end;
end;

procedure TBisCallPhoneChannel.ServerDisable;
begin
  if FServer.Active then begin
    FServer.OnUDPRead:=nil;
    FServer.Active:=false;
    FServer.Bindings.Clear;
  end;
end;

function TBisCallPhoneChannel.TryServerActive: Boolean;

  function SetPort(P: Integer): Boolean;
  var
    B: TIdSocketHandle;
  begin
    Result:=false;
    if not UDPPortExists(FLocalIP,P) then begin
      try
        B:=FServer.Bindings.Add;
        B.IP:=FLocalIP;
        B.Port:=P;
        FServer.Active:=true;
        Result:=FServer.Active;
        if Result then
          FServer.OnUDPRead:=ServerUDPRead;
      except
        FServer.Active:=false;
        FServer.OnUDPRead:=nil;
      end;
    end;
  end;

var
  First: Integer;
  MaxPort: Integer;
begin
  Result:=false;
  ServerDisable;
  if not Active then begin
    First:=FLocalPort;
    Inc(First);
    MaxPort:=POWER_2;
    while First<MaxPort do begin
      Result:=SetPort(First);
      if not Result then
        Inc(First)
      else begin
        break;
      end;
    end;
  end;
end;

function TBisCallPhoneChannel.DialRequest(Request: TBisCallPhoneRequest): Boolean;

  procedure SendResponse(AMessage: String; AResponseType: TBisCallPhoneResponseType);
  var
    Response: TBisCallPhoneResponse;
  begin
    Response:=TBisCallPhoneResponse.Create(mdOutgoing,SEventResult);
    with Response do begin
      AddSessionId(FRemoteSessionId);
      AddRemoteSessionId(Core.SessionId);
      AddChannelId(FId);
      AddRequestName(Request.Name);
      AddSequence(Request.Sequence);
      AddResponseType(AResponseType);
      AddMessage(AMessage);
    end;
    Request.Responses.Add(Response);
    SendEvent(Response.AsString);
  end;

var
  Message: String;
  ResponseType: TBisCallPhoneResponseType;
begin
  Result:=false;
  if Assigned(Request) and Assigned(Core) then begin
    Message:='';
    ResponseType:=rtUnknown;
    try
      try
        FRemoteSessionId:=Request.RemoteSessionId;
        FRemoteDataPort:=Request.DataPort;
        FRemoteDriverFormat:=FChannels.FForm.FDrivers.FindFormat('',Request.FormatTag,Request.Channels,
                                                                 Request.SamplesPerSec,Request.BitsPerSample);
        FRemotePayloadType:=FChannels.FForm.FDrivers.FormatToPayloadType(FRemoteDriverFormat);
        FRemoteDataSize:=Request.DataSize;
        FRemotePacketTime:=Request.PacketTime;

        if GetRemoteEventParams(FRemoteSessionId) and Assigned(FRemoteDriverFormat) then begin

          ResponseType:=rtBusy;
          if FChannels.CanAdd then begin
            Result:=GetCallInfo(Request.CallId);
            if Result then begin
              FState:=csRinning;
              FFrame.Flashing:=true;
              FChannels.SetFrameProps(Self);
              FChannels.FForm.ChannelRing(Self);
              ResponseType:=rtOK;
            end;
          end;
        end;
      except
        On E: Exception do begin
          Message:=E.Message;
          ResponseType:=rtError;
        end;
      end;
    finally
      SendResponse(Message,ResponseType);
    end;
  end;
end;

function TBisCallPhoneChannel.AnswerRequest(Request: TBisCallPhoneRequest): Boolean;

  procedure SendResponse(AMessage: String; AResponseType: TBisCallPhoneResponseType);
  var
    Response: TBisCallPhoneResponse;
  begin
    Response:=TBisCallPhoneResponse.Create(mdOutgoing,SEventResult);
    with Response do begin
      AddSessionId(FRemoteSessionId);
      AddChannelId(FId);
      AddRequestName(Request.Name);
      AddSequence(Request.Sequence);
      AddResponseType(AResponseType);
      AddMessage(AMessage);
    end;
    Request.Responses.Add(Response);
    SendEvent(Response.AsString);
  end;

var
  Message: String;
  ResponseType: TBisCallPhoneResponseType;
begin
  Result:=false;
  if Assigned(Request) and Assigned(FChannels) then begin
    Message:='';
    ResponseType:=rtUnknown;
    try
      try
        ResponseType:=rtBusy;

        FRemoteDataPort:=Request.DataPort;
        FRemoteDriverFormat:=FChannels.FForm.FDrivers.FindFormat('',Request.FormatTag,Request.Channels,
                                                                 Request.SamplesPerSec,Request.BitsPerSample);
        FRemotePayloadType:=FChannels.FForm.FDrivers.FormatToPayloadType(FRemoteDriverFormat);
        FRemoteDataSize:=Request.DataSize;
        FRemotePacketTime:=Request.PacketTime;

        if Assigned(FRemoteDriverFormat) then begin

          FState:=csProcessing;
          FChannels.ExcludeHold(Self);
          FProcessExists:=true;
          FFrame.StartTime:=Now;
          FFrame.TimerTime.Enabled:=true;
          FFrame.Active:=true;
          FChannels.FForm.ChannelProcess(Self);
          ResponseType:=rtOK;
        end;
        Result:=true;
      except
        On E: Exception do begin
          Message:=E.Message;
          ResponseType:=rtError;
        end;
      end;
    finally
      SendResponse(Message,ResponseType);
    end;
  end;
end;

function TBisCallPhoneChannel.HangupRequest(Request: TBisCallPhoneRequest): Boolean;

  procedure SendResponse(AMessage: String; AResponseType: TBisCallPhoneResponseType);
  var
    Response: TBisCallPhoneResponse;
  begin
    Response:=TBisCallPhoneResponse.Create(mdOutgoing,SEventResult);
    with Response do begin
      AddSessionId(FRemoteSessionId);
      AddChannelId(FId);
      AddRequestName(Request.Name);
      AddSequence(Request.Sequence);
      AddResponseType(AResponseType);
      AddMessage(AMessage);
    end;
    Request.Responses.Add(Response);
    SendEvent(Response.AsString);
  end;

var
  Message: String;
  ResponseType: TBisCallPhoneResponseType;
begin
  Result:=false;
  if Assigned(Request) and Assigned(FChannels) and Assigned(Core) then begin
    Message:='';
    ResponseType:=rtUnknown;
    try
      try
        Finish;
        ResponseType:=rtOK;
        Result:=true;
      except
        On E: Exception do begin
          Message:=E.Message;
          ResponseType:=rtError;
        end;
      end;
    finally
      SendResponse(Message,ResponseType);
    end;
  end;
end;

function TBisCallPhoneChannel.DialResponse(Response: TBisCallPhoneResponse; var FreeChannel: Boolean): Boolean;
begin
  Result:=false;
  if Assigned(Response) and Assigned(FChannels) and (FState=csNothing) then begin
    case Response.ResponseType of
      rtUnknown: ;
      rtOK: begin
        FState:=csRinning;
        FFrame.Flashing:=true;
        FChannels.FForm.ChannelDial(Self);
        Result:=true;
      end;
      rtBusy: begin
        Finish;
        Result:=true;
      end;
      rtError: ;
    end;
  end;
end;

procedure TBisCallPhoneChannel.Dial(Acceptor: String; AcceptorType: TBisCallPhoneAcceptorType);
var
  Request: TBisCallPhoneRequest;
begin
  if (FState=csNothing) then begin
    FRemoteSessionId:=GetServerSessionId;
    if not VarIsNull(FRemoteSessionId) then begin
      FCallId:=GetUniqueID;
      if GetRemoteEventParams(FRemoteSessionId) and TryServerActive then begin
        Request:=TBisCallPhoneRequest.Create(mdOutgoing,SEventDial);
        with Request do begin
          AddSessionId(FRemoteSessionId);
          AddRemoteSessionId(Core.SessionId);
          AddChannelId(FId);
          AddSequence(FRequests.NextSequence);
          AddDataPort(Self.DataPort);
          AddCallId(FCallId);
          AddCallerId(Core.AccountId);
          AddCallerPhone(Null);
          AddAcceptor(Acceptor);
          AddAcceptorType(AcceptorType);
        end;
        FRequests.Add(Request);
        SendEvent(Request.AsString);
        FTimeoutThread.Start;
      end;
    end else begin
      Finish;
    end;
  end;
end;

function TBisCallPhoneChannel.AnswerResponse(Response: TBisCallPhoneResponse; var FreeChannel: Boolean): Boolean;
begin
  Result:=false;
  if Assigned(Response) and Assigned(FChannels) and (FState=csRinning) then begin
    case Response.ResponseType of
      rtUnknown: ;
      rtOK: begin
        FState:=csProcessing;
        FProcessExists:=true;
        FFrame.StartTime:=Now;
        FFrame.TimerTime.Enabled:=true;
        FFrame.Active:=true;
        FChannels.FForm.ChannelProcess(Self);
        Result:=true;
      end;
      rtBusy: ;
      rtError: ;
    end;
  end;
end;

procedure TBisCallPhoneChannel.Answer;
var
  Request: TBisCallPhoneRequest;
begin
  if (FState=csRinning) and TryServerActive then begin
    Request:=TBisCallPhoneRequest.Create(mdOutgoing,SEventAnswer);
    with Request do begin
      AddSessionId(FRemoteSessionId);
      AddChannelId(FId);
      AddSequence(FRequests.NextSequence);
      AddDataPort(Self.DataPort);
    end;
    FRequests.Add(Request);
    SendEvent(Request.AsString);
    FTimeoutThread.Start;
  end;
end;

function TBisCallPhoneChannel.HangupResponse(Response: TBisCallPhoneResponse; var FreeChannel: Boolean): Boolean;
begin
  Result:=false;
  if Assigned(Response) and Assigned(FChannels) then begin
    case Response.ResponseType of
      rtUnknown: ;
      rtOK: begin
        Finish;
        ApplyCallResult;
        FreeChannel:=true;
        Result:=true;
      end;
      rtBusy: ;
      rtError: ;
    end;
  end;
end;

procedure TBisCallPhoneChannel.Hangup;
var
  Request: TBisCallPhoneRequest;
begin
  if Assigned(FFrame) and (FState in [csRinning,csProcessing,csHolding]) then begin
    Request:=TBisCallPhoneRequest.Create(mdOutgoing,SEventHangup);
    with Request do begin
      AddSessionId(FRemoteSessionId);
      AddChannelId(FId);
      AddSequence(FRequests.NextSequence);
      AddCallResultId(FFrame.CallResultId);
    end;
    FRequests.Add(Request);
    SendEvent(Request.AsString);
    FTimeoutThread.Start;
  end;
end;

function TBisCallPhoneChannel.HoldResponse(Response: TBisCallPhoneResponse; var FreeChannel: Boolean): Boolean;
begin
  Result:=false;
  if Assigned(Response) then begin
    case Response.ResponseType of
      rtUnknown: ;
      rtOK: begin
        FState:=csHolding;
        FFrame.Active:=false;
        FChannels.FForm.ChannelFinish(Self);
        Result:=true;
      end;
      rtBusy: ;
      rtError: ;
    end;
  end;
end;

procedure TBisCallPhoneChannel.Hold;
var
  Request: TBisCallPhoneRequest;
begin
  if FState in [csProcessing] then begin
    Request:=TBisCallPhoneRequest.Create(mdOutgoing,SEventHold);
    with Request do begin
      AddSessionId(FRemoteSessionId);
      AddChannelId(FId);
      AddSequence(FRequests.NextSequence);
    end;
    FRequests.Add(Request);
    SendEvent(Request.AsString);
    FTimeoutThread.Start;
  end;
end;

function TBisCallPhoneChannel.UnHoldResponse(Response: TBisCallPhoneResponse; var FreeChannel: Boolean): Boolean;
begin
  Result:=false;
  if Assigned(Response) then begin
    case Response.ResponseType of
      rtUnknown: ;
      rtOK: begin
        FState:=csProcessing;
        FFrame.Active:=true;
        FChannels.FForm.ChannelProcess(Self);
        Result:=true;
      end;
      rtBusy: ;
      rtError: ;
    end;
  end;
end;

procedure TBisCallPhoneChannel.UnHold;
var
  Request: TBisCallPhoneRequest;
begin
  if FState in [csHolding] then begin
    Request:=TBisCallPhoneRequest.Create(mdOutgoing,SEventUnHold);
    with Request do begin
      AddSessionId(FRemoteSessionId);
      AddChannelId(FId);
      AddSequence(FRequests.NextSequence);
    end;
    FRequests.Add(Request);
    SendEvent(Request.AsString);
    FTimeoutThread.Start;
  end;
end;

{ TBisCallPhoneChannels }

constructor TBisCallPhoneChannels.Create(Form: TBisCallPhoneForm);
begin
  inherited Create;
  FForm:=Form;
  with Core.Events do begin
    FEventResult:=Add(SEventResult,ResultHandler,false);
    FEventDial:=Add(SEventDial,DialHandler,false);
    FEventAnswer:=Add(SEventAnswer,AnswerHandler,false);
    FEventHangup:=Add(SEventHangup,HangupHandler,false);
  end;
end;

destructor TBisCallPhoneChannels.Destroy;
begin
  with Core.Events do begin
    Remove(FEventHangup);
    Remove(FEventAnswer);
    Remove(FEventDial);
    Remove(FEventResult);
  end;
  FForm:=nil;
  inherited Destroy;
end;

function TBisCallPhoneChannels.Find(Id: String): TBisCallPhoneChannel;
var
  i: Integer;
  Item: TBisCallPhoneChannel;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if AnsiSameText(Id,Item.FId) then begin
      Result:=Item;
      exit;
    end;
  end;
end;

function TBisCallPhoneChannels.GetItem(Index: Integer): TBisCallPhoneChannel;
begin
  Result:=TBisCallPhoneChannel(inherited Items[Index]);
end;

function TBisCallPhoneChannels.GetNum: Integer;
begin
  if FLastNum>=99999 then
    FLastNum:=0;
  Inc(FLastNum);
  Result:=FLastNum;
end;

procedure TBisCallPhoneChannels.ExcludeHold(Channel: TBisCallPhoneChannel);
var
  i: Integer;
  Item: TBisCallPhoneChannel;
begin
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if (Item<>Channel) then begin
      Item.Hold;
    end;
  end;
end;

function TBisCallPhoneChannels.ActiveExists(Channel: TBisCallPhoneChannel): Boolean;
var
  i: Integer;
  Item: TBisCallPhoneChannel;
begin
  Result:=false;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if (Item<>Channel) then begin
      if Item.FState=csProcessing then begin
        Result:=true;
        exit;
      end;
    end;
  end;
end;

function TBisCallPhoneChannels.GetCurrent: TBisCallPhoneChannel;
var
  Channel: TBisCallPhoneChannel;
  i: Integer;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Channel:=Items[i];
    if Channel.FState=csProcessing then begin
      Result:=Channel;
      exit;
    end;
  end;
end;

function TBisCallPhoneChannels.GetFrameTop(AFrame: TBisCallPhoneFrame): Integer;
var
  i: Integer;
  Channel: TBisCallPhoneChannel;
begin
  Result:=FForm.ComboBoxAcceptorType.Top+FForm.ComboBoxAcceptorType.Height+10;
  for i:=0 to Count-1 do begin
    Channel:=Items[i];
    if Channel.FFrame=AFrame then
      Break;
    Result:=Result+Channel.FFrame.Height+5;
  end;
end;

procedure TBisCallPhoneChannels.Remove(Channel: TBisCallPhoneChannel);
begin
  FForm.ChannelDeactivate(Channel);
  inherited Remove(Channel);
  if Count=0 then
    FForm.ChannelFinish(nil);
  ReOrderFrames;
  FForm.UpdateDialButton;
  FForm.UpdateHeight;
  FForm.UpdateChannel(nil);
  if FFreeOnLast then
    FForm.Close; 
end;

procedure TBisCallPhoneChannels.ReOrderFrames;
var
  i: Integer;
  Channel: TBisCallPhoneChannel;
begin
  for i:=0 to Count-1 do begin
    Channel:=Items[i];
    Channel.FFrame.Top:=GetFrameTop(Channel.FFrame);
  end;
end;

function TBisCallPhoneChannels.Height: Integer;
var
  i: Integer;
  Channel: TBisCallPhoneChannel;
begin
  Result:=0;
  for i:=0 to Count-1 do begin
    Channel:=Items[i];
    Result:=Result+Channel.FFrame.Height+5;
  end;
end;

procedure TBisCallPhoneChannels.SetFrameProps(Channel: TBisCallPhoneChannel);
begin
  if Assigned(Channel) and Assigned(FForm) then begin
    with Channel do begin
      FFrame.Parent:=FForm.TabSheetPhone;
      FFrame.Num:=GetNum;
      FFrame.Top:=GetFrameTop(FFrame);
      FFrame.Left:=FForm.ComboBoxAcceptorType.Left;
      FFrame.Width:=FForm.TabSheetPhone.ClientWidth-FForm.ComboBoxAcceptorType.Left-5;
      FFrame.AutoHeight;
      FFrame.Anchors:=[akLeft,akTop,akRight];
    end;
    FForm.UpdateDialButton;
    FForm.UpdateHeight;
  end;
end;

function TBisCallPhoneChannels.ActiveCount: Integer;
var
  i: Integer;
  Item: TBisCallPhoneChannel;
begin
  Result:=0;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if Item.FState in [csRinning,csProcessing,csHolding] then
      Inc(Result);
  end;
end;

function TBisCallPhoneChannels.CanAdd: Boolean;
var
  i: Integer;
  Item: TBisCallPhoneChannel;
begin
  Result:=Assigned(FForm) and not FForm.ButtonBreak.Down;
  if Result then begin
    Result:=FForm.UpDownMaxChannels.Position>ActiveCount;
    if Result then begin
      for i:=0 to Count-1 do begin
        Item:=Items[i];
        if Item.FFrame.InQueryCallResultId then begin
          Result:=false;
          exit;
        end;
      end;
    end;
  end;
end;

function TBisCallPhoneChannels.CanClose: Boolean;
var
  i: Integer;
begin
  Result:=not ActiveExists(nil);
  if not FFreeOnLast then begin
    FFreeOnLast:=true;
    for i:=Count-1 downto 0 do begin
      Items[i].Close;
    end;
  end;
end;

function TBisCallPhoneChannels.Add(Id: String; Incoming: Boolean): TBisCallPhoneChannel;
begin
  Result:=Find(Id);
  if not Assigned(Result) then begin
    Result:=TBisCallPhoneChannel.Create(Self);
    Result.FId:=Id;
    Result.FLocalIP:=FIP;
    Result.FLocalPort:=FPort;
    Result.FLocalUseCompressor:=FUseCompressor;
    Result.FLocalCompressorLevel:=FCompressorLevel;
    Result.FLocalUseCrypter:=FUseCrypter;
    Result.FLocalCrypterKey:=FCrypterKey;
    Result.FLocalCrypterAlgorithm:=FCrypterAlgorithm;
    Result.FLocalCrypterMode:=FCrypterMode;
    Result.FFrame.Incoming:=Incoming;
    inherited Add(Result);
  end;
end;

function TBisCallPhoneChannels.AddIncoming(Request: TBisCallPhoneRequest): TBisCallPhoneChannel;
begin
  Result:=nil;
  if Assigned(Request) then begin
    Result:=Add(Request.ChannelId,true);
    if Assigned(Result) then begin
      Result.FCallId:=Request.CallId;
      Result.FRequests.Add(Request);
    end;
  end;
end;

function TBisCallPhoneChannels.AddOutgoing: TBisCallPhoneChannel;
begin
  Result:=Add(GetUniqueID,false);
end;

function TBisCallPhoneChannels.ResultHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
var
  Response: TBisCallPhoneResponse;
  Request: TBisCallPhoneRequest;
  Channel: TBisCallPhoneChannel;
  FreeChannel: Boolean;
begin
  Result:=false;
  Response:=TBisCallPhoneResponse.Create(mdIncoming,Event.Name,InParams);
  if Assigned(Response) then begin
    Channel:=Find(Response.ChannelId);
    if Assigned(Channel) then begin
      Request:=Channel.FRequests.Find(Response);
      if Assigned(Request) then begin
        Channel.FTimeoutThread.Stop;
        Request.Responses.Add(Response);

        FreeChannel:=false;

        if Response.Same(SEventDial) then
          Result:=Channel.DialResponse(Response,FreeChannel);

        if Response.Same(SEventAnswer) then
          Result:=Channel.AnswerResponse(Response,FreeChannel);

        if Response.Same(SEventHangup) then
          Result:=Channel.HangupResponse(Response,FreeChannel);

        if Response.Same(SEventHold) then
          Result:=Channel.HoldResponse(Response,FreeChannel);

        if Response.Same(SEventUnHold) then
          Result:=Channel.UnHoldResponse(Response,FreeChannel);

        if not Result then
          Request.Responses.Remove(Response);

        if FreeChannel then begin
          Remove(Channel);
        end;

      end else
        Response.Free;
    end else
      Response.Free;
  end;
end;

function TBisCallPhoneChannels.DialHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
var
  Request: TBisCallPhoneRequest;
  Channel: TBisCallPhoneChannel;
begin
  Result:=false;
  Request:=TBisCallPhoneRequest.Create(mdIncoming,Event.Name,InParams);
  if Assigned(Request) then begin
    Channel:=Find(Request.ChannelId);
    if not Assigned(Channel) then begin
      Channel:=AddIncoming(Request);
      if Assigned(Channel) then begin
        Result:=Channel.DialRequest(Request);
        if not Result then
          Remove(Channel);
      end else
        Request.Free;
    end else
      Request.Free;
  end;
end;

function TBisCallPhoneChannels.AnswerHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
var
  Request: TBisCallPhoneRequest;
  Channel: TBisCallPhoneChannel;
begin
  Result:=false;
  Request:=TBisCallPhoneRequest.Create(mdIncoming,Event.Name,InParams);
  if Assigned(Request) then begin
    Channel:=Find(Request.ChannelId);
    if Assigned(Channel) then begin
      Channel.FRequests.Add(Request);
      Result:=Channel.AnswerRequest(Request);
    end else
      Request.Free;
  end;
end;

function TBisCallPhoneChannels.HangupHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
var
  Request: TBisCallPhoneRequest;
  Channel: TBisCallPhoneChannel;
begin
  Result:=false;
  Request:=TBisCallPhoneRequest.Create(mdIncoming,Event.Name,InParams);
  if Assigned(Request) then begin
    Channel:=Find(Request.ChannelId);
    if Assigned(Channel) then begin
      Channel.FRequests.Add(Request);
      Result:=Channel.HangupRequest(Request);
      if not Channel.FProcessExists then
        Remove(Channel);
    end else
      Request.Free;
  end;
end;

{ TBisCallPhoneForm }

constructor TBisCallPhoneForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CloseMode:=cmFree;
  SizesStored:=true;

  FCurrentChannel:=nil;

  FVoicePlayerLock:=TCriticalSection.Create;

  TrackBarTransparent.Position:=AlphaBlendValue;

  FRingStream:=TMemoryStream.Create;
  FDialStream:=TMemoryStream.Create;

  FChannels:=TBisCallPhoneChannels.Create(Self);

  FDrivers:=TBisRtpAcmDrivers.Create;

  FRecorder:=TBisAudioLiveRecorder.Create(Self);
  FRecorder.DeviceID:=0;
  FRecorder.Async:=true;
  FRecorder.PCMFormat:=nonePCM;
  FRecorder.OnFormat:=RecorderFormat;
  FRecorder.OnData:=RecorderData;
  FRecorder.OnError:=AudioError;

  FRecorder.FillDevices(ComboBoxRecorderDevice.Items);
  if ComboBoxRecorderDevice.Items.Count>0 then
    ComboBoxRecorderDevice.ItemIndex:=0;

  FRecorderMixer:=TBisAudioMixer.Create(nil);
  FRecorderMixer.MixerName:=FRecorder.DeviceName;

  FVoicePlayerStream:=TMemoryStream.Create;

  FVoicePlayer:=TBisAudioLivePlayer.Create(nil);
  FVoicePlayer.DeviceID:=0;
  FVoicePlayer.PCMFormat:=nonePCM;
  FVoicePlayer.PCMFormat:=Mono16bit8000Hz;
  FVoicePlayer.BufferInternally:=true;
  FVoicePlayer.Async:=true;
  FVoicePlayer.OnData:=VoicePlayerData;
  FVoicePlayer.OnError:=AudioError;

  FVoicePlayer.FillDevices(ComboBoxPlayerDevice.Items);
  if ComboBoxPlayerDevice.Items.Count>0 then
    ComboBoxPlayerDevice.ItemIndex:=0;

  FMusicPlayer:=TBisAudioStockPlayer.Create(nil);
  FMusicPlayer.DeviceID:=0;
  FMusicPlayer.Async:=false;
  FMusicPlayer.OnError:=AudioError;

  FPlayerMixer:=TBisAudioMixer.Create(nil);
  FPlayerMixer.MixerName:=FVoicePlayer.DeviceName;

  PageControl.ActivePage:=TabSheetPhone;

  FAccountId:=Null;
  FSessionId:=Null;
  FOldAcceptorType:=atSession;

  FResponseTimeout:=5000;

  ComboBoxAcceptorType.ItemIndex:=Integer(atPhone);
  ComboBoxAcceptorTypeChange(nil);

  FAfterLoginEvent:=Core.AfterLoginEvents.Add(AfterLogin);

  UpdateDialButton;

  FSMicEnabled:='��������� ��������';
  FSMicDisabled:='�������� ��������';
  FSBreakEnabled:='���� �� �������';
  FSBreakDisabled:='����� � ��������';

end;

destructor TBisCallPhoneForm.Destroy;
begin
  Core.AfterLoginEvents.Remove(FAfterLoginEvent);
  FPlayerMixerLine:=nil;
  FPlayerMixer.Free;
  FMusicPlayer.Free;
  FVoicePlayer.Free;
  FVoicePlayerStream.Free;
  FRecorderMixerLine:=nil;
  FRecorderMixer.Free;
  FRecorder.Free;
  FDrivers.Free;
  FChannels.Free;
  FDialStream.Free;
  FRingStream.Free;
  FVoicePlayerLock.Free;
  inherited Destroy;
end;

procedure TBisCallPhoneForm.ConnectionUpdate(AEnabled: Boolean);
var
  Params: TBisConfig;
begin
  if Assigned(Core) then begin
    Params:=TBisConfig.Create(nil);
    try
      Params.Write(ObjectName,'Enabled',AEnabled);
      DefaultUpdate(Params)
    finally
      Params.Free;
    end;
  end;
end;

procedure TBisCallPhoneForm.AfterLogin(Sender: TObject);
begin
  ConnectionUpdate(not ButtonBreak.Down);
end;

procedure TBisCallPhoneForm.ReadDataParams(DataParams: TBisDataValueParams);
begin
  inherited ReadDataParams(DataParams);

  if Assigned(DataParams) then begin

    with DataParams do begin
      SaveToStream(SParamRingMusic,FRingStream);
      SaveToStream(SParamDialMusic,FDialStream);
      FResponseTimeout:=AsInteger(SParamResponseTimeout,FResponseTimeout);
    end;

  end;
end;

procedure TBisCallPhoneForm.ReadProfileParams;
begin
  inherited ReadProfileParams;
  ComboBoxPlayerDevice.ItemIndex:=ProfileRead('ComboBoxPlayerDevice.ItemIndex',ComboBoxPlayerDevice.ItemIndex);
  ComboBoxPlayerDeviceChange(nil);
  ComboBoxRecorderDevice.ItemIndex:=ProfileRead('ComboBoxRecorderDevice.ItemIndex',ComboBoxRecorderDevice.ItemIndex);
  ComboBoxRecorderDeviceChange(nil);
  TrackBarPlayer.Position:=ProfileRead('TrackBarPlayer.Position',TrackBarPlayer.Position);
  TrackBarPlayerChange(nil);
  TrackBarRecorder.Position:=ProfileRead('TrackBarRecorder.Position',TrackBarRecorder.Position);
  TrackBarRecorderChange(nil);
  TrackBarTransparent.Position:=ProfileRead('TrackBarTransparent.Position',TrackBarTransparent.Position);
  TrackBarTransparentChange(nil);
  UpDownMaxChannels.Position:=ProfileRead('UpDownMaxChannels.Position',UpDownMaxChannels.Position);
  UpDownBuffer.Position:=ProfileRead('UpDownBuffer.Position',UpDownBuffer.Position);
  CheckBoxAutoAnswer.Checked:=ProfileRead('CheckBoxAutoAnswer.Checked',CheckBoxAutoAnswer.Checked);
  UpDownAutoAnswer.Position:=ProfileRead('UpDownAutoAnswer.Position',UpDownAutoAnswer.Position);
end;

procedure TBisCallPhoneForm.WriteProfileParams;
begin
  inherited WriteProfileParams;
  ProfileWrite('ComboBoxPlayerDevice.ItemIndex',ComboBoxPlayerDevice.ItemIndex);
  ProfileWrite('ComboBoxRecorderDevice.ItemIndex',ComboBoxRecorderDevice.ItemIndex);
  ProfileWrite('TrackBarPlayer.Position',TrackBarPlayer.Position);
  ProfileWrite('TrackBarRecorder.Position',TrackBarRecorder.Position);
  ProfileWrite('TrackBarTransparent.Position',TrackBarTransparent.Position);
  ProfileWrite('UpDownMaxChannels.Position',UpDownMaxChannels.Position);
  ProfileWrite('UpDownBuffer.Position',UpDownBuffer.Position);
  ProfileWrite('CheckBoxAutoAnswer.Checked',CheckBoxAutoAnswer.Checked);
  ProfileWrite('UpDownAutoAnswer.Position',UpDownAutoAnswer.Position);
end;

class function TBisCallPhoneForm.GetCallPhoneFrameClass: TBisCallPhoneFrameClass;
begin
  Result:=TBisCallPhoneFrame;
end;

function TBisCallPhoneForm.GetAcceptorType: TBisCallPhoneAcceptorType;
begin
  Result:=TBisCallPhoneAcceptorType(ComboBoxAcceptorType.ItemIndex);
end;

procedure TBisCallPhoneForm.SetAcceptorType(Value: TBisCallPhoneAcceptorType);
begin
  ComboBoxAcceptorType.ItemIndex:=Integer(Value);
end;

function TBisCallPhoneForm.GetAcceptor: String;
begin
  Result:='';
  case GetAcceptorType of
    atPhone: Result:=Trim(FPhone);
    atAccount: Result:=VarToStrDef(FAccountId,'');
    atComputer: Result:=Trim(FComputer);
    atSession: Result:=VarToStrDef(FSessionId,'');
  end;
end;

procedure TBisCallPhoneForm.SetAcceptor(Value: String);
begin
  case GetAcceptorType of
    atPhone: begin
      FPhone:=Trim(Value);
      ComboBoxAcceptor.Text:=FPhone;
    end;
    atAccount: FAccountId:=iff(Trim(Value)<>'',Value,Null);
    atComputer: FComputer:=Trim(Value);
    atSession: FSessionId:=iff(Trim(Value)<>'',Value,Null);
  end;
end;

procedure TBisCallPhoneForm.EditMaxChannelsChange(Sender: TObject);
begin
  UpdateDialButton;
end;

procedure TBisCallPhoneForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ConnectionUpdate(false);
end;

procedure TBisCallPhoneForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=FChannels.CanClose;
end;

procedure TBisCallPhoneForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  Index: Integer;
begin
  if (ssCtrl in Shift) then begin
    if Char(Key) in ['1'..'2'] then begin
      Index:=StrToIntDef(Char(Key),1)-1;
      if TabSet.Tabs.Count>Index then begin
        if TabSet.TabIndex<>Index then
          TabSet.TabIndex:=Index;
      end;
    end;
  end;
end;

procedure TBisCallPhoneForm.Init;
begin
  inherited Init;
  FOldPlayerDeviceCaption:=LabelPlayerDevice.Caption;
  FOldRecorderDeviceCaption:=LabelRecorderDevice.Caption;
  UpdateMicOffButton;
  UpdateBreakButton;
end;

procedure TBisCallPhoneForm.VoicePlayerStreamClear;
begin
  FVoicePlayerLock.Enter;
  try
    FVoicePlayerStream.Clear; 
  finally
    FVoicePlayerLock.Leave;
  end;
end;

procedure TBisCallPhoneForm.VoicePlayerStart(Channel: TBisCallPhoneChannel);
begin
  if Assigned(Channel) then begin
    VoicePlayerStreamClear;
    FVoicePlayerBufferSize:=Cardinal(UpDownBuffer.Position);
    FVoicePlayer.BufferLength:=Channel.FRemotePacketTime;
    FVoicePlayer.BufferCount:=UpDownBufferCount.Position;
    FVoicePlayer.Start(true);
  end;
end;

procedure TBisCallPhoneForm.RecorderStart(Channel: TBisCallPhoneChannel);
begin
  if Assigned(Channel) then begin
    FRecorderBufferSize:=Cardinal(UpDownBuffer.Position);
    FRecorder.BufferLength:=Channel.FRemotePacketTime;
    FRecorder.BufferCount:=UpDownBufferCount.Position;
    FRecorder.Start(true);
  end;
end;

procedure TBisCallPhoneForm.MusicPlayerStart(Mode: TBisCallPhoneFormMusicMode);
var
  Flag: Boolean;
  Stream: TStream;
begin
  Flag:=true;
  Stream:=nil;
  case Mode of
    mmRing: begin
      Flag:=not FChannels.ActiveExists(nil);
      Stream:=FRingStream;
    end;
    mmDial: Stream:=FDialStream;
  end;
  if Flag and Assigned(Stream) and
     (Stream.Size>0) then begin
    Stream.Position:=0;
    FMusicPlayer.PlayStream(Stream);
  end;
end;

procedure TBisCallPhoneForm.TimerAutoAnswerTimer(Sender: TObject);
begin
  TimerAutoAnswer.Enabled:=false;
  FChannels.ExcludeHold(FLastRingChannel);
  if Assigned(FLastRingChannel) then
    FLastRingChannel.Answer;
end;

procedure TBisCallPhoneForm.ChannelRing(Channel: TBisCallPhoneChannel);
begin
  MusicPlayerStart(mmRing);
  if Assigned(Forms.Application) then begin
    if not FChannels.ActiveExists(Channel) then begin
      with Forms.Application do begin
        Restore;
        if Assigned(MainForm) then
          Self.BringToFront;
      end;
    end;
  end;
  TimerAutoAnswer.Enabled:=false;
  FLastRingChannel:=nil;
  if CheckBoxAutoAnswer.Checked then begin
    FLastRingChannel:=Channel;
    TimerAutoAnswer.Interval:=UpDownAutoAnswer.Position*1000;
    TimerAutoAnswer.Enabled:=true;
  end;
end;

procedure TBisCallPhoneForm.ChannelDial(Channel: TBisCallPhoneChannel);
begin
  try
    MusicPlayerStart(mmDial);
    if not FChannels.ActiveExists(Channel) then begin
      FVoicePlayer.Stop(true);
      FRecorder.Stop(true);
    end;
  except
    On E: Exception do
      LoggerWrite(E.Message,ltError);
  end;
end;

procedure TBisCallPhoneForm.ChannelProcess(Channel: TBisCallPhoneChannel);
begin
  try
    ChannelActivate(Channel);
    FMusicPlayer.Stop(true);
    VoicePlayerStart(Channel);
    RecorderStart(Channel);
  except
    On E: Exception do
      LoggerWrite(E.Message,ltError);
  end;
end;

procedure TBisCallPhoneForm.ChannelFinish(Channel: TBisCallPhoneChannel);
begin
  try
    FMusicPlayer.Stop(true);
    if not FChannels.ActiveExists(Channel) then begin
      VoicePlayerStreamClear;
      FVoicePlayer.Stop(true);
      FRecorder.Stop(true);
    end;
  except
    On E: Exception do
      LoggerWrite(E.Message,ltError);
  end;
end;

procedure TBisCallPhoneForm.ChannelActivate(Channel: TBisCallPhoneChannel);
begin
  FCurrentChannel:=Channel;
end;

procedure TBisCallPhoneForm.ChannelDeactivate(Channel: TBisCallPhoneChannel);
begin
  if Channel=FCurrentChannel then
    FCurrentChannel:=nil;
  if Channel=FLastRingChannel then
    FLastRingChannel:=nil;
end;

type
  THackWaveAudioIO=class(TWaveAudioIO)
  end;

procedure TBisCallPhoneForm.AudioError(Sender: TObject);
begin
  if Assigned(Sender) then begin
    if Sender is TWaveAudioIO then begin
      LoggerWrite(THackWaveAudioIO(Sender).LastErrorText,ltError);
    end;
  end;
end;

function TBisCallPhoneForm.VoicePlayerData(Sender: TObject; const Buffer: Pointer; BufferSize: Cardinal; var NumLoops: Cardinal): Cardinal;
var
  ASize: Cardinal;
  MaxSize: Cardinal;
  Temp: TMemoryStream;
begin
  FVoicePlayerLock.Enter;
  try
    Result:=FVoicePlayer.BufferLength;;
    NumLoops:=0;
    FVoicePlayerStream.Position:=0;
    ASize:=FVoicePlayerStream.Size;
    if ASize>=BufferSize then begin
      MaxSize:=Round((BufferSize*FVoicePlayerBufferSize)/FVoicePlayer.BufferLength);
      if ASize>MaxSize then begin
        ASize:=MaxSize;
        FVoicePlayerStream.Position:=FVoicePlayerStream.Size-ASize;
      end;
      FVoicePlayerStream.Read(Buffer^,BufferSize);
      ASize:=FVoicePlayerStream.Size-FVoicePlayerStream.Position;
      if ASize>0 then begin
        Temp:=TMemoryStream.Create;
        try
          Temp.CopyFrom(FVoicePlayerStream,ASize);
          Temp.Position:=0;
          FVoicePlayerStream.Clear;
          FVoicePlayerStream.CopyFrom(Temp,ASize);
        finally
          Temp.Free;
        end;
      end else
        FVoicePlayerStream.Clear;
      Result:=BufferSize;
    end;
  finally
    FVoicePlayerLock.Leave;
  end;
end;

procedure TBisCallPhoneForm.InData(Channel: TBisCallPhoneChannel; const Data: Pointer; const DataSize: Cardinal);
var
  Converter: TBisAudioWaveConverter;
  ASize: Integer;
begin
  try
    FVoicePlayerLock.Enter;
    try
      if Assigned(Channel) and Assigned(Channel.FRemoteDriverFormat) and (DataSize>0) then begin
        Converter:=TBisAudioWaveConverter.Create;
        try
          Converter.BeginRewrite(Channel.FRemoteDriverFormat.WaveFormat);
          Converter.Write(Pointer(Data)^,DataSize);
          Converter.EndRewrite;
          if Converter.ConvertToPCM(FVoicePlayer.PCMFormat) then begin
            Converter.Stream.Position:=Converter.DataOffset;
            ASize:=Converter.Stream.Size-Converter.Stream.Position;
            if ASize>0 then begin
              FVoicePlayerStream.Position:=FVoicePlayerStream.Size;
              FVoicePlayerStream.CopyFrom(Converter.Stream,ASize);
            end;
          end;
        finally
          Converter.Free;
        end;
      end;
    finally
      FVoicePlayerLock.Leave;
    end;
  except
    On E: Exception do
      LoggerWrite(E.Message,ltError);
  end;
end;

procedure TBisCallPhoneForm.RecorderFormat(Sender: TObject; var pWaveFormat: PWaveFormatEx; var FreeIt: Boolean);
var
  Wave: TBisAudioWave;
  L: Cardinal;
begin
  FreeIt:=false;
  pWaveFormat:=nil;
  SetLength(FSilence,0);
  if Assigned(FCurrentChannel) and
     Assigned(FCurrentChannel.FRemoteDriverFormat) then begin
    pWaveFormat:=FCurrentChannel.FRemoteDriverFormat.WaveFormat;
    if Assigned(pWaveFormat) then begin
      Wave:=TBisAudioWave.Create;
      try
        Wave.BeginRewritePCM(Mono16bit22050Hz);
        Wave.EndRewrite;
        Wave.InsertSilence(0,FRecorder.BufferLength);
        if Wave.ConvertTo(pWaveFormat) then begin
          Wave.Stream.Position:=Wave.DataOffset;
          L:=Wave.Stream.Size-Wave.Stream.Position;
          if L>0 then begin
            SetLength(FSilence,L);
            Wave.Stream.Read(Pointer(FSilence)^,L);
          end;
        end;
      finally
        Wave.Free;
      end;
    end;
  end;
end;

procedure TBisCallPhoneForm.RecorderData(Sender: TObject; const Buffer: Pointer; BufferSize: Cardinal; var FreeIt: Boolean);
var
  L: Cardinal;
begin
  FreeIt:=true;
  if (BufferSize>0) and Assigned(FCurrentChannel) then begin
    if not FMicOff then
      FCurrentChannel.SendData(Buffer,BufferSize)
    else begin
      L:=Length(FSilence);
      if L>0 then begin
        FreeIt:=false;
        FCurrentChannel.SendData(FSilence,L);
      end;
    end;
  end;
end;

procedure TBisCallPhoneForm.TabSetChange(Sender: TObject; NewTab: Integer; var AllowChange: Boolean);
begin
  if NewTab=TabSheetPhone.PageIndex then begin
    WriteProfileParams;
    SaveProfileParams;
    PageControl.ActivePage:=TabSheetPhone
  end else begin
    PageControl.ActivePage:=TabSheetOptions;
  end;

  UpdateHeight;  
end;

procedure TBisCallPhoneForm.TrackBarPlayerChange(Sender: TObject);
begin
  if Assigned(FPlayerMixerLine) then
    FPlayerMixerLine.Volume:=TrackBarPlayer.Position;
end;

procedure TBisCallPhoneForm.TrackBarRecorderChange(Sender: TObject);
begin
  if Assigned(FRecorderMixerLine) then
    FRecorderMixerLine.Volume:=TrackBarRecorder.Position;
end;

procedure TBisCallPhoneForm.TrackBarTransparentChange(Sender: TObject);
begin
  AlphaBlendValue:=TrackBarTransparent.Max-(TrackBarTransparent.Position-TrackBarTransparent.Min);
end;

procedure TBisCallPhoneForm.UpdateBreakButton;
begin
  if ButtonBreak.Down then
    ButtonBreak.Hint:=FSBreakDisabled
  else
    ButtonBreak.Hint:=FSBreakEnabled;
  ConnectionUpdate(not ButtonBreak.Down);
end;

procedure TBisCallPhoneForm.UpdateDialButton;
begin
  ButtonDial.Enabled:=CanDial;
end;

procedure TBisCallPhoneForm.UpdateChannel(Channel: TBisCallPhoneChannel);
begin
  if Assigned(Channel) and Channel.FFrame.Active then begin
    StatusBar.SimpleText:=Channel.Status;
  end else begin
    StatusBar.SimpleText:=' ';
  end;
  StatusBar.Update;
end;

procedure TBisCallPhoneForm.UpdateHeight;
var
  H0, H1,H2: Integer;
begin
  if PageControl.ActivePage=TabSheetPhone then begin
    H0:=100;
    H1:=130;
    H2:=FChannels.Height;
    Constraints.MinHeight:=H1;
    if (H0+H2)>H1 then
      Constraints.MinHeight:=H0+H2;
  end else begin
    Constraints.MinHeight:=230;
  end;
  Height:=Constraints.MinHeight;
  LabelNoChannels.Visible:=FChannels.Count=0;
end;

procedure TBisCallPhoneForm.UpdateMicOffButton;
begin
  if ButtonMicOff.Down then
    ButtonMicOff.Hint:=FSMicDisabled
  else
    ButtonMicOff.Hint:=FSMicEnabled;
end;

procedure TBisCallPhoneForm.UpdateTrackBarPlayer;
var
  DestID,LineID: Integer;
begin
  TrackBarPlayer.OnChange:=nil;
  try
    FPlayerMixer.MixerName:=FVoicePlayer.DeviceName;
    if FPlayerMixer.FindMixerLine(FPlayerMixer.Master.ComponentType,DestID,LineID) then begin
      FPlayerMixer.DestinationID:=DestID;
      FPlayerMixerLine:=FPlayerMixer.Lines[LineID];
    end else
      FPlayerMixerLine:=FPlayerMixer.Master;

    if Assigned(FPlayerMixerLine) then begin
      TrackBarPlayer.Position:=FPlayerMixerLine.Volume;
      TrackBarPlayer.Enabled:=true;
      LabelPlayerDevice.Caption:=FormatEx('%s %s',[FOldPlayerDeviceCaption,FPlayerMixerLine.Name]);
    end else begin
      TrackBarPlayer.Position:=0;
      TrackBarPlayer.Enabled:=false;
      LabelPlayerDevice.Caption:=FOldPlayerDeviceCaption;
    end;
  finally
    TrackBarPlayer.OnChange:=TrackBarPlayerChange;
  end;
end;

procedure TBisCallPhoneForm.UpdateTrackBarRecorder;
var
  DestID,LineID: Integer;
begin
  TrackBarRecorder.OnChange:=nil;
  try
    FRecorderMixer.MixerName:=FRecorder.DeviceName;
    if FRecorderMixer.FindMixerLine(cmSrcMicrophone,DestID,LineID) then begin
      FRecorderMixer.DestinationID:=DestID;
      FRecorderMixerLine:=FRecorderMixer.Lines[LineID];
    end else
      FRecorderMixerLine:=nil;

    if Assigned(FRecorderMixerLine) then begin
      TrackBarRecorder.Position:=FRecorderMixerLine.Volume;
      TrackBarRecorder.Enabled:=true;
      LabelRecorderDevice.Caption:=FormatEx('%s %s',[FOldRecorderDeviceCaption,FRecorderMixerLine.Name]);
    end else begin
      TrackBarRecorder.Position:=0;
      TrackBarRecorder.Enabled:=false;
      LabelRecorderDevice.Caption:=FOldRecorderDeviceCaption;
    end;
  finally
    TrackBarRecorder.OnChange:=TrackBarRecorderChange;
  end;
end;

procedure TBisCallPhoneForm.GetLocalEventParams;
begin
  if Assigned(Core) then begin
    with FChannels do begin
      GetEventParams(Core.SessionId,
                     FIP,FPort,FUseCompressor,FCompressorLevel,
                     FUseCrypter,FCrypterKey,FCrypterAlgorithm,FCrypterMode);
    end;
  end;
end;

procedure TBisCallPhoneForm.BeforeShow;
var
  Acceptor: String;
begin
  inherited BeforeShow;
  ConnectionUpdate(true);
  GetLocalEventParams;

  UpdateTrackBarPlayer;
  UpdateTrackBarRecorder;
  UpdateHeight;

  Acceptor:=GetAcceptor;
  if Acceptor<>'' then
    Dial;

  FBeforeShowed:=true;
end;

procedure TBisCallPhoneForm.ComboBoxAcceptorChange(Sender: TObject);
begin
  case GetAcceptorType of
    atPhone: FPhone:=ComboBoxAcceptor.Text;
    atAccount: FAccount:=ComboBoxAcceptor.Text;
    atComputer: FComputer:=ComboBoxAcceptor.Text;
    atSession: FSession:=ComboBoxAcceptor.Text;
  end;
  UpdateDialButton;
end;

procedure TBisCallPhoneForm.ComboBoxAcceptorKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  ComboBoxAcceptorChange(nil);
end;

procedure TBisCallPhoneForm.ComboBoxAcceptorTypeChange(Sender: TObject);
var
  NewAcceptorType: TBisCallPhoneAcceptorType;
begin
  NewAcceptorType:=GetAcceptorType;
  if FOldAcceptorType<>NewAcceptorType then begin
    case NewAcceptorType of
      atPhone: begin
        ComboBoxAcceptor.Color:=clWindow;
        ComboBoxAcceptor.Text:=FPhone;
        ButtonSelect.Enabled:=CanSelectAccountPhone;
      end;
      atAccount: begin
        ComboBoxAcceptor.Color:=clBtnFace;
        ComboBoxAcceptor.Text:=FAccount;
        ButtonSelect.Enabled:=CanSelectAccount;
      end;
      atComputer: begin
        ComboBoxAcceptor.Color:=clWindow;
        ComboBoxAcceptor.Text:=FComputer;
        ButtonSelect.Enabled:=CanSelectComputer;
      end;
      atSession: begin
        ComboBoxAcceptor.Color:=clBtnFace;
        ComboBoxAcceptor.Text:=FSession;
        ButtonSelect.Enabled:=CanSelectSession;
      end;
    end;
    FOldAcceptorType:=NewAcceptorType;
  end;
  if FBeforeShowed and ComboBoxAcceptor.CanFocus then
    ComboBoxAcceptor.SetFocus;
end;

procedure TBisCallPhoneForm.ComboBoxPlayerDeviceChange(Sender: TObject);
var
  Index: Integer;
  DeviceID: Cardinal;
begin
  Index:=ComboBoxPlayerDevice.ItemIndex;
  if Index<>FOldPlayerIndex then begin
    if Index>-1 then begin
      DeviceID:=Index;
      FVoicePlayer.DeviceID:=DeviceID;
      FMusicPlayer.DeviceID:=DeviceID;
      UpdateTrackBarPlayer;
    end;
    FOldPlayerIndex:=Index;
  end;
end;

procedure TBisCallPhoneForm.ComboBoxRecorderDeviceChange(Sender: TObject);
var
  Index: Integer;
  DeviceID: Cardinal;
begin
  Index:=ComboBoxRecorderDevice.ItemIndex;
  if Index<>FOldRecorderIndex then begin
    if Index>-1 then begin
      DeviceID:=Index;
      FRecorder.DeviceID:=DeviceID;
      UpdateTrackBarRecorder;
    end;
    FOldRecorderIndex:=Index;
  end;
end;

function TBisCallPhoneForm.CanSelectAccount: Boolean;
begin
  with TBisDesignDataRolesAndAccountsFormIface.CreateInited(nil) do begin
    try
      Result:=CanShow;
    finally
      Free;
    end;
  end;
end;

procedure TBisCallPhoneForm.SelectAccount;
var
  AIface: TBisDesignDataRolesAndAccountsFormIface;
  DS: TBisDataSet;
begin
  if CanSelectAccount then begin
    AIface:=TBisDesignDataRolesAndAccountsFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      AIface.LocateFields:='ACCOUNT_ID';
      AIface.LocateValues:=FAccountId;
      AIface.MultiSelect:=false;
      if AIface.SelectInto(DS) then begin
        FAccountId:=DS.FieldByName('ACCOUNT_ID').Value;
        Acceptor:=FAccountId;
        ComboBoxAcceptor.Text:=DS.FieldByName('USER_NAME').AsString;
        UpdateDialButton;
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

function TBisCallPhoneForm.CanSelectAccountPhone: Boolean;
begin
  with TBisDesignDataAccountsFormIface.CreateInited(nil) do begin
    try
      Result:=CanShow;
    finally
      Free;
    end;
  end;
end;

procedure TBisCallPhoneForm.SelectAccountPhone;
var
  AIface: TBisDesignDataAccountsFormIface;
  DS: TBisDataSet;
begin
  if CanSelectAccountPhone then begin
    AIface:=TBisDesignDataAccountsFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      if AIface.SelectInto(DS) then begin
        Acceptor:=DS.FieldByName('PHONE').AsString;
        UpdateDialButton;
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

function TBisCallPhoneForm.CanSelectComputer: Boolean;
begin
  Result:=true;
end;

procedure TBisCallPhoneForm.SelectComputer;
var
  S: String;
  Title: String;
begin
  if CanSelectComputer then begin
    Title:=FormatEx('%s %s',[ButtonSelect.Hint,ComboBoxAcceptorType.Text,ComboBoxAcceptor.Text]);
    S:=ShowDialog(Title,ComboBoxAcceptor.Text,sdfNetwork,[sdoBrowseForComputer]);
    if S<>ComboBoxAcceptor.Text then begin
      Acceptor:=S;
      UpdateDialButton;
    end;
  end;
end;

function TBisCallPhoneForm.CanSelectSession: Boolean;
begin
  with TBisDesignDataSessionsFormIface.CreateInited(nil) do begin
    try
      Result:=CanShow;
    finally
      Free;
    end;
  end;
end;

procedure TBisCallPhoneForm.CheckBoxAutoAnswerClick(Sender: TObject);
begin
  EditAutoAnswer.Enabled:=CheckBoxAutoAnswer.Checked;
  UpDownAutoAnswer.Enabled:=CheckBoxAutoAnswer.Checked;
end;

procedure TBisCallPhoneForm.SelectSession;
var
  AIface: TBisDesignDataSessionsFormIface;
  DS: TBisDataSet;
begin
  if CanSelectAccount then begin
    AIface:=TBisDesignDataSessionsFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      AIface.LocateFields:='SESSION_ID';
      AIface.LocateValues:=FSessionId;
      AIface.MultiSelect:=false;
      AIface.FilterGroups.Add.Filters.Add('SESSION_ID',fcNotEqual,Core.SessionId).CheckCase:=true;
      if AIface.SelectInto(DS) then begin
        FSessionId:=DS.FieldByName('SESSION_ID').Value;
        Acceptor:=FSessionId;
        ComboBoxAcceptor.Text:=Format('%s %s',[DS.FieldByName('DATE_CREATE').AsString,
                                               DS.FieldByName('APPLICATION_NAME').AsString]);
        UpdateDialButton;                                               
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

procedure TBisCallPhoneForm.ButtonBreakClick(Sender: TObject);
begin
  UpdateBreakButton;
end;

procedure TBisCallPhoneForm.ButtonDialClick(Sender: TObject);
begin
  Dial;
end;

procedure TBisCallPhoneForm.ButtonMicOffClick(Sender: TObject);
begin
  FMicOff:=ButtonMicOff.Down;
  if Assigned(FRecorderMixer.Master) then
    FRecorderMixer.Master.Mute:=ButtonMicOff.Down;
  UpdateMicOffButton;
end;

procedure TBisCallPhoneForm.ButtonSelectClick(Sender: TObject);
begin
  case GetAcceptorType of
    atPhone: SelectAccountPhone;
    atAccount: SelectAccount;
    atComputer: SelectComputer;
    atSession: SelectSession;
  end;
  ComboBoxAcceptorChange(nil);
end;

function TBisCallPhoneForm.CanDial: Boolean;
var
  S: String;
begin
  Result:=UpDownMaxChannels.Position>FChannels.ActiveCount;
  if Result then begin
    S:=GetAcceptor;
    Result:=Trim(S)<>'';
  end;
end;

procedure TBisCallPhoneForm.Dial;
var
  Channel: TBisCallPhoneChannel;
  Acceptor: Variant;
  AcceptorType: TBisCallPhoneAcceptorType;
  S: String;
begin
  Acceptor:=GetAcceptor;
  AcceptorType:=GetAcceptorType;
  if CanDial then begin
    if AcceptorType=atPhone then begin
      S:=VarToStrDef(Acceptor,'');
      if ComboBoxAcceptor.Items.IndexOf(S)=-1 then
        ComboBoxAcceptor.Items.Add(S);
    end;
    SetAcceptor('');
    Channel:=FChannels.AddOutgoing;
    if Assigned(Channel) then begin
      Update;
      if AcceptorType=atPhone then
        Acceptor:=Channel.TransformPhone(Acceptor);
      if Channel.GetCallInfo(Acceptor) then begin
        FChannels.ExcludeHold(Channel);
        FChannels.SetFrameProps(Channel);
        Update;
        Channel.Dial(Acceptor,AcceptorType);
      end else
        FChannels.Remove(Channel);
    end;
  end else begin
    SetAcceptor('');
  end;
end;


end.