unit BisDesignDataTaskEditFm;

interface
                                                                                              
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, CheckLst, ComCtrls, Menus, ActnPopup, ExtDlgs,
  ImgList,
  BisTasks, BisDataEditFm, BisParam, BisControls;

type

  TBisDesignDataTaskEditForm = class(TBisDataEditForm)
    GroupBoxRepeat: TGroupBox;
    CheckBoxRepeat: TCheckBox;
    LabelRepeatValue: TLabel;
    EditRepeatValue: TEdit;
    ComboBoxRepeatType: TComboBox;
    LabelRepeatCount: TLabel;
    EditRepeatCount: TEdit;
    GroupBoxExecute: TGroupBox;
    LabelInterface: TLabel;
    EditInterface: TEdit;
    ButtonInterface: TButton;
    LabelProcName: TLabel;
    EditProcName: TEdit;
    LabelCommandString: TLabel;
    EditCommandString: TEdit;
    GroupBoxSchedule: TGroupBox;
    LabelDayFrequency: TLabel;
    EditDayFrequency: TEdit;
    LabelDayFrequency2: TLabel;
    LabelWeekFrequency: TLabel;
    EditWeekFrequency: TEdit;
    LabelWeekFrequency2: TLabel;
    CheckBoxMonday: TCheckBox;
    CheckBoxTuesday: TCheckBox;
    CheckBoxWednesday: TCheckBox;
    CheckBoxThursday: TCheckBox;
    CheckBoxFriday: TCheckBox;
    CheckBoxSaturday: TCheckBox;
    CheckBoxSunday: TCheckBox;
    CheckBoxJanuary: TCheckBox;
    CheckBoxFebruary: TCheckBox;
    CheckBoxMarch: TCheckBox;
    CheckBoxApril: TCheckBox;
    CheckBoxMay: TCheckBox;
    CheckBoxJune: TCheckBox;
    CheckBoxJuly: TCheckBox;
    CheckBoxAugust: TCheckBox;
    CheckBoxSeptember: TCheckBox;
    CheckBoxOctober: TCheckBox;
    CheckBoxNovember: TCheckBox;
    CheckBoxDecember: TCheckBox;
    LabelMotnDay: TLabel;
    EditMotnDay: TEdit;
    LabelMotnDay2: TLabel;
    LabelDateBegin: TLabel;
    DateTimePickerBegin: TDateTimePicker;
    DateTimePickerBeginTime: TDateTimePicker;
    LabelDateEnd: TLabel;
    DateTimePickerEnd: TDateTimePicker;
    DateTimePickerEndTime: TDateTimePicker;
    GroupBoxResult: TGroupBox;
    LabelDateExecute: TLabel;
    DateTimePickerExecute: TDateTimePicker;
    DateTimePickerExecuteTime: TDateTimePicker;
    LabelResultString: TLabel;
    MemoResultString: TMemo;
    LabelPriority: TLabel;
    ComboBoxPriority: TComboBox;
    GroupBoxGeneral: TGroupBox;
    LabelDescription: TLabel;
    LabelName: TLabel;
    MemoDescription: TMemo;
    EditName: TEdit;
    LabelApplication: TLabel;
    EditApplication: TEdit;
    ButtonApplication: TButton;
    LabelAccount: TLabel;
    EditAccount: TEdit;
    ButtonAccount: TButton;
    CheckBoxEnabled: TCheckBox;
    RadioButtonOnce: TRadioButton;
    RadioButtonRun: TRadioButton;
    RadioButtonEveryDay: TRadioButton;
    RadioButtonEveryWeek: TRadioButton;
    RadioButtonEveryMonth: TRadioButton;
    LabelOffset: TLabel;
    EditOffset: TEdit;
    procedure RadioButtonOnceClick(Sender: TObject);
  private
    FRadioButtonChanging: Boolean;
    procedure SetTaskSchedule;
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeforeShow; override;
    procedure ChangeParam(Param: TBisParam); override;
    function CheckParams: Boolean; override;
  end;

  TBisDesignDataTaskEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataTaskInsertFormIface=class(TBisDesignDataTaskEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataTaskUpdateFormIface=class(TBisDesignDataTaskEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataTaskDeleteFormIface=class(TBisDesignDataTaskEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignDataTaskEditForm: TBisDesignDataTaskEditForm;

implementation

uses DateUtils, DB,
     BisDesignDataApplicationsFm, BisDesignDataAccountsFm, BisDesignDataRolesAndAccountsFm,
     BisDesignDataInterfacesFm,
     BisFilterGroups, BisProvider, BisUtils, BisCore;

{$R *.dfm}

{ TBisDesignDataTaskEditFormIface }

constructor TBisDesignDataTaskEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataTaskEditForm;
  with Params do begin
    AddKey('TASK_ID').Older('OLD_TASK_ID');
    AddInvisible('SCHEDULE').Value:=tscOnce;
    AddEdit('NAME','EditName','LabelName',true);
    AddEditDataSelect('APPLICATION_ID','EditApplication','LabelApplication','ButtonApplication',
                      TBisDesignDataApplicationsFormIface,'APPLICATION_NAME',true,false,'','NAME');
    AddEditDataSelect('ACCOUNT_ID','EditAccount','LabelAccount','ButtonAccount',
                      TBisDesignDataRolesAndAccountsFormIface,'USER_NAME',false,false);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddCheckBox('ENABLED','CheckBoxEnabled').ExcludeModes([emFilter]);
    AddComboBoxIndex('PRIORITY','ComboBoxPriority','LabelPriority',true).Value:=tpNormal;
    AddEdit('PROC_NAME','EditProcName','LabelProcName');
    AddEdit('COMMAND_STRING','EditCommandString','LabelCommandString');
    AddEditDataSelect('INTERFACE_ID','EditInterface','LabelInterface','ButtonInterface',
                      TBisDesignDataInterfacesFormIface,'INTERFACE_NAME',false,false,'','NAME');
    AddEditDateTime('DATE_BEGIN','DateTimePickerBegin','DateTimePickerBeginTime','LabelDateBegin',true);
    AddEditInteger('OFFSET','EditOffset','LabelOffset');
    AddEditInteger('DAY_FREQUENCY','EditDayFrequency','LabelDayFrequency');
    AddEditDateTime('DATE_END','DateTimePickerEnd','DateTimePickerEndTime','LabelDateEnd');
    AddEditInteger('WEEK_FREQUENCY','EditWeekFrequency','LabelWeekFrequency');
    AddCheckBox('MONDAY','CheckBoxMonday',1);
    AddCheckBox('TUESDAY','CheckBoxTuesday');
    AddCheckBox('WEDNESDAY','CheckBoxWednesday');
    AddCheckBox('THURSDAY','CheckBoxThursday');
    AddCheckBox('FRIDAY','CheckBoxFriday');
    AddCheckBox('SATURDAY','CheckBoxSaturday');
    AddCheckBox('SUNDAY','CheckBoxSunday');
    AddEditInteger('MONTH_DAY','EditMotnDay','LabelMotnDay');
    AddCheckBox('JANUARY','CheckBoxJanuary',1);
    AddCheckBox('FEBRUARY','CheckBoxFebruary',1);
    AddCheckBox('MARCH','CheckBoxMarch',1);
    AddCheckBox('APRIL','CheckBoxApril',1);
    AddCheckBox('MAY','CheckBoxMay',1);
    AddCheckBox('JUNE','CheckBoxJune',1);
    AddCheckBox('JULY','CheckBoxJuly',1);
    AddCheckBox('AUGUST','CheckBoxAugust',1);
    AddCheckBox('SEPTEMBER','CheckBoxSeptember',1);
    AddCheckBox('OCTOBER','CheckBoxOctober',1);
    AddCheckBox('NOVEMBER','CheckBoxNovember',1);
    AddCheckBox('DECEMBER','CheckBoxDecember',1);
    AddCheckBox('REPEAT_ENABLED','CheckBoxRepeat');
    AddEditInteger('REPEAT_VALUE','EditRepeatValue','LabelRepeatValue');
    AddComboBoxIndex('REPEAT_TYPE','ComboBoxRepeatType','LabelRepeatValue');
    AddEditInteger('REPEAT_COUNT','EditRepeatCount','LabelRepeatCount');
    AddEditDateTime('DATE_EXECUTE','DateTimePickerExecute','DateTimePickerExecuteTime','LabelDateExecute').ExcludeModes(AllParamEditModes);
    AddMemo('RESULT_STRING','MemoResultString','LabelResultString');//.ExcludeModes(AllParamEditModes);

  end;
end;

{ TBisDesignDataTaskInsertFormIface }

constructor TBisDesignDataTaskInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_TASK';
  Caption:='������� �������';
end;

{ TBisDesignDataTaskUpdateFormIface }

constructor TBisDesignDataTaskUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_TASK';
  Caption:='�������� �������';
end;

{ TBisDesignDataTaskDeleteFormIface }

constructor TBisDesignDataTaskDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_TASK';
  Caption:='������� �������';
end;

{ TBisDesignDataTaskEditForm }

constructor TBisDesignDataTaskEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRadioButtonChanging:=false;
  LabelRepeatValue.FocusControls.Add(ComboBoxRepeatType);
end;

procedure TBisDesignDataTaskEditForm.BeforeShow;
begin
  inherited BeforeShow;

  if Mode in [emInsert,emDuplicate] then begin
    with Provider.Params do begin
      Find('DATE_BEGIN').SetNewValue(Core.ServerDate);
    end;
  end;
  SetTaskSchedule;
  if (Mode in [emInsert,emDuplicate,emUpdate]) then
    ChangeParam(Provider.Params.ParamByName('ENABLED'));
  if (Mode in [emDelete,emFilter]) then begin
    EnableControl(GroupBoxSchedule,false);
    EnableControl(GroupBoxRepeat,false);
  end;

  UpdateButtonState;
end;

procedure TBisDesignDataTaskEditForm.ChangeParam(Param: TBisParam);
var
  TaskSchedule: TBisTaskSchedule;
  AEnabled: Boolean;
begin
  inherited ChangeParam(Param);
  if Assigned(Param) then begin

    if (Mode in [emInsert,emDuplicate,emUpdate]) and
       AnsiSameText(Param.ParamName,'ENABLED') then begin
      with Provider.Params do begin
        ParamByName('PRIORITY').Enabled:=Param.AsBoolean;
        ParamByName('PROC_NAME').Enabled:=Param.AsBoolean;
        ParamByName('COMMAND_STRING').Enabled:=Param.AsBoolean;
        ParamByName('INTERFACE_ID').Enabled:=Param.AsBoolean;
        if not Param.AsBoolean then begin
          if ParamByName('DATE_BEGIN').Empty then
            ParamByName('DATE_BEGIN').Value:=Core.ServerDate;
        end;

      end;
      EnableControl(GroupBoxSchedule,Param.AsBoolean);
      ChangeParam(Provider.Params.ParamByName('SCHEDULE'));
      EnableControl(GroupBoxRepeat,Param.AsBoolean);
      ChangeParam(Provider.Params.ParamByName('REPEAT_ENABLED'));
    end;

    if (Mode in [emInsert,emDuplicate,emUpdate]) and
       AnsiSameText(Param.ParamName,'SCHEDULE') then begin
      TaskSchedule:=TBisTaskSchedule(Param.AsInteger);
      with Provider.Params do begin
        ParamByName('DATE_BEGIN').Enabled:=false;
        ParamByName('OFFSET').Enabled:=false;
        ParamByName('DAY_FREQUENCY').Enabled:=false;
        ParamByName('DATE_END').Enabled:=false;
        ParamByName('WEEK_FREQUENCY').Enabled:=false;
        ParamByName('MONDAY').Enabled:=false;
        ParamByName('TUESDAY').Enabled:=false;
        ParamByName('WEDNESDAY').Enabled:=false;
        ParamByName('THURSDAY').Enabled:=false;
        ParamByName('FRIDAY').Enabled:=false;
        ParamByName('SATURDAY').Enabled:=false;
        ParamByName('SUNDAY').Enabled:=false;
        ParamByName('MONTH_DAY').Enabled:=false;
        ParamByName('JANUARY').Enabled:=false;
        ParamByName('FEBRUARY').Enabled:=false;
        ParamByName('MARCH').Enabled:=false;
        ParamByName('APRIL').Enabled:=false;
        ParamByName('MAY').Enabled:=false;
        ParamByName('JUNE').Enabled:=false;
        ParamByName('JULY').Enabled:=false;
        ParamByName('AUGUST').Enabled:=false;
        ParamByName('SEPTEMBER').Enabled:=false;
        ParamByName('OCTOBER').Enabled:=false;
        ParamByName('NOVEMBER').Enabled:=false;
        ParamByName('DECEMBER').Enabled:=false;
        if ParamByName('ENABLED').AsBoolean then begin
          case TaskSchedule of
            tscRun: begin
              if ParamByName('DATE_BEGIN').Empty then
                ParamByName('DATE_BEGIN').Value:=Core.ServerDate;
            end;
            tscOnce: begin
              ParamByName('DATE_BEGIN').Enabled:=true;
              ParamByName('OFFSET').Enabled:=true;
            end;
            tscEveryDay: begin
              ParamByName('DATE_BEGIN').Enabled:=true;
              ParamByName('OFFSET').Enabled:=true;
              ParamByName('DAY_FREQUENCY').Enabled:=true;
              ParamByName('DATE_END').Enabled:=true;
            end;
            tscEveryWeek: begin
              ParamByName('DATE_BEGIN').Enabled:=true;
              ParamByName('OFFSET').Enabled:=true;
              ParamByName('DATE_END').Enabled:=true;
              ParamByName('WEEK_FREQUENCY').Enabled:=true;
              ParamByName('MONDAY').Enabled:=true;
              ParamByName('TUESDAY').Enabled:=true;
              ParamByName('WEDNESDAY').Enabled:=true;
              ParamByName('THURSDAY').Enabled:=true;
              ParamByName('FRIDAY').Enabled:=true;
              ParamByName('SATURDAY').Enabled:=true;
              ParamByName('SUNDAY').Enabled:=true;
            end;
            tscEveryMonth: begin
              ParamByName('DATE_BEGIN').Enabled:=true;
              ParamByName('OFFSET').Enabled:=true;
              ParamByName('DATE_END').Enabled:=true;
              ParamByName('MONTH_DAY').Enabled:=true;
              ParamByName('JANUARY').Enabled:=true;
              ParamByName('FEBRUARY').Enabled:=true;
              ParamByName('MARCH').Enabled:=true;
              ParamByName('APRIL').Enabled:=true;
              ParamByName('MAY').Enabled:=true;
              ParamByName('JUNE').Enabled:=true;
              ParamByName('JULY').Enabled:=true;
              ParamByName('AUGUST').Enabled:=true;
              ParamByName('SEPTEMBER').Enabled:=true;
              ParamByName('OCTOBER').Enabled:=true;
              ParamByName('NOVEMBER').Enabled:=true;
              ParamByName('DECEMBER').Enabled:=true;
            end;
          end;
        end;
      end;
    end;

    if (Mode in [emInsert,emDuplicate,emUpdate]) and
       AnsiSameText(Param.ParamName,'REPEAT_ENABLED') then begin
      with Provider.Params do begin
        AEnabled:=ParamByName('ENABLED').AsBoolean;
        ParamByName('REPEAT_VALUE').Enabled:=Param.AsBoolean and AEnabled;
        ParamByName('REPEAT_TYPE').Enabled:=Param.AsBoolean and AEnabled;
        ParamByName('REPEAT_COUNT').Enabled:=Param.AsBoolean and AEnabled;
      end;
    end;

  end;
end;

function TBisDesignDataTaskEditForm.CheckParams: Boolean;
var
  Checked: Boolean;
  TaskSchedule: TBisTaskSchedule;
begin
  with Provider.Params do begin
    TaskSchedule:=TBisTaskSchedule(ParamByName('SCHEDULE').AsInteger);
    ParamByName('DAY_FREQUENCY').Required:=TaskSchedule=tscEveryDay;
    ParamByName('WEEK_FREQUENCY').Required:=TaskSchedule=tscEveryWeek;
    ParamByName('MONTH_DAY').Required:=TaskSchedule=tscEveryMonth;
    Checked:=ParamByName('REPEAT_ENABLED').AsBoolean;
    ParamByName('REPEAT_VALUE').Required:=Checked;
    ParamByName('REPEAT_TYPE').Required:=Checked;
    try
      Result:=inherited CheckParams;
    finally
      ParamByName('REPEAT_VALUE').Required:=false;
      ParamByName('REPEAT_TYPE').Required:=false;
      ParamByName('DAY_FREQUENCY').Required:=false;
      ParamByName('WEEK_FREQUENCY').Required:=false;
      ParamByName('MONTH_DAY').Required:=false;
    end;
  end;
end;

procedure TBisDesignDataTaskEditForm.RadioButtonOnceClick(Sender: TObject);
var
  RadioButton: TRadioButton;
  Param: TBisParam;
  TaskSchedule: TBisTaskSchedule;
begin
  if not FRadioButtonChanging and Assigned(Sender) and (Sender is TRadioButton) then begin
    RadioButton:=TRadioButton(Sender);
    Param:=Provider.Params.ParamByName('SCHEDULE');
    if RadioButton.Checked then begin
      TaskSchedule:=tscRun;
      if RadioButton=RadioButtonOnce then TaskSchedule:=tscOnce;
      if RadioButton=RadioButtonEveryDay then TaskSchedule:=tscEveryDay;
      if RadioButton=RadioButtonEveryWeek then TaskSchedule:=tscEveryWeek;
      if RadioButton=RadioButtonEveryMonth then TaskSchedule:=tscEveryMonth;
      if RadioButton=RadioButtonRun then TaskSchedule:=tscRun;
      Param.Value:=TaskSchedule;
    end;
  end;
end;

procedure TBisDesignDataTaskEditForm.SetTaskSchedule;
var
  TaskSchedule: TBisTaskSchedule;
begin
  FRadioButtonChanging:=true;
  try
    TaskSchedule:=TBisTaskSchedule(Provider.Params.ParamByName('SCHEDULE').AsInteger);
    case TaskSchedule of
      tscRun: RadioButtonRun.Checked:=true;
      tscOnce: RadioButtonOnce.Checked:=true;
      tscEveryDay: RadioButtonEveryDay.Checked:=true;
      tscEveryWeek: RadioButtonEveryWeek.Checked:=true;
      tscEveryMonth: RadioButtonEveryMonth.Checked:=true;
    end;
  finally
    FRadioButtonChanging:=false;
  end;
end;

end.