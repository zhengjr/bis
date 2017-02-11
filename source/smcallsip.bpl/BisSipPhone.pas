unit BisSipPhone;

interface

uses SysUtils, Classes, Contnrs, mmSystem, SyncObjs,
     IdGlobal, IdUdpServer, IdTCPServer,
     IdUdpClient, IdSocketHandle, IdException,
     WaveACMDrivers, WaveStorage, WaveUtils,
     BisSip, BisSdp, BisRtp, BisAudioWave, BisLocks, BisAudioDtmf,
     BisRtpAcmDrivers, BisUdpServer, BisAudioSpectrum,
     BisSipClient, BisThreads;

type
  TBisSipPhone=class;

  TBisSipPhoneLine=class;

  TBisSipPhoneLineUdpServer=class(TBisUdpServer)
  protected
    function GetBinding: TIdSocketHandle; override;
  public
    constructor Create(AOwner: TComponent); reintroduce;
    destructor Destroy; override;
  end;

  TBisSipPhoneLineDirection=(ldUnknown,ldIncoming,ldOutgoing);
  TBisSipPhoneLineHoldMode=(lhmStandart,lhmEmulate);
  TBisSipPhoneLineState=(lsDestroying,lsPlaying,lsHolding,lsRinging,lsConnected);
  TBisSipPhoneLineStates=set of TBisSipPhoneLineState;

  TBisSipPhoneLine=class(TBisLock)
  private
    FPhone: TBisSipPhone;

    FDtmf: TBisAudioDtmf;
    FDtmfThread: TBisWaitThread;
    FDtmfCode: Char;
    FDtmfFormat: TWaveFormatEx;
    FDtmfStream: TMemoryStream;
    FDtmfEnabled: Boolean;
    FDtmfPeriod: Cardinal;

    FDetectBusy: TBisAudioSpectrum;
    FDetectBusyEnabled: Boolean;
    FDetectBusyStream: TMemoryStream;
    FDetectBusyFormat: TWaveFormatEx;
    FDetectBusyThread: TBisWaitThread;
    FDetectBusyCount: Cardinal;
    FDetectBusyMaxCount: Cardinal;
    FDetectBusyPeriod: Cardinal;
    FDetectBusyTick, FDetectBusyFreq: Int64;

    FOutThread: TBisWaitThread;
    FOutStream: TMemoryStream;
    FOutLock: TCriticalSection;
    FOutLoopCount: Cardinal;
    FOutCounter: Cardinal;
    FNumber: String;
    FDiversionNumber: String;
    FSession: TBisSipSession;
    FHoldWaiting: Boolean;
    FLastTick: Int64;
    FLastFreq: Int64;
    FStates: TBisSipPhoneLineStates;

    FRemoteHost: String;
    FRemoteIP: String;
    FRemotePort: Integer;
    FRemoteFormat: String;
    FRemoteSessionId: LongWord;
    FRemoteSessionVersion: LongWord;
    FRemotePayloadType: TBisRtpPacketPayloadType;
    FRemoteRtpmaps: TBisSdp;
    FRemoteChannels: Word;
    FRemoteSamplesPerSec: LongWord;
    FRemoteBitsPerSample: Word;
    FRemoteDriverFormat: TWaveAcmDriverFormat;
    FRemotePacketTime: Word;
    FRemoteModeType: TBisSdpModeAttrType;

    FLocalIP: String;
    FLocalSessionId: LongWord;
    FLocalSessionVersion: LongWord;
    FLocalPayloadType: TBisRtpPacketPayloadType;
    FLocalEncondingType: TBisSdpRtpmapAttrEncodingType;
    FLocalChannels: Word;
    FLocalSamplesPerSec: LongWord;
    FLocalBitsPerSample: Word;
    FLocalDriverFormat: TWaveAcmDriverFormat;
    FLocalPacketTime: Word;
    FLocalEmptyAddress: String;
    FLocalSilenceChar: Char;
    FLocalBufferSize: Word;

    FSequence: Word;
    FTimeStamp: LongWord;
    FSSRCIdentifier: LongWord;
    FServer: TBisSipPhoneLineUdpServer;
    FBinding: TIdSocketHandle;
    FRemotePackets: TBisRtpPackets;
    FLocalPackets: TBisRtpPackets;
    FCheckRemoteIP: Boolean;
    FLocalPayloadLength: LongWord;
    FRemotePayloadLength: LongWord;

//  FDialTimeout: Cardinal;
    FDialTick,FDialFreq: Int64;
//  FTalkTimeout: Cardinal;
    FTalkTick,FTalkFreq: Int64;

    procedure DtmfCode(Sender: TObject; const Code: Char);
    procedure DtmfThreadTimeout(Thread: TBisWaitThread);

    procedure DetectBusyClear;
    procedure DetectBusyDetect(Sender: TBisAudioSpectrum; const Freq: Word; const Level: Integer);
    procedure DetectBusyThreadTimeout(Thread: TBisWaitThread);

    procedure OutThreadBegin(Thread: TBisThread);
    procedure OutThreadEnd(Thread: TBisThread);
    procedure OutThreadError(Thread: TBisThread; const E: Exception);
    procedure OutThreadTimeout(Thread: TBisWaitThread);
    
    procedure ServerUDPRead(Sender: TObject; AData: TIdBytes; ABinding: TIdSocketHandle);
    procedure ServerUDPException(Sender: TObject; ABinding: TIdSocketHandle; const AMessage: String; const AExceptionClass: TClass);
    function GetPayloadLength(PayloadType: TBisRtpPacketPayloadType; PacketTime, BitsPerSample, Channels: Word): LongWord;
    function GetPacketTime(PayloadType: TBisRtpPacketPayloadType; BitsPerSample, Channels: Word): Word;
    function DefaultRemotePacket(Packet: TBisRtpPacket): Boolean;
    function SetContent(Content: String): Boolean;
    function TryServerActive: Boolean;
    function SendPacket(Packet: TBisRtpPacket; WithAdd: Boolean): Boolean;
    procedure SendConfirm;
    function GetRemoteFormat: PWaveFormatEx;
    function GetActive: Boolean;
    procedure SetLocalDriverFormat;
    function GetDirection: TBisSipPhoneLineDirection;
    function GetLocalFormat: PWaveFormatEx;
    procedure HoldUnHold(Flag: Boolean);
    function HasFreshData: Boolean;
    function GetInThread: TThread;
    function ReadyForDestroy: Boolean;
    procedure TalkStamp;
    procedure DialStamp;
  public
    constructor Create(Phone: TBisSipPhone); reintroduce;
    destructor Destroy; override;

    procedure Dial(Number: String);
    procedure Answer;
    procedure Hangup;
    procedure Hold;
    procedure UnHold;
    procedure PlayStart(LoopCount: Cardinal=0);
    procedure PlayStream(Stream: TStream); 
    procedure PlayData(const Data: Pointer; const DataSize: Cardinal);
    procedure PlayDtmfString(const S: String; Period: Cardinal);
    procedure PlayStop;
    procedure Send(Data: TBytes; Event: Boolean); overload;
    procedure Send(const Data: Pointer; const DataSize: Cardinal; Event: Boolean); overload;

    property Active: Boolean read GetActive;
    property Number: String read FNumber;
    property DiversionNumber: String read FDiversionNumber;
    property Direction: TBisSipPhoneLineDirection read GetDirection;
    property States: TBisSipPhoneLineStates read FStates;
    property InThread: TThread read GetInThread;

    property RemotePackets: TBisRtpPackets read FRemotePackets;
    property RemoteFormat: PWaveFormatEx read GetRemoteFormat;
    property RemotePayloadType: TBisRtpPacketPayloadType read FRemotePayloadType;
    property RemotePayloadLength: LongWord read FRemotePayloadLength;
    property RemotePacketTime: Word read FRemotePacketTime;

    property LocalPackets: TBisRtpPackets read FLocalPackets;
    property LocalFormat: PWaveFormatEx read GetLocalFormat;
    property LocalPayloadType: TBisRtpPacketPayloadType read FLocalPayloadType;
    property LocalPayloadLength: LongWord read FLocalPayloadLength;
    property LocalPacketTime: Word read FLocalPacketTime;
    property LocalBufferSize: Word read FLocalBufferSize write FLocalBufferSize; 

{    property DtmfEnabled: Boolean read FDtmfEnabled write FDtmfEnabled;
    property DetectBusyEnabled: Boolean read FDetectBusyEnabled write FDetectBusyEnabled;  }
  end;

  TBisSipPhoneLines=class(TBisLocks)
  private
    FPhone: TBisSipPhone;
    function GetItem(Index: Integer): TBisSipPhoneLine;
    function LastLocalPort: Integer;
  protected
    procedure DoItemRemove(Item: TObject); override;  
  public
    constructor Create(Phone: TBisSipPhone); reintroduce;

    function Add(Session: TBisSipSession): TBisSipPhoneLine; reintroduce;
    function LockAdd(Session: TBisSipSession): TBisSipPhoneLine; reintroduce;
    function Find(Session: TBisSipSession): TBisSipPhoneLine;
    function LockFind(Session: TBisSipSession): TBisSipPhoneLine;
    function Exists(Line: TBisSipPhoneLine): Boolean;
    function LockExists(Line: TBisSipPhoneLine): Boolean;
    function ActiveCount: Integer;
    function LockActiveCount: Integer;

    property Items[Index: Integer]: TBisSipPhoneLine read GetItem; default;
  end;

  TBisSipPhoneEvent=procedure (Phone: TBisSipPhone) of object;
  TBisSipPhoneSendEvent=procedure (Phone: TBisSipPhone; Host: String; Port: Integer; Data: String) of object;
  TBisSipPhoneReceiveEvent=TBisSipPhoneSendEvent;
  TBisSipPhoneErrorEvent=procedure (Phone: TBisSipPhone; const Error: String) of object;
  TBisSipPhoneLineEvent=procedure (Phone: TBisSipPhone; Line: TBisSipPhoneLine) of object;
  TBisSipPhoneLineCheckEvent=function (Phone: TBisSipPhone; Line: TBisSipPhoneLine; Message: TBisSipMessage): Boolean of object;
  TBisSipPhoneLineInDataEvent=procedure (Phone: TBisSipPhone; Line: TBisSipPhoneLine; const Data: Pointer; const DataSize: Cardinal) of object;
  TBisSipPhoneLineOutDataEvent=procedure (Phone: TBisSipPhone; Line: TBisSipPhoneLine; const Data: Pointer; const DataSize: Cardinal) of object;
  TBisSipPhoneLineInDataExEvent=procedure (Phone: TBisSipPhone; Line: TBisSipPhoneLine; Packet: TBisRtpPacket; Rtpmap: TBisSdpRtpmapAttr) of object;
  TBisSipPhoneLineDtmfEvent=procedure (Phone: TBisSipPhone; Line: TBisSipPhoneLine; const Code: Char) of object;

  TBisSipPhoneThreadOption=(toConnect,toDisconnect,toError,toSend,toReceive,toTimeout,
                            toLineCheck,toLineConnect,toLineCreate,toLineDestroy,toLineHold,
                            toLineDisconnect,toLineInData,toLineInDataEx,toLineOutData,
                            toLinePlayBegin,toLinePlayEnd,toLineRing,toLineTimeout,toLineDtmf,
                            toLineDetectBusy);
  TBisSipPhoneThreadOptions=set of TBisSipPhoneThreadOption;

  TBisSipPhoneState=(psDefault,psConnecting,psDisconnecting);

  TBisSipPhone=class(TComponent)
  private
    FRemotePort: Integer;
    FLocalPort: Integer;
    FLocalIP: String;
    FRemoteHost: String;
    FPassword: String;
    FLocalHost: String;
    FUserName: String;
    FUserAgent: String;
    FMaxForwards: Integer;
    FExpires: Integer;
    FMaxActiveLines: Integer;
    FScheme: String;
    FProtocol: String;
    FRequestTimeOut: Integer;
    FRequestRetryCount: Integer;
    FUseReceived: Boolean;
    FKeepAliveInterval: Cardinal;
    FUseRport: Boolean;
    FUseTrasnportNameInUri: Boolean;
    FUsePortInUri: Boolean;
    FUseGlobalSequence: Boolean;

    FAudioDriverName: String;
    FAudioFormatName: String;
