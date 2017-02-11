unit BisCallcTakeBellFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin,
  StdCtrls, ExtCtrls, Grids, DBGrids,
  BisDataEditFm, BisDataGridFrm, BisDataFrm, BisProvider, BisVariants,
  BisCallcTakeBellFilterFm, BisControls;

type
  TBisCallcTakeBellFrame=class;

  TEdit=class(BisControls.TEdit)
  private
    FFrame: TBisCallcTakeBellFrame;
    FID: Variant;
    procedure CNKeyDown(var Message: TWMKeyDown); message CN_KEYDOWN;
  public
    property Frame: TBisCallcTakeBellFrame read FFrame write FFrame;
    property ID: Variant read FID write FID;
  end;

  TNewEditDate=class(BisControls.TEditDate)
  private
    FFrame: TBisCallcTakeBellFrame;
    procedure CNKeyDown(var Message: TWMKeyDown); message CN_KEYDOWN;
  public
    property Frame: TBisCallcTakeBellFrame read FFrame write FFrame;
  end;

  TBisCallcTakeBellUpdateFormIface=class(TBisDataEditFormIface)
  private
    FTaskExecuted: Boolean;
    FOnExecute: TNotifyEvent;
  public
    procedure Execute; override;

    property TaskExecuted: Boolean read FTaskExecuted;
    property OnExecute: TNotifyEvent read FOnExecute write FOnExecute;
  end;

  TBisCallcTakeBellFrame = class(TBisDataGridFrame)
    GroupBoxFilter: TGroupBox;
    LabelSurname: TLabel;
    LabelName: TLabel;
    LabelPatronymic: TLabel;
    LabelStatus: TLabel;
    LabelDealNum: TLabel;
    LabelDebtorNum: TLabel;
    LabelDebtorDate: TLabel;
    LabelAddress: TLabel;
    LabelAccountNum: TLabel;
    LabelFirm: TLabel;
    EditSurname: TEdit;
    EditName: TEdit;
    EditPatronymic: TEdit;
    ComboBoxStatus: TComboBox;
    EditDealNum: TEdit;
    EditDebtorNum: TEdit;
    DateTimePickerDebtorDate: TDateTimePicker;
    EditAddress: TEdit;
    EditAccountNum: TEdit;
    EditFirm: TEdit;
    ActionApplyPlan: TAction;
    N13: TMenuItem;
    N15: TMenuItem;
    ActionApplyGroup: TAction;
    N16: TMenuItem;
    LabelDateCreateBegin: TLabel;
    DateTimePickerCreateBegin: TDateTimePicker;
    LabelDateCreateEnd: TLabel;
    DateTimePickerCreateEnd: TDateTimePicker;
    LabelAgreementNum: TLabel;
    EditAgreementNum: TEdit;
    ButtonAgreementNum: TButton;
    LabelActionName: TLabel;
    EditActionName: TEdit;
    ButtonActionName: TButton;
    procedure ActionApplyPlanExecute(Sender: TObject);
    procedure ActionApplyPlanUpdate(Sender: TObject);
    procedure ActionApplyGroupExecute(Sender: TObject);
    procedure ActionApplyGroupUpdate(Sender: TObject);
    procedure ComboBoxStatusChange(Sender: TObject);
    procedure ComboBoxStatusEnter(Sender: TObject);
    procedure ButtonAgreementNumClick(Sender: TObject);
    procedure ButtonActionNameClick(Sender: TObject);
  private
    FDebtorEditDate: TNewEditDate;
    FCreateBeginEditDate: TNewEditDate;
    FCreateEndEditDate: TNewEditDate;
    FActions: TBisVariants;
    FGroups: TBisVariants;
    FOldActionUpdateShortCut: TShortCut;
    FOldActionViewingShortCut: TShortCut;
    FOnCanApplyPlan: TBisDataFrameCanEvent;
    FOnCanApplyGroup: TBisDataFrameCanEvent;
    procedure RefreshActions;
    procedure RefreshGroups;
    function Locked: Boolean;
    function Closed: Boolean;
    procedure CreateBeginEditDateExit(Sender: TObject);
    procedure TakeBellFilterFormIfaceAfterExecute(ASender: TBisDataEditForm; AProvider: TBisProvider);
    procedure TakeBellUpdateFormIfaceAfterExecute(Sender: TObject);
  protected
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure OpenRecords; override;
    function CanUpdateRecord: Boolean; override;

    function CanApplyPlan: Boolean;
    procedure ApplyPlan;
    function CanApplyGroup: Boolean;
    procedure ApplyGroup;

    property OnCanApplyPlan: TBisDataFrameCanEvent read FOnCanApplyPlan write FOnCanApplyPlan;
    property OnCanApplyGroup: TBisDataFrameCanEvent read FOnCanApplyGroup write FOnCanApplyGroup;
  end;

