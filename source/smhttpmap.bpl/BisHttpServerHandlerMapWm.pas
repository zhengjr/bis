unit BisHttpServerHandlerMapWm;

interface

uses Forms,
     SysUtils, Classes, HTTPApp, DB, Contnrs, SyncObjs,
     BisLogger,
     BisDataParams, BisDataSet, BisSystemUtils,
     BisHttpServerHandlers;

type
  TBisHttpServerHandlerMapServerType=(stHttpGet{,stHttpPost});

  TBisHttpServerHandlerMapServer=class(TBisDataParam)
  private
    FParams: TBisDataValueParams;
  protected
    procedure SetDataSet(DataSet: TBisDataSet); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure CopyFrom(Source: TBisDataParam); override;

    function &Type: TBisHttpServerHandlerMapServerType;
    function RouteUrl: String;
    function RouteTrafficParams: String;
    function GeocodeUrl: String;
    function UserName: String;
    function Password: String;
    function UserAgent: String;
    function DistanceIdent: String;
    function DurationIdent: String;
    function LatitudeIdent: String;
    function LongitudeIdent: String;
    function Timeout: Integer;
    function ReadTimeout: Integer;
    function GeocodeUtfParams: Boolean;
  end;

  TBisHttpServerHandlerMapServers=class(TBisDataParams)
  private
    function GetItem(Index: Integer): TBisHttpServerHandlerMapServer;
  protected
    class function GetDataParamClass: TBisDataParamClass; override;
  public
    property Items[Index: Integer]: TBisHttpServerHandlerMapServer read GetItem; default;
  end;

  TBisHttpServerHandlerMapWebModuleExecuteMode=(emDistance,emDuration);
  TBisHttpServerHandlerMapWebModuleExecuteModes=set of TBisHttpServerHandlerMapWebModuleExecuteMode;

  TBisHttpServerHandlerMapWebModule = class(TWebModule)
    procedure BisHttpServerHandlerMapWebModuleDefaultAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure BisHttpServerHandlerMapWebModuleDistanceAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure BisHttpServerHandlerMapWebModuleDurationAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure BisHttpServerHandlerMapWebModuleGeocodeAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
    procedure BisHttpServerHandlerMapWebModuleRouteAction(Sender: TObject; Request: TWebRequest; Response: TWebResponse;
      var Handled: Boolean);
  private
    FHandler: TBisHttpServerHandler;
    FServers: TBisHttpServerHandlerMapServers;
    FSCoordinates: String;
    FSDistance: String;
    FSLocation: String;
    FSPosition: String;
    FServersTimeout: Cardinal;

    function ExecuteRoute(Request: TWebRequest; Response: TWebResponse;
                          Modes: TBisHttpServerHandlerMapWebModuleExecuteModes): Boolean;
    function ExecuteGeocode(Request: TWebRequest; Response: TWebResponse): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Handler: TBisHttpServerHandler read FHandler write FHandler;
    property Servers: TBisHttpServerHandlerMapServers read FServers;
    property ServersTimeout: Cardinal read FServersTimeout write FServersTimeout;

  published
    property SCoordinates: String read FSCoordinates write FSCoordinates;
    property SDistance: String read FSDistance write FSDistance;
  end;

var
  BisHttpServerHandlerMapWebModule: TBisHttpServerHandlerMapWebModule;

implementation

{$R *.dfm}

uses Windows, Variants, StrUtils,
     IdAssignedNumbers, IdHTTP, IdURI, IdAuthentication,
     SuperObject, RegExpr,
     BisCore, BisConsts, BisUtils, BisCoreUtils, BisThreads, BisNetUtils,
     BisConfig, BisValues, BisVariants,
     BisHttpServerHandlerMapConsts;

function PrepareDouble(const S: String; var F: Double): Boolean;
var
  S1: String;
begin
  S1:=Trim(S);
  S1:=ReplaceText(S1,'.',DecimalSeparator);
  S1:=ReplaceText(S1,',',DecimalSeparator);
  Result:=TryStrToFloat(S1,F);
end;

function DoubleAsString(const F: Double): String;
var
  FS: TFormatSettings;
begin
  FS.DecimalSeparator:='.';
  Result:=FloatToStr(F,FS);
end;

function Utf8DecodeEx(const S: UTF8String): WideString;
var
  L: Integer;
  Temp: WideString;