//  FTalkTimeout: Cardinal;
    FRtpLocalPort: Integer;
    FAudioBitsPerSample: Word;
    FAudioSamplesPerSec: LongWord;
    FAudioChannels: Word;
    FConfirmCount: Integer;
    FHoldMode: TBisSipPhoneLineHoldMode;
    FSweepInterval: Cardinal;
    FTransportMode: TBisSipTransportMode;
    FCollectRemotePackets: Boolean;
    FCollectLocalPackets: Boolean;

    FClient: TBisSipClient;
    FLines: TBisSipPhoneLines;
    FDrivers: TBisRtpAcmDrivers;
    FSweepThread: TBisWaitThread;

    FOnSend: TBisSipPhoneSendEvent;
    FOnReceive: TBisSipPhoneReceiveEvent;
    FOnConnect: TBisSipPhoneEvent;
    FOnDisconnect: TBisSipPhoneEvent;
    FOnLineCheck: TBisSipPhoneLineCheckEvent;
    FOnLineRing: TBisSipPhoneLineEvent;
    FOnLineCreate: TBisSipPhoneLineEvent;
    FOnLineDestroy: TBisSipPhoneLineEvent;
    FOnLineInData: TBisSipPhoneLineInDataEvent;
    FOnLineConnect: TBisSipPhoneLineEvent;
    FOnLineDisconnect: TBisSipPhoneLineEvent;
    FOnLineOutData: TBisSipPhoneLineOutDataEvent;
    FOnLineHold: TBisSipPhoneLineEvent;
    FOnLinePlayEnd: TBisSipPhoneLineEvent;
    FOnLineInDataEx: TBisSipPhoneLineInDataExEvent;
    FOnLinePlayBegin: TBisSipPhoneLineEvent;
    FOnLineTimeout: TBisSipPhoneLineEvent;
    FOnError: TBisSipPhoneErrorEvent;
    FOnTimeout: TBisSipPhoneEvent;
    FOnTerminate: TBisSipPhoneEvent;
    FOnLineDtmf: TBisSipPhoneLineDtmfEvent;
    FOnLineDetectBusy: TBisSipPhoneLineEvent;

    FThreadOptions: TBisSipPhoneThreadOptions;

    FDtmfThreshold: Cardinal;
    FDtmfEnabled: Boolean;
    FDtmfTimeout: Cardinal;

    FDetectBusyThreshold: Cardinal;
    FDetectBusyTimeout: Cardinal;
    FDetectBusyEnabled: Boolean;
    FDetectBusyMaxCount: Cardinal;

    procedure SweepThreadTimeout(Thread: TBisWaitThread);

    function GetBusy: Boolean;

    procedure ClientRegister(Client: TBisSipClient);
    procedure ClientError(Client: TBisSipClient; const Error: String);
    procedure ClientSend(Client: TBisSipClient; Host: String; Port: Integer; Data: String);
    procedure ClientReceive(Client: TBisSipClient; Host: String; Port: Integer; Data: String);
    procedure ClientTimeout(Client: TBisSipClient; var Interrupted: Boolean);
    procedure �lientSessionCreate(Client: TBisSipClient; Session: TBisSipSession);
    procedure ClientSessionDestroy(Client: TBisSipClient; Session: TBisSipSession);
    function ClientSessionAccept(Client: TBisSipClient; Session: TBisSipSession; Message: TBisSipMessage): Boolean;
    procedure ClientSessionContent(Client: TBisSipClient; Session: TBisSipSession; Content: String);
    procedure ClientSessionRing(Client: TBisSipClient; Session: TBisSipSession);
    procedure ClientSessionConfirm(Client: TBisSipClient; Session: TBisSipSession);
    procedure ClientSessionTerminate(Client: TBisSipClient; Session: TBisSipSession);
    function GetState: TBisSipPhoneState;
    function GetConnected: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Connect;
    procedure Disconnect;
    procedure Terminate;
    function AddLine(Direction: TBisSipPhoneLineDirection): TBisSipPhoneLine;
    procedure Dial(Number: String);
    procedure Answer(Line: TBisSipPhoneLine);
    procedure Hangup(Line: TBisSipPhoneLine);
    procedure Hold(Line: TBisSipPhoneLine);
    procedure Unhold(Line: TBisSipPhoneLine);
    procedure HangupAll;

    property Connected: Boolean read GetConnected;
    property Lines: TBisSipPhoneLines read FLines;
    property Busy: Boolean read GetBusy;
    property State: TBisSipPhoneState read GetState;

    property Scheme: String read FScheme write FScheme;
    property Protocol: String read FProtocol write FProtocol;
    property UserName: String read FUserName write FUserName;
    property Password: String read FPassword write FPassword;
    property RemoteHost: String read FRemoteHost write FRemoteHost;
    property RemotePort: Integer read FRemotePort write FRemotePort;
    property LocalHost: String read FLocalHost write FLocalHost;
    property LocalPort: Integer read FLocalPort write FLocalPort;
    property UserAgent: String read FUserAgent write FUserAgent;
    property Expires: Integer read FExpires write FExpires;
    property MaxForwards: Integer read FMaxForwards write FMaxForwards;
    property MaxActiveLines: Integer read FMaxActiveLines write FMaxActiveLines;
//    property MaxInLines: Integer read FMaxInLines write FMaxInLines;
//    property MaxOutLines: Integer read FMaxOutLines write FMaxOutLines;
    property KeepAliveInterval: Cardinal read FKeepAliveInterval write FKeepAliveInterval;
    property UseReceived: Boolean read FUseReceived write FUseReceived;
    property UseRport: Boolean read FUseRport write FUseRport;
    property UseTrasnportNameInUri: Boolean read FUseTrasnportNameInUri write FUseTrasnportNameInUri;
    property UsePortInUri: Boolean read FUsePortInUri write FUsePortInUri;
    property UseGlobalSequence: Boolean read FUseGlobalSequence write FUseGlobalSequence;
    property RequestRetryCount: Integer read FRequestRetryCount write FRequestRetryCount;
    property RequestTimeOut: Integer read FRequestTimeOut write FRequestTimeOut;
    property CollectRemotePackets: Boolean read FCollectRemotePackets write FCollectRemotePackets;
    property CollectLocalPackets: Boolean read FCollectLocalPackets write FCollectLocalPackets;
    property TransportMode: TBisSipTransportMode read FTransportMode write FTransportMode;
    property ThreadOptions: TBisSipPhoneThreadOptions read FThreadOptions write FThreadOptions;
{   property DialTimeout: Cardinal read FDialTimeout write FDialTimeout;
    property TalkTimeout: Cardinal read FTalkTimeout write FTalkTimeout;}
    property RtpLocalPort: Integer read FRtpLocalPort write FRtpLocalPort;

    property AudioDriverName: String read FAudioDriverName write FAudioDriverName;
    property AudioFormatName: String read FAudioFormatName write FAudioFormatName;
    property AudioChannels: Word read FAudioChannels write FAudioChannels;
    property AudioSamplesPerSec: LongWord read FAudioSamplesPerSec write FAudioSamplesPerSec;
    property AudioBitsPerSample: Word read FAudioBitsPerSample write FAudioBitsPerSample;

    property ConfirmCount: Integer read FConfirmCount write FConfirmCount;
    property HoldMode: TBisSipPhoneLineHoldMode read FHoldMode write FHoldMode;
    property SweepInterval: Cardinal read FSweepInterval write FSweepInterval;

    property DtmfEnabled: Boolean read FDtmfEnabled write FDtmfEnabled;
    property DtmfThreshold: Cardinal read FDtmfThreshold write FDtmfThreshold;
    property DtmfTimeout: Cardinal read FDtmfTimeout write FDtmfTimeout;

    property DetectBusyEnabled: Boolean read FDetectBusyEnabled write FDetectBusyEnabled;
    property DetectBusyThreshold: Cardinal read FDetectBusyThreshold write FDetectBusyThreshold;
    property DetectBusyTimeout: Cardinal read FDetectBusyTimeout write FDetectBusyTimeout;
    property DetectBusyMaxCount: Cardinal read FDetectBusyMaxCount write FDetectBusyMaxCount; 

    property OnSend: TBisSipPhoneSendEvent read FOnSend write FOnSend;
    property OnReceive: TBisSipPhoneReceiveEvent read FOnReceive write FOnReceive;
    property OnConnect: TBisSipPhoneEvent read FOnConnect write FOnConnect;
    property OnDisconnect: TBisSipPhoneEvent read FOnDisconnect write FOnDisconnect;
    property OnError: TBisSipPhoneErrorEvent read FOnError write FOnError;
    property OnTimeout: TBisSipPhoneEvent read FOnTimeout write FOnTimeout;
    property OnTerminate: TBisSipPhoneEvent read FOnTerminate write FOnTerminate;   
    property OnLineCreate: TBisSipPhoneLineEvent read FOnLineCreate write FOnLineCreate;
    property OnLineDestroy: TBisSipPhoneLineEvent read FOnLineDestroy write FOnLineDestroy;
    property OnLineCheck: TBisSipPhoneLineCheckEvent read FOnLineCheck write FOnLineCheck;
    property OnLineRing: TBisSipPhoneLineEvent read FOnLineRing write FOnLineRing;
    property OnLineConnect: TBisSipPhoneLineEvent read FOnLineConnect write FOnLineConnect;
    property OnLineInData: TBisSipPhoneLineInDataEvent read FOnLineInData write FOnLineInData;
    property OnLineInDataEx: TBisSipPhoneLineInDataExEvent read FOnLineInDataEx write FOnLineInDataEx;
    property OnLineOutData: TBisSipPhoneLineOutDataEvent read FOnLineOutData write FOnLineOutData;
    property OnLineDisconnect: TBisSipPhoneLineEvent read FOnLineDisconnect write FOnLineDisconnect;
    property OnLineHold: TBisSipPhoneLineEvent read FOnLineHold write FOnLineHold;
    property OnLinePlayBegin: TBisSipPhoneLineEvent read FOnLinePlayBegin write FOnLinePlayBegin;
    property OnLinePlayEnd: TBisSipPhoneLineEvent read FOnLinePlayEnd write FOnLinePlayEnd;
    property OnLineTimeout: TBisSipPhoneLineEvent read FOnLineTimeout write FOnLineTimeout;
    property OnLineDtmf: TBisSipPhoneLineDtmfEvent read FOnLineDtmf write FOnLineDtmf;
    property OnLineDetectBusy: TBisSipPhoneLineEvent read FOnLineDetectBusy write FOnLineDetectBusy; 
  end;

const
  AllPhoneThreadOptions=[toConnect,toDisconnect,toError,toSend,toReceive,toTimeout,
                         toLineCheck,toLineConnect,toLineCreate,toLineDestroy,toLineHold,
                         toLineDisconnect,toLineInData,toLineInDataEx,toLineOutData,
                         toLinePlayBegin,toLinePlayEnd,toLineRing,toLineTimeout,toLineDtmf];

implementation

uses Windows, DateUtils,
     IdStack, IdDnsResolver,
     BisUtils, BisNetUtils;

function ResolveSipIPAndPort(Scheme,Transport,Host: String; var IP: String; var Port: Integer): Boolean;

  function ResolveA(Server,Target: String): Boolean;
  var
    Resolver: TIdDNSResolver;
    ResultRecord: TResultRecord;
    i: Integer;
    Rec: TARecord;
  begin
    Result:=false;
    try
      Resolver:=TIdDNSResolver.Create(nil);
      try
        Resolver.Host:=Server;
        Resolver.QueryType:=[qtA];
        Resolver.Resolve(Target);
        for i:=0 to Resolver.QueryResult.Count-1 do begin
          ResultRecord:=Resolver.QueryResult.Items[i];
          if ResultRecord is TARecord then begin
            Rec:=TARecord(ResultRecord);
            Result:=IsIP(Rec.IPAddress);
            if Result then begin
              IP:=Rec.IPAddress;
              exit;
            end;
          end;
        end;
      finally
        Resolver.Free;
      end;
    except
      //
    end;
  end;

  function ResolveService(Server: String): Boolean;
  var
    Resolver: TIdDNSResolver;
    ResultRecord: TResultRecord;
    Domain: String;
    i: Integer;
    Rec: TSRVRecord;
  begin
    Result:=false;
    try
      Resolver:=TIdDNSResolver.Create(nil);
      try
        Domain:=Format('_%s._%s.%s',[Scheme,Transport,Host]);
        Domain:=AnsiLowerCase(Domain);
        Resolver.Host:=Server;
        Resolver.QueryType:=[qtService];
        Resolver.Resolve(Domain);
        for i:=0 to Resolver.QueryResult.Count-1 do begin
          ResultRecord:=Resolver.QueryResult.Items[i];
          if ResultRecord is TSRVRecord then begin
            Rec:=TSRVRecord(ResultRecord);
            Result:=IsIP(Rec.Target);
            if not Result then
              Result:=ResolveA(Server,Rec.Target);
            if Result then begin
              Port:=Rec.Port;
              exit;
            end;
          end;
        end;
      finally
        Resolver.Free;
      end;
    except
      //
    end;
  end;

