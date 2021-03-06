unit BisSmsServerMainFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, Menus, ActnPopup, ImgList,
  StdCtrls, ActnList,

  BisFm, BisObject, BisServerMainFm, BisServers, BisIfaceModules;

type
  TBisSmsServerMainForm = class(TBisServerMainForm)
  protected
    function GetServerClass: TBisServerClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    function CanOptions: Boolean; override;
    procedure Options; override;
  end;

  TBisSmsServerMainFormIface=class(TBisServerMainFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;


var
  BisSmsServerMainForm: TBisSmsServerMainForm;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;

exports
  InitIfaceModule;

implementation

{$R *.dfm}

uses BisCore, BisConsts, BisSmsServerConsts, BisUtils, BisSmsServer,
     BisSmsServerModemsFm;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
var
  IsMainModule: Boolean;
begin
  IsMainModule:=Core.IfaceModules.IsFirstModule(AModule);
  with AModule.Ifaces do begin
    if IsMainModule then
      AddClass(TBisSmsServerMainFormIface);
    AddClass(TBisSmsServerModemsFormIface);  
  end;
end;

{ TTBisSmsServerMainFormIface }

constructor TBisSmsServerMainFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisSmsServerMainForm;
end;

{ TTBisSmsServerMainForm }

constructor TBisSmsServerMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

function TBisSmsServerMainForm.GetServerClass: TBisServerClass;
begin
  Result:=TBisSmsServer;
end;

function TBisSmsServerMainForm.CanOptions: Boolean;
begin
  Result:=inherited CanOptions;
end;

procedure TBisSmsServerMainForm.Options;
var
  Iface: TBisSmsServerModemsFormIface;
begin
  if CanOptions then begin
    Iface:=TBisSmsServerModemsFormIface.Create(nil);
    try
      Iface.ShowModal;
    finally
      Iface.Free;
    end;
  end;
end;


end.
