unit BisGsmServerInit;

interface

uses Windows, Classes, SysUtils, Contnrs, Variants, DB, SyncObjs,
     BisObject, BisCoreObjects, BisServers, BisServerModules,
     BisLogger, BisGsmModem, BisComPort, BisThreads, BisLocks;

type
  TBisGsmServer=class;

  TBisGsmServerModemMode=(mmAll,mmIncoming,mmOutgoing);

{  TBisGsmServerModem=class(TBisLock)
  private
    FThread: TBisWaitThread;

    FMode: TBisGsmServerModemMode;
    FServer: TBisGsmServer;
    FCheckImsi: String;
    FCheckImei: String;
    FBaudRate: TBisComPortBaudRate;
    FParityBits: TBisComPortParityBits;
    FStopBits: TBisComPortStopBits;
    FComPort: String;
    FDataBits: TBisComPortDataBits;
    FInterval: Integer;
    FStorages: String;
    FMaxCount: Integer;
    FTimeOut: Integer;
    FUnknownSender: String;
    FUnknownCode: String;
    FPeriod: Integer;
    FDestPort: Integer;
    FSourcePort: Integer;
    FOperatorIds: TStringList;

    function GetConnected: Boolean;
    procedure ModemStatus(Sender: TObject; Message: String; Error: Boolean=false);
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Connect;
    procedure Disconnect;

    property Server: TBisGsmServer read FServer write FServer;

    property Connected: Boolean read GetConnected;

  end;}

  TBisGsmServer=class(TBisServer)
  private
    FThread: TBisWaitThread;
    FStarted: Boolean;
    FInterval: Cardinal;
    FMode: TBisGsmServerModemMode;
    FCheckImsi: String;
    FCheckImei: String;
    FBaudRate: TBisComPortBaudRate;
    FParityBits: TBisComPortParityBits;
    FStopBits: TBisComPortStopBits;
    FComPort: String;
    FDataBits: TBisComPortDataBits;
    FStorages: String;
    FMaxCount: Integer;
    FTimeOut: Integer;
    FUnknownSender: String;
    FUnknownCode: String;
    FPeriod: Integer;
    FDestPort: Integer;
    FSourcePort: Integer;
    FOperatorIds: TStringList;
    FLocalIP: String;

    FSReadMessagesStart: String;
    FSReadMessagesEnd: String;
    FSInsertIntoDatabaseStart: String;
    FSInsertIntoDatabaseSuccess: String;
    FSInsertIntoDatabaseFail: String;
    FSInsertIntoDatabaseParams: String;
    FSExecuteProcStart: String;
    FSExecuteProcSuccess: String;
    FSExecuteProcFail: String;
    FSExecuteCommandFail: String;
    FSExecuteCommandSuccess: String;
    FSExecuteCommandStart: String;
    FSDeleteMessageStart: String;
    FSDeleteMessageSuccess: String;
    FSExecuteAnswerSuccess: String;
    FSExecuteAnswerText: String;
    FSExecuteAnswerStart: String;
    FSExecuteAnswerFail: String;
    FSCheckImeiFail: String;
    FSCheckImsiFail: String;
    FSInMessagesStart: String;
    FSOutMessagesStart: String;
    FSLockMessages: String;
    FSOutMessageParams: String;
    FSOutMessageSendSuccess: String;
    FSOutMessageSendFail: String;
    FSUnlockOutMessageStart: String;
    FSUnlockOutMessageFail: String;
    FSUnlockOutMessageSuccess: String;
    FSDeleteMessagesStart: String;
    FSDeleteMessagesEnd: String;
    FSChannelFormat: String;
    FSDeleteMessageFail: String;
    FSOutMessagesStartAll: String;

    procedure ChangeParams(Sender: TObject);

    procedure ModemStatus(Sender: TObject; Message: String; Error: Boolean);

    procedure ThreadTimeout(Thread: TBisWaitThread);
    procedure ThreadBegin(Thread: TBisThread);
    procedure ThreadEnd(Thread: TBisThread);
    
  protected
    function GetStarted: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Start; override;
    procedure Stop; override;

  published

    property SInMessagesStart: String read FSInMessagesStart write FSInMessagesStart;
    property SReadMessagesStart: String read FSReadMessagesStart write FSReadMessagesStart;
    property SReadMessagesEnd: String read FSReadMessagesEnd write FSReadMessagesEnd;

    property SInsertIntoDatabaseStart: String read FSInsertIntoDatabaseStart write FSInsertIntoDatabaseStart;
    property SInsertIntoDatabaseParams: String read FSInsertIntoDatabaseParams write FSInsertIntoDatabaseParams;
    property SInsertIntoDatabaseSuccess: String read FSInsertIntoDatabaseSuccess write FSInsertIntoDatabaseSuccess;
    property SInsertIntoDatabaseFail: String read FSInsertIntoDatabaseFail write FSInsertIntoDatabaseFail;

    property SExecuteProcStart: String read FSExecuteProcStart write FSExecuteProcStart;
    property SExecuteProcSuccess: String read FSExecuteProcSuccess write FSExecuteProcSuccess;
    property SExecuteProcFail: String read FSExecuteProcFail write FSExecuteProcFail;

    property SExecuteCommandStart: String read FSExecuteCommandStart write FSExecuteCommandStart;
    property SExecuteCommandSuccess: String read FSExecuteCommandSuccess write FSExecuteCommandSuccess;
    property SExecuteCommandFail: String read FSExecuteCommandFail write FSExecuteCommandFail;

    property SExecuteAnswerStart: String read FSExecuteAnswerStart write FSExecuteAnswerStart;
    property SExecuteAnswerText: String read FSExecuteAnswerText write FSExecuteAnswerText;
    property SExecuteAnswerSuccess: String read FSExecuteAnswerSuccess write FSExecuteAnswerSuccess;
    property SExecuteAnswerFail: String read FSExecuteAnswerFail write FSExecuteAnswerFail;

    property SDeleteMessageStart: String read FSDeleteMessageStart write FSDeleteMessageStart;
    property SDeleteMessageSuccess: String read FSDeleteMessageSuccess write FSDeleteMessageSuccess;
    property SDeleteMessageFail: String read FSDeleteMessageFail write FSDeleteMessageFail; 

    property SDeleteMessagesStart: String read FSDeleteMessagesStart write FSDeleteMessagesStart;
    property SDeleteMessagesEnd: String read FSDeleteMessagesEnd write FSDeleteMessagesEnd;

    property SOutMessagesStart: String read FSOutMessagesStart write FSOutMessagesStart;
    property SOutMessagesStartAll: String read FSOutMessagesStartAll write FSOutMessagesStartAll;
    property SLockMessages: String read FSLockMessages write FSLockMessages;
    property SOutMessageParams: String read FSOutMessageParams write FSOutMessageParams;

    property SOutMessageSendSuccess: String read FSOutMessageSendSuccess write FSOutMessageSendSuccess;
    property SOutMessageSendFail: String read FSOutMessageSendFail write FSOutMessageSendFail;

    property SUnlockOutMessageStart: String read FSUnlockOutMessageStart write FSUnlockOutMessageStart;
    property SUnlockOutMessageSuccess: String read FSUnlockOutMessageSuccess write FSUnlockOutMessageSuccess;
    property SUnlockOutMessageFail: String read FSUnlockOutMessageFail write FSUnlockOutMessageFail;

    property SCheckImeiFail: String read FSCheckImeiFail write FSCheckImeiFail;
    property SCheckImsiFail: String read FSCheckImsiFail write FSCheckImsiFail;

    property SChannelFormat: String read FSChannelFormat write FSChannelFormat;     
  end;

procedure InitServerModule(AModule: TBisServerModule); stdcall;

exports
  InitServerModule;

implementation

uses Math,
     GsmSms,
     BisConsts, BisUtils, BisDataSet, BisProvider, BisNetUtils, BisDataParams,
     BisCore, BisFilterGroups, BisValues, BisOrders, BisCoreUtils,
     BisGsmServerConsts;


procedure InitServerModule(AModule: TBisServerModule); stdcall;
begin
  ServerModule:=AModule;
  AModule.ServerClass:=TBisGsmServer;
end;

{ TBisGsmServerModem }