implementation

uses DateUtils,
     BisUtils, BisFilterGroups, BisConsts, BisCore, BisDialogs,
     BisCallcDealEditFm, BisCallcConsts, BisCallcTaskFm,
     BisCallcTaskOperatorFm, BisCallcTaskClerkFm, BisCallcTaskLeaderFm, BisCallcTaskManagerFm,
     BisCallcHbookPlansFm, BisCallcHbookGroupsFm, BisCallcHbookAgreementsFm, BisCallcHbookActionsFm;

{$R *.dfm}

{ TEdit }

procedure TEdit.CNKeyDown(var Message: TWMKeyDown);
begin
  if Assigned(FFrame) and (Message.CharCode=VK_RETURN) then begin
    FFrame.RefreshRecords;
    Message.Result:=1;
    exit;
  end;
  if ReadOnly and (Message.CharCode in [VK_DELETE,VK_BACK]) then begin
    if SelLength=Length(Text) then begin
      FID:=Null;
      Text:='';
      Message.Result:=1;
      exit;
    end;
  end;
  inherited;
end;

{ TNewEditDate }

procedure TNewEditDate.CNKeyDown(var Message: TWMKeyDown);
begin
  if Assigned(FFrame) and (Message.CharCode=VK_RETURN) then begin
    FFrame.RefreshRecords;
    Message.Result:=1;
    exit;
  end;
  inherited;
end;

{ TBisCallcTakeBellUpdateFormIface }

procedure TBisCallcTakeBellUpdateFormIface.Execute;

  function Locked: Boolean;
  var
    P: TBisProvider;
  begin
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='S_TASKS';
      with P.FilterGroups.Add do begin
        Filters.Add('TASK_ID',fcEqual,ParentProvider.FieldByName('TASK_ID').Value);
        Filters.Add('ACCOUNT_ID',fcIsNotNull,Null);
      end;
      P.Open;
      Result:=P.Active and not P.IsEmpty; 
    finally
      P.Free;
    end;
  end;

var
  APurpose: Integer;
  AIface: TBisCallcTaskFormIface;
  AClass: TBisCallcTaskFormIfaceClass;
begin
  FTaskExecuted:=false;
  if Assigned(ParentProvider) and ParentProvider.Active and not ParentProvider.IsEmpty then begin
    APurpose:=ParentProvider.FieldByName('PURPOSE').AsInteger;
    AClass:=nil;
    case APurpose of
      0: AClass:=TBisCallcTaskOperatorFormIface;
      1: AClass:=TBisCallcTaskClerkFormIface;
      2: AClass:=TBisCallcTaskLeaderFormIface;
      3: AClass:=TBisCallcTaskManagerFormIface;
    end;
    if Assigned(AClass) then begin
      if not Locked then begin
        AIface:=AClass.Create(nil);
        try
          AIface.OnlyOneTask:=true;
          AIface.TaskId:=ParentProvider.FieldByName('TASK_ID').Value;
          AIface.FromDateCreate:=ParentProvider.FieldByName('DATE_CREATE').Value;
          FTaskExecuted:=AIface.ShowModal=mrOk;
        finally
          AIface.Free;
        end;
        if Assigned(FOnExecute) then
          FOnExecute(Self);
      end else
        ShowError('������� �������������.');
    end;
  end;
