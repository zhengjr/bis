unit BisHttpConnection;

interface


uses Windows, Classes, Controls, DB, SyncObjs,
     WinInet, ZLib,
     Ras, RasUtils, RasHelperClasses,
     IdHttp, IdComponent, IdGlobal, IdAuthentication,
     BisConnectionModules, BisConnections, BisExceptions, BisCrypter,
     BisDataSet, BisConfig, BisProfile, BisInterfaces, BisMenus, BisTasks,
     BisAlarmsFm;

type
  TBisHttpConnection=class;

  TBisHttpConnectionType=(ctDirect,ctRemote,ctModem);

  TBisHttpConnectionInternetType=(citUnknown,citModem,citLan,citProxy);

  TBisHttpConnectionReturnType=(rtError,rtSuccess,rtRelay);

  TBisHttpConnectionFormat=(cfRaw,cfXml);

  TBisHttpConnectionMethod=(cmConnect,cmDisconnect,cmImport,cmExport,cmGetServerDate,
                            cmLogin,cmLogout,cmCheck,cmUpdate,
                            cmLoadProfile,cmSaveProfile,cmRefreshPermissions,cmLoadInterfaces,
                            cmGetRecords,cmExecute,cmLoadMenus,cmLoadTasks,cmSaveTask,cmLoadAlarms,
                            cmLoadScript,cmLoadReport,cmLoadDocument,cmCancel);

  TBisIdHttpParams=class(TObject)
  private
    FCaption: String;
    FHost: String;
    FHostIP: String;
    FPort: Integer;
    FPath: String;
    FProtocol: String;
    FUseProxy: Boolean;
    FProxyServer: String;
    FProxyPort: Integer;
    FProxyUsername: String;
    FProxyPassword: String;
    FUseCrypter: Boolean;
    FCrypterAlgorithm: TBisCipherAlgorithm;
    FCrypterMode: TBisCipherMode;
    FCrypterKey: String;
    FUseCompressor: Boolean;
    FCompressorLevel: TCompressionLevel;
    FAuthUserName: String;
    FAuthPassword: String;
  public
    procedure CopyTo(Connection: TBisHttpConnection);
    procedure CopyFrom(Connection: TBisHttpConnection);
  end;

  TBisIdHttp=class(TIdHttp)
  private

    FParent: TBisHttpConnection;

    function GetCacheFileName(Method: TBisHttpConnectionMethod; DataSet: TBisDataSet): String; overload;
    function GetCacheFileName(Method: TBisHttpConnectionMethod; Expression: String): String; overload;
    function GetCacheFileCheckSum(FileName: String): String;
    procedure SaveStreamToCacheFile(Stream: TStream; FileName: String);
    procedure LoadDataSetFromStream(DataSet: TBisDataSet; Stream: TStream);
    procedure LoadDataSetFromCacheFile(DataSet: TBisDataSet; FileName: String);
    procedure LoadStreamFromCacheFile(Stream: TStream; FileName: String);

    function GetFullUrl(const Document: String=''): String;
    function GetKey: String;
    function ExecuteMethod(Method: TBisHttpConnectionMethod; Params: TBisDataSet=nil): TBisHttpConnectionReturnType;
    function CreateParams: TBisDataSet;
  protected
    procedure DoOnConnected; override;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Connect; reintroduce;
    procedure Disconnect; reintroduce;
    procedure Import(ImportType: TBisConnectionImportType; Stream: TStream);
    procedure Export(ExportType: TBisConnectionExportType; const Value: String;
                     Stream: TStream; Params: TBisConnectionExportParams=nil);
    function GetServerDate: TDateTime;

    function Login(const ApplicationId: Variant; const UserName,Password: String; Params: TBisConnectionLoginParams=nil): Variant;
    procedure Logout(const SessionId: Variant);
    function Check(const SessionId: Variant; var ServerDate: TDateTime): Boolean;
    procedure Update(const SessionId: Variant; Params: TBisConfig);
    procedure LoadProfile(const SessionId: Variant; Profile: TBisProfile);
    procedure SaveProfile(const SessionId: Variant; Profile: TBisProfile);
    procedure RefreshPermissions(const SessionId: Variant);
    procedure LoadInterfaces(const SessionId: Variant; Interfaces: TBisInterfaces);
    procedure GetRecords(const SessionId: Variant; DataSet: TBisDataSet);
    procedure Execute(const SessionId: Variant; DataSet: TBisDataSet);
    procedure LoadMenus(const SessionId: Variant; Menus: TBisMenus);
    procedure LoadTasks(const SessionId: Variant; Tasks: TBisTasks);
    procedure SaveTask(const SessionId: Variant; Task: TBisTask);
    procedure LoadAlarms(const SessionId: Variant; Alarms: TBisAlarms);
    procedure LoadScript(const SessionId: Variant; ScriptId: Variant; Stream: TStream);
    procedure LoadReport(const SessionId: Variant; ReportId: Variant; Stream: TStream);
    procedure LoadDocument(const SessionId: Variant; DocumentId: Variant; Stream: TStream);
    procedure Cancel(const SessionId: Variant; DataSetCheckSum: String=''); 

  end;

  TBisDialer=class(TRasDialer)
  end;

  TBisHttpConnection=class(TBisConnection)
  private
    FOriginal: TBisIdHttpParams;
    FConnected: Boolean;
    FConnectionType: TBisHttpConnectionType;
    FRemoteAuto: Boolean;
    FRemoteName: String;
    FInternet: DWord;
    FDialer: TBisDialer;
    FHost: String;
    FHostIP: String;
    FPort: Integer;
    FPath: String;
    FProtocol: String;
    FUseProxy: Boolean;
    FProxyServer: String;
    FProxyPort: Integer;
    FProxyUsername: String;
    FProxyPassword: String;
    FUseCrypter: Boolean;
    FCrypterAlgorithm: TBisCipherAlgorithm;
    FCrypterMode: TBisCipherMode;
    FCrypterKey: String;
    FUseCompressor: Boolean;
    FCompressorLevel: TCompressionLevel;
    FAuthUserName: String;
    FAuthPassword: String;
    FUseCache: Boolean;
    FCacheDirectory: String;
    FCacheProviders: TStringList;
    FConnectTimeout: Integer;
    FUserAgent: String;
    FRecvBufferSize: Integer;
    FSendBufferSize: Integer;
    FRandomStringSize: Integer;

    FSNameAuto: String;
    FSCacheFileNotFound: String;
    FSErrorNotFound: String;
    FSConnectionCaption: String;
    FSServerDoesNotExists: String;

    function CreateConnection: TBisIdHttp;
    procedure ChangeParams(Sender: TObject);
    function GetInternetType: TBisHttpConnectionInternetType;
    procedure DialerNotify(Sender: TObject; State: TRasConnState; ErrorCode: DWORD);

    procedure ConnectDirect(Connection: TBisIdHttp);
    procedure ConnectRemote(Connection: TBisIdHttp);
    procedure ConnectModem(Connection: TBisIdHttp);

    procedure DisconnectDirect(Connection: TBisIdHttp);
    procedure DisconnectRemote(Connection: TBisIdHttp);
    procedure DisconnectModem(Connection: TBisIdHttp);
  protected
    function GetConnected: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;

    procedure Connect; override;
    procedure Disconnect; override;
    procedure Import(ImportType: TBisConnectionImportType; Stream: TStream); override;
    procedure Export(ExportType: TBisConnectionExportType; const Value: String;
                     Stream: TStream; Params: TBisConnectionExportParams=nil); override;
    function GetServerDate: TDateTime; override;

    function Login(const ApplicationId: Variant; const UserName,Password: String; Params: TBisConnectionLoginParams=nil): Variant; override;
    procedure Logout(const SessionId: Variant); override;
    function Check(const SessionId: Variant; var ServerDate: TDateTime): Boolean; override;
    procedure Update(const SessionId: Variant; Params: TBisConfig=nil); override;
    procedure LoadProfile(const SessionId: Variant; Profile: TBisProfile); override;
    procedure SaveProfile(const SessionId: Variant; Profile: TBisProfile); override;
    procedure RefreshPermissions(const SessionId: Variant); override;
    procedure LoadInterfaces(const SessionId: Variant; Interfaces: TBisInterfaces); override;
    procedure GetRecords(const SessionId: Variant; DataSet: TBisDataSet); override;
    procedure Execute(const SessionId: Variant; DataSet: TBisDataSet); override;
    procedure LoadMenus(const SessionId: Variant; Menus: TBisMenus); override;
    procedure LoadTasks(const SessionId: Variant; Tasks: TBisTasks); override;
    procedure SaveTask(const SessionId: Variant; Task: TBisTask); override;
    procedure LoadAlarms(const SessionId: Variant; Alarms: TBisAlarms); override;
    procedure LoadScript(const SessionId: Variant; ScriptId: Variant; Stream: TStream); override;
    procedure LoadReport(const SessionId: Variant; ReportId: Variant; Stream: TStream); override;
    procedure LoadDocument(const SessionId: Variant; DocumentId: Variant; Stream: TStream); override;
    procedure Cancel(const SessionId: Variant; DataSetCheckSum: String=''); override;

  published
    property SNameAuto: String read FSNameAuto write FSNameAuto;
    property SCacheFileNotFound: String read FSCacheFileNotFound write FSCacheFileNotFound;
    property SErrorNotFound: String read FSErrorNotFound write FSErrorNotFound;
    property SConnectionCaption: String read FSConnectionCaption write FSConnectionCaption;
    property SServerDoesNotExists: String read FSServerDoesNotExists write FSServerDoesNotExists;
  end;


procedure InitConnectionModule(AModule: TBisConnectionModule); stdcall;

exports
  InitConnectionModule;

implementation

uses SysUtils, Forms, Variants, TypInfo,
     IdAssignedNumbers, IdIOHandler,
     BisConsts, BisHttpConnectionConsts, BisUtils, BisCore, BisParams, BisParam,
     BisFieldNames, BisFilterGroups, BisOrders, BisCryptUtils, BisLogger,
     BisNetUtils, BisCompressUtils, BisDataParams;


procedure InitConnectionModule(AModule: TBisConnectionModule); stdcall;
begin
  AModule.ConnectionClass:=TBisHttpConnection;
end;

{ TBisIdHttpParams }

