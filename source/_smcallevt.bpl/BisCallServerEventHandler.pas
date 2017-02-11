unit BisCallServerEventHandler;

interface

uses Windows, Classes, Contnrs, ZLib, mmSystem, SyncObjs,
     IdGlobal, IdSocketHandle, IdUDPServer, IdException,
     WaveAcmDrivers,
     BisEvents, BisNotifyEvents, BisCrypter, BisValues, BisConnections,
     BisWave, BisThread,
     BisCallServerHandlerModules, BisCallServerHandlers,
     BisCallServerChannels;

type
  TBisCallServerEventHandler=class;

  TBisCallServerEventChannels=class;

  TBisCallServerEventMessageDirection=(mdIncoming,mdOutgoing);

  TBisCallServerEventMessage=class(TBisValues)
  private
    FName: String;
    FDirection: TBisCallServerEventMessageDirection;
    function GetSessionId: Variant;
    function GetChannelId: String;
    function GetSequence: Integer;
    function GetCallId: Variant;
    function GetRemoteSessionId: Variant;
    function GetDataPort: Integer;
    function GetBitsPerSample: Word;
    function GetChannels: Word;
    function GetFormatTag: Word;
    function GetSamplesPerSec: LongWord;
    function GetDataSize: Integer;
    function GetCallerId: Variant;
    function GetCallerPhone: Variant;
    function GetAcceptor: Variant;
    function GetAcceptorType: TBisCallServerChannelAcceptorType;
  public
    constructor Create(Direction: TBisCallServerEventMessageDirection; Name: String; Params: TBisEventParams=nil); virtual;
    destructor Destroy; override;
    procedure CopyFrom(Params: TBisEventParams);
    function AsString: String; virtual;

    procedure AddSessionId(Value: Variant);
    procedure AddRemoteSessionId(Value: Variant);
    procedure AddChannelId(Value: String);
    procedure AddSequence(Value: Integer);
    procedure AddCallId(Value: Variant);
    procedure AddCallerId(Value: Variant);
    procedure AddCallerPhone(Value: Variant);
    procedure AddDataPort(Value: Integer);
    procedure AddFormatTag(Value: Word);
    procedure AddChannels(Value: Word);
    procedure AddSamplesPerSec(Value: LongWord);
    procedure AddBitsPerSample(Value: Word);
    procedure AddDataSize(Value: Integer);

    property Name: String read FName;
    property SessionId: Variant read GetSessionId;
    property RemoteSessionId: Variant read GetRemoteSessionId;
    property ChannelId: String read GetChannelId;
    property Sequence: Integer read GetSequence;
    property CallId: Variant read GetCallId;
    property CallerId: Variant read GetCallerId;
    property CallerPhone: Variant read GetCallerPhone;
    property DataPort: Integer read GetDataPort;
    property FormatTag: Word read GetFormatTag;
    property Channels: Word read GetChannels;
    property SamplesPerSec: LongWord read GetSamplesPerSec;
    property BitsPerSample: Word read GetBitsPerSample;
    property DataSize: Integer read GetDataSize;
    property Acceptor: Variant read GetAcceptor;
    property AcceptorType: TBisCallServerChannelAcceptorType read GetAcceptorType;  
  end;

  TBisCallServerEventResponseType=(rtUnknown,rtOK,rtCancel,rtError);

  TBisCallServerEventResponse=class(TBisCallServerEventMessage)
  private
    function GetRequestName: String;
    function GetMessage: String;
    function GetResponseType: TBisCallServerEventResponseType;
  public
    procedure AddRequestName(Value: String);
    procedure AddResponseType(Value: TBisCallServerEventResponseType);
    procedure AddMessage(Value: String);

    property RequestName: String read GetRequestName;
    property ResponseType: TBisCallServerEventResponseType read GetResponseType;
    property Message: String read GetMessage;
  end;

  TBisCallServerEventResponses=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisCallServerEventResponse;
  public
    property Items[Index: Integer]: TBisCallServerEventResponse read GetItem; default;
  end;

  TBisCallServerEventRequest=class(TBisCallServerEventMessage)
  private
    FResponses: TBisCallServerEventResponses;
  public
    constructor Create(Direction: TBisCallServerEventMessageDirection; Name: String; Params: TBisEventParams=nil); override;
    destructor Destroy; override;

    property Responses: TBisCallServerEventResponses read FResponses;
  end;

  TBisCallServerEventRequests=class(TObjectList)
  private
    FSequence: Integer;
    function GetItem(Index: Integer): TBisCallServerEventRequest;
  public
    function Find(Response: TBisCallServerEventResponse): TBisCallServerEventRequest;
    function NextSequence: Integer;

    property Items[Index: Integer]: TBisCallServerEventRequest read GetItem; default;
    property Sequence: Integer read FSequence;
  end;

  TBisCallServerEventWaitThread=class(TBisThread)
  private
    FEvent: TEvent;
    FInTimeout: Boolean;
    FMessage: TBisCallServerEventMessage;
    FTimeout: Integer;
    FCounter: Integer;
    FOnTimeOut: TNotifyEvent;
    procedure DoTimeOut;
  public
    constructor Create(Message: TBisCallServerEventMessage; TimeOut: Integer); reintroduce;
    destructor Destroy; override;
    procedure Execute; override;
    procedure Terminate;
  end;

  TBisCallServerEventChannel=class;

  TBisCallServerEventWaitThreads=class(TObjectList)
  private
    FOnTimeOut: TNotifyEvent;
    function GetItem(Index: Integer): TBisCallServerEventWaitThread;
  protected
    procedure Notify(Ptr: Pointer; Action: TListNotification); override;
  public
    constructor Create;
    destructor Destroy; override;
    function Add(Message: TBisCallServerEventMessage; TimeOut: Integer; Counter: Integer=0): TBisCallServerEventWaitThread;
    procedure RemoveBy(Message: TBisCallServerEventMessage);

    property Items[Index: Integer]: TBisCallServerEventWaitThread read GetItem; default;
  end;

  TBisCallServerEventUdpServer=class(TIdUdpServer)
  protected
    function GetBinding: TIdSocketHandle; override;
  end;

  TBisCallServerEventChannel=class(TBisCallServerChannel)
  private
    FHandler: TBisCallServerEventHandler;
    FChannels: TBisCallServerEventChannels;
    FId: String;
    FCreatorId: Variant;
    FCallId: Variant;
    FCallerId, FCallerPhone: Variant;
    FAcceptor: Variant;
    FAcceptorType: TBisCallServerChannelAcceptorType;
    FDateCreate: TDateTime;
    FDirection: TBisCallServerChannelDirection;
    FRequests: TBisCallServerEventRequests;
    FWaits: TBisCallServerEventWaitThreads;
    FServer: TBisCallServerEventUdpServer;
    FOutFormat: PWaveFormatEx;
    FOutDataSize: Integer;
    FSequence: Integer;

    FIP: String;
    FPort: Integer;
    FUseCompressor: Boolean;
    FCompressorLevel: TCompressionLevel;
    FUseCrypter: Boolean;
    FCrypterKey: String;
    FCrypterAlgorithm: TBisCipherAlgorithm;
    FCrypterMode: TBisCipherMode;

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
    FRemoteFormat: TWaveAcmDriverFormat;
    FRemoteDataSize: Integer;

    procedure WaitsTimeOut(Sender: TObject);
    
    function EncodeString(Key, S: String; Algorithm: TBisCipherAlgorithm; Mode: TBisCipherMode): String;
    function CompressString(S: String; Level: TCompressionLevel): String;
    function SendEvent(Data: String): Boolean;
    procedure SendMessage(Message: TBisCallServerEventMessage; WithWait: Boolean);
    procedure ServerUDPException(Sender: TObject; ABinding: TIdSocketHandle; const AMessage: String; const AExceptionClass: TClass);
    procedure ServerUDPRead(Sender: TObject; AData: TIdBytes; ABinding: TIdSocketHandle);
    function DataPort: Integer;
    function TryServerActive: Boolean;
    function GetEventParams(SessionId: Variant;
                            var IP: String; var Port: Integer;
                            var UseCompressor: Boolean; var CompressorLevel: TCompressionLevel;
                            var UseCrypter: Boolean; var CrypterKey: String;
                            var CrypterAlgorithm: TBisCipherAlgorithm; var CrypterMode: TBisCipherMode): Boolean;
    function GetRemoteEventParams(SessionId: Variant): Boolean;
    function GetLocalEventParams: Boolean;

    function DialRequest(Request: TBisCallServerEventRequest): Boolean;
    function AnswerRequest(Request: TBisCallServerEventRequest): Boolean;
    function HangupRequest(Request: TBisCallServerEventRequest): Boolean;
    function HoldRequest(Request: TBisCallServerEventRequest): Boolean;
    function UnHoldRequest(Request: TBisCallServerEventRequest): Boolean;

    function DialResponse(Response: TBisCallServerEventResponse; var FreeChannel: Boolean): Boolean;
    function AnswerResponse(Response: TBisCallServerEventResponse; var FreeChannel: Boolean): Boolean;
    function HangupResponse(Response: TBisCallServerEventResponse; var FreeChannel: Boolean): Boolean;
  protected
    function GetActive: Boolean; override;
    function GetCallId: Variant; override;
    function GetDirection: TBisCallServerChannelDirection; override;
    function GetCallerId: Variant; override;
    function GetCallerPhone: Variant; override;
    function GetAcceptor: Variant; override;
    function GetAcceptorType: TBisCallServerChannelAcceptorType; override;
    function GetCreatorId: Variant; override;
    function GetDateCreate: TDateTime; override;
    function GetLocation: TBisCallServerChannelLocation; override;
    function GetInFormat: PWaveFormatEx; override;
    function GetOutFormat: PWaveFormatEx; override;
    procedure SetOutFormat(const Value: PWaveFormatEx); override;
    function GetOutDataSize: Integer; override;
    procedure SetOutDataSize(const Value: Integer); override;
    function GetVolume: Integer; override;
    function GetListenThread: TThread; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Dial(Acceptor: Variant; AcceptorType: TBisCallServerChannelAcceptorType); override;
    procedure Answer; override;
    procedure Hangup; override;
    procedure Send(const Data: Pointer; const DataSize: Cardinal); override;

  end;

  TBisCallServerEventChannels=class(TBisCallServerChannels)
  private
    FHandler: TBisCallServerEventHandler;
    FEventResult: TBisEvent;
    FEventDial: TBisEvent;
    FEventAnswer: TBisEvent;
    FEventHangup: TBisEvent;
    FEventHold: TBisEvent;
    FEventUnHold: TBisEvent;

    function GetItem(Index: Integer): TBisCallServerEventChannel;
    function ResultHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
    function DialHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
    function AnswerHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
    function HangupHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
    function HoldHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
    function UnHoldHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
  protected
    procedure DoDestroyChannel(Channel: TBisCallServerChannel); override;    
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function MaxDataPort(Default: Integer): Integer;

    function Add(Id: String; Direction: TBisCallServerChannelDirection; CallId: Variant): TBisCallServerEventChannel; reintroduce;
    function AddOutgoing(CallId,CallerId,CallerPhone: Variant): TBisCallServerEventChannel;
    function AddIncoming(Request: TBisCallServerEventRequest): TBisCallServerEventChannel;
    function Find(Id: String): TBisCallServerEventChannel; reintroduce;

    property Items[Index: Integer]: TBisCallServerEventChannel read GetItem; default;
  end;

  TBisCallServerEventHandler=class(TBisCallServerHandler)
  private
    FDrivers: TBisAcmDrivers;
    FWaitTimeOut: Integer;
    FWaitRetryCount: Integer;
    function GetChannels: TBisCallServerEventChannels;
  protected
    function GetChannelsClass: TBisCallServerChannelsClass; override;
    function GetConnected: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Connect; override;
    procedure Disconnect; override;
    function AddOutgoingChannel(CallId,CallerId,CallerPhone: Variant): TBisCallServerChannel; override;

    property Channels: TBisCallServerEventChannels read GetChannels;
  end;