{constructor TBisGsmServerModem.Create;
begin
  inherited Create;

  FOperatorIds:=TStringList.Create;

  FThread:=TBisGsmServerModemThread.Create;
  FThread.OnTimeout:=ThreadTimeout;
  FThread.OnBegin:=ThreadBegin;
  FThread.OnEnd:=ThreadEnd;

  FInterval:=1000;
end;

destructor TBisGsmServerModem.Destroy;
begin
  Disconnect;
  FThread.Free;
  FOperatorIds.Free;
  inherited Destroy;
end;

function TBisGsmServerModem.GetConnected: Boolean;
begin
  Result:=FThread.Working;
end;

procedure TBisGsmServerModem.LoggerWrite(const Message: String; LogType: TBisLoggerType; const LoggerName: String);
var
  S: String;
begin
  if Assigned(FServer) then begin
    S:=Format('%s: %s',[FComPort,Message]);
    FServer.LoggerWrite(S,LogType,LoggerName);
  end;
end;

procedure TBisGsmServerModem.ModemStatus(Sender: TObject; Message: String; Error: Boolean);
var
  S: String;
  LT: TBisLoggerType;
begin
  S:=VisibleControlCharacters(Message);
  LT:=ltInformation;
  if Error then
    LT:=ltError;
  LoggerWrite(S,LT);
end;

procedure TBisGsmServerModem.ThreadTimeout(Thread: TBisWaitThread);
var
  Modem: TBisGsmModem;
const
  PhoneChars=['+','0','1','2','3','4','5','6','7','8','9'];

  // delete messages by types
  procedure DeleteMessagesByTypes(Types: TBisGsmModemReadMessageTypes);
  var
    i: Integer;
    Storage: String;
    Storages: TStringList;
    Messages: TBisGsmModemMessages;
    Item: TBisGsmModemMessage;
  begin
    Storages:=TStringList.Create;
    Messages:=TBisGsmModemMessages.Create;
    try

      LoggerWrite(FServer.SDeleteMessagesStart);

      GetStringsByString(FStorages,';',Storages);

      for i:=0 to Storages.Count-1 do begin
        Storage:=Storages[i];
        Modem.ReadPduMessages(Messages,Storage,Types,FMaxCount);
      end;

      for i:=0 to Messages.Count-1 do begin
        Item:=Messages.Items[i];
        Modem.DeleteMessage(Item);
      end;

      LoggerWrite(FServer.SDeleteMessagesEnd);

    finally
      Messages.Free;
      Storages.Free;
    end;
  end;

  // read from modem and insert into database
  procedure InMessages;

    procedure GetSenderId(Contact: String; Senders: TBisDataSet);
    var
      Phone: String;
      P: TBisProvider;
    begin
      Phone:=GetOnlyChars(Contact,PhoneChars);
      if Trim(Contact)<>'' then begin
        P:=TBisProvider.Create(nil);
        try
          P.ProviderName:='S_ACCOUNTS';
          with P.FieldNames do begin
            AddInvisible('ACCOUNT_ID');
            AddInvisible('PHONE');
            AddInvisible('FIRM_ID');
          end;
          with P.FilterGroups.Add do begin
            Filters.Add('LOCKED',fcEqual,0);
            Filters.Add('IS_ROLE',fcEqual,0);
            Filters.Add('PHONE',fcEqual,Phone);
          end;
          try
            P.Open;
            if P.Active then begin
              Senders.CreateTable(P);
              Senders.CopyRecords(P);
            end;
          except
            on E: Exception do
              LoggerWrite(E.Message,ltError);
          end;
        finally
          P.Free;
        end;
      end;
    end;

    function GetCodeMessageId(TextIn: String; var RetCode,ProcName, CommandString, Answer: String): Variant;
    var
      P: TBisProvider;
    begin
      Result:=Null;
      P:=TBisProvider.Create(nil);
      try
        P.ProviderName:='GET_CODE_MESSAGE';
        with P.Params do begin
          AddInvisible('TEXT_IN').Value:=TextIn;
          AddInvisible('CODE_MESSAGE_ID',ptOutput);
          AddInvisible('CODE',ptOutput);
          AddInvisible('PROC_NAME',ptOutput);
          AddInvisible('COMMAND_STRING',ptOutput);
          AddInvisible('ANSWER',ptOutput);
        end;
        try
          P.Execute;
          if P.Success then begin
            Result:=P.ParamByName('CODE_MESSAGE_ID').Value;
            RetCode:=P.ParamByName('CODE').AsString;
            ProcName:=P.ParamByName('PROC_NAME').AsString;
            CommandString:=P.ParamByName('COMMAND_STRING').AsString;
            Answer:=P.ParamByName('ANSWER').AsString;
          end;
        except
          On E: Exception do
            LoggerWrite(E.Message,ltError);
        end;
      finally
        P.Free;
      end;
    end;
    
    procedure ExecuteProc(ProcName: String; InMessageId: Variant);
    var
      P: TBisProvider;
    begin
      LoggerWrite(FormatEx(FServer.SExecuteProcStart,[ProcName]));
      P:=TBisProvider.Create(nil);
      try
        P.UseShowError:=false;
        P.UseWaitCursor:=false;
        P.ProviderName:=ProcName;
        with P.Params do begin
          AddInvisible('ACCOUNT_ID').Value:=Core.AccountId;
          AddInvisible('IN_MESSAGE_ID').Value:=InMessageId;
        end;
        try
          P.Execute;
          if P.Success then
            LoggerWrite(FServer.SExecuteProcSuccess);
        except
          On E: Exception do begin
            LoggerWrite(FormatEx(FServer.SExecuteProcFail,[E.Message]),ltError);
          end;
        end;
      finally
        P.Free;
      end;
    end;

    procedure ExecuteCommand(Code,CommandString: String; Contact,TextIn: String; DateSend: TDateTime;
                             SenderId, CodeMessageId, InMessageId: Variant);
    var
      S: String;
      i: Integer;
      Params: TBisValues;
      Param: TBisValue;
      StartupInfo: TStartupInfo;
      ProcessInfo: TProcessInformation;
      Ret: Boolean;
    begin
      LoggerWrite(FormatEx(FServer.SExecuteCommandStart,[CommandString]));
      Params:=TBisValues.Create;
      try
        Params.Add('IN_MESSAGE_ID',VarToStrDef(InMessageId,''));
        Params.Add('SENDER_ID',VarToStrDef(SenderId,''));
        Params.Add('CODE_MESSAGE_ID',VarToStrDef(CodeMessageId,''));
        Params.Add('DATE_SEND',DateTimeToStr(DateSend));
        Params.Add('TEXT_IN',TextIn);
        Params.Add('CONTACT',Contact);
        Params.Add('CODE',Code);

        S:=CommandString;
        for i:=0 to Params.Count-1 do begin
          Param:=Params.Items[i];
          S:=StringReplace(S,'%'+Param.Name,'"'+VarToStrDef(Param.Value,'')+'"',[rfReplaceAll, rfIgnoreCase]);
        end;
        try
          FillChar(StartupInfo,SizeOf(TStartupInfo),0);
          with StartupInfo do begin
            cb:=SizeOf(TStartupInfo);
            wShowWindow:=SW_SHOWDEFAULT;
          end;
          Ret:=CreateProcess(nil,PChar(S),nil,nil,False,
                             NORMAL_PRIORITY_CLASS,nil,nil,StartupInfo, ProcessInfo);
          if Ret then
            LoggerWrite(FServer.SExecuteCommandSuccess)
          else
            LoggerWrite(FormatEx(FServer.SExecuteCommandFail,[SysErrorMessage(GetLastError)]),ltError);
        except
          On E: Exception do begin
            LoggerWrite(FormatEx(FServer.SExecuteCommandFail,[E.Message]),ltError);
          end;
        end;
      finally
        Params.Free;
      end;
    end;

    procedure ExecuteAnswer(Code,Answer: String; Contact: String; DateSend: TDateTime;
                            SenderId, CodeMessageId, InMessageId: Variant);
    var
      S: String;
      i: Integer;
      Params: TBisValues;
      Param: TBisValue;
      Ret: Boolean;
      Item: TBisGsmModemMessage;
      Number: String;
    begin
      LoggerWrite(FServer.SExecuteAnswerStart);
      Params:=TBisValues.Create;
      Item:=TBisGsmModemMessage.Create;
      try
        Params.Add('IN_MESSAGE_ID',VarToStrDef(InMessageId,''));
        Params.Add('SENDER_ID',VarToStrDef(SenderId,''));
        Params.Add('CODE_MESSAGE_ID',VarToStrDef(CodeMessageId,''));
        Params.Add('DATE_SEND',DateTimeToStr(DateSend));
        Params.Add('CONTACT',Contact);
        Params.Add('CODE',Code);

        S:=Answer;
        for i:=0 to Params.Count-1 do begin
          Param:=Params.Items[i];
          S:=StringReplace(S,'%'+Param.Name,VarToStrDef(Param.Value,''),[rfReplaceAll, rfIgnoreCase]);
        end;
        try
          LoggerWrite(FormatEx(FServer.SExecuteAnswerText,[S]));

          Number:=GetOnlyChars(Contact,PhoneChars);
          if Trim(Number)<>'' then begin
            Item.OriginalText:=S;
            Item.FlashSMS:=true;
            Item.OriginalNumber:=Number;
            Ret:=Modem.SendPduMessage(Item);
            if Ret then begin
              LoggerWrite(FServer.SExecuteAnswerSuccess)
            end else
              LoggerWrite(FormatEx(FServer.SExecuteAnswerFail,[SysErrorMessage(GetLastError)]),ltError);
          end;
        except
          On E: Exception do begin
            LoggerWrite(FormatEx(FServer.SExecuteAnswerFail,[E.Message]),ltError);
          end;
        end;
      finally
        Item.Free;
        Params.Free;
      end;
    end;

    function WriteMessage(Storage: String; Index: Integer; DateSend: TDateTime;
                          Contact, TextIn: String; SenderId, CodeMessageId, FirmId: Variant;
                          Answer, RetCode, ProcName, CommandString: String): Variant;
    var
      P: TBisProvider;
    begin
      Result:=Null;
      
      P:=TBisProvider.Create(nil);
      try
        LoggerWrite(FormatEx(FServer.SInsertIntoDatabaseParams,
                             [Storage,
                              IntToStr(Index),
                              DateTimeToStr(DateSend),
                              Contact,
                              TextIn]));

        P.UseWaitCursor:=false;
        P.UseShowError:=false;
        P.ProviderName:='I_IN_MESSAGE';
        with P.Params do begin
          AddKey('IN_MESSAGE_ID');
          AddInvisible('SENDER_ID').Value:=SenderId;
          AddInvisible('CODE_MESSAGE_ID').Value:=CodeMessageId;
          AddInvisible('DATE_SEND').Value:=DateSend;
          AddInvisible('TEXT_IN').Value:=TextIn;
          AddInvisible('DATE_IN').Value:=Null;
          AddInvisible('TYPE_MESSAGE').Value:=DefaultTypeMessage;
          AddInvisible('CONTACT').Value:=Contact;
          AddInvisible('CHANNEL').Value:=FormatEx(FServer.SChannelFormat,[FServer.FLocalIP,FComPort]);
          AddInvisible('FIRM_ID').Value:=FirmId;
          AddInvisible('OPERATOR_ID').Value:=Null;
        end;
        try
          P.Execute;
          if P.Success then begin
            Result:=P.Params.ParamByName('IN_MESSAGE_ID').Value;
            LoggerWrite(FormatEx(FServer.SInsertIntoDatabaseSuccess,[VarToStrDef(Result,'')]));
          end;
        except
          On E: Exception do
            LoggerWrite(FormatEx(FServer.SInsertIntoDatabaseFail,[E.Message]),ltError);
        end;
      finally
        P.Free;
      end;

      if not VarIsNull(Result) then begin

        if not VarIsNull(CodeMessageId) then begin

          if not VarIsNull(SenderId) then
            if Trim(Answer)<>'' then
              ExecuteAnswer(RetCode,Answer,Contact,DateSend,SenderId,CodeMessageId,Result);

          if VarIsNull(SenderId) then
            if Trim(FUnknownSender)<>'' then
              ExecuteAnswer(RetCode,FUnknownSender,Contact,DateSend,SenderId,CodeMessageId,Result);

          if Trim(ProcName)<>'' then
            ExecuteProc(ProcName,Result);

          if Trim(CommandString)<>'' then
            ExecuteCommand(RetCode,CommandString,Contact,TextIn,DateSend,SenderId,CodeMessageId,Result);

        end else begin

          if Trim(FUnknownCode)<>'' then
            ExecuteAnswer(RetCode,FUnknownCode,Contact,DateSend,SenderId,CodeMessageId,Result);

        end;

      end;

    end;

    function IncomingGranted(SenderId: Variant): Boolean;
    var
      P: TBisProvider;
    begin
      Result:=false;
      P:=TBisProvider.Create(nil);
      try
        P.ProviderName:='INCOMING_GRANTED';
        with P.Params do begin
          AddInvisible('ACCOUNT_ID').Value:=SenderId;
          AddInvisible('TYPE_MESSAGE').Value:=DefaultTypeMessage;
          AddInvisible('GRANTED',ptOutput);
        end;
        try
          P.Execute;
          if P.Success then
            Result:=P.ParamByName('GRANTED').AsBoolean;
        except
          On E: Exception do
            LoggerWrite(E.Message,ltError);
        end;
      finally
        P.Free;
      end;
    end;

    function IsStatusReport(Message: TBisGsmModemMessage; var MessageId,Contact: String; var DateDelivery: TDateTime): Boolean;
    var
      Report: TSMSStatusReport;
    begin
      Result:=false;
      if AnsiSameText(Message.Text,'(Decoding Error)') then begin
        Report:=TSMSStatusReport.Create(false);
        try
          try
            Report.PDU:=Message.OriginalPDU;
            if Report.Delivered then begin
              MessageId:=Report.MessageReference;
              Contact:=Report.Number;
              Datedelivery:=Report.DischargeTime;
            end;
            Result:=true;
          except
            On E: Exception do
              LoggerWrite(E.Message,ltError);
          end;
        finally
          Report.Free;
        end;
      end;
    end;

    function OutMessageDelivery(MessageId,Contact: String; DateDelivery: TDateTime): Boolean;
    var
      P: TBisProvider;
    begin
      Result:=false;
      P:=TBisProvider.Create(nil);
      try
        P.ProviderName:='OUT_MESSAGE_DELIVERY';
        with P.Params do begin
          AddInvisible('MESSAGE_ID').Value:=Null; // MessageId is not correct
          AddInvisible('CONTACT').Value:=Contact;
          AddInvisible('DATE_DELIVERY').Value:=DateDelivery;
        end;
        try
          P.Execute;
          Result:=P.Success;
        except
          On E: Exception do
            LoggerWrite(E.Message,ltError);
        end;
      finally
        P.Free;
      end;
    end;
    
  var
    i: Integer;
    Storage: String;
    Storages: TStringList;
    Messages: TBisGsmModemMessages;
    Senders: TBisDataSet;
    Item: TBisGsmModemMessage;
    SenderId: Variant;
    CodeMessageId: Variant;
    FirmId: Variant;
    DateSend: TDateTime;
    TextIn: String;
    Contact: String;
    MessageId: String;
    ProcName: String;
    CommandString: String;
    Answer: String;
    RetCode: String;
    InMessageId: Variant;
    FlagWrite: Boolean;
    Datedelivery: TDateTime;
  begin
    LoggerWrite(FServer.SInMessagesStart);

    Storages:=TStringList.Create;
    Messages:=TBisGsmModemMessages.Create;
    try

      LoggerWrite(FServer.SReadMessagesStart);

      GetStringsByString(FStorages,';',Storages);
      for i:=0 to Storages.Count-1 do begin
        Storage:=Storages[i];
        Modem.ReadPduMessages(Messages,Storage,[mtReceivedNew,mtReceivedRead],FMaxCount);
      end;

      LoggerWrite(FormatEx(FServer.SReadMessagesEnd,[Messages.Count]));

      for i:=0 to Messages.Count-1 do begin
        Item:=Messages.Items[i];

        if IsStatusReport(Item,MessageId,Contact,Datedelivery) then begin

          if OutMessageDelivery(MessageId,Contact,Datedelivery) then begin
            LoggerWrite(FServer.SDeleteMessageStart);
            if Modem.DeleteMessage(Item) then
              LoggerWrite(FServer.SDeleteMessageSuccess)
            else
              LoggerWrite(FServer.SDeleteMessageFail);
          end;

        end else begin

          if Modem.DeleteMessage(Item) then begin

            LoggerWrite(FServer.SInsertIntoDatabaseStart);

            FlagWrite:=false;

            Contact:=Item.Number;
            TextIn:=Item.Text;
            DateSend:=Item.TimeStamp;
            ProcName:='';
            CommandString:='';
            CodeMessageId:=GetCodeMessageId(TextIn,RetCode,ProcName,CommandString,Answer);

            Senders:=TBisDataSet.Create(nil);
            try
              GetSenderId(Contact,Senders);
              if Senders.Active and not Senders.Empty then begin
                Senders.First;
                while not Senders.Eof do begin
                  SenderId:=Senders.FieldByName('ACCOUNT_ID').Value;
                  if IncomingGranted(SenderId) then begin
                    FirmId:=Senders.FieldByName('FIRM_ID').Value;
                    InMessageId:=WriteMessage(Item.Storage,Item.Index,DateSend,Contact,TextIn,SenderId,
                                              CodeMessageId,FirmId,Answer,RetCode,ProcName,CommandString);
                    FlagWrite:=not VarIsNull(InMessageId);
                  end else
                    FlagWrite:=true;
                  Senders.Next;
                end;
              end else begin
                InMessageId:=WriteMessage(Item.Storage,Item.Index,DateSend,Contact,TextIn,Null,
                                          CodeMessageId,Null,Answer,RetCode,ProcName,CommandString);
                FlagWrite:=not VarIsNull(InMessageId);
              end;
            finally
              Senders.Free;
            end;

            if FlagWrite then
              LoggerWrite(FServer.SDeleteMessageSuccess);

          end;

        end;
      end;

    //  DeleteMessagesByTypes([mtReceivedRead]);

    finally
      Messages.Free;
      Storages.Free;
    end;
  end;

  // read from database and send by modem
  procedure OutMessages(OperatorId: Variant);
  var
    Locked: String;
    PSelect: TBisProvider;

    procedure UnlockMessage(Sent: Boolean; MessageId: Variant);
    var
      P: TBisProvider;
    begin
      LoggerWrite(FServer.SUnlockOutMessageStart);
      P:=TBisProvider.Create(nil);
      try
        P.UseWaitCursor:=false;
        P.UseShowError:=false;
        P.ProviderName:='UNLOCK_OUT_MESSAGE';
        with P.Params do begin
          AddInvisible('OUT_MESSAGE_ID').Value:=PSelect.FieldByName('OUT_MESSAGE_ID').Value;
          AddInvisible('SENT').Value:=Integer(Sent);
          AddInvisible('MESSAGE_ID').Value:=MessageId;
        end;
        try
          P.Execute;
          if P.Success then
            LoggerWrite(FServer.SUnlockOutMessageSuccess);
        except
          On E: Exception do
            LoggerWrite(FormatEx(FServer.SUnlockOutMessageFail,[E.Message]),ltError);
        end;
      finally
        P.Free;
      end;
    end;

  var
    PLock: TBisProvider;
    LockCount: Integer;
    Item: TBisGsmModemMessage;
    i: Integer;
    Sent: Boolean;
    S: String;
    Field: TField;
    TextOut: String;
    Number: String;
    DestPort: Variant;
    MessageId: Variant;
  begin
    if VarIsNull(OperatorId) then
      LoggerWrite(Server.SOutMessagesStartAll)
    else
      LoggerWrite(FormatEx(Server.SOutMessagesStart,[VarToStrDef(OperatorId,'')]));
    PLock:=TBisProvider.Create(nil);
    try
      Locked:=GetUniqueID;
      PLock.UseShowError:=false;
      PLock.UseWaitCursor:=false;
      PLock.ProviderName:='LOCK_OUT_MESSAGES';
      with PLock.Params do begin
        AddInvisible('MAX_COUNT').Value:=FMaxCount;
        AddInvisible('LOCKED').Value:=Locked;
        AddInvisible('TYPE_MESSAGE').Value:=DefaultTypeMessage;
        AddInvisible('PERIOD').Value:=iff(FPeriod=0,MaxInt,FPeriod);
        AddInvisible('CHANNEL').Value:=FormatEx(FServer.SChannelFormat,[FServer.FLocalIP,FComPort]);
        AddInvisible('OPERATOR_ID').Value:=OperatorId;
        AddInvisible('LOCK_COUNT',ptOutput).Value:=0;
      end;
      try
        PLock.Execute;
        if PLock.Success then begin
          LockCount:=PLock.Params.ParamByName('LOCK_COUNT').AsInteger;
          LoggerWrite(FormatEx(FServer.SLockMessages,[LockCount]));

          if LockCount>0 then begin

            PSelect:=TBisProvider.Create(nil);
            try
              PSelect.UseShowError:=false;
              PSelect.UseWaitCursor:=false;
              PSelect.ProviderName:='S_OUT_MESSAGES';
              with PSelect do begin
                with FieldNames do begin
                  AddInvisible('OUT_MESSAGE_ID');
                  AddInvisible('CREATOR_ID');
                  AddInvisible('RECIPIENT_ID');
                  AddInvisible('DATE_CREATE');
                  AddInvisible('TEXT_OUT');
                  AddInvisible('CONTACT');
                  AddInvisible('DELIVERY');
                  AddInvisible('FLASH');
                  AddInvisible('DEST_PORT');
                  AddInvisible('DESCRIPTION');
                  AddInvisible('CREATOR_NAME');
                  AddInvisible('RECIPIENT_NAME');
                  AddInvisible('RECIPIENT_PHONE');
                end;
                with FilterGroups.Add do begin
                  Filters.Add('LOCKED',fcEqual,Locked);
                  Filters.Add('DATE_OUT',fcIsNull,Null);
                  Filters.Add('TYPE_MESSAGE',fcEqual,DefaultTypeMessage);
                end;
                with Orders do begin
                  Add('PRIORITY');
                  Add('DATE_BEGIN');
                end;
              end;
              try
                PSelect.Open;
                if PSelect.Active and not PSelect.IsEmpty then begin

                  DeleteMessagesByTypes([mtStoredUnsent,mtStoredSent]);
                  
                  PSelect.First;
                  while not PSelect.Eof do begin
                    Sent:=false;
                    MessageId:=Null;
                    try
                      if not Thread.Terminated then begin
                        Item:=TBisGsmModemMessage.Create;
                        try
                          S:=PSelect.FieldByName('TEXT_OUT').AsString;
                          for i:=0 to PSelect.Fields.Count-1 do begin
                            Field:=PSelect.Fields[i];
                            if not AnsiSameText(Field.FieldName,'TEXT_OUT') then
                              S:=StringReplace(S,'%'+Field.FieldName,VarToStrDef(Field.Value,''),[rfReplaceAll, rfIgnoreCase]);
                          end;
                          TextOut:=S;
                          Number:=GetOnlyChars(PSelect.FieldByName('CONTACT').AsString,PhoneChars);
                          if Number<>'' then begin
                            Item.OriginalText:=TextOut;
                            Item.StatusRequest:=Boolean(PSelect.FieldByName('DELIVERY').AsInteger);
                            Item.FlashSMS:=Boolean(PSelect.FieldByName('FLASH').AsInteger);
                            Item.OriginalNumber:=Number;
    //                        Item.MessageReference:=IntToHex(RandomRange(1,MAXBYTE),2); it doesn't work

                            DestPort:=PSelect.FieldByName('DEST_PORT').Value;
                            if not VarIsNull(DestPort) then
                              Item.DestinationPort:=VarToIntDef(DestPort,Item.DestinationPort)
                            else
                              Item.DestinationPort:=FDestPort;
                            Item.SourcePort:=FSourcePort;

                            LoggerWrite(FormatEx(FServer.SOutMessageParams,
                                                 [PSelect.FieldByName('OUT_MESSAGE_ID').AsString,
                                                 Number,TextOut]));

                            Sent:=Modem.SendPduMessage(Item);
                            if Sent then begin
                              Modem.DeleteMessage(Item);
                              LoggerWrite(FServer.SOutMessageSendSuccess)
                            end else
                              LoggerWrite(FormatEx(FServer.SOutMessageSendFail,[SysErrorMessage(GetLastError)]),ltError);
                          end;
                        finally
                          Item.Free;
                        end;
                      end;
                    finally
                      UnlockMessage(Sent,MessageId);
                    end;
                    PSelect.Next;
                  end;

                end;
              except
                On E: Exception do
                  LoggerWrite(E.Message,ltError);
              end;
            finally
              PSelect.Free;
            end;
          end;
        end;
      except
        On E: Exception do
          LoggerWrite(E.Message,ltError);
      end;
    finally
      PLock.Free;
    end;
  end;

  procedure OutMessagesByOperators;
  var
    i: Integer;
  begin
    if FOperatorIds.Count>0 then begin
      for i:=0 to FOperatorIds.Count-1 do begin
        if Thread.Terminated then
          break;
         OutMessages(FOperatorIds[i]); 
      end;
    end else
      OutMessages(Null);
  end;
  
  function CheckImei: Boolean;
  begin
    Result:=Trim(FCheckImei)='';
    if not Result then begin
      Result:=AnsiSameText(FCheckImei,Modem.SerialNumber);
      if not Result then
        LoggerWrite(FServer.SCheckImeiFail);
    end;
  end;

  function CheckImsi: Boolean;
  begin
    Result:=Trim(FCheckImsi)='';
    if not Result then begin
      Result:=AnsiSameText(FCheckImsi,Modem.Subscriber);
      if not Result then
        LoggerWrite(FServer.SCheckImsiFail);
    end;
  end;

var
  Flag: Boolean;
begin
  Modem:=TBisGsmServerModemThread(Thread).FModem;

  if Assigned(FServer) and Assigned(Core) and Assigned(Modem) then begin

    FServer.Working:=true;
    try
      Randomize;
      try
        if not Modem.Connected then
          Modem.Connect;

        if Modem.Connected then begin

          Flag:=CheckImei;
          if Flag then
            Flag:=CheckImsi;

          if Flag then begin
            if FMaxCount>0 then begin
              case FMode of
                mmAll: begin
                  InMessages;
                  OutMessagesByOperators;
                end;
                mmIncoming: begin
                  InMessages;
                end;
                mmOutgoing: OutMessagesByOperators;
              end;
            end;
          end;
        end;
      except
        On E: Exception do
          LoggerWrite(E.Message,ltError);
      end;
    finally
      Thread.Reset;
      FServer.Working:=false;
    end;

  end;
end;

procedure TBisGsmServerModem.ThreadBegin(Thread: TBisThread);
var
  AThread: TBisGsmServerModemThread;
begin
  AThread:=TBisGsmServerModemThread(Thread);
  AThread.FModem:=TBisGsmModem.Create(Self);
  with AThread do begin
    FModem.OnStatus:=ModemStatus;
    FModem.Port:=FComPort;
    FModem.BaudRate:=FBaudRate;
    FModem.StopBits:=FStopBits;
    FModem.DataBits:=FDataBits;
    FModem.ParityBits:=FParityBits;
    FModem.Timeout:=FTimeOut;
  end;
end;

procedure TBisGsmServerModem.ThreadEnd(Thread: TBisThread);
begin
  with TBisGsmServerModemThread(Thread) do begin
    FreeAndNilEx(FModem);
  end;
end;

procedure TBisGsmServerModem.Connect;
begin
  Disconnect;
  if not Connected then begin
    FThread.Timeout:=FInterval;
    FThread.Start;
  end;
end;

procedure TBisGsmServerModem.Disconnect;
begin
  if Connected then 
    FThread.Stop;
end;}

