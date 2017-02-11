unit BisDesignDataScriptsFrm;

interface
                                                                                                   
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin,
  ExtCtrls, Grids, DBGrids, Contnrs, StdCtrls,

  BisDataGridFrm, BisDataFrm, BisScriptModules, BisScriptIface;

type
  TBisDesignDataScriptsFrameScripts=class(TObjectList)
  public
    function FindByClass(AClass: TClass; ACaption: String): TBisScriptIface;
  end;

  TBisDesignDataScriptsFrame = class(TBisDataGridFrame)
    ToolBarScript: TToolBar;
    ToolButtonScriptShow: TToolButton;
    ActionScriptShow: TAction;
    MenuItemScriptShow: TMenuItem;
    N16: TMenuItem;
    procedure ActionScriptShowExecute(Sender: TObject);
    procedure ActionScriptShowUpdate(Sender: TObject);
  private
    FScripts: TBisDesignDataScriptsFrameScripts;
    FOnCanScriptShow: TBisDataFrameCanEvent;
    function GetScriptClass: TBisScriptIfaceClass;
    function GetModuleByName(EngineName: String): TBisScriptModule;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CanScriptShow: Boolean;
    procedure ScriptShow;

    property OnCanScriptShow: TBisDataFrameCanEvent read FOnCanScriptShow write FOnCanScriptShow;
  end;

implementation

uses BisProvider, BisDialogs, BisUtils, BisFilterGroups,
     BisParam, BisCore;

{$R *.dfm}

{ TBisDesignDataScriptsFrameScripts }

function TBisDesignDataScriptsFrameScripts.FindByClass(AClass: TClass; ACaption: String): TBisScriptIface;
var
  i: Integer;
  Obj: TObject;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Obj:=Items[i];
    if Assigned(Obj) and (Obj is TBisScriptIface) and (Obj.ClassType=AClass) then begin
      if Trim(ACaption)<>'' then begin
        if AnsiSameText(TBisScriptIface(Obj).Caption,ACaption) then begin
          Result:=TBisScriptIface(Obj);
          exit;
        end;
      end else begin
        Result:=TBisScriptIface(Obj);
        exit;
      end;
    end;
  end;
end;


{ TBisDesignDataScriptsFrame }

constructor TBisDesignDataScriptsFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FScripts:=TBisDesignDataScriptsFrameScripts.Create;
end;

destructor TBisDesignDataScriptsFrame.Destroy;
begin
  FScripts.Free;
  inherited Destroy;
end;

procedure TBisDesignDataScriptsFrame.ActionScriptShowExecute(Sender: TObject);
begin
  ScriptShow;
end;

procedure TBisDesignDataScriptsFrame.ActionScriptShowUpdate(Sender: TObject);
begin
  ActionScriptShow.Enabled:=CanScriptShow;
end;

function TBisDesignDataScriptsFrame.GetModuleByName(EngineName: String): TBisScriptModule;
var
  i: Integer;
  Module: TBisScriptModule;  
begin
  Result:=nil;
  for i:=0 to Core.ScriptModules.Count-1 do begin
    Module:=Core.ScriptModules.Items[i];
    if AnsiSameText(Module.ObjectName,EngineName) then begin
      Result:=Module;
      exit;
    end;
  end;
end;

function TBisDesignDataScriptsFrame.GetScriptClass: TBisScriptIfaceClass;
var
  P: TBisProvider;
  Module: TBisScriptModule;
begin
  Result:=nil;
  P:=GetCurrentProvider;
  if Assigned(P) and P.Active and not P.IsEmpty then begin
    Module:=GetModuleByName(P.FieldByName('ENGINE').AsString);
    if Assigned(Module) and Assigned(Module.ScriptClass) then
      Result:=Module.ScriptClass;
  end;
end;

function TBisDesignDataScriptsFrame.CanScriptShow: Boolean;
var
  P: TBisProvider;
  AClass: TBisScriptIfaceClass;
begin
  P:=GetCurrentProvider;
  AClass:=GetScriptClass;
  Result:=Assigned(P) and P.Active and not P.IsEmpty and Assigned(AClass);
  if Result and Assigned(FOnCanScriptShow) then begin
    Result:=FOnCanScriptShow(Self);
  end;  
end;

procedure TBisDesignDataScriptsFrame.ScriptShow;
var
  P: TBisProvider;
  AClass: TBisScriptIfaceClass;
  AScript: TBisScriptIface;
  ACaption: String;
begin
  if CanScriptShow then begin
    P:=GetCurrentProvider;
    if Assigned(P) and P.Active and not P.IsEmpty then begin
      AClass:=GetScriptClass;
      if Assigned(AClass) then begin
        ACaption:=P.FieldByName('INTERFACE_NAME').AsString;
        AScript:=FScripts.FindByClass(AClass,ACaption);
        if not Assigned(AScript) then begin
          AScript:=AClass.Create(Self);
          AScript.Permissions.Enabled:=false;
          FScripts.Add(AScript);
          AScript.Init;
        end;
        AScript.Caption:=ACaption;
        AScript.ScriptId:=P.FieldByName('SCRIPT_ID').Value;
        AScript.Show;
      end;
    end;
  end; 
end;


end.