procedure TBisIdHttpParams.CopyFrom(Connection: TBisHttpConnection);
begin
  if Assigned(Connection) then begin
    FCaption:=Connection.Caption;
    FHost:=Connection.FHost;
    FHostIP:=Connection.FHostIP;
    FPort:=Connection.FPort;
    FPath:=Connection.FPath;
    FProtocol:=Connection.FProtocol;
    FUseProxy:=Connection.FUseProxy;
    FProxyServer:=Connection.FProxyServer;
    FProxyPort:=Connection.FProxyPort;
    FProxyUsername:=Connection.FProxyUsername;
    FProxyPassword:=Connection.FProxyPassword;
    FUseCrypter:=Connection.FUseCrypter;
    FCrypterAlgorithm:=Connection.FCrypterAlgorithm;
    FCrypterMode:=Connection.FCrypterMode;
    FCrypterKey:=Connection.FCrypterKey;
    FUseCompressor:=Connection.FUseCompressor;
    FCompressorLevel:=Connection.FCompressorLevel;
    FAuthUserName:=Connection.FAuthUserName;
    FAuthPassword:=Connection.FAuthPassword;
  end;
end;

procedure TBisIdHttpParams.CopyTo(Connection: TBisHttpConnection);
begin
  if Assigned(Connection) then begin
    Connection.Caption:=FCaption;
    Connection.FHost:=FHost;
    Connection.FHostIP:=FHostIP;
    Connection.FPort:=FPort;
    Connection.FPath:=FPath;
    Connection.FProtocol:=FProtocol;
    Connection.FUseProxy:=FUseProxy;
    Connection.FProxyServer:=FProxyServer;
    Connection.FProxyPort:=FProxyPort;
    Connection.FProxyUsername:=FProxyUsername;
    Connection.FProxyPassword:=FProxyPassword;
    Connection.FUseCrypter:=FUseCrypter;
    Connection.FCrypterAlgorithm:=FCrypterAlgorithm;
    Connection.FCrypterMode:=FCrypterMode;
    Connection.FCrypterKey:=FCrypterKey;
    Connection.FUseCompressor:=FUseCompressor;
    Connection.FCompressorLevel:=FCompressorLevel;
    Connection.FAuthUserName:=FAuthUserName;
    Connection.FAuthPassword:=FAuthPassword;
  end;
end;

{ TBisIdHttp }

constructor TBisIdHttp.Create(AOwner: TComponent);
begin
  inherited Create(Aowner);
end;

destructor TBisIdHttp.Destroy;
begin
  inherited Destroy;
end;

procedure TBisIdHttp.DoOnConnected;
begin
  inherited DoOnConnected;
  if Assigned(IOHandler) and Assigned(FParent) then begin
    IOHandler.RecvBufferSize:=FParent.FRecvBufferSize;
    IOHandler.SendBufferSize:=FParent.FSendBufferSize;
  end;
end;

function TBisIdHttp.CreateParams: TBisDataSet;
begin
  Result:=TBisDataSet.Create(nil);
  with Result do begin
    FieldDefs.Add(SFieldName,ftString,100);
    FieldDefs.Add(SFieldValue,ftBlob);
  end;
  Result.CreateTable();
  Result.Open;
end;

function TBisIdHttp.GetCacheFileName(Method: TBisHttpConnectionMethod; DataSet: TBisDataSet): String;

  function GetDataSetCheckSum: String;
  var
    Crypter: TBisCrypter;
    S,S1,S2,S3,S4,S5,S6,S7: String;
    i,j: Integer;
    FieldName: TBisFieldName;
    Param: TBisParam;
    FilterGroup: TBisFilterGroup;
    Filter: TBisFilter;
    Order: TBisOrder;
    Flag: Boolean;
  begin
    Crypter:=TBisCrypter.Create;
    try
      S:=GetEnumName(TypeInfo(TBisHttpConnectionMethod),Integer(Method))+' '+DataSet.ProviderName;

      for i:=0 to DataSet.FieldNames.Count-1 do begin
        FieldName:=DataSet.FieldNames.Items[i];
        if i=0 then
          S:=S+' FieldNames:'+FieldName.FieldName
        else
          S:=S+','+FieldName.FieldName;
      end;

      for i:=0 to DataSet.Params.Count-1 do begin
        Param:=DataSet.Params.Items[i];
        S1:=GetEnumName(TypeInfo(TParamType),Integer(Param.ParamType));
        S2:=VarToStrDef(Param.Value,'');
        S2:=Format('%s=%s (%s)',[Param.ParamName,S2,S1]);
        if i=0 then
          S:=S+' Params:'+S2
        else
          S:=S+','+S2;
      end;

      Flag:=true;
      for i:=0 to DataSet.FilterGroups.Count-1 do begin
        FilterGroup:=DataSet.FilterGroups.Items[i];
        if FilterGroup.Enabled then begin
          S1:=GetEnumName(TypeInfo(TBisFilterOperator),Integer(FilterGroup.&Operator));
          if Flag then begin
            S:=S+' FilterGroups:'+FilterGroup.GroupName;
            Flag:=false;
          end else
            S:=S+','+S1+FilterGroup.GroupName;
          for j:=0 to FilterGroup.Filters.Count-1 do begin
            Filter:=FilterGroup.Filters.Items[j];
            S1:=GetEnumName(TypeInfo(TBisFilterCondition),Integer(Filter.Condition));
            S2:=VarToStrDef(Filter.Value,'');
            S3:=GetEnumName(TypeInfo(TBisFilterOperator),Integer(Filter.&Operator));
            S4:=GetEnumName(TypeInfo(TBisFilterType),Integer(Filter.FilterType));
            S5:=GetEnumName(TypeInfo(Boolean),Integer(Filter.CheckCase));
            S6:=GetEnumName(TypeInfo(Boolean),Integer(Filter.RightSide));
            S7:=GetEnumName(TypeInfo(Boolean),Integer(Filter.LeftSide));
            S7:=Format('%s%s%s (%s,%s,%s,%s,%s)',[Filter.FieldName,S1,S2,S3,S4,S5,S6,S7]);
            if j=0 then
              S:=S+' Filters:'+S7
            else
              S:=S+','+S7;
          end;
        end;
      end;

      for i:=0 to DataSet.Orders.Count-1 do begin
        Order:=DataSet.Orders.Items[i];
        S1:=GetEnumName(TypeInfo(TBisOrderType),Integer(Order.OrderType));
        S2:=Format('%s=%s',[Order.FieldName,S1]);
        if i=0 then
          S:=S+' Orders:'+S2
        else
          S:=S+','+S2;
      end;

      Result:=Crypter.HashString(S,haMD5,hfHEX);
    finally
      Crypter.Free;
    end;
  end;

var
  Path: String;
begin
  Result:='';
  if Assigned(Core) and Assigned(Core.CmdLine) then begin
    Path:=Trim(FParent.FCacheDirectory);
    if Path='' then
      Path:=ExtractFilePath(Core.CmdLine.FileName)
    else Path:=IncludeTrailingPathDelimiter(Path);
    Result:=Path+GetDataSetCheckSum;
    Result:=ExpandFileNameEx(Result);
  end;
end;

function TBisIdHttp.GetCacheFileName(Method: TBisHttpConnectionMethod; Expression: String): String;

  function GetStreamCheckSum: String;
  var
    Crypter: TBisCrypter;
    S: String;
  begin
    Crypter:=TBisCrypter.Create;
    try
      S:=GetEnumName(TypeInfo(TBisHttpConnectionMethod),Integer(Method))+' '+Expression;
      Result:=Crypter.HashString(S,haMD5,hfHEX);
    finally
      Crypter.Free;
    end;
  end;

var
  Path: String;
begin
  Result:='';
  if Assigned(Core) and Assigned(Core.CmdLine) then begin
    Path:=Trim(FParent.FCacheDirectory);
    if Path='' then
      Path:=ExtractFilePath(Core.CmdLine.FileName)
    else Path:=IncludeTrailingPathDelimiter(Path);
    Result:=Path+GetStreamCheckSum;
    Result:=ExpandFileNameEx(Result);
  end;
end;

function TBisIdHttp.GetCacheFileCheckSum(FileName: String): String;
var
  Crypter: TBisCrypter;
  Source: TFileStream;
  Dest: TMemoryStream;
begin
  Result:='';
  if FileExists(FileName) then begin
    try
      Source:=TFileStream.Create(FileName,fmOpenRead);
      Crypter:=TBisCrypter.Create;
      Dest:=TMemoryStream.Create;
      try
        Crypter.DefaultKey:=DefaultKey;
        Crypter.DefaultCipherAlgorithm:=DefaultCipherAlgorithm;
        Crypter.DefaultCipherMode:=DefaultCipherMode;
        Crypter.DecodeStream(Source,Dest);
        Dest.Position:=0;
        Result:=Crypter.HashStream(Dest,haMD5,hfHEX);
      finally
        Dest.Free;
        Crypter.Free;
        Source.Free;
      end;
    except
      On E: Exception do
        FParent.LoggerWrite(E.Message,ltError);
    end;
  end;
end;

procedure TBisIdHttp.SaveStreamToCacheFile(Stream: TStream; FileName: String);
var
  Crypter: TBisCrypter;
  Dest: TFileStream;
begin
  try
    if FileExists(FileName) then
      DeleteFile(FileName);
    Dest:=TFileStream.Create(FileName,fmCreate);
    Crypter:=TBisCrypter.Create;
    try
      Crypter.DefaultKey:=DefaultKey;
      Crypter.DefaultCipherAlgorithm:=DefaultCipherAlgorithm;
      Crypter.DefaultCipherMode:=DefaultCipherMode;
      Crypter.EncodeStream(Stream,Dest);
    finally
      Crypter.Free;
      Dest.Free;
    end;
  except
    On E: Exception do
      FParent.LoggerWrite(E.Message,ltError);
  end;
end;

procedure TBisIdHttp.LoadDataSetFromStream(DataSet: TBisDataSet; Stream: TStream);
begin
  DataSet.BeginUpdate;
  try
    DataSet.Close;
    DataSet.LoadFromStream(Stream);
    DataSet.First;
  finally
    DataSet.EndUpdate;
  end;
end;

procedure TBisIdHttp.LoadDataSetFromCacheFile(DataSet: TBisDataSet; FileName: String);
var
  Crypter: TBisCrypter;
  Source: TFileStream;
  Dest: TMemoryStream;
begin
  if FileExists(FileName) then begin
    try
      Source:=TFileStream.Create(FileName,fmOpenRead);
      Crypter:=TBisCrypter.Create;
      Dest:=TMemoryStream.Create;
      try
        Crypter.DefaultKey:=DefaultKey;
        Crypter.DefaultCipherAlgorithm:=DefaultCipherAlgorithm;
        Crypter.DefaultCipherMode:=DefaultCipherMode;
        Crypter.DecodeStream(Source,Dest);
        Dest.Position:=0;
        LoadDataSetFromStream(DataSet,Dest);
      finally
        Dest.Free;
        Crypter.Free;
        Source.Free;
      end;
    except
      On E: Exception do
        FParent.LoggerWrite(E.Message,ltError);
    end;
  end else
    raise Exception.Create(FormatEx(FParent.SCacheFileNotFound,[FileName]));
