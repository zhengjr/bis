unit BisKrieltDataTypesFm;

interface                                                                                                

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList,
  BisFm, BisDataGridFm, BisDataFrm;

type
  TBisKrieltDataTypesForm = class(TBisDataGridForm)
  private
    { Private declarations }
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;  
  public
    { Public declarations }
  end;

  TBisKrieltDataTypesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataTypesForm: TBisKrieltDataTypesForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisKrieltDataTypeEditFm, BisKrieltDataTypesFrm;

{ TBisKrieltDataTypesFormIface }

constructor TBisKrieltDataTypesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataTypesForm;
  InsertClass:=TBisKrieltDataTypeInsertFormIface;
  UpdateClass:=TBisKrieltDataTypeUpdateFormIface;
  DeleteClass:=TBisKrieltDataTypeDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_TYPES';
  with FieldNames do begin
    AddKey('TYPE_ID');
    AddInvisible('DESCRIPTION');
    Add('NUM','�����',50);
    Add('NAME','������������',300);
  end;
  Orders.Add('NUM');
end;

{ TBisKrieltDataTypesForm }

class function TBisKrieltDataTypesForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisKrieltDataTypesFrame;
end;

end.