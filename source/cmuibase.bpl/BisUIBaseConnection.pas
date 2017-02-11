unit BisUIBaseConnection;

interface                       

uses Windows, Classes, Contnrs, DB, Variants, SyncObjs,
     Forms, Controls, SysUtils,
     uib, uiblib, uibase,
     BisObject, BisConnectionModules, BisCore, BisThreads,
     BisDataSet, BisConfig, BisProfile, BisInterfaces, BisLocks,
     BisParams, BisParam, BisIfaces, BisMenus, BisConnections,
     BisPermissions, BisLogger, BisTasks, BisEvents, BisAlarmsFm;

type
  TBisUIBaseConnection=class;
  TBisUIBaseSessions=class;

  TBisUIBaseQuery=class(TUIBQuery)
  private
    FFetchCount: Integer;
    function GetActive: Boolean;
    function GetIsEmpty: Boolean;
    procedure SetNullToParamValues;
    procedure CopyParamsFrom(Source: TBisParams);
    procedure CopyParamsTo(Source: TBisParams);
    function GetParamsNames: String;
  public
    constructor Create(AOwner: TComponent); override;
    procedure FetchAll;
    function GetQueryText: String;
    procedure CreateTableTo(DataSet: TBisDataSet);
    procedure CopyRecordTo(DataSet: TBisDataSet);
    procedure CopyRecordsTo(DataSet: TBisDataSet);

    property FetchCount: Integer read FFetchCount;
    property Active: Boolean read GetActive;
    property IsEmpty: Boolean read GetIsEmpty;
  end;

  TBisUIBaseTransaction=class(TUIBTransaction)
  private
    FTimeOut: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property TimeOut: Integer read FTimeOut write FTimeOut;
  end;

  TBisUIBaseSession=class;

  TBisUIBaseDatabase=class(TUIBDatabase)
  private
    FLock: TCriticalSection;
    function GetUserName: String;
    procedure SetUserName(Value: String);
    function GetPassword: String;
    procedure SetPassword(Value: String);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CopyFrom(Source: TBisUIBaseDatabase);
    procedure SetSession(Session: TBisUIBaseSession);

    function TryLock: Boolean;
    procedure Lock;
    procedure UnLock;

    property UserName: String read GetUserName write SetUserName;
    property Password: String read GetPassword write SetPassword;

  end;

  TBisUIBaseDatabases=class(TBisLocks)
  private
    function GetItem(Index: Integer): TBisUIBaseDatabase;
  public
    property Items[Index: Integer]: TBisUIBaseDatabase read GetItem; default;
  end;

  TBisUIBaseConnectionClass=class of TBisUIBaseConnection;

  TBisUIBaseTranID=class(TObject)
  private
    FTranID: Cardinal;
    FSessionId: Variant;
    FDataSetCheckSum: String;
    FDatabase: TBisUIBaseDatabase;
  public
    constructor Create;
    destructor Destroy; override;

    property Database: TBisUIBaseDatabase read FDatabase write FDatabase;
    property TranID: Cardinal read FTranID write FTranID;
    property SessionId: Variant read FSessionId write FSessionId;
    property DataSetCheckSum: String read FDataSetCheckSum write FDataSetCheckSum;
  end;

  TBisUIBaseTranIDs=class(TBisLocks)
  private
    function GetItem(Index: Integer): TBisUIBaseTranID;
  public
    function Add(TranID: Cardinal; SessionId: Variant; DataSetCheckSum: String): TBisUIBaseTranID; reintroduce;
    function DatabaseExists(Database: TBisUIBaseDatabase): Boolean;

    property Items[Index: Integer]: TBisUIBaseTranID read GetItem; default;
  end;

  TBisUIBaseSession=class(TBisObject)
  private
    FSessions: TBisUIBaseSessions;
    FSessionId: Variant;
    FConnection: TBisUIBaseConnection;
    FApplicationId: Variant;
    FAccountId: Variant;
    FUserName: String;
    FPassword: String;
    FDateCreate: TDateTime;
    FPermissions: TBisDataSet;
    FRoles: TStringList;
    FLocks: TBisDataSet;
    FIPList: TStringList;
    FParams: TBisConfig;
    FUpdateLock: TBisLock;

    FSSqlInsert: String;
    FSFormatDateTime: String;
    FSSqlUpdate: String;
    FSSqlDelete: String;
    FSSqlLoadPermissions: String;
    FSSqlLoadRoles: String;
    FSSqlLoadLocks: String;
    FSCheckPermissions: String;
    FSSqlLoadProfile: String;
    FSSqlSaveProfile: String;
    FSSqlLoadInterfaces: String;
    FSSqlGetRecords: String;
    FSSqlGetRecordsCount: String;
    FSSqlLoadMenus: String;
    FSSqlLoadScript: String;
    FSSqlLoadReport: String;
    FSSqlLoadDocument: String;
    FSParamPrefix: String;
    FSSessionFormat: String;
    FSInsertStart: String;
    FSInsertSuccess: String;
    FSInsertFail: String;
    FSUpdateStart: String;
    FSUpdateSuccess: String;
    FSUpdateFail: String;
    FSDeleteStart: String;
    FSDeleteFail: String;
    FSDeleteSuccess: String;
    FSLoadProfileFail: String;
    FSLoadProfileSuccess: String;
    FSLoadProfileStart: String;
    FSSaveProfileStart: String;
    FSSaveProfileFail: String;
    FSSaveProfileSuccess: String;
    FSLoadInterfacesSuccess: String;
    FSLoadInterfacesStart: String;
    FSLoadInterfacesFail: String;
    FSGetRecordsSuccess: String;
    FSGetRecordsStart: String;
    FSGetRecordsFail: String;
    FSGetRecordsSql: String;
    FSGetRecordsSqlCount: String;
    FSLoadMenusFail: String;
    FSLoadMenusSuccess: String;
    FSLoadMenusStart: String;
    FSLoadScriptStart: String;
    FSLoadScriptFail: String;
    FSLoadScriptSuccess: String;
    FSLoadScriptSql: String;
    FSLoadReportStart: String;
    FSLoadReportFail: String;
    FSLoadReportSuccess: String;
    FSLoadReportSql: String;
    FSLoadDocumentStart: String;
    FSLoadDocumentFail: String;
    FSLoadDocumentSuccess: String;
    FSLoadDocumentSql: String;
    FSLoadMenusSql: String;
    FSLoadInterfacesSql: String;
    FSSaveProfileSql: String;
    FSLoadProfileSql: String;
    FSDeleteSql: String;
    FSUpdateSql: String;
    FSInsertSql: String;
    FSExecuteStart: String;
    FSExecuteSetParams: String;
    FSExecuteFail: String;
    FSExecuteSuccess: String;
    FSExecuteProvider: String;
    FSExecuteParam: String;
    FSExecutePackageStart: String;
    FSExecutePackageEnd: String;
    FSSqlLoadTasks: String;
    FSLoadTasksStart: String;
    FSLoadTasksSql: String;
    FSLoadTasksFail: String;
    FSLoadTasksSuccess: String;
    FSSqlSaveTask: String;
    FSSaveTaskStart: String;
    FSSaveTaskSql: String;
    FSSaveTaskFail: String;
    FSSaveTaskSuccess: String;
    FSLoadAlarmsFail: String;
    FSLoadAlarmsSuccess: String;
    FSLoadAlarmsStart: String;
    FSLoadAlarmsSql: String;
    FSSqlLoadAlarms: String;
    FSSqlUpdateParams: String;
    FTranTimeOut: Integer;
    FDbPassword: String;
    FDbUserName: String;
    FSCollectionGetRecordsStart: String;
    FSCollectionGetRecordsEnd: String;

    procedure LoggerWrite(const Message: String; LogType: TBisLoggerType=ltInformation);
    procedure CheckPermissions(AObjectName: String; APermissions: TBisPermissions);
    procedure CheckLocks(AMethod: String=''; AObject: String='');
    function GetRoleIds: String;
    procedure CopyData(FromDataSet: TBisUIBaseQuery; ToDataSet: TBisDataSet; AllCount: Integer; TranID: TBisUIBaseTranID);
    function PreparePrefix(AName: String): String;
    procedure SetSessionId(Query: TBisUIBaseQuery);
    procedure LogQueryParams(Query: TBisUIBaseQuery);
    procedure LogParams(Params: TBisParams);
    procedure ExecutePackages(ProviderName: String; Tran: TBisUIBaseTransaction; Package: TBisPackageParams);
    procedure DefaultGetRecords(ProviderName: String; DataSet: TBisDataSet; OpenMode: TBisDataSetOpenMode;
                                Tran: TBisUIBaseTransaction; TranID: TBisUIBaseTranID);
    procedure CollectionGetRecords(ProviderName: String; Collection: TBisDataSetCollection;
                                   Tran: TBisUIBaseTransaction; TranID: TBisUIBaseTranID);
  public
    constructor Create(ASessions: TBisUIBaseSessions); reintroduce; virtual;
    destructor Destroy; override;

    procedure Insert(Database: TBisUIBaseDatabase);
    procedure Update(DataBase: TBisUIBaseDatabase; WithParams: Boolean=false; QueryText: String=''; Duration: Integer=-1);
    procedure Delete(DataBase: TBisUIBaseDatabase);
    procedure LoadPermissions(DataBase: TBisUIBaseDatabase);
    procedure LoadRoles(DataBase: TBisUIBaseDatabase);
    procedure LoadLocks(DataBase: TBisUIBaseDatabase);

    procedure LoadProfile(DataBase: TBisUIBaseDatabase; Profile: TBisProfile); virtual;
    procedure SaveProfile(DataBase: TBisUIBaseDatabase; Profile: TBisProfile); virtual;
    procedure LoadInterfaces(DataBase: TBisUIBaseDatabase; Interfaces: TBisInterfaces); virtual;
    procedure GetRecords(DataBase: TBisUIBaseDatabase; DataSet: TBisDataSet; var QueryText: String); virtual;
    procedure Execute(DataBase: TBisUIBaseDatabase; DataSet: TBisDataSet; var QueryText: String); virtual;
    procedure LoadMenus(DataBase: TBisUIBaseDatabase; Menus: TBisMenus); virtual;
    procedure LoadTasks(DataBase: TBisUIBaseDatabase; Tasks: TBisTasks); virtual;
    procedure SaveTask(DataBase: TBisUIBaseDatabase; Task: TBisTask); virtual;
    procedure LoadAlarms(DataBase: TBisUIBaseDatabase; Alarms: TBisAlarms); virtual;
    procedure LoadScript(DataBase: TBisUIBaseDatabase; ScriptId: Variant; Stream: TStream); virtual;
    procedure LoadReport(DataBase: TBisUIBaseDatabase; ReportId: Variant; Stream: TStream); virtual;
    procedure LoadDocument(DataBase: TBisUIBaseDatabase; DocumentId: Variant; Stream: TStream); virtual;

    property SessionId: Variant read FSessionId write FSessionId;
    property Connection: TBisUIBaseConnection read FConnection write FConnection;
    property ApplicationId: Variant read FApplicationId write FApplicationId;
    property AccountId: Variant read FAccountId write FAccountId;
    property UserName: String read FUserName write FUserName;
    property Password: String read FPassword write FPassword;

    property DbUserName: String read FDbUserName write FDbUserName;
    property DbPassword: String read FDbPassword write FDbPassword;

    property DateCreate: TDateTime read FDateCreate write FDateCreate;
    property TranIdleTimer: Integer read FTranTimeOut write FTranTimeOut;
    property Permissions: TBisDataSet read FPermissions;
    property Roles: TStringList read FRoles;
    property Locks: TBisDataSet read FLocks;
    property IPList: TStringList read FIPList;
    property Params: TBisConfig read FParams;

    property SCheckPermissions: String read FSCheckPermissions write FSCheckPermissions;
    property SFormatDateTime: String read FSFormatDateTime write FSFormatDateTime;
    property SSqlInsert: String read FSSqlInsert write FSSqlInsert;
    property SSqlUpdate: String read FSSqlUpdate write FSSqlUpdate;
    property SSqlUpdateParams: String read FSSqlUpdateParams write FSSqlUpdateParams;
    property SSqlDelete: String read FSSqlDelete write FSSqlDelete;
    property SSqlLoadPermissions: String read FSSqlLoadPermissions write FSSqlLoadPermissions;
    property SSqlLoadRoles: String read FSSqlLoadRoles write FSSqlLoadRoles;
    property SSqlLoadLocks: String read FSSqlLoadLocks write FSSqlLoadLocks;
    property SSqlLoadProfile: String read FSSqlLoadProfile write FSSqlLoadProfile;
    property SSqlSaveProfile: String read FSSqlSaveProfile write FSSqlSaveProfile;
    property SSqlLoadInterfaces: String read FSSqlLoadInterfaces write FSSqlLoadInterfaces;
    property SSqlGetRecords: String read FSSqlGetRecords write FSSqlGetRecords;
    property SSqlGetRecordsCount: String read FSSqlGetRecordsCount write FSSqlGetRecordsCount;
    property SSqlLoadMenus: String read FSSqlLoadMenus write FSSqlLoadMenus;
    property SSqlLoadTasks: String read FSSqlLoadTasks write FSSqlLoadTasks;
    property SSqlSaveTask: String read FSSqlSaveTask write FSSqlSaveTask;
    property SSqlLoadAlarms: String read FSSqlLoadAlarms write FSSqlLoadAlarms;
    property SSqlLoadScript: String read FSSqlLoadScript write FSSqlLoadScript;
    property SSqlLoadReport: String read FSSqlLoadReport write FSSqlLoadReport;
    property SSqlLoadDocument: String read FSSqlLoadDocument write FSSqlLoadDocument;
    property SParamPrefix: String read FSParamPrefix write FSParamPrefix;
  published
    property SSessionFormat: String read FSSessionFormat write FSSessionFormat;

    property SInsertStart: String read FSInsertStart write FSInsertStart;
    property SInsertSql: String read FSInsertSql write FSInsertSql;
    property SInsertSuccess: String read FSInsertSuccess write FSInsertSuccess;
    property SInsertFail: String read FSInsertFail write FSInsertFail;

    property SUpdateStart: String read FSUpdateStart write FSUpdateStart;
    property SUpdateSql: String read FSUpdateSql write FSUpdateSql;
    property SUpdateSuccess: String read FSUpdateSuccess write FSUpdateSuccess;
    property SUpdateFail: String read FSUpdateFail write FSUpdateFail;

    property SDeleteStart: String read FSDeleteStart write FSDeleteStart;
    property SDeleteSql: String read FSDeleteSql write FSDeleteSql;
    property SDeleteSuccess: String read FSDeleteSuccess write FSDeleteSuccess;
    property SDeleteFail: String read FSDeleteFail write FSDeleteFail;

    property SLoadProfileStart: String read FSLoadProfileStart write FSLoadProfileStart;
    property SLoadProfileSql: String read FSLoadProfileSql write FSLoadProfileSql;
    property SLoadProfileSuccess: String read FSLoadProfileSuccess write FSLoadProfileSuccess;
    property SLoadProfileFail: String read FSLoadProfileFail write FSLoadProfileFail;

    property SSaveProfileStart: String read FSSaveProfileStart write FSSaveProfileStart;
    property SSaveProfileSql: String read FSSaveProfileSql write FSSaveProfileSql;
    property SSaveProfileSuccess: String read FSSaveProfileSuccess write FSSaveProfileSuccess;
    property SSaveProfileFail: String read FSSaveProfileFail write FSSaveProfileFail;

    property SLoadInterfacesStart: String read FSLoadInterfacesStart write FSLoadInterfacesStart;
    property SLoadInterfacesSql: String read FSLoadInterfacesSql write FSLoadInterfacesSql;
    property SLoadInterfacesSuccess: String read FSLoadInterfacesSuccess write FSLoadInterfacesSuccess;
    property SLoadInterfacesFail: String read FSLoadInterfacesFail write FSLoadInterfacesFail;

    property SGetRecordsStart: String read FSGetRecordsStart write FSGetRecordsStart;
    property SGetRecordsSql: String read FSGetRecordsSql write FSGetRecordsSql;
    property SGetRecordsSqlCount: String read FSGetRecordsSqlCount write FSGetRecordsSqlCount;
    property SGetRecordsSuccess: String read FSGetRecordsSuccess write FSGetRecordsSuccess;
    property SGetRecordsFail: String read FSGetRecordsFail write FSGetRecordsFail;

    property SCollectionGetRecordsStart: String read FSCollectionGetRecordsStart write FSCollectionGetRecordsStart;
    property SCollectionGetRecordsEnd: String read FSCollectionGetRecordsEnd write FSCollectionGetRecordsEnd;

    property SExecuteStart: String read FSExecuteStart write FSExecuteStart;
    property SExecuteSetParams: String read FSExecuteSetParams write FSExecuteSetParams;
    property SExecuteProvider: String read FSExecuteProvider write FSExecuteProvider;
    property SExecuteParam: String read FSExecuteParam write FSExecuteParam;
    property SExecutePackageStart: String read FSExecutePackageStart write FSExecutePackageStart;
    property SExecutePackageEnd: String read FSExecutePackageEnd write FSExecutePackageEnd;
    property SExecuteSuccess: String read FSExecuteSuccess write FSExecuteSuccess;
    property SExecuteFail: String read FSExecuteFail write FSExecuteFail;

    property SLoadMenusStart: String read FSLoadMenusStart write FSLoadMenusStart;
    property SLoadMenusSql: String read FSLoadMenusSql write FSLoadMenusSql;
    property SLoadMenusSuccess: String read FSLoadMenusSuccess write FSLoadMenusSuccess;
    property SLoadMenusFail: String read FSLoadMenusFail write FSLoadMenusFail;

    property SLoadTasksStart: String read FSLoadTasksStart write FSLoadTasksStart;
    property SLoadTasksSql: String read FSLoadTasksSql write FSLoadTasksSql;
    property SLoadTasksSuccess: String read FSLoadTasksSuccess write FSLoadTasksSuccess;
    property SLoadTasksFail: String read FSLoadTasksFail write FSLoadTasksFail;

    property SSaveTaskStart: String read FSSaveTaskStart write FSSaveTaskStart;
    property SSaveTaskSql: String read FSSaveTaskSql write FSSaveTaskSql;
    property SSaveTaskSuccess: String read FSSaveTaskSuccess write FSSaveTaskSuccess;
    property SSaveTaskFail: String read FSSaveTaskFail write FSSaveTaskFail;

    property SLoadAlarmsStart: String read FSLoadAlarmsStart write FSLoadAlarmsStart;
    property SLoadAlarmsSql: String read FSLoadAlarmsSql write FSLoadAlarmsSql;
    property SLoadAlarmsSuccess: String read FSLoadAlarmsSuccess write FSLoadAlarmsSuccess;
    property SLoadAlarmsFail: String read FSLoadAlarmsFail write FSLoadAlarmsFail;

    property SLoadScriptStart: String read FSLoadScriptStart write FSLoadScriptStart;
    property SLoadScriptSql: String read FSLoadScriptSql write FSLoadScriptSql;
    property SLoadScriptSuccess: String read FSLoadScriptSuccess write FSLoadScriptSuccess;
    property SLoadScriptFail: String read FSLoadScriptFail write FSLoadScriptFail;

    property SLoadReportStart: String read FSLoadReportStart write FSLoadReportStart;
    property SLoadReportSql: String read FSLoadReportSql write FSLoadReportSql;
    property SLoadReportSuccess: String read FSLoadReportSuccess write FSLoadReportSuccess;
    property SLoadReportFail: String read FSLoadReportFail write FSLoadReportFail;

    property SLoadDocumentStart: String read FSLoadDocumentStart write FSLoadDocumentStart;
    property SLoadDocumentSql: String read FSLoadDocumentSql write FSLoadDocumentSql;
    property SLoadDocumentSuccess: String read FSLoadDocumentSuccess write FSLoadDocumentSuccess;
    property SLoadDocumentFail: String read FSLoadDocumentFail write FSLoadDocumentFail;

  end;

  TBisUIBaseSessionClass=class of TBisUIBaseSession;

  TBisUIBaseSessions=class(TBisLocks)
  private
    FConnection: TBisUIBaseConnection;
    FSFormatSchemaName: String;
    function GetItems(Index: Integer): TBisUIBaseSession;
  protected
    function GetSessionClass: TBisUIBaseSessionClass; virtual;
  public
    constructor Create(AConnection: TBisUIBaseConnection); reintroduce; 
    destructor Destroy; override;

    function Add(Database: TBisUIBaseDatabase; SessionId: Variant; DateCreate: TDateTime;
                 ApplicationId, AccountId: Variant; UserName, Password: String;
                 DbUserName, DbPassword: String; SessionParams, IPList: String): TBisUIBaseSession; reintroduce;
    function Find(SessionId: Variant): TBisUIBaseSession;
    procedure CopyFrom(Source: TBisUIBaseSessions; IsClear: Boolean);
    procedure Remove(Session: TBisUIBaseSession; WithLock: Boolean);

    property Items[Index: Integer]: TBisUIBaseSession read GetItems;

    property SFormatSchemaName: String read FSFormatSchemaName write FSFormatSchemaName;
  end;

  TBisUIBaseSessionsClass=class of TBisUIBaseSessions;

  TBisUIBaseConnection=class(TBisConnection)
  private
    FDatabases: TBisUIBaseDatabases;
    FSessions: TBisUIBaseSessions;
    FTranIDs: TBisUIBaseTranIDs;
    FThreads: TBisThreads;