end;

procedure TBisIdHttp.LoadStreamFromCacheFile(Stream: TStream; FileName: String);
var
  Crypter: TBisCrypter;
  Source: TFileStream;
  Dest: TMemoryStream;
begin
  if FileExists(FileName) then begin
    try
      Source:=TFileStream.Create(FileName,fmOpenRead);
      Crypter:=TBisCrypter.Create;
      Dest:=TMemoryStream.Create;
      try
        Crypter.DefaultKey:=DefaultKey;
        Crypter.DefaultCipherAlgorithm:=DefaultCipherAlgorithm;
        Crypter.DefaultCipherMode:=DefaultCipherMode;
        Crypter.DecodeStream(Source,Dest);
        Dest.Position:=0;
        Stream.CopyFrom(Dest,Dest.Size)
      finally
        Dest.Free;
        Crypter.Free;
        Source.Free;
      end;
    except
      On E: Exception do
        FParent.LoggerWrite(E.Message,ltError);
    end;
  end else
    raise Exception.Create(FormatEx(FParent.SCacheFileNotFound,[FileName]));
end;

function TBisIdHttp.GetFullUrl(const Document: String=''): String;
begin
  Result:='';
  try
    URL.Host:=FParent.FHost;
    URL.Port:=IntToStr(FParent.FPort);
    URL.Protocol:=FParent.FProtocol;
    URL.Path:=FParent.FPath;
    URL.Document:=Document;
    Result:=URL.GetFullURI([]);
  except
  end;
end;

function TBisIdHttp.GetKey: String;
begin
  Result:=FParent.FCrypterKey;
end;

function TBisIdHttp.ExecuteMethod(Method: TBisHttpConnectionMethod; Params: TBisDataSet): TBisHttpConnectionReturnType;

  function BuildRandomString: String;
  begin
    Result:=RandomString(FParent.FRandomStringSize);
  end;

var
  Writer: TWriter;
  Reader: TReader;
  ParamsStream: TMemoryStream;
  RequestStream: TMemoryStream;
  ResponseStream: TMemoryStream;
  TempStream: TMemoryStream;
  FullUrl: String;
  Key: String;
  Error: String;
  ASize: Int64;
  Crypter: TBisCrypter;
  RetType: TBisHttpConnectionReturnType;
  Format: TBisHttpConnectionFormat;
begin
  RetType:=rtError;
  if ServerExists(FParent.FHostIP,FParent.FPort,FParent.FConnectTimeout) then begin
    ParamsStream:=TMemoryStream.Create;
    RequestStream:=TMemoryStream.Create;
    ResponseStream:=TMemoryStream.Create;
    TempStream:=TMemoryStream.Create;
    Crypter:=TBisCrypter.Create;
    try
      FullUrl:=GetFullUrl();
      Key:=GetKey;

      Request.UserAgent:=FParent.FUserAgent;

      ProxyParams.ProxyServer:=FParent.FProxyServer;
      ProxyParams.ProxyPort:=FParent.FProxyPort;
      ProxyParams.ProxyUsername:=FParent.FProxyUsername;
      ProxyParams.ProxyPassword:=FParent.FProxyPassword;

      if not FParent.FUseProxy then
        ProxyParams.Clear;

      if Trim(FParent.FAuthUserName)<>'' then begin
        Self.Request.BasicAuthentication:=true;
        if not Assigned(Self.Request.Authentication) then
          Self.Request.Authentication:=TIdBasicAuthentication.Create;
        Self.Request.Authentication.Username:=FParent.FAuthUserName;
        Self.Request.Authentication.Password:=FParent.FAuthPassword;
      end;

      Format:=cfRaw;

      if Assigned(Params) and Params.Active then begin
        case Format of
          cfRaw: Params.SaveToStream(ParamsStream);
          cfXml: ;
        end;
        ParamsStream.Position:=0;
      end;

      Writer:=TWriter.Create(TempStream,WriterBufferSize);
      try
        Writer.WriteInteger(Integer(Format));
        Writer.WriteInteger(Integer(Method));
        Writer.WriteString(BuildRandomString);
        Writer.WriteInteger(ParamsStream.Size);
      finally
        Writer.Free;
      end;

      if ParamsStream.Size>0 then begin
        TempStream.CopyFrom(ParamsStream,ParamsStream.Size);
      end;

      if FParent.FUseCompressor then
        CompressStream(TempStream,FParent.FCompressorLevel);

      RequestStream.Clear;
      TempStream.Position:=0;
      if FParent.FUseCrypter then
        Crypter.EncodeStream(Key,TempStream,RequestStream,FParent.FCrypterAlgorithm,FParent.FCrypterMode)
      else
        RequestStream.CopyFrom(TempStream,TempStream.Size);

      RequestStream.Position:=0;

      Post(FullUrl,RequestStream,ResponseStream);

      ResponseStream.Position:=0;
      TempStream.Clear;
      if FParent.FUseCrypter then
        Crypter.DecodeStream(Key,ResponseStream,TempStream,FParent.FCrypterAlgorithm,FParent.FCrypterMode)
      else
        TempStream.CopyFrom(ResponseStream,ResponseStream.Size);

      if FParent.FUseCompressor then
        DecompressStream(TempStream);

      RetType:=rtSuccess;
      TempStream.Position:=0;

      if TempStream.Size>0 then begin

        Reader:=TReader.Create(TempStream,ReaderBufferSize);
        try
          RetType:=TBisHttpConnectionReturnType(Reader.ReadInteger);
          Error:=Reader.ReadString;
          // read random string
          Reader.ReadString;
          ASize:=Reader.ReadInt64;
        finally
          Reader.Free;
        end;

        if ASize>0 then begin
          ParamsStream.Clear;
          ParamsStream.CopyFrom(TempStream,ASize);
          ParamsStream.Position:=0;
        end;

        if Assigned(Params) and (ParamsStream.Size>0) then begin
          case Format of
            cfRaw: Params.LoadFromStream(ParamsStream);
            cfXml: ;
          end;
          Params.Open;
        end;
      end;
    finally
      Crypter.Free;
      TempStream.Free;
      ResponseStream.Free;
      RequestStream.Free;
      ParamsStream.Free;
    end;
  end else
    Error:=FParent.SServerDoesNotExists;

  Result:=RetType;
  if Result=rtError then begin
    Error:=iff(Trim(Error)<>'',Error,FParent.SErrorNotFound);
    raise Exception.Create(Error);
  end;
end;

procedure TBisIdHttp.Connect;
var
  DS: TBisDataSet;
  RetType: TBisHttpConnectionReturnType;
  Stream: TMemoryStream;
  NewConnect: Boolean;
  NewCaption: String;
  Params: TBisDataValueParams;
begin
  DS:=CreateParams;
  try
    if FParent.FHost<>'' then
      FParent.FHostIP:=ResolveIP(FParent.FHost);

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SConnection;
    DS.FieldByName(SFieldValue).Value:=Null;
    DS.Post;


    RetType:=ExecuteMethod(cmConnect,DS);                                             
    if RetType=rtRelay then begin
      NewConnect:=false;
      if DS.Active and not DS.IsEmpty then begin
        if DS.Locate(SFieldName,SConnection,[]) then begin
          Params:=TBisDataValueParams.Create;
          Stream:=TMemoryStream.Create;
          try
            TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
            Stream.Position:=0;
            Params.LoadFromStream(Stream);

            FParent.FHost:=Params.AsString(SParamHost);
            if FParent.FHost<>'' then
              FParent.FHostIP:=ResolveIP(FParent.FHost);

            FParent.FPort:=Params.AsInteger(SParamPort,IdPORT_HTTP);
            FParent.FPath:=Params.AsString(SParamPath);
            FParent.FProtocol:=Params.AsString(SParamProtocol);
            FParent.FUseProxy:=Params.AsBoolean(SParamUseProxy);
            FParent.FProxyServer:=Params.AsString(SParamProxyHost);
            FParent.FProxyPort:=Params.AsInteger(SParamProxyPort);
            FParent.FProxyUsername:=Params.AsString(SParamProxyUserName);
            FParent.FProxyPassword:=Params.AsString(SParamProxyPassword);
            FParent.FUseCrypter:=Params.AsBoolean(SParamUseCrypter);
            FParent.FCrypterAlgorithm:=Params.AsEnumeration(SParamCrypterAlgorithm,TypeInfo(TBisCipherAlgorithm),ca3Way);
            FParent.FCrypterMode:=Params.AsEnumeration(SParamCrypterMode,TypeInfo(TBisCipherMode),cmCTS);
            FParent.FCrypterKey:=Params.AsString(SParamCrypterKey);
            FParent.FUseCompressor:=Params.AsBoolean(SParamUseCompressor);
            FParent.FCompressorLevel:=Params.AsEnumeration(SParamCompressorLevel,TypeInfo(TCompressionLevel),clNone);
            FParent.FAuthUserName:=Params.AsString(SParamAuthUserName);
            FParent.FAuthPassword:=Params.AsString(SParamAuthPassword);

            NewCaption:=Params.AsString(SParamCaption);

            if Trim(NewCaption)<>'' then
              FParent.Caption:=NewCaption;

          finally
            Stream.Free;
            Params.Free;
          end;
        end;
      end;
      if NewConnect then
        ExecuteMethod(cmConnect);
    end;
  finally
    DS.Free;
  end;
end;

procedure TBisIdHttp.Disconnect;
begin
  ExecuteMethod(cmDisconnect);
end;

procedure TBisIdHttp.Import(ImportType: TBisConnectionImportType; Stream: TStream);
var
  DS: TBisDataSet;
begin
  if Assigned(Stream) then begin
    DS:=CreateParams;
    try
      DS.Append;
      DS.FieldByName(SFieldName).Value:=SImportType;
      DS.FieldByName(SFieldValue).Value:=ImportType;
      DS.Post;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SStream;
      TBlobField(DS.FieldByName(SFieldValue)).LoadFromStream(Stream);
      DS.Post;

      ExecuteMethod(cmImport,DS);
    finally
      DS.Free;
    end;
  end;
end;

procedure TBisIdHttp.Export(ExportType: TBisConnectionExportType; const Value: String;
                            Stream: TStream; Params: TBisConnectionExportParams=nil);
var
  DS: TBisDataSet;
  ExportParams: TMemoryStream;