end;

{ TBisCallcTakeBellFrame }

constructor TBisCallcTakeBellFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FilterClass:=TBisCallcTakeBellFilterFormIface;
  ViewingClass:=TBisCallcDealEditFormIface;
  UpdateClass:=TBisCallcTakeBellUpdateFormIface;
  with Provider.FieldNames do begin
    AddKey('TASK_ID');
    AddInvisible('DEAL_ID');
    AddInvisible('ACTION_ID');
    AddInvisible('RESULT_ID');
    AddInvisible('ACCOUNT_ID');
    AddInvisible('PURPOSE');
    AddInvisible('DATE_CLOSE');
    Add('DATE_CREATE','���� ��������',60).DisplayFormat:=SDisplayFormatDateTime;
    Add('ACTION_NAME','��������',45);
    Add('DEAL_NUM','� ����',30);
    Add('FIRM_SMALL_NAME','��������',75);
    Add('SURNAME','�������',60);
    Add('NAME','���',55);
    Add('PATRONYMIC','��������',70);
    Add('ACCOUNT_NUM','����',50);
    Add('CURRENT_DEBT','����',60).DisplayFormat:=SDisplayFormatFloat;
    Add('CURRENCY_NAME','������',25);
    Add('ARREAR_PERIOD','������',30);
  end;
  with Provider.Orders do begin
    Add('DATE_CREATE');
  end;

  Grid.AutoResizeableColumns:=true;
  Grid.OnEnter:=ComboBoxStatusEnter;
  ActionExport.Visible:=false;
  ActionFilter.Visible:=false;
  ActionInsert.Visible:=false;
  ActionDuplicate.Visible:=false;
  ActionDelete.Visible:=false;
  ActionUpdate.Caption:='�������';
  ActionUpdate.Hint:='������� �������';

  FOldActionUpdateShortCut:=ActionUpdate.ShortCut;
  FOldActionViewingShortCut:=ActionViewing.ShortCut;

  EditSurname.Frame:=Self;
  EditName.Frame:=Self;
  EditPatronymic.Frame:=Self;
  EditDealNum.Frame:=Self;
  EditDebtorNum.Frame:=Self;
  EditAddress.Frame:=Self;
  EditAccountNum.Frame:=Self;
  EditFirm.Frame:=Self;
  EditAgreementNum.Frame:=Self;
  EditActionName.Frame:=Self;

  EditAgreementNum.Color:=ColorControlReadOnly;
  EditActionName.Color:=ColorControlReadOnly;

  FDebtorEditDate:=TNewEditDate(ReplaceDateTimePickerToEditDate(DateTimePickerDebtorDate,TNewEditDate));
  FDebtorEditDate.OnEnter:=ComboBoxStatusEnter;
  FDebtorEditDate.Frame:=Self;

  FCreateBeginEditDate:=TNewEditDate(ReplaceDateTimePickerToEditDate(DateTimePickerCreateBegin,TNewEditDate));
  FCreateBeginEditDate.OnEnter:=ComboBoxStatusEnter;
  FCreateBeginEditDate.OnExit:=CreateBeginEditDateExit;
  FCreateBeginEditDate.Frame:=Self;

  FCreateEndEditDate:=TNewEditDate(ReplaceDateTimePickerToEditDate(DateTimePickerCreateEnd,TNewEditDate));
  FCreateEndEditDate.OnEnter:=ComboBoxStatusEnter;
  FCreateEndEditDate.Frame:=Self;

  FActions:=TBisVariants.Create;
  RefreshActions;
  FGroups:=TBisVariants.Create;
  RefreshGroups;
end;

destructor TBisCallcTakeBellFrame.Destroy;
begin
  FGroups.Free;
  FActions.Free;
  FCreateEndEditDate.Free;
  FCreateBeginEditDate.Free;
  FDebtorEditDate.Free;
  inherited Destroy;
