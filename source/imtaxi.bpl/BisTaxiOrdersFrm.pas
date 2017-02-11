unit BisTaxiOrdersFrm;

interface
                                                
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin, StdCtrls,
  ExtCtrls, Grids, DBGrids, Contnrs, GIFImg,
  VirtualTrees, 
  BisFm, BisDataEditFm, BisDataGridFrm, BisDBTree, BisFilterGroups, BisFieldNames, BisDataFrm,
  BisEvents, BisDataSet, BisThreads, BisProvider, BisControls;

type
  TBisTaxiOrdersFrameResultMenuItem=class(TMenuItem)
  private
    FResultId: Variant;
  public
    property ResultId: Variant read FResultId write FResultId;
  end;

  TBisTaxiOrdersFrameActionMenuItem=class(TMenuItem)
  private
    FActionId: Variant;
  public
    property ActionId: Variant read FActionId write FActionId;
  end;

  TBisTaxiOrdersFrame = class(TBisDataGridFrame)
    ActionAutomatic: TAction;
    ActionManual: TAction;
    N1: TMenuItem;
    MenuItemAutomatic: TMenuItem;
    MenuItemManual: TMenuItem;
    MenuItemResults: TMenuItem;
    ActionClientCall: TAction;
    ActionClientMessage: TAction;
    ActionClient: TAction;
    N4: TMenuItem;
    MenuItemClient: TMenuItem;
    MenuItemClientMessage: TMenuItem;
    MenuItemClientCall: TMenuItem;
    MenuItemDriver: TMenuItem;
    MenuItemDriverMessage: TMenuItem;
    MenuItemDriverCall: TMenuItem;
    ActionDriver: TAction;
    ActionDriverMessage: TAction;
    ActionDriverCall: TAction;
    PanelFilter: TPanel;
    LabelCarType: TLabel;
    LabelOrderStatus: TLabel;
    ComboBoxCarTypes: TComboBox;
    ComboBoxOrderStatus: TComboBox;
    CheckBoxOnlyMy: TCheckBox;
    N2: TMenuItem;
    ImageProcess: TImage;
    procedure ComboBoxOrderStatusChange(Sender: TObject);
    procedure ComboBoxCarTypesChange(Sender: TObject);
    procedure PopupPopup(Sender: TObject);
    procedure ActionAutomaticExecute(Sender: TObject);
    procedure ActionManualExecute(Sender: TObject);
    procedure CheckBoxOnlyMyClick(Sender: TObject);
    procedure ActionClientUpdate(Sender: TObject);
    procedure ActionClientCallUpdate(Sender: TObject);
    procedure ActionClientCallExecute(Sender: TObject);
    procedure ActionClientMessageUpdate(Sender: TObject);
    procedure ActionClientMessageExecute(Sender: TObject);
    procedure ActionDriverUpdate(Sender: TObject);
    procedure ActionDriverCallUpdate(Sender: TObject);
    procedure ActionDriverCallExecute(Sender: TObject);
    procedure ActionDriverMessageUpdate(Sender: TObject);
    procedure ActionDriverMessageExecute(Sender: TObject);
  private
    FParentForm: TBisForm;
    FParentFormCaption: String;
    FGroupStatus: String;
    FGroupCarType: String;
    FGroupOnlyMy: String;
    FGroupToday: String;
    FGroupArchive: String;
    FGroupActions: String;
    FResultMenus: TObjectList;
    FActionMenus: TObjectList;
    FFilterMenuItemToday: TBisDataFrameFilterMenuItem;
    FFilterMenuItemArchive: TBisDataFrameFilterMenuItem;
    FPhoneIndex: Integer;
    FEventOrder: TBisEvent;
    FEventProcessBegin: TBisEvent;
    FEventProcessEnd: TBisEvent;
    FImageProcess: TGIFImage;
    FDefaultPhone: String;
    FCallId: Variant;

    function EventOrderHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
    function EventProcessBeginHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
    function EventProcessEndHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
    function GetTimeArrival(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
    function GetTimeUp(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
    function GetTimeBegin(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
    function GetTimeAccept(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
    function GetNewDriverName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;

    procedure GridBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
                                  Column: TColumnIndex; CellRect: TRect);
    procedure GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode;
                            Column: TColumnIndex; TextType: TVSTTextType);
    procedure GridGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
                                var Ghosted: Boolean; var ImageIndex: Integer);
    function GetParentFormCaption: String;
    procedure RefreshCarTypes;
    procedure RefreshFilterGroups;
    procedure ResultMenuItemClick(Sender: TObject);
    procedure RefreshResults;
    procedure ActionMenuItemClick(Sender: TObject);
    procedure RefreshActions;
    function GetCanAutoRefresh: Boolean;
    function GetOrder(OrderId: Variant): Boolean;
    procedure GetData(NewOrderId, OldOrderId: Variant);
    procedure ProcessResult(NewOrderId, OldOrderId, ResultId: Variant; TypeProcess: Integer);
    function CreateOrderHistory(ActionId, ResultId: Variant; TypeProcess: Integer; WithEvent: Boolean; var NewOrderId: Variant): Boolean;
    procedure ChangeTypeProcess(TypeProcess: Integer);
    procedure Automatic;
    procedure Manual;
    procedure ClearResult;
    procedure ApplyResult(ResultId: Variant);
    function GetLockedOrder(var OrderId: Variant): Variant;
    procedure SetLocked(OrderId,Locked: Variant);
    function CanClient: Boolean;
    function CanClientCall: Boolean;
    procedure ClientCall;
    function CanClientMessage: Boolean;
    procedure ClientMessage;
    function CanDriver: Boolean;
    function CanDriverCall: Boolean;
    procedure DriverCall;
    function CanDriverMessage: Boolean;
    procedure DriverMessage;
  protected
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure OpenRecords; override;
    function CanInsertRecord: Boolean; override;
    function CanUpdateRecord: Boolean; override;
    function CanDeleteRecord: Boolean; override;

    procedure ChangeParentFormCaption;
    procedure InsertRecordWithPhone(Phone: String; CallId: Variant);

    property ParentForm: TBisForm read FParentForm write FParentForm;
    property ParentFormCaption: String read FParentFormCaption write FParentFormCaption;

    property CanAutoRefresh: Boolean read GetCanAutoRefresh;
  end;

implementation

uses DateUtils,
     BisValues, BisUtils, BisIfaces, BisCore, BisLogger, BisParam,
     BisTaxiConsts, BisTaxiOrderEditFm, BisTaxiOrderFilterFm, BisTaxiDataOutMessageEditFm,
     BisTaxiDataDriverOutMessageEditFm, BisTaxiPhoneFm, BisTaxiPhoneFrm;

{$R *.dfm}

type
  TBisCarTypeInfo=class(TObject)
  private
    var CarTypeId: Variant;
  end;

{ TBisTaxiOrdersFrame }

constructor TBisTaxiOrdersFrame.Create(AOwner: TComponent);
var
  Stream: TMemoryStream;
begin
  inherited Create(AOwner);

  FResultMenus:=TObjectList.Create;
  FActionMenus:=TObjectList.Create;

  FilterClass:=TBisTaxiOrderFilterFormIface;
  ViewClass:=TBisTaxiOrderViewFormIface;
  InsertClass:=TBisTaxiOrderInsertFormIface;
  UpdateClass:=TBisTaxiOrderUpdateFormIface;
  DeleteClass:=TBisTaxiOrderDeleteFormIface;

  with Provider do begin
    ProviderName:='S_ORDERS';
    UseCache:=false;
    WaitInterval:=1000;
    with FieldNames do begin
      AddKey('ORDER_ID');
      AddInvisible('ACTION_ID');
      AddInvisible('RATE_ID');
      AddInvisible('CAR_TYPE_ID');
      AddInvisible('WHO_ACCEPT_ID');
      AddInvisible('CLIENT_ID');
      AddInvisible('CAR_ID');
      AddInvisible('RESULT_ID');
      AddInvisible('PARK_ID');
      AddInvisible('SOURCE_ID');
      AddInvisible('DISCOUNT_ID');
      AddInvisible('DRIVER_ID');
      AddInvisible('DESCRIPTION');
      AddInvisible('RATE_NAME');
      AddInvisible('CAR_TYPE_NAME');
      AddInvisible('WHO_PROCESS');
      AddInvisible('WHO_PROCESS_ID');
      AddInvisible('DATE_BEGIN');
      AddInvisible('DATE_END');
      AddInvisible('PARK_NAME');
      AddInvisible('PARK_DESCRIPTION');
      AddInvisible('SOURCE_NAME');
      AddInvisible('LOCALITY_ID');
      AddInvisible('LOCALITY_PREFIX');
      AddInvisible('STREET_ID');
      AddInvisible('STREET_PREFIX');
      AddInvisible('ZONE_ID');
      AddInvisible('ACTION_PERIOD');
      AddInvisible('BEFORE_PERIOD');
      AddInvisible('DRIVER_USER_NAME');
      AddInvisible('DRIVER_SURNAME');
      AddInvisible('DRIVER_NAME');
      AddInvisible('DRIVER_PATRONYMIC');
      AddInvisible('DRIVER_PHONE');
      AddInvisible('CAR_CALLSIGN');
      AddInvisible('FINISHED');
      AddInvisible('LOCALITY_NAME');
      AddInvisible('COST_FACT');
      AddInvisible('COST_GROSS');
      AddInvisible('ROUTE_STREET_ID');
      AddInvisible('ROUTE_STREET_PREFIX');
      AddInvisible('ROUTE_LOCALITY_ID');
      AddInvisible('ROUTE_LOCALITY_NAME');
      AddInvisible('ROUTE_LOCALITY_PREFIX');
      AddInvisible('ROUTE_ZONE_ID');
      AddInvisible('CLIENT_SURNAME');
      AddInvisible('CLIENT_NAME');
      AddInvisible('CLIENT_PATRONYMIC');
      AddInvisible('CLIENT_FIRM_SMALL_NAME');
      AddInvisible('CUSTOMER');
      AddInvisible('FIRM_ID');

      AddCalculate('TIME_ARRIVAL','����� ������',GetTimeArrival,ftDateTime,0,60).DisplayFormat:='hh:nn';
      with AddCalculate('TIME_UP','��������',GetTimeUp,ftString,10,40) do begin
        Alignment:=daCenter;
      end;
      Add('PHONE','�������',100);
      FPhoneIndex:=3;
      Add('STREET_NAME','����� ������',90);
      Add('HOUSE','���/������ ������',32);
      Add('FLAT','��������/���� ������',32);
      Add('PORCH','������� ������',25);
      Add('COST_RATE','���������',40).DisplayFormat:='#0';
      Add('ZONE_NAME','���� ������',90);
      with AddCalculate('TIME_BEGIN','������������',GetTimeBegin,ftString,10,35) do begin
        Alignment:=daCenter;
      end;
      Add('ACTION_NAME','��������',90);
      Add('ROUTE_STREET_NAME','����� ����',90);
      Add('ROUTE_HOUSE','���/������ ����',32);
      Add('ROUTE_FLAT','��������/���� ����',32);
      Add('ROUTE_PORCH','������� ����',25);
      Add('ROUTE_ZONE_NAME','���� ����',90);
      Add('RESULT_NAME','���������',90);
      AddCalculate('NEW_DRIVER_NAME','��������',GetNewDriverName,ftString,150,120);
      Add('CAR_COLOR','���� ����������',70);
      Add('CAR_BRAND','����� ����������',80);
      Add('CAR_STATE_NUM','���. ����� ����������',60);
      Add('CLIENT_USER_NAME','������',100);
      Add('DISCOUNT_TYPE_NAME','��� ��������',100);
      Add('DISCOUNT_NUM','����� ��������',100);
      Add('WHO_ACCEPT','��� ������',100);
      Add('FIRM_SMALL_NAME','�����������',100);
      AddCalculate('TIME_ACCEPT','����� �����������',GetTimeAccept,ftDateTime,0,50).DisplayFormat:='hh:nn:ss';
      Add('DATE_ACCEPT','���� �����������',70).DisplayFormat:='dd.mm.yyyy';
      Add('DATE_ARRIVAL','���� ������',70).DisplayFormat:='dd.mm.yyyy';
      Add('ORDER_NUM','� ������',50);

      Add('ACTION_BRUSH_COLOR','���� ���� ��������',50).Visible:=false;
      Add('ACTION_FONT_COLOR','���� ������ ��������',50).Visible:=false;
      Add('RESULT_BRUSH_COLOR','���� ���� ����������',50).Visible:=false;
      Add('RESULT_FONT_COLOR','���� ������ ����������',50).Visible:=false;
      Add('TYPE_PROCESS','��� ���������',20).Visible:=false;
      Add('LOCKED','����������',20).Visible:=false;
      Add('TYPE_ACCEPT','��������',20).Visible:=false;

    end;
    with FilterGroups.Add do begin
    {  Filters.Add('PARENT_ID',fcIsNull,Null);
      Filters.Add('DATE_HISTORY',fcIsNull,Null);  }
      Filters.Add('WHO_HISTORY_ID',fcIsNull,Null);
    end;
  end;
  RequestLargeData:=true;

  EventRefreshName:=Provider.ProviderName;

  Grid.OnPaintText:=GridPaintText;
  Grid.OnBeforeCellPaint:=GridBeforeCellPaint;
  Grid.OnGetImageIndex:=GridGetImageIndex;

  CheckBoxOnlyMy.Visible:=not VarIsNull(Core.FirmId);

  FGroupStatus:=GetUniqueID;
  FGroupCarType:=GetUniqueID;
  FGroupOnlyMy:=GetUniqueID;
  FGroupToday:=GetUniqueID;
  FGroupArchive:=GetUniqueID;
  FGroupActions:=GetUniqueID;

  FFilterMenuItemToday:=CreateFilterMenuItem('�� �����');
  FFilterMenuItemToday.Checked:=true;

  FFilterMenuItemArchive:=CreateFilterMenuItem('�����');
  FFilterMenuItemArchive.RequestLargeData:=true;

  FEventOrder:=Core.Events.Add(SEventOrder,EventOrderHandler,false);
  FEventProcessBegin:=Core.Events.Add(SEventProcessBegin,EventProcessBeginHandler,false);
  FEventProcessEnd:=Core.Events.Add(SEventProcessEnd,EventProcessEndHandler,false);

  FImageProcess:=TGIFImage.Create;

  Stream:=TMemoryStream.Create;
  try
    ImageProcess.Picture.Graphic.SaveToStream(Stream);
    Stream.Position:=0;
    ImageProcess.Picture.Graphic:=FImageProcess;
    ImageProcess.Picture.Graphic.LoadFromStream(Stream);
  finally
    Stream.Free;
  end;

  TGIFImage(ImageProcess.Picture.Graphic).AnimationSpeed:=500;

  RefreshCarTypes;

  RefreshActions;

  FCallId:=Null;

end;

destructor TBisTaxiOrdersFrame.Destroy;
begin
  ClearStrings(ComboBoxCarTypes.Items);
  FActionMenus.Free;
  FResultMenus.Free;
  Core.Events.Remove(FEventProcessEnd);
  Core.Events.Remove(FEventProcessBegin);
  Core.Events.Remove(FEventOrder);
  FImageProcess.Free;
  inherited Destroy;
end;

function TBisTaxiOrdersFrame.EventOrderHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
var
  POrder: TBisEventParam;
  B: TBookmark;
  S: String;
  OldOrderId: Variant;
  NewOrderId: Variant;
  TypeProcess: Variant;
  Locked: Variant;
begin
  Result:=false;
  if CanAutoRefresh then begin
    POrder:=InParams.Find('OldOrderId');
    if Assigned(POrder) then begin
      if Provider.Active and not Provider.Empty then begin
        B:=Provider.GetBookmark;
        try
          OldOrderId:=iff(Trim(POrder.AsString)='',Null,POrder.Value);
          if not VarIsNull(OldOrderId) then begin

            S:=VarToStrDef(InParams.Value['NewOrderId'],'');
            NewOrderId:=iff(Trim(S)='',Null,S);

            S:=VarToStrDef(InParams.Value['TypeProcess'],'');
            TypeProcess:=iff(Trim(S)='',Null,StrToIntDef(S,0));

            S:=VarToStrDef(InParams.Value['Locked'],'');
            Locked:=iff(Trim(S)='',Null,S);

            if Provider.Locate('ORDER_ID',OldOrderId,[]) then begin
              Provider.Edit;
              if not VarIsNull(NewOrderId) and not VarSameValue(OldOrderId,NewOrderId) then
                Provider.FieldByName('ORDER_ID').Value:=NewOrderId;
              if not VarIsNull(TypeProcess) then
                Provider.FieldByName('TYPE_PROCESS').Value:=TypeProcess;
              Provider.FieldByName('LOCKED').Value:=Locked;
              Provider.Post;
              Grid.Synchronize;
              Result:=true;
            end;
          end;
        finally
          if Assigned(B) and Provider.BookmarkValid(B) then
            Provider.GotoBookmark(B);
        end;
      end;
    end;
  end;
end;

function TBisTaxiOrdersFrame.EventProcessBeginHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
begin
  Result:=false;
  if Event=FEventProcessBegin then begin
    ImageProcess.Visible:=true;
    TGIFImage(ImageProcess.Picture.Graphic).Animate:=true;
    Result:=true;
  end;
end;

function TBisTaxiOrdersFrame.EventProcessEndHandler(Event: TBisEvent; InParams, OutParams: TBisEventParams): Boolean;
begin
  Result:=false;
  if Event=FEventProcessEnd then begin
    TGIFImage(ImageProcess.Picture.Graphic).Animate:=false;
    ImageProcess.Visible:=false;
  end;
end;

procedure TBisTaxiOrdersFrame.Init;
begin
  inherited Init;
{  DuplicateClass:=nil;
  ToolButtonInsert.Style:=tbsTextButton;
  ToolButtonInsert.Caption:=ActionInsert.Caption;}
end;

procedure TBisTaxiOrdersFrame.OpenRecords;
begin
  RefreshFilterGroups;
  inherited OpenRecords;
end;

procedure TBisTaxiOrdersFrame.ActionAutomaticExecute(Sender: TObject);
begin
  Automatic;
end;

procedure TBisTaxiOrdersFrame.ActionClientCallExecute(Sender: TObject);
begin
  ClientCall;
end;

procedure TBisTaxiOrdersFrame.ActionClientCallUpdate(Sender: TObject);
begin
  ActionClientCall.Enabled:=CanClientCall;
end;

procedure TBisTaxiOrdersFrame.ActionClientMessageExecute(Sender: TObject);
begin
  ClientMessage;
end;

procedure TBisTaxiOrdersFrame.ActionClientMessageUpdate(Sender: TObject);
begin
  ActionClientMessage.Enabled:=CanClientMessage;
end;

procedure TBisTaxiOrdersFrame.ActionClientUpdate(Sender: TObject);
begin
  ActionClient.Enabled:=CanClient;
end;

procedure TBisTaxiOrdersFrame.ActionDriverCallExecute(Sender: TObject);
begin
  DriverCall;
end;

procedure TBisTaxiOrdersFrame.ActionDriverCallUpdate(Sender: TObject);
begin
  ActionDriverCall.Enabled:=CanDriverCall;
end;

procedure TBisTaxiOrdersFrame.ActionDriverMessageExecute(Sender: TObject);
begin
  DriverMessage;
end;

procedure TBisTaxiOrdersFrame.ActionDriverMessageUpdate(Sender: TObject);
begin
  ActionDriverMessage.Enabled:=CanDriverMessage;
end;

procedure TBisTaxiOrdersFrame.ActionDriverUpdate(Sender: TObject);
begin
  ActionDriver.Enabled:=CanDriver;
end;

procedure TBisTaxiOrdersFrame.ActionManualExecute(Sender: TObject);
begin
  Manual;
end;

function TBisTaxiOrdersFrame.GetLockedOrder(var OrderId: Variant): Variant;
var
  P: TBisProvider;
begin
  Result:=Null;
  OrderId:=Null;
  if Provider.Active and not Provider.Empty then begin
    OrderId:=Provider.FieldByName('ORDER_ID').Value;
    Result:=Provider.FieldByName('LOCKED').Value;
    P:=TBisProvider.Create(nil);
    try
      P.UseShowError:=false;
      P.UseWaitCursor:=false;
      P.ProviderName:='CHECK_LOCK_ORDER';
      with P.Params do begin
        AddInvisible('ORDER_ID').Value:=OrderId;
        AddInvisible('LOCKED',ptOutput);
      end;
      try
        P.Execute;
        if P.Success then begin
          Result:=P.Params.ParamByName('LOCKED').Value;
        end;
      except
        on E: Exception do
          LoggerWrite(E.Message,ltError);
      end;
    finally
      P.Free;
    end;
  end;
end;

procedure TBisTaxiOrdersFrame.SetLocked(OrderId,Locked: Variant);
begin
  if Provider.Active and not Provider.Empty then begin
    Provider.BeginUpdate(true);
    try
      if Provider.Locate('ORDER_ID',OrderId,[loCaseInsensitive]) then begin
        Provider.Edit;
        Provider.FieldByName('LOCKED').Value:=Locked;
        Provider.Post;
        Grid.Synchronize;
      end;
    finally
      Provider.EndUpdate(true);
    end;
  end;
end;

procedure TBisTaxiOrdersFrame.PopupPopup(Sender: TObject);
var
  OldCursor: TCursor;
  Locked: Variant;
  OrderId: Variant;
begin
  inherited;
  OldCursor:=Screen.Cursor;
  Screen.Cursor:=crHourGlass;
  try
    Locked:=GetLockedOrder(OrderId);
    if VarIsNull(Locked) then begin
      RefreshResults;
      ActionAutomatic.Visible:=Provider.Active and not Provider.Empty and
                               (Provider.FieldByName('TYPE_PROCESS').AsInteger=1) and
                               (ComboBoxOrderStatus.ItemIndex in [0,1]);
      ActionManual.Visible:=Provider.Active and not Provider.Empty and
                            (Provider.FieldByName('TYPE_PROCESS').AsInteger=0) and
                            (ComboBoxOrderStatus.ItemIndex in [0,1]);
      MenuItemResults.Visible:=(ComboBoxOrderStatus.ItemIndex in [0,1]) and Provider.Active and not Provider.Empty;
    end else begin
      FResultMenus.Clear;
      MenuItemResults.Clear;
      ActionAutomatic.Visible:=false;
      ActionManual.Visible:=false;
      MenuItemResults.Visible:=false;
    end;
    SetLocked(OrderId,Locked);
  finally
    Screen.Cursor:=OldCursor;
  end;
end;

function TBisTaxiOrdersFrame.GetTimeAccept(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  FieldDate: TField;
begin
  Result:=Null;
  if DataSet.Active then begin
    FieldDate:=DataSet.FieldByName('DATE_ACCEPT');
    if not VarIsNull(FieldDate.Value) then begin
      Result:=TimeOf(FieldDate.AsDateTime);
    end;
  end;
end;

function TBisTaxiOrdersFrame.GetTimeArrival(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  FieldDate: TField;
begin
  Result:=Null;
  if DataSet.Active then begin
    FieldDate:=DataSet.FieldByName('DATE_ARRIVAL');
    if not VarIsNull(FieldDate.Value) then begin
      Result:=TimeOf(FieldDate.AsDateTime);
    end;
  end;
end;

function TBisTaxiOrdersFrame.GetTimeBegin(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  FieldDate: TField;
  D: TDateTime;
begin
  Result:=Null;
  if DataSet.Active and Assigned(Core) then begin
    FieldDate:=DataSet.FieldByName('DATE_BEGIN');
    if not VarIsNull(FieldDate.Value) then begin
      D:=Core.ServerDate-FieldDate.AsDateTime;
      Result:=FormatDateTime('h:nn',D);
    end;
  end;
end;

function TBisTaxiOrdersFrame.GetTimeUp(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  FieldDate: TField;
  D: TDateTime;
begin
  Result:=Null;
  if DataSet.Active and Assigned(Core) then begin
    FieldDate:=DataSet.FieldByName('DATE_ARRIVAL');
    if ComboBoxOrderStatus.ItemIndex in [0,1] then begin
      if not VarIsNull(FieldDate.Value) then begin
        D:=FieldDate.AsDateTime-Core.ServerDate;
        if D>=0 then
          Result:=FormatDateTime('� h:nn',D)
        else
          Result:=FormatDateTime('+ h:nn',D);
      end;
    end else begin
      Result:='�';
    end;
  end;
end;

function TBisTaxiOrdersFrame.GetNewDriverName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  S1, S2, S3, S4: String;
begin
  Result:=Null;
  if DataSet.Active then begin
    S1:=DataSet.FieldByName('DRIVER_USER_NAME').AsString;
    S2:=DataSet.FieldByName('DRIVER_SURNAME').AsString;
    S3:=DataSet.FieldByName('DRIVER_NAME').AsString;
    S4:=DataSet.FieldByName('DRIVER_PATRONYMIC').AsString;
    Result:=FormatEx('%s - %s %s',[S1,S2,S3,S4]);
    if Trim(Result)='-' then
      Result:=Null;
  end;
end;

procedure TBisTaxiOrdersFrame.GridBeforeCellPaint(Sender: TBaseVirtualTree; TargetCanvas: TCanvas; Node: PVirtualNode;
                                                  Column: TColumnIndex; CellRect: TRect);
var
  ActionColor: Variant;
  ResultColor: Variant;
  AColor: TColor;
begin
  ActionColor:=Grid.GetNodeValue(Node,'ACTION_BRUSH_COLOR');
  ResultColor:=Grid.GetNodeValue(Node,'RESULT_BRUSH_COLOR');
  AColor:=TColor(VarToIntDef(ActionColor,clWindow));
  if not VarIsNull(ResultColor) then
    AColor:=TColor(VarToIntDef(ResultColor,clWindow));
  TargetCanvas.Brush.Style:=bsSolid;
  TargetCanvas.Brush.Color:=AColor;
  TargetCanvas.FillRect(CellRect);
end;

procedure TBisTaxiOrdersFrame.GridGetImageIndex(Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
                                                var Ghosted: Boolean; var ImageIndex: Integer);
var
  TypeProcess: Integer;
  Locked: Boolean;
  TypeAccept: Integer;
begin
  if (Column=1) then begin
    Locked:=not VarIsNull(Grid.GetNodeValue(Node,'LOCKED'));
    TypeProcess:=VarToIntDef(Grid.GetNodeValue(Node,'TYPE_PROCESS'),1);
    if TypeProcess=0 then
      ImageIndex:=iff(not Locked,16,18)
    else ImageIndex:=iff(not Locked,17,19)
  end;
  if (Column=FPhoneIndex) then begin
    TypeAccept:=VarToIntDef(Grid.GetNodeValue(Node,'TYPE_ACCEPT'),0);
    case TypeAccept of
      0: ImageIndex:=20;
      1: ImageIndex:=21;
      2: ImageIndex:=22;
    else
      ImageIndex:=20;
    end;
  end;
end;

procedure TBisTaxiOrdersFrame.GridPaintText(Sender: TBaseVirtualTree; const TargetCanvas: TCanvas; Node: PVirtualNode;
                                            Column: TColumnIndex; TextType: TVSTTextType);
var
  ActionColor: Variant;
  ResultColor: Variant;
  AColor: TColor;
  Phone: String;
  TownPhone: Boolean;
  Flag: Boolean;
  L: Integer;
begin
  Flag:=((Node=Grid.FocusedNode) and (Column<>Grid.FocusedColumn)) or (Node<>Grid.FocusedNode);
  if Flag then begin
    ActionColor:=Grid.GetNodeValue(Node,'ACTION_FONT_COLOR');
    ResultColor:=Grid.GetNodeValue(Node,'RESULT_FONT_COLOR');
    AColor:=TColor(VarToIntDef(ActionColor,clWindowText));
    if not VarIsNull(ResultColor) then
      AColor:=TColor(VarToIntDef(ResultColor,clWindowText));
    TargetCanvas.Font.Color:=AColor;
  end;
  Flag:=(Column=FPhoneIndex);
  if Flag then begin
    Phone:=Trim(VarToStrDef(Grid.GetNodeValue(Node,'PHONE'),''));
    L:=Length('+70123456789');
    TownPhone:=Length(Phone)<L;
    if TownPhone then begin
      TargetCanvas.Font.Style:=[fsBold];
    end else begin
      if Length(Phone)>L then
        TargetCanvas.Font.Style:=[fsStrikeOut];
    end;
  end;
end;

function TBisTaxiOrdersFrame.GetParentFormCaption: String;
var
  S: String;
begin
  Result:=FParentFormCaption;
  if ComboBoxOrderStatus.ItemIndex<>-1 then begin
    S:=ComboBoxOrderStatus.Items[ComboBoxOrderStatus.ItemIndex];
    Result:=FormatEx('%s - %s',[FParentFormCaption,S]);
    if ComboBoxCarTypes.ItemIndex<>-1 then begin
      S:=ComboBoxCarTypes.Items[ComboBoxCarTypes.ItemIndex];
      Result:=FormatEx('%s / %s',[Result,S]);
    end;
  end;
end;

function TBisTaxiOrdersFrame.CanInsertRecord: Boolean;
begin
  Result:=inherited CanInsertRecord;
  if Result then begin
    Result:=ComboBoxOrderStatus.ItemIndex in [0,1];
  end;
end;

function TBisTaxiOrdersFrame.CanUpdateRecord: Boolean;
{var
  V: Variant; }
begin
  Result:=inherited CanUpdateRecord;
  if Result then begin
    Result:=ComboBoxOrderStatus.ItemIndex in [0,1];
    if Result then begin
      if Provider.Active and not Provider.Empty then
        if not VarIsNull(Core.FirmId) then begin
        {  V:=Provider.FieldByName('FIRM_ID').Value;
          Result:=VarSameValue(Core.FirmId,V); }
        end;
    end;
  end;
end;

function TBisTaxiOrdersFrame.CanDeleteRecord: Boolean;
begin
  Result:=inherited CanDeleteRecord;
  if Result then begin
    Result:=ComboBoxOrderStatus.ItemIndex in [0,1,2];
    if Result then begin
      if Provider.Active and not Provider.Empty then
        if not VarIsNull(Core.FirmId) then
          Result:=VarSameValue(Core.FirmId,Provider.FieldByName('FIRM_ID').Value);
    end;
  end;
end;

procedure TBisTaxiOrdersFrame.ChangeParentFormCaption;
begin
  Caption:=GetParentFormCaption;
  if Assigned(FParentForm) then
    FParentForm.Caption:=Caption;
end;

procedure TBisTaxiOrdersFrame.ComboBoxCarTypesChange(Sender: TObject);
begin
  ChangeParentFormCaption;
  RefreshRecords;
  if Grid.Visible and Grid.Enabled and Grid.CanFocus then
    Grid.SetFocus;
end;

procedure TBisTaxiOrdersFrame.ComboBoxOrderStatusChange(Sender: TObject);
begin
  ChangeParentFormCaption;
  RefreshRecords;
  if Grid.Visible and Grid.Enabled and Grid.CanFocus then
    Grid.SetFocus;
end;

procedure TBisTaxiOrdersFrame.RefreshCarTypes;
var
  P: TBisProvider;
  Obj: TBisCarTypeInfo;
  Index: Integer;
begin
  ClearStrings(ComboBoxCarTypes.Items);
  ComboBoxCarTypes.Items.BeginUpdate;
  P:=TBisProvider.Create(nil);
  try
    P.ProviderName:='S_CAR_TYPES';
    with P.FieldNames do begin
      AddInvisible('CAR_TYPE_ID');
      AddInvisible('NAME');
    end;
    P.FilterGroups.Add.Filters.Add('VISIBLE',fcEqual,1);
    P.Orders.Add('PRIORITY');
    P.Open;
    if P.Active and not P.Empty then begin
      Index:=ComboBoxCarTypes.Items.AddObject('�����',nil);
      try
        P.First;
        while not P.Eof do begin
          Obj:=TBisCarTypeInfo.Create;
          Obj.CarTypeId:=P.FieldByName('CAR_TYPE_ID').Value;
          ComboBoxCarTypes.Items.AddObject(P.FieldByName('NAME').AsString,Obj);
          P.Next;
        end;
      finally
        ComboBoxCarTypes.ItemIndex:=Index;
      end;
    end;
  finally
    P.Free;
    ComboBoxCarTypes.Items.EndUpdate;
  end;
end;

procedure TBisTaxiOrdersFrame.RefreshFilterGroups;
var
  Group1, Group2, Group3, Group4: TBisFilterGroup;
  Obj: TBisCarTypeInfo;
  D: TDateTime;
  i: Integer;
  MenuItem: TBisTaxiOrdersFrameActionMenuItem;
begin

  D:=Core.ServerDate;

  with FFilterMenuItemToday do begin
    Group1:=FilterGroups.Find(FGroupToday);
    if Assigned(Group1) then
      FilterGroups.Remove(Group1);
    Group1:=FilterGroups.AddByName(FGroupToday,foAnd,True);
    Group1.Filters.Add('DATE_ARRIVAL',fcGreater,IncDay(D,-1));
  end;

  with FFilterMenuItemArchive do begin
    Group2:=FilterGroups.Find(FGroupArchive);
    if Assigned(Group2) then
      FilterGroups.Remove(Group2);
    Group2:=FilterGroups.AddByName(FGroupArchive,foAnd,True);
    Group2.Filters.Add('DATE_ARRIVAL',fcEqualLess,IncDay(D,-1));
  end;

  Group1:=Provider.FilterGroups.Find(FGroupStatus);
  if Assigned(Group1) then
    Provider.FilterGroups.Remove(Group1);
  if ComboBoxOrderStatus.ItemIndex<>-1 then begin
    Group1:=Provider.FilterGroups.AddByName(FGroupStatus);
    if Assigned(Group1) then begin
      Group1.Filters.Add('STATUS',fcEqual,ComboBoxOrderStatus.ItemIndex);
    end;
  end;

  Group2:=Provider.FilterGroups.Find(FGroupCarType);
  if Assigned(Group2) then
    Provider.FilterGroups.Remove(Group2);
  if ComboBoxCarTypes.ItemIndex>0 then begin
    Group2:=Provider.FilterGroups.AddByName(FGroupCarType);
    if Assigned(Group2) then begin
      Obj:=TBisCarTypeInfo(ComboBoxCarTypes.Items.Objects[ComboBoxCarTypes.ItemIndex]);
      Group2.Filters.Add('CAR_TYPE_ID',fcEqual,Obj.CarTypeId).CheckCase:=true;
    end;
  end;

  Group3:=Provider.FilterGroups.Find(FGroupOnlyMy);
  if Assigned(Group3) then
    Provider.FilterGroups.Remove(Group3);
  if CheckBoxOnlyMy.Visible and CheckBoxOnlyMy.Checked then begin
    Group3:=Provider.FilterGroups.AddByName(FGroupOnlyMy);
    if Assigned(Group3) then begin
      Group3.Filters.Add('FIRM_ID',fcEqual,Core.FirmId).CheckCase:=true;
    end;
  end;

  Group4:=Provider.FilterGroups.Find(FGroupActions);
  if Assigned(Group4) then
    Provider.FilterGroups.Remove(Group4);
  Group4:=Provider.FilterGroups.AddByName(FGroupActions);
  if Assigned(Group4) then begin
    for i:=0 to FActionMenus.Count-1 do begin
      MenuItem:=TBisTaxiOrdersFrameActionMenuItem(FActionMenus.Items[i]);
      if MenuItem.Checked then begin
        with Group4.Filters.Add('ACTION_ID',fcEqual,MenuItem.ActionId) do begin
          CheckCase:=true;
          &Operator:=foOr;
        end;
      end;
    end;
  end;

end;

procedure TBisTaxiOrdersFrame.ResultMenuItemClick(Sender: TObject);
var
  MenuItem: TBisTaxiOrdersFrameResultMenuItem;
begin
  if Assigned(Sender) and (Sender is TBisTaxiOrdersFrameResultMenuItem) then begin
    MenuItem:=TBisTaxiOrdersFrameResultMenuItem(Sender);
    if VarIsNull(MenuItem.ResultId) then
      ClearResult
    else
      ApplyResult(MenuItem.ResultId);
  end;
end;

procedure TBisTaxiOrdersFrame.RefreshResults;
var
  Index: Integer;

  procedure AddMenu(ResultId: Variant; Caption: String; Hint: String);
  var
    MenuItem: TBisTaxiOrdersFrameResultMenuItem;
  begin
    MenuItem:=TBisTaxiOrdersFrameResultMenuItem.Create(nil);
    if not VarIsNull(ResultId) then begin
      MenuItem.Caption:=Caption;
      MenuItem.Hint:='���������� ��������� '+Hint;
      MenuItem.ResultId:=ResultId;
      MenuItem.OnClick:=ResultMenuItemClick;
    end else begin
      MenuItem.Caption:=Caption;
      if Caption<>'-' then begin
        MenuItem.Hint:='������ ��������� '+Hint;
        MenuItem.ResultId:=Null;
        MenuItem.OnClick:=ResultMenuItemClick;
      end;
    end;
    MenuItemResults.Insert(Index,MenuItem);
    Inc(Index);
    FResultMenus.Add(MenuItem);
  end;

var
  P: TBisProvider;
  ResultId: Variant;
begin
  FResultMenus.Clear;
  MenuItemResults.Clear;
  if Provider.Active and not Provider.Empty then begin
    if ComboBoxOrderStatus.ItemIndex in [0,1] then begin
      ResultId:=Provider.FieldByName('RESULT_ID').Value;
      P:=TBisProvider.Create(nil);
      try
        P.UseWaitCursor:=false;
        P.ProviderName:='S_RESULTS';
        with P.FieldNames do begin
          AddInvisible('RESULT_ID');
          AddInvisible('NAME');
        end;
        with P.FilterGroups.Add do begin
          Filters.Add('ACTION_ID',fcEqual,Provider.FieldByName('ACTION_ID').Value).CheckCase:=true;
          Filters.Add('VISIBLE',fcEqual,1);
        end;
        P.Orders.Add('PRIORITY');
        P.Open;
        if P.Active and not P.Empty then begin

          Index:=0;
          if not VarIsNull(ResultId) then begin
            AddMenu(Null,'������ ���������',Provider.FieldByName('RESULT_NAME').AsString);
            AddMenu(Null,'-','');
          end;

          P.First;
          while not P.Eof do begin
            ResultId:=P.FieldByName('RESULT_ID').Value;
            AddMenu(ResultId,P.FieldByName('NAME').AsString,P.FieldByName('NAME').AsString);
            P.Next;
          end;

        end;
      finally
        P.Free;
      end;
    end;
  end;
end;

procedure TBisTaxiOrdersFrame.ActionMenuItemClick(Sender: TObject);
var
  MenuItem, Item: TBisTaxiOrdersFrameActionMenuItem;
  i: Integer;
begin
  if Assigned(Sender) and (Sender is TBisTaxiOrdersFrameActionMenuItem) then begin
    MenuItem:=TBisTaxiOrdersFrameActionMenuItem(Sender);
    if not VarIsNull(MenuItem.ActionId) then begin
      MenuItem.Checked:=not MenuItem.Checked;
      RefreshRecords;
    end else begin
      for i:=0 to FActionMenus.Count-1 do begin
        Item:=TBisTaxiOrdersFrameActionMenuItem(FActionMenus.Items[i]);
        if Item<>MenuItem then
          Item.Checked:=false;
      end;
      RefreshRecords;
    end;
  end;
end;

procedure TBisTaxiOrdersFrame.RefreshActions;
var
  Index: Integer;

  function AddMenu(ActionId: Variant; Caption: String; Hint: String): TBisTaxiOrdersFrameActionMenuItem;
  var
    MenuItem: TBisTaxiOrdersFrameActionMenuItem;
  begin
    MenuItem:=TBisTaxiOrdersFrameActionMenuItem.Create(nil);
    MenuItem.Caption:=Caption;
    MenuItem.Hint:=Hint;
    if MenuItem.Caption<>'' then
      MenuItem.OnClick:=ActionMenuItemClick;
    MenuItem.ActionId:=ActionId;
    MenuItem.Checked:=false;
    Popup.Items.Insert(Index,MenuItem);
    Inc(Index);
    FActionMenus.Add(MenuItem);
    Result:=MenuItem;
  end;

var
  P: TBisProvider;
  ActionId: Variant;
begin
  FActionMenus.Clear;
  P:=TBisProvider.Create(nil);
  try
    P.UseWaitCursor:=false;
    P.ProviderName:='S_ACTIONS';
    with P.FieldNames do begin
      AddInvisible('ACTION_ID');
      AddInvisible('NAME');
      AddInvisible('DESCRIPTION');
    end;
    P.Orders.Add('PRIORITY');
    P.Open;
    if P.Active and not P.Empty then begin
      Index:=Popup.Items.Count-1;
      P.First;
      while not P.Eof do begin
        ActionId:=P.FieldByName('ACTION_ID').Value;
        AddMenu(ActionId,
                P.FieldByName('NAME').AsString,
                P.FieldByName('DESCRIPTION').AsString);
        P.Next;
      end;
      AddMenu(Null,'-','');
      AddMenu(Null,'��������','�������� ��� ��������');
    end;
  finally
    P.Free;
  end;
end;

function TBisTaxiOrdersFrame.GetCanAutoRefresh: Boolean;
begin
  Result:=not Popup.MenuActive and
          (ComboBoxOrderStatus.ItemIndex in [0,1]) and
          Assigned(Grid) and not (tsThumbTracking in Grid.TreeStates) and
          MenuItemRefreshEvent.Checked;
end;

function TBisTaxiOrdersFrame.GetOrder(OrderId: Variant): Boolean;
var
  P: TBisProvider;
begin
  Result:=false;
  if not VarIsNull(OrderId) then begin
    P:=TBisProvider.Create(nil);
    try
      P.ProviderName:=Provider.ProviderName;
      P.FieldNames.CopyFrom(Provider.FieldNames);
      P.FilterGroups.CopyFrom(Provider.FilterGroups);
      P.FilterGroups.Add.Filters.Add('ORDER_ID',fcEqual,OrderId).CheckCase:=true;
      P.Open;
      if P.Active then begin
        if not P.Empty then begin
          Provider.Edit;
          Provider.CopyRecord(P,false,false);
          Provider.Synchronize;
          Provider.Post;
        end else
          Provider.Delete;
      end;
    finally
      P.Free;
    end;
  end;
end;

procedure TBisTaxiOrdersFrame.GetData(NewOrderId, OldOrderId: Variant);
begin
  if not VarIsNull(NewOrderId) and not VarIsNull(OldOrderId) then begin
    if Provider.Active and not Provider.IsEmpty then begin
      Provider.BeginUpdate(true);
      try
        if Provider.Locate('ORDER_ID',OldOrderId,[loCaseInsensitive]) then
          GetOrder(NewOrderId);
      finally
        Provider.EndUpdate;
      end;
    end;
  end;
end;

procedure TBisTaxiOrdersFrame.ProcessResult(NewOrderId, OldOrderId, ResultId: Variant; TypeProcess: Integer);
var
  P: TBisProvider;
begin
  if not VarIsNull(NewOrderId) and not VarIsNull(OldOrderId) and not VarIsNull(ResultId) then begin
    P:=TBisProvider.Create(nil);
    try
      P.UseWaitCursor:=false;
      P.ProviderName:='PROCESS_RESULT';
      with P.Params do begin
        AddInvisible('OLD_ORDER_ID').Value:=NewOrderId;
        AddInvisible('NEW_ORDER_ID').Value:=GetUniqueID;
        AddInvisible('ACCOUNT_ID').Value:=Core.AccountId;
        AddInvisible('RESULT_ID').Value:=ResultId;
        AddInvisible('TYPE_PROCESS').Value:=TypeProcess;
        AddInvisible('WITH_EVENT').Value:=1;
        AddInvisible('ORDER_ID',ptOutput);
      end;
      P.Execute;
      if P.Success then begin
        NewOrderId:=P.Params.ParamByName('ORDER_ID').Value;
        GetData(NewOrderId,OldOrderId);
      end;
    finally
      P.Free;
    end;
  end;
end;

function TBisTaxiOrdersFrame.CreateOrderHistory(ActionId, ResultId: Variant; TypeProcess: Integer;
                                                WithEvent: Boolean; var NewOrderId: Variant): Boolean;
var
  P: TBisProvider;
  OrderId: Variant;
begin
  Result:=false;
  if Provider.Active and not Provider.Empty then begin
    OrderId:=Provider.FieldByName('ORDER_ID').Value;
    NewOrderId:=GetUniqueID;
    P:=TBisProvider.Create(nil);
    try
      P.UseWaitCursor:=false;
      P.ProviderName:='CREATE_ORDER_HISTORY';
      with P.Params do begin
        AddInvisible('OLD_ORDER_ID').Value:=OrderId;
        AddInvisible('NEW_ORDER_ID').Value:=NewOrderId;
        AddInvisible('ACCOUNT_ID').Value:=Core.AccountId;
        AddInvisible('ACTION_ID').Value:=ActionId;
        AddInvisible('RESULT_ID').Value:=ResultId;
        AddInvisible('TYPE_PROCESS').Value:=TypeProcess;
        AddInvisible('DATE_BEGIN').Value:=Core.ServerDate;
        AddInvisible('WITH_DEPENDS').Value:=1;
        AddInvisible('WITH_EVENT').Value:=iff(WithEvent,1,Null);
      end;
      P.Execute;
      if P.Success then
        Result:=true;
    finally
      P.Free;
    end;
  end;
end;

procedure TBisTaxiOrdersFrame.ChangeTypeProcess(TypeProcess: Integer);
var
  ActionId: Variant;
  ResultId: Variant;
  OldOrderId: Variant;
  NewOrderId: Variant;
  OldCursor: TCursor;
begin
  if Provider.Active and not Provider.Empty then begin
    OldCursor:=Screen.Cursor;
    Screen.Cursor:=crHourGlass;
    try
      ActionId:=Provider.FieldByName('ACTION_ID').Value;
      ResultId:=Null;
      case TypeProcess of
        0: ResultId:=Null;
        1: ResultId:=Provider.FieldByName('RESULT_ID').Value;
      end;
      OldOrderId:=Provider.FieldByName('ORDER_ID').Value;
      if CreateOrderHistory(ActionId,ResultId,TypeProcess,true,NewOrderId) then begin
        GetData(NewOrderId,OldOrderId);
      end;
    finally
      Screen.Cursor:=OldCursor;
    end;
  end;
end;

procedure TBisTaxiOrdersFrame.CheckBoxOnlyMyClick(Sender: TObject);
begin
  RefreshRecords;
  if Grid.Visible and Grid.Enabled and Grid.CanFocus then
    Grid.SetFocus;
end;

procedure TBisTaxiOrdersFrame.Automatic;
begin
  ChangeTypeProcess(0);
end;

procedure TBisTaxiOrdersFrame.Manual;
begin
  ChangeTypeProcess(1);
end;

procedure TBisTaxiOrdersFrame.ClearResult;
var
  ActionId: Variant;
  TypeProcess: Integer;
  OldOrderId: Variant;
  NewOrderId: Variant;
  OldCursor: TCursor;
begin
  if Provider.Active and not Provider.Empty then begin
    OldCursor:=Screen.Cursor;
    Screen.Cursor:=crHourGlass;
    try
      Self.Update;
      ActionId:=Provider.FieldByName('ACTION_ID').Value;
      TypeProcess:=Provider.FieldByName('TYPE_PROCESS').AsInteger;
      OldOrderId:=Provider.FieldByName('ORDER_ID').Value;
      if CreateOrderHistory(ActionId,Null,TypeProcess,true,NewOrderId) then begin
        GetData(NewOrderId,OldOrderId);
      end;
    finally
      Screen.Cursor:=OldCursor;
    end;
  end;
end;

procedure TBisTaxiOrdersFrame.ApplyResult(ResultId: Variant);
var
  ActionId: Variant;
  TypeProcess: Integer;
  OldOrderId: Variant;
  NewOrderId: Variant;
  OldCursor: TCursor;
begin
  if Provider.Active and not Provider.Empty then begin
    OldCursor:=Screen.Cursor;
    Screen.Cursor:=crHourGlass;
    try
      Self.Update;
      ActionId:=Provider.FieldByName('ACTION_ID').Value;
      TypeProcess:=Provider.FieldByName('TYPE_PROCESS').AsInteger;
      OldOrderId:=Provider.FieldByName('ORDER_ID').Value;
      if CreateOrderHistory(ActionId,ResultId,TypeProcess,false,NewOrderId) then begin
        ProcessResult(NewOrderId,OldOrderId,ResultId,TypeProcess);
      end;
    finally
      Screen.Cursor:=OldCursor;
    end;
  end;
end;

function TBisTaxiOrdersFrame.CanClient: Boolean;
begin
  Result:=Provider.Active and not Provider.Empty and
          (Trim(Provider.FieldByName('PHONE').AsString)<>'');
end;

function TBisTaxiOrdersFrame.CanClientCall: Boolean;
var
  AIface: TBisTaxiPhoneFormIface;
begin
  Result:=CanClient;
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

procedure TBisTaxiOrdersFrame.ClientCall;
var
  AIface: TBisTaxiPhoneFormIface;
begin
  if CanClientCall then begin
    AIface:=TBisTaxiPhoneFormIface(Core.FindIface(TBisTaxiPhoneFormIface));
    if Assigned(AIface) then begin
      AIface.Dial(Provider.FieldByName('PHONE').AsString);
    end;
  end;
end;

function TBisTaxiOrdersFrame.CanClientMessage: Boolean;
var
  AClass: TBisIfaceClass;
  AIface: TBisDataEditFormIface;
begin
  Result:=CanClient;
  if Result then begin
    AClass:=TBisTaxiDataOutMessageInsertFormIface;
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

procedure TBisTaxiOrdersFrame.ClientMessage;
var
  AClass: TBisIfaceClass;
  AIface: TBisDataEditFormIface;
  P1: TBisParam;
begin
  if CanClientMessage then begin
    AClass:=TBisTaxiDataOutMessageInsertFormIface;
    AIface:=TBisDataEditFormIfaceClass(AClass).Create(nil);
    try
      AIface.Init;
      with AIface.Params do begin
        ParamByName('ORDER_ID').Value:=Provider.FieldByName('ORDER_ID').Value;
        ParamByName('RECIPIENT_ID').Value:=Provider.FieldByName('CLIENT_ID').Value;
        ParamByName('RECIPIENT_USER_NAME').Value:=Provider.FieldByName('CLIENT_USER_NAME').Value;
        ParamByName('RECIPIENT_SURNAME').Value:=Provider.FieldByName('CLIENT_SURNAME').Value;
        ParamByName('RECIPIENT_NAME').Value:=Provider.FieldByName('CLIENT_NAME').Value;
        ParamByName('RECIPIENT_PATRONYMIC').Value:=Provider.FieldByName('CLIENT_PATRONYMIC').Value;
        ParamByName('CONTACT').Value:=Provider.FieldByName('PHONE').Value;
        P1:=ParamByName('RECIPIENT_USER_NAME;RECIPIENT_SURNAME;RECIPIENT_NAME;RECIPIENT_PATRONYMIC');
        P1.Value:=AIface.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
      end;
      AIface.ShowType:=ShowType;
      AIface.ShowModal;
    finally
      AIface.Free;
    end;
  end;
end;

function TBisTaxiOrdersFrame.CanDriver: Boolean;
begin
  Result:=Provider.Active and not Provider.Empty and
          (Trim(Provider.FieldByName('DRIVER_PHONE').AsString)<>'');
end;

function TBisTaxiOrdersFrame.CanDriverCall: Boolean;
var
  AIface: TBisTaxiPhoneFormIface;
begin
  Result:=CanDriver;
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

procedure TBisTaxiOrdersFrame.DriverCall;
var
  AIface: TBisTaxiPhoneFormIface;
begin
  if CanDriverCall then begin
    AIface:=TBisTaxiPhoneFormIface(Core.FindIface(TBisTaxiPhoneFormIface));
    if Assigned(AIface) then begin
      AIface.Dial(Provider.FieldByName('DRIVER_PHONE').AsString);
    end;
  end;
end;

function TBisTaxiOrdersFrame.CanDriverMessage: Boolean;
var
  AClass: TBisIfaceClass;
  AIface: TBisDataEditFormIface;
begin
  Result:=CanDriver;
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

procedure TBisTaxiOrdersFrame.DriverMessage;
var
  AClass: TBisIfaceClass;
  AIface: TBisDataEditFormIface;
  P1: TBisParam;
begin
  if CanDriverMessage then begin
    AClass:=TBisTaxiDataDriverOutMessageInsertFormIface;
    AIface:=TBisDataEditFormIfaceClass(AClass).Create(nil);
    try
      AIface.Init;
      with AIface.Params do begin
        ParamByName('ORDER_ID').Value:=Provider.FieldByName('ORDER_ID').Value;
        ParamByName('RECIPIENT_ID').Value:=Provider.FieldByName('DRIVER_ID').Value;
        ParamByName('RECIPIENT_USER_NAME').Value:=Provider.FieldByName('DRIVER_USER_NAME').Value;
        ParamByName('RECIPIENT_SURNAME').Value:=Provider.FieldByName('DRIVER_SURNAME').Value;
        ParamByName('RECIPIENT_NAME').Value:=Provider.FieldByName('DRIVER_NAME').Value;
        ParamByName('RECIPIENT_PATRONYMIC').Value:=Provider.FieldByName('DRIVER_PATRONYMIC').Value;
        ParamByName('CONTACT').Value:=Provider.FieldByName('DRIVER_PHONE').Value;
        P1:=ParamByName('RECIPIENT_USER_NAME;RECIPIENT_SURNAME;RECIPIENT_NAME;RECIPIENT_PATRONYMIC');
        P1.Value:=AIface.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
      end;
      AIface.ShowType:=ShowType;
      AIface.ShowModal;
    finally
      AIface.Free;
    end;
  end;
end;

procedure TBisTaxiOrdersFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
begin
  inherited BeforeIfaceExecute(AIface);
  if Assigned(AIface) and (AIface is TBisTaxiOrderInsertFormIface) then begin
    TBisTaxiOrderInsertFormIface(AIface).DefaultPhone:=FDefaultPhone;
    TBisTaxiOrderInsertFormIface(AIface).CallId:=FCallId;
    FDefaultPhone:='';
    FCallId:=Null;
  end;
end;

procedure TBisTaxiOrdersFrame.InsertRecordWithPhone(Phone: String; CallId: Variant);
begin
  FDefaultPhone:=Phone;
  FCallId:=CallId;
  InsertRecord;
end;


end.