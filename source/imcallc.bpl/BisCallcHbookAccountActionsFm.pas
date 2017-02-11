unit BisCallcHbookAccountActionsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList;

type
  TBisCallcHbookAccountActionsForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisCallcHbookAccountActionsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BiCallcHbookAccountActionsForm: TBisCallcHbookAccountActionsForm;

implementation

{$R *.dfm}

uses BisCallcHbookAccountActionEditFm;

{ TBisCallcHbookAccountActionsFormIface }

constructor TBisCallcHbookAccountActionsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookAccountActionsForm;
  InsertClass:=TBisCallcHbookAccountActionInsertFormIface;
  UpdateClass:=TBisCallcHbookAccountActionUpdateFormIface;
  DeleteClass:=TBisCallcHbookAccountActionDeleteFormIface;
  Permissions.Enabled:=true;
  Available:=true;
  ProviderName:='S_ACCOUNT_ACTIONS';
  with FieldNames do begin
    AddKey('ACCOUNT_ID');
    AddKey('ACTION_ID');
    Add('USER_NAME','������� ������',150);
    Add('ACTION_NAME','��������',150);
    Add('PRIORITY','�������',50);
  end;
  Orders.Add('USER_NAME');
  Orders.Add('PRIORITY');
  Orders.Add('ACTION_NAME');
end;

end.