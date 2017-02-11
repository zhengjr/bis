unit BisMdiMainFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, StdCtrls, ExtCtrls, XPMan, ComCtrls, Contnrs,
  BisObject, ActnList, XPStyleActnCtrls, ShellAPI, AppEvnts, Menus, ActnPopup, Buttons,
  ActnMan, ToolWin, ActnCtrls, ActnMenus, CustomizeDlg, jpeg, ActnColorMaps, OleCtrls, SHDocVw,

  BisFm, BisMainFm, BisCore, BisConnections, BisDataFm, BisProvider, BisIfaces,
  BisDataEditFm, BisMenus, BisInterfaces, BisNotifyEvents, BisMdiButtonGroup,
  BisProgressEvents;

type
  TBisMdiMainFormIface=class;

  TWebBrowser=class(SHDocVw.TWebBrowser)
  private
    FStatusText: String;
  protected
    procedure CreateParams(var Params: TCreateParams); override;

  published
    property StatusText: String read FStatusText write FStatusText;
  end;

  TStatusBar=class(ComCtrls.TStatusBar)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TActionMainMenuBar=class(ActnMenus.TActionMainMenuBar)
  public
    procedure CreateControls; override;
  end;

  TBisMdiMainFormMenu=class(TBisMenu)
  private
    FAction: TAction;
    FActionItem: TActionClientItem;
    FLinked: Boolean;
    procedure ActionExecute(Sender: TObject);
    procedure ActionUpdate(Sender: TObject);
  protected
    procedure SetIface(AIface: TBisIface); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LinkAction(Action: TAction);

    property Action: TAction read FAction write FAction;
    property ActionItem: TActionClientItem read FActionItem write FActionItem;
    property Linked: Boolean read FLinked;
  end;

  TBisMdiMainFormMenus=class(TBisMenus)
  private
    FImageList: TImageList;
    function GetItem(Index: Integer): TBisMdiMainFormMenu;
  protected
    function GetObjectClass: TBisObjectClass; override;
  public
    function AddAction(Action: TAction; Iface: TBisIface): TBisMdiMainFormMenu;
    procedure Refresh(ActionManager: TCustomActionManager; Items: TActionClients);

    property Items[Index: Integer]: TBisMdiMainFormMenu read GetItem;
    property ImageList: TImageList read FImageList write FImageList;
  end;

  TBisMdiMainForm = class(TBisMainForm)
    StatusBar: TStatusBar;
    ImageListMenu: TImageList;
    ApplicationEvents: TApplicationEvents;
    PanelLogo: TPanel;
    ImageLogo: TImage;
    PanelContent: TPanel;
    WebBrowser: TWebBrowser;
    ActionMainMenuBar: TActionMainMenuBar;
    PanelProgress: TPanel;
    ProgressBar: TProgressBar;
    ButtonInterrupt: TSpeedButton;
    procedure ActionFileExitExecute(Sender: TObject);
    procedure ActionWindowsCloseAllExecute(Sender: TObject);
    procedure ActionWindowsCloseAllUpdate(Sender: TObject);
    procedure ActionWindowsCascadeExecute(Sender: TObject);
    procedure ActionWindowsVerticalExecute(Sender: TObject);
    procedure ActionWindowsHorizontalExecute(Sender: TObject);
    procedure ApplicationEventsHint(Sender: TObject);
    procedure StatusBarResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ActionMainMenuBarDockOver(Sender: TObject;
      Source: TDragDockObject; X, Y: Integer; State: TDragState;
      var Accept: Boolean);
    procedure FormResize(Sender: TObject);
    procedure ImageLogoClick(Sender: TObject);
    procedure ButtonInterruptClick(Sender: TObject);
    procedure ButtonInterruptMouseEnter(Sender: TObject);
    procedure ButtonInterruptMouseLeave(Sender: TObject);
  private
    FSActionBarWindowMenu: String;
    FAutoMenu: Boolean;
    FMenus: TBisMdiMainFormMenus;
    FInterrupted: Boolean;
    FRefreshMenuEvent: TBisNotifyEvent;
    FProgressEvent: TBisProgressEvent;
    FAfterLoginEvent: TBisNotifyEvent;
    FSFormatCaption: String;
    FLogoExists: Boolean;
    FContentExists: Boolean;
    FButtonGroup: TBisMdiButtonGroup;
    FOldCursor: TCursor;