var
  Strings: TStringList;
  i: Integer;
begin
  Result:=false;
  if Trim(Host)<>'' then begin
    Strings:=TStringList.Create;
    try
      GetDNSList(Strings);
      for i:=0 to Strings.Count-1 do begin
        Result:=ResolveService(Strings[i]);
        if Result then
          exit;
      end;
    finally
      Strings.Free;
    end;
  end;
end;

function InOptions(Options: TBisSipPhoneThreadOptions; OptionSet: array of TBisSipPhoneThreadOption): Boolean;
var
  i: Integer;
begin
  Result:=false;
  for i:=Low(OptionSet) to High(OptionSet) do begin
    if OptionSet[i] in Options then
      Result:=true
    else begin
      Result:=false;
      break;
    end;  
  end;
end;

type
  TBisSipPhoneSyncMode=(smDoConnect,smDoDisconnect,smDoError,smDoSend,smDoReceive,smDoTimeout,
                        smDoLineCreate,smDoLineDestroy,smDoLineCheck,
                        smDoLineRing,smDoLineConnect,smDoLineInData,smDoLineInDataEx,
                        smDoLineOutData,smDoLineHold,smDoLineDisconnect,
                        smDoLinePlayBegin,smDoLinePlayEnd,smDoLineTimeout,smDoLineDtmf,smDoLineDetectBusy);

  TBisSipPhoneSync=class(TObject)
  private
    FPhone: TBisSipPhone;
    FMode: TBisSipPhoneSyncMode;
    FHost: String;
    FPort: Integer;
    FData: String;
    FError: String;
    FLine: TBisSipPhoneLine;
    FLineChecked: Boolean;
    FPointer: Pointer;
    FDataSize: Cardinal;
    FPacket: TBisRtpPacket;
    FRtpmap: TBisSdpRtpmapAttr;
    FMessage: TBisSipMessage;
    FCode: Char;
    procedure Sync;
    procedure Async;
    procedure DoMethod;
  public
    constructor Create(Phone: TBisSipPhone; Mode: TBisSipPhoneSyncMode; Line: TBisSipPhoneLine=nil);
    class procedure DoConnect(Phone: TBisSipPhone);
    class procedure DoDisconnect(Phone: TBisSipPhone);
    class procedure DoError(Phone: TBisSipPhone; const Error: String);
    class procedure DoSend(Phone: TBisSipPhone; Host: String; Port: Integer; Data: String);
    class procedure DoReceive(Phone: TBisSipPhone; Host: String; Port: Integer; Data: String);
    class procedure DoTimeout(Phone: TBisSipPhone);
    class procedure DoLineCreate(Phone: TBisSipPhone; Line: TBisSipPhoneLine);
    class procedure DoLineDestroy(Phone: TBisSipPhone; Line: TBisSipPhoneLine);
    class function DoLineCheck(Phone: TBisSipPhone; Line: TBisSipPhoneLine; Message: TBisSipMessage): Boolean;
    class procedure DoLineRing(Phone: TBisSipPhone; Line: TBisSipPhoneLine);
    class procedure DoLineConnect(Phone: TBisSipPhone; Line: TBisSipPhoneLine);
    class procedure DoLineInData(Phone: TBisSipPhone; Line: TBisSipPhoneLine; const Data: Pointer; const DataSize: Cardinal);
    class procedure DoLineInDataEx(Phone: TBisSipPhone; Line: TBisSipPhoneLine; Packet: TBisRtpPacket; Rtpmap: TBisSdpRtpmapAttr);
    class procedure DoLineOutData(Phone: TBisSipPhone; Line: TBisSipPhoneLine; const Data: Pointer; const DataSize: Cardinal);
    class procedure DoLineHold(Phone: TBisSipPhone; Line: TBisSipPhoneLine);
    class procedure DoLineDisconnect(Phone: TBisSipPhone; Line: TBisSipPhoneLine);
    class procedure DoLinePlayBegin(Phone: TBisSipPhone; Line: TBisSipPhoneLine);
    class procedure DoLinePlayEnd(Phone: TBisSipPhone; Line: TBisSipPhoneLine);
    class procedure DoLineDtmf(Phone: TBisSipPhone; Line: TBisSipPhoneLine; const Code: Char);
    class procedure DoLineDetectBusy(Phone: TBisSipPhone; Line: TBisSipPhoneLine);
  end;

{ TBisSipPhoneSync }

constructor TBisSipPhoneSync.Create(Phone: TBisSipPhone; Mode: TBisSipPhoneSyncMode; Line: TBisSipPhoneLine=nil);
begin
  inherited Create;
  FPhone:=Phone;
  FMode:=Mode;
  FLine:=Line;
end;

procedure TBisSipPhoneSync.Sync;
begin
  TBisThread.StaticSynchronize(DoMethod);
end;

procedure TBisSipPhoneSync.Async;
begin
  TBisThread.StaticQueue(DoMethod);
end;

procedure TBisSipPhoneSync.DoMethod;
begin
  try
    if Assigned(FPhone) then
      case FMode of
        smDoConnect: if Assigned(FPhone.OnConnect) then FPhone.OnConnect(FPhone);
        smDoDisconnect: if Assigned(FPhone.OnDisconnect) then FPhone.OnDisconnect(FPhone);
        smDoError: if Assigned(FPhone.OnError) then FPhone.OnError(FPhone,FError);
        smDoSend: if Assigned(FPhone.OnSend) then FPhone.OnSend(FPhone,FHost,FPort,FData);
        smDoReceive: if Assigned(FPhone.OnReceive) then FPhone.OnReceive(FPhone,FHost,FPort,FData);
        smDoTimeout: if Assigned(FPhone.OnTimeout) then FPhone.OnTimeout(FPhone);
        smDoLineCheck: if Assigned(FPhone.OnLineCheck) then FLineChecked:=FPhone.OnLineCheck(FPhone,FLine,FMessage);
        smDoLineConnect: if Assigned(FPhone.OnLineConnect) then FPhone.OnLineConnect(FPhone,FLine);
        smDoLineCreate: if Assigned(FPhone.OnLineCreate) then FPhone.OnLineCreate(FPhone,FLine);
        smDoLineDestroy: if Assigned(FPhone.OnLineDestroy) then FPhone.OnLineDestroy(FPhone,FLine);
        smDoLineDisconnect: if Assigned(FPhone.OnLineDisconnect) then FPhone.OnLineDisconnect(FPhone,FLine);
        smDoLineHold: if Assigned(FPhone.OnLineHold) then FPhone.OnLineHold(FPhone,FLine);
        smDoLineInData: if Assigned(FPhone.OnLineInData) then FPhone.OnLineInData(FPhone,FLine,FPointer,FDataSize);
        smDoLineInDataEx: if Assigned(FPhone.OnLineInDataEx) then FPhone.OnLineInDataEx(FPhone,FLine,FPacket,FRtpmap);
        smDoLineOutData: if Assigned(FPhone.OnLineOutData) then FPhone.OnLineOutData(FPhone,FLine,FPointer,FDataSize);
        smDoLinePlayBegin: if Assigned(FPhone.OnLinePlayBegin) then FPhone.OnLinePlayBegin(FPhone,FLine);
        smDoLinePlayEnd: if Assigned(FPhone.OnLinePlayEnd) then FPhone.OnLinePlayEnd(FPhone,FLine);
        smDoLineRing: if Assigned(FPhone.OnLineRing) then FPhone.OnLineRing(FPhone,FLine);
        smDoLineTimeout: ;
        smDoLineDtmf: if Assigned(FPhone.OnLineDtmf) then FPhone.OnLineDtmf(FPhone,FLine,FCode);
        smDoLineDetectBusy: if Assigned(FPhone.OnLineDetectBusy) then FPhone.OnLineDetectBusy(FPhone,FLine);
      end;
  finally
    Free;
  end;
end;

class procedure TBisSipPhoneSync.DoConnect(Phone: TBisSipPhone);
begin
  if Assigned(Phone.OnConnect) then
    if not (toConnect in Phone.ThreadOptions) and not IsMainThread then begin
      with Create(Phone,smDoConnect) do
        Sync;                                                                               
    end else
      Phone.OnConnect(Phone);
end;

class procedure TBisSipPhoneSync.DoDisconnect(Phone: TBisSipPhone);
begin
  if Assigned(Phone.OnDisconnect) then
    if not (toDisconnect in Phone.ThreadOptions) and not IsMainThread then begin
      with Create(Phone,smDoDisconnect) do
        Sync;
    end else
      Phone.OnDisconnect(Phone);
end;

class procedure TBisSipPhoneSync.DoError(Phone: TBisSipPhone; const Error: String);
begin
  if Assigned(Phone.OnError) then
    if not (toError in Phone.ThreadOptions) and not IsMainThread then begin
      with Create(Phone,smDoError) do begin
        FError:=Error;
        Async;
      end;
    end else
      Phone.OnError(Phone,Error);
end;

class procedure TBisSipPhoneSync.DoSend(Phone: TBisSipPhone; Host: String; Port: Integer; Data: String);
begin
  if Assigned(Phone.OnSend) then
    if not (toSend in Phone.ThreadOptions) and not IsMainThread then begin
      with Create(Phone,smDoSend) do begin
        FHost:=Host;
        FPort:=Port;
        FData:=Data;
        Async;
      end;
    end else
      Phone.OnSend(Phone,Host,Port,Data);
end;

class procedure TBisSipPhoneSync.DoReceive(Phone: TBisSipPhone; Host: String; Port: Integer; Data: String);
begin
  if Assigned(Phone.OnReceive) then
    if not (toReceive in Phone.ThreadOptions) and not IsMainThread then begin
      with Create(Phone,smDoReceive) do begin
        FHost:=Host;
        FPort:=Port;
        FData:=Data;
        Async;
      end;
    end else
      Phone.OnReceive(Phone,Host,Port,Data);
end;

class procedure TBisSipPhoneSync.DoTimeout(Phone: TBisSipPhone);
begin
  if Assigned(Phone.OnTimeout) then
    if not (toTimeout in Phone.ThreadOptions) and not IsMainThread then begin
      with Create(Phone,smDoTimeout) do
        Async;
    end else
      Phone.OnTimeout(Phone);
end;

class function TBisSipPhoneSync.DoLineCheck(Phone: TBisSipPhone; Line: TBisSipPhoneLine; Message: TBisSipMessage): Boolean;
begin
  Result:=true;
  if Assigned(Phone.OnLineCheck) then
    if not (toLineCheck in Phone.ThreadOptions) and not IsMainThread then begin
      with Create(Phone,smDoLineCheck,Line) do begin
        FLineChecked:=false;
        FMessage:=Message;
        Sync;
        Result:=FLineChecked;
      end;
    end else
      Result:=Phone.OnLineCheck(Phone,Line,Message);
end;

class procedure TBisSipPhoneSync.DoLineConnect(Phone: TBisSipPhone; Line: TBisSipPhoneLine);
begin
  if Assigned(Phone.OnLineConnect) then
    if not (toLineConnect in Phone.ThreadOptions) and not IsMainThread then begin
      with Create(Phone,smDoLineConnect,Line) do
        Sync;
    end else
      Phone.OnLineConnect(Phone,Line);