{ TBisGsmServer }

type
  TBisGsmServerModemThread=class(TBisWaitThread)
  private
    FModem: TBisGsmModem;
  end;

constructor TBisGsmServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Params.OnChange:=ChangeParams;

  FOperatorIds:=TStringList.Create;

  FThread:=TBisGsmServerModemThread.Create;
  FThread.OnTimeout:=ThreadTimeout;
  FThread.OnBegin:=ThreadBegin;
  FThread.OnEnd:=ThreadEnd;

  FSInMessagesStart:='��������� �������� ��������� ...';
  FSReadMessagesStart:='������ �������� ��������� ...';
  FSReadMessagesEnd:='��������� %d �������� ���������.';
  FSInsertIntoDatabaseStart:='������ �������� ��������� ��������� ...';
  FSInsertIntoDatabaseParams:='��������� ��������� ���������: ���������=>%s  ������=>%s ���� ��������=>%s �����=>%s �����=>%s';
  FSInsertIntoDatabaseSuccess:='�������� ��������� ������� �������. �������������=>%s';
  FSInsertIntoDatabaseFail:='�������� ��������� �� �������. %s';
  FSExecuteProcStart:='������ ���������� ��������� %s ...';
  FSExecuteProcSuccess:='��������� ��������� �������.';
  FSExecuteProcFail:='��������� �� ���������. %s';
  FSExecuteCommandStart:='������ ���������� ������� %s ...';
  FSExecuteCommandSuccess:='������� ��������� �������.';
  FSExecuteCommandFail:='������� �� ���������. %s';
  FSExecuteAnswerStart:='������ ���������� ������ ...';
  FSExecuteAnswerText:='����� ������ =>%s';
  FSExecuteAnswerSuccess:='����� �������� �������.';
  FSExecuteAnswerFail:='����� �� ��������. %s';
  FSDeleteMessageStart:='������ �������� ��������� ��������� ...';
  FSDeleteMessageSuccess:='�������� ��������� ������� �������.';
  FSDeleteMessageFail:='�������� ��������� �� �������.';
  FSDeleteMessagesStart:='������ �������� ��������� ...';
  FSDeleteMessagesEnd:='��������� �������.';
  FSOutMessagesStart:='��������� ��������� ��������� ��� ��������� %s ...';
  FSOutMessagesStartAll:='��������� ��������� ��������� ��� ���� ���������� ...';
  FSLockMessages:='������������� %d ��������� ���������.';
  FSOutMessageParams:='��������� ���������� ���������: �������������=>%s �����=>%s �����=>%s';
  FSOutMessageSendSuccess:='��������� ��������� ���������� �������.';
  FSOutMessageSendFail:='��������� ��������� �� ����������. %s';
  FSUnlockOutMessageStart:='������ ������������� ��������� ...';
  FSUnlockOutMessageSuccess:='������������� ��������� ��������� �������.';
  FSUnlockOutMessageFail:='������������� ��������� �� ���������. %s';
  FSCheckImeiFail:='�� ������ IMEI.';
  FSCheckImsiFail:='�� ������ IMSI.';
  FSChannelFormat:='%s:%s';

  FInterval:=1000;