procedure InitCallServerHandlerModule(AModule: TBisCallServerHandlerModule); stdcall;

exports
  InitCallServerHandlerModule;

implementation

uses SysUtils, Variants, DB,
     IdUDPClient,
     BisCore, BisProvider, BisFilterGroups, BisUtils, BisConfig, BisConsts, BisLogger,
     BisCallServerEventHandlerConsts;

procedure InitCallServerHandlerModule(AModule: TBisCallServerHandlerModule); stdcall;
begin
  AModule.HandlerClass:=TBisCallServerEventHandler;
end;

{ TBisCallServerEventMessage }

constructor TBisCallServerEventMessage.Create(Direction: TBisCallServerEventMessageDirection; Name: String; Params: TBisEventParams=nil);
begin
  inherited Create;
  FName:=Name;
  FDirection:=Direction;
  CopyFrom(Params);
end;

destructor TBisCallServerEventMessage.Destroy;
begin
  inherited Destroy;
end;

procedure TBisCallServerEventMessage.CopyFrom(Params: TBisEventParams);
var
  i: Integer;
  Param: TBisEventParam;
  V: Variant;
  S: String;
begin
  if Assigned(Params) then begin
    Clear;
    for i:=0 to Params.Count-1 do begin
      Param:=Params[i];
      if not VarIsNull(Param.Value) then begin
        V:=Param.Value;
        case VarType(V) of
          varOleStr,varString: begin
            S:=VarToStrDef(V,'');
            if S='' then
              V:=Null;
          end;
        end;
      end else
        V:=Null;
      Add(Param.Name,V);
    end;
  end;