end;

class procedure TBisSipPhoneSync.DoLineCreate(Phone: TBisSipPhone; Line: TBisSipPhoneLine);
begin
  if Assigned(Phone.OnLineCreate) then
    if not (toLineCreate in Phone.ThreadOptions) and not IsMainThread then begin
      with Create(Phone,smDoLineCreate,Line) do
        Sync;
    end else
      Phone.OnLineCreate(Phone,Line);
end;

class procedure TBisSipPhoneSync.DoLineDestroy(Phone: TBisSipPhone; Line: TBisSipPhoneLine);
begin
  if Assigned(Phone.OnLineDestroy) then
    if not (toLineDestroy in Phone.ThreadOptions) and not IsMainThread then begin
      with Create(Phone,smDoLineDestroy,Line) do
        Sync;
    end else
      Phone.OnLineDestroy(Phone,Line);
end;

class procedure TBisSipPhoneSync.DoLineDisconnect(Phone: TBisSipPhone; Line: TBisSipPhoneLine);
begin
  if Assigned(Phone.OnLineDisconnect) then
    if not (toLineDisconnect in Phone.ThreadOptions) and not IsMainThread then begin
      with Create(Phone,smDoLineDisconnect,Line) do
        Sync;
    end else
      Phone.OnLineDisconnect(Phone,Line);
end;

class procedure TBisSipPhoneSync.DoLineHold(Phone: TBisSipPhone; Line: TBisSipPhoneLine);
begin
  if Assigned(Phone.OnLineHold) then
    if not (toLineHold in Phone.ThreadOptions) and not IsMainThread then begin
      with Create(Phone,smDoLineHold,Line) do
        Async;
    end else
      Phone.OnLineHold(Phone,Line);
end;

class procedure TBisSipPhoneSync.DoLineInData(Phone: TBisSipPhone; Line: TBisSipPhoneLine; const Data: Pointer;
                                              const DataSize: Cardinal);
begin
  if Assigned(Phone.OnLineInData) then
    if not (toLineInData in Phone.ThreadOptions) and not IsMainThread then begin
      with Create(Phone,smDoLineInData,Line) do begin
        FPointer:=Data;
        FDataSize:=DataSize;
        Sync;
      end;
    end else
      Phone.OnLineInData(Phone,Line,Data,DataSize);
end;

class procedure TBisSipPhoneSync.DoLineInDataEx(Phone: TBisSipPhone; Line: TBisSipPhoneLine; Packet: TBisRtpPacket;
                                                Rtpmap: TBisSdpRtpmapAttr);
begin
  if Assigned(Phone.OnLineInDataEx) then
    if not (toLineInDataEx in Phone.ThreadOptions) and not IsMainThread then begin
      with Create(Phone,smDoLineInDataEx,Line) do begin
        FPacket:=Packet;
        FRtpmap:=Rtpmap;
        Sync;
      end;
    end else
      Phone.OnLineInDataEx(Phone,Line,Packet,Rtpmap);
end;

class procedure TBisSipPhoneSync.DoLineOutData(Phone: TBisSipPhone; Line: TBisSipPhoneLine; const Data: Pointer;
                                               const DataSize: Cardinal);
begin
  if Assigned(Phone.OnLineOutData) then
    if not (toLineOutData in Phone.ThreadOptions) and not IsMainThread then begin
      with Create(Phone,smDoLineOutData,Line) do begin
        FPointer:=Data;
        FDataSize:=DataSize;
        Sync;
      end;
    end else
      Phone.OnLineOutData(Phone,Line,Data,DataSize);
end;

class procedure TBisSipPhoneSync.DoLinePlayBegin(Phone: TBisSipPhone; Line: TBisSipPhoneLine);
begin
  if Assigned(Phone.OnLinePlayBegin) then
    if not (toLinePlayBegin in Phone.ThreadOptions) and not IsMainThread then begin
      with Create(Phone,smDoLinePlayBegin,Line) do
        Async;
    end else
      Phone.OnLinePlayBegin(Phone,Line);
end;

class procedure TBisSipPhoneSync.DoLinePlayEnd(Phone: TBisSipPhone; Line: TBisSipPhoneLine);
begin
  if Assigned(Phone.OnLinePlayEnd) then
    if not (toLinePlayEnd in Phone.ThreadOptions) and not IsMainThread then begin
      with Create(Phone,smDoLinePlayEnd,Line) do
        Async;
    end else
      Phone.OnLinePlayEnd(Phone,Line);
end;

class procedure TBisSipPhoneSync.DoLineRing(Phone: TBisSipPhone; Line: TBisSipPhoneLine);
begin
  if Assigned(Phone.OnLineRing) then
    if not (toLineRing in Phone.ThreadOptions) and not IsMainThread then begin
      with Create(Phone,smDoLineRing,Line) do
        Sync;
    end else
      Phone.OnLineRing(Phone,Line);
end;

class procedure TBisSipPhoneSync.DoLineDtmf(Phone: TBisSipPhone; Line: TBisSipPhoneLine; const Code: Char);
begin
  if Assigned(Phone.OnLineDtmf) then
    if not (toLineDtmf in Phone.ThreadOptions) and not IsMainThread then begin
      with Create(Phone,smDoLineDtmf,Line) do begin
        FCode:=Code;
        Async;
      end;
    end else
      Phone.OnLineDtmf(Phone,Line,Code);
end;

class procedure TBisSipPhoneSync.DoLineDetectBusy(Phone: TBisSipPhone; Line: TBisSipPhoneLine);
begin
  if Assigned(Phone.OnLineDetectBusy) then
    if not (toLineDetectBusy in Phone.ThreadOptions) and not IsMainThread then begin
      with Create(Phone,smDoLineDetectBusy,Line) do
        Async;
    end else
      Phone.OnLineDetectBusy(Phone,Line);
end;

{ TBisSipPhoneLineUdpServer }

constructor TBisSipPhoneLineUdpServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TBisSipPhoneLineUdpServer.Destroy;
begin
  FOnUDPRead:=nil;
  inherited Destroy;
end;

function TBisSipPhoneLineUdpServer.GetBinding: TIdSocketHandle;
begin
  Result:=inherited GetBinding;
  if Assigned(FListenerThread) then begin
    FListenerThread.Priority:=tpHigher;
  end;
end;

type
  TBisSipPhoneLineOutThread=class(TBisWaitThread)
  end;

  TBisSipPhoneLineDtmfThread=class(TBisWaitThread)
  end;

  TBisSipPhoneLineDetectBusyThread=class(TBisWaitThread)
  end;

{ TBisSipPhoneLine }

constructor TBisSipPhoneLine.Create(Phone: TBisSipPhone);
var
  DataSize: Cardinal;
begin
  inherited Create;
  FPhone:=Phone;

//FDialTimeout:=FPhone.FDialTimeout;
//FTalkTimeout:=FPhone.FTalkTimeout;

  FServer:=TBisSipPhoneLineUdpServer.Create(nil);
  FServer.OnUDPRead:=ServerUDPRead;
  FServer.OnUDPException:=ServerUDPException;
  FServer.ThreadedEvent:=true;
  FServer.ThreadName:='SipPhoneLineIn';

  FBinding:=FServer.Bindings.Add;

  FDtmfEnabled:=FPhone.FDtmfEnabled;

  FDtmfStream:=TMemoryStream.Create;

  SetPCMAudioFormatS(@FDtmfFormat,Mono16bit8000Hz);

  FDtmf:=TBisAudioDtmf.Create(nil);
  FDtmf.Threshold:=FPhone.FDtmfThreshold;
  FDtmf.OnCode:=DtmfCode;
  FDtmf.SetFormat(@FDtmfFormat);

  FDtmfThread:=TBisSipPhoneLineDtmfThread.Create(FPhone.FDtmfTimeout);
  FDtmfThread.StopOnDestroy:=true;
  FDtmfThread.OnTimeout:=DtmfThreadTimeout;

  FDtmfPeriod:=100;

  FDetectBusyEnabled:=FPhone.FDetectBusyEnabled;

  FDetectBusyStream:=TMemoryStream.Create;

  SetPCMAudioFormatS(@FDetectBusyFormat,Mono16bit8000Hz);

  FDetectBusy:=TBisAudioSpectrum.Create;
  FDetectBusy.Threshold:=FPhone.FDetectBusyThreshold;
  FDetectBusy.LowFreq:=410;
  FDetectBusy.HighFreq:=440;
  FDetectBusy.OnDetect:=DetectBusyDetect;
  FDetectBusy.SetFormat(@FDetectBusyFormat);

  DataSize:=FDetectBusy.WindowSize*FDetectBusyFormat.nChannels*(FDetectBusyFormat.wBitsPerSample div 8);

  FDetectBusyPeriod:=GetWaveAudioLength(@FDetectBusyFormat,DataSize);

  FDetectBusyThread:=TBisSipPhoneLineDetectBusyThread.Create(FPhone.FDetectBusyTimeout);
  FDetectBusyThread.StopOnDestroy:=true;
  FDetectBusyThread.OnTimeout:=DetectBusyThreadTimeout;

  FDetectBusyMaxCount:=FPhone.FDetectBusyMaxCount;
  FDetectBusyCount:=0;

  FRemotePackets:=TBisRtpPackets.Create;
  FLocalPackets:=TBisRtpPackets.Create;

  FRemoteRtpmaps:=TBisSdp.Create;

  FLocalSessionId:=Integer(Self);
  FLocalSessionVersion:=0;
  FLocalEmptyAddress:=FPhone.FClient.Transport.DefaultIP;

  FRemoteDriverFormat:=nil;

  FLocalChannels:=FPhone.FAudioChannels;
  FLocalSamplesPerSec:=FPhone.FAudioSamplesPerSec;
  FLocalBitsPerSample:=FPhone.FAudioBitsPerSample;
  FLocalDriverFormat:=FPhone.FDrivers.FindFormat(FPhone.FAudioDriverName,FPhone.FAudioFormatName,
                                                 FLocalChannels,FLocalSamplesPerSec,FLocalBitsPerSample);
  FLocalPayloadType:=FPhone.FDrivers.FormatToPayloadType(FLocalDriverFormat);
  FLocalEncondingType:=TBisSdpRtpmapAttr.PayloadTypeToEncodingType(FLocalPayloadType);
  FLocalPacketTime:=GetPacketTime(FLocalPayloadType,FLocalBitsPerSample,FLocalChannels);
  FLocalPayloadLength:=GetPayloadLength(FLocalPayloadType,FLocalPacketTime,FLocalBitsPerSample,FLocalChannels);
  FLocalSilenceChar:=#0;
  FLocalBufferSize:=150; // in milliseconds

  FOutThread:=TBisSipPhoneLineOutThread.Create;
  FOutThread.StopOnDestroy:=true;
  FOutThread.OnBegin:=OutThreadBegin;
  FOutThread.OnEnd:=OutThreadEnd;
  FOutThread.OnError:=OutThreadError;
  FOutThread.OnTimeout:=OutThreadTimeout;
  FOutThread.RestrictByZero:=true;
  FOutThread.Priority:=tpHigher;

  FOutStream:=TMemoryStream.Create;
  FOutLock:=TCriticalSection.Create;

  Randomize;
  FSequence:=Random(MaxByte);
  FSSRCIdentifier:=Random(MaxInt);

  FCheckRemoteIP:=true;

end;

destructor TBisSipPhoneLine.Destroy;
begin                                           
  Include(FStates,lsDestroying);
  Hangup;
  FSession:=nil;
  FServer.OnUDPRead:=nil;
  FServer.Active:=false;
  FOutThread.Free;
  FOutLock.Free;
  FOutStream.Free;
  FRemoteRtpmaps.Free;
  FLocalPackets.Free;
  FRemotePackets.Free;
  FDetectBusyThread.Free;
  FDetectBusy.Free;
  FDetectBusyStream.Free;
  FDtmfThread.Free;
  FDtmf.Free;
  FDtmfStream.Free;
  FServer.Free;
  inherited Destroy;
end;

function TBisSipPhoneLine.HasFreshData: Boolean;
begin
  Result:=GetTickDifference(FLastTick,FLastFreq,dtMilliSec)<=FRemotePacketTime*10;
