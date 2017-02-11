unit BisSupportMainFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, DB, ImgList, ActnList, ComCtrls,
  Grids, DBGrids, ExtCtrls, StdCtrls, ToolWin, Buttons,
  BisControls, BisSupportFm;

type
  TBisSupportMainForm = class(TBisSupportForm)
  private
  public
    constructor Create(AOwner: TComponent); override;
    function CanOptions: Boolean; override;
  end;

  TBisSupportMainFormIface=class(TBisSupportFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var                                                                      
  BisSupportMainForm: TBisSupportMainForm;

implementation

{$R *.dfm}

uses BisDialogs, BisCore, BisUtils;

{ TBisSupportMainFormIface }

constructor TBisSupportMainFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisSupportMainForm;
  ApplicationCreateForm:=true;
  AutoShow:=true;
  Permissions.Enabled:=false;
  OnlyOneForm:=true;
end;

{ TBisSupportMainForm }

constructor TBisSupportMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

function TBisSupportMainForm.CanOptions: Boolean;
begin
  Result:=false;
end;

end.