end;

procedure TBisCallcTakeBellFrame.CreateBeginEditDateExit(Sender: TObject);
var
  V: Variant;
begin
  V:=FCreateEndEditDate.Date2;
  if VarIsNull(V) then
    FCreateEndEditDate.Date:=FCreateBeginEditDate.Date;
end;

procedure TBisCallcTakeBellFrame.RefreshActions;
var
  P: TBisProvider;
begin
  FActions.Clear;
  P:=TBisProvider.Create(nil);
  try
    P.ProviderName:='S_ACCOUNT_ACTIONS';
    P.FieldNames.AddInvisible('ACTION_ID');
    P.FilterGroups.Add.Filters.Add('ACCOUNT_ID',fcEqual,Core.AccountId);
    P.Orders.Add('PRIORITY');
    P.Open;
    if P.Active and not P.IsEmpty then begin
      P.First;
      while not P.Eof do begin
        FActions.Add(P.FieldByName('ACTION_ID').Value);
        P.Next;
      end;
    end;
  finally
    P.Free;
  end;
end;

procedure TBisCallcTakeBellFrame.RefreshGroups;
var
  P: TBisProvider;
begin
  FGroups.Clear;
  P:=TBisProvider.Create(nil);
  try
    P.ProviderName:='S_ACCOUNT_GROUPS';
    P.FieldNames.AddInvisible('GROUP_ID');
    P.FilterGroups.Add.Filters.Add('ACCOUNT_ID',fcEqual,Core.AccountId);
    P.Orders.Add('PRIORITY');
    P.Open;
    if P.Active and not P.IsEmpty then begin
      P.First;
      while not P.Eof do begin
        FGroups.Add(P.FieldByName('GROUP_ID').Value);
        P.Next;
      end;
    end;
  finally
    P.Free;
  end;
end;

function TBisCallcTakeBellFrame.Locked: Boolean;
begin
  Result:=false;
  if Provider.Active and not Provider.IsEmpty then
    Result:=not VarIsNull(Provider.FieldByName('ACCOUNT_ID').Value);
end;

function TBisCallcTakeBellFrame.Closed: Boolean;
begin
  Result:=false;
  if Provider.Active and not Provider.IsEmpty then begin
    Result:=not VarIsNull(Provider.FieldByName('DATE_CLOSE').Value) and
            VarIsNull(Provider.FieldByName('RESULT_ID').Value);
  end;
end;

procedure TBisCallcTakeBellFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
begin
  inherited BeforeIfaceExecute(AIface);
  if Assigned(AIface) then begin
    if AIface is TBisCallcTakeBellFilterFormIface then
      AIface.OnAfterExecute:=TakeBellFilterFormIfaceAfterExecute;
    if AIface is TBisCallcDealEditFormIface then begin
      with TBisCallcDealEditFormIface(AIface) do begin
        AsModal:=true;
        DealId:=Provider.FieldByName('DEAL_ID').Value;
        DealNum:=Provider.FieldByName('DEAL_NUM').Value;
        TaskId:=Provider.FieldByName('TASK_ID').Value;
        ActionId:=Provider.FieldByName('ACTION_ID').Value;
      end;
    end;
    if AIface is TBisCallcTakeBellUpdateFormIface then begin
      TBisCallcTakeBellUpdateFormIface(AIface).OnExecute:=TakeBellUpdateFormIfaceAfterExecute;
    end;
  end;
end;

procedure TBisCallcTakeBellFrame.ButtonActionNameClick(Sender: TObject);
var
  Iface: TBisCallcHbookActionsFormIface;
  P: TBisProvider;
begin
  Iface:=TBisCallcHbookActionsFormIface.Create(nil);
  P:=TBisProvider.Create(nil);
  try
    Iface.LocateFields:='ACTION_ID';
    Iface.LocateValues:=EditActionName.ID;
    if Iface.SelectInto(P) then begin
      if P.Active and not P.IsEmpty then begin
        EditActionName.Text:=P.FieldByName('NAME').AsString;
        EditActionName.ID:=P.FieldByName('ACTION_ID').Value;
        RefreshRecords;
      end;
    end;
  finally
    P.Free;
    Iface.Free;
  end;
