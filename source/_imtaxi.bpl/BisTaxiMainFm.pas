unit BisTaxiMainFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, StdCtrls, ExtCtrls, XPMan, ComCtrls, Contnrs,
  BisObject, ActnList, XPStyleActnCtrls, ShellAPI, AppEvnts, Menus, ActnPopup, Buttons,
  ActnMan, ToolWin, ActnCtrls, ActnMenus, CustomizeDlg, jpeg, ActnColorMaps,
  OleCtrls, SHDocVw,

  BisFm, BisCore, BisConnections, BisDataFm, BisProvider, BisIfaces, BisNotifyEvents,
  BisMdiMainFm;

type
  TBisTaxiMainForm = class(TBisMdiMainForm)
    ActionManager: TActionManager;
    ActionFileExit: TAction;
    ActionWindowsCascade: TAction;
    ActionWindowsVertical: TAction;
    ActionWindowsHorizontal: TAction;
    ActionWindowsCloseAll: TAction;
    PanelControlBar: TPanel;
    ControlBar: TControlBar;
    ToolBar: TToolBar;
    ActionListToolbar: TActionList;
    ImageListToolbar: TImageList;
    ToolButtonBeginShift: TToolButton;
    ToolButtonEndShift: TToolButton;
    ActionBeginShift: TAction;
    ActionEndShift: TAction;
    ActionOrderInsert: TAction;
    ToolButtonSeparator1: TToolButton;
    ActionOutMessageInsert: TAction;
    ToolButtonOutMessageInsert: TToolButton;
    ActionReceiptInsert: TAction;
    ActionChargeInsert: TAction;
    ActionBlackInsert: TAction;
    ActionFirmInsert: TAction;
    ActionCarInsert: TAction;
    ActionDriverInsert: TAction;
    ActionDispatcherInsert: TAction;
    ActionOutMessages: TAction;
    ActionInMessages: TAction;
    ActionOrders: TAction;
    ToolButtonReceiptInsert: TToolButton;
    ToolButtonSeparator2: TToolButton;
    ToolButtonChargeInsert: TToolButton;
    ToolButtonSeparator3: TToolButton;
    ToolButtonBlackInsert: TToolButton;
    ToolButtonFirmInsert: TToolButton;
    ToolButtonCarInsert: TToolButton;
    ToolButtonDriverInsert: TToolButton;
    ToolButtonDispatcherInsert: TToolButton;
    ToolButtonSeparator4: TToolButton;
    ToolButtonOutMessages: TToolButton;
    ToolButtonInMessages: TToolButton;
    ToolButtonOrders: TToolButton;
    ToolButtonSeparator5: TToolButton;
    TimerShift: TTimer;
    LabelTime: TLabel;
    TimerAlarm: TTimer;
    ToolButtonClientInsert: TToolButton;
    ActionClientInsert: TAction;
    procedure ActionBeginShiftExecute(Sender: TObject);
    procedure ActionEndShiftExecute(Sender: TObject);
    procedure ActionBeginShiftUpdate(Sender: TObject);
    procedure ActionEndShiftUpdate(Sender: TObject);
    procedure ActionOrderInsertExecute(Sender: TObject);
    procedure ActionOrderInsertUpdate(Sender: TObject);
    procedure ActionOutMessageInsertExecute(Sender: TObject);
    procedure ActionOutMessageInsertUpdate(Sender: TObject);
    procedure ActionReceiptInsertExecute(Sender: TObject);
    procedure ActionChargeInsertExecute(Sender: TObject);
    procedure ActionBlackInsertExecute(Sender: TObject);
    procedure ActionFirmInsertExecute(Sender: TObject);
    procedure ActionCarInsertExecute(Sender: TObject);
    procedure ActionDriverInsertExecute(Sender: TObject);
    procedure ActionDispatcherInsertExecute(Sender: TObject);
    procedure ActionOutMessagesExecute(Sender: TObject);
    procedure ActionInMessagesExecute(Sender: TObject);
    procedure ActionOrdersExecute(Sender: TObject);
    procedure ActionReceiptInsertUpdate(Sender: TObject);
    procedure ActionChargeInsertUpdate(Sender: TObject);
    procedure ActionBlackInsertUpdate(Sender: TObject);
    procedure ActionFirmInsertUpdate(Sender: TObject);
    procedure ActionCarInsertUpdate(Sender: TObject);
    procedure ActionDriverInsertUpdate(Sender: TObject);
    procedure ActionDispatcherInsertUpdate(Sender: TObject);
    procedure ActionOutMessagesUpdate(Sender: TObject);
    procedure ActionInMessagesUpdate(Sender: TObject);
    procedure ActionOrdersUpdate(Sender: TObject);
    procedure TimerShiftTimer(Sender: TObject);
    procedure TimerAlarmTimer(Sender: TObject);
    procedure ActionClientInsertExecute(Sender: TObject);
    procedure ActionClientInsertUpdate(Sender: TObject);
  private
    FFileItem: TActionClientItem;
    FWindowsItem: TActionClientItem;
    FDays: Integer;
    FTime: TDateTime;
    FFirstLabelTimeCaption: String;
    FRoles: TStringList;
    FAlarmTick: Integer;
    FAlarms: TStringList;
    procedure LoadRoles;
    procedure ZeroWorkingTime;
    procedure RefreshWorkingTime;
    procedure RefreshAlarms(AVisible: Boolean);
  protected
    procedure SetLogoPosition(Visible: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure RefreshMenus; override;
  end;

  TBisTaxiMainFormIface=class(TBisMDIMainFormIface)
  private
    FAfterLoginEvent: TBisNotifyEvent;
    FBeforeLogoutEvent: TBisNotifyEvent;

    procedure AfterLogin(Sender: TObject);
    procedure BeforeLogout(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

var
  BisTaxiMainForm: TBisTaxiMainForm;

var
  OrderInsertIface: TBisFormIface=nil;
  OutMessageInsertIface: TBisFormIface=nil;
  ReceiptInsertIface: TBisFormIface=nil;
  ChargeInsertIface: TBisFormIface=nil;
  BlackInsertIface: TBisFormIface=nil;
  FirmInsertIface: TBisFormIface=nil;
  CarInsertIface: TBisFormIface=nil;
  DriverInsertIface: TBisFormIface=nil;
  DispatcherInsertIface: TBisFormIface=nil;
  ClientInsertIface: TBisFormIface=nil;
  DriverOutMessagesIface: TBisFormIface=nil;
  DriverInMessagesIface: TBisFormIface=nil;
  OrdersIface: TBisFormIface=nil;

implementation

{$R *.dfm}

uses BisIfaceModules, BisConsts, BisUtils, BisFilterGroups, BisFieldNames, BisOrders,
     BisTaxiConsts, BisDialogs, BisPicture;

var
  FShiftId: String;
  FShiftBeginDate: TDateTime;

function BeginShift: Boolean;
var
  P: TBisProvider;
begin
  Result:=false;
  P:=TBisProvider.Create(nil);
  try
    P.ProviderName:='I_SHIFT';
    FShiftBeginDate:=Core.ServerDate;
    with P.Params do begin
      AddKey('SHIFT_ID');
      AddInvisible('ACCOUNT_ID').Value:=Core.AccountId;
      AddInvisible('DATE_BEGIN').Value:=FShiftBeginDate;
    end;
    P.Execute;
    if P.Success then begin
      FShiftId:=VarToStrDef(P.Params.ParamByName('SHIFT_ID').Value,'');
      Result:=true;
    end;
  finally
    P.Free;
  end;
end;

function EndShift: Boolean;
var
  P: TBisProvider;
begin
  Result:=false;
  if Trim(FShiftId)<>'' then begin
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:='U_SHIFT';
      with P.Params do begin
        with AddKey('SHIFT_ID') do begin
          Value:=FShiftId;
          Older('OLD_SHIFT_ID');
        end;
        AddInvisible('ACCOUNT_ID').Value:=Core.AccountId;
        AddInvisible('DATE_BEGIN').Value:=FShiftBeginDate;
        AddInvisible('DATE_END').Value:=Core.ServerDate;
      end;
      P.Execute;
      Result:=P.Success;
    finally
      FShiftId:='';
      P.Free;
    end;
  end;
end;

{ TBisTaxiMainFormIface }

constructor TBisTaxiMainFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiMainForm;
  FAfterLoginEvent:=Core.AfterLoginEvents.Add(AfterLogin);
  FBeforeLogoutEvent:=Core.BeforeLogoutEvents.Add(BeforeLogout);

end;

destructor TBisTaxiMainFormIface.Destroy;
begin
  Core.BeforeLogoutEvents.Remove(FBeforeLogoutEvent);
  Core.AfterLoginEvents.Remove(FAfterLoginEvent);
  inherited Destroy;
end;

procedure TBisTaxiMainFormIface.AfterLogin(Sender: TObject);
begin
  BeginShift;
end;

procedure TBisTaxiMainFormIface.BeforeLogout(Sender: TObject);
begin
  EndShift;
end;

{ TBisTaxiMainForm }

constructor TBisTaxiMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoMenu:=true;
  SizesStored:=true;
  CloseToTray:=false;

  FRoles:=TStringList.Create;

  FAlarms:=TStringList.Create;

  FFirstLabelTimeCaption:=LabelTime.Caption;

  if Assigned(OrderInsertIface) then OrderInsertIface.ShowType:=stMdiChild;
  if Assigned(OutMessageInsertIface) then OutMessageInsertIface.ShowType:=stMdiChild;
  if Assigned(ReceiptInsertIface) then ReceiptInsertIface.ShowType:=stMdiChild;
  if Assigned(ChargeInsertIface) then ChargeInsertIface.ShowType:=stMdiChild;
  if Assigned(BlackInsertIface) then BlackInsertIface.ShowType:=stMdiChild;

  FirmInsertIface:=TBisFormIface(Core.FindIface(SObjectDesignDataFirmInsertFormIface));
  if Assigned(FirmInsertIface) then FirmInsertIface.ShowType:=stMdiChild;

  if Assigned(CarInsertIface) then CarInsertIface.ShowType:=stMdiChild;
  if Assigned(DriverInsertIface) then DriverInsertIface.ShowType:=stMdiChild;
  if Assigned(DispatcherInsertIface) then DispatcherInsertIface.ShowType:=stMdiChild;
  if Assigned(ClientInsertIface) then ClientInsertIface.ShowType:=stMdiChild;
  if Assigned(DriverOutMessagesIface) then DriverOutMessagesIface.ShowType:=stMdiChild;
  if Assigned(DriverInMessagesIface) then DriverInMessagesIface.ShowType:=stMdiChild;

  if Assigned(OrdersIface) then OrdersIface.ShowType:=stMdiChild;

  LoadRoles;
  
  ZeroWorkingTime;
  RefreshWorkingTime;

  TimerShift.Enabled:=true;

  FAlarmTick:=0;
  TimerAlarm.Enabled:=ShowTrayIcon;
end;

destructor TBisTaxiMainForm.Destroy;
begin
  FAlarms.Free;
  FRoles.Free;
  inherited Destroy;
end;

procedure TBisTaxiMainForm.RefreshMenus;
var
  ParentItems: TActionClients;
  Item: TActionClientItem;

  procedure SetLocalAction(Action: TAction);
  var
    OldIndex: Integer;
  begin
    if Assigned(Item) then begin
      if Action.ImageIndex=-1 then
        OldIndex:=Item.ImageIndex
      else OldIndex:=Action.ImageIndex;
      Item.Action:=Action;
      Item.ImageIndex:=OldIndex;
    end;
  end;

const
  FSFileItemCaption='����';
  FSFileBeginShiftItemCaption='������ �����';
  FSFileEndShiftItemCaption='��������� �����';
  FSFileExitItemCaption='�����';
  FSWindowsItemCaption='����';
  FSWindowsCascadeItemCaption='��������';
  FSWindowsVerticalItemCaption='�����������';
  FSWindowsHorizontalItemCaption='�������������';
  FSWindowsCloseAllItemCaption='������� ���';
begin
  FFileItem:=nil;
  FWindowsItem:=nil;

  if Assigned(ActionMainMenuBar.ActionClient) then begin
    ParentItems:=ActionMainMenuBar.ActionClient.Items;
    if Assigned(ParentItems) then begin
      inherited RefreshMenus;

      FFileItem:=FindItemByCaption(ParentItems,FSFileItemCaption);
      if Assigned(FFileItem) then begin
        Item:=FindItemByCaption(FFileItem.Items,FSFileExitItemCaption);
        SetLocalAction(ActionFileExit);

        Item:=FindItemByCaption(FFileItem.Items,FSFileBeginShiftItemCaption);
        SetLocalAction(ActionBeginShift);

        Item:=FindItemByCaption(FFileItem.Items,FSFileEndShiftItemCaption);
        SetLocalAction(ActionEndShift);
      end;

      FWindowsItem:=FindItemByCaption(ParentItems,FSWindowsItemCaption);
      if Assigned(FWindowsItem) then begin
        Item:=FindItemByCaption(FWindowsItem.Items,FSWindowsCascadeItemCaption);
        SetLocalAction(ActionWindowsCascade);

        Item:=FindItemByCaption(FWindowsItem.Items,FSWindowsVerticalItemCaption);
        SetLocalAction(ActionWindowsVertical);

        Item:=FindItemByCaption(FWindowsItem.Items,FSWindowsHorizontalItemCaption);
        SetLocalAction(ActionWindowsHorizontal);

        Item:=FindItemByCaption(FWindowsItem.Items,FSWindowsCloseAllItemCaption);
        SetLocalAction(ActionWindowsCloseAll);
      end;

      ActionMainMenuBar.CreateControls;
    end;
  end;
end;

procedure TBisTaxiMainForm.ActionBeginShiftExecute(Sender: TObject);
begin
  if BeginShift then begin
    ZeroWorkingTime;
    TimerShift.Enabled:=true;
  end;
end;

procedure TBisTaxiMainForm.ActionBeginShiftUpdate(Sender: TObject);
begin
  ActionBeginShift.Enabled:=Trim(FShiftId)='';
end;

procedure TBisTaxiMainForm.ActionBlackInsertExecute(Sender: TObject);
begin
  if Assigned(BlackInsertIface) then BlackInsertIface.Show;
end;

procedure TBisTaxiMainForm.ActionBlackInsertUpdate(Sender: TObject);
begin
  ActionBlackInsert.Enabled:=Assigned(BlackInsertIface) and BlackInsertIface.CanShow;
end;

procedure TBisTaxiMainForm.ActionCarInsertExecute(Sender: TObject);
begin
  if Assigned(CarInsertIface) then CarInsertIface.Show;
end;

procedure TBisTaxiMainForm.ActionCarInsertUpdate(Sender: TObject);
begin
  ActionCarInsert.Enabled:=Assigned(CarInsertIface) and CarInsertIface.CanShow;
end;

procedure TBisTaxiMainForm.ActionChargeInsertExecute(Sender: TObject);
begin
  if Assigned(ChargeInsertIface) then ChargeInsertIface.Show;
end;

procedure TBisTaxiMainForm.ActionChargeInsertUpdate(Sender: TObject);
begin
  ActionChargeInsert.Enabled:=Assigned(ChargeInsertIface) and ChargeInsertIface.CanShow;
end;

procedure TBisTaxiMainForm.ActionClientInsertExecute(Sender: TObject);
begin
  if Assigned(ClientInsertIface) then ClientInsertIface.Show;
end;

procedure TBisTaxiMainForm.ActionClientInsertUpdate(Sender: TObject);
begin
  ActionClientInsert.Enabled:=Assigned(ClientInsertIface) and ClientInsertIface.CanShow;
end;

procedure TBisTaxiMainForm.ActionDispatcherInsertExecute(Sender: TObject);
begin
  if Assigned(DispatcherInsertIface) then DispatcherInsertIface.Show;
end;

procedure TBisTaxiMainForm.ActionDispatcherInsertUpdate(Sender: TObject);
begin
  ActionDispatcherInsert.Enabled:=Assigned(DispatcherInsertIface) and DispatcherInsertIface.CanShow;
end;

procedure TBisTaxiMainForm.ActionDriverInsertExecute(Sender: TObject);
begin
  if Assigned(DriverInsertIface) then DriverInsertIface.Show;
end;

procedure TBisTaxiMainForm.ActionDriverInsertUpdate(Sender: TObject);
begin
  ActionDriverInsert.Enabled:=Assigned(DriverInsertIface) and DriverInsertIface.CanShow;
end;

procedure TBisTaxiMainForm.ActionEndShiftExecute(Sender: TObject);
begin
  if EndShift then begin
    TimerShift.Enabled:=false;
    ZeroWorkingTime;
  end;
end;

procedure TBisTaxiMainForm.ActionEndShiftUpdate(Sender: TObject);
begin
  ActionEndShift.Enabled:=Trim(FShiftId)<>'';
end;

procedure TBisTaxiMainForm.ActionFirmInsertExecute(Sender: TObject);
begin
  if Assigned(FirmInsertIface) then FirmInsertIface.Show;
end;

procedure TBisTaxiMainForm.ActionFirmInsertUpdate(Sender: TObject);
begin
  ActionFirmInsert.Enabled:=Assigned(FirmInsertIface) and FirmInsertIface.CanShow;
end;

procedure TBisTaxiMainForm.ActionInMessagesExecute(Sender: TObject);
begin
  if Assigned(DriverInMessagesIface) then DriverInMessagesIface.Show;
end;

procedure TBisTaxiMainForm.ActionInMessagesUpdate(Sender: TObject);
begin
  ActionInMessages.Enabled:=Assigned(DriverInMessagesIface) and DriverInMessagesIface.CanShow;
end;

procedure TBisTaxiMainForm.ActionOrderInsertExecute(Sender: TObject);
begin
  if Assigned(OrderInsertIface) then OrderInsertIface.Show;
end;

procedure TBisTaxiMainForm.ActionOrderInsertUpdate(Sender: TObject);
begin
  ActionOrderInsert.Enabled:=Assigned(OrderInsertIface) and OrderInsertIface.CanShow;
end;

procedure TBisTaxiMainForm.ActionOrdersExecute(Sender: TObject);
begin
  if Assigned(OrdersIface) then OrdersIface.Show;
end;

procedure TBisTaxiMainForm.ActionOrdersUpdate(Sender: TObject);
begin
  ActionOrders.Enabled:=Assigned(OrdersIface) and OrdersIface.CanShow;
end;

procedure TBisTaxiMainForm.ActionOutMessageInsertExecute(Sender: TObject);
begin
  if Assigned(OutMessageInsertIface) then OutMessageInsertIface.Show;
end;

procedure TBisTaxiMainForm.ActionOutMessageInsertUpdate(Sender: TObject);
begin
  ActionOutMessageInsert.Enabled:=Assigned(OutMessageInsertIface) and OutMessageInsertIface.CanShow;
end;

procedure TBisTaxiMainForm.ActionOutMessagesExecute(Sender: TObject);
begin
  if Assigned(DriverOutMessagesIface) then DriverOutMessagesIface.Show;
end;

procedure TBisTaxiMainForm.ActionOutMessagesUpdate(Sender: TObject);
begin
  ActionOutMessages.Enabled:=Assigned(DriverOutMessagesIface) and DriverOutMessagesIface.CanShow;
end;

procedure TBisTaxiMainForm.ActionReceiptInsertExecute(Sender: TObject);
begin
  if Assigned(ReceiptInsertIface) then ReceiptInsertIface.Show;
end;

procedure TBisTaxiMainForm.ActionReceiptInsertUpdate(Sender: TObject);
begin
  ActionReceiptInsert.Enabled:=Assigned(ReceiptInsertIface) and ReceiptInsertIface.CanShow;
end;

procedure TBisTaxiMainForm.SetLogoPosition(Visible: Boolean);
begin
  PanelLogo.Anchors:=[];
  if Visible then begin
    PanelLogo.Left:=ClientWidth-PanelLogo.Width-10;
    PanelLogo.Top:=ClientHeight-PanelControlBar.Height-PanelLogo.Height-50;
    PanelLogo.Anchors:=[akRight,akBottom];
    PanelLogo.Visible:=not TBisPicture(ImageLogo.Picture).Empty;
  end else begin
    PanelLogo.Visible:=false;
    PanelLogo.Anchors:=[akLeft,akTop];
    PanelLogo.Top:=50;
  end;
end;

procedure TBisTaxiMainForm.RefreshWorkingTime;
var
  Hour, Min, Sec, MSec: Word;
  Current: TDateTime;
begin

  Current:=Now-FShiftBeginDate;
  DecodeTime(Current,Hour,Min,Sec,MSec);

  if Hour>=24 then begin
    FDays:=FDays+1;
    FTime:=Now;
    Current:=Now-FTime;
  end;

  if FDays>0 then begin
    LabelTime.Caption:=FormatEx('%d ��. %s ',[FDays,FormatDateTime('h:nn:ss',Current)]);
  end else begin
    LabelTime.Caption:=FormatEx('%s ',[FormatDateTime('h:nn:ss',Current)]);
  end;

  LabelTime.Update;
end;

procedure TBisTaxiMainForm.TimerAlarmTimer(Sender: TObject);
begin
  TimerAlarm.Enabled:=false;
  try
    RefreshAlarms(not Odd(FAlarmTick));
    Inc(FAlarmTick);
  finally
    TimerAlarm.Enabled:=true;
  end;
end;

procedure TBisTaxiMainForm.TimerShiftTimer(Sender: TObject);
begin
  TimerShift.Enabled:=false;
  try
    RefreshWorkingTime;
  finally
    TimerShift.Enabled:=true;
  end;
end;

procedure TBisTaxiMainForm.ZeroWorkingTime;
begin
  LabelTime.Caption:=FFirstLabelTimeCaption;
end;

procedure TBisTaxiMainForm.LoadRoles;
var
  P: TBisProvider;
begin
  FRoles.Clear;
  exit;
  P:=TBisProvider.Create(nil);
  try
    P.ProviderName:='S_ACCOUNT_ROLES';
    P.FieldNames.AddInvisible('ROLE_ID');
    P.FilterGroups.Add.Filters.Add('ACCOUNT_ID',fcEqual,Core.AccountId).CheckCase:=true;
    P.Open;
    if P.Active then begin
      P.First;
      while not P.Eof do begin
        FRoles.Add(P.FieldByName('ROLE_ID').AsString);
        P.Next;
      end;
    end;
  finally
    P.Free;
  end;
end;

procedure TBisTaxiMainForm.RefreshAlarms(AVisible: Boolean);
var
  P: TBisProvider;
  D: TDateTime;
  Typ: Integer;
  Flag: TBalloonFlags;
  Exists: Boolean;
  i: Integer;
  Filter: TBisFilter;
begin
  exit;
  if TrayIcon.Visible then begin

    if not AVisible then begin
      TrayIcon.BalloonHint:='';
      TrayIcon.ShowBalloonHint;
    end else begin

      D:=Core.ServerDate;
      P:=TBisProvider.Create(nil);
      try
        P.WithWaitCursor:=false;
        P.ProviderName:='S_ALARMS';
        with P.FieldNames do begin
          AddInvisible('ALARM_ID');
          AddInvisible('TYPE_ALARM');
          AddInvisible('CAPTION');
          AddInvisible('TEXT_ALARM');
          AddInvisible('DATE_BEGIN');
        end;
        with P.FilterGroups.Add do begin
          Filters.Add('DATE_BEGIN',fcEqualLess,D);
        end;
        with P.FilterGroups.Add do begin
          Filters.Add('DATE_END',fcEqualGreater,D);
          Filters.Add('DATE_END',fcIsNull,Null).Operator:=foOr;
        end;
        with P.FilterGroups.Add do begin
          for i:=0 to FRoles.Count-1 do begin
            Filter:=Filters.Add('RECIPIENT_ID',fcEqual,FRoles[i]);
            Filter.Operator:=foOr;
            Filter.CheckCase:=true;
          end;
          Filter:=Filters.Add('RECIPIENT_ID',fcEqual,Core.AccountId);
          Filter.Operator:=foOr;
          Filter.CheckCase:=true;
          Filters.Add('RECIPIENT_ID',fcIsNull,Null).Operator:=foOr;
        end;

        P.Orders.Add('DATE_BEGIN',otDesc);
        P.Open;
        if P.Active and not P.Empty then begin

          Exists:=false;
          P.First;
          while not P.Eof do begin
            if FAlarms.IndexOf(P.FieldByName('ALARM_ID').AsString)=-1 then begin
              Exists:=true;
              break;
            end;
            P.Next;
          end;

          if not Exists then begin
            FAlarms.Clear;
            P.First;
            Exists:=true;
          end;

          if Exists then begin
            TrayIcon.BalloonTitle:=P.FieldByName('CAPTION').AsString+
                                   FormatDateTime(' [dd.mm.yyyy hh:nn:ss]',P.FieldByName('DATE_BEGIN').AsDateTime);
            Typ:=P.FieldByName('TYPE_ALARM').AsInteger;
            Flag:=bfInfo;
            case Typ of
              0: Flag:=bfInfo;
              1: Flag:=bfWarning;
              2: Flag:=bfError;
            end;
            TrayIcon.BalloonFlags:=Flag;
            TrayIcon.BalloonHint:=P.FieldByName('TEXT_ALARM').AsString;
            TrayIcon.ShowBalloonHint;
            FAlarms.Add(P.FieldByName('ALARM_ID').AsString);
          end;
        end;
      finally
        P.Free;
      end;

    end;
  end;
end;


end.