end;

procedure TBisSipPhoneLine.TalkStamp;
begin
  FTalkTick:=GetTickCount(FTalkFreq);
end;

procedure TBisSipPhoneLine.DialStamp;
begin
  FDialTick:=GetTickCount(FDialFreq);
end;

function TBisSipPhoneLine.ReadyForDestroy: Boolean;
var
  Flag: Boolean;
begin
  Result:=not Assigned(FSession) or
          (Assigned(FSession) and (FSession.State in [ssDestroying]));
  if not Result and Assigned(FSession) then begin
    Flag:=false;
    case FSession.State of
      ssReady: ;
      ssWaiting,ssTrying,ssRinging,ssConfirming,ssProgressing: begin
{       if lsRinging in FStates then
          Flag:=GetTickDifference(FDialTick,FDialFreq,dtMilliSec)>=FDialTimeout;}
      end;
      ssProcessing: begin
//      Flag:=GetTickDifference(FTalkTick,FTalkFreq,dtMilliSec)>=FTalkTimeout;
        if not Flag then
          Flag:=not HasFreshData;
      end;
      ssBreaking: begin
        Flag:=true
      end;
    end;                                   
    if Flag then
      Hangup;
  end;
end;

procedure TBisSipPhoneLine.DtmfCode(Sender: TObject; const Code: Char);
begin
  if not FDtmfThread.Exists then
    if FDtmfThread.TryLock then begin
      try
        FDtmfCode:=Code;
        FDtmfThread.Start;
      finally
        FDtmfThread.UnLock;
      end;
    end;
end;

procedure TBisSipPhoneLine.DtmfThreadTimeout(Thread: TBisWaitThread);
begin
  TBisSipPhoneSync.DoLineDtmf(FPhone,Self,FDtmfCode);
end;

procedure TBisSipPhoneLine.DetectBusyClear;
begin
  FDetectBusyCount:=0;
  FDetectBusyStream.Clear;
  FDetectBusyThread.Stop;
end;

procedure TBisSipPhoneLine.DetectBusyDetect(Sender: TBisAudioSpectrum; const Freq: Word; const Level: Integer);
begin
  if not FDetectBusyThread.Exists then
    if FDetectBusyThread.TryLock then begin
      try
        if FDetectBusyCount=0 then
          FDetectBusyTick:=GetTickCount(FDetectBusyFreq);
        FDetectBusyThread.Start;
      finally
        FDetectBusyThread.UnLock;
      end;
    end;
end;

procedure TBisSipPhoneLine.DetectBusyThreadTimeout(Thread: TBisWaitThread);
begin
  Inc(FDetectBusyCount);
  if FDetectBusyCount>=FDetectBusyMaxCount then
    Hangup
  else
    TBisSipPhoneSync.DoLineDetectBusy(FPhone,Self);
end;

procedure TBisSipPhoneLine.OutThreadBegin(Thread: TBisThread);
begin
  Include(FStates,lsPlaying);
  TBisSipPhoneSync.DoLinePlayBegin(FPhone,Self);
end;

procedure TBisSipPhoneLine.OutThreadEnd(Thread: TBisThread);
begin
  try
    TBisSipPhoneSync.DoLinePlayEnd(FPhone,Self);
  finally
    Exclude(FStates,lsPlaying);
  end;
end;

procedure TBisSipPhoneLine.OutThreadError(Thread: TBisThread; const E: Exception);
begin
  if Assigned(E) then
    TBisSipPhoneSync.DoError(FPhone,E.Message);
end;

procedure TBisSipPhoneLine.OutThreadTimeout(Thread: TBisWaitThread);
var
  L: Cardinal;
  LSize: Int64;
  Data: TBytes;
  MaxSize: Cardinal;
begin
  FOutLock.Enter;
  try
    L:=FLocalPayloadLength;
    LSize:=FOutStream.Size-FOutStream.Position;

    if (FOutLoopCount=0) then begin
      MaxSize:=Round((L*(FLocalBufferSize))/FLocalPacketTime);
      if LSize>=MaxSize then begin
        LSize:=MaxSize;
        FOutStream.Position:=FOutStream.Size-MaxSize;
      end;
    end;

    if L>0 then begin
      SetLength(Data,L);
      FillChar(Pointer(Data)^,L,FLocalSilenceChar);
      if LSize<L then
        L:=LSize;
      L:=FOutStream.Read(Pointer(Data)^,L);
      if L>0 then
        Send(Data,true);
    end;

    if (FOutStream.Position<FOutStream.Size) or (FOutLoopCount=0) then
      Thread.Reset
    else begin
      Inc(FOutCounter);
      if FOutLoopCount>FOutCounter then begin
        FOutStream.Position:=0;
        Thread.Reset;
      end;
    end;
  finally
    FOutLock.Leave;
  end;
end;

procedure TBisSipPhoneLine.PlayStream(Stream: TStream);
var
  Old1,Old2: Int64;
begin
  if Assigned(Stream) then begin
    FOutLock.Enter;
    Old1:=Stream.Position;
    Old2:=FOutStream.Position;
    try
      FOutStream.Position:=FOutStream.Size;
      FOutStream.CopyFrom(Stream,Stream.Size-Old1);
    finally
      FOutStream.Position:=Old2;
      Stream.Position:=Old1;
      FOutLock.Leave;
    end;
  end;
end;

procedure TBisSipPhoneLine.PlayData(const Data: Pointer; const DataSize: Cardinal);
var
  Old: Int64;
begin
  if Assigned(Data) and (DataSize>0) then begin
    FOutLock.Enter;
    Old:=FOutStream.Position;
    try
      FOutStream.Position:=FOutStream.Size;
      FOutStream.Write(Pointer(Data)^,DataSize);
    finally
      FOutStream.Position:=Old;
      FOutLock.Leave;
    end;
  end;
end;

procedure TBisSipPhoneLine.PlayDtmfString(const S: String; Period: Cardinal);
var
  ASize: Cardinal;
  i: Integer;
  Dtmf: String;
  Converter: TWaveConverter;
  Stream: TMemoryStream;
begin
  if (Length(S)>0) and (Period>0) and Assigned(FLocalDriverFormat) then begin
    Converter:=TWaveConverter.Create;
    Stream:=TMemoryStream.Create;
    try
    
      ASize:=FDtmfFormat.wBitsPerSample*Period;
      for i:=1 to Length(S) do begin
        Dtmf:='';
        Converter.Clear;
        Converter.BeginRewrite(@FDtmfFormat);
        if not GetDtmfEvent(S[i],FDtmfFormat.nSamplesPerSec,ASize,Dtmf) then begin
          SetLength(Dtmf,ASize);
          SilenceWaveAudio(Pointer(Dtmf),ASize,@FDtmfFormat);
        end;
        Converter.Write(Pointer(Dtmf)^,Length(Dtmf));
        Converter.EndRewrite;
        if Converter.ConvertTo(FLocalDriverFormat.WaveFormat) then begin
          Converter.Stream.Position:=Converter.DataOffset;
          Stream.CopyFrom(Converter.Stream,Converter.Stream.Size-Converter.Stream.Position);
        end;
      end;

      if Stream.Size>0 then
        PlayStream(Stream);

    finally
      Stream.Free;
      Converter.Free;
    end;
  end;
end;

procedure TBisSipPhoneLine.PlayStart(LoopCount: Cardinal);
begin
  PlayStop;
  if Active then begin
    FOutLock.Enter;
    try
      FOutStream.Clear;
      FOutLoopCount:=LoopCount;
      FOutCounter:=0;
      FOutThread.Timeout:=FLocalPacketTime;
      FOutThread.Start;
    finally
      FOutLock.Leave;
    end;
  end;
end;

procedure TBisSipPhoneLine.PlayStop;
begin
  FOutThread.Stop;
end;

function TBisSipPhoneLine.GetActive: Boolean;
begin
  Result:=FServer.Active and Assigned(FSession);
  if Result then begin
    Result:=(FSession.State in [ssProcessing,ssConfirming]);
  end;
end;

function TBisSipPhoneLine.GetDirection: TBisSipPhoneLineDirection;
begin
  Result:=ldUnknown;
  if Assigned(FSession) then begin
    case FSession.Direction of
      sdIncoming: Result:=ldIncoming;
      sdOutgoing: Result:=ldOutgoing;
    end;
  end;
end;

function TBisSipPhoneLine.GetRemoteFormat: PWaveFormatEx;
begin
  Result:=nil;
  if Assigned(FRemoteDriverFormat) then
    Result:=FRemoteDriverFormat.WaveFormat;
end;

function TBisSipPhoneLine.GetInThread: TThread;
begin
  Result:=FServer.FListenerThread;
end;

function TBisSipPhoneLine.GetLocalFormat: PWaveFormatEx;
begin
  Result:=nil;
  if Assigned(FLocalDriverFormat) then
    Result:=FLocalDriverFormat.WaveFormat;
end;

function TBisSipPhoneLine.SetContent(Content: String): Boolean;

  function SetApplicationSdp: Boolean;
  var
    Origin: TBisSdpOrigin;
    Media: TBisSdpMedia;
    Connection: TBisSdpConnection;
    RtpmapAttr: TBisSdpRtpmapAttr;
    NewRtpmapAttr: TBisSdpRtpmapAttr;
    PtimeAttr: TBisSdpPtimeAttr;
    ModeAttr: TBisSdpModeAttr;
    Sdp, List: TBisSdp;
    i: Integer;
  begin
    Result:=Assigned(FRemoteDriverFormat);
    if Trim(Content)<>'' then begin
      Sdp:=TBisSdp.Create;
      List:=TBisSdp.Create;
      try
        List.OwnsObjects:=false;

        Sdp.Parse(Content);

        Origin:=TBisSdpOrigin(Sdp.Find(TBisSdpOrigin));
        if Assigned(Origin) then begin
          FRemoteSessionId:=Origin.SessionId;
          FRemoteSessionVersion:=Origin.SessionVersion;
        end;

        Media:=TBisSdpMedia(Sdp.Find(TBisSdpMedia));
        if Assigned(Media) then begin
          FRemotePort:=Media.Port;
          FRemoteFormat:=Media.Formats.Text;

          Result:=(Media.MediaType=mtAudio) and (Media.ProtoType=mptRTPAVP);
        end;

        if Result then begin

          Connection:=TBisSdpConnection(Sdp.Find(TBisSdpConnection));
          if Assigned(Connection) then begin
            FRemoteHost:=Connection.Address;
            FRemoteIP:=FRemoteHost;
          end;

          FRemoteDriverFormat:=nil;

          FRemoteRtpmaps.Lock;
          try
            FRemoteRtpmaps.Clear;

            Sdp.GetDescs(TBisSdpRtpmapAttr,List);

            for i:=0 to List.Count-1 do begin
              RtpmapAttr:=TBisSdpRtpmapAttr(List.Items[i]);

              if not Assigned(FRemoteDriverFormat) then begin
                FRemotePayloadType:=RtpmapAttr.PayloadType;
                FRemoteChannels:=RtpmapAttr.Channels;
                FRemoteSamplesPerSec:=RtpmapAttr.SamplesPerSec;
                FRemoteBitsPerSample:=RtpmapAttr.BitsPerSample;
                FRemoteDriverFormat:=FPhone.FDrivers.FindFormat(FRemotePayloadType,FRemoteChannels,
                                                                FRemoteSamplesPerSec,FRemoteBitsPerSample);
                FRemotePayloadLength:=GetPayloadLength(FRemotePayloadType,FRemotePacketTime,FRemoteBitsPerSample,FRemoteChannels);
              end;

              if Assigned(FRemoteDriverFormat) then begin
                NewRtpmapAttr:=TBisSdpRtpmapAttr.Create;
                NewRtpmapAttr.CopyFrom(RtpmapAttr);
                FRemoteRtpmaps.Add(NewRtpmapAttr);
              end;
            end;
          finally
            FRemoteRtpmaps.UnLock;
          end;

          PtimeAttr:=TBisSdpPtimeAttr(Sdp.Find(TBisSdpPtimeAttr));
          if Assigned(PtimeAttr) then
            FRemotePacketTime:=PtimeAttr.Value;

          ModeAttr:=TBisSdpModeAttr(Sdp.Find(TBisSdpModeAttr));
          if Assigned(ModeAttr) then
            FRemoteModeType:=ModeAttr.ModeType;

          Result:=Assigned(FRemoteDriverFormat);
        end;
      finally
        List.Free;
        Sdp.Free;
      end;
    end;
  end;

