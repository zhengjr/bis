unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, GWXLib_TLB, StdCtrls, ComCtrls, ExtCtrls,
  TreeViewForm, ObjStatus, ComObj, Menus, SelectMap, IniFiles, StrUtils,
  ToolWin, ContextSrch, ImgList, ShellApi, XPMan, Contnrs, ActnPopup ;

type
  TMapForm = class(TForm)
    GWControl: TGWControl;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Add1: TMenuItem;
    N1: TMenuItem;
    Clear1: TMenuItem;
    Unload1: TMenuItem;
    N2: TMenuItem;
    Exit1: TMenuItem;
    Map1: TMenuItem;
    Viewcodifier1: TMenuItem;
    Objectvisibility1: TMenuItem;
    StatusBar: TStatusBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    N3: TMenuItem;
    Contextsearch1: TMenuItem;
    Addresssearch1: TMenuItem;
    ToolbarImagelist: TImageList;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    GetInfoByRect1: TMenuItem;
    LoadedmapsandDBs1: TMenuItem;
    View1: TMenuItem;
    Notooltips1: TMenuItem;
    Shorttooltips1: TMenuItem;
    Detailedtooltips1: TMenuItem;
    N4: TMenuItem;
    Merkatorprojection1: TMenuItem;
    Merkatorseamless1: TMenuItem;
    Conicprojection1: TMenuItem;
    Sphericalprojection1: TMenuItem;
    N5: TMenuItem;
    Smoothdrawing1: TMenuItem;
    Coordinategrid1: TMenuItem;
    Quickredraw1: TMenuItem;
    Clientedge1: TMenuItem;
    Scrollbarks1: TMenuItem;
    Overview1: TMenuItem;
    Zoomin1: TMenuItem;
    Zoomout1: TMenuItem;
    N6: TMenuItem;
    Databases1: TMenuItem;
    Loaddatabase1: TMenuItem;
    Loadtable1: TMenuItem;
    N7: TMenuItem;
    Unload2: TMenuItem;
    UnloadallDBsandtables1: TMenuItem;
    GetinfoPolygon1: TMenuItem;
    N8: TMenuItem;
    measure1: TMenuItem;
    Routes1: TMenuItem;
    N9: TMenuItem;
    Createbitmapfile1: TMenuItem;
    None1: TMenuItem;
    N101: TMenuItem;
    N11: TMenuItem;
    N51: TMenuItem;
    N21: TMenuItem;
    N301: TMenuItem;
    N102: TMenuItem;
    N52: TMenuItem;
    N22: TMenuItem;
    N12: TMenuItem;
    N302: TMenuItem;
    N103: TMenuItem;
    Variable1: TMenuItem;
    N10: TMenuItem;
    Definepolyline1: TMenuItem;
    GetinfoPolygon0: TMenuItem;
    Clearpolygon1: TMenuItem;
    ToolButton11: TToolButton;
    LeftButtonType: TComboBox;
    ToolButton12: TToolButton;
    RightButtonType: TComboBox;
    MapStyle1: TMenuItem;
    N13: TMenuItem;
    none2: TMenuItem;
    none3: TMenuItem;
    Openfile1: TMenuItem;
    OpenDialog: TOpenDialog;
    XPManifest1: TXPManifest;
    est1: TMenuItem;
    Addfile1: TMenuItem;
    N14: TMenuItem;
    RasterOpenDialog: TOpenDialog;
    DesignOpenDialog: TOpenDialog;
    Addraster1: TMenuItem;
    Adddesign1: TMenuItem;
    ToolButtonExportToDbf: TToolButton;
    SaveDialog: TSaveDialog;
    PanelProgress: TPanel;
    ButtonProgressBreak: TButton;
    Panel1: TPanel;
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    ToolBar2: TToolBar;
    Panel2: TPanel;
    Label1: TLabel;
    EditLatFrom: TEdit;
    EditLonFrom: TEdit;
    EditLonTo: TEdit;
    Label2: TLabel;
    EditLatTo: TEdit;
    ButtonCalc: TButton;
    Panel3: TPanel;
    Button2: TButton;
    Button4: TButton;
    Button1: TButton;
    LabelCount: TLabel;
    LabelX: TLabel;
    LabelY: TLabel;
    ListView: TListView;
    Splitter1: TSplitter;
    PopupActionBar: TPopupActionBar;
    Clear2: TMenuItem;
    AddressFrom1: TMenuItem;
    AddressTo1: TMenuItem;
    N15: TMenuItem;
    LabelDistance: TLabel;
    EditStep: TEdit;
    UpDownStep: TUpDown;
    CheckBoxScanAll: TCheckBox;
    save1: TMenuItem;
    LabelDistance2: TLabel;
    CheckBoxDraw: TCheckBox;
    SaveDialogPoints: TSaveDialog;
    procedure Exit1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Add1Click(Sender: TObject);
    procedure Unload1Click(Sender: TObject);
    procedure Viewcodifier1Click(Sender: TObject);
    procedure Objectvisibility1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure GWControlMouseAction(ASender: TObject; Action: TOleEnum;
      uMsg, x, y: Integer; out bHandled: Integer);
    procedure Contextsearch1Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure Addresssearch1Click(Sender: TObject);
    procedure GetInfoByRect1Click(Sender: TObject);
    procedure GWControlSelect(ASender: TObject; South, West, North,
      East: Double);
    procedure LoadedmapsandDBs1Click(Sender: TObject);
    procedure Loadtable1Click(Sender: TObject);
    procedure Overview1Click(Sender: TObject);
    procedure Zoomin1Click(Sender: TObject);
    procedure Zoomout1Click(Sender: TObject);
    procedure Notooltips1Click(Sender: TObject);
    procedure Shorttooltips1Click(Sender: TObject);
    procedure Detailedtooltips1Click(Sender: TObject);
    procedure Merkatorprojection1Click(Sender: TObject);
    procedure Merkatorseamless1Click(Sender: TObject);
    procedure Conicprojection1Click(Sender: TObject);
    procedure Sphericalprojection1Click(Sender: TObject);
    procedure Smoothdrawing1Click(Sender: TObject);
    procedure Quickredraw1Click(Sender: TObject);
    procedure Clientedge1Click(Sender: TObject);
    procedure Scrollbarks1Click(Sender: TObject);
    procedure None1Click(Sender: TObject);
    procedure N101Click(Sender: TObject);
    procedure N51Click(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N301Click(Sender: TObject);
    procedure N102Click(Sender: TObject);
    procedure N52Click(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N302Click(Sender: TObject);
    procedure N103Click(Sender: TObject);
    procedure Variable1Click(Sender: TObject);
    procedure GWControlDrawCoordGrid(ASender: TObject; var DeltaLat,
      DeltaLon, LineColor, ZOrder: Integer);
    procedure GWControlSelfDraw(ASender: TObject; hDC, left, top, right,
      bottom: Integer);
    procedure Definepolyline1Click(Sender: TObject);
    procedure GetinfobyPolygon1Click(Sender: TObject);
    procedure Clearpolygon1Click(Sender: TObject);
    procedure Createbitmapfile1Click(Sender: TObject);
    procedure LeftButtonTypeChange(Sender: TObject);
    procedure RightButtonTypeChange(Sender: TObject);
    procedure measure1Click(Sender: TObject);
    procedure Routes1Click(Sender: TObject);
    procedure Loaddatabase1Click(Sender: TObject);
    procedure UnloadallDBsandtables1Click(Sender: TObject);
    procedure Openfile1Click(Sender: TObject);
    procedure ToolButton8Click(Sender: TObject);
    procedure Addfile1Click(Sender: TObject);
    procedure Addraster1Click(Sender: TObject);
    procedure Adddesign1Click(Sender: TObject);
    procedure ToolButtonExportToDbfClick(Sender: TObject);
    procedure ButtonProgressBreakClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ButtonCalcClick(Sender: TObject);
    procedure Clear2Click(Sender: TObject);
    procedure AddressFrom1Click(Sender: TObject);
    procedure AddressTo1Click(Sender: TObject);
    procedure ListViewDblClick(Sender: TObject);
    procedure save1Click(Sender: TObject);
  private
    { Private declarations }
    Ini: TIniFile;
    mapNames, mapFiles: TStringList;
    leftMouseType, rightMouseType: integer;
    mouseTypeSaved: boolean;
    makingPolyline: integer;
    polyline: array of double;
    tool: integer; // 0-nothing, 1-measure, 2-route
    toolpoints: array of double;
    pGWRoute: IGWRoute;
    pTable   :IGWTable;
    trackedIx :integer;

    FBreaked: Boolean;

    function IsLoaded(m: string): boolean;
    procedure OnMapChanged;
    procedure EndMakePolyline;
    procedure BeginMakePolyline(mode: integer; msg: string);
    procedure SaveMouseTypes;
    procedure RestoreMouseTypes;
    procedure UpdateTooltipsState;
    procedure UpdateProjections;
    procedure AddPolylinePoint(x,y : integer);
    procedure DrawPolyline(dc: HDC);
    procedure UpdateMouseTypes;
    procedure BeginMeasure;
    procedure EndMeasure;
    procedure BeginRoute;
    procedure EndRoute;
    procedure OnMeasurePointsChanged;
    procedure OnRoutePointsChanged;
    procedure ShowRouteResult(res: integer);
    procedure UpdateMenuProc(var Message: TMessage); message WM_INITMENU;
    procedure LookupItemClick(Sender: TObject);
    procedure UnloadItemClick(Sender: TObject);
    procedure RouteAddPointCoord(lat, lon: double);

    procedure ZeroL;
    procedure ZeroT;
    procedure ZeroLT;
    function MapScrollR(var dX: Integer): Boolean;
    function MapScrollB(var dY: Integer): Boolean;
    procedure ScanAdress(List1,List2: TStringList; XStart,YStart: Integer);
  public
    { Public declarations }
  end;

var
  MapForm: TMapForm;

implementation

uses ObjList, MapList, RouteParams, BmpOpt, DbSelect, DbErrors,
  PrepareTable,
  DB, FlatSB;

{$R *.dfm}

procedure TMapForm.Exit1Click(Sender: TObject);
begin
// exit
Close;
end;

procedure TMapForm.Clear1Click(Sender: TObject);
begin
// clear
 GWControl.MapName := '';
 OnMapChanged;
end;

procedure TMapForm.Clear2Click(Sender: TObject);
begin
  ListView.Clear;
end;

procedure TMapForm.Open1Click(Sender: TObject);
var
  mname: string;
  i: integer;
begin
// file - open...
  SelectMapForm.ClearList;
  for i:=0 to mapNames.Count-1 do
    SelectMapForm.AddToList(mapNames[i], mapFiles[i]);
  SelectMapForm.Caption:='Select maps to load';
  if SelectMapForm.ShowModal<>mrOk then exit;

  with SelectMapForm do begin
    if SelectedItems.Count=0 then mname:=''
    else if SelectedItems.Count=1 then mname:=GWControl.getModulePath+SelectedItems[0]
    else begin
      mname:=GWControl.getModulePath;
      for i:=0 to SelectedItems.Count-1 do
        mname:=mname+';'+SelectedItems[i];
    end;
  end;

  Screen.Cursor:=crHourGlass;
  GWControl.MapName:=mname;
  Screen.Cursor:=crDefault;
  OnMapChanged;
  StatusBar.Panels[0].Text:='MapName='+GWControl.MapName;
end;

procedure TMapForm.FormCreate(Sender: TObject);
var
  i,p:  integer;
  line: string;
begin
  tool:=0;
  mouseTypeSaved:=false;
  makingPolyline:=0;
  Ini := TIniFile.Create( ChangeFileExt( Application.ExeName, '.INI' ) );
  mapNames:=TStringList.Create;
  mapFiles:=TStringList.Create;
  for i:=1 to 100 do begin
    line:=Ini.ReadString('maps', 'map'+IntToStr(i), '');
    if line='' then break;
    p:=pos('|', line);
    if p=0 then continue;
    mapNames.Add(LeftStr(line,p-1));
    mapFiles.Add(RightStr(line,Length(line)-p));
  end;
  UpdateTooltipsState;
  UpdateProjections;
  Clientedge1.Checked:=true;
  Scrollbarks1.Checked:=true;
  Quickredraw1.Checked:=true;
  None1.Checked:=true;
  UpdateMouseTypes;
  trackedIx:=-1;
end;

procedure TMapForm.FormDestroy(Sender: TObject);
begin
  ini.Free;
  mapNames.Free;
  mapFiles.Free;
end;

function GWXErrorToStr(res: TOleEnum):string;
begin
  case res of
  GWX_Ok:               result:='OK';
  GWX_AlreadyLoaded:    result:='Already loaded';
  GWX_MapFileMissing:   result:='Map file missing';
  GWX_InvalidMapFile:   result:='Invalid map file';
  GWX_UnknownFormat:    result:='Unknown format';
  GWX_SystemError:      result:='System error';
  GWX_CodifierMissing:  result:='Codifier file not found';
  GWX_LookupMissing:    result:='Lookup file not found';
  GWX_HaspNotInstalled: result:='HASP driver is not installed';
  GWX_HaspNotFound:     result:='HASP device not found';
  GWX_LicenceMissing:   result:='Access denied to this map';
  GWX_MapNotLoaded:     result:='Map not loaded';
  GWX_BadLoadCmd:       result:='Bad load command';
  GWX_BadStyle:         result:='Bad style';
  GWX_NotTableObject:   result:='Invalid table object';
  GWX_TableNotLoaded:   result:='No records loaded';
  GWX_ObjectsNotFound:  result:='Corresponding objects are not found';
  GWX_BaseNotLoaded:    result:='Specified base map is not loaded';

  GWX_BadLoadStructure: result:='Invalid load structure';
  GWX_BadLoadField :    result:='Specified field not found';
  GWX_LoadModeTwice:    result:='Load type specified twice';
  GWX_LoadTableAndStruct: result:='Structure specified with table';
  GWX_FrameFileMissing:    result:='Frame file not found';
  GWX_RasterLoadError:    result:='Failed to load raster';
  GWX_DesignLoadError:    result:='Failed to load design';
  end;
end;

procedure TMapForm.Add1Click(Sender: TObject);
var
  mname, status: string;
  i: integer;
  res: TOleEnum;
begin
// file - open...
  SelectMapForm.ClearList;
  for i:=0 to mapNames.Count-1 do
    if not IsLoaded(mapFiles[i]) then
      SelectMapForm.AddToList(mapNames[i], mapFiles[i]);
   SelectMapForm.Caption:='Select maps to add';
  if SelectMapForm.ShowModal<>mrOk then exit;

  Screen.Cursor:=crHourGlass;
  status:='Added maps: ';
  for i:=0 to SelectMapForm.SelectedItems.Count-1 do begin
    mname:=SelectMapForm.SelectedItems[i];
    res:=GWControl.AddMap(GWControl.getModulePath+mname, '');
    if i<>0 then status:=status+', ';
    status:=status+ExtractFileName(mname)+' - '+GWXErrorToStr(res);
  end;
  StatusBar.Panels[0].Text:=status;
  OnMapChanged;
  Screen.Cursor:=crDefault;
end;

function TMapForm.IsLoaded(m: string): boolean;
var
  tbl:IGWTable;
  p: integer;
begin
  result:=false;
  m:=ExtractFileName(m);
  tbl:=GWControl.LoadedMaps as IGWTable;
  p:=tbl.MoveFirst;
  while p>=0 do begin
    if CompareText(m, tbl.getText(0))=0 then begin
      result:=true;
      break;
    end;
    p:=tbl.MoveNext;
  end;
end;


procedure TMapForm.Unload1Click(Sender: TObject);
var
  i,p: integer;
  tbl:IGWTable;
begin
// file - open...
  SelectMapForm.ClearList;
  tbl:=GWControl.LoadedMaps as IGWTable;
  p:=tbl.MoveFirst;
  while p>=0 do begin
    SelectMapForm.AddToList(tbl.getText(1), tbl.getText(0));
    p:=tbl.MoveNext;
  end;
  SelectMapForm.Caption:='Select maps to remove';
  if SelectMapForm.ShowModal<>mrOk then exit;

  for i:=0 to SelectMapForm.SelectedItems.Count-1 do
    GWControl.RemoveMap(SelectMapForm.SelectedItems[i]);
  OnMapChanged;
end;

procedure TMapForm.OnMapChanged;
var
  cap: string;
  p: integer;
  tbl:IGWTable;
begin
  cap:='Ingit GWX Demo';
  tbl:=GWControl.LoadedMaps as IGWTable;
  p:=tbl.MoveFirst;
  while p>=0 do begin
    if p=0 then cap:=cap+' - ' else cap:=cap+', ';
    cap:=cap+tbl.getText(1);
    p:=tbl.MoveNext;
  end;
  Caption:=cap;
  UpdateProjections;
//  UpdateTooltipsState;
  if tool=1 then EndMeasure
  else if tool=2 then EndRoute;
end;

procedure TMapForm.Viewcodifier1Click(Sender: TObject);
begin
   TreeForm.ShowTable(GWControl);
end;

procedure TMapForm.Objectvisibility1Click(Sender: TObject);
begin
  ObjStatusForm.UpdateObjects(GWControl, true);
end;

procedure TMapForm.FormResize(Sender: TObject);
begin
  StatusBar.Panels[0].Width:=ClientWidth-320;
end;

procedure GetStringsByString(const S,Delim: String; Strings: TStrings);
var
  Apos: Integer;
  S1,S2: String;
begin
  if Assigned(Strings) then begin
    Apos:=-1;
    S2:=S;
    while Apos<>0 do begin
      Apos:=AnsiPos(Delim,S2);
      if Apos>0 then begin
        S1:=Copy(S2,1,Apos-Length(Delim));
        S2:=Copy(S2,Apos+Length(Delim),Length(S2));
        if S1<>'' then
          Strings.AddObject(S1,TObject(Apos))
        else begin
          if Length(S2)>0 then
            APos:=-1;
        end;
      end else
        Strings.AddObject(S2,TObject(Apos));
    end;
  end;
end;

procedure GetAddress(S: String; var Locality, StreetPrefix, Street, House: String);
var
  Str: TStringList;
  Temp: TStringList;
  S0, S1, S2: String;
  i: Integer;
begin
  Str:=TStringList.Create;
  Temp:=TStringList.Create;
  try
    GetStringsByString(S,',',Str);
    if Str.Count>0 then begin

      S0:=Trim(Str[0]);
      GetStringsByString(S0,' ',Temp);
      if Temp.Count>0 then begin
        if Temp.Count>1 then begin
          StreetPrefix:=Trim(Temp[Temp.Count-1]);
          Street:=Trim(Temp[0]);
          for i:=1 to Temp.Count-2 do begin
            Street:=Street+' '+Trim(Temp[i]);
          end;
        end else
          Street:=Trim(Temp[0]);
      end;

      if Str.Count>1 then begin
        S1:=Trim(Str[1]);
        Temp.Clear;
        GetStringsByString(S1,' ',Temp);
        if Temp.Count>1 then begin
          House:=Trim(Temp[1]);
          if Temp.Count>3 then
            House:=House+'/'+Trim(Temp[3]);
        end;
      end;

      if Str.Count>2 then begin
        S2:=Trim(Str[2]);
        Locality:=S2;
      end;

    end;
  finally
    Temp.Free;
    Str.Free;
  end;
end;

procedure TMapForm.GWControlMouseAction(ASender: TObject; Action: TOleEnum;
  uMsg, x, y: Integer; out bHandled: Integer);
var
  lat,lon: double;
  fs: TFormatSettings;
  scl: double;
  cnt, j, ix: integer;
  mt: string;

  function CoordToStr(deg: double; isLat: boolean): string;
  var
    n: integer;
    function ModI2Str(var i: integer; divider: integer): string;
    begin
      result:=IntToStr(i mod divider);
      if Length(result)=1 then result:='0'+result;
      i:=i div divider;
    end;
  begin
    if deg<0 then begin deg:=-deg; if isLat then result:='S' else result:='W'; end
    else if isLat then result:='N' else result:='E';
    n:=Round(deg*(60*60*100)); //  100ths of second
    result:=ModI2Str(n,100)+'"'+result; // adding 100ths
    result:=ModI2Str(n,60)+'.'+result; // adding seconds
    result:=ModI2Str(n,60)+''''+result; // adding minutes
    result:=IntToStr(n)+#176+result; // adding minutes
  end;

  function GetToolPointIndex(x,y: integer): integer;
  var
    cnt, i, x1, y1: integer;
  begin
    cnt:=Length(toolpoints);
    for i:=0 to cnt div 2 -1 do begin
      GWControl.Geo2Dev(toolpoints[i*2], toolpoints[i*2+1], x1, y1);
      x1:=x1-x; y1:=y1-y;
      if (x1*x1<=64) and (y1*y1<=64) then begin // remove point
        result:=i;
        exit;
      end;
    end;
    result:=-1;
  end;

var
  Item: TListItem;
  Street: String;
  StreetPrefix: String;
  House: String;
  Locality: String;
  L1: String;
  L2: String;
begin

  // show coordinates under cursor on status bar
  if Action=GWX_MouseMove then begin
    GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT	, fs);
    fs.DecimalSeparator:='.';
    GWControl.Dev2Geo(x,y,lat,lon);
//    StatusBar.Panels[1].Text:=#9+CoordToStr(lat, true)+'   '+CoordToStr(lon,false);
    StatusBar.Panels[1].Text:=#9+Format('%.6f: %d, %.6f: %d', [lat, x, lon, y]);
    scl:=GWControl.CurScale;
    StatusBar.Panels[2].Text:=Format(#9'Scale 1:%.0n',[scl]);
  end;

  // when making polyline - add point or finalize
  if makingPolyline<>0 then begin
    if Action=GWX_LButtonDown then AddPolylinePoint(x, y)
    else if Action=GWX_RButtonDown then EndMakePolyline;
    exit;
  end;

  // double-click
  if (Action=GWX_LButtonDblClk) then begin
    if tool=0 then begin
      GWControl.Dev2Geo(x,y,lat,lon);
      StatusBar.Panels[0].Text:=GWControl.FindNearestAddress(lat,lon);

      L1:=ReplaceStr(FloatToStr(Lat),',','.');
      L2:=ReplaceStr(FloatToStr(Lon),',','.');

      Street:='';
      StreetPrefix:='';
      House:='';
      Locality:='';
      GetAddress(StatusBar.Panels[0].Text,Locality,StreetPrefix,Street,House);

      Item:=ListView.Items.Add;
      Item.Caption:=Street;
      Item.SubItems.Add(StreetPrefix);
      Item.SubItems.Add(House);
      Item.SubItems.Add(Locality);
      Item.SubItems.Add(L1);
      Item.SubItems.Add(L2);
      ListView.Update;

    end
    else begin
      cnt:=Length(toolpoints);
      ix:=GetToolPointIndex(x,y);
      if ix<0 then begin
        SetLength(toolpoints, cnt+2);
        GWControl.Dev2Geo(x, y, toolpoints[cnt], toolpoints[cnt+1]);
      end
      else begin
        for j:=ix*2+2 to cnt-1 do toolpoints[j-2]:=toolpoints[j];
        SetLength(toolpoints, cnt-2);
      end;
      if tool=1 then OnMeasurePointsChanged
      else if tool=2 then OnRoutePointsChanged;
    end;
  end;

  // tracking route or measure point
  if tool<>0 then begin
    if (Action=GWX_LButtonDown) then begin
      trackedIx:=GetToolPointIndex(x,y);
      if trackedIx>=0 then bHandled:=1;
    end
    else if (Action=GWX_LButtonUp) and (trackedIx>=0) then begin
      trackedIx:=-1;
      if tool=1 then OnMeasurePointsChanged
      else OnRoutePointsChanged; // does not matter true or false
    end
    else if (Action=GWX_MouseMove) and (trackedIx>=0) then begin
      GWControl.Dev2Geo(x,y,lat,lon);
      toolpoints[trackedIx*2]:=lat;
      toolpoints[trackedIx*2+1]:=lon;
      mt:='update [';
      if tool=1 then mt:=mt+'measure'
      else           mt:=mt+'route points';
      mt:=mt+'] set metrics="P E '+
         FloatToStr(lon, fs)+' '+FloatToStr(lat, fs)+';'+'" where [ix]='+IntToStr(trackedIx);
      if tool=1 then mt:=mt+' and [objtype]=0';
      GWControl.ModifyTable(mt, 1);
    end;
  end;
end;

procedure TMapForm.RouteAddPointCoord(lat, lon: double);
var
  cnt: integer;
begin
  cnt:=Length(toolpoints);
  SetLength(toolpoints, cnt+2);
  toolpoints[cnt]:=lat;
  toolpoints[cnt+1]:=lon;
  OnRoutePointsChanged;
end;

procedure TMapForm.Contextsearch1Click(Sender: TObject);
begin
  ContextSearchForm.ShowSearch(GWControl, true);
end;

procedure TMapForm.Addresssearch1Click(Sender: TObject);
begin
  ContextSearchForm.ShowSearch(GWControl, false);
end;

procedure TMapForm.ToolButton1Click(Sender: TObject);
begin
  GWControl.Overview;
end;

procedure TMapForm.ToolButton2Click(Sender: TObject);
begin
  if GWControl.MapAttached=0 then exit;
  GWControl.CurScale:=GWControl.CurScale/1.5;
end;

procedure TMapForm.ToolButton3Click(Sender: TObject);
begin
  if GWControl.MapAttached=0 then exit;
  GWControl.CurScale:=GWControl.CurScale*1.5;
end;

procedure TMapForm.GetInfoByRect1Click(Sender: TObject);
begin
  if GWControl.MapAttached=0 then exit;
  EndMakePolyline;
  SaveMouseTypes;
  GWControl.mouseLeftType:=8;
  UpdateMouseTypes;
  StatusBar.Panels[0].Text:='Select a rectangle on the map by left mouse button';
end;


procedure TMapForm.EndMakePolyline;
begin
  RestoreMouseTypes;
  makingPolyline:=0;
  StatusBar.SimpleText:='';
  StatusBar.SimplePanel:=false;
  LeftButtonType.Enabled:=true;
  RightButtonType.Enabled:=true;
end;

procedure TMapForm.SaveMouseTypes;
begin
  if mouseTypeSaved then exit;
  leftMouseType:=GWControl.mouseLeftType;
  rightMouseType:=GWControl.mouseRightType;
  mouseTypeSaved:=true;
end;

procedure TMapForm.RestoreMouseTypes;
begin
  if not mouseTypeSaved then exit;
  GWControl.mouseLeftType:=leftMouseType;
  GWControl.mouseRightType:=rightMouseType;
  UpdateMouseTypes;
  mouseTypeSaved:=false;
end;

procedure TMapForm.GWControlSelect(ASender: TObject; South, West, North,
  East: Double);
var
  tbl: IGWTable;
  s,w,n,e: string;
begin
  RestoreMouseTypes;
  Str(South:8:6, s);
  Str(West :8:6, w);
  Str(North:8:6, n);
  Str(East :8:6, e);
  StatusBar.Panels[0].Text:='Selected rect: South='+s+' West='+w+' North='+n+' East='+e;
  tbl:=GWControl.GetInfoRect(South, West, North, East) as IGWTable;
  ObjListForm.ShowTable(tbl, GWControl);
end;

procedure TMapForm.LoadedmapsandDBs1Click(Sender: TObject);
begin
  MapListForm.ShowList(GWControl);
end;

procedure TMapForm.Loadtable1Click(Sender: TObject);
var
 tbl: IGWTable;
 loadcmd, style: string;
 res: TOleEnum;
begin
  if GWControl.MapAttached=0 then begin
    StatusBar.Panels[0].Text:='No maps loaded';
    Beep;
    exit;
  end;
  tbl:=PrepareTableForm.PrepareGWTable(GWControl, loadcmd, style);
  if tbl=nil then exit;

  res:=GWControl.Table2Map(loadcmd, style, tbl);
  StatusBar.Panels[0].Text:='Result of loading table: '+GWXErrorToStr(res);
end;

procedure TMapForm.Overview1Click(Sender: TObject);
begin
  GWControl.Overview;
end;

procedure TMapForm.Zoomin1Click(Sender: TObject);
begin
  if GWControl.MapAttached=0 then exit;
  GWControl.CurScale:=GWControl.CurScale/1.5;
end;

procedure TMapForm.Zoomout1Click(Sender: TObject);
begin
  if GWControl.MapAttached=0 then exit;
  GWControl.CurScale:=GWControl.CurScale*1.5;
end;

procedure TMapForm.UpdateTooltipsState;
var
 it: integer;
begin
  it:=GWControl.InfoTooltip;
  Notooltips1.Checked:=it=0;
  Shorttooltips1.Checked:=it=1;
  Detailedtooltips1.Checked:=it=2;
end;

procedure TMapForm.Notooltips1Click(Sender: TObject);
begin
  GWControl.InfoTooltip:=0;
  UpdateTooltipsState;
end;

procedure TMapForm.Shorttooltips1Click(Sender: TObject);
begin
  GWControl.InfoTooltip:=1;
  UpdateTooltipsState;
end;

procedure TMapForm.Detailedtooltips1Click(Sender: TObject);
begin
  GWControl.InfoTooltip:=2;
  UpdateTooltipsState;
end;

procedure TMapForm.UpdateProjections;
var
  p: TOleEnum;
begin
  p:=GWControl.Projection;
  Merkatorprojection1.Checked:=p=GWX_Projection_Merkator;
  Merkatorseamless1.Checked:=p=GWX_Projection_MerkatorSeamless;
  Conicprojection1.Checked:=p=GWX_Projection_Conical;
  Sphericalprojection1.Checked:=p=GWX_Projection_Spherical;
end;


procedure TMapForm.Merkatorprojection1Click(Sender: TObject);
begin
  GWControl.Projection:=GWX_Projection_Merkator;
  UpdateProjections;
end;

procedure TMapForm.Merkatorseamless1Click(Sender: TObject);
begin
  GWControl.Projection:=GWX_Projection_MerkatorSeamless;
  UpdateProjections;
end;

procedure TMapForm.Conicprojection1Click(Sender: TObject);
begin
  GWControl.Projection:=GWX_Projection_Conical;
  UpdateProjections;
end;

procedure TMapForm.Sphericalprojection1Click(Sender: TObject);
begin
  GWControl.Projection:=GWX_Projection_Spherical;
  UpdateProjections;
end;

procedure TMapForm.Smoothdrawing1Click(Sender: TObject);
begin
  GWControl.SmoothDrawing:=GWControl.SmoothDrawing xor 1;
  Smoothdrawing1.Checked:=GWControl.SmoothDrawing=1;
end;

procedure TMapForm.Quickredraw1Click(Sender: TObject);
begin
  GWControl.QuickRedraw:=GWControl.QuickRedraw xor 1;
  Quickredraw1.Checked:=GWControl.QuickRedraw=1;
end;

procedure TMapForm.Clientedge1Click(Sender: TObject);
begin
  GWControl.ClientEdge:=GWControl.ClientEdge xor 1;
  Clientedge1.Checked:=GWControl.ClientEdge=1;
end;

procedure TMapForm.Scrollbarks1Click(Sender: TObject);
begin
  GWControl.ScrollBars:=GWControl.ScrollBars xor 1;
  Scrollbarks1.Checked:=GWControl.ScrollBars=1;
end;

procedure TMapForm.None1Click(Sender: TObject);
begin
  GWControl.CoordGrid:=0;
  None1.Checked:=true;
end;

procedure TMapForm.N101Click(Sender: TObject);
begin // 10d
  GWControl.CoordGrid:=10*60*60;
  N101.Checked:=true;
end;

procedure TMapForm.N51Click(Sender: TObject);
begin // 5d
  GWControl.CoordGrid:=5*60*60;
  N51.Checked:=true;
end;

procedure TMapForm.N21Click(Sender: TObject);
begin // 2d
  GWControl.CoordGrid:=2*60*60;
  N21.Checked:=true;
end;

procedure TMapForm.N11Click(Sender: TObject);
begin //1d
  GWControl.CoordGrid:=60*60;
  N11.Checked:=true;
end;

procedure TMapForm.N301Click(Sender: TObject);
begin // 30'
  GWControl.CoordGrid:=30*60;
  N301.Checked:=true;
end;

procedure TMapForm.N102Click(Sender: TObject);
begin // 10'
  GWControl.CoordGrid:=10*60;
  N102.Checked:=true;
end;

procedure TMapForm.N52Click(Sender: TObject);
begin // 5'
  GWControl.CoordGrid:=5*60;
  N52.Checked:=true;
end;

procedure TMapForm.N22Click(Sender: TObject);
begin // 2'
  GWControl.CoordGrid:=2*60;
  N22.Checked:=true;
end;

procedure TMapForm.N12Click(Sender: TObject);
begin // 1'
  GWControl.CoordGrid:=60;
  N12.Checked:=true;
end;

procedure TMapForm.N302Click(Sender: TObject);
begin // 30"
  GWControl.CoordGrid:=30;
  N302.Checked:=true;
end;

procedure TMapForm.N103Click(Sender: TObject);
begin // 10"
  GWControl.CoordGrid:=10;
  N103.Checked:=true;
end;

procedure TMapForm.Variable1Click(Sender: TObject);
begin
  GWControl.CoordGrid:=-1;
  Variable1.Checked:=true;
end;

{
// when GWControl.CoordGrid=-1
  DeltaLat:=60*60*20;
  DeltaLon:=60*60*20;
  LineColor:=RGB(128,128,128);
}
procedure TMapForm.GWControlDrawCoordGrid(ASender: TObject; var DeltaLat,
  DeltaLon, LineColor, ZOrder: Integer);
var
  sc, Lat, Lon, dLat, dLon: double;
  function MakeDelta(d: double): integer;
  begin
    result:=round(d);
    if result<2 then result:=1
    else if result<5 then result:=2
    else if result<10 then result:=5
    else if result<15 then result:=10
    else if result<30 then result:=15
    else if result<60 then result:=30
    else if result<2*60 then result:=60
    else if result<5*60 then result:=2*60
    else if result<10*60 then result:=5*60
    else if result<15*60 then result:=10*60
    else if result<30*60 then result:=15*60
    else if result<60*60 then result:=30*60
    else if result<2*60*60 then result:=60*60
    else if result<5*60*60 then result:=2*60*60
    else result:=5*60*60;
  end;
begin
// when GWControl.CoordGrid=-1
  sc:=GWControl.CurScale;
  if(sc>10000000) then begin
    DeltaLat:=60*60*20; // 20�
    DeltaLon:=60*60*20;
  end
  else if(sc>5000000) then begin
    DeltaLat:=60*60*10; // 10�
    DeltaLon:=60*60*10;
  end
  else begin
    GWControl.GetGeoCenter(Lat,Lon);
    dLat:=sc*(60*60*5/5000000);
    dLon:=dLat/cos(Lat*Pi/180);
    DeltaLat:=MakeDelta(dLat); // 10�
    DeltaLon:=MakeDelta(dLon);
  end;
  LineColor:=RGB(128,128,128);
end;

procedure TMapForm.BeginMakePolyline(mode: integer; msg: string);
begin
  makingPolyline:=mode;
  StatusBar.SimplePanel:=true;
  StatusBar.SimpleText:=msg;
  LeftButtonType.Enabled:=false;
  RightButtonType.Enabled:=false;
end;

procedure TMapForm.AddPolylinePoint(x,y : integer);
var
  cnt: integer;
begin
  cnt:=Length(polyline);
  SetLength(polyline, cnt+2);
  GWControl.Dev2Geo(x, y, polyline[cnt], polyline[cnt+1]);
  DrawPolyline(0);
end;


procedure TMapForm.DrawPolyline(dc: HDC);
var
  cdc: HDC;
  pen, oldpen: HPEN;
  x,y: integer;
  len,i: integer;
begin
  len:=Length(polyline) div 2;
  if len=0 then exit;

  if dc=0 then cdc:=GetDC(GWControl.Handle)
  else cdc:=dc;

  pen:=CreatePen(PS_SOLID,3,clBlue);
  oldpen:=SelectObject(cdc,pen);

  GWControl.Geo2Dev(polyline[0], polyline[1], x, y);
  Ellipse(cdc, x-2, y-2, x+2, y+2);
  MoveToEx(cdc, x, y, nil);

  for i:=1 To len-1 do begin
    GWControl.Geo2Dev(polyline[i*2], polyline[i*2+1], x, y);
    LineTo(cdc,x,y);
  end;

  SelectObject(cdc,oldpen);
  DeleteObject(pen);
  if dc=0 then ReleaseDC(GWControl.Handle, cdc);
end;


procedure TMapForm.GWControlSelfDraw(ASender: TObject; hDC, left, top,
  right, bottom: Integer);
begin
  DrawPolyline(hDC);
end;

procedure TMapForm.Definepolyline1Click(Sender: TObject);
begin
  if GWControl.MapAttached=0 then exit;
  EndMakePolyline;
  BeginMakePolyline(1, 'Left-click polygon points on the map, then right-click to terminate');
  SaveMouseTypes;
  GWControl.mouseLeftType:=0;
  GWControl.mouseRightType:=0;
  SetLength(polyline, 0);
  UpdateMouseTypes;
end;

procedure TMapForm.GetinfobyPolygon1Click(Sender: TObject);
var
 tbl: IGWTable;
 md: integer;
begin // inside polygon
  if GWControl.MapAttached=0 then exit;
  EndMakePolyline;
  if Sender=GetinfoPolygon1 then md:=1 else md:=0;
  if Length(polyline)>=6 then begin
    tbl:=GWControl.GetInfoPolygon(polyline, md) as IGWTable;
     ObjListForm.ShowTable(tbl, GWControl);
  end
  else begin
    StatusBar.Panels[0].Text:='Polygon not defined, please define polygon first';
    Beep;
  end;
end;

procedure TMapForm.Clearpolygon1Click(Sender: TObject);
begin
  EndMakePolyline;
  SetLength(polyline,0);
  GWControl.Invalidate;
end;

procedure TMapForm.Createbitmapfile1Click(Sender: TObject);
var
  north, west, south, east: Double;
  w,h,ms: integer;
  fn: string;
begin
  if GWControl.MapAttached=0 then exit;
  GWControl.Dev2Geo(0, 0, north, west);
  w:=GWControl.ClientWidth; h:=GWControl.ClientHeight;
  GWControl.Dev2Geo(w, h, south, east);

  BitmapOptForm.SetGeoRect(north, west, south, east);
  BitmapOptForm.SetBmpSize(w,h);

  if BitmapOptForm.ShowModal<>mrOK then exit;

  BitmapOptForm.GetGeoRect(north, west, south, east);
  BitmapOptForm.GetBmpSize(w,h);
  BitmapOptForm.GetFontSize(ms);
  BitmapOptForm.GetFileName(fn);

  GWControl.getBitmap(fn, north, west, south, east, w,h,ms);
  ShellExecute(Handle, 'open', PAnsiChar(fn), '', '', SW_SHOWNORMAL);
//  Process.Start('c:\gwx_tmp.bmp')

end;

procedure TMapForm.UpdateMouseTypes;
begin
  LeftButtonType.ItemIndex:=GWControl.mouseLeftType;
  RightButtonType.ItemIndex:=GWControl.mouseRightType;
end;

procedure TMapForm.LeftButtonTypeChange(Sender: TObject);
begin
  GWControl.mouseLeftType:=LeftButtonType.ItemIndex;
end;

procedure TMapForm.RightButtonTypeChange(Sender: TObject);
begin
  GWControl.mouseRightType:=RightButtonType.ItemIndex;
end;

// measure

procedure TMapForm.measure1Click(Sender: TObject);
begin
  if (tool=1) or (GWControl.MapAttached=0) then EndMeasure else BeginMeasure;
end;

procedure TMapForm.BeginMeasure;
begin
  if tool=2 then EndRoute;
  tool:=1;
  measure1.Checked:=true;
  ToolButton5.Down:=true;
  StatusBar.Panels[0].Text:='Left-doubleclick on map to add/remove points of measured polyline';
  SetLength(toolpoints,0);
end;
procedure TMapForm.EndMeasure;
begin
  tool:=0;
  measure1.Checked:=false;
  ToolButton5.Down:=false;
//  StatusBar.Panels[0].Text:='';
  SetLength(toolpoints,0);
  GWControl.DeleteDBF('measure');
end;

function LengthToStr(len: double): string; // len in meters
var m: string;
begin
 if len>=2000 then begin len:=len/1000; m:=' km'; end
 else m:=' m';
 result:=Format('%n', [len])+m;
end;

procedure TMapForm.OnMeasurePointsChanged;
var
  cnt,i: integer;
  status,m: string;
  tbl: IGWTable;
  fs: TFormatSettings;
begin
  cnt:=Length(toolpoints);
  if cnt=0 then status:='Left-doubleclick on map to specify the first point'
  else if cnt=2 then status:='Left-doubleclick on map to specify the second point'
  else begin status:='Length='+LengthToStr(GWControl.getMeasure(toolpoints)/10);
  end;
  StatusBar.Panels[0].Text:=status;

  if cnt=0 then begin
    GWControl.DeleteDBF('measure');
    exit;
  end;

  // creating table
  tbl:=GWControl.CreateGWTable as IGWTable;
  tbl.addColumn('TEXT', 'Metrics', 'Metrics');
  tbl.addColumn('TEXT', 'Style', 'Style');

      tbl.addColumn('INTEGER', 'ix', 'object id');
      tbl.addColumn('INTEGER', 'objtype', 'object type');

  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, fs);
  fs.DecimalSeparator:='.';
  // adding points
  for i:=0 to cnt div 2 -1 do begin // wri
    tbl.addNew();
    m:='P E '+FloatToStr(toolpoints[i*2+1], fs)+' '+FloatToStr(toolpoints[i*2], fs)+';';
    tbl.setValue(m,0);
    if i=0 then tbl.setValue('m @501 "gwp.otl" 1',1)
    else        tbl.setValue('m @501 "gwp.otl" 6 Red',1);

      tbl.setValue(i,2); // id
      tbl.setValue(0,3); // type
  end;
  // adding lines
  for i:=1 to cnt div 2 -1 do begin // wri
    tbl.addNew();
    tbl.setValue(GWControl.GetDistancePath(toolpoints[i*2-2], toolpoints[i*2-1], toolpoints[i*2], toolpoints[i*2+1], 2),0);
    tbl.setValue('p @500 Red 2',1);

      tbl.setValue(i,2); // id
      tbl.setValue(1,3); // type
  end;

  GWControl.Table2Map('name="measure";descr="Distance meter";metrics=[Metrics];style=[Style]', '', tbl);
end;


// route
procedure TMapForm.BeginRoute;
begin
  if tool=1 then EndMeasure;
  pGWRoute:=GWControl.CreateGWRoute('') as IGWRoute;
  if pGWRoute<>nil then begin
    tool:=2;
    Routes1.Checked:=true;
    ToolButton6.Down:=true;
    StatusBar.Panels[0].Text:='Left-doubleclick on map to add/remove points of route';
    SetLength(toolpoints,0);
    GWControl.OnRouteProgress:=RouteParamsForm.OnRouteProgress;
    RouteParamsForm.FOnFormClose:=EndRoute;
    RouteParamsForm.FOnGetRouteResult:=ShowRouteResult;
    RouteParamsForm.FOnRouteAddPoint:=OnRoutePointsChanged;
    RouteParamsForm.FOnRouteAddPointCoord:=RouteAddPointCoord;
    RouteParamsForm.SetGWRoute(pGWRoute);
    RouteParamsForm.Show;
  end
  else begin
    EndRoute;
    StatusBar.Panels[0].Text:='There is no available route information on this map';
    Beep;
  end;
end;
procedure TMapForm.ButtonProgressBreakClick(Sender: TObject);
begin
  FBreaked:=true;
end;

procedure TMapForm.EndRoute;
begin
  tool:=0;
  Routes1.Checked:=false;
  ToolButton6.Down:=false;
  SetLength(toolpoints,0);
  GWControl.Invalidate;
  RouteParamsForm.SetGWRoute(nil);
  pGWRoute:=nil;
  RouteParamsForm.Hide;
  GWControl.DeleteDBF('route points');
  GWControl.DeleteDBF('route lines');
end;


procedure TMapForm.Routes1Click(Sender: TObject);
begin
  if (tool=2) or (GWControl.MapAttached=0) then EndRoute else BeginRoute;
end;


procedure TMapForm.OnRoutePointsChanged;
// added or removed point of the route
var
  cnt,i: integer;
  lat, lon: double;
  status, m, pname: string;
//  tbl: IGWTable;
  fs: TFormatSettings;
  ptype: integer;
begin
  cnt:=Length(toolpoints) div 2;
  if cnt=0 then status:='Left-doubleclick on map to specify the start point'
  else if cnt=1 then status:='Left-doubleclick on map to specify the finish point'
  else status:='';
  StatusBar.Panels[0].Text:=status;

  // show route points
  if cnt=0 then begin
    GWControl.DeleteDBF('route points');
    exit;
  end;
  // using GWTable object
{
  // creating table
  tbl:=GWControl.CreateGWTable as IGWTable;
  tbl.addColumn('TEXT', 'Metrics', 'Metrics');
  tbl.addColumn('TEXT', 'Style', 'Style');
  tbl.addColumn('TEXT', 'Info', 'Point info');
  tbl.addColumn('INTEGER', 'Type', 'Point type'); //////////////////////////

  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, fs);
  fs.DecimalSeparator:='.';
  // adding points to table and to pGWRoute
  pGWRoute.DeletePoints;
  for i:=0 to cnt-1 do begin // wri
    tbl.addNew();
    lat:=toolpoints[i*2];
    lon:=toolpoints[i*2+1];
    pname:=pGWRoute.GetPointName(lat,lon);
    m:='P E '+FloatToStr(lon, fs)+' '+FloatToStr(lat, fs)+';'; // metrics requires (X Y), i.e. (Lon Lat)
    tbl.setValue(m,0);

    ptype:=GWX_RoutePointIntermediate;
    if i=0 then begin if RouteParamsForm.FixStart.Checked then ptype:=GWX_RoutePointStart; end
    else if i=cnt-1 then begin if RouteParamsForm.FixFinish.Checked then ptype:=GWX_RoutePointFinish; end;
    tbl.setValue('m @501 "gwp.otl" '+IntToStr(ptype+20),1);
    tbl.setValue(pname, 2);

    tbl.setValue(ptype, 3);/////////////////////////////////////////////////////
    pGWRoute.AddPoint(lat,lon,ptype,pname,i);
  end;
//  GWControl.Table2Map('name="route points";descr="Points of the route";metrics=[Metrics];style=[Style]', '', tbl);
  GWControl.Table2Map('name="route points";descr="Points of the route";metrics=[Metrics];', 'm @501 "gwp.otl" [Type]+20', tbl);
}

  // alternative method: first add empty table on map and then insert objects

  // mapping empty table
  GWControl.Table2Map('name="route points";descr="Points of the route";'+
    'structure="ix integer index, type integer point type, info text point info";',
    'm @501 "gwp.otl" [type]+20', nil);

  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, fs);
  fs.DecimalSeparator:='.';
  // adding points to table and to pGWRoute
  pGWRoute.DeletePoints;
  for i:=0 to cnt-1 do begin // wri
    lat:=toolpoints[i*2];
    lon:=toolpoints[i*2+1];
    pname:=pGWRoute.GetPointName(lat,lon);
    m:='P E '+FloatToStr(lon, fs)+' '+FloatToStr(lat, fs)+';'; // metrics requires (X Y), i.e. (Lon Lat)

    ptype:=GWX_RoutePointIntermediate;
    if i=0 then begin if RouteParamsForm.FixStart.Checked then ptype:=GWX_RoutePointStart; end
    else if i=cnt-1 then begin if RouteParamsForm.FixFinish.Checked then ptype:=GWX_RoutePointFinish; end;

    pGWRoute.AddPoint(lat,lon,ptype,pname,i);

    GWControl.ModifyTable('insert into [route points] set [type]='+IntToStr(ptype)+
      ', [ix]='+IntToStr(i)+
      ', [info]="'+pname+'", metrics="'+m+'"', 1);

  end;

  if cnt>=2 then RouteParamsForm.OnPointsChanged;
end;

function TimeToStr(sec: integer): string;
begin
  if sec<60 then result:=IntToStr(sec)+' sec'   // < 1 min
  else if sec<600 then result:=IntToStr(sec div 60)+' min '+IntToStr(sec mod 60)+' sec' // 1..10 min
  else if sec<3600 then result:=IntToStr((sec+30) div 60)+' min' // 10 min.. 1 hour
  else begin // more than 1 hour
    sec:=(sec+150) div 300; // 5 min precision
    result:=IntToStr(sec div 12)+' hours '+IntToStr((sec mod 12)*5)+' min';
  end;
end;

procedure TMapForm.ShowRouteResult(res: integer);
var
  status: string;
  tbl: IGWTable;
begin
  if res=0 then begin
    StatusBar.Panels[0].Text:='Failed to calculate route';
    GWControl.DeleteDBF('route lines');
    exit;
  end;

  status:='Length=' + LengthToStr(pGWRoute.RouteLength)+', duration='+TimeToStr(pGWRoute.RouteDuration);
  if res=1 then status:=status+' *** route is calculated only partially';
  StatusBar.Panels[0].Text:=status;

  tbl:=pGWRoute.GetRoute as IGWTable;
  GWControl.Table2Map('name="route lines";descr="Route path";metrics=[Metrics];',
           'p @500 Crimson 205', tbl);
end;

procedure TMapForm.UpdateMenuProc(var Message: TMessage);
var
  item: TMenuItem;
  tbl, luplist:IGWTable;
  p,q: integer;
  cdfs: TStringList; // processed codifiers
  lups: TStringList; // used lookups
  cdf: string;
  dblist: IGWStringList;
begin
  MapStyle1.Clear;
  cdfs:=TStringList.Create;
  lups:=TStringList.Create;

  tbl:=GWControl.LoadedMaps as IGWTable;

  // first get all used lookups
  p:=tbl.MoveFirst;
  while p>=0 do begin
    lups.Add(tbl.getText(5)); // lookup of the map, can be repeted
    p:=tbl.MoveNext;
  end;

  // then get list for all codifier
  p:=tbl.MoveFirst;
  if p<0 then begin
     item:=TMenuItem.Create(Self);
     item.Caption:='<no open maps>';
     item.Enabled:=false;
     MapStyle1.Add(item);
  end;

  while p>=0 do begin
    cdf:=tbl.getText(4); // codifier of the map
    if cdfs.IndexOf(cdf)=-1 then begin
      cdfs.Add(cdf);
      if p>0 then begin
        item:=TMenuItem.Create(Self);
        item.Caption:='-';
        item.Enabled:=false;
        MapStyle1.Add(item);
      end;
      luplist:=GWControl.GetAvailableLookups(cdf) as IGWTable;
      q:=luplist.MoveFirst;
      while q>=0 do begin

        item:=TMenuItem.Create(Self);
        item.Caption:=luplist.getText(1)+#9+luplist.getText(0);
        if lups.IndexOf(luplist.getText(0))>=0 then item.Checked:=true;
        item.OnClick:=LookupItemClick;
        MapStyle1.Add(item);

        q:=luplist.MoveNext;
      end;
      luplist:=nil;
    end;
    p:=tbl.MoveNext;
  end;
  cdfs.Free;
  lups.Free;

  Unload2.Clear;
  dblist:=GWControl.DBFLoadedList as IGWStringList;
  p:=dblist.MoveFirst;
  if p=0 then begin // no tables loaded
    item:=TMenuItem.Create(Self);
    item.Caption:='<no loaded tables>';
    item.Enabled:=false;
    Unload2.Add(item);
  end;
  while p<>0 do begin
    item:=TMenuItem.Create(Self);
    item.Caption:=dblist.Item;
    item.OnClick:=UnloadItemClick;
    Unload2.Add(item);
    p:=dblist.MoveNext;
  end;
  tbl:=nil;
end;

procedure TMapForm.UnloadItemClick(Sender: TObject);
var
  item: TMenuItem;
  ln: string;
  p: integer;
begin
  item:=Sender as TMenuItem;

  ln:=item.Caption;
  p:=Pos('&', ln); // '&' is automatically inserted in caption
  if p>0 then Delete(ln,p,1);
  GWControl.DeleteDBF(ln);
end;

procedure TMapForm.LookupItemClick(Sender: TObject);
var
  item: TMenuItem;
  ln: string;
  p: integer;
begin
  item:=Sender as TMenuItem;
  ln:=item.Caption;
  p:=Pos(#9, ln);
  if p>0 then ln:=RightStr(ln, Length(ln)-p);
  GWControl.SetLookup(ln,'');
end;

procedure TMapForm.Loaddatabase1Click(Sender: TObject);
var
  db,style, status: string;
  res: TOleEnum;
begin
  if GWControl.MapAttached=0 then begin
    StatusBar.Panels[0].Text:='No maps loaded';
    Beep;
    exit;
  end;
  if not DbForm.Execute(GWControl.LoadedMaps as IGWTable, GWControl.getModulePath) then exit;
  DbForm.GetResult(db, style);
  res:=GWControl.DBF2Map(db,style);
  case res of
    GWX_DBF2Map_Ok:            status:='Ok';
    GWX_DBF2Map_MapNoAttached: status:='Map not loaded';
    GWX_DBF2Map_BadStyle:      status:='Bad style specified';
    GWX_DBF2Map_DBFNotFound:   status:='DBF file not found';
    GWX_DBF2Map_ServerError:   status:='Error in DBF or object not found to load on';
  end;
  StatusBar.Panels[0].Text:='Result of loading '''+ExtractFileName(db)+''': '+status;
  // if ok show not loded records
  if res=GWX_DBF2Map_Ok then
    DbErrForm.ShowNotLoadedRecords(GWControl.getUnloaderDBF as IGWTable, db);
end;

procedure TMapForm.UnloadallDBsandtables1Click(Sender: TObject);
var
  p: integer;
  dblist: IGWStringList;
begin
  dblist:=GWControl.DBFLoadedList as IGWStringList;
  p:=dblist.MoveFirst;
  while p<>0 do begin
    GWControl.DeleteDBF(dblist.Item);
    p:=dblist.MoveNext;
  end;
end;

procedure TMapForm.Openfile1Click(Sender: TObject);
var
  i: integer;
  status: string;
  res: TOleEnum;
begin
  if not OpenDialog.Execute then exit;
  Screen.Cursor:=crHourGlass;
  GWControl.MapName:='';
// in order to show licence dialog in English
//  GWControl.LicenceDialogLanguage:='ENGLISH';
  status:='Added maps: ';
  for i:=0 to OpenDialog.Files.Count-1 do begin
    res:=GWControl.AddMap(OpenDialog.Files[i], '');
    if i<>0 then status:=status+', ';
    status:=status+ExtractFileName(OpenDialog.Files[i])+' - '+GWXErrorToStr(res);
  end;
  StatusBar.Panels[0].Text:=status;
  OnMapChanged;
  ShowMessage(GWControl.MapName);
  Screen.Cursor:=crDefault;
end;

procedure TMapForm.ToolButton8Click(Sender: TObject);
begin
  Application.HelpFile:=ExtractFilePath(Application.ExeName)+'ax.hlp';
  Application.HelpCommand(HELP_INDEX,0);
end;

procedure TMapForm.Addfile1Click(Sender: TObject);
var
  i: integer;
  status: string;
  res: TOleEnum;
begin
  if not OpenDialog.Execute then exit;
  status:='Added maps: ';
  Screen.Cursor:=crHourGlass;
  for i:=0 to OpenDialog.Files.Count-1 do begin
    res:=GWControl.AddMap(OpenDialog.Files[i], '');
    if i<>0 then status:=status+', ';
    status:=status+ExtractFileName(OpenDialog.Files[i])+' - '+GWXErrorToStr(res);
  end;
  StatusBar.Panels[0].Text:=status;
  OnMapChanged;
  Screen.Cursor:=crDefault;
end;

procedure TMapForm.Addraster1Click(Sender: TObject);
var
  i: integer;
  status: string;
  res: TOleEnum;
begin
  if not RasterOpenDialog.Execute then exit;
  Screen.Cursor:=crHourGlass;
  status:='Added raster: ';
  for i:=0 to RasterOpenDialog.Files.Count-1 do begin
    res:=GWControl.AddMap(RasterOpenDialog.Files[i], '');
    if i<>0 then status:=status+', ';
    status:=status+ExtractFileName(RasterOpenDialog.Files[i])+' - '+GWXErrorToStr(res);
  end;
  StatusBar.Panels[0].Text:=status;
  OnMapChanged;
  Screen.Cursor:=crDefault;
end;

procedure TMapForm.Adddesign1Click(Sender: TObject);
var
  i: integer;
  status: string;
  res: TOleEnum;
begin
  if not DesignOpenDialog.Execute then exit;
  Screen.Cursor:=crHourGlass;
  status:='Added raster: ';
  for i:=0 to DesignOpenDialog.Files.Count-1 do begin
    res:=GWControl.AddMap(DesignOpenDialog.Files[i], '');
    if i<>0 then status:=status+', ';
    status:=status+ExtractFileName(DesignOpenDialog.Files[i])+' - '+GWXErrorToStr(res);
  end;
  StatusBar.Panels[0].Text:=status;
  OnMapChanged;
  Screen.Cursor:=crDefault;
end;

procedure TMapForm.Button1Click(Sender: TObject);
begin
  ZeroLT;
end;

procedure TMapForm.Button2Click(Sender: TObject);
var
  dX: Integer;
begin
  dX:=0;
  if not MapScrollR(dX) then begin
    ShowMessage('Fail R='+IntToStr(dX));
  end;
end;

procedure TMapForm.Button4Click(Sender: TObject);
var
  dY: Integer;
begin
  dY:=0;
  if not MapScrollB(dY) then begin
    ShowMessage('Fail B='+IntToStr(dY));
  end;
end;

function TMapForm.MapScrollR(var dX: Integer): Boolean;
var
  XPos: Integer;
  XPosNew: Integer;
begin
  XPos:=GetScrollPos(GWControl.Handle,SB_HORZ);
  SendMessage(GWControl.Handle,WM_HSCROLL,SB_PAGERIGHT,0);
  XPosNew:=GetScrollPos(GWControl.Handle,SB_HORZ);
  dX:=XPosNew-XPos;
  Result:=XPos<>XPosNew;
end;

function TMapForm.MapScrollB(var dY: Integer): Boolean;
var
  YPos: Integer;
  YPosNew: Integer;
begin
  YPos:=GetScrollPos(GWControl.Handle,SB_VERT);
  SendMessage(GWControl.Handle,WM_VSCROLL,SB_PAGEDOWN,0);
  YPosNew:=GetScrollPos(GWControl.Handle,SB_VERT);
  dY:=YPosNew-YPos;
  Result:=YPos<>YPosNew;
end;

procedure TMapForm.ZeroL;
begin
  SendMessage(GWControl.Handle,WM_HSCROLL,SB_LEFT,0);
end;

procedure TMapForm.ZeroT;
begin
  SendMessage(GWControl.Handle,WM_VSCROLL,SB_TOP,0);
end;

procedure TMapForm.ZeroLT;
begin
  ZeroL;
  ZeroT;
end;

procedure TMapForm.ToolButtonExportToDbfClick(Sender: TObject);
var
  List1, List2: TStringList;
  X,Y: Integer;
  dX,dY: Integer;
  f1,f2: String;
  Found: Boolean;
begin
  if GWControl.MapAttached>0 then
    if SaveDialog.Execute then begin
      List1:=TStringList.Create;
      List2:=TStringList.Create;
      try

        f1:=ChangeFileExt(SaveDialog.FileName,'.src');
        f2:=SaveDialog.FileName;

        if CheckBoxScanAll.Checked then
          ZeroLT;

        FBreaked:=false;
        Found:=true;

        X:=0;
        Y:=0;

        if Found then
          while True do begin
            ScanAdress(List1,List2,X,Y);

            Application.ProcessMessages;
            if FBreaked then
              break;

            if CheckBoxScanAll.Checked then begin
              if not MapScrollR(dX) then begin
                Application.ProcessMessages;
                ZeroL;
                if not MapScrollB(dY) then
                  break;
              end;
            end;
          end;

        ShowMessage(Format('Found %d addresses.',[List2.Count]));

        List1.SaveToFile(f1);
        List2.SaveToFile(f2);
      finally
        List2.Free;
        List1.Free;
      end;
    end;
end;

function VarToIntDef(const V: Variant; const ADefault: Integer): Integer;
begin
  try
    if not VarIsNull(V) then
      Result:=V
    else
      Result:=ADefault;
  except
    Result:=ADefault;
  end;
end;

function VarToExtendedDef(const V: Variant; const ADefault: Extended): Extended;
begin
  try
    if not VarIsNull(V) then
      Result:=V
    else
      Result:=ADefault;
  except
    Result:=ADefault
  end;
end;

procedure TMapForm.ScanAdress(List1,List2: TStringList; XStart,YStart: Integer);
var
  x,y: Integer;
  S: String;
  L1,L2: String;
  Lat, Lon: Double;
  NewLat,NewLon: Double;
  FLat,FLon: Double;
  Locality, StreetPrefix, Street, House: String;
  Found: Boolean;
  tbl: IGWTable;
  S1: String;
  Id: Integer;
  p: Integer;
  obj:  IGWObject;
  Ids: TInterfaceList;
  i: Integer;
  Item: TListItem;
  XX, YY: Integer;
  paLen: OleVariant;
  coords: array of double;
  List3: TStringList;
  Found2: Boolean;
begin
  if Assigned(List1) and Assigned(List2) then begin


    XX:=UpDownStep.Position;
    YY:=UpDownStep.Position;

    ProgressBar1.Min:=0;
    ProgressBar1.Max:=GWControl.Width;

    ProgressBar2.Min:=0;
    ProgressBar2.Max:=GWControl.Height;

    Ids:=TInterfaceList.Create;
    List3:=TStringList.Create;
    ListView.Items.BeginUpdate;
    try

      for x:=XStart to GWControl.Width do begin

         if (x mod XX)=0 then begin
           ProgressBar1.Position:=x+1;
           ProgressBar1.Update;

           LabelX.Caption:=IntToStr(x);
           LabelX.Update;

            Application.ProcessMessages;
           if FBreaked then
             break;

          for y:=YStart to GWControl.Height do begin

            Found:=false;
            Id:=-1;
            if (y mod YY)=0 then begin

              ProgressBar2.Position:=y+1;
              ProgressBar2.Update;

              LabelY.Caption:=IntToStr(y);
              LabelY.Update;   

              Application.ProcessMessages;
              if FBreaked then
                break;

               Ids.Clear;
               
               GWControl.Dev2Geo(x,y,Lat,Lon);
               tbl:=GWControl.GetInfo(Lat,Lon) as IGWTable;
               if Assigned(tbl) then begin
                 p:=tbl.MoveFirst;
                 while p>=0 do begin
                   S1:=Trim(tbl.getText(2));
                   S1:=Copy(S1,1,2);
                   if (S1='BL') or (S1='TX') then begin
                     obj:=GWControl.getObject(StrToInt(tbl.getText(0))) as IGWObject;
                     if Assigned(Obj) then begin
                       S1:=Trim(StringReplace(tbl.getText(3), #13, '�',[rfReplaceAll]));
                       if S1<>'' then
                         Ids.Add(Obj);
                     end;
//                     Id:=VarToIntDef(tbl.getValue(0),-1);
                     Found:=true;
                   end;

                   p:=tbl.MoveNext;
                 end;
               end;

            end;

            if Found and (Ids.Count>0) then begin

              for i:=0 to Ids.Count-1 do begin

                NewLat:=Lat;
                NewLon:=Lon;

                obj:=IGWObject(Ids[i]);
                coords:=obj.Metrics[paLen];
                Found2:=false;
                if Length(coords)>5 then begin
                  if (coords[2]<=NewLat) and (coords[4]>=NewLat) and
                     (coords[3]<=NewLon) and (coords[5]>=NewLon) then begin
                    NewLat:=(coords[4]+coords[2])/2;
                    NewLon:=(coords[5]+coords[3])/2;
                    Found2:=true;
                  end;
                end;

                if Found2 then begin

                  S:=GWControl.FindNearestAddress(NewLat,NewLon);
                  if (Trim(S)<>'') then begin

                    if List3.IndexOf(S)=-1 then begin

                      List3.Add(S);

                      FLat:=0.0;
                      FLon:=0.0;

                      if Boolean(GWControl.SearchAddress(S,FLat,FLon)) then begin
                        NewLat:=FLat;
                        NewLon:=FLon;
                      end; 

                      L1:=ReplaceStr(FloatToStr(NewLat),',','.');
                      L2:=ReplaceStr(FloatToStr(NewLon),',','.');

                      Street:='';
                      StreetPrefix:='';
                      House:='';
                      Locality:='';
                      GetAddress(S,Locality,StreetPrefix,Street,House);

                      S:=Format('%s;%s;%s',[L1,L2,S]);
              //        if List1.IndexOf(S)=-1 then
                         List1.Add(S);

                      S:=Format('%s;%s;%s;%s;%s;%s',[L1,L2,Street,StreetPrefix,House,Locality]);
            //          if List2.IndexOf(S)=-1 then begin

                        Item:=ListView.Items.Add;
                        Item.Caption:=Street;
                        Item.SubItems.Add(StreetPrefix);
                        Item.SubItems.Add(House);
                        Item.SubItems.Add(Locality);
                        Item.SubItems.Add(L1);
                        Item.SubItems.Add(L2);
                        ListView.Update;

                        List2.AddObject(S,Pointer(Id));

                        LabelCount.Caption:=IntToStr(List2.Count);
                        LabelCount.Update;

                        IGWObject(Ids[i]).Marked:=1;

      //                end;

              //       end;
                    end;
                  end;
                end;

              end;

              if Ids.Count>0 then
                GWControl.Refresh;

            end;
          end;

          end;

      end;
    finally
      List3.Free;
      ListView.Items.EndUpdate;
      Ids.Free;
    end;

    ProgressBar1.Position:=0;
    ProgressBar2.Position:=0;
  end;
end;

procedure TMapForm.AddressFrom1Click(Sender: TObject);
var
  Item: TListItem;
  L1,L2: String;
begin
  Item:=ListView.Selected;
  if Assigned(Item) then begin
    L1:=Item.SubItems[3];
    L2:=Item.SubItems[4];
    EditLatFrom.Text:=L1;
    EditLonFrom.Text:=L2;
  end;
end;

procedure TMapForm.AddressTo1Click(Sender: TObject);
var
  Item: TListItem;
  L1,L2: String;
begin
  Item:=ListView.Selected;
  if Assigned(Item) then begin
    L1:=Item.SubItems[3];
    L2:=Item.SubItems[4];
    EditLatTo.Text:=L1;
    EditLonTo.Text:=L2;
  end;
end;

procedure TMapForm.ListViewDblClick(Sender: TObject);
var
  Item: TListItem;
  L1,L2: String;
  Lat1,Lon1: Double;
  tbl: IGWTable;
  p: Integer;
  obj:  IGWObject;
  S1: String;
  Ids: TInterfaceList;
  i: Integer;
begin
  Item:=ListView.Selected;
  if Assigned(Item) then begin
    L1:=Item.SubItems[3];
    L2:=Item.SubItems[4];
    Lat1:=StrToFloatDef(ReplaceText(L1,'.',','),0.0);
    Lon1:=StrToFloatDef(ReplaceText(L2,'.',','),0.0);
    GWControl.SetGeoCenter(Lat1,Lon1);
    Ids:=TInterfaceList.Create;
    try
     tbl:=GWControl.GetInfo(Lat1,Lon1) as IGWTable;
     if Assigned(tbl) then begin
       p:=tbl.MoveFirst;
       while p>=0 do begin
         S1:=tbl.getText(2);
         S1:=Trim(Copy(S1,1,2));
         if (S1='BL') or (S1='TX') then begin
           obj:=GWControl.getObject(StrToInt(tbl.getText(0))) as IGWObject;
           if Assigned(Obj) then begin
             S1:=Trim(StringReplace(tbl.getText(3), #13, '�',[rfReplaceAll]));
             if S1<>'' then
               Ids.Add(Obj);
           end;
         end;
         p:=tbl.MoveNext;
       end;
     end;

     for i:=0 to Ids.count-1 do begin
       IGWObject(Ids[i]).Marked:=0;
     end;

     GWControl.Refresh;

     for i:=0 to Ids.count-1 do begin
       IGWObject(Ids[i]).Marked:=1;
     end;

    finally
      Ids.Free;
    end;
  end;
end;

procedure TMapForm.ButtonCalcClick(Sender: TObject);
var
  Ret: OleVariant;
  Points: OleVariant;
  V: Extended;
  Lat1,Lon1,Lat2,Lon2: Double;
  lat,lon: Double;
  Route: IGWRoute;
  pname: string;
  ptype: Integer;
  i: Integer;
  B,E: Integer;
  Dim: Integer;
  Flag: Boolean;
  Counter: Integer;
  m: String;
  fs: TFormatSettings;
  tbl: IGWTable;
  T1: TTime;
begin
  Lat1:=StrToFloatDef(ReplaceText(EditLatFrom.Text,'.',','),0.0);
  Lon1:=StrToFloatDef(ReplaceText(EditLonFrom.Text,'.',','),0.0);
  Lat2:=StrToFloatDef(ReplaceText(EditLatTo.Text,'.',','),0.0);
  Lon2:=StrToFloatDef(ReplaceText(EditLonTo.Text,'.',','),0.0);
  Ret:=GWControl.GetDistancePath(Lat1,Lon1,Lat2,Lon2,0);
  if not VarIsNull(Ret) then begin
    V:=VarToExtendedDef(Ret,0.0);
    LabelDistance.Caption:=LengthToStr(V);
  end else
    LabelDistance.Caption:='Error';

  Points:=GWControl.GetDistancePath(Lat1,Lon1,Lat2,Lon2,1);

  Route:=GWControl.CreateGWRoute('') as IGWRoute;
  if Assigned(Route) then begin

    T1:=Time;
    GWControl.DeleteDBF('route lines');
    GWControl.DeleteDBF('route points');

    if CheckBoxDraw.Checked then 
      GWControl.Table2Map('name="route points";descr="Points of the route";'+
                          'structure="ix integer index, type integer point type, info text point info";',
                          'm @501 "gwp.otl" [type]+20', nil);

    GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, fs);
    fs.DecimalSeparator:='.';
    // adding points to table and to pGWRoute
    Route.DeletePoints;

    Dim:=VarArrayDimCount(Points);
    B:=VarArrayLowBound(Points,Dim);
    E:=VarArrayHighBound(Points,Dim);

    Flag:=true;
    Counter:=0;
    lat:=0.0;

    for i:=B to E do begin

      if Counter=0 then
        ptype:=GWX_RoutePointStart
      else if i=E then
        ptype:=GWX_RoutePointFinish
      else ptype:=GWX_RoutePointIntermediate;

      if Flag then begin
        lat:=Points[i];
        Flag:=false;
      end else begin
        lon:=Points[i];

        m:='P E '+FloatToStr(lon, fs)+' '+FloatToStr(lat, fs)+';'; // metrics requires (X Y), i.e. (Lon Lat)

        pname:=Route.GetPointName(lat,lon);
        Route.AddPoint(lat,lon,ptype,pname,Counter);

        if CheckBoxDraw.Checked then
          GWControl.ModifyTable('insert into [route points] set [type]='+IntToStr(ptype)+
                                ', [ix]='+IntToStr(Counter)+
                                ', [info]="'+pname+'", metrics="'+m+'"', 1);

        Inc(Counter);

        Flag:=true;
      end;

    end;
    Route.CalculateRoute;


    LabelDistance2.Caption:=LengthToStr(Route.RouteLength);

    if CheckBoxDraw.Checked then begin
      tbl:=Route.GetRoute as IGWTable;
      GWControl.Table2Map('name="route lines";descr="Route path";metrics=[Metrics];',
                          'p @500 Crimson 205', tbl);
    end;

    ShowMessage(FormatDateTime('ss.zzz',Time-T1));
  end;

end;

procedure TMapForm.save1Click(Sender: TObject);
var
  Str: TStringList;
  i: Integer;
  S: String;
  L1,L2,Street,StreetPrefix,House,Locality: String;
  Item: TListItem;
begin
  if SaveDialogPoints.Execute then begin
    Str:=TStringList.Create;
    try
      for i:=0 to ListView.Items.Count-1 do begin
        Item:=ListView.Items[i];
        Street:=Item.Caption;
        StreetPrefix:=Item.SubItems[0];
        House:=Item.SubItems[1];
        Locality:=Item.SubItems[2];
        L1:=Item.SubItems[3];
        L2:=Item.SubItems[4];
        S:=Format('%s;%s;%s;%s;%s;%s',[L1,L2,Street,StreetPrefix,House,Locality]);
        Str.Add(S);

      end;

      Str.SaveToFile(SaveDialogPoints.FileName);
    finally
      Str.Free;
    end;
  end;
end;


end.

