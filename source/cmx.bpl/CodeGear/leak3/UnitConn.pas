unit UnitConn;

interface

uses  Windows, Classes,
//      IBDatabase, IBStoredProc, IBQuery,
      SqlExpr;

procedure InitConn;
procedure DoneConn;
procedure ExecuteSqlStoredProc;
procedure ExecuteSqlQuery;
procedure ExecuteIBStoredProc;
procedure ExecuteIBQuery;

var
  FLock: TRTLCriticalSection;
  
implementation

uses SysUtils, WinSock, Forms;

var
  FConnection1: TSQLConnection;
//  FConnection2: TIBDatabase;

function GetHostNameEx: String;
const
  WSVer = $101;
var
  wsaData: TWSAData;
  Buf: array [0..127] of Char;
begin
  Result := '';
  if WSAStartup(WSVer, wsaData) = 0 then begin
    if GetHostName(@Buf, 128) = 0 then begin
      Result:=Buf;
    end;
    WSACleanup;
  end;
end;

procedure GetStringsByString(const S,Delim: String; Strings: TStrings);
var
  Apos: Integer;
  S1,S2: String;
begin
  if Assigned(Strings) then begin
    Apos:=-1;
    S2:=S;
    while Apos<>0 do begin
      Apos:=AnsiPos(Delim,S2);
      if Apos>0 then begin
        S1:=Copy(S2,1,Apos-Length(Delim));
        S2:=Copy(S2,Apos+Length(Delim),Length(S2));
        if S1<>'' then
          Strings.AddObject(S1,TObject(Apos))
        else begin
          if Length(S2)>0 then
            APos:=-1;
        end;
      end else
        Strings.AddObject(S2,TObject(Apos));
    end;
  end;
end;

function GetDatabaseName: String;
var
  Str: TStringList;
begin
  Str:=TStringList.Create;
  try
//    Result:=ExtractFilePath(Application.ExeName)+'INTERBASE.IB';
    Result:=ExtractFilePath(Application.ExeName)+'FIREBIRD.FDB';
    GetStringsByString(Result,':',Str);
    if Str.Count<=2 then
      Result:=GetHostNameEx+':'+Result;
  finally
    Str.Free;
  end;
end;


procedure InitConn;
begin
  InitializeCriticalSection(FLock);

  FConnection1:=TSQLConnection.Create(nil);
  with FConnection1 do begin
    LoadParamsOnConnect:=false;
    AutoClone:=false;

    DriverName := 'Interbase';
    GetDriverFunc := 'getSQLDriverINTERBASE';
    LibraryName := 'dbxint30.dll';
    VendorLib := 'gds32.dll';

{    DriverName:='Firebird';
    GetDriverFunc := 'getSQLDriverFIREBIRD';
    LibraryName := 'dbxfb40.dll';
    VendorLib := 'gds32.dll'; }

    Params.Add('User_Name=SYSDBA');
    Params.Add('Password=masterkey');
    Params.Add(Format('Database=%s',[GetDatabaseName]));
    Params.Add('RoleName=');
    Params.Add('ServerCharSet=');
    Params.Add('SQLDialect=3');
    Params.Add('BlobSize=-1');
    Params.Add('ErrorResourceFile=');
    Params.Add('LocaleCode=0000');
    Params.Add('CommitRetain=False');
    Params.Add('WaitOnLock=True');
    Params.Add('Interbase TransIsolation=ReadCommited');
    Params.Add('Trim Char=False');
    ParamsLoaded:=true;
    Open;
  end;

{  FConnection2:=TIBDataBase.Create(nil);
  with FConnection2 do begin
    DatabaseName:=GetDatabaseName;
    LoginPrompt:=false;
    Params.Add('User_Name=SYSDBA');
    Params.Add('Password=masterkey');
    Open;
  end;}
  
end;

procedure DoneConn;
begin
//  FConnection2.Free;
  FConnection1.Free;

  DeleteCriticalSection(FLock);
end;

procedure ExecuteSqlStoredProc;
var
  Proc: TSQLStoredProc;
  S: String;