//    FWorking: Boolean;
    FDatabaseName: String;
    FUserName: String;
    FPassword: String;
    FCharacterSet: TCharacterSet;
    FSQLDialect: Integer;
    FPrefix: String;
    FSweepTimeout: Integer;
    FConnected: Boolean;

    FSSqlGetDbUserName: String;
    FSSqlApplicationExists: String;
    FSSqlSessionExists: String;
    FSSqlGetServerDate: String;
    FSFieldNameQuote: String;
    FSFormatDateTimeValue: String;
    FSFormatDateValue: String;
    FSSqlInsert: String;
    FSFormatFilterDateValue: String;
    FSImportScriptSuccess: String;
    FSImportScriptStart: String;
    FSImportScriptSql: String;
    FSImportScriptFail: String;
    FSImportTableStart: String;
    FSImportTableSql: String;
    FSImportTableFail: String;
    FSImportTableSuccess: String;
    FSImportTableParam: String;
    FSSqlUpdate: String;
    FSSQLGetKeys: String;
    FSImportTableEmpty: String;
    FSSqlSessions: String;
    FCheckVersion: Boolean;
    FMaxRecordCount: Integer;
    FTimeOut: Integer;
    FSSqlDeleteStatements: String;
    FSDeleteStatementsSql: String;

    procedure ThreadsItemRemove(Sender: TBisThreads; Item: TBisThread);
    procedure ThreadTimeout(Thread: TBisWaitThread);
    procedure ThreadDestroy(Thread: TBisThread);
//    procedure ThreadEnd(Thread: TBisThread; const AException: Exception);

    procedure DatabaseConnectionLost(Sender: TObject);

    function GetDbUserName(Database: TBisUIBaseDatabase;
                           UserName, Password: String; var AccountId, FirmId, FirmSmallName: Variant;
                           var DbUserName, DbPassword: String): Boolean;
    function ApplicationExists(Database: TBisUIBaseDatabase; ApplicationId,AccountId: Variant; Version: String): Boolean;
    procedure DeleteStatements(Database: TBisUIBaseDatabase; SessionId: Variant; DataSetCheckSum: String);
    procedure DeleteAllStatements;
    function GetSessionIDs: String;
    procedure CheckSessions(Database: TBisUIBaseDatabase); reintroduce; overload;
    function SessionExists(Database: TBisUIBaseDatabase; SessionId: Variant): Boolean; reintroduce; overload;
    function SessionFind(Database: TBisUIBaseDatabase; SessionId: Variant): TBisUIBaseSession;
    function GetTableName(SQL: String; var Where: String): String;
    procedure ImportScript(Database: TBisUIBaseDatabase; Stream: TStream);
    procedure ImportTable(Database: TBisUIBaseDatabase; Stream: TStream);
    procedure ExportScript(Database: TBisUIBaseDatabase; const Value: String; Stream: TStream; Params: TBisConnectionExportParams=nil);
    procedure ExportTable(Database: TBisUIBaseDatabase; const Value: String; Stream: TStream; Params: TBisConnectionExportParams=nil);
    procedure ChangeParams(Sender: TObject);
    function PreparePrefix(AName: String): String;
    function GetInternalServerDate(Database: TBisUIBaseDatabase): TDateTime;
  protected
    function GetFieldNameQuote: String; override;
    function GetRecordsFilterDateValue(Value: TDateTime): String; override;
    function GetConnected: Boolean; override;
//    function GetWorking: Boolean; override;
    function GetSessionCount: Integer; override;

    function GetSessionsClass: TBisUIBaseSessionsClass; virtual;
    property Sessions: TBisUIBaseSessions read FSessions;
    property Prefix: String read FPrefix;
    property Timeout: Integer read FTimeOut;
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

//    function CloneConnection(const SessionId: Variant; WithDefault: Boolean=true): TBisConnection; override;
//    procedure RemoveConnection(Connection: TBisConnection; const SessionId: Variant; IsLogout: Boolean); override;
    procedure CheckSessions; overload; override;
    function SessionExists(const SessionId: Variant): Boolean; overload; override; 

    function CreateDatabase: TBisUIBaseDatabase;
    procedure FreeDatabase(Database: TBisUIBaseDatabase; Threaded: Boolean=true);

    function CreateTranID(Database: TBisUIBaseDatabase; Tran: TBisUIBaseTransaction;
                          SessionId: Variant; DataSet: TBisDataSet): TBisUIBaseTranID;
    procedure FreeTranID(TranID: TBisUIBaseTranID);
    function TranIDExists(TranID: TBisUIBaseTranID): Boolean;

    property SSqlGetDbUserName: String read FSSqlGetDbUserName write FSSqlGetDbUserName;
    property SSqlApplicationExists: String read FSSqlApplicationExists write FSSqlApplicationExists;
    property SSqlDeleteStatements: String read FSSqlDeleteStatements write FSSqlDeleteStatements;
    property SSqlSessionExists: String read FSSqlSessionExists write FSSqlSessionExists;
    property SSqlSessions: String read FSSqlSessions write FSSqlSessions;
    property SSqlGetServerDate: String read FSSqlGetServerDate write FSSqlGetServerDate;
    property SFieldNameQuote: String read FSFieldNameQuote write FSFieldNameQuote;
    property SFormatDateTimeValue: String read FSFormatDateTimeValue write FSFormatDateTimeValue;
    property SSqlInsert: String read FSSqlInsert write FSSqlInsert;
    property SSqlUpdate: String read FSSqlUpdate write FSSqlUpdate;
    property SSQLGetKeys: String read FSSQLGetKeys write FSSQLGetKeys;
    property SFormatFilterDateValue: String read FSFormatFilterDateValue write FSFormatFilterDateValue;
  published

    property SImportScriptStart: String read FSImportScriptStart write FSImportScriptStart;
    property SImportScriptSql: String read FSImportScriptSql write FSImportScriptSql;
    property SImportScriptSuccess: String read FSImportScriptSuccess write FSImportScriptSuccess;
    property SImportScriptFail: String read FSImportScriptFail write FSImportScriptFail;

    property SImportTableStart: String read FSImportTableStart write FSImportTableStart;
    property SImportTableSql: String read FSImportTableSql write FSImportTableSql;
    property SImportTableSuccess: String read FSImportTableSuccess write FSImportTableSuccess;
    property SImportTableEmpty: String read FSImportTableEmpty write FSImportTableEmpty;
    property SImportTableFail: String read FSImportTableFail write FSImportTableFail;
    property SImportTableParam: String read FSImportTableParam write FSImportTableParam;

    property SDeleteStatementsSql: String read FSDeleteStatementsSql write FSDeleteStatementsSql;
  end;


procedure InitConnectionModule(AModule: TBisConnectionModule); stdcall;

exports
  InitConnectionModule;

implementation

uses DateUtils, ActiveX, FMtBcd, TypInfo, StrUtils,
     BisUtils, BisExceptions, BisNetUtils, BisCryptUtils,
     BisConsts, BisCoreUtils, BisFilterGroups,
     BisUIBaseConsts;


procedure InitConnectionModule(AModule: TBisConnectionModule); stdcall;
begin
  AModule.ConnectionClass:=TBisUIBaseConnection;
end;

{ TBisUIBaseQuery }

constructor TBisUIBaseQuery.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FetchBlobs:=true;
end;

procedure TBisUIBaseQuery.CreateTableTo(DataSet: TBisDataSet);
var
  SqlType: Smallint;

  function GetPrecision: Integer;
  begin
    case SqlType and not 1 of
      SQL_SHORT:
        Result:=4;
      SQL_LONG:
        Result:=9;
      SQL_INT64:
        Result:=18;
      else
        Result:=0;
    end;
  end;

var
  i: Word;
  Def: TFieldDef;
  FieldType: TUIBFieldType;
  DataType: TFieldType;
  SqlScale: Smallint;
  Size: Integer;
  Precision: Integer;
begin
  if Assigned(DataSet) then begin
    DataSet.Close;
    DataSet.Fields.Clear;
    DataSet.FieldDefs.Clear;
    for i:=0 to Fields.FieldCount-1 do begin
      Def:=DataSet.FieldDefs.AddFieldDef;
      Def.Name:=Fields.SqlName[i];
      FieldType:=Fields.FieldType[i];
      SqlType:=Fields.SQLType[i];
      SqlScale:=Fields.SQLScale[i];
      DataType:=ftUnknown;
      Size:=0;
      Precision:=GetPrecision;
      case FieldType of
        uftUnKnown: ;
        uftFloat, uftDoublePrecision: DataType:=ftFloat;
        uftNumeric: begin
          if SqlType=SQL_SHORT then begin
            if (SqlScale = 0) then
              DataType:=ftSmallInt
            else begin
              DataType:=ftBCD;
              Size:=-SqlScale;
              if Precision = Size then
                Inc(Precision);
            end;
          end else if SqlType=SQL_LONG then begin
            if (SqlScale = 0) then
              DataType:=ftInteger
            else if (SqlScale >= (-4)) then begin
              DataType:=ftBCD;
              Size:=-SqlScale;
              if Precision=Size then
                Inc(Precision);
            end else if Database.SQLDialect = 1 then
              DataType:=ftFloat
            else begin
              DataType:=ftFMTBCD;
              Size:=-SqlScale;
              if Precision=Size then
                Inc(Precision);
            end;
          end else if SqlType=SQL_INT64 then begin
            if (SqlScale = 0) then
              DataType:=ftLargeInt
            else if (SqlScale >= (-4)) then begin
              DataType:=ftBCD;
              Size:=-SqlScale;
            end else begin
              DataType:=ftFMTBCD;
              Size:=-SqlScale;
              if Precision=Size then
                 Inc(Precision);
            end;
          end;
        end;
        uftChar, uftVarchar, uftCstring: begin
          DataType:=ftString;
          Size:=Fields.SQLLen[i];
        end;
        uftSmallint: DataType:=ftSmallint;
        uftInteger: DataType:=ftInteger;
        uftQuad: ;
        uftTimestamp: DataType:=ftDateTime;
        uftBlob: begin
          if Fields.IsBlobText[i] then
            DataType:=ftMemo
          else
            DataType:=ftBlob;
        end;
        uftBlobId: ;
        uftDate: DataType:=ftDate;
        uftTime: DataType:=ftTime;
        uftInt64: DataType:=ftLargeint;
        uftArray: DataType:=ftArray;
      end;
      if DataType<>ftUnknown then begin
        Def.DataType:=DataType;
        Def.Size:=Size;
        Def.Precision:=Precision;
        Def.Required:=false;
      end;
    end;
    DataSet.InitCalcFieldDefs;
    DataSet.CreateTable(nil);
  end;
end;

procedure TBisUIBaseQuery.CopyRecordTo(DataSet: TBisDataSet);
var
  i: Word;
  Field: TField;
  AValue: Variant;
  Stream: TMemoryStream;
begin
  DataSet.Append;
  try
    for i:=0 to Fields.FieldCount-1 do begin
      Field:=DataSet.Fields.FindField(Fields.SqlName[i]);
      if Assigned(Field) then begin
        if not Fields.IsBlob[i] then begin
          AValue:=Fields.AsVariant[i];
          if not VarIsNull(AValue) then begin
            Field.Clear;
            Field.Value:=AValue;
          end else begin
            Field.Value:=Null;
          end;
        end else begin
          Stream:=TMemoryStream.Create;
          try
            Fields.ReadBlob(i,Stream);
            Stream.Position:=0;
            TBlobField(Field).LoadFromStream(Stream);
          finally
            Stream.Free;
          end;
        end;
      end;
    end;
  finally
    DataSet.Post;
  end;
end;

procedure TBisUIBaseQuery.CopyParamsFrom(Source: TBisParams);
var
  Item: TBisParam;

  procedure SetToParam(ParamName: String; Value: Variant);
  var
    Index: Word;
    S: String;
  begin
    if Params.TryGetFieldIndex(ParamName,Index) then begin
      if Item.ParamType in [ptInput,ptInputOutput] then begin
        if not Params.IsBlob[Index] then begin
          Params.AsVariant[Index]:=Value;
          Params.IsNull[Index]:=VarIsNull(Value);
        end else begin
          S:=VarToStrDef(Value,'');
          if Trim(S)='' then
            Params.IsNull[Index]:=true
          else
            ParamsSetBlob(Index,S);
        end;  
      end;
    end;
  end;

var
  i,j: Integer;
begin
  if Assigned(Source) then begin
    for i:=0 to Source.Count-1 do begin
      Item:=Source.Items[i];
      SetToParam(Item.ParamName,Item.Value);
      for j:=0 to Item.Olders.Count-1 do begin
        SetToParam(Item.Olders.Strings[j],Item.OldValue);
      end;
    end;
  end;
end;

procedure TBisUIBaseQuery.CopyParamsTo(Source: TBisParams);
var
  Item: TBisParam;

  procedure GetFromParam;
  var
    Index: Word;
    Stream: TMemoryStream;
  begin
    if Fields.TryGetFieldIndex(Item.ParamName,Index) then begin
      if Item.ParamType in [ptOutput,ptInputOutput] then begin
        if not Fields.IsBlob[Index] then
          Item.Value:=Fields.AsVariant[Index]
        else begin
          // blob is not support by we need this
          Stream:=TMemoryStream.Create;
          try
            Fields.ReadBlob(Index,Stream);
            Stream.Position:=0;
            Item.LoadFromStream(Stream);
          finally
            Stream.Free;
          end;
        end;
      end;
    end;
  end;

var
  i: Integer;
begin
  if Assigned(Source) then begin
    for i:=0 to Source.Count-1 do begin
      Item:=Source.Items[i];
      GetFromParam;
    end;
  end;
end;

procedure TBisUIBaseQuery.CopyRecordsTo(DataSet: TBisDataSet);
begin
 if Assigned(DataSet) then begin
    if Active then begin
      First;
      while not Eof do begin
        CopyRecordTo(DataSet);
        Next;
      end;
    end;
  end;
end;

procedure TBisUIBaseQuery.FetchAll;
begin
  FFetchCount:=0;
  First;
  while not Eof do begin
    Inc(FFetchCount);
    Next;
  end;
  First;
end;

function TBisUIBaseQuery.GetActive: Boolean;
begin
  Result:=(CursorName<>'') and (CurrentState=qsExecute);
end;

function TBisUIBaseQuery.GetIsEmpty: Boolean;
begin
  Result:=Fields.RecordCount=0;
end;

function TBisUIBaseQuery.GetParamsNames: String;
var
  i: Integer;
  S: String;
begin
  Result:='';
  for i:=0 to Params.ParamCount-1 do begin
    S:=':'+Params.FieldName[i];
    Result:=iff(Result='',S,Result+','+S);
  end;
  if Result<>'' then
    Result:='('+Result+')';
end;

function TBisUIBaseQuery.GetQueryText: String;
var
  Str: TStringList;
  i: Integer;
  S: String;
  V: String;
begin
  Str:=TStringList.Create;
  try
    Str.Text:=Trim(SQL.Text);
    for i:=Params.ParamCount-1 downto 0 do begin
      if Params.IsNull[i] then
        V:=SNull
      else begin
        if not Params.IsBlob[i] then
          V:=Params.AsString[i]
        else begin
          V:=''; // can I get blob without error?
        end;  
      end;
      S:=FormatEx('%s=%s',[Params.FieldName[i],V]);
      Str.Add(S);
    end;
    Result:=Trim(Str.Text);
  finally
    Str.Free;
  end;
end;

procedure TBisUIBaseQuery.SetNullToParamValues;
var
  i: Integer;
begin
  for i:=Params.FieldCount-1 downto 0 do begin
    if Trim(Params.FieldName[i])<>'' then begin
      Params.IsNull[i]:=true;
    end;
  end;
end;

{ TBisUIBaseTransaction }

constructor TBisUIBaseTransaction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  DefaultAction:=etmRollback;
  Options:=[tpRead,tpReadCommitted,tpRecVersion];
end;

destructor TBisUIBaseTransaction.Destroy;
begin
  inherited Destroy;
end;

{ TBisUIBaseDatabase }

constructor TBisUIBaseDatabase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLock:=TCriticalSection.Create;
end;

destructor TBisUIBaseDatabase.Destroy;
begin
  FLock.Free;
  inherited Destroy;
end;

function TBisUIBaseDatabase.GetUserName: String;
begin
  Result:=Params.Values[SDBParamUserName];
end;

procedure TBisUIBaseDatabase.SetUserName(Value: String);
begin
  Params.Values[SDBParamUserName]:=Value;
end;

function TBisUIBaseDatabase.GetPassword: String;
begin
  Result:=Params.Values[SDBParamPassword];
end;

procedure TBisUIBaseDatabase.SetPassword(Value: String);
begin
  Params.Values[SDBParamPassword]:=Value;
end;

procedure TBisUIBaseDatabase.SetSession(Session: TBisUIBaseSession);
var
  OldConnected: Boolean;
begin
  if Assigned(Session) then begin
    if not AnsiSameText(UserName,Session.DbUserName) or
       not AnsiSameText(Password,Session.DbPassword) then begin
      OldConnected:=Connected;
      try
        Connected:=false;
        UserName:=Session.DbUserName;
        Password:=Session.DbPassword;
      finally
        Connected:=OldConnected;
      end;
    end;
  end;
end;

procedure TBisUIBaseDatabase.CopyFrom(Source: TBisUIBaseDatabase);
var
  ASource: TBisUIBaseDatabase;
begin
  if Source is TBisUIBaseDatabase then begin
    ASource:=TBisUIBaseDatabase(Source);
    Self.DatabaseName:=ASource.DatabaseName;
    Self.UserName:=ASource.UserName;
    Self.Password:=ASource.Password;
    Self.CharacterSet:=ASource.CharacterSet;
    Self.SQLDialect:=ASource.SQLDialect;
    Self.Params.Text:=ASource.Params.Text;
  end;
end;

function TBisUIBaseDatabase.TryLock: Boolean;
begin
  Result:=FLock.TryEnter;
end;

procedure TBisUIBaseDatabase.Lock;
begin
  FLock.Enter;
end;

procedure TBisUIBaseDatabase.UnLock;
begin
  FLock.Leave;
end;

{ TBisUIBaseDatabases }

function TBisUIBaseDatabases.GetItem(Index: Integer): TBisUIBaseDatabase;
begin
  Result:=TBisUIBaseDatabase(inherited Items[Index]);
end;

{ TBisUIBaseSession }

constructor TBisUIBaseSession.Create(ASessions: TBisUIBaseSessions);
begin
  inherited Create(nil);
//  FLock:=TCriticalSection.Create;

  FSessions:=ASessions;