begin
  Result := '';
  if S = '' then Exit;
  SetLength(Temp, Length(S));

  L := Utf8ToUnicode(PWideChar(Temp), Length(Temp)+1, PChar(S), Length(S));
  if L > 0 then
    SetLength(Temp, L-1)
  else
    Temp := S;
  Result := Temp;
end;



{ TBisHttpServerHandlerMapServer }

constructor TBisHttpServerHandlerMapServer.Create;
begin
  inherited Create;
  FParams:=TBisDataValueParams.Create;
end;

destructor TBisHttpServerHandlerMapServer.Destroy;
begin
  FParams.Free;
  inherited Destroy;
end;

procedure TBisHttpServerHandlerMapServer.SetDataSet(DataSet: TBisDataSet);
var
  Field: TField;
begin
  inherited SetDataSet(DataSet);

  FParams.Clear;
  Field:=DataSet.FindField(SFieldParams);
  if Assigned(Field) then
    FParams.CopyFromDataSet(Field.AsString);

end;

procedure TBisHttpServerHandlerMapServer.CopyFrom(Source: TBisDataParam);
begin
  inherited CopyFrom(Source);
  if Assigned(Source) and (Source is TBisHttpServerHandlerMapServer) then
    FParams.CopyFrom(TBisHttpServerHandlerMapServer(Source).FParams);
end;

function TBisHttpServerHandlerMapServer.RouteTrafficParams: String;
begin
  Result:=FParams.AsString(SParamRouteTrafficParams);
end;

function TBisHttpServerHandlerMapServer.RouteUrl: String;
begin
  Result:=FParams.AsString(SParamRouteUrl);
end;

function TBisHttpServerHandlerMapServer.Password: String;
begin
  Result:=FParams.AsString(SParamPassword);
end;

function TBisHttpServerHandlerMapServer.ReadTimeout: Integer;
begin
  Result:=FParams.AsInteger(SParamReadTimeout);
end;

function TBisHttpServerHandlerMapServer.DistanceIdent: String;
begin
  Result:=FParams.AsString(SParamDistanceIdent);
end;

function TBisHttpServerHandlerMapServer.DurationIdent: String;
begin
  Result:=FParams.AsString(SParamDurationIdent);
end;

function TBisHttpServerHandlerMapServer.GeocodeUrl: String;
begin
  Result:=FParams.AsString(SParamGeocodeUrl);
end;

function TBisHttpServerHandlerMapServer.GeocodeUtfParams: Boolean;
begin
  Result:=FParams.AsBoolean(SParamGeocodeUtfParams,true);
end;

function TBisHttpServerHandlerMapServer.LatitudeIdent: String;
begin
  Result:=FParams.AsString(SParamLatitudeIdent);
end;

function TBisHttpServerHandlerMapServer.LongitudeIdent: String;
begin
  Result:=FParams.AsString(SParamLongitudeIdent);
end;

function TBisHttpServerHandlerMapServer.&Type: TBisHttpServerHandlerMapServerType;
begin
  Result:=FParams.AsEnumeration(SParamType,TypeInfo(TBisHttpServerHandlerMapServerType),stHttpGet);
end;

function TBisHttpServerHandlerMapServer.Timeout: Integer;
begin
  Result:=FParams.AsInteger(SParamTimeout);
end;

function TBisHttpServerHandlerMapServer.UserAgent: String;
begin
  Result:=FParams.AsString(SParamUserAgent);
end;

function TBisHttpServerHandlerMapServer.UserName: String;
begin
  Result:=FParams.AsString(SParamUserName);
end;

{ TBisHttpServerHandlerMapServers }

class function TBisHttpServerHandlerMapServers.GetDataParamClass: TBisDataParamClass;
begin
  Result:=TBisHttpServerHandlerMapServer;
end;

function TBisHttpServerHandlerMapServers.GetItem(Index: Integer): TBisHttpServerHandlerMapServer;
begin
  Result:=TBisHttpServerHandlerMapServer(inherited Items[Index]);
end;

type
  TBisMapServerThreadParam=class(TBisValue)
  private
    FIdent: String;
    function Get(Index: Integer): String;
  public
    function Location: String;
    function Expression: String;
  end;

  TBisMapServerThreadParams=class(TBisValues)
  private
    function GetItem(Index: Integer): TBisMapServerThreadParam;
  protected
    function GetVariantClass: TBisVariantClass; override;
  public
    function Add(const Name, Ident: String): TBisMapServerThreadParam;
    
    property Items[Index: Integer]: TBisMapServerThreadParam read GetItem; default;
  end;