begin
  EnterCriticalSection(FLock);
  try
    if FConnection1.Connected then begin
      Proc:=TSQLStoredProc.Create(nil);
      try
        Proc.SQLConnection:=FConnection1;

        Proc.StoredProcName:='PROC_EMPTY';
        Proc.ExecProc;

        Proc.StoredProcName:='PROC_ONE_IN_PARAM';
        Proc.Params[0].AsString:='Hello';
        Proc.ExecProc;

        Proc.StoredProcName:='PROC_ONE_OUT_PARAM';
        Proc.ExecProc;
        S:=Proc.Params[0].AsString;
        if S<>'' then

        Proc.StoredProcName:='PROC_OUT_IN_PARAM';
        Proc.Params[0].AsString:='Hello';
        Proc.ExecProc;
        S:=Proc.Params[1].AsString;
        if S<>'' then

      finally
        Proc.Free;
      end;
    end;
  finally
    LeaveCriticalSection(FLock);
  end;
end;

procedure ExecuteSqlQuery;
var
  Query: TSQLQuery;
begin
  if FConnection1.Connected then begin
    Query:=TSQLQuery.Create(nil);
    try
      Query.SQLConnection:=FConnection1;

      Query.SQL.Text:='SELECT * FROM TABLE_ONE_RECORD';
      Query.Open;

      Query.Close;
      Query.SQL.Text:='INSERT INTO TABLE_INSERT (ID) VALUES (1)';
      Query.ExecSQL;

      Query.SQL.Text:='UPDATE TABLE_UPDATE SET NAME=''Test'' WHERE ID=1';
      Query.ExecSQL;

      Query.SQL.Text:='DELETE FROM TABLE_DELETE WHERE ID=1';
      Query.ExecSQL;
    finally
      Query.Free;
    end;
  end;
end;

procedure ExecuteIBStoredProc;
{var
  Proc: TIBStoredProc;
  Tran: TIBTransaction;
  S: String;}
begin
{  if FConnection2.Connected then begin
    Proc:=TIBStoredProc.Create(nil);
    Tran:=TIBTransaction.Create(nil);
    try
      Tran.Params.Text:='read_committed'+#13#10+'rec_version'+#13#10+'nowait';
      FConnection2.AddTransaction(Tran);
      Tran.AddDatabase(FConnection2);
      Proc.Database:=FConnection2;
      Proc.Transaction:=Tran;
      Tran.Active:=true;

      Proc.StoredProcName:='PROC_EMPTY';
      Proc.Prepare;
      Proc.ExecProc;

      Proc.StoredProcName:='PROC_ONE_IN_PARAM';
      Proc.Prepare;
      Proc.Params[0].AsString:='Hello';
      Proc.ExecProc;

      Proc.StoredProcName:='PROC_ONE_OUT_PARAM';
      Proc.Prepare;
      Proc.ExecProc;
      S:=Proc.Params[0].AsString;
      if S<>'' then

      Proc.StoredProcName:='PROC_OUT_IN_PARAM';
      Proc.Prepare;
      Proc.Params.ParamByName('S1').AsString:='Hello';
      Proc.ExecProc;
      S:=Proc.Params.ParamByName('N2').AsString;
      if S<>'' then

      Tran.Commit;


    finally
      Proc.Free;
      Tran.Free;
    end;
  end;}
end;

procedure ExecuteIBQuery;
{var
  Query: TIBQuery;
  Tran: TIBTransaction;}
begin
{  if FConnection2.Connected then begin
    Query:=TIBQuery.Create(nil);
    Tran:=TIBTransaction.Create(nil);
    try
      Tran.Params.Text:='read_committed'+#13#10+'rec_version'+#13#10+'nowait';
      FConnection2.AddTransaction(Tran);
      Tran.AddDatabase(FConnection2);
      Query.Database:=FConnection2;
      Query.Transaction:=Tran;
      Tran.Active:=true;

      Query.SQL.Text:='SELECT * FROM TABLE_ONE_RECORD';
      Query.Open;

      Query.Close;
      Query.SQL.Text:='INSERT INTO TABLE_INSERT (ID) VALUES (1)';
      Query.ExecSQL;

      Query.SQL.Text:='UPDATE TABLE_UPDATE SET NAME=''Test'' WHERE ID=1';
      Query.ExecSQL;

      Query.SQL.Text:='DELETE FROM TABLE_DELETE WHERE ID=1';
      Query.ExecSQL;
    finally
      Query.Free;
      Tran.Free;
    end;
  end;}
end;

end.