end;

function TBisCallServerEventMessage.AsString: String;
var
  Config: TBisConfig;
  i: Integer;
  Item: TBisValue;
begin
  Result:='';
  if Trim(FName)<>'' then begin
    Config:=TBisConfig.Create(nil);
    try
      for i:=0 to Count-1 do begin
        Item:=Items[i];
        Config.Write(FName,Item.Name,Item.Value);
      end;
      Result:=Trim(Config.Text);
    finally
      Config.Free;
    end;
  end;
end;

function TBisCallServerEventMessage.GetCallId: Variant;
begin
  Result:=GetValue('CallId');
end;

function TBisCallServerEventMessage.GetCallerId: Variant;
begin
  Result:=GetValue('CallerId');
end;

function TBisCallServerEventMessage.GetCallerPhone: Variant;
begin
  Result:=GetValue('CallerPhone');
end;

function TBisCallServerEventMessage.GetChannelId: String;
begin
  Result:=VarToStrDef(GetValue('ChannelId'),'');
end;

function TBisCallServerEventMessage.GetDataPort: Integer;
begin
  Result:=VarToIntDef(GetValue('DataPort'),0);
end;

function TBisCallServerEventMessage.GetRemoteSessionId: Variant;
begin
  Result:=GetValue('RemoteSessionId');
end;

function TBisCallServerEventMessage.GetSessionId: Variant;
begin
  Result:=GetValue('SessionId');
end;

function TBisCallServerEventMessage.GetSequence: Integer;
begin
  Result:=VarToIntDef(GetValue('Sequence'),0);
end;

function TBisCallServerEventMessage.GetFormatTag: Word;
begin
  Result:=VarToIntDef(GetValue('FormatTag'),0);
end;

function TBisCallServerEventMessage.GetChannels: Word;
begin
  Result:=VarToIntDef(GetValue('Channels'),0);
end;

function TBisCallServerEventMessage.GetSamplesPerSec: LongWord;
begin
  Result:=VarToIntDef(GetValue('SamplesPerSec'),0);
end;

function TBisCallServerEventMessage.GetBitsPerSample: Word;
begin
  Result:=VarToIntDef(GetValue('BitsPerSample'),0);
end;

function TBisCallServerEventMessage.GetDataSize: Integer;
begin
  Result:=VarToIntDef(GetValue('DataSize'),0);
end;

function TBisCallServerEventMessage.GetAcceptor: Variant;
begin
  Result:=GetValue('Acceptor');
end;

function TBisCallServerEventMessage.GetAcceptorType: TBisCallServerChannelAcceptorType;
begin
  Result:=TBisCallServerChannelAcceptorType(VarToIntDef(GetValue('AcceptorType'),Integer(catPhone)));
end;

procedure TBisCallServerEventMessage.AddCallId(Value: Variant);
begin
  Add('CallId',Value);
end;

procedure TBisCallServerEventMessage.AddCallerId(Value: Variant);
begin
  Add('CallerId',Value);
end;

procedure TBisCallServerEventMessage.AddCallerPhone(Value: Variant);
begin
  Add('CallerPhone',Value);
end;

procedure TBisCallServerEventMessage.AddChannelId(Value: String);
begin
  Add('ChannelId',Value);
end;

procedure TBisCallServerEventMessage.AddDataPort(Value: Integer);
begin
  Add('DataPort',Value);
end;

procedure TBisCallServerEventMessage.AddRemoteSessionId(Value: Variant);
begin
  Add('RemoteSessionId',Value);
end;

procedure TBisCallServerEventMessage.AddSequence(Value: Integer);
begin
  Add('Sequence',Value);
end;

procedure TBisCallServerEventMessage.AddSessionId(Value: Variant);
begin
  Add('SessionId',Value);
end;

procedure TBisCallServerEventMessage.AddFormatTag(Value: Word);
begin
  Add('FormatTag',Value);
end;

procedure TBisCallServerEventMessage.AddChannels(Value: Word);
begin
  Add('Channels',Value);
end;

procedure TBisCallServerEventMessage.AddSamplesPerSec(Value: LongWord);
begin
  Add('SamplesPerSec',Value);
end;

procedure TBisCallServerEventMessage.AddBitsPerSample(Value: Word);
begin
  Add('BitsPerSample',Value);
end;

procedure TBisCallServerEventMessage.AddDataSize(Value: Integer);
begin
  Add('DataSize',Value);
end;

{ TBisCallServerEventResponse }

function TBisCallServerEventResponse.GetMessage: String;
begin
  Result:=VarToStrDef(GetValue('Message'),'');
end;

function TBisCallServerEventResponse.GetRequestName: String;
begin
  Result:=VarToStrDef(GetValue('RequestName'),'');
end;

function TBisCallServerEventResponse.GetResponseType: TBisCallServerEventResponseType;
begin
  Result:=TBisCallServerEventResponseType(VarToIntDef(GetValue('ResponseType'),Integer(rtUnknown)));
  if not (Result in [rtOK,rtCancel,rtError]) then
    Result:=rtUnknown;
end;

procedure TBisCallServerEventResponse.AddResponseType(Value: TBisCallServerEventResponseType);
begin
  Add('ResponseType',Integer(Value));
end;

procedure TBisCallServerEventResponse.AddMessage(Value: String);
begin
  Add('Message',Value);
end;

procedure TBisCallServerEventResponse.AddRequestName(Value: String);
begin
  Add('RequestName',Value);