begin
  if Assigned(Stream) then begin
    DS:=CreateParams;
    try
      DS.Append;
      DS.FieldByName(SFieldName).Value:=SExportType;
      DS.FieldByName(SFieldValue).Value:=ExportType;
      DS.Post;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SValue;
      DS.FieldByName(SFieldValue).Value:=Value;
      DS.Post;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SStream;
      DS.FieldByName(SFieldValue).Value:=Null;
      DS.Post;

      if Assigned(Params) then begin
        ExportParams:=TMemoryStream.Create;
        try
          Params.SaveToStream(ExportParams);
          ExportParams.Position:=0;
          DS.Append;
          DS.FieldByName(SFieldName).Value:=SParams;
          TBlobField(DS.FieldByName(SFieldValue)).LoadFromStream(ExportParams);
          DS.Post;
        finally
          ExportParams.Free;
        end;
      end;

      if ExecuteMethod(cmExport,DS)=rtSuccess then begin

        if DS.Active and not DS.IsEmpty then begin
          if DS.Locate(SFieldName,SStream,[]) then begin
            TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
          end;
        end;

      end;
    finally
      DS.Free;
    end;
  end;
end;

function TBisIdHttp.GetServerDate: TDateTime;
var
  DS: TBisDataSet;
begin
  Result:=Now;
  DS:=CreateParams;
  try
    DS.Append;
    DS.FieldByName(SFieldName).Value:=SResult;
    DS.FieldByName(SFieldValue).Value:=Null;
    DS.Post;

    if ExecuteMethod(cmGetServerDate,DS)=rtSuccess then begin

      if DS.Active and not DS.IsEmpty then begin
        if DS.Locate(SFieldName,SResult,[]) then begin
          Result:=StrToDateTimeDef(DS.FieldByName(SFieldValue).AsString,Now);
        end;
      end;

    end;
  finally
    DS.Free;
  end;
end;

function TBisIdHttp.Login(const ApplicationId: Variant; const UserName, Password: String; Params: TBisConnectionLoginParams=nil): Variant;
var
  DS: TBisDataSet;
  Stream: TMemoryStream;
  LoginParams: TBisConnectionLoginParams;
begin
  if Assigned(Params) then begin
    Result:=Null;
    DS:=CreateParams;
    try
      DS.Append;
      DS.FieldByName(SFieldName).Value:=SApplicationId;
      DS.FieldByName(SFieldValue).Value:=ApplicationId;
      DS.Post;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SUserName;
      DS.FieldByName(SFieldValue).Value:=UserName;
      DS.Post;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SPassword;
      DS.FieldByName(SFieldValue).Value:=Password;
      DS.Post;

      if Assigned(Params) then begin
        Stream:=TMemoryStream.Create;
        try
          Params.SaveToStream(Stream);
          Stream.Position:=0;
          DS.Append;
          DS.FieldByName(SFieldName).Value:=SParams;
          TBlobField(DS.FieldByName(SFieldValue)).LoadFromStream(Stream);
          DS.Post;
        finally
          Stream.Free;
        end;
      end;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SResult;
      DS.FieldByName(SFieldValue).Value:=Null;
      DS.Post;

      if ExecuteMethod(cmLogin,DS)=rtSuccess then begin

        if DS.Active and not DS.IsEmpty then begin

          if DS.Locate(SFieldName,SParams,[]) then begin
            if Assigned(Params) then begin
              LoginParams:=TBisConnectionLoginParams.Create;
              Stream:=TMemoryStream.Create;
              try
                TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
                Stream.Position:=0;
                LoginParams.LoadFromStream(Stream);
                Params.AccountId:=LoginParams.AccountId;
                Params.FirmId:=LoginParams.FirmId;
                Params.FirmSmallName:=LoginParams.FirmSmallName;
              finally
                Stream.Free;
                LoginParams.Free;
              end;
            end;
          end;

          if DS.Locate(SFieldName,SResult,[]) then begin
            Result:=DS.FieldByName(SFieldValue).Value;
          end;

        end;
      end;
    finally
      DS.Free;
    end;
  end;
end;

procedure TBisIdHttp.Logout(const SessionId: Variant);
var
  DS: TBisDataSet;
begin
  DS:=CreateParams;
  try
    DS.Append;
    DS.FieldByName(SFieldName).Value:=SSessionId;
    DS.FieldByName(SFieldValue).Value:=SessionId;
    DS.Post;

    ExecuteMethod(cmLogout,DS);
  finally
    DS.Free;
  end;
end;

function TBisIdHttp.Check(const SessionId: Variant; var ServerDate: TDateTime): Boolean;
var
  DS: TBisDataSet;
begin
  DS:=CreateParams;
  try
    Result:=false;
    
    DS.Append;
    DS.FieldByName(SFieldName).Value:=SSessionId;
    DS.FieldByName(SFieldValue).Value:=SessionId;
    DS.Post;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SServerDate;
    DS.FieldByName(SFieldValue).Value:=Null;
    DS.Post;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SResult;
    DS.FieldByName(SFieldValue).Value:=Null;
    DS.Post;

    if ExecuteMethod(cmCheck,DS)=rtSuccess then begin

      if DS.Active and not DS.IsEmpty then begin

        if DS.Locate(SFieldName,SResult,[]) then begin
          Result:=Boolean(StrToIntDef(DS.FieldByName(SFieldValue).AsString,0));
        end;

        if Result and DS.Locate(SFieldName,SServerDate,[]) then begin
          ServerDate:=StrToDateTimeDef(DS.FieldByName(SFieldValue).AsString,Now);
        end;

      end;

    end;

  finally
    DS.Free;
  end;
end;

procedure TBisIdHttp.Update(const SessionId: Variant; Params: TBisConfig);
var
  DS: TBisDataSet;
  Stream: TMemoryStream;
begin
  if Assigned(Params) then begin
    DS:=CreateParams;
    try
      DS.Append;
      DS.FieldByName(SFieldName).Value:=SSessionId;
      DS.FieldByName(SFieldValue).Value:=SessionId;
      DS.Post;

      Stream:=TMemoryStream.Create;
      try
        Params.SaveToStream(Stream);
        Stream.Position:=0;
        DS.Append;
        DS.FieldByName(SFieldName).Value:=SParams;
        TBlobField(DS.FieldByName(SFieldValue)).LoadFromStream(Stream);
        DS.Post;
      finally
        Stream.Free;
      end;

      ExecuteMethod(cmUpdate,DS);
    finally
      DS.Free;
    end;
  end;
end;

procedure TBisIdHttp.LoadProfile(const SessionId: Variant; Profile: TBisProfile);
var
  DS: TBisDataSet;
  Stream: TMemoryStream;
  CheckSum: String;
  CacheFileName: String;
begin
  if Assigned(Profile) then begin
    DS:=CreateParams;
    try
      DS.Append;
      DS.FieldByName(SFieldName).Value:=SSessionId;
      DS.FieldByName(SFieldValue).Value:=SessionId;
      DS.Post;

      CheckSum:='';
      CacheFileName:='';
      if FParent.FUseCache then begin
        CacheFileName:=GetCacheFileName(cmLoadProfile,FormatEx('%s %s',[Core.AccountId,Core.Application.ID]));
        CheckSum:=GetCacheFileCheckSum(CacheFileName);

        DS.Append;
        DS.FieldByName(SFieldName).Value:=SCheckSum;
        DS.FieldByName(SFieldValue).Value:=CheckSum;
        DS.Post;
      end;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SProfile;
      DS.FieldByName(SFieldValue).Value:=Null;
      DS.Post;

      if ExecuteMethod(cmLoadProfile,DS)=rtSuccess then begin

        if DS.Active and not DS.IsEmpty then begin

          if DS.Locate(SFieldName,SProfile,[]) then begin
            Stream:=TMemoryStream.Create;
            try
              TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
              Stream.Position:=0;
              if Stream.Size>0 then begin
                if FParent.FUseCache then begin
                  SaveStreamToCacheFile(Stream,CacheFileName);
                  Stream.Position:=0;
                end;
                Profile.LoadFromStream(Stream);
              end else begin
                if FParent.FUseCache then begin
                  Stream.Clear;
                  LoadStreamFromCacheFile(Stream,CacheFileName);
                  Stream.Position:=0;
                  Profile.LoadFromStream(Stream);
                end;
              end;
            finally
              Stream.Free;
            end;
          end;
        end;
      end;

    finally
      DS.Free;
    end;
  end;
end;

procedure TBisIdHttp.SaveProfile(const SessionId: Variant; Profile: TBisProfile);
var
  DS: TBisDataSet;
  Stream: TMemoryStream;
  CacheFileName: String;
begin
  if Assigned(Profile) then begin
    DS:=CreateParams;
    try
      DS.Append;
      DS.FieldByName(SFieldName).Value:=SSessionId;
      DS.FieldByName(SFieldValue).Value:=SessionId;
      DS.Post;

      Stream:=TMemoryStream.Create;
      try
        Profile.SaveToStream(Stream);
        Stream.Position:=0;
        DS.Append;
        DS.FieldByName(SFieldName).Value:=SProfile;
        TBlobField(DS.FieldByName(SFieldValue)).LoadFromStream(Stream);
        DS.Post;

        if FParent.FUseCache then begin
          CacheFileName:=GetCacheFileName(cmLoadProfile,FormatEx('%s %s',[Core.AccountId,Core.Application.ID]));
          Stream.Position:=0;
          SaveStreamToCacheFile(Stream,CacheFileName);
        end;

      finally
        Stream.Free;
      end;

      ExecuteMethod(cmSaveProfile,DS);
    finally
      DS.Free;
    end;
  end;
end;

procedure TBisIdHttp.RefreshPermissions(const SessionId: Variant);
var
  DS: TBisDataSet;
begin
  DS:=CreateParams;
  try
    DS.Append;
    DS.FieldByName(SFieldName).Value:=SSessionId;
    DS.FieldByName(SFieldValue).Value:=SessionId;
    DS.Post;

    ExecuteMethod(cmRefreshPermissions,DS);
  finally
    DS.Free;
  end;
end;

procedure TBisIdHttp.LoadInterfaces(const SessionId: Variant; Interfaces: TBisInterfaces);
var
  DS: TBisDataSet;
  Stream: TMemoryStream;
  CheckSum: String;
  CacheFileName: String;