//  FTransaction:=TBisUIBaseTransaction.Create(nil);

  FUpdateLock:=TBisLock.Create;
  FUpdateLock.MaxTimeout:=0;

  FPermissions:=TBisDataSet.Create(nil);
  FRoles:=TStringList.Create;
  FLocks:=TBisDataSet.Create(nil);
  FIPList:=TStringList.Create;
  FParams:=TBisConfig.Create(nil);

  FSSessionFormat:='%s: %s';

  FSInsertStart:='������ �������� ������ ...';
  FSInsertSql:='������ �������� ������ => %s';
  FSInsertSuccess:='������ ������� �������.';
  FSInsertFail:='������ �� �������. %s';

  FSUpdateStart:='������ ���������� ������ ...';
  FSUpdateSql:='������ ���������� ������ => %s';
  FSUpdateSuccess:='������ ��������� �������.';
  FSUpdateFail:='������ �� ���������. %s';

  FSDeleteStart:='������ �������� ������ ...';
  FSDeleteSql:='������ �������� ������ => %s';
  FSDeleteSuccess:='������ ������� �������.';
  FSDeleteFail:='������ �� �������. %s';

  FSLoadProfileStart:='������ �������� ������� ...';
  FSLoadProfileSql:='������ �������� ������� => %s';
  FSLoadProfileSuccess:='������� �������� �������.';
  FSLoadProfileFail:='������� �� ��������. %s';

  FSSaveProfileStart:='������ ���������� ������� ...';
  FSSaveProfileSql:='������ ���������� ������� => %s';
  FSSaveProfileSuccess:='������� �������� �������.';
  FSSaveProfileFail:='������� �� ��������. %s';

  FSLoadInterfacesStart:='������ �������� ����������� ...';
  FSLoadInterfacesSql:='������ �������� ����������� => %s';
  FSLoadInterfacesSuccess:='���������� ��������� �������.';
  FSLoadInterfacesFail:='���������� �� ���������. %s';

  FSGetRecordsStart:='������ ��������� ������� ...';
  FSGetRecordsSql:='������ ��������� ������� => %s';
  FSGetRecordsSqlCount:='������ ���������� ������� => %s';
  FSGetRecordsSuccess:='������ �������� �������.';
  FSGetRecordsFail:='������ �� ��������. %s';

  FSCollectionGetRecordsStart:='������ ��������� ��������� ...';
  FSCollectionGetRecordsEnd:='��������� ��������� ��������� ...';

  FSExecuteStart:='������ ���������� ��������� ...';
  FSExecuteSetParams:='��������� ������. ������ ��������� ...';
  FSExecuteProvider:='��� ��������� => %s';
  FSExecuteParam:='�������� => %s ��� ��������� => %s ��� ������ => %s �������� => %s';
  FSExecutePackageStart:='������ ���������� ������ ...';
  FSExecutePackageEnd:='��������� ���������� ������ ...';
  FSExecuteSuccess:='��������� ��������� �������.';
  FSExecuteFail:='��������� �� ���������. %s';

  FSLoadMenusStart:='������ �������� ���� ...';
  FSLoadMenusSql:='������ �������� ���� => %s';
  FSLoadMenusSuccess:='���� ��������� �������.';
  FSLoadMenusFail:='���� �� ���������. %s';

  FSLoadTasksStart:='������ �������� ������� ...';
  FSLoadTasksSql:='������ �������� ������� => %s';
  FSLoadTasksSuccess:='������� ��������� �������.';
  FSLoadTasksFail:='������� �� ���������. %s';

  FSSaveTaskStart:='������ ���������� ������� ...';
  FSSaveTaskSql:='������ ���������� ������� => %s';
  FSSaveTaskSuccess:='������� ��������� �������.';
  FSSaveTaskFail:='������� �� ���������. %s';

  FSLoadAlarmsStart:='������ �������� ���������� ...';
  FSLoadAlarmsSql:='������ �������� ���������� => %s';
  FSLoadAlarmsSuccess:='���������� ��������� �������.';
  FSLoadAlarmsFail:='��������� �� ���������. %s';

  FSLoadScriptStart:='������ �������� ������� ...';
  FSLoadScriptSql:='������ �������� ������� => %s';
  FSLoadScriptSuccess:='������ �������� �������.';
  FSLoadScriptFail:='������ �� ��������. %s';

  FSLoadReportStart:='������ �������� ������ ...';
  FSLoadReportSql:='������ �������� ������ => %s';
  FSLoadReportSuccess:='����� �������� �������.';
  FSLoadReportFail:='����� �� ��������. %s';

  FSLoadDocumentStart:='������ �������� ��������� ...';
  FSLoadDocumentSql:='������ �������� ��������� => %s';
  FSLoadDocumentSuccess:='�������� �������� �������.';
  FSLoadDocumentFail:='�������� �� ��������. %s';

  FSCheckPermissions:='NAME=%s';
  FSFormatDateTime:='yyyy-mm-dd hh:nn:ss';  // English
  FSSqlInsert:='INSERT INTO /*PREFIX*/SESSIONS (SESSION_ID,APPLICATION_ID,ACCOUNT_ID,DATE_CREATE,DATE_CHANGE,PARAMS) '+
               'VALUES (%s,%s,%s,%s,CURRENT_TIMESTAMP,:PARAMS)';
  FSSqlUpdate:='UPDATE /*PREFIX*/SESSIONS SET DATE_CHANGE=CURRENT_TIMESTAMP, QUERY_TEXT=:QUERY_TEXT, DURATION=:DURATION '+
               'WHERE SESSION_ID=%s';
  FSSqlUpdateParams:='UPDATE /*PREFIX*/SESSIONS SET DATE_CHANGE=CURRENT_TIMESTAMP, PARAMS=:PARAMS, '+
                     'QUERY_TEXT=:QUERY_TEXT, DURATION=:DURATION '+
                     'WHERE SESSION_ID=%s ';
  FSSqlDelete:='DELETE FROM /*PREFIX*/SESSIONS WHERE SESSION_ID=%s';
  FSSqlLoadPermissions:='SELECT P.INTERFACE_ID, I.NAME, P.RIGHT_ACCESS, P."VALUE" '+
                        'FROM /*PREFIX*/PERMISSIONS P JOIN /*PREFIX*/INTERFACES I ON I.INTERFACE_ID=P.INTERFACE_ID '+
                        'WHERE P.ACCOUNT_ID IN (%s)';
  FSSqlLoadLocks:='SELECT METHOD, OBJECT, DESCRIPTION, IP_LIST FROM /*PREFIX*/LOCKS '+
                  'WHERE ((DATE_BEGIN<=%s AND DATE_END IS NULL) OR (DATE_BEGIN<=%s AND DATE_END>=%s)) '+
                  'AND APPLICATION_ID=%s AND (ACCOUNT_ID IN (%s) OR ACCOUNT_ID IS NULL) '+
                  'ORDER BY DATE_BEGIN';
  FSSqlLoadRoles:='SELECT ROLE_ID FROM /*PREFIX*/ACCOUNT_ROLES WHERE ACCOUNT_ID=%s';
  FSSqlLoadProfile:='SELECT P.PROFILE FROM /*PREFIX*/PROFILES P WHERE P.APPLICATION_ID=%s AND P.ACCOUNT_ID=%s';
  FSSqlSaveProfile:='UPDATE /*PREFIX*/PROFILES SET PROFILE=:PROFILE WHERE APPLICATION_ID=%s AND ACCOUNT_ID=%s';
  FSSqlLoadInterfaces:='SELECT AI.INTERFACE_ID, AI.PRIORITY, AI.AUTO_RUN, I.NAME, I.DESCRIPTION, '+
                       'I."MODULE_NAME", I.MODULE_INTERFACE, I.INTERFACE_TYPE, '+
                       'S.SCRIPT_ID, S.ENGINE AS SCRIPT_ENGINE, S.PLACE AS SCRIPT_PLACE, '+
                       'R.REPORT_ID, R.ENGINE AS REPORT_ENGINE, R.PLACE AS REPORT_PLACE, '+
                       'D.DOCUMENT_ID, D.OLE_CLASS AS DOCUMENT_OLE_CLASS, D.PLACE AS DOCUMENT_PLACE '+
                       'FROM /*PREFIX*/APPLICATION_INTERFACES AI '+
                       'JOIN /*PREFIX*/INTERFACES I ON I.INTERFACE_ID=AI.INTERFACE_ID '+
                       'LEFT JOIN /*PREFIX*/SCRIPTS S ON S.SCRIPT_ID=AI.INTERFACE_ID '+
                       'LEFT JOIN /*PREFIX*/REPORTS R ON R.REPORT_ID=AI.INTERFACE_ID '+
                       'LEFT JOIN /*PREFIX*/DOCUMENTS D ON D.DOCUMENT_ID=AI.INTERFACE_ID '+
                       'WHERE AI.APPLICATION_ID=%s AND AI.ACCOUNT_ID IN (%s) '+
                       'ORDER BY AI.PRIORITY';
  FSSqlGetRecords:='SELECT %s FROM %s %s %s %s %s';
  FSSqlGetRecordsCount:='SELECT COUNT(*) FROM (%s)';
  FSSqlLoadMenus:='SELECT M.MENU_ID, M.PARENT_ID, M.NAME, M.DESCRIPTION, M.INTERFACE_ID, '+
                  'M.SHORTCUT, M.PICTURE, M.PRIORITY '+
                  'FROM /*PREFIX*/APPLICATION_MENUS AP '+
                  'JOIN /*PREFIX*/MENUS M ON M.MENU_ID=AP.MENU_ID '+
                  'WHERE AP.APPLICATION_ID=%s '+
                  'AND (M.INTERFACE_ID IN (SELECT INTERFACE_ID FROM /*PREFIX*/APPLICATION_INTERFACES '+
                                           'WHERE APPLICATION_ID=AP.APPLICATION_ID AND ACCOUNT_ID IN (%s)) '+
                  'OR M.INTERFACE_ID IS NULL) '+
                  'ORDER BY M."LEVEL", M.PRIORITY ';
  FSSqlLoadTasks:='SELECT TASK_ID, NAME, DESCRIPTION, INTERFACE_ID, '+
                  'ENABLED, DATE_BEGIN, OFFSET, DATE_END, SCHEDULE, PRIORITY, '+
                  'PROC_NAME, COMMAND_STRING, DAY_FREQUENCY, WEEK_FREQUENCY, '+
                  'MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY, '+
                  'MONTH_DAY, JANUARY, FEBRUARY, MARCH, APRIL, MAY, JUNE, '+
                  'JULY, AUGUST, SEPTEMBER, OCTOBER, NOVEMBER, DECEMBER, '+
                  'REPEAT_ENABLED, REPEAT_TYPE, REPEAT_VALUE, REPEAT_COUNT, '+
                  'DATE_EXECUTE, RESULT_STRING '+
                  'FROM /*PREFIX*/TASKS '+
                  'WHERE APPLICATION_ID=%s AND (ACCOUNT_ID IN (%s) OR ACCOUNT_ID IS NULL) '+
                  'ORDER BY DATE_BEGIN';
  FSSqlSaveTask:='UPDATE /*PREFIX*/TASKS SET DATE_EXECUTE=%s, RESULT_STRING=%s WHERE TASK_ID=%s';
  FSSqlLoadAlarms:='SELECT ALARM_ID, TYPE_ALARM, DATE_BEGIN, CAPTION, TEXT_ALARM, A1.USER_NAME '+
                   'FROM /*PREFIX*/ALARMS A '+
                   'JOIN /*PREFIX*/ACCOUNTS A1 ON A1.ACCOUNT_ID=A.SENDER_ID '+
                   'WHERE ((A.DATE_BEGIN<=CURRENT_TIMESTAMP AND A.DATE_END IS NULL) OR '+
                   '(A.DATE_BEGIN<=CURRENT_TIMESTAMP AND A.DATE_END>=CURRENT_TIMESTAMP)) '+
                   'AND (A.RECIPIENT_ID IN (%s) OR A.RECIPIENT_ID IS NULL) '+
                   'ORDER BY A.DATE_BEGIN';
  FSSqlLoadScript:='SELECT SCRIPT, PLACE FROM /*PREFIX*/SCRIPTS WHERE SCRIPT_ID=%s';
  FSSqlLoadReport:='SELECT REPORT, PLACE FROM /*PREFIX*/REPORTS WHERE REPORT_ID=%s';
  FSSqlLoadDocument:='SELECT DOCUMENT, PLACE FROM /*PREFIX*/DOCUMENTS WHERE DOCUMENT_ID=%s';
  FSParamPrefix:='';


  TranslateObject(Self,TBisUIBaseSession);
end;

destructor TBisUIBaseSession.Destroy;
begin
  FParams.Free;
  FIPList.Free;
  FLocks.Free;
  FRoles.Free;
  FPermissions.Free;
  FUpdateLock.Free;
  inherited Destroy;
end;

procedure TBisUIBaseSession.LoggerWrite(const Message: String; LogType: TBisLoggerType=ltInformation);
var
  S: String;
begin
  if Assigned(FConnection) and (Trim(Message)<>'') then begin
    S:=FormatEx(FSSessionFormat,[VarToStrDef(FSessionId,''),Message]);
    FConnection.LoggerWrite(S,LogType);
  end;
end;

function TBisUIBaseSession.PreparePrefix(AName: String): String;
begin
  Result:=AName;
  if Assigned(FConnection) then
    Result:=FConnection.PreparePrefix(AName);
end;

function TBisUIBaseSession.GetRoleIds: String;
var
  i: Integer;
begin
  Result:=QuotedStr(VarToStrDef(FAccountId,''));
  for i:=0 to FRoles.Count-1 do begin
    if Trim(FRoles[i])<>'' then begin
      Result:=Result+','+QuotedStr(FRoles[i]);
    end;
  end;
end;

procedure TBisUIBaseSession.Insert(Database: TBisUIBaseDatabase);
var
  Query: TBisUIBaseQuery;
  Tran: TBisUIBaseTransaction;
  Stream: TMemoryStream;
  Sql: String;
begin
  if Database.Connected then begin
    LoggerWrite(FSInsertStart);
    try
      Query:=TBisUIBaseQuery.Create(nil);
      Tran:=TBisUIBaseTransaction.Create(nil);
      Stream:=TMemoryStream.Create;
      try
        Tran.Database:=Database;
        Tran.TimeOut:=FTranTimeOut;
        Tran.Options:=[tpWrite,tpReadCommitted,tpRecVersion,tpNoWait];
        Query.Transaction:=Tran;
        Query.ParseParams:=true;
        Sql:=FormatEx(FSSqlInsert,[QuotedStr(VarToStrDef(FSessionId,'')),QuotedStr(VarToStrDef(FApplicationId,'')),
                                   QuotedStr(VarToStrDef(FAccountId,'')),
                                   QuotedStr(FormatDateTime(FSFormatDateTime,FDateCreate))]);
        Sql:=ReplaceText(Sql,SPrefix,FConnection.Prefix);
        LoggerWrite(FormatEx(FSInsertSql,[Sql]));
        Query.SQL.Text:=Sql;
        FParams.SaveToStream(Stream);
        Stream.Position:=0;
        Query.ParamsSetBlob('PARAMS',Stream);

        Query.ExecSQL;
        Tran.Commit;
        LoggerWrite(FSInsertSuccess);
      finally
        Stream.Free;
        Tran.Free;
        Query.Free;
      end;
    except
      On E: Exception do begin
        LoggerWrite(FormatEx(FSInsertFail,[E.Message]),ltError);
        raise;
      end;
    end;
  end;
end;

procedure TBisUIBaseSession.Update(DataBase: TBisUIBaseDatabase; WithParams: Boolean=false; QueryText: String=''; Duration: Integer=-1);
var
  Query: TBisUIBaseQuery;
  Tran: TBisUIBaseTransaction;
  Stream: TMemoryStream;
  Sql: String;
begin
  if FUpdateLock.TryLock then begin
    try
      if Assigned(FConnection) and Database.Connected then begin
        LoggerWrite(FSUpdateStart);
        try
          Query:=TBisUIBaseQuery.Create(nil);
          Tran:=TBisUIBaseTransaction.Create(nil);
          Stream:=TMemoryStream.Create;
          try
            Tran.Database:=Database;
            Tran.TimeOut:=FTranTimeOut;
            Tran.Options:=[tpWrite,tpReadCommitted,tpRecVersion,tpNoWait];
            Query.Transaction:=Tran;
            Query.ParseParams:=true;
            if WithParams then begin
              Sql:=FormatEx(FSSqlUpdateParams,[QuotedStr(VarToStrDef(FSessionId,''))])
            end else begin
              Sql:=FormatEx(FSSqlUpdate,[QuotedStr(VarToStrDef(FSessionId,''))]);
            end;
            Sql:=ReplaceText(Sql,SPrefix,FConnection.Prefix);
            Query.SQL.Text:=Sql;
            if WithParams then begin
              FParams.SaveToStream(Stream);
              Stream.Position:=0;
              Query.ParamsSetBlob('PARAMS',Stream);
            end;
            Stream.Clear;
            if Trim(QueryText)<>'' then begin
              Stream.Write(Pointer(QueryText)^,Length(QueryText));
              Stream.Position:=0;
              Query.ParamsSetBlob('QUERY_TEXT',Stream);
            end else
              Query.Params.ByNameIsNull['QUERY_TEXT']:=true;
            Query.Params.ByNameAsVariant['DURATION']:=Iff(Duration<>-1,Duration,NULL);
            LoggerWrite(FormatEx(FSUpdateSql,[Sql]));
            Query.ExecSQL;
            Tran.Commit;
            LoggerWrite(FSUpdateSuccess);
          finally
            Stream.Free;
            Query.Free;
            Tran.Free;
          end;
        except
          On E: Exception do begin
            LoggerWrite(FormatEx(FSUpdateFail,[E.Message]),ltError);
            raise;
          end;
        end;
      end;
    finally
      FUpdateLock.UnLock;
    end;
  end;
end;

procedure TBisUIBaseSession.Delete(Database: TBisUIBaseDatabase);
var
  Query: TBisUIBaseQuery;
  Tran: TBisUIBaseTransaction;
  Sql: String;
begin
  if Database.Connected then begin
    LoggerWrite(FSDeleteStart);
    try
      Query:=TBisUIBaseQuery.Create(nil);
      Tran:=TBisUIBaseTransaction.Create(nil);
      try
        Tran.Database:=Database;
        Tran.TimeOut:=FTranTimeOut;
        Tran.Options:=[tpWrite,tpReadCommitted,tpRecVersion,tpNoWait];
        Query.Transaction:=Tran;
        Sql:=FormatEx(FSSqlDelete,[QuotedStr(VarToStrDef(FSessionId,''))]);
        Sql:=ReplaceText(Sql,SPrefix,FConnection.Prefix);
        LoggerWrite(FormatEx(FSDeleteSql,[Sql]));
        Query.SQL.Text:=Sql;
        Query.ExecSQL;
        Tran.Commit;
        LoggerWrite(FSDeleteSuccess);
      finally
        Tran.Free;
        Query.Free;
      end;
    except
      On E: Exception do begin
        LoggerWrite(FormatEx(FSDeleteFail,[E.Message]),ltError);
        raise;
      end;
    end;
  end;
end;

procedure TBisUIBaseSession.LoadPermissions(Database: TBisUIBaseDatabase);
var
  Query: TBisUIBaseQuery;
  Tran: TBisUIBaseTransaction;
  S: String;
  Sql: String;
begin
  S:=GetRoleIds;
  if Database.Connected and (Trim(S)<>'') then begin
    Query:=TBisUIBaseQuery.Create(nil);
    Tran:=TBisUIBaseTransaction.Create(nil);
    try
      Tran.Database:=Database;
      Tran.TimeOut:=FTranTimeOut;
      Query.Transaction:=Tran;
      Sql:=FormatEx(FSSqlLoadPermissions,[S]);
      Query.SQL.Text:=ReplaceText(Sql,SPrefix,FConnection.Prefix);
      Query.Open;
      if Query.Active then begin
        Query.CreateTableTo(FPermissions);
        Query.CopyRecordsTo(FPermissions);
      end;
    finally
      Tran.Free;
      Query.Free;
    end;
  end;
end;

procedure TBisUIBaseSession.LoadRoles(Database: TBisUIBaseDatabase);
var
  Query: TBisUIBaseQuery;
  Tran: TBisUIBaseTransaction;
  Sql: String;
begin
  if Database.Connected then begin
    FRoles.Clear;
    Query:=TBisUIBaseQuery.Create(nil);
    Tran:=TBisUIBaseTransaction.Create(nil);
    try
      Tran.Database:=Database;
      Tran.TimeOut:=FTranTimeOut;
      Query.Transaction:=Tran;
      Sql:=FormatEx(FSSqlLoadRoles,[QuotedStr(VarToStrDef(FAccountId,''))]);
      Query.SQL.Text:=ReplaceText(Sql,SPrefix,FConnection.Prefix);
      Query.Open;
      if Query.Active then begin
        Query.First;
        while not Query.Eof do begin
          FRoles.Add(Query.Fields.ByNameAsString['ROLE_ID']);
          Query.Next;
        end;
      end;
    finally
      Tran.Free;
      Query.Free;
    end;
  end;
end;

procedure TBisUIBaseSession.LoadLocks(Database: TBisUIBaseDatabase);
var
  Query: TBisUIBaseQuery;
  Tran: TBisUIBaseTransaction;
  S: String;
  Sql: String;
  ADate: String;
begin
  S:=GetRoleIds;
  if Database.Connected and (Trim(S)<>'') then begin
    Query:=TBisUIBaseQuery.Create(nil);
    Tran:=TBisUIBaseTransaction.Create(nil);
    try
      Tran.Database:=Database;
      Tran.TimeOut:=FTranTimeOut;
      Query.Transaction:=Tran;
      ADate:=QuotedStr(FormatDateTime(FSFormatDateTime,FDateCreate));
      Sql:=FormatEx(FSSqlLoadLocks,[ADate,ADate,ADate,QuotedStr(VarToStrDef(FApplicationId,'')),S]);
      Query.SQL.Text:=ReplaceText(Sql,SPrefix,FConnection.Prefix);
      Query.Open;
      if Query.Active then begin
        Query.CreateTableTo(FLocks);
        Query.CopyRecordsTo(FLocks);
      end;
    finally
      Tran.Free;
      Query.Free;
    end;
  end;
end;

procedure TBisUIBaseSession.CheckPermissions(AObjectName: String; APermissions: TBisPermissions);
var
  Access: String;
  Perm: TBisPermission;
  Value: String;
  Index: Integer;