end;

{ TBisCallServerEventResponses }

function TBisCallServerEventResponses.GetItem(Index: Integer): TBisCallServerEventResponse;
begin
  Result:=TBisCallServerEventResponse(inherited Items[Index]);
end;

{ TBisCallServerEventRequest }

constructor TBisCallServerEventRequest.Create(Direction: TBisCallServerEventMessageDirection; Name: String; Params: TBisEventParams=nil); 
begin
  inherited Create(Direction,Name,Params);
  FResponses:=TBisCallServerEventResponses.Create;
end;

destructor TBisCallServerEventRequest.Destroy;
begin
  FResponses.Free;
  inherited Destroy;
end;

{ TBisCallServerEventRequests }

function TBisCallServerEventRequests.Find(Response: TBisCallServerEventResponse): TBisCallServerEventRequest;
var
  i: Integer;
  Item: TBisCallServerEventRequest;
begin
  Result:=nil;
  if Assigned(Response) then begin
    for i:=Count-1 downto 0 do begin
      Item:=Items[i];
      if AnsiSameText(Item.Name,Response.RequestName) and
         (Item.Sequence=Response.Sequence) then begin
        Result:=Item;
        exit;
      end;
    end;
  end;
end;

function TBisCallServerEventRequests.GetItem(Index: Integer): TBisCallServerEventRequest;
begin
  Result:=TBisCallServerEventRequest(inherited Items[Index]);
end;

function TBisCallServerEventRequests.NextSequence: Integer;
begin
  Inc(FSequence);
  Result:=FSequence;
end;

{ TBisCallServerEventWaitThread }

constructor TBisCallServerEventWaitThread.Create(Message: TBisCallServerEventMessage; TimeOut: Integer);
begin
  inherited Create;
  FreeOnTerminate:=true;
  FMessage:=Message;
  FTimeout:=TimeOut;
  FEvent:=TEvent.Create(nil,false,false,'');
end;

destructor TBisCallServerEventWaitThread.Destroy;
begin
  FEvent.SetEvent;
  FEvent.Free;
  inherited Destroy;
end;

procedure TBisCallServerEventWaitThread.Terminate;
begin
  FOnTimeOut:=nil;
  FMessage:=nil;
  FEvent.SetEvent;
  inherited Terminate;
end;

procedure TBisCallServerEventWaitThread.DoTimeOut;
begin
  Inc(FCounter);
  if Assigned(FOnTimeOut) then
    FOnTimeOut(Self);
end;

procedure TBisCallServerEventWaitThread.Execute;
var
  Ret: TWaitResult;
begin
  inherited Execute;
  FEvent.ResetEvent;
  Ret:=FEvent.WaitFor(FTimeOut);
  if (Ret=wrTimeout) and not Terminated then begin
    FInTimeout:=true;
    try
      Synchronize(DoTimeOut);
    finally
      FInTimeout:=false;
    end;
  end;
end;

{ TBisCallServerEventWaitThreads }

constructor TBisCallServerEventWaitThreads.Create;
begin
  inherited Create(false);
end;

destructor TBisCallServerEventWaitThreads.Destroy;
begin
  inherited Destroy;
end;

function TBisCallServerEventWaitThreads.GetItem(Index: Integer): TBisCallServerEventWaitThread;
begin
  Result:=TBisCallServerEventWaitThread(inherited Items[Index]);
end;

procedure TBisCallServerEventWaitThreads.Notify(Ptr: Pointer; Action: TListNotification);
var
  Item: TBisCallServerEventWaitThread;
begin
  Item:=TBisCallServerEventWaitThread(Ptr);
  if OwnsObjects and Assigned(Item) and (Action=lnDeleted) then begin
    Item.Terminate;
   { if not Item.FInTimeout then
      Item.WaitFor;   }

     { OwnsObjects:=false;
      try    }
        inherited Notify(Ptr,Action);
    {  finally
        OwnsObjects:=true;
      end;  }
//    end;
  end else
    inherited Notify(Ptr,Action);
end;

function TBisCallServerEventWaitThreads.Add(Message: TBisCallServerEventMessage; TimeOut: Integer; Counter: Integer): TBisCallServerEventWaitThread;
begin
  Result:=TBisCallServerEventWaitThread.Create(Message,TimeOut);
  Result.FOnTimeOut:=FOnTimeOut;
  Result.FCounter:=Counter;
  inherited Add(Result);
end;

procedure TBisCallServerEventWaitThreads.RemoveBy(Message: TBisCallServerEventMessage);
var
  i: Integer;
  Item: TBisCallServerEventWaitThread;
begin
  for i:=Count-1 downto 0 do begin
    Item:=Items[i];
    if Item.FMessage=Message then begin
      Remove(Item);
    end;
  end;
end;

{ TBisCallServerEventUdpServer }

function TBisCallServerEventUdpServer.GetBinding: TIdSocketHandle;
begin
  Result:=inherited GetBinding;
  if Assigned(FListenerThread) then begin
    FListenerThread.Priority:=tpHighest;
  end;
end;

{ TBisCallServerEventChannel }

constructor TBisCallServerEventChannel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FRequests:=TBisCallServerEventRequests.Create;

  FWaits:=TBisCallServerEventWaitThreads.Create;
  FWaits.FOnTimeOut:=WaitsTimeOut;

  FServer:=TBisCallServerEventUdpServer.Create(nil);
  FServer.OnUDPRead:=ServerUDPRead;
  FServer.OnUDPException:=ServerUDPException;
  FServer.ThreadedEvent:=true;
  FServer.ThreadName:='CallServerEventListen';

  FCreatorId:=Core.AccountId;
  FDateCreate:=Core.ServerDate;
  FCallId:=Null;
  FCallerId:=Null;
  FCallerPhone:=Null;
  FAcceptor:=Null;

  FRemoteFormat:=nil;
  FSequence:=0;
end;

destructor TBisCallServerEventChannel.Destroy;
begin
  FServer.OnUDPRead:=nil;
  FServer.Free;
  FWaits.Free;
  FRequests.Free;
  inherited Destroy;
end;

function TBisCallServerEventChannel.GetActive: Boolean;
begin
  Result:=Assigned(FServer) and FServer.Active and (State in [csProcessing]);
end;

function TBisCallServerEventChannel.GetCallerId: Variant;
begin
  Result:=FCallerId;
