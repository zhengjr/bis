unit BisKrieltDataAnswersFm;

interface
                                                                                                    
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, DBCtrls, DB,
  BisFm, BisFieldNames, BisDataFrm, BisDataGridFrm, BisDataEditFm,
  BisDataGridFm;

type
  TBisKrieltDataAnswersFrame=class(TBisDataGridFrame)
  private
    FQuestionDateCreate: TDateTime;
    FQuestionNum: String;
    FQuestionId: Variant;
  protected
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); override;
  public
    property QuestionId: Variant read FQuestionId write FQuestionId;
    property QuestionNum: String read FQuestionNum write FQuestionNum;
    property QuestionDateCreate: TDateTime read FQuestionDateCreate write FQuestionDateCreate;
  end;

  TBisKrieltDataAnswersForm = class(TBisDataGridForm)
    PanelControls: TPanel;
    GroupBoxControls: TGroupBox;
    PanelDescription: TPanel;
    DBMemoAnswerText: TDBMemo;
  private
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataAnswersFormIface=class(TBisDataGridFormIface)
  private
    FQuestionId: Variant;
    FQuestionNum: String;
    FQuestionDateCreate: TDateTime;
    function GetConsultant(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;

    property QuestionId: Variant read FQuestionId write FQuestionId;
    property QuestionNum: String read FQuestionNum write FQuestionNum;
    property QuestionDateCreate: TDateTime read FQuestionDateCreate write FQuestionDateCreate;  
  end;

var
  BisKrieltDataInputTypesForm: TBisKrieltDataAnswersForm;

implementation

{$R *.dfm}

uses
    BisFilterGroups, BisOrders, BisUtils, BisParamEditDataSelect, BisParam,
    BisKrieltDataAnswerEditFm;

{ TBisKrieltDataAnswersFrame }

procedure TBisKrieltDataAnswersFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
var
  ParamId: TBisParamEditDataSelect;
  P1: TBisParam;
begin
  inherited BeforeIfaceExecute(AIface);
  if Assigned(AIface) then begin
    ParamId:=TBisParamEditDataSelect(AIface.Params.Find('QUESTION_ID'));
    if Assigned(ParamId) and not VarIsNull(FQuestionId) then begin
      ParamId.Value:=FQuestionId;
      with AIface do begin
        Params.ParamByName('QUESTION_NUM').Value:=FQuestionNum;
        Params.ParamByName('QUESTION_DATE_CREATE').Value:=FQuestionDateCreate;
        P1:=Params.ParamByName('QUESTION_NUM;QUESTION_DATE_CREATE');
        P1.Value:=FormatEx(ParamId.DataAliasFormat,[FQuestionNum,FQuestionDateCreate]);
      end;
      ParamId.ExcludeModes(AllParamEditModes);
    end;
  end;
end;

{ TBisKrieltDataAnswersFormIface }

constructor TBisKrieltDataAnswersFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataAnswersForm;
  FilterClass:=TBisKrieltDataAnswerFilterFormIface;
  InsertClass:=TBisKrieltDataAnswerInsertFormIface;
  UpdateClass:=TBisKrieltDataAnswerUpdateFormIface;
  DeleteClass:=TBisKrieltDataAnswerDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_ANSWERS';
  with FieldNames do begin
    AddKey('ANSWER_ID');
    AddInvisible('QUESTION_ID');
    AddInvisible('QUESTION_DATE_CREATE');
    AddInvisible('CONSULTANT_ID');
    AddInvisible('CONSULTANT_SURNAME');
    AddInvisible('CONSULTANT_NAME');
    AddInvisible('CONSULTANT_PATRONYMIC');
    AddInvisible('ANSWER_TEXT');
    Add('QUESTION_NUM','����� �������',50);
    Add('DATE_CREATE','���� ��������',130);
    AddCalculate('CONSULTANT','�����������',GetConsultant,ftString,300,250);
  end;
  Orders.Add('DATE_CREATE',otAsc);

  FQuestionId:=Null;
  FQuestionNum:='';
  FQuestionDateCreate:=Now;
end;

function TBisKrieltDataAnswersFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    with TBisKrieltDataAnswersForm(Result) do begin
      TBisKrieltDataAnswersFrame(DataFrame).QuestionId:=FQuestionId;
      TBisKrieltDataAnswersFrame(DataFrame).QuestionNum:=FQuestionNum;
      TBisKrieltDataAnswersFrame(DataFrame).QuestionDateCreate:=FQuestionDateCreate;
    end;
  end;
end;

function TBisKrieltDataAnswersFormIface.GetConsultant(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  S1,S2,S3: String;
begin
  Result:=Null;
  if Dataset.Active then begin
    S1:=DataSet.FieldByName('CONSULTANT_SURNAME').AsString;
    S2:=DataSet.FieldByName('CONSULTANT_NAME').AsString;
    S3:=DataSet.FieldByName('CONSULTANT_PATRONYMIC').AsString;
    Result:=FormatEx('%s %s %s',[S1,S2,S3]);
  end;
end;

{ TBisKrieltDataAnswersForm }

constructor TBisKrieltDataAnswersForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if Assigned(DataFrame) then begin
    DBMemoAnswerText.DataSource:=DataFrame.DataSource;
  end;
end;

class function TBisKrieltDataAnswersForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisKrieltDataAnswersFrame;
end;

end.