begin
  Result:=false;
  if Assigned(FSession) then begin
    case FSession.ContentTypeKind of
      ctkUnknown: ;
      ctkApplicationSdp: Result:=SetApplicationSdp;
    end;
  end;
end;

function TBisSipPhoneLine.SendPacket(Packet: TBisRtpPacket; WithAdd: Boolean): Boolean;
var
  Data: String;
begin
  Result:=false;
  if Active and Assigned(Packet) then begin
    if Packet.GetData(Data) then begin
      FServer.Send(FRemoteIP,FRemotePort,Data);
      if WithAdd and FPhone.FCollectLocalPackets then
        FLocalPackets.LockAdd(Packet);
      Result:=true;
    end;
  end;
end;

procedure TBisSipPhoneLine.SendConfirm;
var
  i: Integer;
  Packet: TBisRtpPacket;
  L: Integer;
  Data: TBytes;
  Sent: Boolean;
begin
  if Active then begin
    L:=GetPayloadLength(FLocalPayloadType,FLocalPacketTime,FLocalBitsPerSample,FLocalChannels);
    if L>0 then begin
      SetLength(Data,L);
      FTimeStamp:=Windows.GetTickCount;
      
      for i:=0 to FPhone.FConfirmCount-1 do begin
        Sent:=false;
        FillChar(Pointer(Data)^,L,i);

        Packet:=TBisRtpPacket.Create;
        try
          Packet.Version:=vSecond;
          Packet.Padding:=false;
          Packet.Extension:=false;
          Packet.Marker:=false;
          Packet.PayloadType:=FLocalPayloadType;
          Packet.Sequence:=FSequence;
          Packet.TimeStamp:=FTimeStamp;
          Packet.SSRCIdentifier:=FSSRCIdentifier;
          Packet.ExternalHeader:=ToBytes('');
          Packet.Payload:=Data;

          Sent:=SendPacket(Packet,false);
          if Sent then begin
            Inc(FSequence);
            Inc(FTimeStamp,L);
          end else begin
            break;
          end;

        finally
          if not Sent then
            Packet.Free;
        end;
      end;
    end;
  end;
end;

function TBisSipPhoneLine.GetPacketTime(PayloadType: TBisRtpPacketPayloadType; BitsPerSample, Channels: Word): Word;
begin
  Result:=0;
  case PayloadType of
    ptPCMU,ptPCMA,ptGSM: Result:=20;
  end;
end;

function TBisSipPhoneLine.GetPayloadLength(PayloadType: TBisRtpPacketPayloadType; PacketTime, BitsPerSample, Channels: Word): LongWord;
begin
  Result:=0;
  case PayloadType of
    ptPCMU,ptPCMA,ptGSM: Result:=PacketTime*BitsPerSample*Channels;
  end;
end;

function TBisSipPhoneLine.DefaultRemotePacket(Packet: TBisRtpPacket): Boolean;
var
  L: Integer;
begin
  Result:=(Packet.Version=vSecond) and
          (Packet.PayloadType=FRemotePayloadType);
  if Result then begin
    L:=GetPayloadLength(FRemotePayloadType,FRemotePacketTime,FRemoteBitsPerSample,FRemoteChannels);
    Result:=Length(Packet.Payload)=L;
  end;
end;

procedure TBisSipPhoneLine.Send(Data: TBytes; Event: Boolean);
var
  L: Integer;
  Packet: TBisRtpPacket;
  Sent: Boolean;
begin
  try
    L:=Length(Data);
    if L>0 then begin
      Sent:=false;
      Packet:=TBisRtpPacket.Create;
      try
        Packet.Version:=vSecond;
        Packet.Padding:=false;
        Packet.Extension:=false;
        Packet.Marker:=false;
        Packet.PayloadType:=FLocalPayloadType;
        Packet.Sequence:=FSequence;
        Packet.TimeStamp:=FTimeStamp;
        Packet.SSRCIdentifier:=FSSRCIdentifier;
        Packet.ExternalHeader:=ToBytes('');
        Packet.Payload:=Data;

        Sent:=SendPacket(Packet,true);
        if Sent then begin
          Inc(FSequence);
          Inc(FTimeStamp,L);

          if Event then
            TBisSipPhoneSync.DoLineOutData(FPhone,Self,Pointer(Packet.Payload),Length(Packet.Payload));
        end;

      finally
        if not Sent then
          Packet.Free;
      end;
    end;
  except
    On E: Exception do
      TBisSipPhoneSync.DoError(FPhone,E.Message);
  end;
end;

procedure TBisSipPhoneLine.Send(const Data: Pointer; const DataSize: Cardinal; Event: Boolean);
var
  D: TBytes;
begin
  if DataSize>0 then begin
    SetLength(D,DataSize);
    Move(Data^,Pointer(D)^,DataSize);
    Send(D,Event);
  end;
end;

procedure TBisSipPhoneLine.ServerUDPException(Sender: TObject; ABinding: TIdSocketHandle; const AMessage: String;
                                              const AExceptionClass: TClass);
begin
  if Assigned(FPhone) and (Trim(AMessage)<>'') then
    TBisSipPhoneSync.DoError(FPhone,AMessage);
end;

procedure TBisSipPhoneLine.ServerUDPRead(Sender: TObject; AData: TIdBytes; ABinding: TIdSocketHandle);
var
  Packet: TBisRtpPacket;

  procedure LoadDtmf;
  var
    Converter: TWaveConverter;
    ASize,NeedSize: Int64;
  begin
    if not FDtmfThread.Exists then begin
      try
        Converter:=TWaveConverter.Create;
        try
          Converter.BeginRewrite(FRemoteDriverFormat.WaveFormat);
          Converter.Write(Pointer(Packet.Payload)^,Length(Packet.Payload));
          Converter.EndRewrite;
          if Converter.ConvertTo(@FDtmfFormat) then begin
            Converter.Stream.Position:=Converter.DataOffset;
            ASize:=Converter.Stream.Size-Converter.Stream.Position;
            if ASize>0 then begin
              FDtmfStream.Position:=FDtmfStream.Size;
              FDtmfStream.CopyFrom(Converter.Stream,ASize);
              NeedSize:=Round((ASize*FDtmfPeriod)/FRemotePacketTime);
              if (FDtmfStream.Size>=NeedSize) then begin
                FDtmfStream.Position:=FDtmfStream.Size-NeedSize;
                FDtmf.LoadFromStream(FDtmfStream);
                FDtmfStream.Clear;
              end;
            end;
          end;
        finally
          Converter.Free;
        end;
      except
        On E: Exception do
          TBisSipPhoneSync.DoError(FPhone,E.Message);
      end;
    end;
  end;

  procedure LoadDetectBusy;

    function NeedDetectBusy: Boolean;
    var
      Diff: Int64;
      MaxDiff: Int64;
    begin
      Result:=true;
      if (FDetectBusyCount>0) and (FDetectBusyCount<=FDetectBusyMaxCount) then begin
        MaxDiff:=(FDetectBusyThread.Timeout*2)*(FDetectBusyMaxCount-1);
        Diff:=GetTickDifference(FDetectBusyTick,FDetectBusyFreq,dtMilliSec);
        if Diff>=MaxDiff then
          Result:=false;
      end;
    end;
    
  var
    Converter: TWaveConverter;
    ASize,NeedSize: Int64;
  begin
    if NeedDetectBusy and not FDetectBusyThread.Exists then begin
      try
        Converter:=TWaveConverter.Create;
        try
          Converter.BeginRewrite(FRemoteDriverFormat.WaveFormat);
          Converter.Write(Pointer(Packet.Payload)^,Length(Packet.Payload));
          Converter.EndRewrite;
          if Converter.ConvertTo(@FDetectBusyFormat) then begin
            Converter.Stream.Position:=Converter.DataOffset;
            ASize:=Converter.Stream.Size-Converter.Stream.Position;
            if ASize>0 then begin
              FDetectBusyStream.Position:=FDetectBusyStream.Size;
              FDetectBusyStream.CopyFrom(Converter.Stream,ASize);
              NeedSize:=Round((ASize*FDetectBusyPeriod)/FRemotePacketTime);
              if (FDetectBusyStream.Size>=NeedSize) then begin
                FDetectBusyStream.Position:=FDetectBusyStream.Size-NeedSize;
                FDetectBusy.LoadFromStream(FDetectBusyStream);
                FDetectBusyStream.Clear;
              end;
            end;
          end;
        finally
          Converter.Free;
        end;
      except
        On E: Exception do
          TBisSipPhoneSync.DoError(FPhone,E.Message);  
      end;
    end;
  end;

var
  Flag: Boolean;
  L: Integer;
  i: Integer;
  PayloadType: TBisRtpPacketPayloadType;
  Rtpmap: TBisSdpRtpmapAttr;
  D: TBytes;
  Code: Char;
begin
  try
    if Active and (lsConnected in FStates) then begin

      Flag:=Assigned(FRemoteDriverFormat);
      if FCheckRemoteIP then
        Flag:=Flag and (ABinding.PeerIP=FRemoteIP) and
                       (ABinding.PeerPort=FRemotePort);

      if Flag then begin

        FLastTick:=GetTickCount(FLastFreq);

        L:=Length(AData);
        if (L>0) then begin

          Flag:=false;
          Packet:=TBisRtpPacket.Create;
          try
            Packet.Parse(AData);

            Flag:=DefaultRemotePacket(Packet);
            if Flag then begin

              Flag:=FPhone.FCollectRemotePackets;
              if Flag then
                FRemotePackets.LockAdd(Packet);

              if FDtmfEnabled then
                LoadDtmf;

              if FDetectBusyEnabled then
                LoadDetectBusy; 

              TBisSipPhoneSync.DoLineInData(FPhone,Self,Pointer(Packet.Payload),Length(Packet.Payload));

            end else begin

              PayloadType:=Packet.PayloadType;

              FRemoteRtpmaps.Lock;
              try
                for i:=0 to FRemoteRtpmaps.Count-1 do begin
                  Rtpmap:=TBisSdpRtpmapAttr(FRemoteRtpmaps.Items[i]);
                  if PayloadType=Rtpmap.PayloadType then begin

                    Flag:=FPhone.FCollectRemotePackets;
                    if Flag then
                      FRemotePackets.LockAdd(Packet);

                    if FDtmfEnabled then begin
                      if Rtpmap.EncodingType=retTelephoneEvent then begin
                        D:=Packet.Payload;
                        if Length(D)>0 then
                          if GetDtmfCodeByEvent(D[0],Code) then
                            if Assigned(FDtmf.OnCode) then
                              DtmfCode(FDtmf,Code);
                      end;
                    end;

                    TBisSipPhoneSync.DoLineInDataEx(FPhone,Self,Packet,Rtpmap);

                    break;
                  end;
                end;
              finally
                FRemoteRtpmaps.UnLock;
              end;

            end;
          finally
            if not Flag then
              Packet.Free;
          end;
        end;
      end;
    end;
  except
    On E: Exception do
      TBisSipPhoneSync.DoError(FPhone,E.Message);
  end;
end;

function TBisSipPhoneLine.TryServerActive: Boolean;

  procedure Disable;
  begin
    if FServer.Active then begin
      FServer.OnUDPRead:=nil;
      FServer.Active:=false;
      FBinding.CloseSocket;
    end;
  end;

  function SetPort(P: Integer): Boolean;
  begin
    Result:=false;
    if not UDPPortExists(FBinding.IP,P) then begin
      try
        FBinding.Port:=P;
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
  Disable;
  if not Active then begin
    First:=FBinding.Port;
    MaxPort:=POWER_2;
    while First<MaxPort do begin
      Result:=SetPort(First);
      if not Result then
        Inc(First,2)
      else begin
        break;
      end;
    end;
  end;
end;

procedure TBisSipPhoneLine.Dial(Number: String);
var
  Sdp: TBisSdp;
  Media: TBisSdpMedia;