end;

function TBisCallServerEventChannel.GetCallerPhone: Variant;
begin
  Result:=FCallerPhone;
end;

function TBisCallServerEventChannel.GetCallId: Variant;
begin
  Result:=FCallId;
end;

function TBisCallServerEventChannel.GetAcceptor: Variant;
begin
  Result:=FAcceptor;
end;

function TBisCallServerEventChannel.GetAcceptorType: TBisCallServerChannelAcceptorType;
begin
  Result:=FAcceptorType;
end;

function TBisCallServerEventChannel.GetCreatorId: Variant;
begin
  Result:=FCreatorId;
end;

function TBisCallServerEventChannel.GetDateCreate: TDateTime;
begin
  Result:=FDateCreate;
end;

function TBisCallServerEventChannel.GetDirection: TBisCallServerChannelDirection;
begin
  Result:=FDirection;
end;

function TBisCallServerEventChannel.GetInFormat: PWaveFormatEx;
begin
  Result:=nil;
  if Assigned(FRemoteFormat) then
    Result:=FRemoteFormat.WaveFormat;
end;

function TBisCallServerEventChannel.GetLocation: TBisCallServerChannelLocation;
begin
  Result:=inherited GetLocation;
  if Assigned(FHandler) then begin
    case FHandler.Location of
      hlInternal: Result:=clInternal;
      hlExternal: Result:=clExternal;
    end;
  end;
end;

function TBisCallServerEventChannel.GetOutDataSize: Integer;
begin
  Result:=FOutDataSize;
end;

function TBisCallServerEventChannel.GetOutFormat: PWaveFormatEx;
begin
  Result:=FOutFormat;
end;

function TBisCallServerEventChannel.GetVolume: Integer;
begin
  Result:=inherited GetVolume;
  if Assigned(FHandler) then
    Result:=FHandler.Volume;
end;

function TBisCallServerEventChannel.GetListenThread: TThread;
begin
  Result:=inherited GetListenThread;
  if Assigned(FServer) then
    Result:=FServer.FListenerThread;
end;

procedure TBisCallServerEventChannel.WaitsTimeOut(Sender: TObject);
var
  Wait: TBisCallServerEventWaitThread;
begin
  if Assigned(Sender) and (Sender is TBisCallServerEventWaitThread) then begin
    Wait:=TBisCallServerEventWaitThread(Sender);
    try
      if Assigned(Wait.FMessage) and Assigned(FHandler) then begin
        if Wait.FCounter<FHandler.FWaitRetryCount then begin
          if SendEvent(Wait.FMessage.AsString) then
            FWaits.Add(Wait.FMessage,FHandler.FWaitTimeOut,Wait.FCounter).Resume;
        end else begin
          DoTimeout;
        end;
      end;
    finally
//      FWaits.Remove(Wait);
    end;
  end;
end;

function TBisCallServerEventChannel.EncodeString(Key, S: String; Algorithm: TBisCipherAlgorithm; Mode: TBisCipherMode): String;
var
  Crypter: TBisCrypter;
begin
  Crypter:=TBisCrypter.Create;
  try
    Result:=Crypter.EncodeString(Key,S,Algorithm,Mode);
  finally
    Crypter.Free;
  end;
end;

function TBisCallServerEventChannel.CompressString(S: String; Level: TCompressionLevel): String;
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

function TBisCallServerEventChannel.SendEvent(Data: String): Boolean;
var
  Udp: TIdUDPClient;
  S: String;
