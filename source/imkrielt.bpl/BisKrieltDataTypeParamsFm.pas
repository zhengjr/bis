unit BisKrieltDataTypeParamsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList,
  BisFm, BisDataGridFm;

type
  TBisKrieltDataInputParamsForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisKrieltDataTypeParamsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataTypeTypesForm: TBisKrieltDataInputParamsForm;

implementation

{$R *.dfm}

uses BisKrieltDataTypeParamEditFm;

{ TBisKrieltDataTypeParamsFormIface }

constructor TBisKrieltDataTypeParamsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataTypeParamsForm;
  FilterClass:=TBisKrieltDataTypeParamFilterFormIface;
  InsertClass:=TBisKrieltDataTypeParamInsertFormIface;
  UpdateClass:=TBisKrieltDataTypeParamUpdateFormIface;
  DeleteClass:=TBisKrieltDataTypeParamDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  FilterOnShow:=true;
  ProviderName:='S_TYPE_PARAMS';
  with FieldNames do begin
    AddKey('TYPE_ID');
    AddKey('PARAM_ID');
    AddKey('OPERATION_ID');
    AddInvisible('MAIN');
    AddInvisible('VISIBLE');
    Add('PARAM_NAME','��������',150);
    Add('TYPE_NAME','��� �������',150);
    Add('OPERATION_NAME','��������',100);
    Add('PRIORITY','�������',50);
  end;
  Orders.Add('PARAM_NAME');
  Orders.Add('TYPE_NAME');
  Orders.Add('OPERATION_NAME');
  Orders.Add('PRIORITY');
end;

end.