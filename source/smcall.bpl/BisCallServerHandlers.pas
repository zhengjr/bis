unit BisCallServerHandlers;

interface

uses Classes, Contnrs,
     BisObject, BisCoreObjects, BisDataSet, BisVariants, BisDataParams,
     BisCallServerChannels;

type
  TBisCallServerHandler=class;

  TBisCallServerHandlers=class;

  TBisCallServerHandlerLocation=(hlUnknown,hlInternal,hlExternal);

  TBisCallServerHandlerDirection=(hdBoth,hdIncoming,hdOutgoing);
  TBisCallServerHandlerDirections=set of TBisCallServerHandlerDirection;

  TBisCallServerHandler=class(TBisCoreObject)
  private
    FParams: TBisDataValueParams;
    FOperatorIds: TBisVariants;
    FEnabled: Boolean;
    FChannels: TBisCallServerChannels;
    FVolume: Integer;
    FLocation: TBisCallServerHandlerLocation;
    FSDisconnectFail: String;
    FSConnectSuccess: String;
    FSDisconnect: String;
    FSDisconnectSuccess: String;
    FSConnectFail: String;
    FSConnect: String;
    FDirection: TBisCallServerHandlerDirection;
  protected
    function GetChannelsClass: TBisCallServerChannelsClass; virtual;
    function GetBusy: Boolean; virtual;
    function GetConnected: Boolean; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;

    procedure Connect; virtual;
    procedure Disconnect; virtual;
    function AddOutgoingChannel(CallId,CallerId,CallerPhone: Variant): TBisCallServerChannel; virtual;

    property Params: TBisDataValueParams read FParams;
    property Channels: TBisCallServerChannels read FChannels;
    property Location: TBisCallServerHandlerLocation read FLocation;
    property OperatorIds: TBisVariants read FOperatorIds;
    property Connected: Boolean read GetConnected;
    property Busy: Boolean read GetBusy;
    property Direction: TBisCallServerHandlerDirection read FDirection;

    property Enabled: Boolean read FEnabled write FEnabled;

  published
    property SConnect: String read FSConnect write FSConnect;
    property SConnectSuccess: String read FSConnectSuccess write FSConnectSuccess;
    property SConnectFail: String read FSConnectFail write FSConnectFail;

    property SDisconnect: String read FSDisconnect write FSDisconnect;
    property SDisconnectSuccess: String read FSDisconnectSuccess write FSDisconnectSuccess;
    property SDisconnectFail: String read FSDisconnectFail write FSDisconnectFail;
  end;

  TBisCallServerHandlerClass=class of TBisCallServerHandler;

  TBisCallServerHandlersCreateEvent=procedure (Handlers: TBisCallServerHandlers; Handler: TBisCallServerHandler) of object;
  TBisCallServerHandlersDestroyEvent=procedure (Handlers: TBisCallServerHandlers; Handler: TBisCallServerHandler) of object;

  TBisCallServerHandlers=class(TBisCoreObjects)
  private
    FOnCreateHandler: TBisCallServerHandlersCreateEvent;
    FOnDestroyHandler: TBisCallServerHandlersDestroyEvent;
    function GetItem(Index: Integer): TBisCallServerHandler;
  protected
    function GetObjectClass: TBisObjectClass; override;
    procedure DoItemFree(Obj: TBisObject); override;
    procedure DoCreateHandler(Handler: TBisCallServerHandler); virtual;
    procedure DoDestroyHandler(Handler: TBisCallServerHandler); virtual;
  public
    destructor Destroy; override;


    function AddClass(AClass: TBisCallServerHandlerClass; const ObjectName: String=''): TBisCallServerHandler;
    function AddHandler(Handler: TBisCallServerHandler): Boolean;
    procedure Connect;
    procedure Disconnect;
    procedure GetHandlers(Location: TBisCallServerHandlerLocation; Directions: TBisCallServerHandlerDirections;
                          OperatorId: Variant; Handlers: TObjectList);

    property Items[Index: Integer]: TBisCallServerHandler read GetItem; default;

    property OnCreateHandler: TBisCallServerHandlersCreateEvent read FOnCreateHandler write FOnCreateHandler;
    property OnDestroyHandler: TBisCallServerHandlersDestroyEvent read FOnDestroyHandler write FOnDestroyHandler;
  end;


implementation

uses SysUtils, Variants,
     BisUtils, BisConsts,
     BisCallServerConsts;

{ TBisCallServerHandler }

constructor TBisCallServerHandler.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FParams:=TBisDataValueParams.Create;

  FChannels:=GetChannelsClass.Create;
  FChannels.DialTimeout:=10000;
  FChannels.AnswerTimeout:=30000;
  FChannels.HangupTimeout:=2000;
  FChannels.AliveTimeout:=5000;

  FOperatorIds:=TBisVariants.Create;

  FVolume:=100;

  FSConnect:='����������� ����������� ...';
  FSConnectSuccess:='����������� ����������� ������ �������.';
  FSConnectFail:='����������� ����������� �� ������. %s';

  FSDisconnect:='���������� ����������� ...';
  FSDisconnectSuccess:='���������� ����������� ������ �������.';
  FSDisconnectFail:='���������� ����������� �� ������. %s';
  
end;