end;

destructor TBisGsmServer.Destroy;
begin
  Stop;
  FThread.Free;
  inherited Destroy;
end;

function TBisGsmServer.GetStarted: Boolean;
begin
  Result:=FStarted;
end;

procedure TBisGsmServer.ChangeParams(Sender: TObject);
begin
  FComPort:=Params.AsString(SParamComPort);
  FMode:=Params.AsEnumeration(SParamMode,TypeInfo(TBisGsmServerModemMode),mmAll);
  FInterval:=Params.AsInteger(SParamInterval);
  FStorages:=Params.AsString(SParamStorages);
  FMaxCount:=Params.AsInteger(SParamMaxCount);
  FTimeOut:=Params.AsInteger(SParamTimeout);
  FCheckImei:=Params.AsString(SParamImei);
  FCheckImsi:=Params.AsString(SParamImsi);
  FBaudRate:=Params.AsEnumeration(SParamBaudRate,TypeInfo(TBisComPortBaudRate),br14400);
  FDataBits:=Params.AsEnumeration(SParamDataBits,TypeInfo(TBisComPortDataBits),dbEight);
  FStopBits:=Params.AsEnumeration(SParamStopBits,TypeInfo(TBisComPortStopBits),sbOneStopBit);
  FParityBits:=Params.AsEnumeration(SParamParityBits,TypeInfo(TBisComPortParityBits),prNone);
  FUnknownSender:=Params.AsString(SParamUnknownSender);
  FUnknownCode:=Params.AsString(SParamUnknownCode);
  FPeriod:=Params.AsInteger(SParamPeriod);
  FDestPort:=Params.AsInteger(SParamDestPort);
  FSourcePort:=Params.AsInteger(SParamSourcePort);
  FOperatorIds.Text:=Trim(Params.AsString(SParamOperatorIds));