{ TBisMapServerThreadParam }

function TBisMapServerThreadParam.Get(Index: Integer): String;
var
  Str: TStringList;
begin
  Str:=TStringList.Create;
  try
    Str.Text:=FIdent;
    if Str.Count>Index then
      Result:=Str[Index];
  finally
    Str.Free;
  end;
end;

function TBisMapServerThreadParam.Expression: String;
begin
  Result:=Get(1);
end;

function TBisMapServerThreadParam.Location: String;
begin
  Result:=Get(0);
end;

{ TBisMapServerThreadParams }

function TBisMapServerThreadParams.GetVariantClass: TBisVariantClass;
begin
  Result:=TBisMapServerThreadParam;
end;

function TBisMapServerThreadParams.Add(const Name,Ident: String): TBisMapServerThreadParam;
begin
  Result:=TBisMapServerThreadParam(inherited Add(Name));
  if Assigned(Result) then
    Result.FIdent:=Ident;
end;

function TBisMapServerThreadParams.GetItem(Index: Integer): TBisMapServerThreadParam;
begin
  Result:=TBisMapServerThreadParam(inherited Items[Index]);
end;

type
  TBisMapServerThread=class(TBisThread)
  private
    FLoggerName: String;
    FServer: TBisHttpServerHandlerMapServer;
    FParams: TBisMapServerThreadParams;
    FLastResult: String;

    procedure ProcessResult(const S: String);
    function GetResult: String;
  protected
    procedure DoBegin; override;
    procedure DoWork; override;
    procedure DoEnd; override;
    procedure DoError(const E: Exception); override;
    function GetHttpUrl: String; virtual;

    procedure LoggerWrite(Message: String; LogType: TBisLoggerType=ltInformation);
    function UrlServerExists(const Url: String; var Host,IP: String; var Port: Integer): Boolean;
  public
    constructor Create(WebModule: TBisHttpServerHandlerMapWebModule;
                       Server: TBisHttpServerHandlerMapServer); reintroduce;
    destructor Destroy; override;

  end;

{ TBisMapServerThread }

constructor TBisMapServerThread.Create(WebModule: TBisHttpServerHandlerMapWebModule;
                                       Server: TBisHttpServerHandlerMapServer);
begin
  inherited Create;
  FreeOnEnd:=false;
  StopOnDestroy:=false;
  FServer:=TBisHttpServerHandlerMapServer.Create;
  FServer.CopyFrom(Server);
  FLoggerName:=WebModule.Handler.ObjectName+FServer.Name;
  FParams:=TBisMapServerThreadParams.Create;
end;

destructor TBisMapServerThread.Destroy;
begin
  FParams.Free;
  FServer.Free;
  inherited Destroy;
end;

procedure TBisMapServerThread.LoggerWrite(Message: String; LogType: TBisLoggerType);
begin
  BisCoreUtils.ObjectLoggerWrite(FLoggerName,Message,LogType);
end;

procedure TBisMapServerThread.DoBegin;
begin
  FParams.Clear;
end;

procedure TBisMapServerThread.DoEnd;
var
  Item: TBisMapServerThreadParam;
  Flag: Boolean;
  i: Integer;
  S,S1: String;
begin
  Flag:=false;
  for i:=0 to FParams.Count-1 do begin
    Item:=FParams[i];
    if not Flag then
      Flag:=Item.ValueExists;
    S1:=FormatEx('%s=%s',[Item.Name]);
    S:=iff(i=0,S1,S+' '+S1);
  end;
  if Flag then
    LoggerWrite(FormatEx(S,FParams))
  else
    if FLastResult<>'' then
      LoggerWrite(FormatEx('��������� => %s',[FLastResult]),ltError);

end;

procedure TBisMapServerThread.DoError(const E: Exception);
begin
  if Assigned(E) then
    LoggerWrite(E.Message,ltError);
end;

function TBisMapServerThread.UrlServerExists(const Url: String; var Host,IP: String; var Port: Integer): Boolean;
var
  Uri: TIdURI;
begin
  Result:=false;
  if Trim(Url)<>'' then begin
    Uri:=TIdURI.Create(Url);
    try
      try
        Host:=Uri.Host;
        Port:=StrToIntDef(Uri.Port,IdPORT_HTTP);
        if not IsIP(Host) then
          IP:=ResolveIP(Host)
        else IP:=Host;
        Result:=ServerExists(IP,Port,FServer.Timeout);
      except
      end;
    finally
      Uri.Free;
    end;
  end;