destructor TBisCallServerHandler.Destroy;
begin
  FOperatorIds.Free;
  FChannels.Free;
  FParams.Free;
  inherited Destroy;
end;

procedure TBisCallServerHandler.Disconnect;
begin
  FChannels.Clear;
end;

procedure TBisCallServerHandler.Connect;
begin
  FChannels.Clear;
end;

function TBisCallServerHandler.AddOutgoingChannel(CallId,CallerId,CallerPhone: Variant): TBisCallServerChannel;
begin
  Result:=nil;
end;                                                          

function TBisCallServerHandler.GetBusy: Boolean;
begin
  Result:=false;
end;

function TBisCallServerHandler.GetChannelsClass: TBisCallServerChannelsClass;
begin
  Result:=TBisCallServerChannels;
end;

function TBisCallServerHandler.GetConnected: Boolean;
begin
  Result:=false;
end;

procedure TBisCallServerHandler.Init;
var
  S: String;

begin
  inherited Init;

  with FParams do begin
    FLocation:=AsEnumeration(SParamLocation,TypeInfo(TBisCallServerHandlerLocation),FLocation);
    FDirection:=AsEnumeration(SParamDirection,TypeInfo(TBisCallServerHandlerDirection),FDirection);
    FVolume:=AsInteger(SParamVolume,FVolume);

    FChannels.DialTimeout:=AsInteger(SParamDialTimeout,FChannels.DialTimeout);
    FChannels.AnswerTimeout:=AsInteger(SParamAnswerTimeout,FChannels.AnswerTimeout);
    FChannels.HangupTimeout:=AsInteger(SParamHangupTimeout,FChannels.HangupTimeout);
    FChannels.AliveTimeout:=AsInteger(SParamAliveTimeout,FChannels.AliveTimeout);

    FOperatorIds.Clear;
    S:=AsString(SParamOperatorIds);
    FOperatorIds.AddStringsText(S);
  end;

  FChannels.Volume:=FVolume;
  case FLocation of
    hlUnknown: FChannels.Location:=clUnknown;
    hlInternal: FChannels.Location:=clInternal;
    hlExternal: FChannels.Location:=clExternal;
  end;

  FChannels.Init;

end;

{ TBisCallServerHandlers }

destructor TBisCallServerHandlers.Destroy;
begin
  inherited Destroy;
end;

procedure TBisCallServerHandlers.DoCreateHandler(Handler: TBisCallServerHandler);
begin
  if Assigned(FOnCreateHandler) then
    FOnCreateHandler(Self,Handler);
end;

procedure TBisCallServerHandlers.DoDestroyHandler(Handler: TBisCallServerHandler);
begin
  if Assigned(FOnDestroyHandler) then
    FOnDestroyHandler(Self,Handler);
end;

function TBisCallServerHandlers.GetItem(Index: Integer): TBisCallServerHandler;
begin
  Result:=TBisCallServerHandler(inherited Items[Index]);
end;

function TBisCallServerHandlers.GetObjectClass: TBisObjectClass;
begin
  Result:=TBisCallServerHandler;
end;

function TBisCallServerHandlers.AddClass(AClass: TBisCallServerHandlerClass; const ObjectName: String): TBisCallServerHandler;
begin
  Result:=nil;
  if Assigned(AClass) then begin
    Result:=AClass.Create(Self);
    if Trim(ObjectName)<>'' then
      Result.ObjectName:=ObjectName;
    if not Assigned(Find(Result.ObjectName)) then begin
      AddObject(Result);
      DoCreateHandler(Result);
    end else begin
      FreeAndNilEx(Result);
    end;
  end;
end;

function TBisCallServerHandlers.AddHandler(Handler: TBisCallServerHandler): Boolean;
begin
  Result:=false;
  if not Assigned(Find(Handler.ObjectName)) then begin
    AddObject(Handler);
    Result:=true;
  end;
end;

procedure TBisCallServerHandlers.DoItemFree(Obj: TBisObject);
begin
  if Assigned(Obj) and (Obj is TBisCallServerHandler) then
    DoDestroyHandler(TBisCallServerHandler(Obj));
  inherited DoItemFree(Obj);
end;

procedure TBisCallServerHandlers.Connect;
var
  Item: TBisCallServerHandler;
  i: Integer;
begin
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if Item.Enabled then
      Item.Connect;
  end;
end;

procedure TBisCallServerHandlers.Disconnect;
var
  Item: TBisCallServerHandler;
  i: Integer;
begin
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if Item.Enabled then
      Item.Disconnect;
  end;
end;

procedure TBisCallServerHandlers.GetHandlers(Location: TBisCallServerHandlerLocation; Directions: TBisCallServerHandlerDirections;
                                             OperatorId: Variant; Handlers: TObjectList);
var
  Item: TBisCallServerHandler;
  i: Integer;
  Flag: Boolean;
begin
  if Assigned(Handlers) then
    for i:=0 to Count-1 do begin
      Item:=Items[i];
      if Item.Enabled and (Item.Location=Location) and (Item.Direction in Directions) and
         Item.Connected and not Item.Busy then begin
        Flag:=true;
        if not VarIsNull(OperatorId) and (Item.OperatorIds.Count>0) then
          Flag:=Assigned(Item.OperatorIds.Find(OperatorId));
        if Flag then
          Handlers.Add(Item);
      end;
    end;
end;

end.