begin
  if Assigned(APermissions) then
    if FPermissions.Active and not FPermissions.IsEmpty then begin
      APermissions.Clear;
      FPermissions.Filter:=FormatEx(FSCheckPermissions,[QuotedStr(AObjectName)]);
      FPermissions.Filtered:=true;
      try
        FPermissions.First;
        while not FPermissions.Eof do begin
          Access:=FPermissions.FieldByName('RIGHT_ACCESS').AsString;
          Perm:=APermissions.Find(Access);
          if not Assigned(Perm) then
            Perm:=APermissions.Add(Access);
          if Assigned(Perm) then begin
            Value:=FPermissions.FieldByName('VALUE').AsString;
            Index:=Perm.Values.IndexOf(Value);
            if Index=-1 then
              Index:=Perm.Values.Add(Value);
            Perm.Exists[Index]:=true;
          end;
          FPermissions.Next;
        end;
      finally
        FPermissions.Filtered:=false;
        FPermissions.Filter:='';
      end;
    end;
end;

procedure TBisUIBaseSession.CheckLocks(AMethod: String=''; AObject: String='');
var
  Met: String;
  Obj: String;
  Desc: String;
  List: TStringList;

  function ListFound: Boolean;
  var
    i: Integer;
  begin
    Result:=false;
    for i:=0 to IPList.Count-1 do begin
      if MatchIP(Trim(IPList[i]),List) then begin
        Result:=true;
        exit;
      end;
    end;
  end;

begin
  if Assigned(FLocks) then begin
    if FLocks.Active and not FLocks.IsEmpty then begin
      FLocks.First;
      List:=TStringList.Create;
      try
        while not FLocks.Eof do begin
          Met:=FLocks.FieldByName('METHOD').AsString;
          if (Trim(Met)='') or AnsiSameText(Met,AMethod) then begin
            Obj:=FLocks.FieldByName('OBJECT').AsString;
            if (Trim(Obj)='') or AnsiSameText(Obj,AObject) then begin
              List.Text:=FLocks.FieldByName('IP_LIST').AsString;
              if (Trim(List.Text)='') or ListFound then begin
                Desc:=FLocks.FieldByName('DESCRIPTION').AsString;
                raise Exception.Create(Desc);
              end;
            end;
          end;
          FLocks.Next;
        end;
      finally
        List.Free;
      end;
    end;
  end;
end;

procedure TBisUIBaseSession.LoadProfile(Database: TBisUIBaseDatabase; Profile: TBisProfile);
var
  Query: TBisUIBaseQuery;
  Tran: TBisUIBaseTransaction;
  Sql: String;
begin
  if Assigned(Profile) and Database.Connected then begin
    LoggerWrite(FSLoadProfileStart);
    try
      Query:=TBisUIBaseQuery.Create(nil);
      Tran:=TBisUIBaseTransaction.Create(nil);
      try
        Tran.Database:=Database;
        Tran.TimeOut:=FTranTimeOut;
        Query.Transaction:=Tran;
        Sql:=FormatEx(FSSqlLoadProfile,[QuotedStr(VarToStrDef(FApplicationId,'')),QuotedStr(VarToStrDef(FAccountId,''))]);
        Sql:=ReplaceText(Sql,SPrefix,FConnection.Prefix);
        LoggerWrite(FormatEx(FSLoadProfileSql,[Sql]));
        Query.SQL.Text:=Sql;
        Query.Open;
        if Query.Active and not Query.IsEmpty then begin
          Profile.Text:=Query.Fields.ByNameAsString['PROFILE'];
        end;
        LoggerWrite(FSLoadProfileSuccess);
      finally
        Tran.Free;
        Query.Free;
      end;
    except
      On E: Exception do begin
        LoggerWrite(FormatEx(FSLoadProfileFail,[E.Message]),ltError);
        raise;
      end;
    end;
  end;
end;

procedure TBisUIBaseSession.SaveProfile(Database: TBisUIBaseDatabase; Profile: TBisProfile);
var
  Query: TBisUIBaseQuery;
  Tran: TBisUIBaseTransaction;
  Stream: TMemoryStream;
  Sql: String;
begin
  if Assigned(Profile) and Database.Connected then begin
    LoggerWrite(FSSaveProfileStart);
    try
      Query:=TBisUIBaseQuery.Create(nil);
      Tran:=TBisUIBaseTransaction.Create(nil);
      Stream:=TMemoryStream.Create;
      try
        Profile.SaveToStream(Stream);
        Tran.Database:=Database;
        Tran.TimeOut:=FTranTimeOut;
        Tran.Options:=[tpWrite,tpReadCommitted,tpRecVersion,tpNoWait];
        Query.Transaction:=Tran;
        Query.ParseParams:=true;
        Sql:=FormatEx(FSSqlSaveProfile,[QuotedStr(VarToStrDef(FApplicationId,'')),QuotedStr(VarToStrDef(FAccountId,''))]);
        Sql:=ReplaceText(Sql,SPrefix,FConnection.Prefix);
        LoggerWrite(FormatEx(FSSaveProfileSql,[Sql]));
        Query.SQL.Text:=Sql;
        Stream.Position:=0;
        Query.ParamsSetBlob('PROFILE',Stream);
        Query.ExecSQL;
        Tran.Commit;
        LoggerWrite(FSSaveProfileSuccess);
      finally
        Stream.Free;
        Tran.Free;
        Query.Free;
      end;
    except
      On E: Exception do begin
        LoggerWrite(FormatEx(FSSaveProfileFail,[E.Message]),ltError);
        raise;
      end;
    end;
  end;
end;

procedure TBisUIBaseSession.LoadInterfaces(Database: TBisUIBaseDatabase; Interfaces: TBisInterfaces);
var
  Query: TBisUIBaseQuery;
  Tran: TBisUIBaseTransaction;
  AInterface: TBisInterface;
  S: String;
  AID: String;
  AType: TBisInterfaceType;
  AObjectName: String;
  AScriptId: Variant;
  AReportId: Variant;
  ADocumentId: Variant;
  Sql: String;
begin
  S:=GetRoleIds;
  if Assigned(Interfaces) and Database.Connected and (Trim(S)<>'') then begin
    LoggerWrite(FSLoadInterfacesStart);
    try
      Query:=TBisUIBaseQuery.Create(nil);
      Tran:=TBisUIBaseTransaction.Create(nil);
      try
        Tran.Database:=Database;
        Tran.TimeOut:=FTranTimeOut;
        Query.Transaction:=Tran;
        Sql:=FormatEx(FSSqlLoadInterfaces,[QuotedStr(VarToStrDef(FApplicationId,'')),S]);
        Sql:=ReplaceText(Sql,SPrefix,FConnection.Prefix);
        LoggerWrite(FormatEx(FSLoadInterfacesSql,[Sql]));
        Query.SQL.Text:=Sql;
        Query.Open;
        if Query.Active then begin
          Query.FetchAll;
          while not Query.Eof do begin
            AID:=Query.Fields.ByNameAsString['INTERFACE_ID'];
            AType:=TBisInterfaceType(Query.Fields.ByNameAsInteger['INTERFACE_TYPE']);
            AObjectName:=Query.Fields.ByNameAsString['NAME'];
            AInterface:=Interfaces.FindById(AID);
            if not Assigned(AInterface) then begin
              case AType of
                BisInterfaces.itInternal: begin
                  AInterface:=Interfaces.AddInternal(AID,AObjectName,
                                                     Query.Fields.ByNameAsString['MODULE_NAME'],
                                                     Query.Fields.ByNameAsString['MODULE_INTERFACE']);
                end;
                BisInterfaces.itScript: begin
                  AScriptId:=Query.Fields.ByNameAsVariant['SCRIPT_ID'];
                  if not VarIsNull(AScriptId) then
                    AInterface:=Interfaces.AddScript(AScriptId,AObjectName,
                                                     Query.Fields.ByNameAsString['SCRIPT_ENGINE'],
                                                     TBisScriptPlace(Query.Fields.ByNameAsInteger['SCRIPT_PLACE']));
                end;
                BisInterfaces.itReport: begin
                  AReportId:=Query.Fields.ByNameAsVariant['REPORT_ID'];
                  if not VarIsNull(AReportId) then
                    AInterface:=Interfaces.AddReport(AReportId,AObjectName,
                                                     Query.Fields.ByNameAsString['REPORT_ENGINE'],
                                                     TBisReportPlace(Query.Fields.ByNameAsInteger['REPORT_PLACE']));
                end;
                BisInterfaces.itDocument: begin
                  ADocumentId:=Query.Fields.ByNameAsVariant['DOCUMENT_ID'];
                  if not VarIsNull(ADocumentId) then
                    AInterface:=Interfaces.AddDocument(ADocumentId,AObjectName,
                                                       Query.Fields.ByNameAsString['DOCUMENT_OLE_CLASS'],
                                                       TBisDocumentPlace(Query.Fields.ByNameAsInteger['DOCUMENT_PLACE']));
                end;
              end;
            end;
            if Assigned(AInterface) then begin
              with AInterface do begin
                Description:=Query.Fields.ByNameAsString['DESCRIPTION'];
                InterfaceType:=AType;
                AutoShow:=Boolean(Query.Fields.ByNameAsInteger['AUTO_RUN']);
                CheckPermissions(AInterface.ObjectName,AInterface.Permissions);
              end;
            end;
            Query.Next;
          end;
          LoggerWrite(FSLoadInterfacesSuccess);
        end;
      finally
        Tran.Free;
        Query.Free;
      end;
    except
      On E: Exception do begin
        LoggerWrite(FormatEx(FSLoadInterfacesFail,[E.Message]),ltError);
        raise;
      end;
    end;
  end;
end;

procedure TBisUIBaseSession.CopyData(FromDataSet: TBisUIBaseQuery; ToDataSet: TBisDataSet;
                                     AllCount: Integer; TranID: TBisUIBaseTranID);

  function FetchAll(MaxCount: Integer): Integer;
  begin
    Result:=0;
    FromDataSet.First;
    while FConnection.TranIDExists(TranID) and not FromDataSet.Eof do begin
      Inc(Result);
      if (Result>=MaxCount) then
        break;
      FromDataSet.Next;
    end;
    FromDataSet.Last;
  end;

var
  FetchCount: Integer;
  StartPos: Integer;
  RealCount: Integer;
  RecCount: Integer;
  AActive: Boolean;
begin
  if Assigned(FromDataSet) and Assigned(ToDataSet) then begin

    AActive:=FromDataSet.Active;

    if AActive then begin

      ToDataSet.BeginUpdate;
      try
        if not ToDataSet.Active then begin
          FromDataSet.CreateTableTo(ToDataSet);
        end;

        if ToDataSet.FetchCount<0 then begin
          FetchCount:=FetchAll(FConnection.FMaxRecordCount);
          AllCount:=FetchCount;
        end;

        if ToDataSet.Active then
          StartPos:=ToDataSet.RecordCount
        else StartPos:=0;

        RealCount:=ToDataSet.FetchCount;
        if RealCount<0 then begin
          RealCount:=AllCount-StartPos
        end else begin
          if (StartPos+RealCount)>AllCount then
            RealCount:=AllCount-StartPos;
        end;

        RecCount:=0;

        FromDataSet.First;

        while not FromDataSet.Eof do begin
          if (RecCount>=StartPos) then begin
            if (RecCount<(StartPos+RealCount)) and FConnection.TranIDExists(TranID) then begin
              FromDataSet.CopyRecordTo(ToDataSet);
            end else
              break;
          end;
          Inc(RecCount);
          FromDataSet.Next;
        end;

        if not FConnection.TranIDExists(TranID) then
          if ToDataSet.Active then
            ToDataSet.EmptyTable;

        ToDataSet.First;
        ToDataSet.ServerRecordCount:=AllCount;

      finally
        ToDataSet.EndUpdate;
      end;
    end;
  end;
end;

procedure TBisUIBaseSession.SetSessionId(Query: TBisUIBaseQuery);
var
  Index: Word;
begin
  if Query.Params.TryGetFieldIndex('SESSION_ID',Index) then
    Query.Params.AsVariant[Index]:=FSessionId;
end;

procedure TBisUIBaseSession.LogQueryParams(Query: TBisUIBaseQuery);
var
  S: String;
  S1: String;
  S2: String;
  S3: String;
  i: Integer;
begin
  if Assigned(Query.Params) then begin
    for i:=0 to Query.Params.FieldCount-1 do begin
      if Query.Params.IsNull[i] then
        S1:=SNull
      else begin
        if not Query.Params.IsBlob[i] then
          S1:=Query.Params.AsString[i]
        else begin
          S1:='';
        end;
      end;
      if Length(S1)>MaxValueSize then
        S1:=Copy(S1,1,MaxValueSize)+'...';

      S:=Query.Params.FieldName[i];
      S2:=GetEnumName(TypeInfo(DB.TParamType),Integer(ptInput));
      S3:=GetEnumName(TypeInfo(TUIBFieldType),Integer(Query.Params.FieldType[i]));
      LoggerWrite(FormatEx(FSExecuteParam,[S,S2,S3,S1]));
    end;
  end;
end;

procedure TBisUIBaseSession.LogParams(Params: TBisParams);
var
  S1: String;
  S2: String;
  S3: String;
  i: Integer;
  Param: TBisParam;
begin
  for i:=0 to Params.Count-1 do begin
    Param:=Params.Items[i];
    if Param.Empty then
      S1:=SNull
    else S1:=VarToStrDef(Param.Value,'');
    if Length(S1)>MaxValueSize then
      S1:=Copy(S1,1,MaxValueSize)+'...';

    S2:=GetEnumName(TypeInfo(DB.TParamType),Integer(Param.ParamType));
    S3:=GetEnumName(TypeInfo(TFieldType),Integer(Param.DataType));

    LoggerWrite(FormatEx(FSExecuteParam,[Param.ParamName,S2,S3,S1]));
  end;
end;

procedure TBisUIBaseSession.ExecutePackages(ProviderName: String; Tran: TBisUIBaseTransaction; Package: TBisPackageParams);
var
  i: Integer;
  Query: TBisUIBaseQuery;
  Params: TBisParams;
  AProvider: String;
begin
  if Assigned(Package) and (Package.Count>0) then begin
    LoggerWrite(FSExecutePackageStart);
    try
      for i:=0 to Package.Count-1 do begin
        Params:=Package.Items[i];
        AProvider:=iff(Trim(Params.ProviderName)<>'',Params.ProviderName,ProviderName);
        AProvider:=PreparePrefix(AProvider);
        Query:=TBisUIBaseQuery.Create(nil);
        try
          Query.Transaction:=Tran;
          Query.BuildStoredProc(AProvider,false);
          LoggerWrite(FormatEx(FSExecuteProvider,[AProvider]));
          Query.SetNullToParamValues;
          SetSessionId(Query);
          Query.CopyParamsFrom(Params);
          LogQueryParams(Query);
          LoggerWrite(FSExecuteSetParams);
          Query.Execute;
          Query.CopyParamsTo(Params);
          LogParams(Params);
          LoggerWrite(FSExecuteSuccess);
        finally
          Query.Free;
        end;
      end;
    finally
      LoggerWrite(FSExecutePackageEnd);
    end;
  end;
end;

procedure TBisUIBaseSession.DefaultGetRecords(ProviderName: String; DataSet: TBisDataSet; OpenMode: TBisDataSetOpenMode;
                                              Tran: TBisUIBaseTransaction; TranID: TBisUIBaseTranID);
var
  Query: TBisUIBaseQuery;
  SQL: String;
  SQLCount: String;
  AllCount: Integer;
  FieldNames: String;
  Params: String;
  Filters: String;
  Groups: String;
  Orders: String;
  QueryText: String;
begin
  if Trim(ProviderName)<>'' then begin
    Query:=TBisUIBaseQuery.Create(nil);
    try
      Query.Transaction:=Tran;
      Query.ParseParams:=DataSet.Params.Count>0;
      Query.BufferChunks:=FConnection.FMaxRecordCount;

      if OpenMode=omExecute then begin
        Query.ParseParams:=true;
        Query.BuildStoredProc(ProviderName,true);
      end;

      FieldNames:=FConnection.GetRecordsFieldNames(DataSet,DataSet.FieldNames);
      if OpenMode=omOpen then
        Params:=FConnection.GetRecordsParams(DataSet,DataSet.Params)
      else
        Params:=Query.GetParamsNames;
      Filters:=FConnection.GetRecordsFilterGroups(DataSet.FilterGroups);
      Groups:=FConnection.GetRecordsGroups(DataSet,DataSet.FieldNames);
      Orders:=FConnection.GetRecordsOrders(DataSet.Orders);

      SQL:=Trim(FormatEx(FSSqlGetRecords,[FieldNames,ProviderName,Params,Filters,Groups,Orders]));
      AllCount:=0;

      if DataSet.FetchCount>0 then begin
        SQLCount:=Trim(FormatEx(FSSqlGetRecords,['COUNT(*)',ProviderName,Params,Filters,Groups,'']));
        LoggerWrite(FormatEx(FSGetRecordsSqlCount,[SQLCount]));
        Query.SQL.Text:=SQLCount;
        Query.Open;

        if not Query.IsEmpty then
          AllCount:=Query.Fields.AsInteger[0];
      end else begin
        AllCount:=MaxInt;
      end;

      Query.Close;
      Query.SQL.Text:=SQL;

      if OpenMode=omExecute then begin
        Query.SetNullToParamValues;
        SetSessionId(Query);
        Query.CopyParamsFrom(DataSet.Params);
        LogQueryParams(Query);
      end;

      QueryText:=Query.GetQueryText;

      LoggerWrite(FormatEx(FSGetRecordsSql,[QueryText]));

      ExecutePackages(ProviderName,Tran,DataSet.PackageBefore);
      Query.Open;
      if OpenMode=omExecute then begin
        Query.CopyParamsTo(DataSet.Params);
        LogParams(DataSet.Params);
      end;
      ExecutePackages(ProviderName,Tran,DataSet.PackageAfter);

      CopyData(Query,DataSet,AllCount,TranID);

    finally
      Query.Free;
    end;
  end;
end;

procedure TBisUIBaseSession.CollectionGetRecords(ProviderName: String; Collection: TBisDataSetCollection;
                                                 Tran: TBisUIBaseTransaction; TranID: TBisUIBaseTranID);
var
  i: Integer;
  Item: TBisDataSetCollectionItem;
  ADataSet: TBisDataSet;
  AProvider: String;
begin
  if Assigned(Collection) and (Collection.Count>0) then begin
    LoggerWrite(FSCollectionGetRecordsStart);
    try
      for i:=0 to Collection.Count-1 do begin
        Item:=Collection.Items[i];
        ADataSet:=TBisDataSet.Create(nil);
        try
          AProvider:=iff(Trim(Item.ProviderName)<>'',Item.ProviderName,ProviderName);
          AProvider:=PreparePrefix(AProvider);

          ADataSet.InGetRecords:=true;
          ADataSet.ProviderName:=AProvider;
          ADataSet.FieldNames.CopyFrom(Item.FieldNames);
          ADataSet.FilterGroups.CopyFrom(Item.FilterGroups);
          ADataSet.Params.CopyFrom(Item.Params);
          ADataSet.PackageBefore.CopyFrom(Item.PackageBefore);
          ADataSet.PackageAfter.CopyFrom(Item.PackageAfter);
          ADataSet.Orders.CopyFrom(Item.Orders);
          DefaultGetRecords(AProvider,ADataSet,Item.OpenMode,Tran,TranID);
          Item.SetDataSet(ADataSet);
        finally
          ADataSet.Free;
        end;
      end;
    finally
      LoggerWrite(FSCollectionGetRecordsEnd);
    end;
  end;
end;

procedure TBisUIBaseSession.GetRecords(Database: TBisUIBaseDatabase; DataSet: TBisDataSet; var QueryText: String);
var
  Tran: TBisUIBaseTransaction;
  WriteTran: Boolean;
  TranID: TBisUIBaseTranID;
  AProvider: String;
begin
  if Assigned(DataSet) and Database.Connected then begin
    LoggerWrite(FSGetRecordsStart);
    try
      AProvider:=PreparePrefix(DataSet.ProviderName);
      Tran:=TBisUIBaseTransaction.Create(nil);
      try
        Tran.Database:=Database;
        Tran.TimeOut:=FTranTimeOut;

        WriteTran:=(DataSet.OpenMode=omExecute) or (DataSet.PackageBefore.Count>0) or (DataSet.PackageAfter.Count>0);
        if WriteTran then
          Tran.Options:=[tpWrite,tpReadCommitted,tpRecVersion,tpNoWait];
        try
          Tran.StartTransaction;

          TranID:=FConnection.CreateTranID(Database,Tran,FSessionId,DataSet);
          try
            CollectionGetRecords(AProvider,DataSet.CollectionBefore,Tran,TranID);
            DefaultGetRecords(AProvider,DataSet,omOpen,Tran,TranID);
            CollectionGetRecords(AProvider,DataSet.CollectionAfter,Tran,TranID);

            if WriteTran then
              Tran.Commit;

            LoggerWrite(FSGetRecordsSuccess);
          finally
            FConnection.FreeTranID(TranID);
          end;
        except
          On E: Exception do begin
            Tran.RollBack;
            raise;
          end;
        end;
      finally
        Tran.Free;
      end;  
    except
      On E: Exception do begin
        LoggerWrite(FormatEx(FSGetRecordsFail,[E.Message]),ltError);
        raise;
      end;
    end;
  end;