end;

function TBisMapServerThread.GetHttpUrl: String;
begin
  Result:='';
end;

function TBisMapServerThread.GetResult: String;

  function GetHttpGet: String;

    function EncodeParamValues(Url: String): String;

      function Encode(Params: String): String;
      var
        Str: TStringList;
        List: TBisValues;
        Item: TBisValue;
        i: Integer;
        S1: String;
      begin
        Result:='';
        Str:=TStringList.Create;
        List:=TBisValues.Create;
        try
          GetStringsByString(Params,'&',Str);
          for i:=0 to Str.Count-1 do begin
            S1:=HTTPEncode(Str.ValueFromIndex[i]);
            if Trim(Str.Names[i])<>'' then
              List.Add(Str.Names[i],S1);
          end;
          for i:=0 to List.Count-1 do begin
            Item:=List[i];
            S1:=FormatEx('%s=%s',[Item.Name,Item.AsString]);
            Result:=iff(i=0,S1,Result+'&'+S1);
          end;
        finally
          List.Free;
          Str.Free;
        end;
      end;

    var
      Uri: TIdURI;
    begin
      Result:=Url;
      Uri:=TIdURI.Create(Url);
      try
        try
          Uri.Params:=Encode(Uri.Params);
          Result:=Uri.GetFullURI([ofBookmark]);
        except
        end;
      finally
        Uri.Free;
      end;
    end;

  var
    Url,S1: String;
    Host,IP: String;
    Port: Integer;
    Http: TIdHttp;
  begin
    Result:='';

    Url:=GetHttpUrl;
    LoggerWrite(Url);
    S1:=EncodeParamValues(Url);
    if S1<>Url then begin
      Url:=S1;
      LoggerWrite(Url);
    end;

    if not Terminated and UrlServerExists(Url,Host,IP,Port) then begin

      if IP<>Host then
        LoggerWrite(FormatEx('%s:%d (%s)',[Host,Port,IP]))
      else
        LoggerWrite(FormatEx('%s:%d',[Host,Port]));

      Http:=TIdHttp.Create(nil);
      try

        Http.Request.UserAgent:=FServer.UserAgent;
        Http.ReadTimeout:=FServer.ReadTimeout;

        if Trim(FServer.UserName)<>'' then begin
          Http.Request.BasicAuthentication:=true;
          if not Assigned(Http.Request.Authentication) then
            Http.Request.Authentication:=TIdBasicAuthentication.Create;
          Http.Request.Authentication.Username:=FServer.UserName;
          Http.Request.Authentication.Password:=FServer.Password;
        end;

        try
          Result:=Http.Get(Url);
        except
          on E: Exception do
            LoggerWrite(E.Message,ltError);
        end;

      finally
        Http.Free;
      end;

    end else
      LoggerWrite(FormatEx('%s:%d �� ������',[Host,Port]),ltError);
  end;

begin
  Result:='';
  if not Terminated then begin
    case FServer.&Type of
      stHttpGet: Result:=GetHttpGet;
    end;
    if FLastResult<>Result then
      FLastResult:=Result;
  end;
end;

procedure TBisMapServerThread.ProcessResult(const S: String);

    function Expression(Text,Ident: String): String;
    var
      Expr: TRegExpr;
    begin
      Result:='';
      try
        if Ident<>'' then begin
          Expr:=TRegExpr.Create;
          try
            Expr.Expression:=Ident;
            Expr.ModifierStr:='rsg-imx';
            Expr.Compile;
            if Expr.Exec(Text) then begin
              if Expr.SubExprMatchCount>0 then
                Result:=Expr.Match[Expr.SubExprMatchCount];
            end;
          finally
            Expr.Free;
          end;
        end;
      except
        On E: Exception do
          LoggerWrite(E.Message,ltError);
      end;
    end;

    procedure ProcessJson;
    var
      Json: ISuperObject;

      procedure SetParamValue(Item: TBisMapServerThreadParam);
      var
        L,E: String;
        Obj: ISuperObject;
        Ident: WideString;
        Text: String;
      begin
        L:=Item.Location;
        E:=Item.Expression;
        Text:='';
        try
          case Json.DataType of
            stInt,stCurrency,stDouble,stString: begin
              Text:=Json.AsString;
            end;
          else
            if Trim(L)<>'' then begin
              Ident:=L;
              Obj:=TSuperObject.ParseString(PWideChar(Ident),False,True,Json);
              if Assigned(Obj) then begin
                Text:=Obj.AsString;
              end;
            end;
          end;
        finally
          if Trim(Text)<>'' then begin
            if Trim(E)<>'' then begin
              Text:=Expression(Text,E);
              if Trim(Text)<>'' then
                Item.Value:=Text;
            end else
              Item.Value:=Text;
          end;
        end;
      end;

    var
      W: WideString;
      i: Integer;
    begin
      try
        W:=S;
        Json:=TSuperObject.ParseString(PWideChar(W),false);
        if Assigned(Json) then begin
          for i:=0 to FParams.Count-1 do begin
            if not Terminated then
              SetParamValue(FParams[i]);
          end;
        end;
      except
        On E: Exception do
          LoggerWrite(E.Message,ltError);
      end;
    end;   

  function TextIsJson: Boolean;
  begin
    Result:=true;
  end;
  