end;

procedure TBisCallcTakeBellFrame.ButtonAgreementNumClick(Sender: TObject);
var
  Iface: TBisCallcHbookAgreementsFormIface;
  P: TBisProvider;
begin
  Iface:=TBisCallcHbookAgreementsFormIface.Create(nil);
  P:=TBisProvider.Create(nil);
  try
    Iface.LocateFields:='AGREEMENT_ID';
    Iface.LocateValues:=EditAgreementNum.ID;
    if Iface.SelectInto(P) then begin
      if P.Active and not P.IsEmpty then begin
        EditAgreementNum.Text:=P.FieldByName('NUM').AsString;
        EditAgreementNum.ID:=P.FieldByName('AGREEMENT_ID').Value;
        RefreshRecords;
      end;
    end;
  finally
    P.Free;
    Iface.Free;
  end;
end;

procedure TBisCallcTakeBellFrame.TakeBellFilterFormIfaceAfterExecute(ASender: TBisDataEditForm; AProvider: TBisProvider);
var
  AForm: TBisCallcTakeBellFilterForm;
  i: Integer;
  Info,Obj: TBisCallcStatusInfo;
begin
  if Assigned(ASender) and (ASender is TBisCallcTakeBellFilterForm) then begin
    AForm:=TBisCallcTakeBellFilterForm(ASender);
    if (AForm.RadioGroupStatuses.ItemIndex<>-1) then begin
      ClearStrings(ComboBoxStatus.Items);
      for I := 0 to AForm.RadioGroupStatuses.Items.Count - 1 do begin
        Info:=TBisCallcStatusInfo(AForm.RadioGroupStatuses.Items.Objects[i]);
        Obj:=TBisCallcStatusInfo.Create;
        Obj.TableName:=Info.TableName;
        Obj.Condition:=Info.Condition;
        ComboBoxStatus.Items.AddObject(AForm.RadioGroupStatuses.Items[i],Obj);
      end;
      ComboBoxStatus.ItemIndex:=AForm.RadioGroupStatuses.ItemIndex;
      OpenRecords;
      LastFiltered:=true;
    end;
  end;
end;

procedure TBisCallcTakeBellFrame.TakeBellUpdateFormIfaceAfterExecute(Sender: TObject);
begin
  if TBisCallcTakeBellUpdateFormIface(Sender).TaskExecuted then
    OpenRecords;
end;

procedure TBisCallcTakeBellFrame.OpenRecords;
var
  Info: TBisCallcStatusInfo;
  i: Integer;