end;

procedure TBisUIBaseSession.Execute(Database: TBisUIBaseDatabase; DataSet: TBisDataSet; var QueryText: String);
var
  Query: TBisUIBaseQuery;
  AProvider: String;
  Tran: TBisUIBaseTransaction;
  TranID: TBisUIBaseTranID;
begin
  if Assigned(DataSet) and Database.Connected then begin
    LoggerWrite(FSExecuteStart);
    try
      AProvider:=PreparePrefix(DataSet.ProviderName);
      Tran:=TBisUIBaseTransaction.Create(nil);
      try
        Tran.Database:=Database;
        Tran.TimeOut:=FTranTimeOut;
        Tran.Options:=[tpWrite,tpReadCommitted,tpRecVersion,tpNoWait];
        LoggerWrite(FormatEx(FSExecuteProvider,[AProvider]));
        if DataSet.InGetRecords then begin
          try
            Tran.StartTransaction;

            TranID:=FConnection.CreateTranID(Database,Tran,FSessionId,DataSet);
            try
              CollectionGetRecords(AProvider,DataSet.CollectionBefore,Tran,TranID);
              DefaultGetRecords(AProvider,DataSet,omExecute,Tran,TranID);
              CollectionGetRecords(AProvider,DataSet.CollectionAfter,Tran,TranID);
              Tran.Commit;
            finally
              FConnection.FreeTranID(TranID);
            end;
          except
            on E: Exception do begin
              Tran.Rollback;
              raise;
            end;
          end;
        end else begin
          Query:=TBisUIBaseQuery.Create(nil);
          try
            Query.Transaction:=Tran;
            Query.BuildStoredProc(AProvider,DataSet.InGetRecords);
            try
              Query.SetNullToParamValues;                                              
              SetSessionId(Query);
              Query.CopyParamsFrom(DataSet.Params);
              LogQueryParams(Query);
              QueryText:=Query.GetQueryText;
              LoggerWrite(FSExecuteSetParams);

              Query.BeginTransaction;

              TranID:=FConnection.CreateTranID(Database,Tran,FSessionId,DataSet);
              try
                ExecutePackages(DataSet.ProviderName,Tran,DataSet.PackageBefore);
                Query.Execute;
                Query.CopyParamsTo(DataSet.Params);
                LogParams(DataSet.Params);
                ExecutePackages(DataSet.ProviderName,Tran,DataSet.PackageAfter);
                Tran.Commit;
              finally
                FConnection.FreeTranID(TranID);
              end;

            except
              on E: Exception do begin
                Tran.Rollback;
                raise;
              end;
            end;
          finally
            Query.Free;
          end;
        end;
        LoggerWrite(FSExecuteSuccess);
      finally
        Tran.Free;
      end;
    except
      On E: Exception do begin
        LoggerWrite(FormatEx(FSExecuteFail,[E.Message]),ltError);
        raise;
      end;
    end;
  end;
end;

procedure TBisUIBaseSession.LoadMenus(Database: TBisUIBaseDatabase; Menus: TBisMenus);
var
  Query: TBisUIBaseQuery;
  Tran: TBisUIBaseTransaction;
  Menu: TBisMenu;
  S: String;
  ID: String;
  ParentID: String;
  Stream: TMemoryStream;
  Sql: String;
begin
  S:=GetRoleIds;
  if Assigned(Menus) and Database.Connected and (Trim(S)<>'') then begin
    LoggerWrite(FSLoadMenusStart);
    try
      Query:=TBisUIBaseQuery.Create(nil);
      Tran:=TBisUIBaseTransaction.Create(nil);
      try
        Tran.Database:=Database;
        Tran.TimeOut:=FTranTimeOut;
        Query.Transaction:=Tran;
        Sql:=FormatEx(FSSqlLoadMenus,[QuotedStr(VarToStrDef(FApplicationId,'')),S]);
        Sql:=ReplaceText(Sql,SPrefix,FConnection.Prefix);
        LoggerWrite(FormatEx(FSLoadMenusSql,[Sql]));
        Query.SQL.Text:=Sql;
        Query.Open;
        if Query.Active then begin
          Query.FetchAll;
          while not Query.Eof do begin
            ID:=Query.Fields.ByNameAsString['MENU_ID'];
            ParentID:=Query.Fields.ByNameAsString['PARENT_ID'];
            Menu:=Menus.AddByID(ID,ParentID);
            if Assigned(Menu) then begin
              Menu.InterfaceID:=Query.Fields.ByNameAsString['INTERFACE_ID'];
              Menu.Caption:=Query.Fields.ByNameAsString['NAME'];
              Menu.Description:=Query.Fields.ByNameAsString['DESCRIPTION'];
              Menu.ShortCut:=Query.Fields.ByNameAsInteger['SHORTCUT'];
              Menu.Priority:=Query.Fields.ByNameAsInteger['PRIORITY'];
              Stream:=TMemoryStream.Create;
              try
                Query.Fields.ReadBlob('PICTURE',Stream);
                Stream.Position:=0;
                Menu.Picture.LoadFromStream(Stream);
              finally
                Stream.Free;
              end;
            end;

            Query.Next;
          end;
          LoggerWrite(FSLoadMenusSuccess);
        end;
      finally
        Tran.Free;
        Query.Free;
      end;
    except
      On E: Exception do begin
        LoggerWrite(FormatEx(FSLoadMenusFail,[E.Message]),ltError);
        raise;
      end;
    end;
  end;
end;

procedure TBisUIBaseSession.LoadTasks(Database: TBisUIBaseDatabase; Tasks: TBisTasks);
var
  Query: TBisUIBaseQuery;
  Tran: TBisUIBaseTransaction;
  Task: TBisTask;
  S: String;
  ID: String;
  AObjectName: String;
  Sql: String;
begin
  S:=GetRoleIds;
  if Assigned(Tasks) and Database.Connected and (Trim(S)<>'') then begin
    LoggerWrite(FSLoadTasksStart);
    try
      Query:=TBisUIBaseQuery.Create(nil);
      Tran:=TBisUIBaseTransaction.Create(nil);
      try
        Tran.Database:=Database;
        Tran.TimeOut:=FTranTimeOut;
        Query.Transaction:=Tran;
        Sql:=FormatEx(FSSqlLoadTasks,[QuotedStr(VarToStrDef(FApplicationId,'')),S]);
        Sql:=ReplaceText(Sql,SPrefix,FConnection.Prefix);
        LoggerWrite(FormatEx(FSLoadTasksSql,[Sql]));
        Query.SQL.Text:=Sql;
        Query.Open;
        if Query.Active then begin
          Query.FetchAll;
          while not Query.Eof do begin
            ID:=Query.Fields.ByNameAsString['TASK_ID'];
            AObjectName:=Query.Fields.ByNameAsString['NAME'];
            Task:=Tasks.FindByID(ID);
            if not Assigned(Task) then
              Task:=Tasks.Add(ID,AObjectName);
            if Assigned(Task) then begin
              with Task do begin
                Description:=Query.Fields.ByNameAsString['DESCRIPTION'];
                Enabled:=Boolean(Query.Fields.ByNameAsInteger['ENABLED']);
                Priority:=TBisTaskPriority(Query.Fields.ByNameAsInteger['PRIORITY']);
                Schedule:=TBisTaskSchedule(Query.Fields.ByNameAsInteger['SCHEDULE']);
                InterfaceID:=Query.Fields.ByNameAsString['INTERFACE_ID'];
                ProcName:=Query.Fields.ByNameAsString['PROC_NAME'];
                CommandString:=Query.Fields.ByNameAsString['COMMAND_STRING'];
                DateBegin:=Query.Fields.ByNameAsDateTime['DATE_BEGIN'];
                Offset:=Query.Fields.ByNameAsInteger['OFFSET'];
                DateEnd:=Query.Fields.ByNameAsDateTime['DATE_END'];
                DayFrequency:=Query.Fields.ByNameAsInteger['DAY_FREQUENCY'];
                WeekFrequency:=Query.Fields.ByNameAsInteger['WEEK_FREQUENCY'];
                Monday:=Boolean(Query.Fields.ByNameAsInteger['MONDAY']);
                Tuesday:=Boolean(Query.Fields.ByNameAsInteger['TUESDAY']);
                Wednesday:=Boolean(Query.Fields.ByNameAsInteger['WEDNESDAY']);
                Thursday:=Boolean(Query.Fields.ByNameAsInteger['THURSDAY']);
                Friday:=Boolean(Query.Fields.ByNameAsInteger['FRIDAY']);
                Saturday:=Boolean(Query.Fields.ByNameAsInteger['SATURDAY']);
                Sunday:=Boolean(Query.Fields.ByNameAsInteger['SUNDAY']);
                MonthDay:=Query.Fields.ByNameAsInteger['MONTH_DAY'];
                January:=Boolean(Query.Fields.ByNameAsInteger['JANUARY']);
                February:=Boolean(Query.Fields.ByNameAsInteger['FEBRUARY']);
                March:=Boolean(Query.Fields.ByNameAsInteger['MARCH']);
                April:=Boolean(Query.Fields.ByNameAsInteger['APRIL']);
                May:=Boolean(Query.Fields.ByNameAsInteger['MAY']);
                June:=Boolean(Query.Fields.ByNameAsInteger['JUNE']);
                July:=Boolean(Query.Fields.ByNameAsInteger['JULY']);
                August:=Boolean(Query.Fields.ByNameAsInteger['AUGUST']);
                September:=Boolean(Query.Fields.ByNameAsInteger['SEPTEMBER']);
                October:=Boolean(Query.Fields.ByNameAsInteger['OCTOBER']);
                November:=Boolean(Query.Fields.ByNameAsInteger['NOVEMBER']);
                December:=Boolean(Query.Fields.ByNameAsInteger['DECEMBER']);
                RepeatEnabled:=Boolean(Query.Fields.ByNameAsInteger['REPEAT_ENABLED']);
                RepeatValue:=Query.Fields.ByNameAsInteger['REPEAT_VALUE'];
                RepeatType:=TBisTaskRepeat(Query.Fields.ByNameAsInteger['REPEAT_TYPE']);
                RepeatCount:=Query.Fields.ByNameAsInteger['REPEAT_COUNT'];
                DateExecute:=Query.Fields.ByNameAsDateTime['DATE_EXECUTE'];
                ResultString:=Query.Fields.ByNameAsString['RESULT_STRING'];
              end;
            end;
            Query.Next;
          end;
          LoggerWrite(FSLoadTasksSuccess);
        end;
      finally
        Tran.Free;
        Query.Free;
      end;
    except
      On E: Exception do begin
        LoggerWrite(FormatEx(FSLoadTasksFail,[E.Message]),ltError);
        raise;
      end;
    end;
  end;
end;

procedure TBisUIBaseSession.SaveTask(Database: TBisUIBaseDatabase; Task: TBisTask);
var
  Query: TBisUIBaseQuery;
  Tran: TBisUIBaseTransaction;
  Sql: String;
begin
  if Assigned(Task) and Database.Connected then begin
    LoggerWrite(FSSaveTaskStart);
    try
      Query:=TBisUIBaseQuery.Create(nil);
      Tran:=TBisUIBaseTransaction.Create(nil);
      try
        Tran.Database:=Database;
        Tran.TimeOut:=FTranTimeOut;
        Tran.Options:=[tpWrite,tpReadCommitted,tpRecVersion,tpNoWait];
        Query.Transaction:=Tran;
        Sql:=FormatEx(FSSqlSaveTask,[QuotedStr(FormatDateTime(FSFormatDateTime,Task.DateExecute)),
                                     QuotedStr(Task.ResultString),QuotedStr(Task.ID)]);
        Sql:=ReplaceText(Sql,SPrefix,FConnection.Prefix);
        LoggerWrite(FormatEx(FSSaveTaskSql,[Sql]));
        Query.SQL.Text:=Sql;
        Query.ExecSQL;
        Tran.Commit;
        LoggerWrite(FSSaveTaskSuccess);
      finally
        Tran.Free;
        Query.Free;
      end;
    except
      On E: Exception do begin
        LoggerWrite(FormatEx(FSSaveTaskFail,[E.Message]),ltError);
        raise;
      end;
    end;
  end;
end;

procedure TBisUIBaseSession.LoadAlarms(Database: TBisUIBaseDatabase; Alarms: TBisAlarms);
var
  Query: TBisUIBaseQuery;
  Tran: TBisUIBaseTransaction;
  Alarm: TBisAlarm;
  S: String;
  ID: String;
  Sql: String;
begin
  S:=GetRoleIds;
  if Assigned(Alarms) and Database.Connected and (Trim(S)<>'') then begin
    LoggerWrite(FSLoadAlarmsStart);
    try
      Query:=TBisUIBaseQuery.Create(nil);
      Tran:=TBisUIBaseTransaction.Create(nil);
      try
        Tran.Database:=Database;
        Tran.TimeOut:=FTranTimeOut;
        Query.Transaction:=Tran;
        Sql:=FormatEx(FSSqlLoadAlarms,[S]);
        Sql:=ReplaceText(Sql,SPrefix,FConnection.Prefix);
        LoggerWrite(FormatEx(FSSqlLoadAlarms,[Sql]));
        Query.SQL.Text:=Sql;
        Query.Open;
        if Query.Active then begin
          Query.FetchAll;
          while not Query.Eof do begin
            ID:=Query.Fields.ByNameAsString['ALARM_ID'];
            Alarm:=Alarms.FindByID(ID);
            if not Assigned(Alarm) then
              Alarm:=Alarms.Add(ID);
            if Assigned(Alarm) then begin
              with Alarm do begin
                TypeAlarm:=TBisAlarmType(Query.Fields.ByNameAsInteger['TYPE_ALARM']);
                DateBegin:=Query.Fields.ByNameAsDateTime['DATE_BEGIN'];
                Caption:=Query.Fields.ByNameAsString['CAPTION'];
                Text:=Query.Fields.ByNameAsString['TEXT_ALARM'];
                SenderName:=Query.Fields.ByNameAsString['USER_NAME'];
              end;
            end;
            Query.Next;
          end;
          LoggerWrite(FSLoadAlarmsSuccess);
        end;
      finally
        Tran.Free;
        Query.Free;
      end;
    except
      On E: Exception do begin
        LoggerWrite(FormatEx(FSLoadAlarmsFail,[E.Message]),ltError);
        raise;
      end;
    end;
  end;
end;

procedure TBisUIBaseSession.LoadScript(Database: TBisUIBaseDatabase; ScriptId: Variant; Stream: TStream);
var
  Query: TBisUIBaseQuery;
  Tran: TBisUIBaseTransaction;
  FileStream: TFileStream;
  S: String;
  Sql: String;
begin
  if Assigned(Stream) and Database.Connected then begin
    LoggerWrite(FSLoadScriptStart);
    try
      Query:=TBisUIBaseQuery.Create(nil);
      Tran:=TBisUIBaseTransaction.Create(nil);
      try
        Tran.Database:=Database;
        Tran.TimeOut:=FTranTimeOut;
        Query.Transaction:=Tran;
        Sql:=FormatEx(FSSqlLoadScript,[QuotedStr(VarToStrDef(ScriptId,''))]);
        Sql:=ReplaceText(Sql,SPrefix,FConnection.Prefix);
        LoggerWrite(FormatEx(FSLoadScriptSql,[Sql]));
        Query.SQL.Text:=Sql;
        Query.Open;
        if Query.Active and not Query.IsEmpty then begin
          if Query.Fields.ByNameIsBlob['SCRIPT'] then begin
            case TBisScriptPlace(Query.Fields.ByNameAsInteger['PLACE']) of
              spDatabase: Query.Fields.ReadBlob('SCRIPT',Stream);
              spFileSystem: begin
                S:=Query.Fields.ByNameAsString['SCRIPT'];
                if FileExists(S) then begin
                  FileStream:=nil;
                  try
                    FileStream:=TFileStream.Create(S,fmOpenRead);
                    Stream.CopyFrom(FileStream,FileStream.Size);
                  finally
                    FreeAndNilEx(FileStream);
                  end;
                end;
              end;
            end;
            Stream.Position:=0;
          end;
        end;
        LoggerWrite(FSLoadScriptSuccess);
      finally
        Tran.Free;
        Query.Free;
      end;
    except
      On E: Exception do begin
        LoggerWrite(FormatEx(FSLoadScriptFail,[E.Message]),ltError);
        raise;
      end;
    end;
  end;
end;

procedure TBisUIBaseSession.LoadReport(Database: TBisUIBaseDatabase; ReportId: Variant; Stream: TStream);
var
  Query: TBisUIBaseQuery;
  Tran: TBisUIBaseTransaction;
  FileStream: TFileStream;
  S: String;
  Sql: String;
begin
  if Assigned(Stream) and Database.Connected then begin
    LoggerWrite(FSLoadReportStart);
    try
      Query:=TBisUIBaseQuery.Create(nil);
      Tran:=TBisUIBaseTransaction.Create(nil);
      try
        Tran.Database:=Database;
        Tran.TimeOut:=FTranTimeOut;
        Query.Transaction:=Tran;
        Sql:=FormatEx(FSSqlLoadReport,[QuotedStr(VarToStrDef(ReportId,''))]);
        Sql:=ReplaceText(Sql,SPrefix,FConnection.Prefix);
        LoggerWrite(FormatEx(FSLoadReportSql,[Sql]));
        Query.SQL.Text:=Sql;
        Query.Open;
        if Query.Active and not Query.IsEmpty then begin
          if Query.Fields.ByNameIsBlob['REPORT'] then begin
            case TBisReportPlace(Query.Fields.ByNameAsInteger['PLACE']) of
              rpDatabase: Query.Fields.ReadBlob('REPORT',Stream);
              rpFileSystem: begin
                S:=Query.Fields.ByNameAsString['REPORT'];
                if FileExists(S) then begin
                  FileStream:=nil;
                  try
                    FileStream:=TFileStream.Create(S,fmOpenRead);
                    Stream.CopyFrom(FileStream,FileStream.Size);
                  finally
                    FreeAndNilEx(FileStream);
                  end;
                end;
              end;
            end;
            Stream.Position:=0;
          end;
        end;
        LoggerWrite(FSLoadReportSuccess);
      finally
        Tran.Free;
        Query.Free;
      end;
    except
      On E: Exception do begin
        LoggerWrite(FormatEx(FSLoadReportFail,[E.Message]),ltError);
        raise;
      end;
    end;
  end;
end;

procedure TBisUIBaseSession.LoadDocument(Database: TBisUIBaseDatabase; DocumentId: Variant; Stream: TStream);
var
  Query: TBisUIBaseQuery;
  Tran: TBisUIBaseTransaction;
  FileStream: TFileStream;
  S: String;
  Sql: String;
begin
  if Assigned(Stream) and Database.Connected then begin
    LoggerWrite(FSLoadDocumentStart);
    try
      Query:=TBisUIBaseQuery.Create(nil);
      Tran:=TBisUIBaseTransaction.Create(nil);
      try
        Tran.Database:=Database;
        Tran.TimeOut:=FTranTimeOut;
        Query.Transaction:=Tran;
        Sql:=FormatEx(FSSqlLoadDocument,[QuotedStr(VarToStrDef(DocumentId,''))]);
        Sql:=ReplaceText(Sql,SPrefix,FConnection.Prefix);
        LoggerWrite(FormatEx(FSLoadDocumentSql,[Sql]));
        Query.SQL.Text:=Sql;
        Query.Open;
        if Query.Active and not Query.IsEmpty then begin
          if Query.Fields.ByNameIsBlob['DOCUMENT'] then begin
            case TBisDocumentPlace(Query.Fields.ByNameAsInteger['PLACE']) of
              dpDatabase: Query.Fields.ReadBlob('DOCUMENT',Stream);
              dpFileSystem: begin
                S:=Query.Fields.ByNameAsString['DOCUMENT'];
                if FileExists(S) then begin
                  FileStream:=nil;
                  try
                    FileStream:=TFileStream.Create(S,fmOpenRead);
                    Stream.CopyFrom(FileStream,FileStream.Size);
                  finally
                    FreeAndNilEx(FileStream);
                  end;
                end;
              end;
            end;
            Stream.Position:=0;
          end;
        end;
        LoggerWrite(FSLoadDocumentSuccess);
      finally
        Tran.Free;
        Query.Free;
      end;
    except
      On E: Exception do begin
        LoggerWrite(FormatEx(FSLoadDocumentFail,[E.Message]),ltError);
        raise;
      end;
    end;
  end;
