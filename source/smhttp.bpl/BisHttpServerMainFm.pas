unit BisHttpServerMainFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, Menus, ActnPopup, ImgList,
  StdCtrls, ActnList,

  BisFm, BisObject, BisServerMainFm, BisServers, BisIfaceModules;

type
  TBisHttpServerMainForm = class(TBisServerMainForm)
  protected
    function GetServerClass: TBisServerClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    function CanOptions: Boolean; override;
  end;

  TBisHttpServerMainFormIface=class(TBisServerMainFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;


var
  BisHttpServerMainForm: TBisHttpServerMainForm;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;

exports
  InitIfaceModule;


implementation

{$R *.dfm}

uses BisConsts, BisHttpServerConsts, BisUtils, BisHttpServerInit;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
begin
  AModule.Ifaces.AddClass(TBisHttpServerMainFormIface);
end;

{ TTBisHttpServerMainFormIface }

constructor TBisHttpServerMainFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisHttpServerMainForm;
end;

{ TTBisHttpServerMainForm }

function TBisHttpServerMainForm.CanOptions: Boolean;
begin
  Result:=false;
end;

constructor TBisHttpServerMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

function TBisHttpServerMainForm.GetServerClass: TBisServerClass;
begin
  Result:=TBisHttpServer;
end;

end.