//    procedure InternetProtocolGetDocumentByUrl(const Url: string; Stream: TMemoryStream; var Found: Boolean);
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure RePositionProgressBars;
    procedure InternalRefreshMenus(Sender: TObject);
    procedure InternalAfterLogin(Sender: TObject);
    procedure InternalProgress(const Min, Max, Position: Integer; var Interrupted: Boolean);
  protected
    procedure CreateWnd; override;
    procedure SetConnectionCaption; virtual;
    procedure SetAccountUserName; virtual;
    procedure SetLogoPosition(Visible: Boolean); virtual;
    procedure SetContentPosition(Visible: Boolean); virtual;
    procedure LoadLogo; virtual;
    procedure LoadContent; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    
    procedure RefreshMenus; virtual;
    function FindItemByCaption(ParentItems: TActionClients; ACaption: String): TActionClientItem;

    property AutoMenu: Boolean read FAutoMenu write FAutoMenu;

    property Menus: TBisMdiMainFormMenus read FMenus;
    property ButtonGroup: TBisMdiButtonGroup read FButtonGroup;  
  published

    property SActionBarWindowMenu: String read FSActionBarWindowMenu write FSActionBarWindowMenu;
    property SFormatCaption: String read FSFormatCaption write FSFormatCaption;
  end;

  TBisMdiMainFormIface=class(TBisMainFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisMdiMainForm: TBisMdiMainForm;

implementation

{$R *.dfm}

uses MSHTML, ActiveX,
     BisIfaceModules, BisConsts, BisUtils, BisFilterGroups, BisDialogs, BisPicture,
     BisInternetProtocol, BisConnectionUtils,
     BisCoreIntf;

procedure ShowMDIClientEdge(ClientHandle: THandle; ShowEdge: Boolean);
var
  Style: Longint;
begin
  if ClientHandle <> 0 then
  begin
    Style := GetWindowLong(ClientHandle, GWL_EXSTYLE);
    if ShowEdge then
      if Style and WS_EX_CLIENTEDGE = 0 then
        Style := Style or WS_EX_CLIENTEDGE
      else
        Exit
    else if Style and WS_EX_CLIENTEDGE <> 0 then
      Style := Style and not WS_EX_CLIENTEDGE
    else
      Exit;
    SetWindowLong(ClientHandle, GWL_EXSTYLE, Style);
    SetWindowPos(ClientHandle, 0, 0,0,0,0, SWP_FRAMECHANGED or SWP_NOACTIVATE or
      SWP_NOMOVE or SWP_NOSIZE or SWP_NOZORDER);
  end;
end;

     
{ TWebBrowser }

procedure TWebBrowser.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
end;

{ TStatusBar }

constructor TStatusBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle:=ControlStyle+[csAcceptsControls];
end;

{ TActionMainMenuBar }

procedure TActionMainMenuBar.CreateControls;
var
  H: Integer;
begin
  H:=Height;
  try
    inherited CreateControls;
  finally
    Height:=H;
  end;
end;

{ TBisMdiMainFormMenu }

constructor TBisMdiMainFormMenu.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TBisMdiMainFormMenu.Destroy;
var
  YesFree: Boolean;
begin
  YesFree:=Assigned(FActionItem);
  if FLinked then begin
    FreeAndNilEx(FAction);
    YesFree:=false;
  end;
  inherited Destroy;
  if YesFree then
    FreeAndNilEx(FActionItem);
end;

procedure TBisMdiMainFormMenu.LinkAction(Action: TAction);
begin
  FAction := Action;
  if Assigned(FAction) then begin
    FAction.Caption:=Caption;
    FAction.Hint:=Description;
    FAction.ShortCut:=ShortCut;
    FAction.OnExecute:=ActionExecute;
    FAction.OnUpdate:=ActionUpdate;
    FLinked:=true;
  end;
end;

procedure TBisMdiMainFormMenu.SetIface(AIface: TBisIface);
begin
  inherited SetIface(AIface);
  if Assigned(AIface) and (AIface is TBisFormIface) then
    TBisFormIface(AIface).ShowAfterMainForm:=true;
end;

procedure TBisMdiMainFormMenu.ActionExecute(Sender: TObject);
var
  Action: TAction;
begin
  if Assigned(Iface) then begin
    if Iface is TBisFormIface then begin
      with TBisFormIface(Iface) do begin
        ShowType:=stMdiChild;
      end;   
    end;
  end;
  if Assigned(Sender) and (Sender is TAction) then begin
    Action:=TAction(Sender);
    if Action.ImageIndex<>-1 then begin

    end;
  end;
  Show;
end;

procedure TBisMdiMainFormMenu.ActionUpdate(Sender: TObject);
begin
  FAction.Enabled:=CanShow;
end;

{ TBisMdiMainFormMenus }

function TBisMdiMainFormMenus.AddAction(Action: TAction; Iface: TBisIface): TBisMdiMainFormMenu;
begin
  Result:=TBisMdiMainFormMenu(inherited Add(GetUniqueID));
  if Assigned(Result) then begin
    Result.Action:=Action;
    if Assigned(Action) then begin
      Action.OnExecute:=Result.ActionExecute;
      Action.OnUpdate:=Result.ActionUpdate;
      Result.Caption:=Action.Caption;
      Result.Description:=Action.Hint;
    end;
    Result.Iface:=Iface;
  end;
end;

function TBisMdiMainFormMenus.GetItem(Index: Integer): TBisMdiMainFormMenu;
begin
  Result:=TBisMdiMainFormMenu(inherited Items[Index]);
end;

function TBisMdiMainFormMenus.GetObjectClass: TBisObjectClass;
begin
  Result:=TBisMdiMainFormMenu;
end;

procedure TBisMdiMainFormMenus.Refresh(ActionManager: TCustomActionManager; Items: TActionClients);

  function FindByCaption(ParentItems: TActionClients; ACaption: String): TActionClientItem;
  var
    i: Integer;
    Item: TActionClientItem;
  begin
    Result:=nil;
    if Trim(ACaption)<>SMenuDelim then
      for i:=0 to ParentItems.Count-1 do begin
        Item:=ParentItems[i];
        if AnsiSameText(Item.Caption,ACaption) and
           not Assigned(Item.Action) then begin
          Result:=Item;
          exit;
        end;
      end;
  end;

  function GetRealyIndex(ParentItems: TActionClients; Menu: TBisMdiMainFormMenu): Integer;
  var
    ActionItem: TActionClientItem;
  begin
    ActionItem:=FindByCaption(ParentItems,Menu.Caption);
    if Assigned(ActionItem) and not Assigned(ActionItem.Action) then begin
      Result:=ActionItem.Index;
    end else begin
      if Menu.Priority>ParentItems.Count then
        Result:=ParentItems.Count
      else Result:=Menu.Priority;
    end;
  end;

  function GetImageIndex(Menu: TBisMdiMainFormMenu): Integer;
  var
    Bmp,Mask: TBitmap;
  begin
    Result:=-1;                                            
    if not Menu.Picture.Empty then begin
      if Menu.Picture.Graphic is TBitmap then begin
        Bmp:=TBitmap.Create;
        Mask:=TBitmap.Create;
        try
          Bmp.Height:=FImageList.Height;
          Bmp.Width:=FImageList.Width;
          Bmp.Canvas.StretchDraw(Rect(0,0,Bmp.Width,Bmp.Height),Menu.Picture.Graphic);
          Bmp.TransparentColor:=Bmp.Canvas.Pixels[0,0];
          Mask.Assign(Bmp);
          Mask.Mask(Bmp.TransparentColor);
          Bmp.Transparent:=true;
          Result:=FImageList.Add(Bmp,Mask);
        finally
          Mask.Free;
          Bmp.Free;
        end;
      end;
      if Menu.Picture.Graphic is TIcon then
        Result:=FImageList.AddIcon(TIcon(Menu.Picture.Graphic));
    end;
  end;

  procedure RefreshMenu(ParentMenus: TBisMenus; ParentItems: TActionClients);
  var
    i: Integer;
    Action: TAction;
    ActionItem: TActionClientItem;
    Menu: TBisMdiMainFormMenu;
    Index: Integer;
    ImageIndex: Integer;
  begin
    for i:=0 to ParentMenus.Count-1 do begin
      Menu:=TBisMdiMainFormMenu(ParentMenus.Items[i]);
      Index:=GetRealyIndex(ParentItems,Menu);
      if Assigned(Menu.Iface) then begin
        ActionItem:=TActionClientItem(ParentItems.Insert(Index));
        ActionItem.Caption:=Menu.Caption;
        Menu.ActionItem:=ActionItem;
        Action:=TAction.Create(Menu);
        Menu.LinkAction(Action);
        ActionItem.Action:=Menu.Action;
        Menu.Action.ActionList:=ActionManager;
        ImageIndex:=GetImageIndex(Menu);
        Menu.Action.ImageIndex:=ImageIndex;
        ActionItem.ImageIndex:=ImageIndex;
      end else begin
        ActionItem:=FindByCaption(ParentItems,Menu.Caption);
        if not Assigned(ActionItem) then begin
          ActionItem:=TActionClientItem(ParentItems.Insert(Index));
          Menu.ActionItem:=ActionItem;
        end;
        ActionItem.Caption:=Menu.Caption;
        ImageIndex:=GetImageIndex(Menu);
        ActionItem.ImageIndex:=ImageIndex;
        RefreshMenu(Menu.Childs,ActionItem.Items);
      end;
    end;
  end;

begin
  Clear;
  if Assigned(ActionManager) and Assigned(Items) and Assigned(FImageList) then begin
    if DefaultLoadMenus(Self) then
      RefreshMenu(Self,Items);
  end;
end;

{ TBisMdiMainFormIface }

constructor TBisMdiMainFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisMdiMainForm;
end;

{ TBisMdiMainForm }

constructor TBisMdiMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CoInitialize(nil);

  FMenus:=TBisMdiMainFormMenus.Create(Self);
  FMenus.Interfaces:=Core.Interfaces;
  FMenus.ImageList:=ImageListMenu;

  FButtonGroup:=TBisMdiButtonGroup.Create(Self);
  FButtonGroup.Parent:=Self;
  FButtonGroup.Align:=alTop;
  FButtonGroup.Top:=ActionMainMenuBar.Top+ActionMainMenuBar.Height+1;
  FButtonGroup.MdiClientHandle:=ClientHandle;
  FButtonGroup.GradientEndColor:=ActionMainMenuBar.Color;
//  FButtonGroup.Caption:='��� �� ������ ����';

  FRefreshMenuEvent:=Core.ContentEvents.Add(InternalRefreshMenus);
  FProgressEvent:=Core.ProgressEvents.Add(InternalProgress);
  FAfterLoginEvent:=Core.AfterLoginEvents.Add(InternalAfterLogin);

  PanelProgress.Parent:=StatusBar;
  PanelProgress.ParentBackground:=true;

  ActionMainMenuBar.ColorMap.SelectedColor:=ColorSelected;

  LoadLogo;
  LoadContent;

  FSActionBarWindowMenu:='����';
  FSFormatCaption:='%s: %s';

  SetConnectionCaption;
  SetAccountUserName;

  ImageLogo.Align:=alClient;
  Windows.SetParent(PanelLogo.Handle,ClientHandle);
  SetLogoPosition(false);

  Windows.SetParent(PanelContent.Handle,ClientHandle);
  SetContentPosition(false);

{  RegisterNameSpace('bis-main');
  BisInternetProtocolClassFactory.OnGetDocumentByUrl:=InternetProtocolGetDocumentByUrl;}
end;

procedure TBisMdiMainForm.CreateWnd;
begin
  inherited CreateWnd;
  ShowMDIClientEdge(ClientHandle,not FContentExists);
end;

destructor TBisMdiMainForm.Destroy;
begin
{  BisInternetProtocolClassFactory.OnGetDocumentByUrl:=nil;
  UnRegisterNameSpace('bis-main');}

  Core.ProgressEvents.Remove(FProgressEvent);
  Core.AfterLoginEvents.Remove(FAfterLoginEvent);
  Core.ContentEvents.Remove(FRefreshMenuEvent);
  FButtonGroup.Free;
  FMenus.Free;
  inherited Destroy;
end;

{procedure TBisMdiMainForm.InternetProtocolGetDocumentByUrl(const Url: string; Stream: TMemoryStream; var Found: Boolean);
begin
  ShowInfo(Url);
end;}

procedure TBisMdiMainForm.CMDialogKey(var Message: TCMDialogKey);
begin
  if Message.CharCode=VK_ESCAPE then begin
    FInterrupted:=true;
    Application.ProcessMessages;
  end;
end;

procedure TBisMdiMainForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Hide;
end;

procedure TBisMdiMainForm.Init;
begin
  inherited Init;
  RefreshMenus;
  ActionMainMenuBar.WindowMenu:='';
  ActionMainMenuBar.WindowMenu:=FSActionBarWindowMenu;
  Enabled:=true;
end;

procedure TBisMdiMainForm.SetConnectionCaption;
begin
  StatusBar.Panels[2].Text:='';
  if Core.Logged then
    StatusBar.Panels[2].Text:=Core.Connection.Caption;
end;

procedure TBisMdiMainForm.SetAccountUserName;
var
  S: String;
  S1,S2: String;
begin
  Caption:=FirstCaption;
  StatusBar.Panels[3].Text:='';
  if Core.Logged then begin
    S1:=Core.AccountUserName;
    S2:=VarToStrDef(Core.FirmSmallName,'');
    if Trim(S2)<>'' then
      S:=FormatEx('%s [%s]',[S1,S2])
    else
      S:=S1;  
    StatusBar.Panels[3].Text:=S;
    Caption:=FormatEx(FSFormatCaption,[FirstCaption,S]);
  end;
end;

procedure TBisMdiMainForm.StatusBarResize(Sender: TObject);
begin
  RePositionProgressBars;
end;

procedure TBisMdiMainForm.ActionFileExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TBisMdiMainForm.ActionMainMenuBarDockOver(Sender: TObject;
  Source: TDragDockObject; X, Y: Integer; State: TDragState;
  var Accept: Boolean);
begin
  Accept:=false;
end;

procedure TBisMdiMainForm.ActionWindowsCascadeExecute(Sender: TObject);
begin
  Cascade;
end;

procedure TBisMdiMainForm.ActionWindowsCloseAllExecute(Sender: TObject);

  function InMDIChildren(Form: TCustomForm): Boolean;
  var
    i: Integer;
    FormCurrent: TCustomForm;
  begin
    Result:=false;
    for i:=MDIChildCount-1 downto 0 do begin
      FormCurrent:=MDIChildren[i];
      if FormCurrent=Form then begin
        Result:=true;
        exit;
      end;
    end;
  end;

var
  i: Integer;
  Form: TCustomForm;
  List: Tlist;
begin
  List:=TList.Create;
  try
    for i:=MDIChildCount-1 downto 0 do begin
      Form:=MDIChildren[i];
      List.Add(Form);
    end;
    for i:=List.Count-1 downto 0 do begin
      Form:=List.Items[i];
      if InMDIChildren(Form) then
        Form.Close;
    end;
  finally
    List.Free;
  end;
end;

procedure TBisMdiMainForm.ActionWindowsCloseAllUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled:=MDIChildCount>0;
end;

procedure TBisMdiMainForm.ActionWindowsHorizontalExecute(Sender: TObject);
begin
  TileMode:=tbHorizontal;
  Tile;
end;

procedure TBisMdiMainForm.ActionWindowsVerticalExecute(Sender: TObject);
begin
  TileMode:=tbVertical;
  Tile;
end;

procedure TBisMdiMainForm.ApplicationEventsHint(Sender: TObject);
begin
  StatusBar.Panels[1].Text:=Application.Hint;
end;

procedure TBisMdiMainForm.ButtonInterruptClick(Sender: TObject);
begin
  FInterrupted:=true;
end;

procedure TBisMdiMainForm.ButtonInterruptMouseEnter(Sender: TObject);
begin
  FOldCursor:=Screen.Cursor;
  Screen.Cursor:=crDefault;
end;

procedure TBisMdiMainForm.ButtonInterruptMouseLeave(Sender: TObject);
begin
  Screen.Cursor:=FOldCursor;
end;

procedure TBisMdiMainForm.RePositionProgressBars;
begin
  PanelProgress.Left:=0;
  PanelProgress.Width:=StatusBar.Panels.Items[0].Width;
  PanelProgress.Top:=1;
  PanelProgress.Height:=StatusBar.Height;
end;

procedure TBisMdiMainForm.InternalProgress(const Min, Max, Position: Integer; var Interrupted: Boolean);
var
  Delta: Integer;
  m: integer;
begin
  if Min=Position then
    FInterrupted:=false;
  Interrupted:=(not Interrupted and FInterrupted) or Interrupted;
  PanelProgress.Visible:=not Interrupted and (Position>0) and (Position<Max) and ((Max-Min)>=1000);
  if PanelProgress.Visible then begin
    RePositionProgressBars;
    Delta:=Max div 50;
    if Delta>0 then begin
      M:=Position mod Delta;
      if M=0 then begin
        ProgressBar.Min:=Min;
        ProgressBar.Max:=Max;
        ProgressBar.Position:=Position;
        ProgressBar.Update;
        Application.ProcessMessages;
      end;
    end;
  end else
    Screen.Cursor:=FOldCursor;
end;

procedure TBisMdiMainForm.InternalRefreshMenus(Sender: TObject);
begin
  RefreshMenus;
end;

procedure TBisMdiMainForm.InternalAfterLogin(Sender: TObject);
begin
  SetConnectionCaption;
  SetAccountUserName;
end;

procedure TBisMdiMainForm.LoadLogo;
var
  Stream: TMemoryStream;
begin
  Stream:=TMemoryStream.Create;
  try
    FLogoExists:=false;
    if Core.LocalBase.ReadParam(SParamLogo,Stream) then begin
      Stream.Position:=0;
      TBisPicture(ImageLogo.Picture).LoadFromStream(Stream);
      FLogoExists:=not TBisPicture(ImageLogo.Picture).Empty;
    end;
  finally
    Stream.Free;
  end;
end;

procedure TBisMdiMainForm.LoadContent;
var
  S: String;
  Doc: IHTMLDocument2;
  V: Variant;
begin
  S:='';
  try
    FContentExists:=false;
    WebBrowser.Navigate('about:blank');
    Doc:=WebBrowser.Document as IHtmlDocument2;
    if Assigned(Doc) and Core.LocalBase.ReadParam(SParamContent,S) then begin
      if Length(S)>0 then begin
        V:=VarArrayCreate([0,0],varVariant);
        V[0]:=S;
        Doc.write(PSafeArray(TVarData(V).VArray));
        FContentExists:=true;
      end;
    end;
  finally
  end;
end;

procedure TBisMdiMainForm.RefreshMenus;
begin
  FInterrupted:=false;
  if FAutoMenu and Assigned(ActionMainMenuBar) and Assigned(ActionMainMenuBar.ActionManager) then begin
    if Assigned(ActionMainMenuBar.ActionClient) then begin
      ImageListMenu.Clear;
      FMenus.Refresh(ActionMainMenuBar.ActionManager,ActionMainMenuBar.ActionClient.Items);
      ActionMainMenuBar.CreateControls;
    end;
  end;
end;

function TBisMdiMainForm.FindItemByCaption(ParentItems: TActionClients; ACaption: String): TActionClientItem;
var
  i: Integer;
  Item: TActionClientItem;
begin
  Result:=nil;
  if Trim(ACaption)<>SMenuDelim then
    for i:=0 to ParentItems.Count-1 do begin
      Item:=ParentItems[i];
      if AnsiSameText(Item.Caption,ACaption) and
         not Assigned(Item.Action) then begin
        Result:=Item;
        exit;
      end;
    end;
end;

procedure TBisMdiMainForm.SetLogoPosition(Visible: Boolean);
var
  PWI: TWindowInfo;
begin
  GetWindowInfo(ClientHandle,PWI);
  PanelLogo.Anchors:=[];
  if Visible then begin
    PanelLogo.Left:=PWI.rcWindow.Right-PWI.rcWindow.Left-10;
    PanelLogo.Top:=PWI.rcWindow.Bottom-PWI.rcWindow.Top-50;
    PanelLogo.Anchors:=[akRight,akBottom];
    PanelLogo.Visible:=true;
  end else begin
    PanelLogo.Visible:=false;
    PanelLogo.Anchors:=[akLeft,akTop];
    PanelLogo.Top:=50;
  end;
end;

procedure TBisMdiMainForm.SetContentPosition(Visible: Boolean);
var
  PWI: TWindowInfo;
begin
  GetWindowInfo(ClientHandle,PWI);
  if Visible then begin
    PanelContent.Left:=0;
    PanelContent.Top:=0;
    PanelContent.Width:=PWI.rcWindow.Right-PWI.rcWindow.Left;
    PanelContent.Height:=PWI.rcWindow.Bottom-PWI.rcWindow.Top;
    PanelContent.Visible:=true;
//    PanelContent.SendToBack;
  end else begin
    PanelContent.Visible:=false;
  end;

end;

procedure TBisMdiMainForm.FormResize(Sender: TObject);
begin
  if FContentExists then begin
    SetContentPosition(false);
    SetContentPosition(true);
  end else begin
    if FLogoExists then begin
      SetLogoPosition(false);
      SetLogoPosition(true);
    end;
  end;
end;

procedure TBisMdiMainForm.ImageLogoClick(Sender: TObject);
var
  Buffer: String;
begin
  Buffer:='';
  if Core.LocalBase.ReadParam(SParamSite,Buffer) then begin
    ShellExecute(0,'open',PChar(Buffer),nil,nil,SW_SHOW);
  end;
end;


end.