begin
  if TextIsJson then
    ProcessJson;
end;

procedure TBisMapServerThread.DoWork;
var
  S: String;
begin
  S:=GetResult;
  if not Terminated then
    ProcessResult(S);
end;


type
  TBisMapRouteServerThread=class(TBisMapServerThread)
  private
    FLat1,FLon1,FLat2,FLon2: Double;
    FTraffic: Boolean;
    FDistance,FDuration: TBisMapServerThreadParam;
  protected
    procedure DoBegin; override;
    procedure DoEnd; override;
    function GetHttpUrl: String; override;
  public
    constructor Create(WebModule: TBisHttpServerHandlerMapWebModule;
                       Server: TBisHttpServerHandlerMapServer;
                       Lat1,Lon1,Lat2,Lon2: Double; Traffic: Boolean); reintroduce;
  end;

{ TBisMapRouteServerThread }

constructor TBisMapRouteServerThread.Create(WebModule: TBisHttpServerHandlerMapWebModule;
                                            Server: TBisHttpServerHandlerMapServer;
                                            Lat1,Lon1,Lat2,Lon2: Double; Traffic: Boolean);
begin
  inherited Create(WebModule,Server);
  FLat1:=Lat1;
  FLon1:=Lon1;
  FLat2:=Lat2;
  FLon2:=Lon2;
  FTraffic:=Traffic;
end;

function TBisMapRouteServerThread.GetHttpUrl: String;
begin
  Result:=FServer.RouteUrl;
  Result:=ReplaceText(Result,'%LON1',DoubleAsString(FLon1));
  Result:=ReplaceText(Result,'%LAT1',DoubleAsString(FLat1));
  Result:=ReplaceText(Result,'%LON2',DoubleAsString(FLon2));
  Result:=ReplaceText(Result,'%LAT2',DoubleAsString(FLat2));
  if FTraffic then
    Result:=Result+FServer.RouteTrafficParams;
end;

procedure TBisMapRouteServerThread.DoBegin;
begin
  inherited DoBegin;
  FDistance:=FParams.Add('����������',FServer.DistanceIdent);
  FDuration:=FParams.Add('�����',FServer.DurationIdent);
end;


procedure TBisMapRouteServerThread.DoEnd;
var
  F: Double;
begin
  inherited DoEnd;

  if FDistance.ValueExists then
    if PrepareDouble(FDistance.AsString,F) then
      FDistance.Value:=F;

  if FDuration.ValueExists then
    if PrepareDouble(FDuration.AsString,F) then
      FDuration.Value:=Round(F);

end;

type
  TBisMapGeocodeServerThread=class(TBisMapServerThread)
  private
    FCountry,FRegion,FLocality,FStreet,FHouse: String;
    FLatitude,FLongitude: TBisMapServerThreadParam;
  protected
    procedure DoBegin; override;
    procedure DoEnd; override;
    function GetHttpUrl: String; override;
  public
    constructor Create(WebModule: TBisHttpServerHandlerMapWebModule;
                       Server: TBisHttpServerHandlerMapServer;
                       Country,Region,Locality,Street,House: WideString); reintroduce;
  end;

{ TBisMapGeocodeServerThread }

constructor TBisMapGeocodeServerThread.Create(WebModule: TBisHttpServerHandlerMapWebModule;
                                              Server: TBisHttpServerHandlerMapServer;
                                              Country,Region,Locality,Street,House: WideString);