end;

procedure TBisGsmServer.ModemStatus(Sender: TObject; Message: String; Error: Boolean);
var
  S: String;
  LT: TBisLoggerType;
begin
  S:=VisibleControlCharacters(Message);
  LT:=ltInformation;
  if Error then
    LT:=ltError;
  LoggerWrite(S,LT);
end;

procedure TBisGsmServer.ThreadTimeout(Thread: TBisWaitThread);
var
  Modem: TBisGsmModem;
const
  PhoneChars=['+','0','1','2','3','4','5','6','7','8','9'];

  // delete messages by types
  procedure DeleteMessagesByTypes(Types: TBisGsmModemReadMessageTypes);
  var
    i: Integer;
    Storage: String;
    Storages: TStringList;
    Messages: TBisGsmModemMessages;
    Item: TBisGsmModemMessage;
  begin
    Storages:=TStringList.Create;
    Messages:=TBisGsmModemMessages.Create;
    try

      LoggerWrite(FSDeleteMessagesStart);

      GetStringsByString(FStorages,';',Storages);

      for i:=0 to Storages.Count-1 do begin
        Storage:=Storages[i];
        Modem.ReadPduMessages(Messages,Storage,Types,FMaxCount);
      end;

      for i:=0 to Messages.Count-1 do begin
        Item:=Messages.Items[i];
        Modem.DeleteMessage(Item);
      end;

      LoggerWrite(FSDeleteMessagesEnd);

    finally
      Messages.Free;
      Storages.Free;
    end;
  end;

  // read from modem and insert into database
  procedure InMessages;

    procedure GetSenderId(Contact: String; Senders: TBisDataSet);
    var
      Phone: String;
      P: TBisProvider;
    begin
      Phone:=GetOnlyChars(Contact,PhoneChars);
      if Trim(Contact)<>'' then begin
        P:=TBisProvider.Create(nil);
        try
          P.ProviderName:='S_ACCOUNTS';
          with P.FieldNames do begin
            AddInvisible('ACCOUNT_ID');
            AddInvisible('PHONE');
            AddInvisible('FIRM_ID');
          end;
          with P.FilterGroups.Add do begin
            Filters.Add('LOCKED',fcEqual,0);
            Filters.Add('IS_ROLE',fcEqual,0);
            Filters.Add('PHONE',fcEqual,Phone);
          end;
          try
            P.Open;
            if P.Active then begin
              Senders.CreateTable(P);
              Senders.CopyRecords(P);
            end;
          except
            on E: Exception do
              LoggerWrite(E.Message,ltError);
          end;
        finally
          P.Free;
        end;
      end;
    end;

    function GetCodeMessageId(TextIn: String; var RetCode,ProcName, CommandString, Answer: String): Variant;
    var
      P: TBisProvider;
    begin
      Result:=Null;
      P:=TBisProvider.Create(nil);
      try
        P.ProviderName:='GET_CODE_MESSAGE';
        with P.Params do begin
          AddInvisible('TEXT_IN').Value:=TextIn;
          AddInvisible('CODE_MESSAGE_ID',ptOutput);
          AddInvisible('CODE',ptOutput);
          AddInvisible('PROC_NAME',ptOutput);
          AddInvisible('COMMAND_STRING',ptOutput);
          AddInvisible('ANSWER',ptOutput);
        end;
        try
          P.Execute;
          if P.Success then begin
            Result:=P.ParamByName('CODE_MESSAGE_ID').Value;
            RetCode:=P.ParamByName('CODE').AsString;
            ProcName:=P.ParamByName('PROC_NAME').AsString;
            CommandString:=P.ParamByName('COMMAND_STRING').AsString;
            Answer:=P.ParamByName('ANSWER').AsString;
          end;
        except
          On E: Exception do
            LoggerWrite(E.Message,ltError);
        end;
      finally
        P.Free;
      end;
    end;
    
    procedure ExecuteProc(ProcName: String; InMessageId: Variant);
    var
      P: TBisProvider;
    begin
      LoggerWrite(FormatEx(FSExecuteProcStart,[ProcName]));
      P:=TBisProvider.Create(nil);
      try
        P.UseShowError:=false;
        P.UseWaitCursor:=false;
        P.ProviderName:=ProcName;
        with P.Params do begin
          AddInvisible('ACCOUNT_ID').Value:=Core.AccountId;
          AddInvisible('IN_MESSAGE_ID').Value:=InMessageId;
        end;
        try
          P.Execute;
          if P.Success then
            LoggerWrite(FSExecuteProcSuccess);
        except
          On E: Exception do begin
            LoggerWrite(FormatEx(FSExecuteProcFail,[E.Message]),ltError);
          end;
        end;
      finally
        P.Free;
      end;
    end;

    procedure ExecuteCommand(Code,CommandString: String; Contact,TextIn: String; DateSend: TDateTime;
                             SenderId, CodeMessageId, InMessageId: Variant);
    var
      S: String;
      i: Integer;
      Params: TBisValues;
      Param: TBisValue;
      StartupInfo: TStartupInfo;
      ProcessInfo: TProcessInformation;
      Ret: Boolean;
    begin
      LoggerWrite(FormatEx(FSExecuteCommandStart,[CommandString]));
      Params:=TBisValues.Create;
      try
        Params.Add('IN_MESSAGE_ID',VarToStrDef(InMessageId,''));
        Params.Add('SENDER_ID',VarToStrDef(SenderId,''));
        Params.Add('CODE_MESSAGE_ID',VarToStrDef(CodeMessageId,''));
        Params.Add('DATE_SEND',DateTimeToStr(DateSend));
        Params.Add('TEXT_IN',TextIn);
        Params.Add('CONTACT',Contact);
        Params.Add('CODE',Code);

        S:=CommandString;
        for i:=0 to Params.Count-1 do begin
          Param:=Params.Items[i];
          S:=StringReplace(S,'%'+Param.Name,'"'+VarToStrDef(Param.Value,'')+'"',[rfReplaceAll, rfIgnoreCase]);
        end;
        try
          FillChar(StartupInfo,SizeOf(TStartupInfo),0);
          with StartupInfo do begin
            cb:=SizeOf(TStartupInfo);
            wShowWindow:=SW_SHOWDEFAULT;
          end;
          Ret:=CreateProcess(nil,PChar(S),nil,nil,False,
                             NORMAL_PRIORITY_CLASS,nil,nil,StartupInfo, ProcessInfo);
          if Ret then
            LoggerWrite(FSExecuteCommandSuccess)
          else
            LoggerWrite(FormatEx(FSExecuteCommandFail,[SysErrorMessage(GetLastError)]),ltError);
        except
          On E: Exception do begin
            LoggerWrite(FormatEx(FSExecuteCommandFail,[E.Message]),ltError);
          end;
        end;
      finally
        Params.Free;
      end;
    end;

    procedure ExecuteAnswer(Code,Answer: String; Contact: String; DateSend: TDateTime;
                            SenderId, CodeMessageId, InMessageId: Variant);
    var
      S: String;
      i: Integer;
      Params: TBisValues;
      Param: TBisValue;
      Ret: Boolean;
      Item: TBisGsmModemMessage;
      Number: String;
    begin
      LoggerWrite(FSExecuteAnswerStart);
      Params:=TBisValues.Create;
      Item:=TBisGsmModemMessage.Create;
      try
        Params.Add('IN_MESSAGE_ID',VarToStrDef(InMessageId,''));
        Params.Add('SENDER_ID',VarToStrDef(SenderId,''));
        Params.Add('CODE_MESSAGE_ID',VarToStrDef(CodeMessageId,''));
        Params.Add('DATE_SEND',DateTimeToStr(DateSend));
        Params.Add('CONTACT',Contact);
        Params.Add('CODE',Code);

        S:=Answer;
        for i:=0 to Params.Count-1 do begin
          Param:=Params.Items[i];
          S:=StringReplace(S,'%'+Param.Name,VarToStrDef(Param.Value,''),[rfReplaceAll, rfIgnoreCase]);
        end;
        try
          LoggerWrite(FormatEx(FSExecuteAnswerText,[S]));

          Number:=GetOnlyChars(Contact,PhoneChars);
          if Trim(Number)<>'' then begin
            Item.OriginalText:=S;
            Item.FlashSMS:=true;
            Item.OriginalNumber:=Number;
            Ret:=Modem.SendPduMessage(Item);
            if Ret then begin
              LoggerWrite(FSExecuteAnswerSuccess)
            end else
              LoggerWrite(FormatEx(FSExecuteAnswerFail,[SysErrorMessage(GetLastError)]),ltError);
          end;
        except
          On E: Exception do begin
            LoggerWrite(FormatEx(FSExecuteAnswerFail,[E.Message]),ltError);
          end;
        end;
      finally
        Item.Free;
        Params.Free;
      end;
    end;

    function WriteMessage(Storage: String; Index: Integer; DateSend: TDateTime;
                          Contact, TextIn: String; SenderId, CodeMessageId, FirmId: Variant;
                          Answer, RetCode, ProcName, CommandString: String): Variant;
    var
      P: TBisProvider;
    begin
      Result:=Null;
      
      P:=TBisProvider.Create(nil);
      try
        LoggerWrite(FormatEx(FSInsertIntoDatabaseParams,
                             [Storage,
                              IntToStr(Index),
                              DateTimeToStr(DateSend),
                              Contact,
                              TextIn]));

        P.UseWaitCursor:=false;
        P.UseShowError:=false;
        P.ProviderName:='I_IN_MESSAGE';
        with P.Params do begin
          AddKey('IN_MESSAGE_ID');
          AddInvisible('SENDER_ID').Value:=SenderId;
          AddInvisible('CODE_MESSAGE_ID').Value:=CodeMessageId;
          AddInvisible('DATE_SEND').Value:=DateSend;
          AddInvisible('TEXT_IN').Value:=TextIn;
          AddInvisible('DATE_IN').Value:=Null;
          AddInvisible('TYPE_MESSAGE').Value:=DefaultTypeMessage;
          AddInvisible('CONTACT').Value:=Contact;
          AddInvisible('CHANNEL').Value:=FormatEx(FSChannelFormat,[FLocalIP,FComPort]);
          AddInvisible('FIRM_ID').Value:=FirmId;
          AddInvisible('OPERATOR_ID').Value:=Null;
        end;
        try
          P.Execute;
          if P.Success then begin
            Result:=P.Params.ParamByName('IN_MESSAGE_ID').Value;
            LoggerWrite(FormatEx(FSInsertIntoDatabaseSuccess,[VarToStrDef(Result,'')]));
          end;
        except
          On E: Exception do
            LoggerWrite(FormatEx(FSInsertIntoDatabaseFail,[E.Message]),ltError);
        end;
      finally
        P.Free;
      end;

      if not VarIsNull(Result) then begin

        if not VarIsNull(CodeMessageId) then begin

          if not VarIsNull(SenderId) then
            if Trim(Answer)<>'' then
              ExecuteAnswer(RetCode,Answer,Contact,DateSend,SenderId,CodeMessageId,Result);

          if VarIsNull(SenderId) then
            if Trim(FUnknownSender)<>'' then
              ExecuteAnswer(RetCode,FUnknownSender,Contact,DateSend,SenderId,CodeMessageId,Result);

          if Trim(ProcName)<>'' then
            ExecuteProc(ProcName,Result);

          if Trim(CommandString)<>'' then
            ExecuteCommand(RetCode,CommandString,Contact,TextIn,DateSend,SenderId,CodeMessageId,Result);

        end else begin

          if Trim(FUnknownCode)<>'' then
            ExecuteAnswer(RetCode,FUnknownCode,Contact,DateSend,SenderId,CodeMessageId,Result);

        end;

      end;

    end;

    function IncomingGranted(SenderId: Variant): Boolean;
    var
      P: TBisProvider;
    begin
      Result:=false;
      P:=TBisProvider.Create(nil);
      try
        P.ProviderName:='INCOMING_GRANTED';
        with P.Params do begin
          AddInvisible('ACCOUNT_ID').Value:=SenderId;
          AddInvisible('TYPE_MESSAGE').Value:=DefaultTypeMessage;
          AddInvisible('GRANTED',ptOutput);
        end;
        try
          P.Execute;
          if P.Success then
            Result:=P.ParamByName('GRANTED').AsBoolean;
        except
          On E: Exception do
            LoggerWrite(E.Message,ltError);
        end;
      finally
        P.Free;
      end;
    end;

    function IsStatusReport(Message: TBisGsmModemMessage; var MessageId,Contact: String; var DateDelivery: TDateTime): Boolean;
    var
      Report: TSMSStatusReport;
    begin
      Result:=false;
      if AnsiSameText(Message.Text,'(Decoding Error)') then begin
        Report:=TSMSStatusReport.Create(false);
        try
          try
            Report.PDU:=Message.OriginalPDU;
            if Report.Delivered then begin
              MessageId:=Report.MessageReference;
              Contact:=Report.Number;
              Datedelivery:=Report.DischargeTime;
            end;
            Result:=true;
          except
            On E: Exception do
              LoggerWrite(E.Message,ltError);
          end;
        finally
          Report.Free;
        end;
      end;
    end;

    function OutMessageDelivery(MessageId,Contact: String; DateDelivery: TDateTime): Boolean;
    var
      P: TBisProvider;
    begin
      Result:=false;
      P:=TBisProvider.Create(nil);
      try
        P.ProviderName:='OUT_MESSAGE_DELIVERY';
        with P.Params do begin
          AddInvisible('MESSAGE_ID').Value:=Null; // MessageId is not correct
          AddInvisible('CONTACT').Value:=Contact;
          AddInvisible('DATE_DELIVERY').Value:=DateDelivery;
        end;
        try
          P.Execute;
          Result:=P.Success;
        except
          On E: Exception do
            LoggerWrite(E.Message,ltError);
        end;
      finally
        P.Free;
      end;
    end;
    
  var
    i: Integer;
    Storage: String;
    Storages: TStringList;
    Messages: TBisGsmModemMessages;
    Senders: TBisDataSet;
    Item: TBisGsmModemMessage;
    SenderId: Variant;
    CodeMessageId: Variant;
    FirmId: Variant;
    DateSend: TDateTime;
    TextIn: String;
    Contact: String;
    MessageId: String;
    ProcName: String;
    CommandString: String;
    Answer: String;
    RetCode: String;
    InMessageId: Variant;
    FlagWrite: Boolean;
    Datedelivery: TDateTime;
  begin
    LoggerWrite(FSInMessagesStart);

    Storages:=TStringList.Create;
    Messages:=TBisGsmModemMessages.Create;
    try

      LoggerWrite(FSReadMessagesStart);

      GetStringsByString(FStorages,';',Storages);
      for i:=0 to Storages.Count-1 do begin
        Storage:=Storages[i];
        Modem.ReadPduMessages(Messages,Storage,[mtReceivedNew,mtReceivedRead],FMaxCount);
      end;

      LoggerWrite(FormatEx(FSReadMessagesEnd,[Messages.Count]));

      for i:=0 to Messages.Count-1 do begin
        Item:=Messages.Items[i];

        if IsStatusReport(Item,MessageId,Contact,Datedelivery) then begin

          if OutMessageDelivery(MessageId,Contact,Datedelivery) then begin
            LoggerWrite(FSDeleteMessageStart);
            if Modem.DeleteMessage(Item) then
              LoggerWrite(FSDeleteMessageSuccess)
            else
              LoggerWrite(FSDeleteMessageFail);
          end;

        end else begin

          if Modem.DeleteMessage(Item) then begin

            LoggerWrite(FSInsertIntoDatabaseStart);

            FlagWrite:=false;

            Contact:=Item.Number;
            TextIn:=Item.Text;
            DateSend:=Item.TimeStamp;
            ProcName:='';
            CommandString:='';
            CodeMessageId:=GetCodeMessageId(TextIn,RetCode,ProcName,CommandString,Answer);

            Senders:=TBisDataSet.Create(nil);
            try
              GetSenderId(Contact,Senders);
              if Senders.Active and not Senders.Empty then begin
                Senders.First;
                while not Senders.Eof do begin
                  SenderId:=Senders.FieldByName('ACCOUNT_ID').Value;
                  if IncomingGranted(SenderId) then begin
                    FirmId:=Senders.FieldByName('FIRM_ID').Value;
                    InMessageId:=WriteMessage(Item.Storage,Item.Index,DateSend,Contact,TextIn,SenderId,
                                              CodeMessageId,FirmId,Answer,RetCode,ProcName,CommandString);
                    FlagWrite:=not VarIsNull(InMessageId);
                  end else
                    FlagWrite:=true;
                  Senders.Next;
                end;
              end else begin
                InMessageId:=WriteMessage(Item.Storage,Item.Index,DateSend,Contact,TextIn,Null,
                                          CodeMessageId,Null,Answer,RetCode,ProcName,CommandString);
                FlagWrite:=not VarIsNull(InMessageId);
              end;
            finally
              Senders.Free;
            end;

            if FlagWrite then
              LoggerWrite(FSDeleteMessageSuccess);

          end;

        end;
      end;

    //  DeleteMessagesByTypes([mtReceivedRead]);

    finally
      Messages.Free;
      Storages.Free;
    end;
  end;

  // read from database and send by modem
  procedure OutMessages(OperatorId: Variant);
  var
    Locked: String;
    PSelect: TBisProvider;

    procedure UnlockMessage(Sent: Boolean; MessageId: Variant);
    var
      P: TBisProvider;
    begin
      LoggerWrite(FSUnlockOutMessageStart);
      P:=TBisProvider.Create(nil);
      try
        P.UseWaitCursor:=false;
        P.UseShowError:=false;
        P.ProviderName:='UNLOCK_OUT_MESSAGE';
        with P.Params do begin
          AddInvisible('OUT_MESSAGE_ID').Value:=PSelect.FieldByName('OUT_MESSAGE_ID').Value;
          AddInvisible('SENT').Value:=Integer(Sent);
          AddInvisible('MESSAGE_ID').Value:=MessageId;
        end;
        try
          P.Execute;
          if P.Success then
            LoggerWrite(FSUnlockOutMessageSuccess);
        except
          On E: Exception do
            LoggerWrite(FormatEx(FSUnlockOutMessageFail,[E.Message]),ltError);
        end;
      finally
        P.Free;
      end;
    end;

  var
    PLock: TBisProvider;
    LockCount: Integer;
    Item: TBisGsmModemMessage;
    i: Integer;
    Sent: Boolean;
    S: String;
    Field: TField;
    TextOut: String;
    Number: String;
    DestPort: Variant;
    MessageId: Variant;
  begin
    if VarIsNull(OperatorId) then
      LoggerWrite(FSOutMessagesStartAll)
    else
      LoggerWrite(FormatEx(FSOutMessagesStart,[VarToStrDef(OperatorId,'')]));
    PLock:=TBisProvider.Create(nil);
    try
      Locked:=GetUniqueID;
      PLock.UseShowError:=false;
      PLock.UseWaitCursor:=false;
      PLock.ProviderName:='LOCK_OUT_MESSAGES';
      with PLock.Params do begin
        AddInvisible('MAX_COUNT').Value:=FMaxCount;
        AddInvisible('LOCKED').Value:=Locked;
        AddInvisible('TYPE_MESSAGE').Value:=DefaultTypeMessage;
        AddInvisible('PERIOD').Value:=iff(FPeriod=0,MaxInt,FPeriod);
        AddInvisible('CHANNEL').Value:=FormatEx(FSChannelFormat,[FLocalIP,FComPort]);
        AddInvisible('OPERATOR_ID').Value:=OperatorId;
        AddInvisible('LOCK_COUNT',ptOutput).Value:=0;
      end;
      try
        PLock.Execute;
        if PLock.Success then begin
          LockCount:=PLock.Params.ParamByName('LOCK_COUNT').AsInteger;
          LoggerWrite(FormatEx(FSLockMessages,[LockCount]));

          if LockCount>0 then begin

            PSelect:=TBisProvider.Create(nil);
            try
              PSelect.UseShowError:=false;
              PSelect.UseWaitCursor:=false;
              PSelect.ProviderName:='S_OUT_MESSAGES';
              with PSelect do begin
                with FieldNames do begin
                  AddInvisible('OUT_MESSAGE_ID');
                  AddInvisible('CREATOR_ID');
                  AddInvisible('RECIPIENT_ID');
                  AddInvisible('DATE_CREATE');
                  AddInvisible('TEXT_OUT');
                  AddInvisible('CONTACT');
                  AddInvisible('DELIVERY');
                  AddInvisible('FLASH');
                  AddInvisible('DEST_PORT');
                  AddInvisible('DESCRIPTION');
                  AddInvisible('CREATOR_NAME');
                  AddInvisible('RECIPIENT_NAME');
                  AddInvisible('RECIPIENT_PHONE');
                end;
                with FilterGroups.Add do begin
                  Filters.Add('LOCKED',fcEqual,Locked).CheckCase:=true;
                  Filters.Add('DATE_OUT',fcIsNull,Null);
                  Filters.Add('TYPE_MESSAGE',fcEqual,DefaultTypeMessage);
                end;
                with Orders do begin
                  Add('PRIORITY');
                  Add('DATE_BEGIN');
                end;
              end;
              try
                PSelect.Open;
                if PSelect.Active and not PSelect.IsEmpty then begin

                  DeleteMessagesByTypes([mtStoredUnsent,mtStoredSent]);
                  
                  PSelect.First;
                  while not PSelect.Eof do begin
                    Sent:=false;
                    MessageId:=Null;
                    try
                      if not Thread.Terminated then begin
                        Item:=TBisGsmModemMessage.Create;
                        try
                          S:=PSelect.FieldByName('TEXT_OUT').AsString;
                          for i:=0 to PSelect.Fields.Count-1 do begin
                            Field:=PSelect.Fields[i];
                            if not AnsiSameText(Field.FieldName,'TEXT_OUT') then
                              S:=StringReplace(S,'%'+Field.FieldName,VarToStrDef(Field.Value,''),[rfReplaceAll, rfIgnoreCase]);
                          end;
                          TextOut:=S;
                          Number:=GetOnlyChars(PSelect.FieldByName('CONTACT').AsString,PhoneChars);
                          if Number<>'' then begin
                            Item.OriginalText:=TextOut;
                            Item.StatusRequest:=Boolean(PSelect.FieldByName('DELIVERY').AsInteger);
                            Item.FlashSMS:=Boolean(PSelect.FieldByName('FLASH').AsInteger);
                            Item.OriginalNumber:=Number;
    //                        Item.MessageReference:=IntToHex(RandomRange(1,MAXBYTE),2); it doesn't work

                            DestPort:=PSelect.FieldByName('DEST_PORT').Value;
                            if not VarIsNull(DestPort) then
                              Item.DestinationPort:=VarToIntDef(DestPort,Item.DestinationPort)
                            else
                              Item.DestinationPort:=FDestPort;
                            Item.SourcePort:=FSourcePort;

                            LoggerWrite(FormatEx(FSOutMessageParams,
                                                 [PSelect.FieldByName('OUT_MESSAGE_ID').AsString,
                                                 Number,TextOut]));

                            Sent:=Modem.SendPduMessage(Item);
                            if Sent then begin
                              Modem.DeleteMessage(Item);
                              LoggerWrite(FSOutMessageSendSuccess)
                            end else
                              LoggerWrite(FormatEx(FSOutMessageSendFail,[SysErrorMessage(GetLastError)]),ltError);
                          end;
                        finally
                          Item.Free;
                        end;
                      end;
                    finally
                      UnlockMessage(Sent,MessageId);
                    end;
                    PSelect.Next;
                  end;

                end;
              except
                On E: Exception do
                  LoggerWrite(E.Message,ltError);
              end;
            finally
              PSelect.Free;
            end;
          end;
        end;
      except
        On E: Exception do
          LoggerWrite(E.Message,ltError);
      end;
    finally
      PLock.Free;
    end;
  end;

  procedure OutMessagesByOperators;
  var
    i: Integer;
  begin
    if FOperatorIds.Count>0 then begin
      for i:=0 to FOperatorIds.Count-1 do begin
        if Thread.Terminated then
          break;
         OutMessages(FOperatorIds[i]); 
      end;
    end else
      OutMessages(Null);
  end;
  
  function CheckImei: Boolean;
  begin
    Result:=Trim(FCheckImei)='';
    if not Result then begin
      Result:=AnsiSameText(FCheckImei,Modem.SerialNumber);
      if not Result then
        LoggerWrite(FSCheckImeiFail);
    end;
  end;

  function CheckImsi: Boolean;
  begin
    Result:=Trim(FCheckImsi)='';
    if not Result then begin
      Result:=AnsiSameText(FCheckImsi,Modem.Subscriber);
      if not Result then
        LoggerWrite(FSCheckImsiFail);
    end;
  end;