begin
  if Assigned(FSession) and (FSession.State=ssReady) and
     (FSession.Direction=sdOutgoing) then begin
    FNumber:=Number;
    if Assigned(FLocalDriverFormat) and (FLocalPayloadType<>ptUnknown) and TryServerActive then begin
      Sdp:=TBisSdp.Create;
      try
        with Sdp do begin
          AddVersion;
          AddOrigin(FLocalSessionId,FLocalSessionVersion,oatIP4,FLocalIP);
          AddSession;
          AddConnection(oatIP4,FLocalIP);
          AddTiming;
          Media:=AddMedia(mtAudio,FBinding.Port,mptRTPAVP);
          if Assigned(Media) then
             Media.Formats.Add(TBisSdpRtpmapAttr.PayloadTypeToName(FLocalPayloadType));
          AddRtpmapAttr(FLocalPayloadType,FLocalEncondingType,FLocalSamplesPerSec);
          AddPtimeAttr(FLocalPacketTime);
          AddModeAttr(matSendrecv);
        end;
        FSession.RequestInvite(FNumber,Sdp.AsString,ctkApplicationSdp);
      finally
        Sdp.Free;
      end;
    end;
  end;
end;

procedure TBisSipPhoneLine.SetLocalDriverFormat;
var
  Rtpmap: TBisSdpRtpmapAttr;
  i: Integer;
begin
  FRemoteRtpmaps.Lock;
  try
    for i:=0 to FRemoteRtpmaps.Count-1 do begin
      Rtpmap:=TBisSdpRtpmapAttr(FRemoteRtpmaps.Items[i]);
      FLocalDriverFormat:=FPhone.FDrivers.FindFormat(Rtpmap.PayloadType,Rtpmap.Channels,
                                                     Rtpmap.SamplesPerSec,Rtpmap.BitsPerSample);
      if Assigned(FLocalDriverFormat) then begin
        FLocalPayloadType:=Rtpmap.PayloadType;
        FLocalEncondingType:=Rtpmap.EncodingType;
        FLocalChannels:=Rtpmap.Channels;
        FLocalSamplesPerSec:=Rtpmap.SamplesPerSec;
        FLocalBitsPerSample:=Rtpmap.BitsPerSample;
        FLocalPacketTime:=GetPacketTime(Rtpmap.PayloadType,Rtpmap.BitsPerSample,Rtpmap.Channels);
        exit;
      end;
    end;
  finally
    FRemoteRtpmaps.UnLock;
  end;
end;

procedure TBisSipPhoneLine.Answer;

  function GetSdpBody(var Body: String): Boolean;
  var
    Sdp: TBisSdp;
    Media: TBisSdpMedia;
  begin
    Result:=false;
    if Assigned(FLocalDriverFormat) and (FLocalPayloadType<>ptUnknown) and TryServerActive then begin
      Sdp:=TBisSdp.Create;
      try
        with Sdp do begin
          AddVersion;
          AddOrigin(FLocalSessionId,FLocalSessionVersion,oatIP4,FLocalIP);
          AddSession;
          AddConnection(oatIP4,FLocalIP);
          AddTiming;
          Media:=AddMedia(mtAudio,FBinding.Port,mptRTPAVP);
          if Assigned(Media) then
             Media.Formats.Add(TBisSdpRtpmapAttr.PayloadTypeToName(FLocalPayloadType));
          AddRtpmapAttr(FLocalPayloadType,FLocalEncondingType,FLocalSamplesPerSec);
          AddPtimeAttr(FLocalPacketTime);
          AddModeAttr(matSendrecv);
        end;
        Body:=Sdp.AsString;
        Result:=true
      finally
        Sdp.Free;
      end;
    end;
  end;

var
  Body: String;
begin
  if Assigned(FSession) and (FSession.State in [ssRinging,ssProgressing]) and
     (FSession.Direction in [sdIncoming,sdOutgoing]) and
     (FSession.ContentTypeKind=ctkApplicationSdp) then begin

    SetLocalDriverFormat;
    if GetSdpBody(Body) then begin
      case FSession.Direction of
        sdIncoming: FSession.ResponseInviteOK(Body,ctkApplicationSdp);
        sdOutgoing: ;
      end;
    end;
  end;
end;

procedure TBisSipPhoneLine.Hangup;
begin
  if Assigned(FSession) and
     (FSession.Direction in [sdIncoming,sdOutgoing]) and
     (FSession.State in [ssBreaking,ssWaiting,ssRinging,ssConfirming,
                         ssProgressing,ssProcessing,ssDestroying]) then begin
    case FSession.State of
      ssBreaking: begin
        if not (lsDestroying in FStates) then
          FPhone.FClient.Sessions.LockRemove(FSession);
      end;
      ssDestroying: begin
        FPhone.FClient.Sessions.LockRemove(FSession);      
      end;
      ssWaiting,ssConfirming: FSession.RequestCancel;
      ssRinging,ssProgressing: begin
        case FSession.Direction of
          sdIncoming: FSession.ResponseInviteBusyHere;
          sdOutgoing: FSession.RequestCancel;
        end;
      end;
      ssProcessing: FSession.RequestBye;
    end;
  end;
end;

procedure TBisSipPhoneLine.HoldUnHold(Flag: Boolean);
var
  Sdp: TBisSdp;
  Media: TBisSdpMedia;
begin
  if FPhone.Connected and
     Assigned(FSession) and (FSession.State=ssProcessing) and
     (FSession.Direction in [sdIncoming,sdOutgoing]) and
     Active then begin

    if Assigned(FLocalDriverFormat) and (FLocalPayloadType<>ptUnknown) then begin
      if FPhone.FHoldMode=lhmStandart then begin
        Sdp:=TBisSdp.Create;
        try
          Inc(FLocalSessionVersion);
          with Sdp do begin
            AddVersion;
            AddOrigin(FLocalSessionId,FLocalSessionVersion,oatIP4,FLocalIP);
            AddSession;
            AddConnection(oatIP4,iff(Flag,FLocalEmptyAddress,FLocalIP));
            AddTiming;
            Media:=AddMedia(mtAudio,FBinding.Port,mptRTPAVP);
            if Assigned(Media) then
               Media.Formats.Add(TBisSdpRtpmapAttr.PayloadTypeToName(FLocalPayloadType));
            AddRtpmapAttr(FLocalPayloadType,FLocalEncondingType,FLocalSamplesPerSec);
            AddPtimeAttr(FLocalPacketTime);
            AddModeAttr(iff(Flag,matSendonly,matSendrecv));
          end;
          FSession.RequestInvite(FNumber,Sdp.AsString,ctkApplicationSdp);
          FHoldWaiting:=true;
        finally
          Sdp.Free;
        end;
      end else begin
        if Flag then
          Include(FStates,lsHolding)
        else
          Exclude(FStates,lsHolding);

        TBisSipPhoneSync.DoLineHold(FPhone,Self);  
      end;
    end;
  end;
end;

procedure TBisSipPhoneLine.Hold;
begin
  HoldUnHold(true);
end;

procedure TBisSipPhoneLine.UnHold;
begin
  HoldUnHold(false);
end;

{ TBisSipPhoneLines }

constructor TBisSipPhoneLines.Create(Phone: TBisSipPhone);
begin
  inherited Create;
  FPhone:=Phone;
end;

procedure TBisSipPhoneLines.DoItemRemove(Item: TObject);
var
  Session: TBisSipSession;
begin
  Session:=nil;
  if Assigned(Item) and (Item is TBisSipPhoneLine) then
    Session:=TBisSipPhoneLine(Item).FSession;

  inherited DoItemRemove(Item);

  if Assigned(Session) then
    FPhone.FClient.Sessions.LockRemove(Session);
  
end;

function TBisSipPhoneLines.GetItem(Index: Integer): TBisSipPhoneLine;
begin
  Result:=TBisSipPhoneLine(inherited Items[Index]);
end;

function TBisSipPhoneLines.LastLocalPort: Integer;
begin
  Result:=FPhone.RtpLocalPort;
  if Count>0 then begin
    Result:=Items[Count-1].FBinding.Port;
  end;
end;

function TBisSipPhoneLines.Find(Session: TBisSipSession): TBisSipPhoneLine;
var
  i: Integer;
  Item: TBisSipPhoneLine;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if Item.FSession=Session then begin
      Result:=Item;
      exit;
    end;
  end;
end;

function TBisSipPhoneLines.LockFind(Session: TBisSipSession): TBisSipPhoneLine;
begin
  Lock;
  try
    Result:=Find(Session);
  finally
    UnLock;
  end;
end;

function TBisSipPhoneLines.Add(Session: TBisSipSession): TBisSipPhoneLine;
begin
  Result:=TBisSipPhoneLine.Create(FPhone);
  Result.FSession:=Session;
  Result.FLocalIP:=FPhone.FClient.LocalIP;
  Result.FBinding.IP:=FPhone.FClient.Transport.DefaultIP;
  Result.FBinding.Port:=LastLocalPort;
  inherited Add(Result);
end;

function TBisSipPhoneLines.LockAdd(Session: TBisSipSession): TBisSipPhoneLine;
begin
  Lock;
  try
    Result:=Add(Session);
  finally
    UnLock;
  end;
end;

function TBisSipPhoneLines.Exists(Line: TBisSipPhoneLine): Boolean;
begin
  Result:=IndexOf(Line)<>-1;
end;

function TBisSipPhoneLines.LockExists(Line: TBisSipPhoneLine): Boolean;
begin
  Lock;
  try
    Result:=Exists(Line);
  finally
    UnLock;
  end;
end;

function TBisSipPhoneLines.ActiveCount: Integer;
var
  i: Integer;
  Item: TBisSipPhoneLine;
begin
  Result:=0;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if Item.Active then
      Inc(Result);
  end;
end;

function TBisSipPhoneLines.LockActiveCount: Integer;
begin
  Lock;
  try
    Result:=ActiveCount;
  finally
    UnLock;
  end;
end;

type
  TBisSipPhoneSweepThread=class(TBisWaitThread)
  end;

{ TBisSipPhone }

constructor TBisSipPhone.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FScheme:=DefaultScheme;
  FProtocol:=DefaultProtocol;
  FLocalHost:='localhost';
  FLocalPort:=DefaultSipPort;;
  FMaxForwards:=70;
  FExpires:=3600;
  FMaxActiveLines:=3;
//  FMaxInLines:=3;
//  FMaxOutLines:=3;
  FKeepAliveInterval:=30000;
  FRequestRetryCount:=3;
  FRequestTimeOut:=3000;
  FCollectRemotePackets:=false;
  FCollectLocalPackets:=false;
  FTransportMode:=tmUDP;

  FHoldMode:=lhmEmulate;
  FRtpLocalPort:=20000;
  FAudioDriverName:='';
  FAudioFormatName:='CCITT A-Law';
  FAudioChannels:=1;
  FAudioSamplesPerSec:=8000;
  FAudioBitsPerSample:=8;
  FConfirmCount:=3;
  FSweepInterval:=1000;

  FDtmfThreshold:=900;
  FDtmfEnabled:=true;
  FDtmfTimeout:=250;

  FDetectBusyThreshold:=50;
  FDetectBusyEnabled:=true;
  FDetectBusyTimeout:=400;
  FDetectBusyMaxCount:=5;

  FLines:=TBisSipPhoneLines.Create(Self);

  FSweepThread:=TBisSipPhoneSweepThread.Create;
  FSweepThread.OnTimeout:=SweepThreadTimeout;
  FSweepThread.RestrictByZero:=true;
  FSweepThread.StopOnDestroy:=true;

  FClient:=TBisSipClient.Create;
  FClient.OnRegister:=ClientRegister;
  FClient.OnError:=ClientError;
  FClient.OnSend:=ClientSend;
  FClient.OnReceive:=ClientReceive;
  FClient.OnTimeout:=ClientTimeout;
  FClient.OnSessionTimeout:=nil;
  FClient.OnSessionCreate:=�lientSessionCreate;
  FClient.OnSessionDestroy:=ClientSessionDestroy;
  FClient.OnSessionAccept:=ClientSessionAccept;
  FClient.OnSessionRing:=ClientSessionRing;
  FClient.OnSessionContent:=ClientSessionContent;
  FClient.OnSessionProgress:=ClientSessionRing;
  FClient.OnSessionConfirm:=ClientSessionConfirm;
  FClient.OnSessionTerminate:=ClientSessionTerminate;

  FDrivers:=TBisRtpAcmDrivers.Create;

