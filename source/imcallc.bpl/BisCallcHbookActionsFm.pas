unit BisCallcHbookActionsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, DB,
  BisDataGridFm, BisFm, BisFieldNames;

type
  TBisCallcHbookActionsForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisCallcHbookActionsFormIface=class(TBisDataGridFormIface)
  private
    function GetPurposeName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcHbookActionsForm: TBisCallcHbookActionsForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisCallcHbookActionEditFm;

{ TBisCallcHbookActionsFormIface }

constructor TBisCallcHbookActionsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookActionsForm;
  InsertClass:=TBisCallcHbookActionInsertFormIface;
  UpdateClass:=TBisCallcHbookActionUpdateFormIface;
  DeleteClass:=TBisCallcHbookActionDeleteFormIface;
  Permissions.Enabled:=true;
  Available:=true;
  ProviderName:='S_ACTIONS';
  with FieldNames do begin
    AddKey('ACTION_ID');
    AddInvisible('PURPOSE');
    Add('NAME','������������',150);
    Add('DESCRIPTION','��������',200);
    AddCalculate('PURPOSE_NAME','����������',GetPurposeName,ftString,100,100);
  end;
  Orders.Add('NAME');
end;

function TBisCallcHbookActionsFormIface.GetPurposeName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  S: String;
begin
  Result:=Null;
  S:=GetPurposeByIndex(DataSet.FieldByName('PURPOSE').AsInteger);
  if Trim(S)<>'' then
    Result:=S;
end;

end.