var
  Flag: Boolean;
begin
  Modem:=TBisGsmServerModemThread(Thread).FModem;

  if Assigned(Core) and Assigned(Modem) then begin

    Working:=true;
    try
      Randomize;
      try
        if not Modem.Connected then
          Modem.Connect;

        if Modem.Connected then begin

          Flag:=CheckImei;
          if Flag then
            Flag:=CheckImsi;

          if Flag then begin
            if FMaxCount>0 then begin
              case FMode of
                mmAll: begin
                  InMessages;
                  OutMessagesByOperators;
                end;
                mmIncoming: begin
                  InMessages;
                end;
                mmOutgoing: OutMessagesByOperators;
              end;
            end;
          end;
        end;
      except
        On E: Exception do
          LoggerWrite(E.Message,ltError);
      end;
    finally
      Thread.Reset;
      Working:=false;
    end;

  end;
end;

procedure TBisGsmServer.ThreadBegin(Thread: TBisThread);
var
  AThread: TBisGsmServerModemThread;
begin
  AThread:=TBisGsmServerModemThread(Thread);
  AThread.FModem:=TBisGsmModem.Create(Self);
  with AThread do begin
    FModem.OnStatus:=ModemStatus;
    FModem.Port:=FComPort;
    FModem.BaudRate:=FBaudRate;
    FModem.StopBits:=FStopBits;
    FModem.DataBits:=FDataBits;
    FModem.ParityBits:=FParityBits;
    FModem.Timeout:=FTimeOut;
  end;
end;

procedure TBisGsmServer.ThreadEnd(Thread: TBisThread);
begin
  with TBisGsmServerModemThread(Thread) do begin
    FreeAndNilEx(FModem);
  end;
end;

procedure TBisGsmServer.Start;
begin
  Stop;
  if not Started and Enabled then begin
    LoggerWrite(SStart);
    try
      FLocalIP:=GetLocalIP;
      FThread.Timeout:=FInterval;
      FThread.Start;
      FStarted:=True;
      LoggerWrite(SStartSuccess);
    except
      On E: Exception do begin
        LoggerWrite(FormatEx(SStartFail,[E.Message]),ltError);
      end;
    end;
  end;
end;

procedure TBisGsmServer.Stop;
begin
  if Started then begin
    LoggerWrite(SStop);
    try
      FThread.Stop;
      FStarted:=false;
      LoggerWrite(SStopSuccess);
    except
      On E: Exception do begin
        LoggerWrite(FormatEx(SStopFail,[E.Message]),ltError);
      end;
    end;
  end;
end;

end.