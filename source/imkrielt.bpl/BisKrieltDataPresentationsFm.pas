unit BisKrieltDataPresentationsFm;

interface
                                                                                                      
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, DB, DBCtrls,
  BisFm, BisDataGridFm, BisFieldNames, BisDataFrm,
  BisKrieltDataPresentationsFrm;

type
  TBisKrieltDataPresentationsForm = class(TBisDataGridForm)
    PanelControls: TPanel;
    GroupBoxControls: TGroupBox;
    PanelDescription: TPanel;
    DBMemoDescription: TDBMemo;
  private
    { Private declarations }
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataPresentationsFormIface=class(TBisDataGridFormIface)
  private
    function GetPresentationTypeName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;  
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataPresentationsForm: TBisKrieltDataPresentationsForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisKrieltDataPresentationEditFm;

{ TBisKrieltDataPresentationsFormIface }

constructor TBisKrieltDataPresentationsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataPresentationsForm;
  FilterClass:=TBisKrieltDataPresentationFilterFormIface;
  InsertClass:=TBisKrieltDataPresentationInsertFormIface;
  UpdateClass:=TBisKrieltDataPresentationUpdateFormIface;
  DeleteClass:=TBisKrieltDataPresentationDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_PRESENTATIONS';
  with FieldNames do begin
    AddKey('PRESENTATION_ID');
    AddInvisible('DESCRIPTION');
    AddInvisible('PRESENTATION_TYPE');
    AddInvisible('SORTING');
    AddInvisible('PUBLISHING_ID');
    AddInvisible('PUBLISHING_NAME');
    AddInvisible('VIEW_ID');
    AddInvisible('VIEW_NUM');
    AddInvisible('VIEW_NAME');
    AddInvisible('TYPE_ID');
    AddInvisible('TYPE_NUM');
    AddInvisible('TYPE_NAME');
    AddInvisible('OPERATION_ID');
    AddInvisible('OPERATION_NUM');
    AddInvisible('OPERATION_NAME');
    AddInvisible('CONDITIONS');
    Add('NAME','������������',300);
    Add('TABLE_NAME','������� ���������',180);
    AddCalculate('PRESENTATION_TYPE_NAME','��� �������������',GetPresentationTypeName,ftString,100,120);
  end;
  Orders.Add('NAME');
  Orders.Add('PRESENTATION_TYPE');
end;

function TBisKrieltDataPresentationsFormIface.GetPresentationTypeName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  S: String;
begin
  Result:=Null;
  S:=GetPresentationTypeByIndex(DataSet.FieldByName('PRESENTATION_TYPE').AsInteger);
  if Trim(S)<>'' then
    Result:=S;
end;

{ TBisKrieltDataPresentationsForm }

constructor TBisKrieltDataPresentationsForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if Assigned(DataFrame) then begin
    DBMemoDescription.DataSource:=DataFrame.DataSource;
  end;
end;

class function TBisKrieltDataPresentationsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisKrieltDataPresentationsFrame;
end;

end.