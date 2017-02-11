unit BisTaxiMainFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, StdCtrls, ExtCtrls, XPMan, ComCtrls, Contnrs,
  BisObject, ActnList, XPStyleActnCtrls, ShellAPI, AppEvnts, Menus, ActnPopup, Buttons,
  ActnMan, ToolWin, ActnCtrls, ActnMenus, CustomizeDlg, jpeg, ActnColorMaps,
  OleCtrls, SHDocVw,

  BisFm, BisCore, BisConnections, BisDataFm, BisProvider, BisIfaces, BisNotifyEvents,
  BisMdiButtonGroup,
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
    procedure ActionClientInsertExecute(Sender: TObject);
    procedure ActionClientInsertUpdate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    FFileItem: TActionClientItem;
    FWindowsItem: TActionClientItem;
    FBlackInsertIface: TBisFormIface;
    FCarInsertIface: TBisFormIface;
    FOutMessageInsertIface: TBisFormIface;
    FDriverInsertIface: TBisFormIface;
    FDispatcherInsertIface: TBisFormIface;
    FClientInsertIface: TBisFormIface;
    FReceiptInsertIface: TBisFormIface;
    FChargeInsertIface: TBisFormIface;
    FOrderInsertIface: TBisFormIface;
    FDriverInMessagesIface: TBisFormIface;
    FDriverOutMessagesIface: TBisFormIface;
    FOrdersIface: TBisFormIface;
    FFirmInsertIface: TBisFormIface;

    function ButtonGroupCanAdd(Sender: TObject; AForm: TForm): Boolean;
  protected
    procedure SetLogoPosition(Visible: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure BeforeShow; override;
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

implementation

{$R *.dfm}

uses BisIfaceModules, BisConsts, BisUtils, BisFilterGroups, BisFieldNames, BisOrders,
     BisDialogs, BisPicture,
     BisTaxiConsts, BisTaxiOrdersFm,
     BisTaxiDataBlackEditFm, BisTaxiDataCarEditFm, BisTaxiDataDriverEditFm, BisTaxiDataDispatcherEditFm,
     BisTaxiDataOutMessageEditFm, BisTaxiDataClientEditFm,
     BisTaxiOrderEditFm, BisTaxiDataReceiptEditFm, BisTaxiDataChargeEditFm,
     BisTaxiDataDriverInMessagesFm, BisTaxiDataDriverOutMessagesFm,
     BisDesignDataFirmEditFm;

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

  ButtonGroup.Align:=alNone;
  ButtonGroup.Parent:=ControlBar;
  ButtonGroup.GradientEndColor:=ControlBar.GradientEndColor;
  ButtonGroup.Left:=ToolBar.Left+ToolBar.Width+1;
  ButtonGroup.Height:=ToolBar.Height;
  ButtonGroup.Width:=50;
  ButtonGroup.Top:=0;
  ButtonGroup.ButtonWidth:=75;
  ButtonGroup.ButtonHeight:=ToolBar.Height;
  ButtonGroup.DrawingStyle:=dsGradient;
  ButtonGroup.OnCanAdd:=ButtonGroupCanAdd;

  FBlackInsertIface:=TBisTaxiDataBlackInsertFormIface.Create(nil);
  FCarInsertIface:=TBisTaxiDataCarEditFormIface.Create(nil);
  FOutMessageInsertIface:=TBisTaxiDataOutMessageInsertExFormIface.Create(nil);
  FDriverInsertIface:=TBisTaxiDataDriverInsertFormIface.Create(nil);
  FDispatcherInsertIface:=TBisTaxiDataDispatcherInsertFormIface.Create(nil);
  FClientInsertIface:=TBisTaxiDataClientInsertFormIface.Create(nil);
  FReceiptInsertIface:=TBisTaxiDataReceiptInsertFormIface.Create(nil);
  FChargeInsertIface:=TBisTaxiDataChargeInsertFormIface.Create(nil);
  FOrderInsertIface:=TBisTaxiOrderInsertFormIface.Create(nil);
  FDriverInMessagesIface:=TBisTaxiDataDriverInMessagesFormIface.Create(nil);
  FDriverOutMessagesIface:=TBisTaxiDataDriverOutMessagesFormIface.Create(nil);
  FOrdersIface:=TBisTaxiOrdersFormIface(Core.FindIface(TBisTaxiOrdersFormIface));
  FFirmInsertIface:=TBisDesignDataFirmInsertFormIface.Create(nil);

end;

destructor TBisTaxiMainForm.Destroy;
begin
  FFirmInsertIface.Free;
  FOrdersIface:=nil;
  FDriverOutMessagesIface.Free;
  FDriverInMessagesIface.Free;
  FOrderInsertIface.Free;
  FChargeInsertIface.Free;
  FReceiptInsertIface.Free;
  FClientInsertIface.Free;
  FDispatcherInsertIface.Free;
  FDriverInsertIface.Free;
  FCarInsertIface.Free;
  FBlackInsertIface.Free;
  inherited Destroy;
end;

procedure TBisTaxiMainForm.FormResize(Sender: TObject);
begin
  inherited;
  ButtonGroup.Width:=ControlBar.ClientWidth-ToolBar.Left+ToolBar.Width-5;
end;

procedure TBisTaxiMainForm.Init;
begin
  inherited Init;
  FBlackInsertIface.Init;
  FCarInsertIface.Init;
  FOutMessageInsertIface.Init;
  FDriverInsertIface.Init;
  FDispatcherInsertIface.Init;
  FClientInsertIface.Init;
  FReceiptInsertIface.Init;
  FChargeInsertIface.Init;
  FOrderInsertIface.Init;
  FDriverInMessagesIface.Init;
  FDriverOutMessagesIface.Init;
  if Assigned(FOrdersIface) then
    FOrdersIface.Init;
  FFirmInsertIface.Init;
end;

procedure TBisTaxiMainForm.BeforeShow;
begin
  inherited BeforeShow;
  FBlackInsertIface.ShowType:=stMdiChild;
  FCarInsertIface.ShowType:=stMdiChild;
  FOutMessageInsertIface.ShowType:=stMdiChild;
  FDriverInsertIface.ShowType:=stMdiChild;
  FDispatcherInsertIface.ShowType:=stMdiChild;
  FClientInsertIface.ShowType:=stMdiChild;
  FReceiptInsertIface.ShowType:=stMdiChild;
  FChargeInsertIface.ShowType:=stMdiChild;
  FOrderInsertIface.ShowType:=stMdiChild;
  FDriverInMessagesIface.ShowType:=stMdiChild;
  FDriverOutMessagesIface.ShowType:=stMdiChild;
  if Assigned(FOrdersIface) then
    FOrdersIface.ShowType:=stMdiChild;
  FFirmInsertIface.ShowType:=stMdiChild;
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
  BeginShift;
end;

procedure TBisTaxiMainForm.ActionBeginShiftUpdate(Sender: TObject);
begin
  ActionBeginShift.Enabled:=Trim(FShiftId)='';
end;

procedure TBisTaxiMainForm.ActionBlackInsertExecute(Sender: TObject);
begin
  FBlackInsertIface.Show;
end;

procedure TBisTaxiMainForm.ActionBlackInsertUpdate(Sender: TObject);
begin
  ActionBlackInsert.Enabled:=FBlackInsertIface.CanShow;
end;

procedure TBisTaxiMainForm.ActionCarInsertExecute(Sender: TObject);
begin
  FCarInsertIface.Show;
end;

procedure TBisTaxiMainForm.ActionCarInsertUpdate(Sender: TObject);
begin
  ActionCarInsert.Enabled:=FCarInsertIface.CanShow;
end;

procedure TBisTaxiMainForm.ActionChargeInsertExecute(Sender: TObject);
begin
  FChargeInsertIface.Show;
end;

procedure TBisTaxiMainForm.ActionChargeInsertUpdate(Sender: TObject);
begin
  ActionChargeInsert.Enabled:=FChargeInsertIface.CanShow;
end;

procedure TBisTaxiMainForm.ActionClientInsertExecute(Sender: TObject);
begin
  FClientInsertIface.Show;
end;

procedure TBisTaxiMainForm.ActionClientInsertUpdate(Sender: TObject);
begin
  ActionClientInsert.Enabled:=FClientInsertIface.CanShow;
end;

procedure TBisTaxiMainForm.ActionDispatcherInsertExecute(Sender: TObject);
begin
  FDispatcherInsertIface.Show;
end;

procedure TBisTaxiMainForm.ActionDispatcherInsertUpdate(Sender: TObject);
begin
  ActionDispatcherInsert.Enabled:=FDispatcherInsertIface.CanShow;
end;

procedure TBisTaxiMainForm.ActionDriverInsertExecute(Sender: TObject);
begin
  FDriverInsertIface.Show;
end;

procedure TBisTaxiMainForm.ActionDriverInsertUpdate(Sender: TObject);
begin
  ActionDriverInsert.Enabled:=FDriverInsertIface.CanShow;
end;

procedure TBisTaxiMainForm.ActionEndShiftExecute(Sender: TObject);
begin
  EndShift;
end;

procedure TBisTaxiMainForm.ActionEndShiftUpdate(Sender: TObject);
begin
  ActionEndShift.Enabled:=Trim(FShiftId)<>'';
end;

procedure TBisTaxiMainForm.ActionFirmInsertExecute(Sender: TObject);
begin
  FFirmInsertIface.Show;
end;

procedure TBisTaxiMainForm.ActionFirmInsertUpdate(Sender: TObject);
begin
  ActionFirmInsert.Enabled:=FFirmInsertIface.CanShow;
end;

procedure TBisTaxiMainForm.ActionInMessagesExecute(Sender: TObject);
begin
  FDriverInMessagesIface.Show;
end;

procedure TBisTaxiMainForm.ActionInMessagesUpdate(Sender: TObject);
begin
  ActionInMessages.Enabled:=FDriverInMessagesIface.CanShow;
end;

procedure TBisTaxiMainForm.ActionOrderInsertExecute(Sender: TObject);
begin
  FOrderInsertIface.Show;
end;

procedure TBisTaxiMainForm.ActionOrderInsertUpdate(Sender: TObject);
begin
  ActionOrderInsert.Enabled:=FOrderInsertIface.CanShow;
end;

procedure TBisTaxiMainForm.ActionOrdersExecute(Sender: TObject);
begin
  if Assigned(FOrdersIface) then
    FOrdersIface.Show;
end;

procedure TBisTaxiMainForm.ActionOrdersUpdate(Sender: TObject);
begin
  ActionOrders.Enabled:=Assigned(FOrdersIface) and FOrdersIface.CanShow;
end;

procedure TBisTaxiMainForm.ActionOutMessageInsertExecute(Sender: TObject);
begin
  FOutMessageInsertIface.Show;
end;

procedure TBisTaxiMainForm.ActionOutMessageInsertUpdate(Sender: TObject);
begin
  ActionOutMessageInsert.Enabled:=FOutMessageInsertIface.CanShow;
end;

procedure TBisTaxiMainForm.ActionOutMessagesExecute(Sender: TObject);
begin
  FDriverOutMessagesIface.Show;
end;

procedure TBisTaxiMainForm.ActionOutMessagesUpdate(Sender: TObject);
begin
  ActionOutMessages.Enabled:=FDriverOutMessagesIface.CanShow;
end;

procedure TBisTaxiMainForm.ActionReceiptInsertExecute(Sender: TObject);
begin
  FReceiptInsertIface.Show;
end;

procedure TBisTaxiMainForm.ActionReceiptInsertUpdate(Sender: TObject);
begin
  ActionReceiptInsert.Enabled:=FReceiptInsertIface.CanShow;
end;

function TBisTaxiMainForm.ButtonGroupCanAdd(Sender: TObject; AForm: TForm): Boolean;
begin
  Result:=Assigned(AForm);
{  if Result then
    Result:=not (AForm is TBisTaxiOrdersForm);}
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

end.