begin
  if Assigned(Interfaces) then begin
    DS:=CreateParams;
    try
      DS.Append;
      DS.FieldByName(SFieldName).Value:=SSessionId;
      DS.FieldByName(SFieldValue).Value:=SessionId;
      DS.Post;

      CheckSum:='';
      CacheFileName:='';
      if FParent.FUseCache then begin
        CacheFileName:=GetCacheFileName(cmLoadInterfaces,FormatEx('%s %s',[Core.AccountId,Core.Application.ID]));
        CheckSum:=GetCacheFileCheckSum(CacheFileName);

        DS.Append;
        DS.FieldByName(SFieldName).Value:=SCheckSum;
        DS.FieldByName(SFieldValue).Value:=CheckSum;
        DS.Post;
      end;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SInterfaces;
      DS.FieldByName(SFieldValue).Value:=Null;
      DS.Post;

      if ExecuteMethod(cmLoadInterfaces,DS)=rtSuccess then begin

        if DS.Active and not DS.IsEmpty then begin

          if DS.Locate(SFieldName,SInterfaces,[]) then begin
            Stream:=TMemoryStream.Create;
            try
              TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
              Stream.Position:=0;
              if Stream.Size>0 then begin
                if FParent.FUseCache then begin
                  SaveStreamToCacheFile(Stream,CacheFileName);
                  Stream.Position:=0;
                end;
                Interfaces.LoadFromStream(Stream);
              end else begin
                if FParent.FUseCache then begin
                  Stream.Clear;
                  LoadStreamFromCacheFile(Stream,CacheFileName);
                  Stream.Position:=0;
                  Interfaces.LoadFromStream(Stream);
                end;
              end;
            finally
              Stream.Free;
            end;
          end;

        end;
      end;
    finally
      DS.Free;
    end;
  end;
end;

procedure TBisIdHttp.GetRecords(const SessionId: Variant; DataSet: TBisDataSet);
var
  DS: TBisDataSet;
  Stream: TMemoryStream;
  CheckSum: String;
  CacheFileName: String;
  AUseCache: Boolean;
  Collection: TBisDataSetCollection;
  Package: TBisDataSetPackage;
begin
  if Assigned(DataSet) then begin

    AUseCache:=FParent.FUseCache and DataSet.UseCache;
    if AUseCache and (FParent.FCacheProviders.Count>0) then
      AUseCache:=FParent.FCacheProviders.IndexOf(DataSet.ProviderName)<>-1;

    DS:=CreateParams;
    Stream:=TMemoryStream.Create;
    Package:=TBisDataSetPackage.Create;
    Collection:=TBisDataSetCollection.Create;
    try

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SSessionId;
      DS.FieldByName(SFieldValue).Value:=SessionId;
      DS.Post;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SProviderName;
      DS.FieldByName(SFieldValue).Value:=DataSet.ProviderName;
      DS.Post;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SFetchCount;
      DS.FieldByName(SFieldValue).Value:=DataSet.FetchCount;
      DS.Post;

      Stream.Clear;
      DataSet.FieldNames.SaveToStream(Stream);
      Stream.Position:=0;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SFieldNames;
      TBlobField(DS.FieldByName(SFieldValue)).LoadFromStream(Stream);
      DS.Post;

      Stream.Clear;
      DataSet.FilterGroups.SaveToStream(Stream);
      Stream.Position:=0;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SFilterGroups;
      TBlobField(DS.FieldByName(SFieldValue)).LoadFromStream(Stream);
      DS.Post;

      Stream.Clear;
      DataSet.Orders.SaveToStream(Stream);
      Stream.Position:=0;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SOrders;
      TBlobField(DS.FieldByName(SFieldValue)).LoadFromStream(Stream);
      DS.Post;

      Stream.Clear;
      DataSet.Params.SaveToStream(Stream);
      Stream.Position:=0;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SParams;
      TBlobField(DS.FieldByName(SFieldValue)).LoadFromStream(Stream);
      DS.Post;

      Package.CopyFrom(DataSet.PackageBefore,true,false);
      Stream.Clear;
      Package.SaveToStream(Stream);
      Stream.Position:=0;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SPackageBefore;
      TBlobField(DS.FieldByName(SFieldValue)).LoadFromStream(Stream);
      DS.Post;

      Package.CopyFrom(DataSet.PackageAfter,true,false);
      Stream.Clear;
      Package.SaveToStream(Stream);
      Stream.Position:=0;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SPackageAfter;
      TBlobField(DS.FieldByName(SFieldValue)).LoadFromStream(Stream);
      DS.Post;

      Stream.Clear;
      DataSet.CollectionBefore.SaveToStream(Stream);
      Stream.Position:=0;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SCollectionBefore;
      TBlobField(DS.FieldByName(SFieldValue)).LoadFromStream(Stream);
      DS.Post;

      Stream.Clear;
      DataSet.CollectionAfter.SaveToStream(Stream);
      Stream.Position:=0;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SCollectionAfter;
      TBlobField(DS.FieldByName(SFieldValue)).LoadFromStream(Stream);
      DS.Post;

      CheckSum:='';
      CacheFileName:='';
      if AUseCache then begin
        CacheFileName:=GetCacheFileName(cmGetRecords,DataSet);
        CheckSum:=GetCacheFileCheckSum(CacheFileName);

        DS.Append;
        DS.FieldByName(SFieldName).Value:=SCheckSum;
        DS.FieldByName(SFieldValue).Value:=CheckSum;
        DS.Post;
      end;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SDataSet;
      DS.FieldByName(SFieldValue).Value:=Null;
      DS.Post;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SServerRecordCount;
      DS.FieldByName(SFieldValue).Value:=Null;
      DS.Post;

      if ExecuteMethod(cmGetRecords,DS)=rtSuccess then begin

        if DS.Active and not DS.IsEmpty then begin

          if DS.Locate(SFieldName,SDataSet,[]) then begin
            Stream.Clear;
            TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
            Stream.Position:=0;
            if Stream.Size>0 then begin
//              if AUseCache and (Trim(DataSet.ProviderName)<>'') then begin
              if AUseCache then begin
                SaveStreamToCacheFile(Stream,CacheFileName);
                Stream.Position:=0;
              end;
              LoadDataSetFromStream(DataSet,Stream);
            end else begin
//              if AUseCache and (Trim(DataSet.ProviderName)<>'') then
              if AUseCache and (Trim(CheckSum)<>'') then
                LoadDataSetFromCacheFile(DataSet,CacheFileName);
            end;
          end;

          if DS.Locate(SFieldName,SServerRecordCount,[]) then begin
            DataSet.ServerRecordCount:=VarToIntDef(DS.FieldByName(SFieldValue).Value,0);
          end;

          if DS.Locate(SFieldName,SPackageBefore,[]) then begin
            Stream.Clear;
            TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
            Stream.Position:=0;
            Package.Clear;
            Package.LoadFromStream(Stream);
            DataSet.PackageBefore.CopyFrom(Package,false,false,[ptOutput,ptInputOutput,ptResult]);
          end;

          if DS.Locate(SFieldName,SPackageAfter,[]) then begin
            Stream.Clear;
            TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
            Stream.Position:=0;
            Package.Clear;
            Package.LoadFromStream(Stream);
            DataSet.PackageAfter.CopyFrom(Package,false,false,[ptOutput,ptInputOutput,ptResult]);
          end;
          
          if DS.Locate(SFieldName,SCollectionBefore,[]) then begin
            Stream.Clear;
            TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
            Stream.Position:=0;
            Collection.Clear;
            Collection.LoadFromStream(Stream);
            DataSet.CollectionBefore.CopyFrom(Collection,false);
          end;

          if DS.Locate(SFieldName,SCollectionAfter,[]) then begin
            Stream.Clear;
            TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
            Stream.Position:=0;
            Collection.Clear;
            Collection.LoadFromStream(Stream);
            DataSet.CollectionAfter.CopyFrom(Collection,false);
          end;

        end;
      end;
    finally
      Collection.Free;
      Package.Free;
      Stream.Free;
      DS.Free;
    end;
  end;
end;

procedure TBisIdHttp.Execute(const SessionId: Variant; DataSet: TBisDataSet);
var
  DS: TBisDataSet;
  Stream: TMemoryStream;
  Params: TBisParams;
  CheckSum: String;
  CacheFileName: String;
  AUseCache: Boolean;
  Collection: TBisDataSetCollection;
  Package: TBisDataSetPackage;
begin
  if Assigned(DataSet) then begin

    AUseCache:=FParent.FUseCache and DataSet.UseCache;
    if AUseCache and (FParent.FCacheProviders.Count>0) then
      AUseCache:=FParent.FCacheProviders.IndexOf(DataSet.ProviderName)<>-1;

    DS:=CreateParams;
    Stream:=TMemoryStream.Create;
    Params:=TBisParams.Create;
    Collection:=TBisDataSetCollection.Create;
    Package:=TBisDataSetPackage.Create;
    try

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SSessionId;
      DS.FieldByName(SFieldValue).Value:=SessionId;
      DS.Post;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SProviderName;
      DS.FieldByName(SFieldValue).Value:=DataSet.ProviderName;
      DS.Post;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SFetchCount;
      DS.FieldByName(SFieldValue).Value:=DataSet.FetchCount;
      DS.Post;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SInGetRecords;
      DS.FieldByName(SFieldValue).Value:=Integer(DataSet.InGetRecords);
      DS.Post;

      Stream.Clear;
      DataSet.FieldNames.SaveToStream(Stream);
      Stream.Position:=0;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SFieldNames;
      TBlobField(DS.FieldByName(SFieldValue)).LoadFromStream(Stream);
      DS.Post;

      Params.CopyFrom(DataSet.Params,true,false);
      Stream.Clear;
      Params.SaveToStream(Stream);
      Stream.Position:=0;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SParams;
      TBlobField(DS.FieldByName(SFieldValue)).LoadFromStream(Stream);
      DS.Post;

      Package.CopyFrom(DataSet.PackageBefore,true,false);
      Stream.Clear;
      Package.SaveToStream(Stream);
      Stream.Position:=0;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SPackageBefore;
      TBlobField(DS.FieldByName(SFieldValue)).LoadFromStream(Stream);
      DS.Post;

      Package.CopyFrom(DataSet.PackageAfter,true,false);
      Stream.Clear;
      Package.SaveToStream(Stream);
      Stream.Position:=0;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SPackageAfter;
      TBlobField(DS.FieldByName(SFieldValue)).LoadFromStream(Stream);
      DS.Post;

      Stream.Clear;
      DataSet.CollectionBefore.SaveToStream(Stream);
      Stream.Position:=0;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SCollectionBefore;
      TBlobField(DS.FieldByName(SFieldValue)).LoadFromStream(Stream);
      DS.Post;

      Stream.Clear;
      DataSet.CollectionAfter.SaveToStream(Stream);
      Stream.Position:=0;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SCollectionAfter;
      TBlobField(DS.FieldByName(SFieldValue)).LoadFromStream(Stream);
      DS.Post;
      
      CheckSum:='';
      CacheFileName:='';
      if AUseCache then begin
        CacheFileName:=GetCacheFileName(cmExecute,DataSet);
        CheckSum:=GetCacheFileCheckSum(CacheFileName);

        DS.Append;
        DS.FieldByName(SFieldName).Value:=SCheckSum;
        DS.FieldByName(SFieldValue).Value:=CheckSum;
        DS.Post;
      end;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SDataSet;
      DS.FieldByName(SFieldValue).Value:=Null;
      DS.Post;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SServerRecordCount;
      DS.FieldByName(SFieldValue).Value:=Null;
      DS.Post;

      if ExecuteMethod(cmExecute,DS)=rtSuccess then begin

        if DS.Active and not DS.IsEmpty then begin

          if DS.Locate(SFieldName,SDataSet,[]) then begin
            Stream.Clear;
            TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
            Stream.Position:=0;
            if Stream.Size>0 then begin