begin
  if ComboBoxStatus.ItemIndex<>-1 then begin
    Info:=TBisCallcStatusInfo(ComboBoxStatus.Items.Objects[ComboBoxStatus.ItemIndex]);

    Provider.ProviderName:=Info.TableName;

    Provider.FilterGroups.Clear;
    Provider.FilterGroups.Add.Filters.AddSql(Info.Condition);
    with Provider.FilterGroups.Add do begin
      with Filters.Add('DEAL_NUM',fcLike,iff(EditDealNum.Text<>'',EditDealNum.Text,NULL)) do begin
        LeftSide:=true;
        RightSide:=true;
      end;
      with Filters.Add('SURNAME',fcLike,iff(EditSurname.Text<>'',EditSurname.Text,NULL)) do begin
        LeftSide:=true;
        RightSide:=true;
      end;
      with Filters.Add('NAME',fcLike,iff(EditName.Text<>'',EditName.Text,NULL)) do begin
        LeftSide:=true;
        RightSide:=true;
      end;
      with Filters.Add('PATRONYMIC',fcLike,iff(EditPatronymic.Text<>'',EditPatronymic.Text,NULL)) do begin
        LeftSide:=true;
        RightSide:=true;
      end;
      with Filters.Add('ACCOUNT_NUM',fcLike,iff(EditAccountNum.Text<>'',EditAccountNum.Text,NULL)) do begin
        LeftSide:=true;
        RightSide:=true;
      end;
      with Filters.Add('FIRM_SMALL_NAME',fcLike,iff(EditFirm.Text<>'',EditFirm.Text,NULL)) do begin
        LeftSide:=true;
        RightSide:=true;
      end;
      with Filters.Add('DEBTOR_NUM',fcLike,iff(EditDebtorNum.Text<>'',EditDebtorNum.Text,NULL)) do begin
        LeftSide:=true;
        RightSide:=true;
      end;
      Filters.Add('DEBTOR_DATE',fcEqual,iff(FDebtorEditDate.Date<>NullDate,FDebtorEditDate.Date,NULL));
      Filters.Add('DATE_CREATE',fcEqualGreater,iff(FCreateBeginEditDate.Date<>NullDate,FCreateBeginEditDate.Date,NULL));
      Filters.Add('DATE_CREATE',fcLess,iff(FCreateEndEditDate.Date<>NullDate,IncDay(FCreateEndEditDate.Date),NULL));
      Filters.Add('AGREEMENT_ID',fcEqual,EditAgreementNum.ID);
      Filters.Add('ACTION_ID',fcEqual,EditActionName.ID);
    end;

    with Provider.FilterGroups.Add do begin
      with Filters.Add('ADDRESS_RESIDENCE',fcLike,iff(EditAddress.Text<>'',EditAddress.Text,NULL)) do begin
        LeftSide:=true;
        RightSide:=true;
      end;
      with Filters.Add('ADDRESS_ACTUAL',fcLike,iff(EditAddress.Text<>'',EditAddress.Text,NULL)) do begin
        LeftSide:=true;
        RightSide:=true;
        Operator:=foOr;
      end;
      with Filters.Add('ADDRESS_ADDITIONAL',fcLike,iff(EditAddress.Text<>'',EditAddress.Text,NULL)) do begin
        LeftSide:=true;
        RightSide:=true;
        Operator:=foOr;
      end;
      with Filters.Add('ADDRESS_WORK',fcLike,iff(EditAddress.Text<>'',EditAddress.Text,NULL)) do begin
        LeftSide:=true;
        RightSide:=true;
        Operator:=foOr;
      end;
    end;

    with Provider.FilterGroups.Add do begin
      for i:=0 to FActions.Count - 1 do
        Filters.Add('ACTION_ID',fcEqual,FActions.Items[i].Value).Operator:=foOr;
    end;

    with Provider.FilterGroups.Add do begin
      for i:=0 to FGroups.Count - 1 do
        Filters.Add('GROUP_ID',fcEqual,FGroups.Items[i].Value).Operator:=foOr;
    end;

{    with Provider.FilterGroups.Add do begin
      Filters.Add('ACCOUNT_ID',fcIsNull,Null);
    end;}

    inherited OpenRecords;
  end;
end;

procedure TBisCallcTakeBellFrame.ActionApplyGroupExecute(Sender: TObject);
begin
  ApplyGroup;
end;

procedure TBisCallcTakeBellFrame.ActionApplyGroupUpdate(Sender: TObject);
begin
  ActionApplyGroup.Enabled:=CanApplyGroup;
end;

procedure TBisCallcTakeBellFrame.ActionApplyPlanExecute(Sender: TObject);
begin
  ApplyPlan;
end;

procedure TBisCallcTakeBellFrame.ActionApplyPlanUpdate(Sender: TObject);
begin
  ActionApplyPlan.Enabled:=CanApplyPlan;
end;

function TBisCallcTakeBellFrame.CanApplyPlan: Boolean;
begin
  Result:=Provider.Active and not Provider.IsEmpty;
  if Result and Assigned(FOnCanApplyPlan) then
    Result:=FOnCanApplyPlan(Self);
end;

