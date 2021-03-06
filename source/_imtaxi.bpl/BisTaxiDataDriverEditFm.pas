unit BisTaxiDataDriverEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, DB, ImgList, Buttons, Menus, ActnPopup,
  BisDataEditFm, BisDataFrm, BisParam,
  BisTaxiDataDriverShiftsFm, BisTaxiDataParkStatesFm, BisTaxiDataReceiptsFrm,
  BisTaxiDataChargesFrm, BisTaxiDataDriverInMessagesFm, BisTaxiDataDriverOutMessagesFm,
  BisTaxiDataCallEditFm, BisTaxiDataCallsFrm,
  BisTaxiDataOrdersFrm, BisTaxiDataDriverWeekScheduleFrm, 
  BisControls;

type
  TBisTaxiDataDriverEditForm = class(TBisDataEditForm)
    PageControl: TPageControl;
    TabSheetMain: TTabSheet;
    TabSheetAccount: TTabSheet;
    TabSheetShifts: TTabSheet;
    TabSheetParkStates: TTabSheet;
    TabSheetMessages: TTabSheet;
    TabSheetOrders: TTabSheet;
    TabSheetExtra: TTabSheet;
    LabelSurname: TLabel;
    EditSurname: TEdit;
    LabelName: TLabel;
    EditName: TEdit;
    LabelPatronymic: TLabel;
    EditPatronymic: TEdit;
    LabelPhone: TLabel;
    EditPhone: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelPhoneHome: TLabel;
    EditPhoneHome: TEdit;
    LabelPassport: TLabel;
    MemoPassport: TMemo;
    LabelAddressResidence: TLabel;
    EditAddressResidence: TEdit;
    LabelDateBirth: TLabel;
    DateTimePickerBirth: TDateTimePicker;
    LabelPlaceBirth: TLabel;
    EditPlaceBirth: TEdit;
    LabelCar: TLabel;
    EditCar: TEdit;
    ButtonCar: TButton;
    LabelMethod: TLabel;
    ComboBoxMethod: TComboBox;
    LabelCategories: TLabel;
    EditCategories: TEdit;
    LabelUserName: TLabel;
    EditUserName: TEdit;
    CheckBoxLocked: TCheckBox;
    LabelLicense: TLabel;
    EditLicense: TEdit;
    BitBtnPhone: TBitBtn;
    PopupPhone: TPopupActionBar;
    PanelReceiptCharges: TPanel;
    LabelCalc: TLabel;
    ComboBoxCalc: TComboBox;
    LabelMinBalance: TLabel;
    EditMinBalance: TEdit;
    LabelActualBalance: TLabel;
    EditActualBalance: TEdit;
    PageControlAccount: TPageControl;
    TabSheetAccountReceipts: TTabSheet;
    TabSheetAccountCharges: TTabSheet;
    PhoneMenuItemMessage: TMenuItem;
    PhoneMenuItemCall: TMenuItem;
    PageControlMessages: TPageControl;
    TabSheetInMessages: TTabSheet;
    TabSheetOutMessages: TTabSheet;
    TabSheetSchedules: TTabSheet;
    LabelDateCreate: TLabel;
    DateTimePickerCreate: TDateTimePicker;
    DateTimePickerCreateTime: TDateTimePicker;
    GroupBoxPriority: TGroupBox;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    LabelDatePriority: TLabel;
    DateTimePickerPriority: TDateTimePicker;
    PanelSchedule: TPanel;
    LabelMinHours: TLabel;
    EditMinHours: TEdit;
    LabelDateSchedule: TLabel;
    DateTimePickerSchedule: TDateTimePicker;
    ButtonUserName: TBitBtn;
    LabelFirm: TLabel;
    LabelAddressActual: TLabel;
    EditAddressActual: TEdit;
    ComboBoxFirm: TComboBox;
    TabSheetCalls: TTabSheet;
    PageControlCalls: TPageControl;
    TabSheetInCalls: TTabSheet;
    TabSheetOutCalls: TTabSheet;
    procedure PageControlChange(Sender: TObject);
    procedure BitBtnPhoneClick(Sender: TObject);
    procedure PopupPhonePopup(Sender: TObject);
    procedure PhoneMenuItemMessageClick(Sender: TObject);
    procedure PageControlAccountChange(Sender: TObject);
    procedure PageControlMessagesChange(Sender: TObject);
    procedure ButtonUserNameClick(Sender: TObject);
    procedure PhoneMenuItemCallClick(Sender: TObject);
    procedure PageControlCallsChange(Sender: TObject);
  private
    FWeekScheduleFrame: TBisTaxiDataDriverWeekScheduleFrame;
    FShiftsFrame: TBisTaxiDataDriverShiftsFrame;
    FParkStatesFrame: TBisTaxiDataParkStatesFrame;
    FReceiptsFrame: TBisTaxiDataReceiptsFrame;
    FChargesFrame: TBisTaxiDataChargesFrame;
    FInMessagesFrame: TBisTaxiDataDriverInMessagesFrame;
    FOutMessagesFrame: TBisTaxiDataDriverOutMessagesFrame;
    FInCallsFrame: TBisTaxiDataCallsFrame;
    FOutCallsFrame: TBisTaxiDataCallsFrame;
    FOrdersFrame: TBisTaxiDataOrdersFrame;

    procedure SetActualBalance;
    procedure SetFirmSmallName;
    function CanMessage: Boolean;
    procedure Message;
    function CanCall: Boolean;
    procedure Call;
    function FrameCan(Sender: TBisDataFrame): Boolean;
    procedure FrameCalcBalance(Sender: TBisDataFrame);
    function GetDriverUserName(VisibleCursor: Boolean): String;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure ChangeParam(Param: TBisParam); override;
    procedure BeforeShow; override;
    procedure ShowParam(Param: TBisParam); override;

  end;

  TBisTaxiDataDriverEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDriverViewFormIface=class(TBisTaxiDataDriverEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDriverFilterFormIface=class(TBisTaxiDataDriverEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDriverInsertFormIface=class(TBisTaxiDataDriverEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDriverUpdateFormIface=class(TBisTaxiDataDriverEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDriverDeleteFormIface=class(TBisTaxiDataDriverEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataDriverEditForm: TBisTaxiDataDriverEditForm;

implementation

uses
     BisUtils, BisTaxiConsts, BisIfaces, BisCore, BisFm, BisDataFm, BisLogger,
     BisValues, BisProvider, BisFilterGroups, BisOrders, BisParamEditDataSelect,
     BisTaxiDataCalcsFm, BisTaxiDataCarsFm, BisTaxiDataMethodsFm,
     BisTaxiDataDriverOutMessageEditFm, BisTaxiPhoneFm, BisTaxiPhoneFrm;

{$R *.dfm}

{ TBisTaxiDataDriverEditFormIface }

constructor TBisTaxiDataDriverEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataDriverEditForm;
  with Params do begin
    AddKey('DRIVER_ID').Older('OLD_DRIVER_ID');
    AddInvisible('CAR_BRAND');
    AddInvisible('CAR_STATE_NUM');
    AddInvisible('CAR_COLOR');
    AddInvisible('CAR_CALLSIGN');
    AddInvisible('INSURANCE');
    AddInvisible('HEALTH_CERT');
    AddInvisible('ADDICT_CERT');

    AddEdit('SURNAME','EditSurName','LabelSurName',true);
    AddEdit('NAME','EditName','LabelName',true);
    AddEdit('PATRONYMIC','EditPatronymic','LabelPatronymic');
    AddEdit('PHONE','EditPhone','LabelPhone',true);
    AddComboBoxDataSelect('METHOD_ID','ComboBoxMethod','LabelMethod','',
                          TBisTaxiDataMethodsFormIface,'METHOD_NAME',false,false,'','NAME');
    AddComboBoxDataSelect('FIRM_ID','ComboBoxFirm','LabelFirm',
                          'S_OFFICES','FIRM_SMALL_NAME',false,false,'','SMALL_NAME');
    AddEdit('ADDRESS_ACTUAL','EditAddressActual','LabelAddressActual');
                          
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddEditDataSelect('CAR_ID','EditCar','LabelCar','ButtonCar',
                      TBisTaxiDataCarsFormIface,'CAR_COLOR;CAR_BRAND;CAR_STATE_NUM',
                      true,false,'CAR_ID','COLOR;BRAND;STATE_NUM').DataAliasFormat:='%s %s %s';
    AddEdit('LICENSE','EditLicense','LabelLicense');
    AddEdit('USER_NAME','EditUserName','LabelUserName',true);
    AddCheckBox('LOCKED','CheckBoxLocked');
    AddEditDateTime('DATE_CREATE','DateTimePickerCreate','DateTimePickerCreateTime','LabelDateCreate',true).ExcludeModes([emFilter,emUpdate]);
    AddEditInteger('PRIORITY','EditPriority','LabelPriority');
    AddEditDate('DATE_PRIORITY','DateTimePickerPriority','LabelDatePriority');

    AddEdit('ADDRESS_RESIDENCE','EditAddressResidence','LabelAddressResidence');
    AddEditDate('DATE_BIRTH','DateTimePickerBirth','LabelDateBirth');
    AddEdit('PLACE_BIRTH','EditPlaceBirth','LabelPlaceBirth');
    AddMemo('PASSPORT','MemoPassport','LabelPassport');
    AddEdit('PHONE_HOME','EditPhoneHome','LabelPhoneHome');
    AddEdit('CATEGORIES','EditCategories','LabelCategories');

    AddComboBoxDataSelect('CALC_ID','ComboBoxCalc','LabelCalc','',
                          TBisTaxiDataCalcsFormIface,'CALC_NAME',false,false,'','NAME');
    AddEditFloat('MIN_BALANCE','EditMinBalance','LabelMinBalance');
    AddEditFloat('ACTUAL_BALANCE','EditActualBalance','LabelActualBalance').ExcludeModes(AllParamEditModes);

    AddEditInteger('MIN_HOURS','EditMinHours','LabelMinHours');
    AddEditDate('DATE_SCHEDULE','DateTimePickerSchedule','LabelDateSchedule');
  end;
end;

{ TBisTaxiDataDriverViewFormIface }

constructor TBisTaxiDataDriverViewFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='�������� ��������';
end;

{ TBisTaxiDataDriverFilterFormIface }

constructor TBisTaxiDataDriverFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='������ ���������';
end;

{ TBisTaxiDataDriverInsertFormIface }

constructor TBisTaxiDataDriverInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Permissions.Enabled:=true;
  ProviderName:='I_DRIVER';
  ParentProviderName:='S_DRIVERS';
  Caption:='������� ��������';
  SMessageSuccess:='�������� %USER_NAME ������� ������.';
end;

{ TBisTaxiDataDriverUpdateFormIface }

constructor TBisTaxiDataDriverUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_DRIVER';
  Caption:='�������� ��������';
end;

{ TBisTaxiDataDriverDeleteFormIface }

constructor TBisTaxiDataDriverDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_DRIVER';
  Caption:='������� ��������';
end;

{ TBisTaxiDataDriverEditForm }

constructor TBisTaxiDataDriverEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FWeekScheduleFrame:=TBisTaxiDataDriverWeekScheduleFrame.Create(nil);
  with FWeekScheduleFrame do begin
    Parent:=TabSheetSchedules;
    Align:=alClient;
    AsModal:=true;
  end;

  FShiftsFrame:=TBisTaxiDataDriverShiftsFrame.Create(nil);
  with FShiftsFrame do begin
    Parent:=TabSheetShifts;
    Align:=alClient;
    AsModal:=true;
    LabelCounter.Visible:=true;
    Provider.FieldNames.FieldByName('DRIVER_USER_NAME').Visible:=false;
    FilterMenuItemToday.Visible:=false;
    FilterMenuItemToday.Checked:=false;
    FilterMenuItemArchive.Visible:=false;
    FilterMenuItemArchive.Checked:=false;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
  end;

  FParkStatesFrame:=TBisTaxiDataParkStatesFrame.Create(nil);
  with FParkStatesFrame do begin
    Parent:=TabSheetParkStates;
    Align:=alClient;
    AsModal:=true;
    LabelCounter.Visible:=true;
    with Provider.FieldNames do begin
      FieldByName('PARK_NAME').Visible:=true;
      FieldByName('DRIVER_USER_NAME').Visible:=false;
    end;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
  end;

  FReceiptsFrame:=TBisTaxiDataReceiptsFrame.Create(nil);
  with FReceiptsFrame do begin
    Parent:=TabSheetAccountReceipts;
    Align:=alClient;
    AsModal:=true;
    ShowAnotherFirms:=true;
    LabelCounter.Visible:=true;
    Provider.FieldNames.FieldByName('NEW_USER_NAME').Visible:=false;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
    OnAfterInsertRecord:=FrameCalcBalance;
    OnAfterUpdateRecord:=FrameCalcBalance;
    OnAfterDeleteRecord:=FrameCalcBalance;
  end;

  FChargesFrame:=TBisTaxiDataChargesFrame.Create(nil);
  with FChargesFrame do begin
    Parent:=TabSheetAccountCharges;
    Align:=alClient;
    AsModal:=true;
    ShowAnotherFirms:=true;
    LabelCounter.Visible:=true;
    Provider.FieldNames.FieldByName('NEW_USER_NAME').Visible:=false;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
    OnAfterInsertRecord:=FrameCalcBalance;
    OnAfterUpdateRecord:=FrameCalcBalance;
    OnAfterDeleteRecord:=FrameCalcBalance;
  end;

  FInMessagesFrame:=TBisTaxiDataDriverInMessagesFrame.Create(nil);
  with FInMessagesFrame do begin
    Parent:=TabSheetInMessages;
    Align:=alClient;
    AsModal:=true;
    LabelCounter.Visible:=true;
    with Provider.FieldNames do begin
      FieldByName('NEW_SENDER_NAME').Visible:=false;
      FieldByName('CAR_COLOR').Visible:=false;
      FieldByName('CAR_BRAND').Visible:=false;
      FieldByName('CAR_STATE_NUM').Visible:=false;
    end;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
  end;

  FOutMessagesFrame:=TBisTaxiDataDriverOutMessagesFrame.Create(nil);
  with FOutMessagesFrame do begin
    Parent:=TabSheetOutMessages;
    Align:=alClient;
    AsModal:=true;
    LabelCounter.Visible:=true;
    with Provider.FieldNames do begin
      FieldByName('NEW_RECIPIENT_NAME').Visible:=false;
      FieldByName('CAR_COLOR').Visible:=false;
      FieldByName('CAR_BRAND').Visible:=false;
      FieldByName('CAR_STATE_NUM').Visible:=false;
    end;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
  end;

  FInCallsFrame:=TBisTaxiDataCallsFrame.Create(nil);
  with FInCallsFrame do begin
    Parent:=TabSheetInCalls;
    Align:=alClient;
    AsModal:=true;
    LabelCounter.Visible:=true;
    with Provider.FieldNames do begin
      FieldByName('NEW_CALLER_NAME').Visible:=false;
    end;
    FilterMenuItemHour.Checked:=false;
    FilterMenuItemToday.Checked:=true;
    ViewMode:=vmIncoming;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
  end;

  FOutCallsFrame:=TBisTaxiDataCallsFrame.Create(nil);
  with FOutCallsFrame do begin
    Parent:=TabSheetOutCalls;
    Align:=alClient;
    AsModal:=true;
    LabelCounter.Visible:=true;
    with Provider.FieldNames do begin
      FieldByName('NEW_ACCEPTOR_NAME').Visible:=false;
    end;
    FilterMenuItemHour.Checked:=false;
    FilterMenuItemToday.Checked:=true;
    ViewMode:=vmOutgoing;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
  end;
  
  FOrdersFrame:=TBisTaxiDataOrdersFrame.Create(nil);
  with FOrdersFrame do begin
    Parent:=TabSheetOrders;
    Align:=alClient;
    AsModal:=true;
    LabelCounter.Visible:=true;
    with Provider.FieldNames do begin
      FieldByName('NEW_DRIVER_NAME').Visible:=false;
      FieldByName('CAR_COLOR').Visible:=false;
      FieldByName('CAR_BRAND').Visible:=false;
      FieldByName('CAR_STATE_NUM').Visible:=false;
    end;
    OnCanInsertRecord:=FrameCan;
    OnCanDuplicateRecord:=FrameCan;
    OnCanUpdateRecord:=FrameCan;
    OnCanDeleteRecord:=FrameCan;
  end;
end;

destructor TBisTaxiDataDriverEditForm.Destroy;
begin
  FOrdersFrame.Free;
  FOutCallsFrame.Free;
  FInCallsFrame.Free;
  FOutMessagesFrame.Free;
  FInMessagesFrame.Free;
  FChargesFrame.Free;
  FReceiptsFrame.Free;
  FParkStatesFrame.Free;
  FShiftsFrame.Free;
  FWeekScheduleFrame.Free;
  inherited Destroy;
end;

procedure TBisTaxiDataDriverEditForm.FrameCalcBalance(Sender: TBisDataFrame);
begin
  if (Mode in [emUpdate,emDelete,emView]) then
    SetActualBalance;
end;

function TBisTaxiDataDriverEditForm.FrameCan(Sender: TBisDataFrame): Boolean;
begin
  Result:=Mode in [emUpdate];
end;

procedure TBisTaxiDataDriverEditForm.Init;
begin
  inherited Init;
  FWeekScheduleFrame.Init;
  FShiftsFrame.Init;
  FParkStatesFrame.Init;
  FReceiptsFrame.Init;
  FChargesFrame.Init;
  FInMessagesFrame.Init;
  FOutMessagesFrame.Init;
  FInCallsFrame.Init;
  FOutCallsFrame.Init;
  FOrdersFrame.Init;
end;

procedure TBisTaxiDataDriverEditForm.BeforeShow;
var
  Exists: Boolean;
  UserName: String;
begin
  inherited BeforeShow;

  PageControl.TabIndex:=0;
  PageControlAccount.TabIndex:=0;
  PageControlMessages.TabIndex:=0;

  Exists:=Mode in [emUpdate,emDelete,emView];
  PageControlAccount.Visible:=Exists;
  TabSheetSchedules.TabVisible:=Exists;
  TabSheetShifts.TabVisible:=Exists;
  TabSheetParkStates.TabVisible:=Exists;
  TabSheetMessages.TabVisible:=Exists;
  TabSheetOrders.TabVisible:=Exists;

  if Mode in [emInsert,emDuplicate] then begin
    UserName:=GetDriverUserName(false);
    with Provider.Params do begin
      Find('USER_NAME').SetNewValue(UserName);
      Find('DATE_CREATE').SetNewValue(Core.ServerDate);
    end;
    SetFirmSmallName;
  end;

  if not VarIsNull(Core.FirmId) then
    Provider.ParamByName('FIRM_ID').Enabled:=(Mode in [emFilter]);

  if Mode in [emDelete] then begin
    EnableControl(TabSheetMain,false);
    EnableControl(PanelReceiptCharges,false);
    EnableControl(TabSheetAccountReceipts,false);
    EnableControl(TabSheetAccountCharges,false);
    EnableControl(TabSheetSchedules,false);
    EnableControl(TabSheetShifts,false);
    EnableControl(TabSheetParkStates,false);
    EnableControl(TabSheetInMessages,false);
    EnableControl(TabSheetOutMessages,false);
    EnableControl(TabSheetInCalls,false);
    EnableControl(TabSheetOutCalls,false);
    EnableControl(TabSheetOrders,false);
  end else begin
    FWeekScheduleFrame.ShowType:=ShowType;
    FShiftsFrame.ShowType:=ShowType;
    FParkStatesFrame.ShowType:=ShowType;
    FReceiptsFrame.ShowType:=ShowType;
    FChargesFrame.ShowType:=ShowType;
    FInMessagesFrame.ShowType:=ShowType;
    FOutMessagesFrame.ShowType:=ShowType;
    FInCallsFrame.ShowType:=ShowType;
    FOutCallsFrame.ShowType:=ShowType;
    FOrdersFrame.ShowType:=ShowType;
  end;

  UpdateButtonState;
end;

procedure TBisTaxiDataDriverEditForm.SetActualBalance;
var
  ParamBalance: TBisParam;
  ParamDriverId: TBisParam;
  P: TBisProvider;
begin
  ParamBalance:=Provider.Params.ParamByName('ACTUAL_BALANCE');
  ParamDriverId:=Provider.Params.ParamByName('DRIVER_ID');
  if not ParamDriverId.Empty then begin
    P:=TBisProvider.Create(nil);
    try
      P.StopException:=true;
      P.ProviderName:='GET_ACCOUNT_BALANCE';
      P.Params.AddInvisible('ACCOUNT_ID').Value:=ParamDriverId.Value;
      P.Params.AddInvisible('BALANCE',ptOutput);
      P.Execute;
      if P.Success then
        ParamBalance.SetNewValue(P.Params.ParamByName('BALANCE').Value)
      else
        ParamBalance.SetNewValue(Null);
    finally
      P.Free;
    end;
  end;
end;

procedure TBisTaxiDataDriverEditForm.SetFirmSmallName;
var
//  P: TBisProvider;
  ParamFirmId: TBisParam;
  ParamFirmSmallName: TBisParam;
begin
  if not VarIsNull(Core.FirmId) then begin
    ParamFirmId:=Provider.ParamByName('FIRM_ID');
    ParamFirmSmallName:=Provider.ParamByName('FIRM_SMALL_NAME');
    if Assigned(ParamFirmId) and Assigned(ParamFirmSmallName) then begin
      ParamFirmId.SetNewValue(Core.FirmId);
      ParamFirmSmallName.SetNewValue(Core.FirmSmallName);

{      P:=TBisProvider.Create(nil);
      try
        P.StopException:=true;
        P.ProviderName:='S_FIRMS';
        P.FieldNames.AddInvisible('SMALL_NAME');
        P.FilterGroups.Add.Filters.Add('FIRM_ID',fcEqual,Core.FirmId).CheckCase:=true;
        P.Open;
        if P.Active and not P.Empty then begin
          ParamFirmId.SetNewValue(Core.FirmId);
          ParamFirmSmallName.SetNewValue(P.FieldByName('SMALL_NAME').Value);
        end;
      finally
        P.Free;
      end;}
    end;
  end;
end;

procedure TBisTaxiDataDriverEditForm.ShowParam(Param: TBisParam);
begin
  if AnsiSameText(Param.ParamName,'ADDRESS_RESIDENCE') or
     AnsiSameText(Param.ParamName,'ADDRESS_ACTUAL') or
     AnsiSameText(Param.ParamName,'DATE_BIRTH') or
     AnsiSameText(Param.ParamName,'PLACE_BIRTH') or
     AnsiSameText(Param.ParamName,'PASSPORT') or
     AnsiSameText(Param.ParamName,'PHONE_HOME') or
     AnsiSameText(Param.ParamName,'CATEGORIES') then begin
    PageControl.ActivePageIndex:=1;
  end else
  if AnsiSameText(Param.ParamName,'CALC_ID') or
     AnsiSameText(Param.ParamName,'CALC_NAME') or
     AnsiSameText(Param.ParamName,'MIN_BALANCE') or
     AnsiSameText(Param.ParamName,'ACTUAL_BALANCE') then begin
    PageControl.ActivePageIndex:=2;
  end else
  if AnsiSameText(Param.ParamName,'MIN_HOURS') then begin
    PageControl.ActivePageIndex:=3;
  end else
    PageControl.ActivePageIndex:=0;

  inherited ShowParam(Param);

end;

procedure TBisTaxiDataDriverEditForm.BitBtnPhoneClick(Sender: TObject);
var
  Pt: TPoint;
begin
  Pt:=TabSheetMain.ClientToScreen(Point(BitBtnPhone.Left,BitBtnPhone.Top+BitBtnPhone.Height));
  PopupPhone.Popup(Pt.X,Pt.Y);
end;

procedure TBisTaxiDataDriverEditForm.ChangeParam(Param: TBisParam);
var
  CarParam: TBisParamEditDataSelect;
  V: TBisValue;
begin
  inherited ChangeParam(Param);

  if AnsiSameText(Param.ParamName,'CAR_COLOR;CAR_BRAND;CAR_STATE_NUM') then begin
    CarParam:=TBisParamEditDataSelect(Provider.Params.ParamByName('CAR_ID'));
    if CarParam.Empty then begin
      Provider.Params.ParamByName('CAR_CALLSIGN').SetNewValue(Null);
    end else begin
      V:=CarParam.Values.Find('CALLSIGN');
      if Assigned(V) then
        Provider.Params.ParamByName('CAR_CALLSIGN').SetNewValue(V.Value);
    end;
  end;

end;

procedure TBisTaxiDataDriverEditForm.PhoneMenuItemCallClick(Sender: TObject);
begin
  Call;
end;

procedure TBisTaxiDataDriverEditForm.PhoneMenuItemMessageClick(Sender: TObject);
begin
  Message;
end;

function TBisTaxiDataDriverEditForm.CanCall: Boolean;
var
  AIface: TBisTaxiPhoneFormIface;
begin
  Result:=Trim(EditPhone.Text)<>'';
  if Result then begin
    AIface:=TBisTaxiPhoneFormIface.Create(nil);
    try
      AIface.Init;
      Result:=AIface.CanShow;
    finally
      AIface.Free;
    end;
  end;
end;

procedure TBisTaxiDataDriverEditForm.Call;
var
  AIface: TBisTaxiPhoneFormIface;
begin
  if CanCall then begin
    AIface:=TBisTaxiPhoneFormIface(Core.FindIface(TBisTaxiPhoneFormIface));
    if Assigned(AIface) then begin
      with Provider do begin
        AIface.Dial(ParamByName('PHONE').AsString,Null);
      end;
    end;
  end;
end;

function TBisTaxiDataDriverEditForm.CanMessage: Boolean;
var
  AClass: TBisIfaceClass;
  AIface: TBisDataEditFormIface;
begin
  Result:=Trim(EditPhone.Text)<>'';
  if Result then begin
    AClass:=TBisTaxiDataDriverOutMessageInsertFormIface;
    Result:=Assigned(AClass) and IsClassParent(AClass,TBisDataEditFormIface);
    if Result then begin
      AIface:=TBisDataEditFormIfaceClass(AClass).Create(nil);
      try
        AIface.Init;
        Result:=AIface.CanShow;
      finally
        AIface.Free;
      end;
    end;
  end;
end;

procedure TBisTaxiDataDriverEditForm.Message;
var
  AClass: TBisIfaceClass;
  AIface: TBisDataEditFormIface;
  P1: TBisParam;
begin
  if CanMessage then begin
    AClass:=TBisTaxiDataDriverOutMessageInsertFormIface;
    AIface:=TBisDataEditFormIfaceClass(AClass).Create(nil);
    try
      with AIface.Params do begin
        if Mode in [emUpdate,emView] then begin
          ParamByName('RECIPIENT_ID').Value:=Provider.Params.ParamByName('DRIVER_ID').Value;
          ParamByName('RECIPIENT_USER_NAME').Value:=Provider.Params.ParamByName('USER_NAME').Value;
          ParamByName('RECIPIENT_SURNAME').Value:=Provider.Params.ParamByName('SURNAME').Value;
          ParamByName('RECIPIENT_NAME').Value:=Provider.Params.ParamByName('NAME').Value;
          ParamByName('RECIPIENT_PATRONYMIC').Value:=Provider.Params.ParamByName('PATRONYMIC').Value;
          P1:=ParamByName('RECIPIENT_USER_NAME;RECIPIENT_SURNAME;RECIPIENT_NAME;RECIPIENT_PATRONYMIC');
          P1.Value:=AIface.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
        end;
        ParamByName('CONTACT').Value:=Provider.Params.ParamByName('PHONE').Value;
      end;
      AIface.Init;
      AIface.ShowType:=ShowType;
      AIface.ShowModal;
    finally
      AIface.Free;
    end;
  end;
end;

procedure TBisTaxiDataDriverEditForm.PopupPhonePopup(Sender: TObject);
begin
  PhoneMenuItemMessage.Enabled:=CanMessage;
  PhoneMenuItemCall.Enabled:=CanCall;
end;

procedure TBisTaxiDataDriverEditForm.PageControlAccountChange(Sender: TObject);
var
  Param: TBisParam;
begin

  if PageControlAccount.ActivePage=TabSheetAccountReceipts then begin
    Param:=Provider.Params.ParamByName('DRIVER_ID');
    if not Param.Empty then begin
      with FReceiptsFrame do begin
        ResizeToolbars;
        AccountId:=Param.Value;
        UserName:=Self.Provider.Params.ParamByName('USER_NAME').Value;
        Surname:=Self.Provider.Params.ParamByName('SURNAME').Value;
        Name:=Self.Provider.Params.ParamByName('NAME').Value;
        Patronymic:=Self.Provider.Params.ParamByName('PATRONYMIC').Value;
        Provider.FilterGroups.Clear;
        Provider.FilterGroups.Add.Filters.Add('ACCOUNT_ID',fcEqual,Param.Value).CheckCase:=true;
        OpenRecords;
      end;
    end;
  end;

  if PageControlAccount.ActivePage=TabSheetAccountCharges then begin
    Param:=Provider.Params.ParamByName('DRIVER_ID');
    if not Param.Empty then begin
      with FChargesFrame do begin
        ResizeToolbars;
        AccountId:=Param.Value;
        UserName:=Self.Provider.Params.ParamByName('USER_NAME').Value;
        Surname:=Self.Provider.Params.ParamByName('SURNAME').Value;
        Name:=Self.Provider.Params.ParamByName('NAME').Value;
        Patronymic:=Self.Provider.Params.ParamByName('PATRONYMIC').Value;
        Provider.FilterGroups.Clear;
        Provider.FilterGroups.Add.Filters.Add('ACCOUNT_ID',fcEqual,Param.Value).CheckCase:=true;
        OpenRecords;
      end;
    end;
  end;

end;

procedure TBisTaxiDataDriverEditForm.PageControlMessagesChange(Sender: TObject);
var
  Param: TBisParam;
begin

  if PageControlMessages.ActivePage=TabSheetInMessages then begin
    Param:=Provider.Params.ParamByName('DRIVER_ID');
    if not Param.Empty then begin
      with FInMessagesFrame do begin
        ResizeToolbars;
        SenderId:=Param.Value;
        SenderUserName:=Self.Provider.Params.ParamByName('USER_NAME').Value;
        SenderSurname:=Self.Provider.Params.ParamByName('SURNAME').Value;
        SenderName:=Self.Provider.Params.ParamByName('NAME').Value;
        SenderPatronymic:=Self.Provider.Params.ParamByName('PATRONYMIC').Value;
        Contact:=Self.Provider.Params.ParamByName('PHONE').Value;
        Provider.FilterGroups.Clear;
        Provider.FilterGroups.Add.Filters.Add('SENDER_ID',fcEqual,Param.Value).CheckCase:=true;
        OpenRecords;
      end;
    end;
  end;

  if PageControlMessages.ActivePage=TabSheetOutMessages then begin
    Param:=Provider.Params.ParamByName('DRIVER_ID');
    if not Param.Empty then begin
      with FOutMessagesFrame do begin
        ResizeToolbars;
        RecipientId:=Param.Value;
        RecipientUserName:=Self.Provider.Params.ParamByName('USER_NAME').Value;
        RecipientSurname:=Self.Provider.Params.ParamByName('SURNAME').Value;
        RecipientName:=Self.Provider.Params.ParamByName('NAME').Value;
        RecipientPatronymic:=Self.Provider.Params.ParamByName('PATRONYMIC').Value;
        Contact:=Self.Provider.Params.ParamByName('PHONE').Value;
        Provider.FilterGroups.Clear;
        Provider.FilterGroups.Add.Filters.Add('RECIPIENT_ID',fcEqual,Param.Value).CheckCase:=true;
        OpenRecords;
      end;
    end;
  end;

end;

procedure TBisTaxiDataDriverEditForm.PageControlCallsChange(Sender: TObject);
var
  Param: TBisParam;
begin

  if PageControlCalls.ActivePage=TabSheetInCalls then begin
    Param:=Provider.Params.ParamByName('DRIVER_ID');
    if not Param.Empty then begin
      with FInCallsFrame do begin
        ResizeToolbars;
        CallerId:=Param.Value;
        CallerUserName:=Self.Provider.Params.ParamByName('USER_NAME').Value;
        CallerSurname:=Self.Provider.Params.ParamByName('SURNAME').Value;
        CallerName:=Self.Provider.Params.ParamByName('NAME').Value;
        CallerPatronymic:=Self.Provider.Params.ParamByName('PATRONYMIC').Value;
        CallerPhone:=Self.Provider.Params.ParamByName('PHONE').Value;
        Provider.FilterGroups.Clear;
        Provider.FilterGroups.Add.Filters.Add('CALLER_ID',fcEqual,Param.Value).CheckCase:=true;
        OpenRecords;
      end;
    end;
  end;

  if PageControlCalls.ActivePage=TabSheetOutCalls then begin
    Param:=Provider.Params.ParamByName('DRIVER_ID');
    if not Param.Empty then begin
      with FOutCallsFrame do begin
        ResizeToolbars;
        AcceptorId:=Param.Value;
        AcceptorUserName:=Self.Provider.Params.ParamByName('USER_NAME').Value;
        AcceptorSurname:=Self.Provider.Params.ParamByName('SURNAME').Value;
        AcceptorName:=Self.Provider.Params.ParamByName('NAME').Value;
        AcceptorPatronymic:=Self.Provider.Params.ParamByName('PATRONYMIC').Value;
        AcceptorPhone:=Self.Provider.Params.ParamByName('PHONE').Value;
        Provider.FilterGroups.Clear;
        Provider.FilterGroups.Add.Filters.Add('ACCEPTOR_ID',fcEqual,Param.Value).CheckCase:=true;
        OpenRecords;
      end;
    end;
  end;

end;

procedure TBisTaxiDataDriverEditForm.PageControlChange(Sender: TObject);
var
  Param: TBisParam;
begin

  if PageControl.ActivePage=TabSheetAccount then begin
    if (Mode in [emUpdate,emDelete,emView]) then
      SetActualBalance;
    PageControlAccountChange(nil);
  end;

  if PageControl.ActivePage=TabSheetSchedules then begin
    Param:=Provider.Params.ParamByName('DRIVER_ID');
    if not Param.Empty then begin
      with FWeekScheduleFrame do begin
        ResizeToolbars;
        DriverId:=Param.Value;
        CanChange:=Mode in [emUpdate];
        OpenRecords;
      end;
    end;
  end;

  if PageControl.ActivePage=TabSheetShifts then begin
    Param:=Provider.Params.ParamByName('DRIVER_ID');
    if not Param.Empty then begin
      with FShiftsFrame do begin
        ResizeToolbars;
        DriverId:=Param.Value;
        DriverUserName:=Self.Provider.Params.ParamByName('USER_NAME').Value;
        DriverSurname:=Self.Provider.Params.ParamByName('SURNAME').Value;
        DriverName:=Self.Provider.Params.ParamByName('NAME').Value;
        DriverPatronymic:=Self.Provider.Params.ParamByName('PATRONYMIC').Value;
        Provider.FilterGroups.Clear;
        Provider.FilterGroups.Add.Filters.Add('DRIVER_ID',fcEqual,Param.Value).CheckCase:=true;
        OpenRecords;
      end;
    end;
  end;

  if PageControl.ActivePage=TabSheetParkStates then begin
    Param:=Provider.Params.ParamByName('DRIVER_ID');
    if not Param.Empty then begin
      with FParkStatesFrame do begin
        ResizeToolbars;
        DriverId:=Param.Value;
        DriverUserName:=Self.Provider.Params.ParamByName('USER_NAME').Value;
        DriverSurname:=Self.Provider.Params.ParamByName('SURNAME').Value;
        DriverName:=Self.Provider.Params.ParamByName('NAME').Value;
        DriverPatronymic:=Self.Provider.Params.ParamByName('PATRONYMIC').Value;
        Provider.FilterGroups.Clear;
        Provider.FilterGroups.Add.Filters.Add('DRIVER_ID',fcEqual,Param.Value).CheckCase:=true;
        OpenRecords;
      end;
    end;
  end;

  if PageControl.ActivePage=TabSheetMessages then begin
    PageControlMessagesChange(nil);
  end;

  if PageControl.ActivePage=TabSheetCalls then begin
    PageControlCallsChange(nil);
  end;
  
  if PageControl.ActivePage=TabSheetOrders then begin
    Param:=Provider.Params.ParamByName('DRIVER_ID');
    if not Param.Empty then begin
      with FOrdersFrame do begin
        ResizeToolbars;
        with Provider do begin
          FilterGroups.Clear;
          with FilterGroups.Add do begin
           { Filters.Add('PARENT_ID',fcIsNull,Null);
            Filters.Add('DATE_HISTORY',fcIsNull,Null); }
            Filters.Add('WHO_HISTORY_ID',fcIsNull,Null);
            Filters.Add('DRIVER_ID',fcEqual,Param.Value).CheckCase:=true;
          end;
        end;
        OpenRecords;
      end;
    end;
  end;

end;

function TBisTaxiDataDriverEditForm.GetDriverUserName(VisibleCursor: Boolean): String;
var
  P: TBisProvider;
begin
  Result:='';
  P:=TBisProvider.Create(nil);
  try
    P.WithWaitCursor:=VisibleCursor;
    P.StopException:=false;
    P.ProviderName:='GET_DRIVER_USER_NAME';
    P.Params.AddInvisible('USER_NAME',ptInputOutput);
    try
      P.Execute;
      if P.Success then
        Result:=P.Params.Find('USER_NAME').AsString;
    except
      On E: Exception do
        LoggerWrite(E.Message,ltError);
    end;
  finally
    P.Free;
  end;
end;

procedure TBisTaxiDataDriverEditForm.ButtonUserNameClick(Sender: TObject);
begin
  Provider.Params.ParamByName('USER_NAME').Value:=GetDriverUserName(true);
end;


end.