//              if AUseCache and DataSet.InGetRecords and (Trim(DataSet.ProviderName)<>'') then begin
              if AUseCache then begin
                SaveStreamToCacheFile(Stream,CacheFileName);
                Stream.Position:=0;
              end;
              LoadDataSetFromStream(DataSet,Stream);
            end else begin
//              if AUseCache and DataSet.InGetRecords and (Trim(DataSet.ProviderName)<>'') then
              if AUseCache and (Trim(CheckSum)<>'') then
                LoadDataSetFromCacheFile(DataSet,CacheFileName);
            end;
          end;

          if DS.Locate(SFieldName,SServerRecordCount,[]) then begin
            DataSet.ServerRecordCount:=VarToIntDef(DS.FieldByName(SFieldValue).Value,0);
          end;

          if DS.Locate(SFieldName,SParams,[]) then begin
            Stream.Clear;
            TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
            Stream.Position:=0;
            Params.Clear;
            Params.LoadFromStream(Stream);
            DataSet.Params.CopyFrom(Params,false,false,[ptOutput,ptInputOutput,ptResult]);
          end;

          if DS.Locate(SFieldName,SPackageBefore,[]) then begin
            Stream.Clear;
            TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
            Stream.Position:=0;
            Package.Clear;
            Package.LoadFromStream(Stream);
            DataSet.PackageBefore.CopyFrom(Package,false,false,[ptOutput,ptInputOutput,ptResult]);
          end;

          if DS.Locate(SFieldName,SPackageAfter,[]) then begin
            Stream.Clear;
            TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
            Stream.Position:=0;
            Package.Clear;
            Package.LoadFromStream(Stream);
            DataSet.PackageAfter.CopyFrom(Package,false,false,[ptOutput,ptInputOutput,ptResult]);
          end;
          
          if DS.Locate(SFieldName,SCollectionBefore,[]) then begin
            Stream.Clear;
            TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
            Stream.Position:=0;
            Collection.Clear;
            Collection.LoadFromStream(Stream);
            DataSet.CollectionBefore.CopyFrom(Collection,false);
          end;

          if DS.Locate(SFieldName,SCollectionAfter,[]) then begin
            Stream.Clear;
            TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
            Stream.Position:=0;
            Collection.Clear;
            Collection.LoadFromStream(Stream);
            DataSet.CollectionAfter.CopyFrom(Collection,false);
          end;
          
        end;
      end;
    finally
      Collection.Free;
      Package.Free;
      Params.Free;
      Stream.Free;
      DS.Free;
    end;
  end;
end;

procedure TBisIdHttp.LoadMenus(const SessionId: Variant; Menus: TBisMenus);
var
  DS: TBisDataSet;
  Stream: TMemoryStream;
  CheckSum: String;
  CacheFileName: String;
begin
  if Assigned(Menus) then begin
    DS:=CreateParams;
    try
      DS.Append;
      DS.FieldByName(SFieldName).Value:=SSessionId;
      DS.FieldByName(SFieldValue).Value:=SessionId;
      DS.Post;

      CheckSum:='';
      CacheFileName:='';
      if FParent.FUseCache then begin
        CacheFileName:=GetCacheFileName(cmLoadMenus,FormatEx('%s %s',[Core.AccountId,Core.Application.ID]));
        CheckSum:=GetCacheFileCheckSum(CacheFileName);

        DS.Append;
        DS.FieldByName(SFieldName).Value:=SCheckSum;
        DS.FieldByName(SFieldValue).Value:=CheckSum;
        DS.Post;
      end;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SMenus;
      DS.FieldByName(SFieldValue).Value:=Null;
      DS.Post;

      if ExecuteMethod(cmLoadMenus,DS)=rtSuccess then begin

        if DS.Active and not DS.IsEmpty then begin

          if DS.Locate(SFieldName,SMenus,[]) then begin
            Stream:=TMemoryStream.Create;
            try
              TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
              Stream.Position:=0;
              if Stream.Size>0 then begin
                if FParent.FUseCache then begin
                  SaveStreamToCacheFile(Stream,CacheFileName);
                  Stream.Position:=0;
                end;
                Menus.LoadFromStream(Stream);
              end else begin
                if FParent.FUseCache then begin
                  Stream.Clear;
                  LoadStreamFromCacheFile(Stream,CacheFileName);
                  Stream.Position:=0;
                  Menus.LoadFromStream(Stream);
                end;
              end;
            finally
              Stream.Free;
            end;
          end;

        end;
      end;
    finally
      DS.Free;
    end;
  end;
end;

procedure TBisIdHttp.LoadTasks(const SessionId: Variant; Tasks: TBisTasks);
var
  DS: TBisDataSet;
  Stream: TMemoryStream;
  CheckSum: String;
  CacheFileName: String;
begin
  if Assigned(Tasks) then begin
    DS:=CreateParams;
    try
      DS.Append;
      DS.FieldByName(SFieldName).Value:=SSessionId;
      DS.FieldByName(SFieldValue).Value:=SessionId;
      DS.Post;

      CheckSum:='';
      CacheFileName:='';
      if FParent.FUseCache then begin
        CacheFileName:=GetCacheFileName(cmLoadTasks,FormatEx('%s %s',[Core.AccountId,Core.Application.ID]));
        CheckSum:=GetCacheFileCheckSum(CacheFileName);

        DS.Append;
        DS.FieldByName(SFieldName).Value:=SCheckSum;
        DS.FieldByName(SFieldValue).Value:=CheckSum;
        DS.Post;
      end;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=STasks;
      DS.FieldByName(SFieldValue).Value:=Null;
      DS.Post;

      if ExecuteMethod(cmLoadTasks,DS)=rtSuccess then begin

        if DS.Active and not DS.IsEmpty then begin
          if DS.Locate(SFieldName,STasks,[]) then begin
            Stream:=TMemoryStream.Create;
            try
              TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
              Stream.Position:=0;
              if Stream.Size>0 then begin
                if FParent.FUseCache then begin
                  SaveStreamToCacheFile(Stream,CacheFileName);
                  Stream.Position:=0;
                end;
                Tasks.LoadFromStream(Stream);
              end else begin
                if FParent.FUseCache then begin
                  Stream.Clear;
                  LoadStreamFromCacheFile(Stream,CacheFileName);
                  Stream.Position:=0;
                  Tasks.LoadFromStream(Stream);
                end;
              end;
            finally
              Stream.Free;
            end;
          end;
        end;
      end;
    finally
      DS.Free;
    end;
  end;
end;

procedure TBisIdHttp.SaveTask(const SessionId: Variant; Task: TBisTask);
var
  DS: TBisDataSet;
  Stream: TMemoryStream;
begin
  if Assigned(Task) then begin
    DS:=CreateParams;
    try
      DS.Append;
      DS.FieldByName(SFieldName).Value:=SSessionId;
      DS.FieldByName(SFieldValue).Value:=SessionId;
      DS.Post;

      Stream:=TMemoryStream.Create;
      try
        Task.SaveToStream(Stream);
        Stream.Position:=0;
        DS.Append;
        DS.FieldByName(SFieldName).Value:=STask;
        TBlobField(DS.FieldByName(SFieldValue)).LoadFromStream(Stream);
        DS.Post;
      finally
        Stream.Free;
      end;

      ExecuteMethod(cmSaveTask,DS);
    finally
      DS.Free;
    end;
  end;
end;

procedure TBisIdHttp.LoadAlarms(const SessionId: Variant; Alarms: TBisAlarms);
var
  DS: TBisDataSet;
  Stream: TMemoryStream;
  CheckSum: String;
  CacheFileName: String;
begin
  if Assigned(Alarms) then begin
    DS:=CreateParams;
    try
      DS.Append;
      DS.FieldByName(SFieldName).Value:=SSessionId;
      DS.FieldByName(SFieldValue).Value:=SessionId;
      DS.Post;

      CheckSum:='';
      CacheFileName:='';
      if FParent.FUseCache then begin
        CacheFileName:=GetCacheFileName(cmLoadAlarms,FormatEx('%s %s',[Core.AccountId,Core.Application.ID]));
        CheckSum:=GetCacheFileCheckSum(CacheFileName);

        DS.Append;
        DS.FieldByName(SFieldName).Value:=SCheckSum;
        DS.FieldByName(SFieldValue).Value:=CheckSum;
        DS.Post;
      end;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SAlarms;
      DS.FieldByName(SFieldValue).Value:=Null;
      DS.Post;

      if ExecuteMethod(cmLoadAlarms,DS)=rtSuccess then begin

        if DS.Active and not DS.IsEmpty then begin
          if DS.Locate(SFieldName,SAlarms,[]) then begin
            Stream:=TMemoryStream.Create;
            try
              TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
              Stream.Position:=0;
              if Stream.Size>0 then begin
                if FParent.FUseCache then begin
                  SaveStreamToCacheFile(Stream,CacheFileName);
                  Stream.Position:=0;
                end;
                Alarms.LoadFromStream(Stream);
              end else begin
                if FParent.FUseCache then begin
                  Stream.Clear;
                  LoadStreamFromCacheFile(Stream,CacheFileName);
                  Stream.Position:=0;
                  Alarms.LoadFromStream(Stream);
                end;
              end;
            finally
              Stream.Free;
            end;
          end;
        end;
      end;
    finally
      DS.Free;
    end;
  end;
end;

procedure TBisIdHttp.LoadScript(const SessionId: Variant; ScriptId: Variant; Stream: TStream);
var
  DS: TBisDataSet;
  CheckSum: String;
  CacheFileName: String;
