unit BisSmppServerMainFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, Menus, ActnPopup, ImgList,
  StdCtrls, ActnList,

  BisFm, BisObject, BisServerMainFm, BisServers, BisIfaceModules;

type
  TBisSmppServerMainForm = class(TBisServerMainForm)
  protected
    function GetServerClass: TBisServerClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    function CanOptions: Boolean; override;
  end;

  TBisSmppServerMainFormIface=class(TBisServerMainFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;


var
  BisSmppServerMainForm: TBisSmppServerMainForm;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;

exports
  InitIfaceModule;

implementation

{$R *.dfm}

uses BisCore, BisConsts, BisSmppServerConsts, BisUtils, BisSmppServerInit;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
var
  IsMainModule: Boolean;
begin
  IsMainModule:=Core.IfaceModules.IsFirstModule(AModule);
  with AModule.Ifaces do begin
    if IsMainModule then
      AddClass(TBisSmppServerMainFormIface);
  end;
end;

{ TTBisSmppServerMainFormIface }

constructor TBisSmppServerMainFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisSmppServerMainForm;
end;

{ TTBisSmppServerMainForm }

constructor TBisSmppServerMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

function TBisSmppServerMainForm.GetServerClass: TBisServerClass;
begin
  Result:=TBisSmppServer;
end;

function TBisSmppServerMainForm.CanOptions: Boolean;
begin
  Result:=false;
end;

end.