end;

{ TBisUIBaseSessions }

constructor TBisUIBaseSessions.Create(AConnection: TBisUIBaseConnection);
begin
  inherited Create;
  FConnection:=AConnection;
end;

destructor TBisUIBaseSessions.Destroy;
begin
  inherited Destroy;
end;

function TBisUIBaseSessions.GetSessionClass: TBisUIBaseSessionClass;
begin
  Result:=TBisUIBaseSession;
end;

function TBisUIBaseSessions.GetItems(Index: Integer): TBisUIBaseSession;
begin
  Result:=TBisUIBaseSession(inherited Items[Index]);
end;

function TBisUIBaseSessions.Add(Database: TBisUIBaseDatabase; SessionId: Variant; DateCreate: TDateTime;
                                ApplicationId, AccountId: Variant; UserName, Password: String;
                                DbUserName, DbPassword: String; SessionParams, IPList: String): TBisUIBaseSession;
var
  Session: TBisUIBaseSession;
begin
  Result:=nil;
  if Assigned(FConnection) then begin
    try
      Session:=GetSessionClass.Create(Self);
      if Assigned(Session) then begin
        Session.SessionId:=SessionId;
        Session.DateCreate:=DateCreate;
        Session.ApplicationId:=ApplicationId;
        Session.AccountId:=AccountId;
        Session.UserName:=UserName;
        Session.Password:=Password;
        Session.DbUserName:=DbUserName;
        Session.DbPassword:=DbPassword;
        Session.TranIdleTimer:=FConnection.TimeOut;

        Session.Params.Text:=SessionParams;
        Session.IPList.Text:=IPList;

        Session.Connection:=FConnection;

        if Assigned(Database) then begin
          Session.Insert(Database);
          Session.LoadRoles(Database);
          Session.LoadPermissions(Database);
          Session.LoadLocks(Database);
        end;

        Lock;
        try
          inherited Add(Session);
        finally
          UnLock;
        end;
        
        Result:=Session;
      end;
    except
      on E: Exception do begin
        FreeAndNilEx(Session);
        raise;
      end;
    end;
  end;
end;

function TBisUIBaseSessions.Find(SessionId: Variant): TBisUIBaseSession;
var
  i: Integer;
  Item: TBisUIBaseSession;
begin
  Lock;
  try
    Result:=nil;
    for i:=0 to Count-1 do begin
      Item:=Items[i];
      if VarSameValue(Item.SessionId,SessionId) then begin
        Result:=Item;
        exit;
      end;
    end;
  finally
    UnLock;
  end;
end;

procedure TBisUIBaseSessions.Remove(Session: TBisUIBaseSession; WithLock: Boolean);
begin
  if WithLock then
    Lock;
  try
    inherited Remove(Session);
  finally
    if WithLock then
      UnLock;
  end;
end;

procedure TBisUIBaseSessions.CopyFrom(Source: TBisUIBaseSessions; IsClear: Boolean);
var
  i: Integer;
  Item: TBisUIBaseSession;
  Session: TBisUIBaseSession;
begin
  if IsClear then
    Clear;
  if Assigned(Source) then begin
    for i:=0 to Source.Count-1 do begin
      Item:=Source.Items[i];
      Session:=Find(Item.SessionId);
      if not Assigned(Session) then begin
        Session:=Add(nil,Item.SessionId,Item.DateCreate,Item.ApplicationId,
                     Item.AccountId,Item.UserName,Item.Password,
                     Item.DbUserName,Item.DbPassword,
                     Item.Params.Text,Item.IPList.Text);
        if Assigned(Session) then begin
          Session.Roles.Text:=Item.Roles.Text;
          Session.Permissions.CreateTable(Item.Permissions);
          Session.Permissions.CopyRecords(Item.Permissions);
          Session.Locks.CreateTable(Item.Locks);
          Session.Locks.CopyRecords(Item.Locks);
        end;
      end;
    end;
  end;
end;

{ TBisUIBaseTranID }

constructor TBisUIBaseTranID.Create;
begin
  inherited Create;
  FTranID:=0;
  FSessionId:=Null;
end;

destructor TBisUIBaseTranID.Destroy;
begin
  FDatabase:=nil;
  inherited Destroy;
end;

{ TBisUIBaseTranIDs }

function TBisUIBaseTranIDs.GetItem(Index: Integer): TBisUIBaseTranID;
begin
  Result:=TBisUIBaseTranID(inherited Items[Index]);
end;

function TBisUIBaseTranIDs.Add(TranID: Cardinal; SessionId: Variant; DataSetCheckSum: String): TBisUIBaseTranID;
begin
  Result:=TBisUIBaseTranID.Create;
  Result.TranID:=TranID;
  Result.SessionId:=SessionId;
  Result.DataSetCheckSum:=DataSetCheckSum;
  inherited Add(Result);
end;

function TBisUIBaseTranIDs.DatabaseExists(Database: TBisUIBaseDatabase): Boolean;
var
  i: Integer;
  Item: TBisUIBaseTranID;
begin
  Result:=false;
  if Assigned(Database) then begin
    for i:=0 to Count-1 do begin
      Item:=Items[i];
      if Item.Database=Database then begin
        Result:=true;
        exit;
      end;
    end;
  end;
end;

type
  TBisDatabaseSweepThread=class(TBisWaitThread)
  private
    FDatabase: TBisUIBaseDatabase;
  end;

{ TBisUIBaseConnection }

constructor TBisUIBaseConnection.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FCheckVersion:=true;
  FMaxRecordCount:=50000;
  FSweepTimeout:=10000;

  Params.OnChange:=ChangeParams;

  FUserName:='SYSDBA';
  FPassword:='masterkey';
  FCharacterSet:=csWIN1251;
  FSQLDialect:=3;

  FDatabases:=TBisUIBaseDatabases.Create;
  FSessions:=GetSessionsClass.Create(Self);
  FTranIDs:=TBisUIBaseTranIDs.Create;

  FThreads:=TBisThreads.Create;
  FThreads.OnItemRemove:=ThreadsItemRemove;
  FThreads.OwnsObjects:=False; 

//  Core.ExceptNotifier.IngnoreExceptions.Add(EIBInterBaseError);

  FSImportScriptStart:='������ ���������� ������� ������� ...';
  FSImportScriptSql:='����� ������� => %s';
  FSImportScriptSuccess:='������ ������� �������� �������.';
  FSImportScriptFail:='������ ������� �� ��������. %s';

  FSImportTableStart:='������ ���������� ������� ������� ...';
  FSImportTableSql:='����� ������� => %s';
  FSImportTableSuccess:='������ ������� �������� �������.';
  FSImportTableEmpty:='������� �� �������� ��� ������.';
  FSImportTableFail:='������ ������� �� ��������. %s';
  FSImportTableParam:='�������� => %s ��� ��������� => %s ��� ������ => %s �������� => %s';

  FSDeleteStatementsSql:='������ �������� �������� => %s';

  FSSqlGetDbUserName:='SELECT A.ACCOUNT_ID, A.FIRM_ID, F.SMALL_NAME AS FIRM_SMALL_NAME, A.DB_USER_NAME, A.DB_PASSWORD, A."PASSWORD" '+
                      'FROM /*PREFIX*/ACCOUNTS A '+
                      'LEFT JOIN /*PREFIX*/FIRMS F ON F.FIRM_ID=A.FIRM_ID '+
                      'WHERE UPPER(A.USER_NAME)=%s AND A.LOCKED<>1';
  FSSqlApplicationExists:='SELECT A.LOCKED, P.PROFILE, A.VERSION '+
                          'FROM /*PREFIX*/PROFILES P '+
                          'JOIN /*PREFIX*/APPLICATIONS A ON A.APPLICATION_ID=P.APPLICATION_ID '+
                          'WHERE P.APPLICATION_ID=%s '+
                          'AND P.ACCOUNT_ID=%s';
  FSSqlDeleteStatements:='DELETE FROM MON$STATEMENTS WHERE MON$TRANSACTION_ID IN (%s)';
  FSSqlSessionExists:='SELECT SESSION_ID FROM /*PREFIX*/SESSIONS WHERE SESSION_ID=%s';
  FSSqlSessions:='SELECT SESSION_ID FROM /*PREFIX*/SESSIONS WHERE SESSION_ID IN (%s)';
  FSSqlGetServerDate:='SELECT DISTINCT(CURRENT_TIMESTAMP) FROM /*PREFIX*/APPLICATIONS';
  FSFieldNameQuote:='"';
  FSFormatDateTimeValue:='yyyy-mm-dd hh:nn:ss';
  FSFormatDateValue:='yyyy-mm-dd';
  FSSqlInsert:='INSERT INTO %s (%s) VALUES (%s)';
  FSSqlUpdate:='UPDATE %s SET %s WHERE %s';
  FSSQLGetKeys:='SELECT I.RDB$FIELD_NAME '+
                'FROM RDB$RELATION_CONSTRAINTS RC, RDB$INDEX_SEGMENTS I, RDB$INDICES IDX '+
                'WHERE (I.RDB$INDEX_NAME = RC.RDB$INDEX_NAME) AND '+
                '(IDX.RDB$INDEX_NAME = RC.RDB$INDEX_NAME) AND '+
                '(RC.RDB$CONSTRAINT_TYPE = ''PRIMARY KEY'') AND '+
                '(RC.RDB$RELATION_NAME = %s) '+
                'ORDER BY I.RDB$FIELD_POSITION';
  FSFormatFilterDateValue:='%s';
end;

destructor TBisUIBaseConnection.Destroy;
begin
  FreeAndNilEx(FThreads);
  DeleteAllStatements;
  FTranIDs.Free;
  FSessions.Free;
  FreeAndNilEx(FDatabases);
  inherited Destroy;
end;

function TBisUIBaseConnection.GetSessionsClass: TBisUIBaseSessionsClass;
begin
  Result:=TBisUIBaseSessions;
end;

procedure TBisUIBaseConnection.DeleteAllStatements;

  function Exists: Boolean;
  begin
    FTranIDs.Lock;
    try
      Result:=FTranIDs.Count>0; 
    finally
      FTranIDs.UnLock;
    end;
  end;

var
  Database: TBisUIBaseDatabase;
begin
  if Exists and FConnected then begin
    Database:=CreateDatabase;
    if Assigned(Database) then begin
      try
        DeleteStatements(Database,Null,'');
      finally
        FreeDatabase(Database,false);
      end;
    end;
  end;
end;

procedure TBisUIBaseConnection.DatabaseConnectionLost(Sender: TObject);
begin
  if Assigned(Sender) and (Sender is TBisUIBaseDatabase) then begin
    TBisUIBaseDatabase(Sender).Connected:=false;
    TBisUIBaseDatabase(Sender).UnLock;
  end;
  FConnected:=false;
end;

function TBisUIBaseConnection.CreateDatabase: TBisUIBaseDatabase;

  function GetFirst: TBisUIBaseDatabase;
  var
    i: Integer;
    Item: TBisUIBaseDatabase;
  begin
    FDatabases.Lock;
    try
      Result:=nil;
      for i:=FDatabases.Count-1 downto 0 do begin
        Item:=FDatabases.Items[i];
        if Item.TryLock then begin
          Item.Connected:=true;
          Result:=Item;
          break;
        end;
      end;
    finally
      FDatabases.UnLock;
    end;
  end;

begin
  Result:=GetFirst;
  try
    if not Assigned(Result) then begin
      Result:=TBisUIBaseDatabase.Create(Self);
      Result.DatabaseName:=FDatabaseName;
      Result.UserName:=FUserName;
      Result.Password:=FPassword;
      Result.CharacterSet:=FCharacterSet;
      Result.SQLDialect:=FSQLDialect;
      Result.OnConnectionLost:=DatabaseConnectionLost;
      Result.Connected:=true;

      FDatabases.Lock;
      try
        FDatabases.Add(Result);
        Result.Lock;
      finally
        FDatabases.UnLock;
      end;
    end;
  except
    if Assigned(Result) then
      FreeAndNilEx(Result);
  end;
end;

procedure TBisUIBaseConnection.ThreadDestroy(Thread: TBisThread);
begin
  if Assigned(FThreads) and not FThreads.Destroying then
    FThreads.LockRemove(Thread);
end;

procedure TBisUIBaseConnection.ThreadsItemRemove(Sender: TBisThreads; Item: TBisThread);
var
  Thread: TBisDatabaseSweepThread;
begin
  if Assigned(Item) and (Item is TBisDatabaseSweepThread) then begin
    Thread:=TBisDatabaseSweepThread(Item);
    Thread.FDatabase:=nil;
  end;
end;

{procedure TBisUIBaseConnection.ThreadEnd(Thread: TBisThread; const AException: Exception);
begin
  if Assigned(FThreads) and not FThreads.Destroying then begin
    FThreads.LockRemove(Th);
    try
      FThreads.Remove(Thread);
    finally
      FThreads.OwnsObjects:=true;
      FThreads.UnLock;
    end;
  end;
end;}

procedure TBisUIBaseConnection.ThreadTimeout(Thread: TBisWaitThread);
var
  Database: TBisUIBaseDatabase;
begin
  if Assigned(FDatabases) then begin
    FDatabases.Lock;
    try
      Database:=TBisDatabaseSweepThread(Thread).FDatabase;
      if Assigned(Database) then begin
        if Database.TryLock then begin
          FDatabases.Remove(Database);
          TBisDatabaseSweepThread(Thread).FDatabase:=nil;
          if Assigned(FThreads) then
            FThreads.LockRemove(Thread);
        end else
          Thread.Reset;
      end else
        FThreads.LockRemove(Thread);
    finally
      FDatabases.UnLock;
    end;
  end;
end;

procedure TBisUIBaseConnection.FreeDatabase(Database: TBisUIBaseDatabase; Threaded: Boolean=true);

  function ThreadExists: Boolean;
  var
    i: Integer;
    Item: TBisDatabaseSweepThread;
  begin
    FThreads.Lock;
    try
      Result:=false;
      for i:=0 to FThreads.Count-1 do begin
        Item:=TBisDatabaseSweepThread(FThreads.Items[i]);
        if Item.FDatabase=Database then begin
          Item.Reset;
          Result:=true;
          exit;
        end;
      end;
    finally
      FThreads.UnLock;
    end;
  end;

  procedure ThreadDatabaseNil;
  var
    i: Integer;
    Item: TBisDatabaseSweepThread;
  begin
    FThreads.Lock;
    try
      for i:=0 to FThreads.Count-1 do begin
        Item:=TBisDatabaseSweepThread(FThreads.Items[i]);
        if Item.FDatabase=Database then begin
          Item.FDatabase:=nil;
          Item.Terminate;
        end;
      end;
    finally
      FThreads.UnLock;
    end;
  end;

var
  Thread: TBisDatabaseSweepThread;
begin
  if Threaded then begin
    if Assigned(Database) then begin
      if not ThreadExists then begin
        Thread:=TBisDatabaseSweepThread.Create(FSweepTimeout);
        Thread.OnTimeout:=ThreadTimeout;
//        Thread.OnEnd:=ThreadEnd;
        Thread.OnDestroy:=ThreadDestroy;
        Thread.FreeOnEnd:=true;
        Thread.StopOnDestroy:=false;
        Thread.FDatabase:=Database;

        FThreads.Lock;
        try
          FThreads.Add(Thread);
        finally
          FThreads.UnLock;
        end;

        Thread.Start;
      end;
      Database.UnLock;
    end;
  end else begin
    FDatabases.Lock;
    try
      ThreadDatabaseNil;
      Database.UnLock;
      FDatabases.Remove(Database);
    finally
      FDatabases.UnLock;
    end;
  end;
end;

function TBisUIBaseConnection.CreateTranID(Database: TBisUIBaseDatabase; Tran: TBisUIBaseTransaction;
                                           SessionId: Variant; DataSet: TBisDataSet): TBisUIBaseTranID;
var
  TranID: Cardinal;
  TraHandle: IscTrHandle;
  CheckSum: String;                       
begin
  Result:=nil;
  if Assigned(Database) and Assigned(Tran) then begin
    TraHandle:=Tran.TrHandle;
    TranID:=Database.Lib.TransactionGetId(TraHandle);

    CheckSum:='';
    if Assigned(DataSet) then
      CheckSum:=DataSet.CheckSum;

    FTranIDs.Lock;
    try
      Result:=FTranIDs.Add(TranID,SessionId,CheckSum);
      Result.Database:=Database;
    finally
      FTranIDs.UnLock;
    end;
  end;
end;

procedure TBisUIBaseConnection.FreeTranID(TranID: TBisUIBaseTranID);
begin
  FTranIDs.Lock;
  try
    FTranIDs.Remove(TranID);
  finally
    FTranIDs.UnLock;
  end;
end;

function TBisUIBaseConnection.TranIDExists(TranID: TBisUIBaseTranID): Boolean;
begin
  FTranIDs.Lock;
  try
    Result:=FTranIDs.IndexOf(TranID)>-1;
  finally
    FTranIDs.UnLock;
  end;
end;