begin
  if Assigned(Stream) then begin
    DS:=CreateParams;
    try
      DS.Append;
      DS.FieldByName(SFieldName).Value:=SSessionId;
      DS.FieldByName(SFieldValue).Value:=SessionId;
      DS.Post;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SScriptId;
      DS.FieldByName(SFieldValue).Value:=ScriptId;
      DS.Post;

      CheckSum:='';
      CacheFileName:='';
      if FParent.FUseCache then begin
        CacheFileName:=GetCacheFileName(cmLoadScript,VarToStrDef(ScriptId,''));
        CheckSum:=GetCacheFileCheckSum(CacheFileName);

        DS.Append;
        DS.FieldByName(SFieldName).Value:=SCheckSum;
        DS.FieldByName(SFieldValue).Value:=CheckSum;
        DS.Post;
      end;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SStream;
      DS.FieldByName(SFieldValue).Value:=Null;
      DS.Post;

      if ExecuteMethod(cmLoadScript,DS)=rtSuccess then begin

        if DS.Active and not DS.IsEmpty then begin
          if DS.Locate(SFieldName,SStream,[]) then begin
            TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
            Stream.Position:=0;
            if Stream.Size>0 then begin
              if FParent.FUseCache then begin
                SaveStreamToCacheFile(Stream,CacheFileName);
                Stream.Position:=0;
              end;
            end else begin
              if FParent.FUseCache then begin
                LoadStreamFromCacheFile(Stream,CacheFileName);
                Stream.Position:=0;
              end;
            end;
          end;
        end;
      end;
    finally
      DS.Free;
    end;
  end;
end;

procedure TBisIdHttp.LoadReport(const SessionId: Variant; ReportId: Variant; Stream: TStream);
var
  DS: TBisDataSet;
  CheckSum: String;
  CacheFileName: String;
begin
  if Assigned(Stream) then begin
    DS:=CreateParams;
    try
      DS.Append;
      DS.FieldByName(SFieldName).Value:=SSessionId;
      DS.FieldByName(SFieldValue).Value:=SessionId;
      DS.Post;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SReportId;
      DS.FieldByName(SFieldValue).Value:=ReportId;
      DS.Post;

      CheckSum:='';
      CacheFileName:='';
      if FParent.FUseCache then begin
        CacheFileName:=GetCacheFileName(cmLoadReport,VarToStrDef(ReportId,''));
        CheckSum:=GetCacheFileCheckSum(CacheFileName);

        DS.Append;
        DS.FieldByName(SFieldName).Value:=SCheckSum;
        DS.FieldByName(SFieldValue).Value:=CheckSum;
        DS.Post;
      end;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SStream;
      DS.FieldByName(SFieldValue).Value:=Null;
      DS.Post;

      if ExecuteMethod(cmLoadReport,DS)=rtSuccess then begin

        if DS.Active and not DS.IsEmpty then begin
          if DS.Locate(SFieldName,SStream,[]) then begin

            TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
            Stream.Position:=0;
            if Stream.Size>0 then begin
              if FParent.FUseCache then begin
                SaveStreamToCacheFile(Stream,CacheFileName);
                Stream.Position:=0;
              end;
            end else begin
              if FParent.FUseCache then begin
                LoadStreamFromCacheFile(Stream,CacheFileName);
                Stream.Position:=0;
              end;
            end;

          end;
        end;
      end;
    finally
      DS.Free;
    end;
  end;
end;

procedure TBisIdHttp.LoadDocument(const SessionId: Variant; DocumentId: Variant; Stream: TStream);
var
  DS: TBisDataSet;
  CheckSum: String;
  CacheFileName: String;
begin
  if Assigned(Stream) then begin
    DS:=CreateParams;
    try
      DS.Append;
      DS.FieldByName(SFieldName).Value:=SSessionId;
      DS.FieldByName(SFieldValue).Value:=SessionId;
      DS.Post;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SDocumentId;
      DS.FieldByName(SFieldValue).Value:=DocumentId;
      DS.Post;

      CheckSum:='';
      CacheFileName:='';
      if FParent.FUseCache then begin
        CacheFileName:=GetCacheFileName(cmLoadDocument,VarToStrDef(DocumentId,''));
        CheckSum:=GetCacheFileCheckSum(CacheFileName);

        DS.Append;
        DS.FieldByName(SFieldName).Value:=SCheckSum;
        DS.FieldByName(SFieldValue).Value:=CheckSum;
        DS.Post;
      end;

      DS.Append;
      DS.FieldByName(SFieldName).Value:=SStream;
      DS.FieldByName(SFieldValue).Value:=Null;
      DS.Post;

      if ExecuteMethod(cmLoadDocument,DS)=rtSuccess then begin

        if DS.Active and not DS.IsEmpty then begin
          if DS.Locate(SFieldName,SStream,[]) then begin
            TBlobField(DS.FieldByName(SFieldValue)).SaveToStream(Stream);
            Stream.Position:=0;
            if Stream.Size>0 then begin
              if FParent.FUseCache then begin
                SaveStreamToCacheFile(Stream,CacheFileName);
                Stream.Position:=0;
              end;
            end else begin
              if FParent.FUseCache then begin
                LoadStreamFromCacheFile(Stream,CacheFileName);
                Stream.Position:=0;
              end;
            end;
          end;
        end;
      end;
    finally
      DS.Free;
    end;
  end;
end;

procedure TBisIdHttp.Cancel(const SessionId: Variant; DataSetCheckSum: String);
var
  DS: TBisDataSet;
begin
  DS:=CreateParams;
  try
    DS.Append;
    DS.FieldByName(SFieldName).Value:=SSessionId;
    DS.FieldByName(SFieldValue).Value:=SessionId;
    DS.Post;

    DS.Append;
    DS.FieldByName(SFieldName).Value:=SDataSetCheckSum;
    DS.FieldByName(SFieldValue).Value:=DataSetCheckSum;
    DS.Post;

    ExecuteMethod(cmCancel,DS);
  finally
    DS.Free;
  end;
end;

{ TBisHttpConnection }

constructor TBisHttpConnection.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FRecvBufferSize:=GRecvBufferSizeDefault;
  FSendBufferSize:=GSendBufferSizeDefault;
  FRandomStringSize:=1024*3;
  FConnectTimeout:=1000;

  FOriginal:=TBisIdHttpParams.Create;

  FCacheProviders:=TStringList.Create;

  FDialer:=TBisDialer.Create;
  FDialer.Mode:=dmSync;
  FDialer.OnNotify:=DialerNotify;

  Params.OnChange:=ChangeParams;

  FSNameAuto:='���������������';
  FSCacheFileNotFound:='���-���� %s �� ������.';
  FSErrorNotFound:='��� ������ �� ������.';
  FSConnectionCaption:='%s [%s]';
  FSServerDoesNotExists:='������� ����� ����� ��� �������� ������.';
end;

destructor TBisHttpConnection.Destroy;
begin
  FDialer.OnNotify:=nil;
  FDialer.Free;
  FCacheProviders.Free;
  FOriginal.Free;
  inherited Destroy;
end;

procedure TBisHttpConnection.Init;
begin
  inherited Init;
end;

function TBisHttpConnection.CreateConnection: TBisIdHttp;
begin
  Result:=TBisIdHttp.Create(Self);
  Result.FParent:=Self;
end;

procedure TBisHttpConnection.ChangeParams(Sender: TObject);
{var
  i: Integer;
  Param: TBisConnectionParam;}
begin

  FHost:=Params.AsString(SParamHost);
  if FHost<>'' then
    FHostIP:=ResolveIP(FHost);

  FPort:=Params.AsInteger(SParamPort,IdPORT_HTTP);
  FPath:=Params.AsString(SParamPath);
  FProtocol:=Params.AsString(SParamProtocol);

  FConnectionType:=Params.AsEnumeration(SParamType,TypeInfo(TBisHttpConnectionType),ctDirect);

  FUseProxy:=Params.AsBoolean(SParamUseProxy);
  FProxyServer:=Params.AsString(SParamProxyHost);
  FProxyPort:=Params.AsInteger(SParamProxyPort);
  FProxyUsername:=Params.AsString(SParamProxyUserName);
  FProxyPassword:=Params.AsString(SParamProxyPassword);

  FRemoteAuto:=Params.AsBoolean(SParamRemoteAuto);
  FRemoteName:=Params.AsString(SParamRemoteName);

  FDialer.UserName:=Params.AsString(SParamModemUser);
  FDialer.Password:=Params.AsString(SParamModemPassword);
  FDialer.Domain:=Params.AsString(SParamModemDomain);
  FDialer.PhoneNumber:=Params.AsString(SParamModemPhone);

  FUseCrypter:=Params.AsBoolean(SParamUseCrypter);
  FCrypterAlgorithm:=Params.AsEnumeration(SParamCrypterAlgorithm,TypeInfo(TBisCipherAlgorithm),ca3Way);
  FCrypterMode:=Params.AsEnumeration(SParamCrypterAlgorithm,TypeInfo(TBisCipherMode),cmCTS);
  FCrypterKey:=Params.AsString(SParamCrypterKey);

  FUseCompressor:=Params.AsBoolean(SParamUseCompressor);
  FCompressorLevel:=Params.AsEnumeration(SParamCompressorLevel,TypeInfo(TCompressionLevel),clNone);

  FAuthUserName:=Params.AsString(SParamAuthUserName);
  FAuthPassword:=Params.AsString(SParamAuthPassword);

  FUseCache:=Params.AsBoolean(SParamUseCache);
  FCacheDirectory:=Params.AsString(SParamCacheDirectory);
  FCacheProviders.Text:=Params.AsString(SParamCacheProviders);

  FConnectTimeout:=Params.AsInteger(SParamConnectTimeOut,FConnectTimeout);
  FUserAgent:=Params.AsString(SParamUserAgent,ObjectName);

  FRecvBufferSize:=Params.AsInteger(SParamRecvBufferSize,FRecvBufferSize);
  FSendBufferSize:=Params.AsInteger(SParamSendBufferSize,FSendBufferSize);
  FRandomStringSize:=Params.AsInteger(SParamRandomStringSize,FRandomStringSize);

  FOriginal.CopyFrom(Self);
end;

function TBisHttpConnection.GetConnected: Boolean;
begin
  Result:=FConnected;
end;

function TBisHttpConnection.GetInternetType: TBisHttpConnectionInternetType;
var
  Connected: Bool;
  dwFlags: Dword;
begin
  Result:=citUnknown;
  Connected:=InternetGetConnectedState(@dwFlags,0) and ((dwFlags and INTERNET_CONNECTION_MODEM_BUSY)=0);
  if Connected then begin
    if (dwFlags and INTERNET_CONNECTION_MODEM)=1 then Result:=citModem;
    if (dwFlags and INTERNET_CONNECTION_LAN)=1 then Result:=citLan;
    if (dwFlags and INTERNET_CONNECTION_PROXY)=1 then Result:=citProxy;
  end;
end;

procedure TBisHttpConnection.DialerNotify(Sender: TObject; State: TRasConnState;
  ErrorCode: DWORD);
begin
  FConnected:=FDialer.Active;
end;

procedure TBisHttpConnection.ConnectDirect(Connection: TBisIdHttp);
var
  AConnected: Boolean;
begin
  AConnected:=false;
  try
    Connection.Connect;
    AConnected:=true;
  finally
    FConnected:=AConnected;
  end;
end;

