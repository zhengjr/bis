unit BisHttpServerHandlerEventWm;

interface

uses
  SysUtils, Classes, HTTPApp, DB, Contnrs,
  BisLogger, BisHttpServerHandlers;

type
  TBisHttpServerHandlerEventWebModule = class(TWebModule)
    procedure BisHttpServerHandlerEventWebModuleDefaultAction(Sender: TObject; Request: TWebRequest;
      Response: TWebResponse; var Handled: Boolean);
  private
    FHandler: TBisHttpServerHandler;

    procedure LoggerWrite(Message: String; LogType: TBisLoggerType=ltInformation);

    function Execute(Request: TWebRequest; Response: TWebResponse): Boolean;

  public
    property Handler: TBisHttpServerHandler read FHandler write FHandler;
  end;

var
  BisHttpServerHandlerEventWebModule: TBisHttpServerHandlerEventWebModule;

implementation

{$R *.dfm}

uses Windows, Variants, StrUtils, DateUtils,
     AlXmlDoc,
     BisCore, BisEvents, BisConfig, BisCoreUtils, 
     BisHttpServerHandlerEventConsts;


{ TBisHttpServerHandlerMessageWebModule }

procedure TBisHttpServerHandlerEventWebModule.LoggerWrite(Message: String; LogType: TBisLoggerType=ltInformation);
begin
  BisCoreUtils.ClassLoggerWrite(ClassName,Message,LogType);
end;

function TBisHttpServerHandlerEventWebModule.Execute(Request: TWebRequest; Response: TWebResponse): Boolean;

  procedure ReadEventParams(EventName: String; Config: TBisConfig; InParams: TBisEventParams);
  var
    P: TBisEventParam;
    i: Integer;
    Values: TStringList;
    N,V: String;
  begin
    Values:=TStringList.Create;
    try
      P:=nil;
      Config.ReadSectionValues(EventName,Values);
      for i:=0 to Values.Count-1 do begin
        N:=Values.Names[i];
        if Trim(N)<>'' then begin
          V:=Values.ValueFromIndex[i];
          P:=InParams.Add(N,V);
        end else begin
          if Assigned(P) then
            P.Value:=VarToStrDef(P.Value,'')+#13#10+Values.Strings[i];
        end;
      end;
    finally
      Values.Free;
    end;
  end;

  function ValidSessionId(InParams: TBisEventParams): Boolean;
  var
    P: TBisEventParam;
  begin
    Result:=false;
    if Core.Logged then begin
      P:=InParams.Find(SParamSessionId);
      if Assigned(P) then
        Result:=VarSameValue(Core.SessionId,P.Value);
    end else
      Result:=Assigned(Core.LoginIface) and not Core.LoginIface.Enabled and VarIsNull(Core.SessionId);
  end;

  function ExecuteEvent(EventName: String; InParams, OutParams: TBisEventParams): Boolean;
  var
    i: Integer;
    Event: TBisEvent;
    Events: TBisEvents;
    Flag: Boolean;
    Ret: Boolean;
  begin
    Core.Events.Lock;
    Events:=TBisEvents.Create;
    try
      Events.OwnsObjects:=false;
      Result:=false;
      Flag:=true;
      Core.Events.GetEvents(EventName,Events);
      for i:=0 to Events.Count-1 do begin
        Event:=Events.Items[i];
        if Assigned(Event) then begin
          try
            Ret:=Event.Execute(InParams,OutParams);
            if Flag then begin
              Flag:=false;
              Result:=Ret;
            end else
              Result:=Result and Ret;
          except
            on E: Exception do
              LoggerWrite(E.Message,ltError);
          end;
        end;
      end;
    finally
      Events.Free;
      Core.Events.UnLock;
    end;
  end;

  procedure WriteEvent(EventName: String; Success: Boolean; OutConfig: TBisConfig; OutParams: TBisEventParams);
  var
    i: Integer;
    Item: TBisEventParam;
  begin
    OutConfig.Write(EventName,SParamSuccess,IntToStr(Integer(Success)));
    for i:=0 to OutParams.Count-1 do begin
      Item:=OutParams.Items[i];
      OutConfig.Write(EventName,Item.Name,Item.AsString);
    end;
  end;

var
  InConfig: TBisConfig;
  OutConfig: TBisConfig;
  Events: TStringList;
  InParams: TBisEventParams;
  OutParams: TBisEventParams;
  EventName: String;
  Success: Boolean;
  i: Integer;
begin
  Result:=false;
  if Assigned(Core) then begin
    InConfig:=TBisConfig.Create(nil);
    OutConfig:=TBisConfig.Create(nil);
    Events:=TStringList.Create;
    try
      InConfig.Text:=Trim(Request.Content);
      InConfig.ReadSections(Events);
      if Events.Count>0 then begin
        Result:=true;
        for i:=0 to Events.Count-1 do begin
          InParams:=TBisEventParams.Create;
          OutParams:=TBisEventParams.Create;
          try
            try
              EventName:=Events[i];
              ReadEventParams(EventName,InConfig,InParams);
              Success:=false;
              if ValidSessionId(InParams) then
                Success:=ExecuteEvent(EventName,InParams,OutParams);
              WriteEvent(EventName,Success,OutConfig,OutParams);
            except
              on E: Exception do
                LoggerWrite(E.Message,ltError);
            end;
          finally
            OutParams.Free;
            InParams.Free;
          end;
        end;
      end;
    finally
      Response.Content:=Trim(OutConfig.Text);
      Response.ContentEncoding:=SDefaultEncoding;
      Events.Free;
      OutConfig.Free;
      InConfig.Free;
    end;
  end;
end;

procedure TBisHttpServerHandlerEventWebModule.BisHttpServerHandlerEventWebModuleDefaultAction(Sender: TObject;
          Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
begin
  Handled:=Execute(Request,Response);
end;

end.