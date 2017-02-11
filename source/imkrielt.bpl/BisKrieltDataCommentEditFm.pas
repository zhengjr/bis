unit BisKrieltDataCommentEditFm;

interface
                                                                                             
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ExtDlgs, ImgList,
  BisFm, BisDataEditFm, BisParam, BisControls;

type
  TBisKrieltDataCommentEditForm = class(TBisDataEditForm)
    LabelTitle: TLabel;
    EditTitle: TEdit;
    LabelParent: TLabel;
    EditParent: TEdit;
    ButtonParent: TButton;
    LabelDateComment: TLabel;
    DateTimePickerComment: TDateTimePicker;
    DateTimePickerCommentTime: TDateTimePicker;
    LabelAccount: TLabel;
    EditAccount: TEdit;
    ButtonAccount: TButton;
    LabelArticle: TLabel;
    EditArticle: TEdit;
    ButtonArticle: TButton;
    LabelText: TLabel;
    MemoText: TMemo;
    CheckBoxVisible: TCheckBox;
  private
  public
    constructor Create(AOwner: TComponent); override;
    procedure ChangeParam(Param: TBisParam); override;
    procedure Execute; override;
    function ChangesExists: Boolean; override;
    procedure BeforeShow; override;
  end;

  TBisKrieltDataCommentEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataCommentInsertFormIface=class(TBisKrieltDataCommentEditFormIface)
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataCommentInsertChildFormIface=class(TBisKrieltDataCommentEditFormIface)
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataCommentUpdateFormIface=class(TBisKrieltDataCommentEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataCommentDeleteFormIface=class(TBisKrieltDataCommentEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataCommentEditForm: TBisKrieltDataCommentEditForm;

implementation

uses BisProvider,
     BisFilterGroups, BisUtils, BisCore,
     BisKrieltDataCommentsFm, BisKrieltDataArticlesFm, BisKrieltConsts;

{$R *.dfm}

{ TBisKrieltDataCommentEditFormIface }

constructor TBisKrieltDataCommentEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataCommentEditForm;
  with Params do begin
    with AddKey('COMMENT_ID') do begin
      Older('OLD_COMMENT_ID');
    end;
    AddEditDataSelect('PARENT_ID','EditParent','LabelParent','ButtonParent',
                      TBisKrieltDataCommentsFormIface,'PARENT_TITLE',false,false,'COMMENT_ID','TITLE');
    AddEditDateTime('DATE_COMMENT','DateTimePickerComment','DateTimePickerCommentTime','LabelDateComment',true).ExcludeModes([emFilter]);
    AddCheckBox('VISIBLE','CheckBoxVisible').Value:=1;
    AddEditDataSelect('ACCOUNT_ID','EditAccount','LabelAccount','ButtonAccount',
                      SIfaceClassDataAccountsFormIface,'USER_NAME',true,false);
    AddEditDataSelect('ARTICLE_ID','EditArticle','LabelArticle','ButtonArticle',
                      TBisKrieltDataArticlesFormIface,'ARTICLE_TITLE',true,false,'','TITLE');
    AddEdit('TITLE','EditTitle','LabelTitle',true);
    AddMemo('COMMENT_TEXT','MemoText','LabelText',true);
  end;
end;

{ TBisKrieltDataCommentInsertFormIface }

constructor TBisKrieltDataCommentInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_COMMENT';
  Caption:='������� �����������';
end;

function TBisKrieltDataCommentInsertFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    if Assigned(ParentDataSet) and ParentDataSet.Active and not ParentDataSet.IsEmpty then begin
      with LastForm.Provider do begin
        Params.ParamByName('PARENT_ID').SetNewValue(ParentDataSet.FieldByName('PARENT_ID').Value);
        Params.ParamByName('PARENT_TITLE').SetNewValue(ParentDataSet.FieldByName('PARENT_TITLE').Value);
      end;
    end;
  end;
end;

{ TBisKrieltDataCommentInsertChildFormIface }

constructor TBisKrieltDataCommentInsertChildFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_COMMENT';
  Caption:='������� ��������������';
end;


function TBisKrieltDataCommentInsertChildFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    if Assigned(ParentDataSet) and ParentDataSet.Active and not ParentDataSet.IsEmpty then begin
      with LastForm.Provider do begin
        Params.ParamByName('PARENT_ID').SetNewValue(ParentDataSet.FieldByName('COMMENT_ID').Value);
        Params.ParamByName('PARENT_TITLE').SetNewValue(ParentDataSet.FieldByName('TITLE').Value);
      end;
    end;
  end;
end;

{ TBisKrieltDataCommentUpdateFormIface }

constructor TBisKrieltDataCommentUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_COMMENT';
  Caption:='�������� �����������';
end;

{ TBisKrieltDataCommentDeleteFormIface }

constructor TBisKrieltDataCommentDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_COMMENT';
  Caption:='������� �����������';
end;

{ TBisKrieltDataCommentEditForm }

constructor TBisKrieltDataCommentEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TBisKrieltDataCommentEditForm.ChangeParam(Param: TBisParam);
begin
  inherited ChangeParam(Param);
end;

function TBisKrieltDataCommentEditForm.ChangesExists: Boolean;
begin
  Result:=inherited ChangesExists;
end;

procedure TBisKrieltDataCommentEditForm.BeforeShow;
begin
  inherited BeforeShow;
  if Mode in [emInsert,emDuplicate] then begin
    with Provider do begin
      ParamByName('DATE_COMMENT').SetNewValue(Core.ServerDate);
    end;
  end;
  UpdateButtonState;
end;

procedure TBisKrieltDataCommentEditForm.Execute;
begin
  inherited Execute;
end;

end.