begin
  inherited Create(WebModule,Server);
  FCountry:=Country;
  FRegion:=Region;
  FLocality:=Locality;
  FStreet:=Street;
  FHouse:=House;
end;

function TBisMapGeocodeServerThread.GetHttpUrl: String;
var
  UtfParams: Boolean;
  
  function Encode(S: WideString): String;
  begin
    if UtfParams then
      Result:=AnsiToUtf8(S)
    else
      Result:=S;  
  end;

begin
  UtfParams:=FServer.GeocodeUtfParams;
  Result:=FServer.GeocodeUrl;
  Result:=ReplaceText(Result,'%COUNTRY',Encode(FCountry));
  Result:=ReplaceText(Result,'%REGION',Encode(FRegion));
  Result:=ReplaceText(Result,'%LOCALITY',Encode(FLocality));
  Result:=ReplaceText(Result,'%STREET',Encode(FStreet));
  Result:=ReplaceText(Result,'%HOUSE',Encode(FHouse));
end;


procedure TBisMapGeocodeServerThread.DoBegin;
begin
  inherited DoBegin;
  FLatitude:=FParams.Add('������',FServer.LatitudeIdent);
  FLongitude:=FParams.Add('�������',FServer.LongitudeIdent);
end;

procedure TBisMapGeocodeServerThread.DoEnd;
var
  F: Double;
begin
  inherited DoEnd;

  if FLatitude.ValueExists then
    if PrepareDouble(FLatitude.AsString,F) then
      FLatitude.Value:=F;

  if FLongitude.ValueExists then
    if PrepareDouble(FLongitude.AsString,F) then
      FLongitude.Value:=F;
      
end;

type
  TBisMapServerThreads=class(TBisThreads)
  protected
    procedure DoItemRemove(Item: TBisThread); override;
  public
    constructor Create; override;
    function Execute(WaitTimeout: Cardinal): Boolean;
  end;

{ TBisMapServerThreads }

constructor TBisMapServerThreads.Create;
begin
  inherited Create;
  OwnsObjects:=False;
end;

procedure TBisMapServerThreads.DoItemRemove(Item: TBisThread);
begin
  if Item.Working then begin
    Item.FreeOnEnd:=true;
    Item.Terminate;
  end else
    Item.Free;
end;

function TBisMapServerThreads.Execute(WaitTimeout: Cardinal): Boolean;
var
  i: Integer;
  Arr: array[0..MAXIMUM_WAIT_OBJECTS] of THandle;
  Ret: DWord;
begin
  Result:=Count=0;
  if Count>0 then begin
    for i:=0 to Count-1 do begin
      Items[i].Start(false);
      Arr[i]:=Items[i].Handle;
    end;
    Ret:=WaitForMultipleObjects(Count,@Arr,True,WaitTimeout);
    Result:=(Ret=WAIT_OBJECT_0) or (Ret=WAIT_TIMEOUT);
  end;
end;

{ TBisHttpServerHandlerMessageWebModule }

constructor TBisHttpServerHandlerMapWebModule.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FServers:=TBisHttpServerHandlerMapServers.Create;

  FSCoordinates:='������=%d ������1=%g �������1=%g ������2=%g �������2=%g';
  FSDistance:='������� ����������=%d �����=%d';
  FSLocation:='������������ %s, %s, %s, %s, %s';
  FSPosition:='������=%g �������=%g';

end;

destructor TBisHttpServerHandlerMapWebModule.Destroy;
begin
  FServers.Free;
  inherited Destroy;
end;

function TBisHttpServerHandlerMapWebModule.ExecuteRoute(Request: TWebRequest; Response: TWebResponse;
                                                        Modes: TBisHttpServerHandlerMapWebModuleExecuteModes): Boolean;