{function TBisUIBaseConnection.CloneConnection(const SessionId: Variant; WithDefault: Boolean=true): TBisConnection;
var
  Clone: TBisUIBaseConnection;
  Item, Session: TBisUIBaseSession;
begin
  Result:=inherited CloneConnection(SessionId);
  if Assigned(Result) and (Result is TBisUIBaseConnection) then begin
{    Clone:=TBisUIBaseConnection(Result);
    if WithDefault then begin
      Clone.FDefaultDatabase.CopyFrom(FDefaultDatabase);
      Clone.FDefaultDatabase.Connected:=FDefaultDatabase.Connected;
      CLone.FLinkedRealDefaultDatabase:=nil;
    end else
      CLone.FLinkedRealDefaultDatabase:=FDefaultDatabase;
    Item:=FSessions.Find(SessionId);
    if Assigned(Item) then begin
      Session:=Clone.Sessions.Add(Item.SessionId,Item.DateCreate,Item.ApplicationId,
                                  Item.AccountId,Item.UserName,Item.Password,
                                  Item.Database.UserName,Item.Database.Password,
                                  Item.Params.Text,Item.IPList.Text,false);
      if Assigned(Session) then begin
        Session.Roles.Text:=Item.Roles.Text;
        Session.Permissions.CreateTable(Item.Permissions);
        Session.Permissions.CopyRecords(Item.Permissions);
        Session.Locks.CreateTable(Item.Locks);
        Session.Locks.CopyRecords(Item.Locks);
      end;
    end;
  end;
end;    }

{procedure TBisUIBaseConnection.RemoveConnection(Connection: TBisConnection; const SessionId: Variant; IsLogout: Boolean);
var
  Session: TBisUIBaseSession;
begin
  if Assigned(Connection) and (Connection is TBisUIBaseConnection) and (Connection<>Self) then begin
 {   if IsLogout then begin
      Session:=FSessions.Find(SessionId);
      if Assigned(Session) then
        FSessions.Remove(Session,false);
    end else
      FSessions.CopyFrom(TBisUIBaseConnection(Connection).Sessions,false);
  end;
  inherited RemoveConnection(Connection,SessionId,IsLogout);
end;}

procedure TBisUIBaseConnection.ChangeParams(Sender: TObject);
{var
  i: Integer;
  Param: TBisConnectionParam;
  N: String;}
begin

  FDatabaseName:=Params.AsString(SDBParamDatabase);
  FUserName:=Params.AsString(SDBParamUserName);
  FPassword:=Params.AsString(SDBParamPassword);
  FCharacterSet:=Params.AsEnumeration(SDBParamCharacterSet,TypeInfo(TCharacterSet),FCharacterSet);
  FCheckVersion:=Params.AsBoolean(SDBParamCheckVersion,true);
  FMaxRecordCount:=Params.AsInteger(SDBParamMaxRecordCount,FMaxRecordCount);
  FPrefix:=Params.AsString(SDBParamPrefix);
  FTimeout:=Params.AsInteger(SDBParamTimeOut);
  FSweepTimeout:=Params.AsInteger(SDBParamSweepTimeOut,FSweepTimeout);

{  for i:=0 to Params.Count-1 do begin
    Param:=Params.Items[i];
    N:=Param.ParamName;

    if AnsiSameText(N,SDBParamDatabase) then FDatabaseName:=Param.Value;
    if AnsiSameText(N,SDBParamUserName) then FUserName:=Param.Value;
    if AnsiSameText(N,SDBParamPassword) then FPassword:=Param.Value;
    if AnsiSameText(N,SDBParamCharacterSet) then FCharacterSet:=TCharacterSet(StrToIntDef(Param.Value,Integer(FCharacterSet)));
    if AnsiSameText(N,SDBParamCheckVersion) then FCheckVersion:=Boolean(StrToIntDef(Param.Value,Integer(True)));
    if AnsiSameText(N,SDBParamMaxRecordCount) then FMaxRecordCount:=StrToIntDef(Param.Value,FMaxRecordCount);
    if AnsiSameText(N,SDBParamPrefix) then FPrefix:=Param.Value;
    if AnsiSameText(N,SDBParamTimeOut) then FTimeout:=StrToIntDef(Param.Value,0);
    if AnsiSameText(N,SDBParamSweepTimeOut) then FSweepTimeout:=StrToIntDef(Param.Value,FSweepTimeout);

  end;}
end;

function TBisUIBaseConnection.PreparePrefix(AName: String): String;
begin
  Result:=Format('%s%s',[FPrefix,AName]);
end;

procedure TBisUIBaseConnection.Init;
begin
  inherited Init;
  ChangeParams(Params);
end;

function TBisUIBaseConnection.GetDbUserName(Database: TBisUIBaseDatabase; UserName, Password: String;
                                            var AccountId, FirmId, FirmSmallName: Variant;
                                            var DbUserName, DbPassword: String): Boolean;
var
  Query: TBisUIBaseQuery;
  Tran: TBisUIBaseTransaction;
  Sql: String;
  AAccountId: String;
  NewPass: String;
  MD: String;
begin
  Result:=false;
  if Database.Connected then begin
    Query:=TBisUIBaseQuery.Create(nil);
    Tran:=TBisUIBaseTransaction.Create(nil);
    try
      Tran.DataBase:=Database;
      Tran.TimeOut:=FTimeOut;
      Query.Transaction:=Tran;
      Sql:=FormatEx(FSSqlGetDbUserName,[QuotedStr(AnsiUpperCase(UserName))]);
      Query.SQL.Text:=ReplaceText(Sql,SPrefix,FPrefix);
      Query.Open;
      if Query.Active and not Query.IsEmpty then begin
        NewPass:=Query.Fields.ByNameAsString['PASSWORD'];
        AAccountId:=Query.Fields.ByNameAsString['ACCOUNT_ID'];
        MD:=MD5(AAccountId+Password+AAccountId);
        if (NewPass=Password) or AnsiSameText(NewPass,MD) then begin
          AccountId:=Query.Fields.ByNameAsVariant['ACCOUNT_ID'];
          FirmId:=Query.Fields.ByNameAsVariant['FIRM_ID'];
          FirmSmallName:=Query.Fields.ByNameAsVariant['FIRM_SMALL_NAME'];
          DbUserName:=Query.Fields.ByNameAsString['DB_USER_NAME'];
          DbPassword:=Query.Fields.ByNameAsString['DB_PASSWORD'];
          Result:=true;
        end;
      end;
    finally
      Tran.Free;
      Query.Free;
    end;
  end;
end;

function TBisUIBaseConnection.ApplicationExists(Database: TBisUIBaseDatabase;
                                                ApplicationId,AccountId: Variant; Version: String): Boolean;
var
  Query: TBisUIBaseQuery;
  Tran: TBisUIBaseTransaction;
  Sql: String;
begin
  Result:=false;
  if Database.Connected then begin
    Query:=TBisUIBaseQuery.Create(nil);
    Tran:=TBisUIBaseTransaction.Create(nil);
    try
      Tran.DataBase:=Database;
      Tran.TimeOut:=FTimeOut;
      Query.Transaction:=Tran;
      Sql:=FormatEx(FSSqlApplicationExists,[QuotedStr(VarToStrDef(ApplicationId,'')),QuotedStr(VarToStrDef(AccountId,''))]);
      Query.SQL.Text:=ReplaceText(Sql,SPrefix,FPrefix);
      Query.Open;
      if Query.Active and not Query.IsEmpty then begin
        Result:=not Boolean(Query.Fields.ByNameAsInteger['LOCKED']);
        if Result and FCheckVersion then
          Result:=AnsiSameText(Query.Fields.ByNameAsString['VERSION'],Version);
      end;
    finally
      Tran.Free;
      Query.Free;
    end;
  end;
end;

procedure TBisUIBaseConnection.DeleteStatements(Database: TBisUIBaseDatabase; SessionId: Variant; DataSetCheckSum: String);

  function GetTranIDs(SessionId: Variant; var List: TObjectList): String;
  var
    i: Integer;
    Item: TBisUIBaseTranID;
    Flag: Boolean;
  begin
    FTranIDs.Lock;
    try
      Result:='';
      for i:=0 to FTranIDs.Count-1 do begin
        Item:=FTranIDs.Items[i];
        Flag:=true;
        if not VarIsNull(SessionId) then begin
          Flag:=VarSameValue(Item.SessionId,SessionId);
          if Flag and (Trim(DataSetCheckSum)<>'') then
            Flag:=AnsiSameText(Item.DataSetCheckSum,DataSetCheckSum); 
        end;
        if Flag then begin
          Result:=iff(Result<>'',Result+',','')+IntToStr(Item.TranID);
          if Assigned(List) then
            List.Add(Item);
        end;
      end;
    finally
      FTranIDs.UnLock;
    end;
  end;

  procedure DeleteTranIDs(List: TObjectList);
  var
    i: Integer;
  begin
    FTranIDs.Lock;
    try
      for i:=0 to List.Count-1 do
        FTranIDs.Remove(List[i]);
    finally
      FTranIDs.UnLock;
    end;
  end;

var
  Query: TBisUIBaseQuery;
  Tran: TBisUIBaseTransaction;
  S: String;
  List: TObjectList;
  Sql: String;
begin
  List:=TObjectList.Create(false);
  try
    S:=GetTranIDs(SessionId,List);
    if Database.Connected and (Trim(S)<>'') then begin
      Query:=TBisUIBaseQuery.Create(nil);
      Tran:=TBisUIBaseTransaction.Create(nil);
      try
        Tran.DataBase:=Database;
        Tran.TimeOut:=FTimeOut;
        Tran.Options:=[tpWrite,tpReadCommitted,tpRecVersion,tpNoWait];
        Query.Transaction:=Tran;
        Sql:=FormatEx(FSSqlDeleteStatements,[S]);
        LoggerWrite(FormatEx(FSDeleteStatementsSql,[SQL]));
        Query.SQL.Text:=Sql;
        Query.ExecSQL;
        Tran.Commit;
        DeleteTranIDs(List);
      finally
        Tran.Free;
        Query.Free;
      end;
    end;
  finally
    List.Free;
  end;
end;

function TBisUIBaseConnection.SessionExists(Database: TBisUIBaseDatabase; SessionId: Variant): Boolean;
var
  Query: TBisUIBaseQuery;
  Tran: TBisUIBaseTransaction;
  Sql: String;
begin
  Result:=false;
  if Database.Connected then begin
    Query:=TBisUIBaseQuery.Create(nil);
    Tran:=TBisUIBaseTransaction.Create(nil);
    try
      Tran.Database:=Database;
      Tran.TimeOut:=FTimeOut;
      Query.Transaction:=Tran;
      Sql:=FormatEx(FSSqlSessionExists,[QuotedStr(VarToStrDef(SessionId,''))]);
      Query.SQL.Text:=ReplaceText(Sql,SPrefix,FPrefix);
      Query.Open;
      Result:=Query.Active and not Query.IsEmpty;
    finally
      Tran.Free;
      Query.Free;
    end;
  end;
end;

function TBisUIBaseConnection.SessionFind(Database: TBisUIBaseDatabase; SessionId: Variant): TBisUIBaseSession;
var
  Exists: Boolean;
begin
  Exists:=SessionExists(Database,SessionId);
  Result:=FSessions.Find(SessionId);
  if not Exists and Assigned(Result) then begin
    Result.Delete(Database);
    FSessions.Remove(Result,true);
    Result:=nil;
  end;
end;

function TBisUIBaseConnection.GetSessionIDs: String;
var
  i: Integer;
  Item: TBisUIBaseSession;
begin
  FSessions.Lock;
  try
    Result:='';
    for i:=0 to FSessions.Count-1 do begin
      Item:=FSessions.Items[i];
      if Trim(Item.SessionId)<>'' then begin
        Result:=iff(Result<>'',Result+',','')+QuotedStr(Item.SessionId);
      end;
    end;
  finally
    FSessions.UnLock;
  end;
end;

procedure TBisUIBaseConnection.CheckSessions(Database: TBisUIBaseDatabase);
var
  Query: TBisUIBaseQuery;
  Tran: TBisUIBaseTransaction;
  Sql: String;
  S: String;
  Session: TBisUIBaseSession;
  i: Integer;
  Strings: TStringList;
begin
  S:=GetSessionIDs;
  if Database.Connected and (Trim(S)<>'') then begin
    Query:=TBisUIBaseQuery.Create(nil);
    Tran:=TBisUIBaseTransaction.Create(nil);
    try
      Tran.Database:=Database;
      Tran.TimeOut:=FTimeOut;
      Query.Transaction:=Tran;
      Sql:=FormatEx(FSSqlSessions,[S]);
      Query.SQL.Text:=ReplaceText(Sql,SPrefix,FPrefix);
      Query.Open;
      if Query.Active then begin
        Strings:=TStringList.Create;
        FSessions.Lock;
        try
          Query.First;
          while not Query.Eof do begin
            Strings.Add(Query.Fields.AsString[0]);
            Query.Next;
          end;
          for i:=FSessions.Count-1 downto 0 do begin
            Session:=FSessions.Items[i];
            if Strings.IndexOf(VarToStrDef(Session.SessionId,''))=-1 then
              FSessions.Remove(Session,false);
          end;
        finally
          FSessions.UnLock;
          Strings.Free;
        end;
      end;
    finally
      Tran.Free;
      Query.Free;
    end;
  end;
end;

function TBisUIBaseConnection.GetFieldNameQuote: String;
begin
  Result:=FSFieldNameQuote;
end;

function TBisUIBaseConnection.GetRecordsFilterDateValue(Value: TDateTime): String;
var
  D: TDate;
begin
  D:=DateOf(Value);
  if D<>Value then
    Result:=FormatEx(FSFormatFilterDateValue,[QuotedStr(FormatDateTime(FSFormatDateTimeValue,Value))])
  else
    Result:=FormatEx(FSFormatFilterDateValue,[QuotedStr(FormatDateTime(FSFormatDateValue,Value))]);
end;

function TBisUIBaseConnection.GetConnected: Boolean;
begin
  Result:=FConnected;
end;

{function TBisUIBaseConnection.GetWorking: Boolean;
begin
  Result:=FWorking;
end;}

function TBisUIBaseConnection.GetSessionCount: Integer;
begin
  FSessions.Lock;
  try
    Result:=FSessions.Count;
  finally
    FSessions.UnLock;
  end;
end;

function TBisUIBaseConnection.SessionExists(const SessionId: Variant): Boolean;
var
  Session: TBisUIBaseSession;
begin
  Session:=FSessions.Find(SessionId);
  Result:=Assigned(Session);
end;

procedure TBisUIBaseConnection.Connect;
var
  Database: TBisUIBaseDatabase;
begin
  FConnected:=false;
  Database:=CreateDatabase;
  if Assigned(Database) then begin
    try
      FConnected:=Database.Connected;
    finally
      FreeDatabase(Database);
    end;
  end;
end;

procedure TBisUIBaseConnection.Disconnect;
begin
  if GetSessionCount=0 then
    FConnected:=false;
end;

function TBisUIBaseConnection.GetTableName(SQL: String; var Where: String): String;
var
  APos: Integer;
  i: Integer;
  Ch: Char;
const
  Chars=[' ',#13,#10,#0];
begin
  Result:='';
  APos:=Pos(UpperCase(SFrom),UpperCase(SQL));
  if APos>0 then begin
    Result:=Copy(SQL,APos+Length(SFrom)+1,Length(SQL));
    for i:=1 to Length(Result) do begin
      Ch:=Result[i];
      if Ch in Chars then begin
        Result:=Copy(Result,1,i-1);
        Result:=Trim(Result);
        break;
      end;
    end;
  end;
  APos:=Pos(UpperCase(SWhere),UpperCase(SQL));
  if APos>0 then begin
    Where:=Copy(SQL,APos+Length(SWhere)+1,Length(SQL));
  end;
end;

procedure TBisUIBaseConnection.ImportScript(Database: TBisUIBaseDatabase; Stream: TStream);
var
  Query: TBisUIBaseQuery;
  Tran: TBisUIBaseTransaction;
  SQL: String;
begin
  if (Stream.Size>0) and Database.Connected then begin
    Stream.Position:=0;
    SetLength(SQL,Stream.Size);
    Stream.ReadBuffer(Pointer(SQL)^,Stream.Size);
    if Trim(SQL)<>'' then begin
      LoggerWrite(FSImportScriptStart);
      try
        Query:=TBisUIBaseQuery.Create(nil);
        Tran:=TBisUIBaseTransaction.Create(nil);
        try
          Tran.Database:=Database;
          Tran.TimeOut:=FTimeOut;
          Tran.Options:=[tpWrite,tpReadCommitted,tpRecVersion,tpNoWait];
          Query.Transaction:=Tran;
          Query.ParseParams:=false;
          SQL:=Trim(SQL);
          LoggerWrite(FormatEx(FSImportScriptSql,[SQL]));
          Query.SQL.Text:=ReplaceText(SQL,SPrefix,FPrefix);
          try
            Query.ExecSQL;
            Tran.Commit;
            LoggerWrite(FSImportScriptSuccess);
          except
            On E: Exception do begin
              Tran.Rollback;
              raise Exception.Create(E.Message);
            end;
          end;
        finally
          Tran.Free;
          Query.Free;
        end;
      except
        On E: Exception do begin
          LoggerWrite(FormatEx(FSImportScriptFail,[E.Message]),ltError);
          raise;
        end;
      end;
    end;
  end;
end;

procedure TBisUIBaseConnection.ImportTable(Database: TBisUIBaseDatabase; Stream: TStream);

  procedure GetKeys(TableName: String; Keys: TStrings);
  var
    Query: TBisUIBaseQuery;
    Tran: TBisUIBaseTransaction;
    SQL: String;
  begin
    Query:=TBisUIBaseQuery.Create(nil);
    Tran:=TBisUIBaseTransaction.Create(nil);
    try
      Tran.Database:=Database;
      Tran.TimeOut:=FTimeOut;
      Query.Transaction:=Tran;
      SQL:=FormatEx(FSSQLGetKeys,[QuotedStr(PreparePrefix(TableName))]);
      SQL:=ReplaceText(SQL,SPrefix,FPrefix);
      Query.SQL.Text:=SQL;
      Query.Open;
      if Query.Active and not Query.IsEmpty then begin
        Query.First;
        while not Query.Eof do begin
          Keys.Add(Trim(Query.Fields.AsString[0]));
          Query.Next;
        end;
      end;
    finally
      Tran.Free;
      Query.Free;
    end;
  end;

  procedure DumpParams(Query: TBisUIBaseQuery);
  var
    S: String;
    S1: String;
    S2: String;
    S3: String;
    i: Integer;
//    Stream: TMemoryStream;
  begin
    if Assigned(Query.Params) then begin
      for i:=0 to Query.Params.FieldCount-1 do begin
        if Query.Params.IsNull[i] then
          S1:=SNull
        else begin
          if not Query.Params.IsBlob[i] then
            S1:=VarToStrDef(Query.Params.AsVariant[i],'')
          else begin
            S1:='';
{            Stream:=TMemoryStream.Create;
            try
              S1:=Query.Params.AsString[i];
            finally
              Stream.Free;
            end;}
          end;
        end;
        if Length(S1)>MaxValueSize then
          S1:=Copy(S1,1,MaxValueSize)+'...';

        S:=Query.Params.FieldName[i];
        S2:=GetEnumName(TypeInfo(DB.TParamType),Integer(ptInput));
        S3:=GetEnumName(TypeInfo(TUIBFieldType),Integer(Query.Params.FieldType[i]));
        LoggerWrite(FormatEx(FSImportTableParam,[S,S2,S3,S1]));
      end;
    end;
  end;

  function TryInsert(DataSet: TBisDataSet; var Error: String): Boolean;
  var
    Query: TBisUIBaseQuery;
    Tran: TBisUIBaseTransaction;
    i: Integer;
    Field: TField;
    Fields: String;
    Values: String;
    SQL: String;
    Stream: TMemoryStream;
  begin
    Result:=false;
    try
      Query:=TBisUIBaseQuery.Create(nil);
      Tran:=TBisUIBaseTransaction.Create(nil);
      Stream:=TMemoryStream.Create;
      try
        Tran.Database:=Database;
        Tran.TimeOut:=FTimeOut;
        Tran.Options:=[tpWrite,tpReadCommitted,tpRecVersion,tpNoWait];
        Query.Transaction:=Tran;
        Query.ParseParams:=true;
        for i:=0 to DataSet.FieldCount-1 do begin
          Field:=DataSet.Fields[i];
          if i=0 then begin
            Fields:=FSFieldNameQuote+Field.FieldName+FSFieldNameQuote;
            Values:=':'+Field.FieldName;
          end else begin
            Fields:=Fields+','+FSFieldNameQuote+Field.FieldName+FSFieldNameQuote;
            Values:=Values+',:'+Field.FieldName;
          end;
        end;
        SQL:=FormatEx(FSSqlInsert,[PreparePrefix(DataSet.TableName),Fields,Values]);
        SQL:=ReplaceText(SQL,SPrefix,FPrefix);
        LoggerWrite(FormatEx(FSImportTableSql,[SQL]));
        Query.SQL.Text:=SQL;

        for i:=0 to Query.Params.FieldCount-1 do begin
          Field:=DataSet.FindField(Query.Params.FieldName[i]);
          if Assigned(Field) then begin
            if not Field.IsBlob then
              Query.Params.AsVariant[i]:=Field.Value
            else begin
              Stream.Clear;
              TBlobField(Field).SaveToStream(Stream);
              Stream.Position:=0;
              Query.ParamsSetBlob(i,Stream);
            end;  
          end;
        end;

        DumpParams(Query);

        Query.ExecSQL;
        Tran.Commit;
        Result:=true;
      finally
        Stream.Free;
        Tran.Free;
        Query.Free;
      end;
    except
      On E: Exception do begin
        Error:=E.Message;
      end;
    end;
  end;

  function TryUpdate(DataSet: TBisDataSet; Keys: TStringList; var Error: String): Boolean;
  var
    Query: TBisUIBaseQuery;
    Tran: TBisUIBaseTransaction;
    i: Integer;
    Field: TField;
    FieldValues: String;
    Condition: String;
    SQL: String;
    Stream: TMemoryStream;
  begin
    Result:=false;
    try
      Query:=TBisUIBaseQuery.Create(nil);
      Tran:=TBisUIBaseTransaction.Create(nil);
      Stream:=TMemoryStream.Create;
      try
        Tran.Database:=Database;
        Tran.TimeOut:=FTimeOut;
        Tran.Options:=[tpWrite,tpReadCommitted,tpRecVersion,tpNoWait];
        Query.Transaction:=Tran;
        Query.ParseParams:=true;
        for i:=0 to DataSet.FieldCount-1 do begin
          Field:=DataSet.Fields[i];
          if i=0 then begin
            FieldValues:=FSFieldNameQuote+Field.FieldName+FSFieldNameQuote;
          end else begin
            FieldValues:=FieldValues+','+FSFieldNameQuote+Field.FieldName+FSFieldNameQuote;
          end;
          FieldValues:=FieldValues+'=:'+Field.FieldName;
        end;
        for i:=0 to Keys.Count-1 do begin
          if i=0 then
            Condition:=FSFieldNameQuote+Keys[i]+FSFieldNameQuote
          else
            Condition:=Condition+' '+GetRecordsFilterOperator(foAnd)+' '+FSFieldNameQuote+Keys[i]+FSFieldNameQuote;
          Condition:=Condition+'=:'+Keys[i];
        end;
        SQL:=FormatEx(FSSqlUpdate,[PreparePrefix(DataSet.TableName),FieldValues,Condition]);
        SQL:=ReplaceText(SQL,SPrefix,FPrefix);
        LoggerWrite(FormatEx(FSImportTableSql,[SQL]));
        Query.SQL.Text:=SQL;

        for i:=0 to Query.Params.FieldCount-1 do begin
          Field:=DataSet.FindField(Query.Params.FieldName[i]);
          if Assigned(Field) then begin
            if not Field.IsBlob then
              Query.Params.AsVariant[i]:=Field.Value
            else begin
              Stream.Clear;
              TBlobField(Field).SaveToStream(Stream);
              Stream.Position:=0;
              Query.ParamsSetBlob(i,Stream);
            end;  
          end;
        end;
        
        Query.ExecSQL;
        Tran.Commit;
        Result:=true;
      finally
        Stream.Free;
        Tran.Free;
        Query.Free;
      end;
    except
      On E: Exception do begin
        Error:=E.Message;
      end;
    end;
  end;

var
  DataSet: TBisDataSet;
  Error: String;
  Keys: TStringList;
begin
  if (Stream.Size>0) and Database.Connected then begin
    LoggerWrite(FSImportTableStart);
    try
      DataSet:=TBisDataSet.Create(nil);
      Keys:=TStringList.Create;
      try
        DataSet.LoadFromStream(Stream);
        DataSet.Open;
        if DataSet.Active and not DataSet.Empty then begin
          GetKeys(DataSet.TableName,Keys);
          DataSet.First;
          while not DataSet.Eof do begin

           Error:='';
            if not TryInsert(DataSet,Error) then
              if not TryUpdate(DataSet,Keys,Error) then
                raise Exception.Create(Error);

            DataSet.Next;
          end;
          LoggerWrite(FSImportTableSuccess);
        end else
          LoggerWrite(FSImportTableEmpty);
      finally
        Keys.Free;
        DataSet.Free;
      end;
    except
      On E: Exception do begin
        LoggerWrite(FormatEx(FSImportTableFail,[E.Message]),ltError);
        raise;
      end;
    end;
  end;
end;

procedure TBisUIBaseConnection.Import(ImportType: TBisConnectionImportType; Stream: TStream);
var
  Database: TBisUIBaseDatabase;
begin
  if Assigned(Stream) then begin
    Database:=CreateDatabase;
    if Assigned(Database) then begin
      try
        case ImportType of
          itScript: ImportScript(Database,Stream);
          itTable: ImportTable(Database,Stream);
        end;
      finally
        FreeDatabase(Database);
      end;
    end;
  end;
end;

procedure TBisUIBaseConnection.ExportScript(Database: TBisUIBaseDatabase; const Value: String;
                                            Stream: TStream; Params: TBisConnectionExportParams=nil);
begin
  //
end;

procedure TBisUIBaseConnection.ExportTable(Database: TBisUIBaseDatabase; const Value: String;
                                           Stream: TStream; Params: TBisConnectionExportParams=nil);
var
  Query: TBisUIBaseQuery;
  Tran: TBisUIBaseTransaction;
  DataSet: TBisDataSet;
  TableName: String;
  Where: String;
  FromPos, FetchCount: Integer;
  Position: Integer;
begin
  if Database.Connected then begin
    try
      Query:=TBisUIBaseQuery.Create(nil);
      Tran:=TBisUIBaseTransaction.Create(nil);
      DataSet:=TBisDataSet.Create(nil);
      try
        FromPos:=0;
        FetchCount:=MaxInt;
        if Assigned(Params) then begin
          FromPos:=Params.FromPosition;
          if FromPos<0 then
            FromPos:=0;
          FetchCount:=Params.FetchCount;
          if FetchCount<0 then
            FetchCount:=MaxInt;
        end;
        Tran.Database:=Database;
        Tran.TimeOut:=FTimeOut;
        Query.Transaction:=Tran;
        Query.Sql.Text:=Value;
        Query.Open;
        if Query.Active then begin
          TableName:=GetTableName(Value,Where);
          Position:=0;
          Query.First;
          Query.CreateTableTo(DataSet);
          while not Query.Eof do begin
            if Position>=FromPos then begin
              if Position<(FromPos+FetchCount) then
                Query.CopyRecordTo(DataSet)
              else
                break;
            end;
            Inc(Position);
            Query.Next;
          end;
          DataSet.TableName:=TableName;
          DataSet.SaveToStream(Stream);
        end;
      finally
        DataSet.Free;
        Tran.Free;
        Query.Free;
      end;
    except
      On E: Exception do begin
        raise;
      end;
    end;
  end;
end;

procedure TBisUIBaseConnection.Export(ExportType: TBisConnectionExportType; const Value: String;
                                      Stream: TStream; Params: TBisConnectionExportParams=nil);
var
  Database: TBisUIBaseDatabase;
begin
  if Assigned(Stream) then begin
    Database:=CreateDatabase;
    if Assigned(Database) then begin
      try
        case ExportType of
          etScript: ExportScript(Database,Value,Stream,Params);
          etTable: ExportTable(Database,Value,Stream,Params);
        end;
      finally
        FreeDatabase(Database);
      end;
    end;
  end;
end;

function TBisUIBaseConnection.GetInternalServerDate(Database: TBisUIBaseDatabase): TDateTime;
var
  Query: TBisUIBaseQuery;
  Tran: TBisUIBaseTransaction;
  Sql: String;
  Value: Variant;
begin
  Result:=Now;
  if Database.Connected then begin
    Query:=TBisUIBaseQuery.Create(nil);
    Tran:=TBisUIBaseTransaction.Create(nil);
    try
      Tran.DataBase:=Database;
      Tran.TimeOut:=FTimeOut;
      Query.Transaction:=Tran;
      Sql:=FSSqlGetServerDate;
      Query.SQL.Text:=ReplaceText(Sql,SPrefix,FPrefix);
      Query.Open;
      if Query.Active and not Query.IsEmpty then begin
        Value:=Query.Fields.AsVariant[0];
        if not VarIsNull(Value) then
          Result:=VarToDateDef(Value,Result);
      end;
    finally
      Tran.Free;
      Query.Free;
    end;
  end;
end;

function TBisUIBaseConnection.GetServerDate: TDateTime;
var
  Database: TBisUIBaseDatabase;
begin
  Result:=inherited GetServerDate;
  Database:=CreateDatabase;
  if Assigned(Database) then begin
    try
      Result:=GetInternalServerDate(Database);
    finally
      FreeDatabase(Database);
    end;
  end;
end;

function TBisUIBaseConnection.Login(const ApplicationId: Variant; const UserName,Password: String;
                                    Params: TBisConnectionLoginParams=nil): Variant;
var
  Database: TBisUIBaseDatabase;
  UserDefault: Boolean;
  AccountId: Variant;
  FirmId: Variant;
  FirmSmallName: Variant;
  DbUserName: String;
  DbPassword: String;
  ASession: TBisUIBaseSession;
  SessionParams, IPList: String;
  Version: String;
  DateCreate: TDateTime;
begin
  Database:=CreateDatabase;
  if Assigned(Database) then begin
    try
      CheckSessions(Database);
      
      if GetDbUserName(Database,UserName,Password,AccountId,FirmId,FirmSmallName,DbUserName,DbPassword) then begin

        Version:='';
        if Assigned(Params) then
          Version:=Params.Version;

        if ApplicationExists(Database,ApplicationId,AccountId,Version) then begin

          UserDefault:=(Trim(DbUserName)='') or
                        AnsiSameText(Database.UserName,DbUserName);
          if UserDefault then begin
            DbUserName:=Database.UserName;
            DbPassword:=Database.Password;
          end;

          if Assigned(Params) then begin
            SessionParams:=Params.SessionParams.Text;
            IPList:=Params.IPList.Text;
          end;

          DateCreate:=GetInternalServerDate(Database);

          ASession:=FSessions.Add(Database,GetUniqueID,DateCreate,
                                  ApplicationId,AccountId,UserName,Password,
                                  DbUserName,DbPassword,SessionParams,IPList);
          if Assigned(ASession) then begin
            try
              if Assigned(Params) then begin
                Params.AccountId:=AccountId;
                Params.FirmId:=FirmId;
                Params.FirmSmallName:=FirmSmallName;
              end;

              ASession.CheckLocks(SLogin);
              Result:=ASession.SessionId;
            except
              on E: Exception do begin
                FSessions.Remove(ASession,true);
                raise;
              end;
            end;
          end else
            raise Exception.Create(SSessionCreateFailed);

        end else
          raise Exception.Create(SApplicationNotFoundOrLocked);

      end else
        raise Exception.CreateFmt(SAccountNotFoundOrLocked,[UserName]);


    finally
      FreeDatabase(Database);
    end;
  end;
end;

procedure TBisUIBaseConnection.Logout(const SessionId: Variant);
var
  Session: TBisUIBaseSession;
  Database: TBisUIBaseDatabase;
begin
  Database:=CreateDatabase;
  if Assigned(Database) then begin
    try
      Session:=SessionFind(Database,SessionId);
      if Assigned(Session) then begin
        Database.SetSession(Session);
        Session.Update(Database);
        Session.CheckLocks(SLogout);
        Session.Delete(Database);
        DeleteStatements(Database,SessionId,'');
        FSessions.Remove(Session,true);
      end;
    finally
      FreeDatabase(Database);
    end;
  end;
end;

function TBisUIBaseConnection.Check(const SessionId: Variant; var ServerDate: TDateTime): Boolean;
var
  Session: TBisUIBaseSession;
  Database: TBisUIBaseDatabase;
begin
  Result:=inherited Check(SessionId,ServerDate);
  Database:=CreateDatabase;
  if Assigned(Database) then begin
    try
      Session:=SessionFind(Database,SessionId);
      ServerDate:=GetInternalServerDate(Database);
      Result:=Assigned(Session);
    finally
      FreeDatabase(Database);
    end;
  end;
end;

procedure TBisUIBaseConnection.Update(const SessionId: Variant; Params: TBisConfig=nil);
var
  Session: TBisUIBaseSession;
  T, F: Int64;
  Database: TBisUIBaseDatabase;
begin
  Database:=CreateDatabase;
  if Assigned(Database) then begin
    try
      Session:=SessionFind(Database,SessionId);
      if Assigned(Session) then begin
        T:=GetTickCount(F);
        try
          Database.SetSession(Session);
          Session.CheckLocks(SRefreshPermissions);
          Session.Params.CopyFrom(Params);
        finally
          Session.Update(Database,Assigned(Params),'',GetTickDifference(T,F,dtMilliSec));
        end;
      end else
        raise Exception.Create(SInvalidSession);
    finally
      FreeDatabase(Database);
    end;
  end;
end;

procedure TBisUIBaseConnection.LoadProfile(const SessionId: Variant; Profile: TBisProfile);
var
  Session: TBisUIBaseSession;
  T, F: Int64;
  Database: TBisUIBaseDatabase;
begin
  Database:=CreateDatabase;
  if Assigned(Database) then begin
    try
      Session:=SessionFind(Database,SessionId);
      if Assigned(Session) and Assigned(Profile) then begin
        T:=GetTickCount(F);
        try
          Database.SetSession(Session);
          Session.CheckLocks(SLoadProfile);
          Session.LoadProfile(Database,Profile);
        finally
          Session.Update(Database,False,'',GetTickDifference(T,F,dtMilliSec));
        end;
      end else
        raise Exception.Create(SInvalidSession);
    finally
      FreeDatabase(Database);
    end;
  end;
end;

procedure TBisUIBaseConnection.SaveProfile(const SessionId: Variant; Profile: TBisProfile);
var
  Session: TBisUIBaseSession;
  T, F: Int64;
  Database: TBisUIBaseDatabase;
begin
  Database:=CreateDatabase;
  if Assigned(Database) then begin
    try
      Session:=SessionFind(Database,SessionId);
      if Assigned(Session) and Assigned(Profile) then begin
        T:=GetTickCount(F);
        try
          Database.SetSession(Session);
          Session.CheckLocks(SSaveProfile);
          Session.SaveProfile(Database,Profile);
        finally
          Session.Update(Database,False,'',GetTickDifference(T,F,dtMilliSec));
        end;
      end else
        raise Exception.Create(SInvalidSession);
    finally
      FreeDatabase(Database);
    end;
  end;
end;

procedure TBisUIBaseConnection.RefreshPermissions(const SessionId: Variant);
var
  Session: TBisUIBaseSession;
  T, F: Int64;
  Database: TBisUIBaseDatabase;
begin
  Database:=CreateDatabase;
  if Assigned(Database) then begin
    try
      Session:=SessionFind(Database,SessionId);
      if Assigned(Session) then begin
        T:=GetTickCount(F);
        try
          Database.SetSession(Session);
          Session.CheckLocks(SRefreshPermissions);
          Session.LoadRoles(Database);
          Session.LoadPermissions(Database);
        finally
          Session.Update(Database,False,'',GetTickDifference(T,F,dtMilliSec));
        end;
      end else
        raise Exception.Create(SInvalidSession);
    finally
      FreeDatabase(Database);
    end;
  end;
end;

procedure TBisUIBaseConnection.LoadInterfaces(const SessionId: Variant; Interfaces: TBisInterfaces);
var
  Session: TBisUIBaseSession;
  T, F: Int64;
  Database: TBisUIBaseDatabase;
begin
  Database:=CreateDatabase;
  if Assigned(Database) then begin
    try
      Session:=SessionFind(Database,SessionId);
      if Assigned(Session) and Assigned(Interfaces) then begin
        T:=GetTickCount(F);
        try
          Database.SetSession(Session);
          Session.CheckLocks(SLoadInterfaces);
          Session.LoadInterfaces(Database,Interfaces);
        finally
          Session.Update(Database,False,'',GetTickDifference(T,F,dtMilliSec));
        end;
      end else
        raise Exception.Create(SInvalidSession);
    finally
      FreeDatabase(Database);
    end;
  end;
end;

procedure TBisUIBaseConnection.GetRecords(const SessionId: Variant; DataSet: TBisDataSet);
var
  Session: TBisUIBaseSession;
  Query: String;
  T, F: Int64;
  Database: TBisUIBaseDatabase;
begin
  Database:=CreateDatabase;
  if Assigned(Database) then begin
    try
      Session:=SessionFind(Database,SessionId);
      if Assigned(Session) and Assigned(DataSet) then begin
        T:=GetTickCount(F);
        try
          Database.SetSession(Session);
          Session.CheckLocks(SGetRecords,DataSet.ProviderName);
          Session.GetRecords(Database,DataSet,Query);
        finally
          Session.Update(Database,false,Query,GetTickDifference(T,F,dtMilliSec));
        end;
      end else
        raise Exception.Create(SInvalidSession);
    finally
      FreeDatabase(Database);
    end;
  end;
end;

procedure TBisUIBaseConnection.Execute(const SessionId: Variant; DataSet: TBisDataSet);
var
  Session: TBisUIBaseSession;
  Query: String;
  T, F: Int64;
  Database: TBisUIBaseDatabase;
begin
  Database:=CreateDatabase;
  if Assigned(Database) then begin
    try
      Session:=SessionFind(Database,SessionId);
      if Assigned(Session) and Assigned(DataSet) then begin
        T:=GetTickCount(F);
        try
          Database.SetSession(Session);
          Session.CheckLocks(SExecute,DataSet.ProviderName);
          Session.Execute(Database,DataSet,Query);
        finally
          Session.Update(Database,False,Query,GetTickDifference(T,F,dtMilliSec));
        end;
      end else
        raise Exception.Create(SInvalidSession);
    finally
      FreeDatabase(Database);
    end;
  end;
end;

procedure TBisUIBaseConnection.LoadMenus(const SessionId: Variant; Menus: TBisMenus);
var
  Session: TBisUIBaseSession;
  T, F: Int64;
  Database: TBisUIBaseDatabase;
begin
  Database:=CreateDatabase;
  if Assigned(Database) then begin
    try
      Session:=SessionFind(Database,SessionId);
      if Assigned(Session) and Assigned(Menus) then begin
        T:=GetTickCount(F);
        try
          Database.SetSession(Session);
          Session.CheckLocks(SLoadMenus);
          Session.LoadMenus(Database,Menus);
        finally
          Session.Update(Database,False,'',GetTickDifference(T,F,dtMilliSec));
        end;
      end else
        raise Exception.Create(SInvalidSession);
    finally
      FreeDatabase(Database);
    end;
  end;
end;

procedure TBisUIBaseConnection.LoadTasks(const SessionId: Variant; Tasks: TBisTasks);
var
  Session: TBisUIBaseSession;
  T, F: Int64;
  Database: TBisUIBaseDatabase;
begin
  Database:=CreateDatabase;
  if Assigned(Database) then begin
    try
      Session:=SessionFind(Database,SessionId);
      if Assigned(Session) and Assigned(Tasks) then begin
        T:=GetTickCount(F);
        try
          Database.SetSession(Session);
          Session.CheckLocks(SLoadTasks);
          Session.LoadTasks(Database,Tasks);
        finally
          Session.Update(Database,False,'',GetTickDifference(T,F,dtMilliSec));
        end;
      end else
        raise Exception.Create(SInvalidSession);
    finally
      FreeDatabase(Database);
    end;
  end;
end;

procedure TBisUIBaseConnection.SaveTask(const SessionId: Variant; Task: TBisTask);
var
  Session: TBisUIBaseSession;
  T, F: Int64;
  Database: TBisUIBaseDatabase;
begin
  Database:=CreateDatabase;
  if Assigned(Database) then begin
    try
      Session:=SessionFind(Database,SessionId);
      if Assigned(Session) and Assigned(Task) then begin
        T:=GetTickCount(F);
        try
          Database.SetSession(Session);
          Session.CheckLocks(SSaveTask);
          Session.SaveTask(Database,Task);
        finally
          Session.Update(Database,False,'',GetTickDifference(T,F,dtMilliSec));
        end;
      end else
        raise Exception.Create(SInvalidSession);
    finally
      FreeDatabase(Database);
    end;
  end;
end;

procedure TBisUIBaseConnection.LoadAlarms(const SessionId: Variant; Alarms: TBisAlarms);
var
  Session: TBisUIBaseSession;
  T, F: Int64;
  Database: TBisUIBaseDatabase;
begin
  Database:=CreateDatabase;
  if Assigned(Database) then begin
    try
      Session:=SessionFind(Database,SessionId);
      if Assigned(Session) and Assigned(Alarms) then begin
        T:=GetTickCount(F);
        try
          Database.SetSession(Session);
          Session.CheckLocks(SLoadAlarms);
          Session.LoadAlarms(Database,Alarms);
        finally
          Session.Update(Database,False,'',GetTickDifference(T,F,dtMilliSec));
        end;
      end else
        raise Exception.Create(SInvalidSession);
    finally
      FreeDatabase(Database);
    end;
  end;
end;

procedure TBisUIBaseConnection.LoadScript(const SessionId: Variant; ScriptId: Variant; Stream: TStream);
var
  Session: TBisUIBaseSession;
  T, F: Int64;
  Database: TBisUIBaseDatabase;
begin
  Database:=CreateDatabase;
  if Assigned(Database) then begin
    try
      Session:=SessionFind(Database,SessionId);
      if Assigned(Session) and Assigned(Stream) then begin
        T:=GetTickCount(F);
        try
          Database.SetSession(Session);
          Session.CheckLocks(SLoadScript);
          Session.LoadScript(Database,ScriptId,Stream);
        finally
          Session.Update(Database,False,'',GetTickDifference(T,F,dtMilliSec));
        end;
      end else
        raise Exception.Create(SInvalidSession);
    finally
      FreeDatabase(Database);
    end;
  end;
end;

procedure TBisUIBaseConnection.LoadReport(const SessionId: Variant; ReportId: Variant; Stream: TStream);
var
  Session: TBisUIBaseSession;
  T, F: Int64;
  Database: TBisUIBaseDatabase;
begin
  Database:=CreateDatabase;
  if Assigned(Database) then begin
    try
      Session:=SessionFind(Database,SessionId);
      if Assigned(Session) and Assigned(Stream) then begin
        T:=GetTickCount(F);
        try
          Database.SetSession(Session);
          Session.CheckLocks(SLoadReport);
          Session.LoadReport(Database,ReportId,Stream);
        finally
          Session.Update(Database,False,'',GetTickDifference(T,F,dtMilliSec));
        end;
      end else
        raise Exception.Create(SInvalidSession);
    finally
      FreeDatabase(Database);
    end;
  end;
end;

procedure TBisUIBaseConnection.LoadDocument(const SessionId: Variant; DocumentId: Variant; Stream: TStream);
var
  Session: TBisUIBaseSession;
  T, F: Int64;
  Database: TBisUIBaseDatabase;
begin
  Database:=CreateDatabase;
  if Assigned(Database) then begin
    try
      Session:=SessionFind(Database,SessionId);
      if Assigned(Session) and Assigned(Stream) then begin
        T:=GetTickCount(F);
        try
          Database.SetSession(Session);
          Session.CheckLocks(SLoadDocument);
          Session.LoadDocument(Database,DocumentId,Stream);
        finally
          Session.Update(Database,False,'',GetTickDifference(T,F,dtMilliSec));
        end;
      end else
        raise Exception.Create(SInvalidSession);
    finally
      FreeDatabase(Database);
    end;
  end;
end;

procedure TBisUIBaseConnection.Cancel(const SessionId: Variant; DataSetCheckSum: String='');
var
  Database: TBisUIBaseDatabase;
begin
  Database:=CreateDatabase;
  if Assigned(Database) then begin
    try
      DeleteStatements(Database,SessionId,DataSetCheckSum);
    finally
      FreeDatabase(Database);
    end;
  end;
end;

procedure TBisUIBaseConnection.CheckSessions;
var
  Database: TBisUIBaseDatabase;
begin
  Database:=CreateDatabase;
  if Assigned(Database) then begin
    try
      CheckSessions(Database);
    finally
      FreeDatabase(Database);
    end;
  end;
end;


end.


