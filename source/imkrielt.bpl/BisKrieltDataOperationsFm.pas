unit BisKrieltDataOperationsFm;

interface                                                                                               

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList;

type
  TBisKrieltDataOperationsForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisKrieltDataOperationsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataOperationsForm: TBisKrieltDataOperationsForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisKrieltDataOperationEditFm;

{ TBisKrieltDataOperationsFormIface }

constructor TBisKrieltDataOperationsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataOperationsForm;
  InsertClass:=TBisKrieltDataOperationInsertFormIface;
  UpdateClass:=TBisKrieltDataOperationUpdateFormIface;
  DeleteClass:=TBisKrieltDataOperationDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_OPERATIONS';
  with FieldNames do begin
    AddKey('OPERATION_ID');
    AddInvisible('DESCRIPTION');
    Add('NUM','�����',50);
    Add('NAME','������������',300);
  end;
  Orders.Add('NUM');
end;

end.