var
  Lat1, Lon1: Double;
  Lat2, Lon2: Double;
  Traffic: Boolean;

  function ReadParams: Boolean;
  var
    V: Integer;
  begin
    Result:=false;
    if Trim(Request.Query)<>'' then begin
      with Request.QueryFields do begin
        if not PrepareDouble(Values['lat1'],Lat1) then  exit;
        if not PrepareDouble(Values['lon1'],Lon1) then  exit;
        if not PrepareDouble(Values['lat2'],Lat2) then  exit;
        if not PrepareDouble(Values['lon2'],Lon2) then  exit;
        if TryStrToInt(Values['traffic'],V) then
          Traffic:=Boolean(V);
      end;
      Result:=true;
    end;
  end;

  procedure Calculate(var Distance,Duration: Integer);
  var
    i: Integer;
    Server: TBisHttpServerHandlerMapServer;
    List: TBisMapServerThreads;
    Thread: TBisMapRouteServerThread;
    V: Extended;
    Dis: Extended;
    Dur: Integer;
    DisCount: Integer;
    DurCount: Integer;
  begin
    List:=TBisMapServerThreads.Create;
    try

      for i:=0 to FServers.Count-1 do begin
        Server:=FServers[i];
        if Server.Enabled and (Trim(Server.RouteUrl)<>'') then begin
          Thread:=TBisMapRouteServerThread.Create(Self,Server,Lat1,Lon1,Lat2,Lon2,Traffic);
          List.Add(Thread);
        end;
      end;

      if List.Execute(FServersTimeout) then begin
        Dis:=0.0;
        Dur:=0;
        DisCount:=0;
        DurCount:=0;

        List.Lock;
        try
          for i:=0 to List.Count-1 do begin
            Thread:=TBisMapRouteServerThread(List[i]);
            if Thread.FDistance.ValueExists then begin
              V:=Thread.FDistance.AsExtended;
              if V>0.0 then begin
                Dis:=Dis+V;
                Inc(DisCount);
              end;
            end;
            if Thread.FDuration.ValueExists then begin
              V:=Thread.FDuration.AsInteger;
              if V>0.0 then begin
                Dur:=Dur+Thread.FDuration.AsInteger;
                Inc(DurCount);
              end;
            end;
          end;
        finally
          List.UnLock;
        end;

        if DisCount>0 then
          Distance:=Round(Dis/DisCount);
        if DurCount>0 then
          Duration:=Round(Dur/DurCount);
          
      end else
        FHandler.LoggerWrite(SysErrorMessage(GetLastError),ltError);

    finally
      List.Free;
    end;
  end;

  procedure WriteParams(Distance,Duration: Int64);
  var
    S: String;
    Config: TBisConfig;
  begin
    S:='';
    try
      if Modes=[emDistance,emDuration] then begin
        Config:=TBisConfig.Create(nil);
        try
          Config.Write(SSectionResult,SParamDistance,Distance);
          Config.Write(SSectionResult,SParamDuration,Duration);
          S:=Trim(Config.Text);
        finally
          Config.Free;
        end; 
      end else begin
        if emDistance in Modes then
          S:=IntToStr(Distance);
        if emDuration in Modes then
          S:=IntToStr(Duration);
      end;
    finally
      Response.Content:=S;
    end;
  end;

var
  RequestStream: TMemoryStream;
  Flag: Boolean;
  Distance: Integer;
  Duration: Integer;
begin
  Result:=false;
  if Assigned(FHandler) then begin
    try
      RequestStream:=TMemoryStream.Create;
      try
        RequestStream.WriteBuffer(Pointer(Request.Content)^,Length(Request.Content));
        RequestStream.Position:=0;

        Lat1:=0.0;
        Lon1:=0.0;
        Lat2:=0.0;
        Lon2:=0.0;
        Traffic:=false;

        Flag:=ReadParams;

        FHandler.LoggerWrite(FormatEx(FSCoordinates,[Integer(Traffic),Lat1,Lon1,Lat2,Lon2]));

        if Flag then begin

          Distance:=0;
          Duration:=0;
          
          Calculate(Distance,Duration);

          FHandler.LoggerWrite(FormatEx(FSDistance,[Distance,Duration]));

          if Assigned(Response.ContentStream) then begin
            WriteParams(Distance,Duration);
            Result:=true;
          end;
        end;

      finally
        RequestStream.Free;
      end;
    except
      On E: Exception do
        FHandler.LoggerWrite(E.Message,ltError);
    end;
  end;
end;