function TBisCallcTakeBellFrame.CanUpdateRecord: Boolean;
begin
  Result:=inherited CanUpdateRecord and
          not Locked and not Closed;
end;

procedure TBisCallcTakeBellFrame.ComboBoxStatusChange(Sender: TObject);
begin
  RefreshRecords;
end;

procedure TBisCallcTakeBellFrame.ComboBoxStatusEnter(Sender: TObject);
begin
  if Assigned(Sender) then begin
    if Sender=Grid then begin
      ActionUpdate.ShortCut:=FOldActionUpdateShortCut;
      ActionViewing.ShortCut:=FOldActionViewingShortCut;
    end else begin
      ActionUpdate.ShortCut:=0;
      ActionViewing.ShortCut:=0;
    end;
  end;
end;

procedure TBisCallcTakeBellFrame.ApplyPlan;
var
  P,P2: TBisProvider;
  AIface: TBisCallcHbookPlansFormIface;
  Flag: Boolean;
begin
  if CanApplyPlan then begin
    AIface:=TBisCallcHbookPlansFormIface.Create(nil);
    P:=TBisProvider.Create(nil);
    try
      if AIface.SelectInto(P) then begin
        if P.Active and not P.IsEmpty then begin
          P2:=TBisProvider.Create(nil);
          Provider.BeginUpdate;
          try
            Flag:=false;
            P2.ProviderName:='APPLY_PLAN';
            Provider.First;
            while not Provider.Eof do begin
              if not Flag then begin
                P2.Params.AddInvisible('TASK_ID').Value:=Provider.FieldByName('TASK_ID').Value;
                P2.Params.AddInvisible('PLAN_ID').Value:=P.FieldByName('PLAN_ID').Value;
              end else begin
                with P2.PackageParams.Add do begin
                  AddInvisible('TASK_ID').Value:=Provider.FieldByName('TASK_ID').Value;
                  AddInvisible('PLAN_ID').Value:=P.FieldByName('PLAN_ID').Value;
                end;
              end;
              Provider.Next;
            end;
            P2.Execute;
          finally
            Provider.EndUpdate;
            P2.Free;
          end;
          OpenRecords;
        end;
      end;
    finally
      P.Free;
      AIface.Free;
    end;
  end;
end;

function TBisCallcTakeBellFrame.CanApplyGroup: Boolean;
begin
  Result:=Provider.Active and not Provider.IsEmpty;
  if Result and Assigned(FOnCanApplyGroup) then
    Result:=FOnCanApplyGroup(Self);
end;

procedure TBisCallcTakeBellFrame.ApplyGroup;
var
  P,P2: TBisProvider;
  AIface: TBisCallcHbookGroupsFormIface;
  Flag: Boolean;
begin
  if CanApplyGroup then begin
    AIface:=TBisCallcHbookGroupsFormIface.Create(nil);
    P:=TBisProvider.Create(nil);
    try
      if AIface.SelectInto(P) then begin
        if P.Active and not P.IsEmpty then begin
          P2:=TBisProvider.Create(nil);
          Provider.BeginUpdate;
          try
            Flag:=false;
            P2.ProviderName:='APPLY_GROUP';
            Provider.First;
            while not Provider.Eof do begin
              if not Flag then begin
                P2.Params.AddInvisible('TASK_ID').Value:=Provider.FieldByName('TASK_ID').Value;
                P2.Params.AddInvisible('GROUP_ID').Value:=P.FieldByName('GROUP_ID').Value;
              end else begin
                with P2.PackageParams.Add do begin
                  AddInvisible('TASK_ID').Value:=Provider.FieldByName('TASK_ID').Value;
                  AddInvisible('GROUP_ID').Value:=P.FieldByName('GROUP_ID').Value;
                end;
              end;
              Provider.Next;
            end;
            P2.Execute;
          finally
            Provider.EndUpdate;
            P2.Free;
          end;
          OpenRecords;
        end;
      end;
    finally
      P.Free;
      AIface.Free;
    end;
  end;
end;

end.