begin
  Result:=false;
  if Data<>'' then begin
    Udp:=TIdUDPClient.Create(nil);
    try
      S:=Data;

      if FRemoteUseCompressor then
        S:=CompressString(S,FRemoteCompressorLevel);

      if FRemoteUseCrypter then
        S:=EncodeString(FRemoteCrypterKey,S,
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

procedure TBisCallServerEventChannel.Send(const Data: Pointer; const DataSize: Cardinal);
var
  L: Integer;
  S: String;
begin
  if Assigned(FServer) and FServer.Active then begin
    L:=DataSize;
    SetLength(S,L);
    Move(Data^,Pointer(S)^,L);
    FServer.Send(FRemoteIP,FRemoteDataPort,S);
  end;
end;

procedure TBisCallServerEventChannel.SendMessage(Message: TBisCallServerEventMessage; WithWait: Boolean);
begin
  if Assigned(Message) and Assigned(FHandler) then begin
    if SendEvent(Message.AsString) and (FHandler.FWaitRetryCount>0) and WithWait then
      FWaits.Add(Message,FHandler.FWaitTimeOut).Resume;
  end;
end;

procedure TBisCallServerEventChannel.ServerUDPException(Sender: TObject; ABinding: TIdSocketHandle;
                                                        const AMessage: String; const AExceptionClass: TClass);
begin
  LoggerWrite(AMessage,ltError);
end;

procedure TBisCallServerEventChannel.ServerUDPRead(Sender: TObject; AData: TIdBytes; ABinding: TIdSocketHandle);
var
  L: Integer;
begin
  try
    L:=Length(AData);
    if (L=FRemoteDataSize) then begin
      DoData(AData,L);
    end;
  except
    On E: Exception do begin
      LoggerWrite(E.Message,ltError);
    end;
  end;
end;

procedure TBisCallServerEventChannel.SetOutDataSize(const Value: Integer);
begin
  FOutDataSize:=Value;
end;

procedure TBisCallServerEventChannel.SetOutFormat(const Value: PWaveFormatEx);
begin
  FOutFormat:=Value;
end;

function TBisCallServerEventChannel.DataPort: Integer;
begin
  Result:=0;
  if Assigned(FServer) and (FServer.Bindings.Count>0) then begin
    Result:=FServer.Bindings[0].Port;
  end;
end;

function TBisCallServerEventChannel.TryServerActive: Boolean;
var
  First: Integer;
  MaxPort: Integer;
begin
  Result:=false;
  if Assigned(FServer) and not FServer.Active and Assigned(FChannels) then begin
    Core.ExceptNotifier.IngnoreExceptions.Add(EIdException);
    try
      First:=FPort;
      Inc(First);
      First:=FChannels.MaxDataPort(First);
      MaxPort:=POWER_2;
      while First<MaxPort do begin
        try
          FServer.Bindings.Clear;
          with FServer.Bindings.Add do begin
            IP:=FIP;
            Port:=First;
          end;
          FServer.Active:=true;
          Result:=true;
          break;
        except
          on E: Exception do begin
            FServer.Active:=false;
            Inc(First);
          end;
        end;
      end;
    finally
      Core.ExceptNotifier.IngnoreExceptions.Remove(EIdException);
    end;
  end;
end;

function TBisCallServerEventChannel.GetEventParams(SessionId: Variant;
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
      P.StopException:=false;
      P.WithWaitCursor:=false;
      P.Connection:=Connection;
      P.ConnectionSessionId:=ConnectionSessionId;
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
        Result:=true;
      end;
    finally
      P.Free;
    end;
  end;
end;

function TBisCallServerEventChannel.GetRemoteEventParams(SessionId: Variant): Boolean;
begin
  Result:=GetEventParams(SessionId,
                         FRemoteIP,FRemotePort,FRemoteUseCompressor,FRemoteCompressorLevel,
                         FRemoteUseCrypter,FRemoteCrypterKey,FRemoteCrypterAlgorithm,FRemoteCrypterMode);
end;

function TBisCallServerEventChannel.GetLocalEventParams: Boolean;
begin
  Result:=GetEventParams(Core.SessionId,
                         FIP,FPort,FUseCompressor,FCompressorLevel,
                         FUseCrypter,FCrypterKey,FCrypterAlgorithm,FCrypterMode);
end;

function TBisCallServerEventChannel.DialRequest(Request: TBisCallServerEventRequest): Boolean;

  procedure SendResponse(AMessage: String; AResponseType: TBisCallServerEventResponseType);
  var
    Response: TBisCallServerEventResponse;
  begin
    Response:=TBisCallServerEventResponse.Create(mdOutgoing,SEventResult);
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
  ResponseType: TBisCallServerEventResponseType;
begin
  Result:=false;
  if Assigned(Request) and Assigned(Core) then begin
    Message:='';
    ResponseType:=rtUnknown;
    try
      try
        FRemoteSessionId:=Request.RemoteSessionId;
        FRemoteDataPort:=Request.DataPort;
        FRemoteFormat:=FHandler.FDrivers.FindFormat('',Request.FormatTag,Request.Channels,
                                                    Request.SamplesPerSec,Request.BitsPerSample);
        FRemoteDataSize:=Request.DataSize;
        if GetRemoteEventParams(FRemoteSessionId) and Assigned(FRemoteFormat) then begin
          ResponseType:=rtCancel;
          FAcceptor:=Request.Acceptor;
          FAcceptorType:=Request.AcceptorType;
          if DoCheck then begin
            DoRing;
            ResponseType:=rtOK;
          end;
          Result:=true;
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

function TBisCallServerEventChannel.AnswerRequest(Request: TBisCallServerEventRequest): Boolean;

  procedure SendResponse(AMessage: String; AResponseType: TBisCallServerEventResponseType);
  var
    Response: TBisCallServerEventResponse;
  begin
    Response:=TBisCallServerEventResponse.Create(mdOutgoing,SEventResult);
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
  ResponseType: TBisCallServerEventResponseType;
begin
  Result:=false;
  if Assigned(Request) and Assigned(FHandler) and (State=csRinning) then begin
    Message:='';
    ResponseType:=rtUnknown;
    try
      try
        ResponseType:=rtCancel;
        FRemoteDataPort:=Request.DataPort;
        FRemoteFormat:=FHandler.FDrivers.FindFormat('',Request.FormatTag,Request.Channels,
                                                   Request.SamplesPerSec,Request.BitsPerSample);
        FRemoteDataSize:=Request.DataSize;
        if Assigned(FRemoteFormat) then begin
          DoConnect;
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

function TBisCallServerEventChannel.HangupRequest(Request: TBisCallServerEventRequest): Boolean;

  procedure SendResponse(AMessage: String; AResponseType: TBisCallServerEventResponseType);
  var
    Response: TBisCallServerEventResponse;
  begin
    Response:=TBisCallServerEventResponse.Create(mdOutgoing,SEventResult);
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
  ResponseType: TBisCallServerEventResponseType;
begin
  Result:=false;
  if Assigned(Request) and (State in [csRinning,csProcessing,csHolding]) then begin
    Message:='';
    ResponseType:=rtUnknown;
    try
      try
        DoDisconnect;
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

function TBisCallServerEventChannel.HoldRequest(Request: TBisCallServerEventRequest): Boolean;

  procedure SendResponse(AMessage: String; AResponseType: TBisCallServerEventResponseType);
  var
    Response: TBisCallServerEventResponse;
  begin
    Response:=TBisCallServerEventResponse.Create(mdOutgoing,SEventResult);
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
  ResponseType: TBisCallServerEventResponseType;
begin
  Result:=false;
  if Assigned(Request) and (State in [csProcessing]) then begin
    Message:='';
    ResponseType:=rtUnknown;
    try
      try
        DoHold;
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

function TBisCallServerEventChannel.UnHoldRequest(Request: TBisCallServerEventRequest): Boolean;

  procedure SendResponse(AMessage: String; AResponseType: TBisCallServerEventResponseType);
  var
    Response: TBisCallServerEventResponse;
  begin
    Response:=TBisCallServerEventResponse.Create(mdOutgoing,SEventResult);
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
  ResponseType: TBisCallServerEventResponseType;
begin
  Result:=false;
  if Assigned(Request) and (State in [csHolding]) then begin
    Message:='';
    ResponseType:=rtUnknown;
    try
      try
        DoUnHold;
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

function TBisCallServerEventChannel.DialResponse(Response: TBisCallServerEventResponse; var FreeChannel: Boolean): Boolean;
begin
  Result:=false;
  if Assigned(Response) then begin
    case Response.ResponseType of
      rtUnknown: ;
      rtOK: begin
        if DoCheck then begin
          DoRing;
          Result:=true;
        end;
      end;
      rtCancel: begin
        DoCancel;
        Result:=true;
        FreeChannel:=true;
      end;
      rtError: begin
        DoError(Response.Message);
        Result:=true;
        FreeChannel:=true;
      end;
    end;
  end;
end;

function TBisCallServerEventChannel.AnswerResponse(Response: TBisCallServerEventResponse; var FreeChannel: Boolean): Boolean;
begin
  Result:=false;
  if Assigned(Response) then begin
    case Response.ResponseType of
      rtUnknown: ;
      rtOK: begin
        DoConnect;
        Result:=true;
      end;
      rtCancel: ;
      rtError: begin
        DoError(Response.Message);
        Result:=true;
      end;
    end;
  end;
end;

function TBisCallServerEventChannel.HangupResponse(Response: TBisCallServerEventResponse; var FreeChannel: Boolean): Boolean;
begin
  Result:=false;
  if Assigned(Response) then begin
    case Response.ResponseType of
      rtUnknown: ;
      rtOK: begin
        DoDisconnect;
        FreeChannel:=true;
        Result:=true;
      end;
      rtCancel: ;
      rtError: begin
        DoError(Response.Message);
        Result:=true;
      end;
    end;
  end;
end;

procedure TBisCallServerEventChannel.Dial(Acceptor: Variant; AcceptorType: TBisCallServerChannelAcceptorType);
var
  Request: TBisCallServerEventRequest;
begin
  inherited Dial(Acceptor,AcceptorType);
  if Assigned(FHandler) and Assigned(Core) and Assigned(FOutFormat) then begin
    if not VarIsNull(Acceptor) and (AcceptorType=catSession) then begin
      if GetRemoteEventParams(Acceptor) and GetLocalEventParams() and TryServerActive then begin
        FRemoteSessionId:=Acceptor;
        Request:=TBisCallServerEventRequest.Create(mdOutgoing,SEventDial);
        with Request do begin
          AddSessionId(FRemoteSessionId);
          AddRemoteSessionId(Core.SessionId);
          AddChannelId(Self.FId);
          AddSequence(FRequests.NextSequence);
          AddDataPort(Self.DataPort);
          with FOutFormat^ do begin
            AddFormatTag(wFormatTag);
            AddChannels(nChannels);
            AddSamplesPerSec(nSamplesPerSec);
            AddBitsPerSample(wBitsPerSample);
          end;
          AddDataSize(FOutDataSize);
          AddCallId(Self.FCallId);
          AddCallerId(Self.FCallerId);
          AddCallerPhone(Self.FCallerPhone);
        end;
        FRequests.Add(Request);
        SendMessage(Request,true);
      end;
    end;
  end;
end;

procedure TBisCallServerEventChannel.Answer;
var
  Request: TBisCallServerEventRequest;
begin
  inherited Answer;
  if Assigned(FHandler) and Assigned(FOutFormat) and GetLocalEventParams and TryServerActive then begin
    Request:=TBisCallServerEventRequest.Create(mdOutgoing,SEventAnswer);
    with Request do begin
      AddSessionId(FRemoteSessionId);
      AddChannelId(Self.FId);
      AddSequence(FRequests.NextSequence);
      AddDataPort(Self.DataPort);
      with FOutFormat^ do begin
        AddFormatTag(wFormatTag);
        AddChannels(nChannels);
        AddSamplesPerSec(nSamplesPerSec);
        AddBitsPerSample(wBitsPerSample);
      end;
      AddDataSize(FOutDataSize);
    end;
    FRequests.Add(Request);
    SendMessage(Request,true);
  end;
end;

procedure TBisCallServerEventChannel.Hangup;
var
  Request: TBisCallServerEventRequest;
begin
  inherited Hangup;
  if Assigned(FHandler) then begin
    Request:=TBisCallServerEventRequest.Create(mdOutgoing,SEventHangup);
    with Request do begin
      AddSessionId(FRemoteSessionId);
      AddChannelId(Self.FId);
      AddSequence(FRequests.NextSequence);
    end;
    FRequests.Add(Request);
    SendMessage(Request,true);
  end;
end;

{ TBisCallServerEventChannels }

constructor TBisCallServerEventChannels.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  with Core.Events do begin
    FEventResult:=Add(SEventResult,ResultHandler,false);
    FEventDial:=Add(SEventDial,DialHandler,false);
    FEventAnswer:=Add(SEventAnswer,AnswerHandler,false);
    FEventHangup:=Add(SEventHangup,HangupHandler,false);
    FEventHold:=Add(SEventHold,HoldHandler,false);
    FEventUnHold:=Add(SEventUnHold,UnHoldHandler,false);
  end;
end;

destructor TBisCallServerEventChannels.Destroy;
begin
  with Core.Events do begin
    Remove(FEventUnHold);
    Remove(FEventHold);
    Remove(FEventHangup);
    Remove(FEventAnswer);
    Remove(FEventDial);
    Remove(FEventResult);
  end;
  inherited Destroy;
end;

procedure TBisCallServerEventChannels.DoDestroyChannel(Channel: TBisCallServerChannel);
begin
  if Assigned(Channel) then
    Channel.Hangup;
  inherited DoDestroyChannel(Channel);
end;

function TBisCallServerEventChannels.Find(Id: String): TBisCallServerEventChannel;
var
  i: Integer;
  Item: TBisCallServerEventChannel;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if AnsiSameText(Item.FId,Id) then begin
      Result:=Item;
      exit;
    end;
  end;
end;

function TBisCallServerEventChannels.Add(Id: String; Direction: TBisCallServerChannelDirection; CallId: Variant): TBisCallServerEventChannel;
begin
  Result:=Find(Id);
  if not Assigned(Result) then begin
    Result:=TBisCallServerEventChannel(inherited AddClass(TBisCallServerEventChannel,false));
    if Assigned(Result) then begin
      Result.FId:=Id;
      Result.FCallId:=CallId;
      Result.FChannels:=Self;
      Result.FHandler:=FHandler;
      Result.FDirection:=Direction;
    end;
  end;
end;

function TBisCallServerEventChannels.AddOutgoing(CallId, CallerId, CallerPhone: Variant): TBisCallServerEventChannel;
begin
  Result:=Add(GetUniqueID,cdOutgoing,CallId);
  if Assigned(Result) then begin
    Result.FCallerId:=CallerId;
    Result.FCallerPhone:=CallerPhone;
    DoCreateChannel(Result);
  end;
end;

function TBisCallServerEventChannels.AddIncoming(Request: TBisCallServerEventRequest): TBisCallServerEventChannel;
begin
  Result:=nil;
  if Assigned(Request) then begin
    Result:=Add(Request.ChannelId,cdIncoming,Request.CallId);
    if Assigned(Result) then begin
      Result.FCallerId:=Request.CallerId;
      Result.FCallerPhone:=Request.CallerPhone;
      Result.FRequests.Add(Request);
      DoCreateChannel(Result);
    end;
  end;
end;

function TBisCallServerEventChannels.GetItem(Index: Integer): TBisCallServerEventChannel;
begin
  Result:=TBisCallServerEventChannel(inherited Items[Index]);
end;

function TBisCallServerEventChannels.MaxDataPort(Default: Integer): Integer;
var
  i: Integer;
  Item: TBisCallServerEventChannel;
begin
  Result:=Default;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if Item.DataPort>Default then
      Result:=Item.DataPort;
  end;
end;

function TBisCallServerEventChannels.ResultHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
var
  Channel: TBisCallServerEventChannel;
  Response: TBisCallServerEventResponse;
  Request: TBisCallServerEventRequest;
  FreeChannel: Boolean;
begin
  Result:=false;
  Response:=TBisCallServerEventResponse.Create(mdIncoming,Event.Name,InParams);
  if Assigned(Response) then begin
    Channel:=Find(Response.ChannelId);
    if Assigned(Channel) then begin
      Request:=Channel.FRequests.Find(Response);
      if Assigned(Request) then begin
        Channel.FWaits.RemoveBy(Request);
        Request.Responses.Add(Response);

        FreeChannel:=false;

        if AnsiSameText(Response.RequestName,SEventDial) then
          Result:=Channel.DialResponse(Response,FreeChannel);

        if AnsiSameText(Response.RequestName,SEventAnswer) then
          Result:=Channel.AnswerResponse(Response,FreeChannel);

        if AnsiSameText(Response.RequestName,SEventHangup) then
          Result:=Channel.HangupResponse(Response,FreeChannel);

        if not Result then
          Request.Responses.Remove(Response);

        if FreeChannel then
          Remove(Channel);

      end else
        Response.Free;
    end else
      Response.Free;
  end;
end;

function TBisCallServerEventChannels.DialHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
var
  Request: TBisCallServerEventRequest;
  Channel: TBisCallServerEventChannel;
begin
  Result:=false;
  Request:=TBisCallServerEventRequest.Create(mdIncoming,Event.Name,InParams);
  if Assigned(Request) then begin
    Channel:=AddIncoming(Request);
    if Assigned(Channel) then begin
      Result:=Channel.DialRequest(Request);
      if not Result then
        Remove(Channel);
    end else
      Request.Free;
  end;
end;

function TBisCallServerEventChannels.AnswerHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
var
  Request: TBisCallServerEventRequest;
  Channel: TBisCallServerEventChannel;
begin
  Result:=false;
  Request:=TBisCallServerEventRequest.Create(mdIncoming,Event.Name,InParams);
  if Assigned(Request) then begin
    Channel:=Find(Request.ChannelId);
    if Assigned(Channel) then begin
      Channel.FRequests.Add(Request);
      Result:=Channel.AnswerRequest(Request);
    end else
      Request.Free;
  end;
end;

function TBisCallServerEventChannels.HangupHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
var
  Request: TBisCallServerEventRequest;
  Channel: TBisCallServerEventChannel;
begin
  Result:=false;
  Request:=TBisCallServerEventRequest.Create(mdIncoming,Event.Name,InParams);
  if Assigned(Request) then begin
    Channel:=Find(Request.ChannelId);
    if Assigned(Channel) then begin
      Channel.FRequests.Add(Request);
      Result:=Channel.HangupRequest(Request);
      Remove(Channel);
    end else
      Request.Free;
  end;
end;

function TBisCallServerEventChannels.HoldHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
var
  Request: TBisCallServerEventRequest;
  Channel: TBisCallServerEventChannel;
begin
  Result:=false;
  Request:=TBisCallServerEventRequest.Create(mdIncoming,Event.Name,InParams);
  if Assigned(Request) then begin
    Channel:=Find(Request.ChannelId);
    if Assigned(Channel) then begin
      Channel.FRequests.Add(Request);
      Result:=Channel.HoldRequest(Request);
    end else
      Request.Free;
  end;
end;

function TBisCallServerEventChannels.UnHoldHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
var
  Request: TBisCallServerEventRequest;
  Channel: TBisCallServerEventChannel;
begin
  Result:=false;
  Request:=TBisCallServerEventRequest.Create(mdIncoming,Event.Name,InParams);
  if Assigned(Request) then begin
    Channel:=Find(Request.ChannelId);
    if Assigned(Channel) then begin
      Channel.FRequests.Add(Request);
      Result:=Channel.UnHoldRequest(Request);
    end else
      Request.Free;
  end;
end;

{ TBisCallServerEventHandler }

constructor TBisCallServerEventHandler.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Channels.FHandler:=Self;

  FDrivers:=TBisAcmDrivers.Create;

  FWaitRetryCount:=3;
  FWaitTimeOut:=1000;
end;

destructor TBisCallServerEventHandler.Destroy;
begin
  FDrivers.Free;
  inherited Destroy;
end;

procedure TBisCallServerEventHandler.Init;
var
  N, V: String;
begin
  inherited Init;
  if Params.Active and not Params.Empty then begin
    Params.First;
    while not Params.Eof do begin
      N:=Params.FieldByName(SFieldName).AsString;
      V:=Params.FieldByName(SFieldValue).AsString;

      if AnsiSameText(N,SParamRequestRetryCount) then FWaitRetryCount:=StrToIntDef(V,FWaitRetryCount);
      if AnsiSameText(N,SParamRequestTimeOut) then FWaitTimeOut:=StrToIntDef(V,FWaitTimeOut);

      Params.Next;
    end;
  end;
end;

function TBisCallServerEventHandler.AddOutgoingChannel(CallId,CallerId,CallerPhone: Variant): TBisCallServerChannel;
begin
  Result:=Channels.AddOutgoing(CallId,CallerId,CallerPhone);
end;

function TBisCallServerEventHandler.GetChannels: TBisCallServerEventChannels;
begin
  Result:=TBisCallServerEventChannels(inherited Channels);
end;

function TBisCallServerEventHandler.GetChannelsClass: TBisCallServerChannelsClass;
begin
  Result:=TBisCallServerEventChannels;
end;

function TBisCallServerEventHandler.GetConnected: Boolean;
begin
  Result:=inherited GetConnected;
  if Assigned(Core) then
    Result:=true;
end;

procedure TBisCallServerEventHandler.Connect;
begin
  inherited Connect;
end;

procedure TBisCallServerEventHandler.Disconnect;
begin
  inherited Disconnect;
end;

end.