function TBisHttpServerHandlerMapWebModule.ExecuteGeocode(Request: TWebRequest; Response: TWebResponse): Boolean;
var
  Country,Region,Locality,Street,House: WideString;

  function ReadParams: Boolean;
  begin
    with Request.QueryFields do begin
      Country:=Trim(Utf8DecodeEx(Values['country']));
      Region:=Trim(Utf8DecodeEx(Values['region']));
      Locality:=Trim(Utf8DecodeEx(Values['locality']));
      Street:=Trim(Utf8DecodeEx(Values['street']));
      House:=Trim(Utf8DecodeEx(Values['house']));
    end;
    Result:=(Street<>'') and (House<>'');
  end;

  procedure Calculate(var Latitude,Longitude: Double);
  var
    i: Integer;
    Server: TBisHttpServerHandlerMapServer;
    List: TBisMapServerThreads;
    Thread: TBisMapGeocodeServerThread;
    V: Double;
    Lat,Lon: Double;
    LatCount: Integer;
    LonCount: Integer;
  begin
    List:=TBisMapServerThreads.Create;
    try

      for i:=0 to FServers.Count-1 do begin
        Server:=FServers[i];
        if Server.Enabled and (Trim(Server.GeocodeUrl)<>'') then begin
          Thread:=TBisMapGeocodeServerThread.Create(Self,Server,Country,Region,Locality,Street,House);
          List.Add(Thread);
        end;
      end;

      if List.Execute(FServersTimeout) then begin

        Lat:=0.0;
        Lon:=0.0;
        LatCount:=0;
        LonCount:=0;

        List.Lock;
        try
          for i:=0 to List.Count-1 do begin
            Thread:=TBisMapGeocodeServerThread(List[i]);
            if Thread.FLatitude.ValueExists then begin
              V:=Thread.FLatitude.AsExtended;
              if V>0.0 then begin
                Lat:=Lat+V;
                Inc(LatCount);
              end;
            end;
            if Thread.FLongitude.ValueExists then begin
              V:=Thread.FLongitude.AsExtended;
              if V>0.0 then begin
                Lon:=Lon+V;
                Inc(LonCount);
              end;
            end;
          end;
        finally
          List.UnLock;
        end;

        if LatCount>0 then
          Latitude:=Lat/LatCount;
        if LonCount>0 then
          Longitude:=Lon/LonCount;

      end else
        FHandler.LoggerWrite(SysErrorMessage(GetLastError),ltError);
 
    finally
      List.Free;
    end;
  end;

  procedure WriteParams(Latitude,Longitude: Double);
  var
    S: String;
    Config: TBisConfig;
  begin
    S:='';
    try
      Config:=TBisConfig.Create(nil);
      try
        Config.Write(SSectionResult,SParamLatitude,DoubleAsString(Latitude));
        Config.Write(SSectionResult,SParamLongitude,DoubleAsString(Longitude));
        S:=Trim(Config.Text);
      finally
        Config.Free;
      end;
    finally
      Response.Content:=S;
    end;
  end;
  
var
  RequestStream: TMemoryStream;
  Flag: Boolean;
  Latitude,Longitude: Double;
begin
  Result:=false;
  if Assigned(FHandler) then begin
    try
      RequestStream:=TMemoryStream.Create;
      try
        RequestStream.WriteBuffer(Pointer(Request.Content)^,Length(Request.Content));
        RequestStream.Position:=0;

        Flag:=ReadParams;

        FHandler.LoggerWrite(FormatEx(FSLocation,[Country,Region,Locality,Street,House]));

        if Flag then begin

          Latitude:=0.0;
          Longitude:=0.0;

          Calculate(Latitude,Longitude);

          FHandler.LoggerWrite(FormatEx(FSPosition,[Latitude,Longitude]));

          if Assigned(Response.ContentStream) then begin
            WriteParams(Latitude,Longitude);
            Result:=true;
          end;
        end;

      finally
        RequestStream.Free;
      end;
    except
      On E: Exception do
        FHandler.LoggerWrite(E.Message,ltError);
    end;
  end;
end;

procedure TBisHttpServerHandlerMapWebModule.BisHttpServerHandlerMapWebModuleDefaultAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Handled:=false;
end;

procedure TBisHttpServerHandlerMapWebModule.BisHttpServerHandlerMapWebModuleDistanceAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Handled:=ExecuteRoute(Request,Response,[emDistance]);
end;

procedure TBisHttpServerHandlerMapWebModule.BisHttpServerHandlerMapWebModuleDurationAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Handled:=ExecuteRoute(Request,Response,[emDuration]);
end;

procedure TBisHttpServerHandlerMapWebModule.BisHttpServerHandlerMapWebModuleGeocodeAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Handled:=ExecuteGeocode(Request,Response);
end;

procedure TBisHttpServerHandlerMapWebModule.BisHttpServerHandlerMapWebModuleRouteAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Handled:=ExecuteRoute(Request,Response,[emDistance,emDuration]);
end;

end.