procedure TBisHttpConnection.ConnectRemote(Connection: TBisIdHttp);
var
  InternetType: TBisHttpConnectionInternetType;
  Ret: Dword;
  dwConnection: DWord;
  AConnected: Boolean;
  NewRemoteName: string;
  S: String;
begin
  AConnected:=false;
  try
    NewRemoteName:=iff(FRemoteAuto,FSNameAuto,FRemoteName);
    InternetType:=GetInternetType;
    if InternetType<>citLan then begin
      if FRemoteAuto then begin
        AConnected:=InternetAutoDial(INTERNET_AUTODIAL_FORCE_UNATTENDED,ParentHandle);
      end else begin
        Ret:=InternetDial(ParentHandle,PChar(FRemoteName),INTERNET_AUTODIAL_FORCE_UNATTENDED,@dwConnection,0);
        if Ret=ERROR_SUCCESS then begin
          FInternet:=dwConnection;
          AConnected:=true;
        end;
      end;
    end else AConnected:=true;

    if AConnected then begin
      S:=Connection.GetFullUrl;
      InternetGoOnline(PChar(S),ParentHandle,0);
      Connection.Connect;
    end;
  finally
    FConnected:=AConnected;
  end;
end;

procedure TBisHttpConnection.ConnectModem(Connection: TBisIdHttp);
var
  InternetType: TBisHttpConnectionInternetType;
  Ret: Dword;
  AConnected: Boolean;
  S: String;
begin
  AConnected:=false;
  try
    Ret:=ERROR_SUCCESS;
    InternetType:=GetInternetType;
    if InternetType<>citLan then begin
      try
        FDialer.Dial;
      except
        On E: EWin32Error do begin
          Ret:=E.ErrorCode;
        end;
      end;
      if Ret=ERROR_SUCCESS then begin
        FInternet:=FDialer.ConnHandle;
        AConnected:=true;
      end;
    end else AConnected:=true;

    if AConnected then begin
      S:=Connection.GetFullUrl;
      InternetGoOnline(PChar(S),ParentHandle,0);
      Connection.Connect;
    end;
  finally
    FConnected:=AConnected;
  end;
end;

procedure TBisHttpConnection.Connect;
var
  Connection: TBisIdHttp;
begin
  Connection:=CreateConnection;
  try
    if not FConnected then begin
      FOriginal.CopyTo(Self);
      case FConnectionType of
        ctDirect: ConnectDirect(Connection);
        ctRemote: ConnectRemote(Connection);
        ctModem: ConnectModem(Connection);
      end;
    end;
  finally
    Connection.Free;
  end;
end;

procedure TBisHttpConnection.DisconnectDirect(Connection: TBisIdHttp);
begin
  try
    Connection.Disconnect;
  finally
    FConnected:=false;
  end;
end;

procedure TBisHttpConnection.DisconnectRemote(Connection: TBisIdHttp);
var
  InternetType: TBisHttpConnectionInternetType;
begin
  Connection.Disconnect;
  InternetType:=GetInternetType;
  if InternetType<>citLan then begin
    if FRemoteAuto then
      InternetAutodialHangup(0)
    else begin
      InternetHangUp(FInternet,0);
    end;
  end;
  FConnected:=false;
end;

procedure TBisHttpConnection.DisconnectModem(Connection: TBisIdHttp);
var
  InternetType: TBisHttpConnectionInternetType;
begin
  Connection.Disconnect;
  InternetType:=GetInternetType;
  if InternetType<>citLan then begin
    try
      if FDialer.Active then
        FDialer.HangUp;
    except
    end;
  end;
  FConnected:=false;
end;

procedure TBisHttpConnection.Disconnect;
var
  Connection: TBisIdHttp;
begin
  Connection:=CreateConnection;
  try
    if FConnected then begin
      case FConnectionType of
        ctDirect: DisconnectDirect(Connection);
        ctRemote: DisconnectRemote(Connection);
        ctModem: DisconnectModem(Connection);
      end;
    end;
  finally
    Connection.Free;
  end;
end;

procedure TBisHttpConnection.Import(ImportType: TBisConnectionImportType; Stream: TStream);
var
  Connection: TBisIdHttp;
begin
  Connection:=CreateConnection;
  try
    if Assigned(Stream) then
      Connection.Import(ImportType,Stream)
  finally
    Connection.Free;
  end;
end;

procedure TBisHttpConnection.Export(ExportType: TBisConnectionExportType; const Value: String;
                                    Stream: TStream; Params: TBisConnectionExportParams=nil);
var
  Connection: TBisIdHttp;
begin
  Connection:=CreateConnection;
  try
    if Assigned(Stream) then
      Connection.Export(ExportType,Value,Stream,Params);
  finally
    Connection.Free;
  end;
end;

function TBisHttpConnection.GetServerDate: TDateTime;
var
  Connection: TBisIdHttp;
begin
  Connection:=CreateConnection;
  try
    Result:=Connection.GetServerDate;
  finally
    Connection.Free;
  end;
end;

function TBisHttpConnection.Login(const ApplicationId: Variant; const UserName,Password: String; Params: TBisConnectionLoginParams=nil): Variant;
var
  Connection: TBisIdHttp;
begin
  Connection:=CreateConnection;
  try
    Result:=Connection.Login(ApplicationId,UserName,Password,Params);
  finally
    Connection.Free;
  end;
end;

procedure TBisHttpConnection.Logout(const SessionId: Variant);
var
  Connection: TBisIdHttp;
begin
  Connection:=CreateConnection;
  try
    Connection.Logout(SessionId);
  finally
    Connection.Free;
  end;
end;

function TBisHttpConnection.Check(const SessionId: Variant; var ServerDate: TDateTime): Boolean;
var
  Connection: TBisIdHttp;
begin
  Connection:=CreateConnection;
  try
    Result:=Connection.Check(SessionId,ServerDate);
  finally
    Connection.Free;
  end;
end;

procedure TBisHttpConnection.Update(const SessionId: Variant; Params: TBisConfig);
var
  Connection: TBisIdHttp;
begin
  Connection:=CreateConnection;
  try
    if Assigned(Params) then
      Connection.Update(SessionId,Params);
  finally
    Connection.Free;
  end;
end;

procedure TBisHttpConnection.LoadProfile(const SessionId: Variant; Profile: TBisProfile);
var
  Connection: TBisIdHttp;
begin
  Connection:=CreateConnection;
  try
    if Assigned(Profile) then
      Connection.LoadProfile(SessionId,Profile);
  finally
    Connection.Free;
  end;
end;

procedure TBisHttpConnection.SaveProfile(const SessionId: Variant; Profile: TBisProfile);
var
  Connection: TBisIdHttp;
begin
  Connection:=CreateConnection;
  try
    if Assigned(Profile) then
      Connection.SaveProfile(SessionId,Profile);
  finally
    Connection.Free;
  end;
end;

procedure TBisHttpConnection.RefreshPermissions(const SessionId: Variant);
var
  Connection: TBisIdHttp;
begin
  Connection:=CreateConnection;
  try
    Connection.RefreshPermissions(SessionId);
  finally
    Connection.Free;
  end;
end;

procedure TBisHttpConnection.LoadInterfaces(const SessionId: Variant; Interfaces: TBisInterfaces);
var
  Connection: TBisIdHttp;
begin
  Connection:=CreateConnection;
  try
    if Assigned(Interfaces) then
      Connection.LoadInterfaces(SessionId,Interfaces);
  finally
    Connection.Free;
  end;
end;

procedure TBisHttpConnection.GetRecords(const SessionId: Variant; DataSet: TBisDataSet);
var
  Connection: TBisIdHttp;
begin
  Connection:=CreateConnection;
  try
    if Assigned(DataSet) then
      Connection.GetRecords(SessionId,DataSet);
  finally
    Connection.Free;
  end;
end;

procedure TBisHttpConnection.Execute(const SessionId: Variant; DataSet: TBisDataSet);
var
  Connection: TBisIdHttp;
begin
  Connection:=CreateConnection;
  try
    if Assigned(DataSet) then
      Connection.Execute(SessionId,DataSet);
  finally
    Connection.Free;
  end;
end;

procedure TBisHttpConnection.LoadMenus(const SessionId: Variant; Menus: TBisMenus);
var
  Connection: TBisIdHttp;
begin
  Connection:=CreateConnection;
  try
    if Assigned(Menus) then
      Connection.LoadMenus(SessionId,Menus);
  finally
    Connection.Free;
  end;
end;

procedure TBisHttpConnection.LoadTasks(const SessionId: Variant; Tasks: TBisTasks);
var
  Connection: TBisIdHttp;
begin
  Connection:=CreateConnection;
  try
    if Assigned(Tasks) then
      Connection.LoadTasks(SessionId,Tasks);
  finally
    Connection.Free;
  end;
end;

procedure TBisHttpConnection.SaveTask(const SessionId: Variant; Task: TBisTask);
var
  Connection: TBisIdHttp;
begin
  Connection:=CreateConnection;
  try
    if Assigned(Task) then
      Connection.SaveTask(SessionId,Task);
  finally
    Connection.Free;
  end;
end;

procedure TBisHttpConnection.LoadAlarms(const SessionId: Variant; Alarms: TBisAlarms);
var
  Connection: TBisIdHttp;
begin
  Connection:=CreateConnection;
  try
    if Assigned(Alarms) then
      Connection.LoadAlarms(SessionId,Alarms);
  finally
    Connection.Free;
  end;
end;

procedure TBisHttpConnection.LoadScript(const SessionId: Variant; ScriptId: Variant; Stream: TStream);
var
  Connection: TBisIdHttp;
begin
  Connection:=CreateConnection;
  try
    if Assigned(Stream) then
      Connection.LoadScript(SessionId,ScriptId,Stream);
  finally
    Connection.Free;
  end;
end;

procedure TBisHttpConnection.LoadReport(const SessionId: Variant; ReportId: Variant; Stream: TStream);
var
  Connection: TBisIdHttp;
begin
  Connection:=CreateConnection;
  try
    if Assigned(Stream) then
      Connection.LoadReport(SessionId,ReportId,Stream);
  finally
    Connection.Free;
  end;
end;

procedure TBisHttpConnection.LoadDocument(const SessionId: Variant; DocumentId: Variant; Stream: TStream);
var
  Connection: TBisIdHttp;
begin
  Connection:=CreateConnection;
  try
    if Assigned(Stream) then
      Connection.LoadDocument(SessionId,DocumentId,Stream);
  finally
    Connection.Free;
  end;
end;

procedure TBisHttpConnection.Cancel(const SessionId: Variant; DataSetCheckSum: String);
var
  Connection: TBisIdHttp;
begin
  Connection:=CreateConnection;
  try
    Connection.Cancel(SessionId,DataSetCheckSum);
  finally
    Connection.Free;
  end;
end;


end.