end;

destructor TBisSipPhone.Destroy;
begin
  FDrivers.Free;
  FClient.Free;
  FSweepThread.Free;
  FLines.Free;
  inherited Destroy;
end;

procedure TBisSipPhone.SweepThreadTimeout(Thread: TBisWaitThread);
var
  i: Integer;
  Line: TBisSipPhoneLine;
  Flag: Boolean;
begin
  FLines.Lock;
  try
    for i:=FLines.Count-1 downto 0 do begin
      Line:=FLines.Items[i];

      Flag:=false;
      if Line.TryLock then
        try
          Flag:=Line.ReadyForDestroy;
        finally
          Line.UnLock;
          if Flag then
            FLines.Delete(i)
        end;

    end;
  finally
    FLines.UnLock;
    Thread.Reset;
  end;
end;

function TBisSipPhone.GetBusy: Boolean;
begin
  Result:=FLines.LockActiveCount>=FMaxActiveLines;
end;

function TBisSipPhone.GetConnected: Boolean;
begin
  Result:=FClient.Registered;
end;

function TBisSipPhone.GetState: TBisSipPhoneState;
begin
  case FClient.State of
    csRegistering: Result:=psConnecting;
    csUnRegistering: Result:=psDisconnecting;
  else
    Result:=psDefault;
  end;
end;

procedure TBisSipPhone.ClientError(Client: TBisSipClient; const Error: String);
begin
  if Trim(Error)<>'' then
    TBisSipPhoneSync.DoError(Self,Error);
end;

procedure TBisSipPhone.ClientRegister(Client: TBisSipClient);
begin
  if Client.Registered then begin
    FSweepThread.Start;
    TBisSipPhoneSync.DoConnect(Self);
  end else begin
    FSweepThread.Stop;
    TBisSipPhoneSync.DoDisconnect(Self);
  end;
end;

procedure TBisSipPhone.ClientSend(Client: TBisSipClient; Host: String; Port: Integer; Data: String);
begin
  TBisSipPhoneSync.DoSend(Self,Host,Port,Data);
end;

procedure TBisSipPhone.ClientReceive(Client: TBisSipClient; Host: String; Port: Integer; Data: String);
begin
  TBisSipPhoneSync.DoReceive(Self,Host,Port,Data);
end;

procedure TBisSipPhone.ClientTimeout(Client: TBisSipClient; var Interrupted: Boolean);
begin
  TBisSipPhoneSync.DoTimeout(Self);
end;

procedure TBisSipPhone.�lientSessionCreate(Client: TBisSipClient; Session: TBisSipSession);
var
  Line: TBisSipPhoneLine;
begin
  Line:=FLines.LockAdd(Session);
  if Assigned(Line) then begin
    Line.Lock;
    try
      TBisSipPhoneSync.DoLineCreate(Self,Line);
    finally
      Line.UnLock;
    end;
  end;
end;

procedure TBisSipPhone.ClientSessionDestroy(Client: TBisSipClient; Session: TBisSipSession);
var
  Line: TBisSipPhoneLine;
begin
  Line:=FLines.LockFind(Session);
  if Assigned(Line) then begin
    Line.Lock;
    try
      TBisSipPhoneSync.DoLineDestroy(Self,Line);
    finally
      Line.UnLock;
      FLines.LockRemove(Line);
    end;
  end;
end;

function TBisSipPhone.ClientSessionAccept(Client: TBisSipClient; Session: TBisSipSession;
                                          Message: TBisSipMessage): Boolean;

  function GetLineNumber: String;
  var
    From: TBisSipFrom;
  begin
    Result:='';
    Message.Lock;
    try
      From:=TBisSipFrom(Message.Headers.Find(TBisSipFrom));
      if Assigned(From) then begin
        Result:=From.Display;
        if Trim(Result)='' then
          Result:=From.User;
      end;
    finally
      Message.UnLock;
    end;
  end;

  function GetLineDiversionNumber: String;
  var
    Diversion: TBisSipDiversion;
  begin                                                            
    Result:='';
    Message.Lock;
    try
      Diversion:=TBisSipDiversion(Message.Headers.Find(TBisSipDiversion));
      if Assigned(Diversion) then begin
        Result:=Diversion.Display;
        if Trim(Result)='' then
          Result:=Diversion.User;
      end;
    finally
      Message.UnLock;
    end;
  end;

var
  Line: TBisSipPhoneLine;
  Flag: Boolean;
begin
  Result:=false;
  Line:=FLines.LockFind(Session);
  Flag:=Busy;
  if Assigned(Line) and not Flag then begin
    Line.Lock;
    try
      case Session.Direction of
        sdIncoming: begin
          Line.FNumber:=GetLineNumber;
          Line.FDiversionNumber:=GetLineDiversionNumber;
          Result:=TBisSipPhoneSync.DoLineCheck(Self,Line,Message);
          if Result then
            Result:=Line.SetContent(Message.Body.Text);
        end;
        sdOutgoing: begin
          Result:=TBisSipPhoneSync.DoLineCheck(Self,Line,Message);
          if Result then
            Result:=Line.SetContent(Message.Body.Text);
        end;
      end;
    finally
      Line.UnLock;
    end;
  end;
end;

procedure TBisSipPhone.ClientSessionContent(Client: TBisSipClient; Session: TBisSipSession; Content: String);
var
  Line: TBisSipPhoneLine;
begin
  Line:=FLines.LockFind(Session);
  if Assigned(Line) then begin
    Line.Lock;
    try
      Line.SetContent(Content);
    finally
      Line.UnLock;
    end;
  end;
end;

procedure TBisSipPhone.ClientSessionRing(Client: TBisSipClient; Session: TBisSipSession);
var
  Line: TBisSipPhoneLine;
begin
  Line:=FLines.LockFind(Session);
  if Assigned(Line) then begin
    Line.Lock;
    try
      if not (lsRinging in Line.FStates) then begin
        Include(Line.FStates,lsRinging);
        Line.DialStamp;
        TBisSipPhoneSync.DoLineRing(Self,Line);
      end;
    finally
      Line.UnLock;
    end;
  end;
end;

procedure TBisSipPhone.ClientSessionConfirm(Client: TBisSipClient; Session: TBisSipSession);
var
  Line: TBisSipPhoneLine;
begin
  Line:=FLines.LockFind(Session);
  if Assigned(Line) then begin
    Line.Lock;
    try
      if not Line.FHoldWaiting then begin
        if not (lsConnected in Line.FStates) then begin
          Exclude(Line.FStates,lsRinging);
          Line.SendConfirm;
          Line.TalkStamp;
          Line.DetectBusyClear;
          TBisSipPhoneSync.DoLineConnect(Self,Line);
          Include(Line.FStates,lsConnected);
        end else
          
      end else begin
        Line.FHoldWaiting:=false;
        if lsHolding in Line.FStates then
          Exclude(Line.FStates,lsHolding)
        else
          Include(Line.FStates,lsHolding);
        TBisSipPhoneSync.DoLineHold(Self,Line);
      end;
    finally
      Line.UnLock;
    end;
  end;
end;

procedure TBisSipPhone.ClientSessionTerminate(Client: TBisSipClient; Session: TBisSipSession);
var
  Line: TBisSipPhoneLine;
begin
  Line:=FLines.LockFind(Session);
  if Assigned(Line) then begin
    Line.Lock;
    try
      TBisSipPhoneSync.DoLineDisconnect(Self,Line);
      Exclude(Line.FStates,lsConnected);
    finally
      Line.UnLock;
    end;
  end;
end;

procedure TBisSipPhone.Connect;
var
  RIP: String;
  RPort: Integer;
begin
  if not FClient.Registered then begin

    FClient.Transport.Active:=false;

    FSweepThread.Timeout:=FSweepInterval;

    FClient.Scheme:=FScheme;
    FClient.Protocol:=FProtocol;
    FClient.RemoteHost:=FRemoteHost;
    FClient.RemoteIP:=FRemoteHost;
    FClient.RemotePort:=FRemotePort;
    if IsIP(FRemoteHost) then
      FClient.RemoteIP:=FRemoteHost
    else begin
      if ResolveSipIPAndPort(FClient.Scheme,FClient.Transport.Name,
                             FRemoteHost,RIP,RPort) then begin
        FClient.RemoteIP:=RIP;
        FClient.RemotePort:=RPort;
      end;
    end;
    FLocalIP:=ResolveIP(FLocalHost);
    FClient.LocalIP:=FLocalIP;
    FClient.LocalPort:=FLocalPort;
    FClient.UserName:=FUserName;
    FClient.Password:=FPassword;
    FClient.Expires:=FExpires;
    FClient.UserAgent:=FUserAgent;
    FClient.MaxForwards:=FMaxForwards;
    FClient.KeepAliveInterval:=FKeepAliveInterval;
    FClient.UseReceived:=FUseReceived;
    FClient.UseRport:=FUseRport;
    FClient.UseTrasnportNameInUri:=FUseTrasnportNameInUri;
    FClient.UsePortInUri:=FUsePortInUri;
    FClient.UseGlobalSequence:=FUseGlobalSequence;
    FClient.WaitRetryCount:=FRequestRetryCount;
    FClient.WaitTimeOut:=FRequestTimeOut;
    FClient.Transport.Mode:=FTransportMode;

//    FClient.Transport.MaxThreadCount:=5;
//    FClient.WaitTimeOut:=10000;

    FClient.Register(true);
    
  end;
end;

procedure TBisSipPhone.Disconnect;
begin
  if FClient.Registered then begin
    FClient.Register(false,true);
  end;
end;

procedure TBisSipPhone.Terminate;
begin
  FClient.Terminate;
end;

function TBisSipPhone.AddLine(Direction: TBisSipPhoneLineDirection): TBisSipPhoneLine;
var
  ADirection: TBisSipSessionDirection;
  Session: TBisSipSession;
begin
  ADirection:=sdUnknown;
  case Direction of
    ldIncoming: ADirection:=sdIncoming;
    ldOutgoing: ADirection:=sdOutgoing;
  end;
  Session:=FClient.Sessions.LockAdd('',ADirection);
  Result:=FLines.LockFind(Session);
end;

procedure TBisSipPhone.Dial(Number: String);
var
  Line: TBisSipPhoneLine;
begin
  if FClient.Registered and (FClient.State=csDefault) then begin
    Line:=AddLine(ldOutgoing);
    if Assigned(Line) then begin
      Line.Lock;
      try
        Line.Dial(Number);
      finally
        Line.UnLock;
      end;
    end;
  end;
end;

procedure TBisSipPhone.Answer(Line: TBisSipPhoneLine);
begin
  if FLines.LockExists(Line) then begin
    Line.Lock;
    try
      Line.Answer;
    finally
      Line.UnLock;
    end;
  end;
end;

procedure TBisSipPhone.Hangup(Line: TBisSipPhoneLine);
begin
  if FLines.LockExists(Line) then begin
    Line.Lock;
    try
      Line.Hangup;
    finally
      Line.UnLock;
    end;
  end;
end;

procedure TBisSipPhone.HangupAll;
var
  i: Integer;
  Line: TBisSipPhoneLine;
begin
  FLines.Lock;
  try
    for i:=0 to FLines.Count-1 do begin
      Line:=FLines.Items[i];
      Line.Lock;
      try
        Line.Hangup;
      finally
        Line.UnLock;
      end;
    end;
  finally
    FLines.UnLock;
  end;
end;

procedure TBisSipPhone.Hold(Line: TBisSipPhoneLine);
begin
  if FLines.LockExists(Line) then begin
    Line.Lock;
    try
      Line.Hold;
    finally
      Line.UnLock;
    end;
  end;
end;

procedure TBisSipPhone.Unhold(Line: TBisSipPhoneLine);
begin
  if FLines.LockExists(Line) then begin
    Line.Lock;
    try
      Line.UnHold;
    finally
      Line.UnLock;
    end;
  end;
end;

end.