unit BisCallcHbookAccountFirmsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList;

type
  TBisCallcHbookAccountFirmsForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisCallcHbookAccountFirmsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BiCallcHbookAccountFirmsForm: TBisCallcHbookAccountFirmsForm;

implementation

{$R *.dfm}

uses BisCallcHbookAccountFirmEditFm;

{ TBisCallcHbookAccountFirmsFormIface }

constructor TBisCallcHbookAccountFirmsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookAccountFirmsForm;
  InsertClass:=TBisCallcHbookAccountFirmInsertFormIface;
  UpdateClass:=TBisCallcHbookAccountFirmUpdateFormIface;
  DeleteClass:=TBisCallcHbookAccountFirmDeleteFormIface;
  Permissions.Enabled:=true;
  Available:=true;
  ProviderName:='S_ACCOUNT_FIRMS';
  with FieldNames do begin
    AddKey('ACCOUNT_ID');
    AddKey('FIRM_ID');
    Add('USER_NAME','������� ������',150);
    Add('FIRM_SMALL_NAME','�����������',200);
  end;
  Orders.Add('USER_NAME');
  Orders.Add('FIRM_SMALL_NAME');
end;

end.