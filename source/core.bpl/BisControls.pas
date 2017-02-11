unit BisControls;

interface

uses Windows, Messages, Classes, Controls, Graphics, StdCtrls, ComCtrls, Contnrs,
     ExtCtrls, CheckLst,
     DBCtrls, rxToolEdit, RxRichEd, ThemedDBGrid, rxCurrEdit,
     SynEdit,
     BisPopupEdit;

type
  TLabel=class(StdCtrls.TLabel)
  private
    FFocusControls: TObjectList;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property FocusControls: TObjectList read FFocusControls;
  end;

  TEdit=class(StdCtrls.TEdit)
  private
    FLabels: TList;
    FOldColor: TColor;
    FOldLabelColor: TColor;
    FAlignment: TAlignment;
    FPassword: Boolean;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure SetAlignment(const Value: TAlignment);
    procedure SetPassword(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateParams(var Params: TCreateParams); override;

    property Alignment: TAlignment read FAlignment write SetAlignment;
    property Password: Boolean read FPassword write SetPassword;
  end;

  TLabeledEdit=class(ExtCtrls.TLabeledEdit)
  private
    FLabels: TList;
    FOldColor: TColor;
    FOldLabelColor: TColor;
    FPassword: Boolean;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    procedure SetPassword(const Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateParams(var Params: TCreateParams); override;

    property Password: Boolean read FPassword write SetPassword;
  end;

  TMemo=class(StdCtrls.TMemo)
  private
    FLabels: TList;
    FOldColor: TColor;
    FOldLabelColor: TColor;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TRichEdit=class(ComCtrls.TRichEdit)
  private
    FLabels: TList;
    FOldColor: TColor;
    FOldLabelColor: TColor;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TSynEdit=class(SynEdit.TSynEdit)
  private
    FLabels: TList;
    FOldColor: TColor;
    FOldLabelColor: TColor;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TListBox=class(StdCtrls.TListBox)
  private
    FLabels: TList;
    FOldColor: TColor;
    FOldLabelColor: TColor;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CanFocus: Boolean; override;
  end;

  TCheckListBox=class(CheckLst.TCheckListBox)
  private
    FLabels: TList;
    FOldColor: TColor;
    FOldLabelColor: TColor;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TComboBox=class(StdCtrls.TComboBox)
  private
    FLabels: TList;
    FOldColor: TColor;
    FOldLabelColor: TColor;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CanFocus: Boolean; override;
  end;

  TColorBox=class(ExtCtrls.TColorBox)
  private
    FLabels: TList;
    FOldColor: TColor;
    FOldLabelColor: TColor;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TDateTimePicker=class(ComCtrls.TDateTimePicker)
  private
    FLabels: TList;
    FOldColor: TColor;
    FOldLabelColor: TColor;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TDBEdit=class(DBCtrls.TDBEdit)
  private
    FOldColor: TColor;
    FOldLabelColor: TColor;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
  end;

  TDBMemo=class(DBCtrls.TDBMemo)
  private
    FOldColor: TColor;
    FOldLabelColor: TColor;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
  end;

  TEditDate=class(TDateEdit)
  private
    FLabels: TList;
    FOldColor: TColor;
    FOldLabelColor: TColor;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    function GetDate2: Variant;
    procedure SetDate2(Value: Variant);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Date2: Variant read GetDate2 write SetDate2;
  end;

  TEditPopup=class(TBisPopupEdit)
  private
    FLabels: TList;
    FOldColor: TColor;
    FOldLabelColor: TColor;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TEditCurrency=class(TCurrencyEdit)
  private
    FLabels: TList;
    FOldColor: TColor;
    FOldLabelColor: TColor;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TEditCalc=class(TRxCalcEdit)
  private
    FLabels: TList;
    FOldColor: TColor;
    FOldLabelColor: TColor;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
    function GetValue: Variant;
    procedure SetValue(const AValue: Variant);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Value: Variant read GetValue write SetValue;
  end;

  TEditDateClass=class of TEditDate;

  TEditInteger=class(TEdit)
  private
    FMaxValue: Integer;
    FMinValue: Integer;
    function GetValue: Integer;
    procedure SetValue(Value: Integer);
    function ChopToRange(Value: Integer): Integer;
    procedure SetMaxValue(Value: Integer);
    procedure SetMinValue(Value: Integer);
    function IsInRange(Value: Integer): boolean; overload;
    function IsInRange(Value: String): boolean; overload;
  protected
     procedure WMPaste(var Msg: TMessage); message WM_PASTE;
  public
    constructor Create(AOwner: TComponent); override;
    procedure KeyPress(var Key: Char); override;

    property Value: Integer read GetValue write SetValue;
    property MaxValue: Integer read FMaxValue write SetMaxValue;
    property MinValue: Integer read FMinValue write SetMinValue;
  end;

  TEditFloat=class(TEdit)
  private
    FMaxValue: Extended;
    FMinValue: Extended;
    FDecimals: Integer;
    FDisplayFormat: String;
    function GetValue: Extended;
    procedure SetValue(Value: Extended);
    function ChopToRange(Value: Extended): Extended;
    procedure SetDecimals(Value: Integer);
    procedure SetMaxValue(Value: Extended);
    procedure SetMinValue(Value: Extended);
    function IsInRange(Value: Extended): boolean; overload;
    function IsInRange(Value: String): boolean; overload;
    procedure SetDisplayFormat(const Value: String);
  protected
    procedure WMPaste(var Msg: TMessage); message WM_PASTE;
  public
    constructor Create(AOwner: TComponent); override;
    procedure KeyPress(var Key: Char); override;
    procedure Change; override;

    property Value: Extended read GetValue write SetValue;
    property MaxValue: Extended read FMaxValue write SetMaxValue;
    property MinValue: Extended read FMinValue write SetMinValue;
    property Decimals: Integer read FDecimals write SetDecimals;
    property DisplayFormat: String read FDisplayFormat write SetDisplayFormat; 
  end;

  THotKey=class(ComCtrls.THotKey)
  private
    FLabels: TList;
    FOldColor: TColor;
    FOldLabelColor: TColor;
    procedure CMEnter(var Message: TCMEnter); message CM_ENTER;
    procedure CMExit(var Message: TCMExit); message CM_EXIT;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Color;
  end;

  TDBGrid=class(ThemedDBGrid.TDBGrid)
  end;



function GetLabelByWinControl(WinControl: TWinControl): TLabel;
procedure EnableLabelsByWinControl(WinControl: TWinControl; Enabled: Boolean);

function ReplaceEditToEditInteger(var Edit: TEdit): TEditInteger;
function ReplaceEditToEditFloat(var Edit: TEdit): TEditFloat;
function ReplaceDateTimePickerToEditDate(var DateTimePicker: TDateTimePicker; AClass: TEditDateClass=nil): TEditDate;
function ReplaceEditToEditPopup(var Edit: TEdit): TEditPopup;
function ReplaceEditToEditCurrency(var Edit: TEdit): TEditCurrency;
function ReplaceEditToEditCalc(var Edit: TEdit): TEditCalc;
function ReplaceMemoToSynEdit(var Memo: TMemo): TSynEdit;

implementation

uses Forms, Math, SysUtils, Variants, ClipBrd, StrUtils,
     BisUtils, BisConsts;

function GetLabelByWinControl(WinControl: TWinControl): TLabel;
var
  i: Integer;
begin
  Result:=nil;
  if not Assigned(WinControl) then exit;
  if not Assigned(WinControl.Owner) then exit;
  if not (WinControl.Owner is TScrollingWinControl) then exit;
  for i:=0 to TScrollingWinControl(WinControl.Owner).ComponentCount-1 do begin
    if TScrollingWinControl(WinControl.Owner).Components[i] is TLabel then
      if TLabel(TScrollingWinControl(WinControl.Owner).Components[i]).FocusControl=WinControl then begin
        Result:=TLabel(TScrollingWinControl(WinControl.Owner).Components[i]);
        break;
      end;
  end;
end;

procedure GetLabelsByWinControl(WinControl: TWinControl; Labels: TList; IsClear: Boolean=true);

  procedure GetLabelsByComponents(Parent: TWinControl);
  var
    i: Integer;
  begin
    for i:=0 to Parent.ComponentCount-1 do begin
      if Parent.Components[i] is TLabel then begin
        if (TLabel(Parent.Components[i]).FocusControls.IndexOf(WinControl)<>-1) or
           (TLabel(Parent.Components[i]).FocusControl=WinControl) then
          Labels.Add(Parent.Components[i]);
      end;
    end;
  end;

  procedure GetLabelsByControls(Parent: TWinControl);
  var
    i: Integer;
  begin
    for i:=0 to Parent.ControlCount-1 do begin
      if Parent.Controls[i] is TLabel then begin
        if (TLabel(Parent.Controls[i]).FocusControls.IndexOf(WinControl)<>-1) or
           (TLabel(Parent.Controls[i]).FocusControl=WinControl) then
          Labels.Add(Parent.Controls[i]);
      end else if Assigned(Parent.Controls[i].Parent) then
        GetLabelsByWinControl(Parent.Controls[i].Parent,Labels,false);
    end;
  end;

begin
  if Assigned(WinControl) and Assigned(Labels) then begin
    if IsClear then
      Labels.Clear;
    if Assigned(WinControl.Owner) and  (WinControl.Owner is TWinControl) then
      GetLabelsByComponents(TWinControl(WinControl.Owner))
    else if Assigned(WinControl.Parent) and (WinControl.Parent is TWinControl) then
      GetLabelsByControls(TWinControl(WinControl.Parent))
  end;
end;

procedure EnableLabelsByWinControl(WinControl: TWinControl; Enabled: Boolean);
var
  List: TList;
  i: Integer;
begin
  List:=TList.Create;
  try
    GetLabelsByWinControl(WinControl,List);
    for i:=0 to List.Count-1 do begin
      TLabel(List.Items[i]).Enabled:=Enabled;
    end;
  finally
    List.Free;
  end;  
end;

type
  THackLabel=class(TCustomLabel)
  end;

function GetLabelsColor(Labels: TList; NewColor, DefaultColor: TColor): TColor;
var
  Lb: THackLabel;
  i: Integer;
  First: Boolean;
begin
  Result:=DefaultColor;
  if Assigned(Labels) then begin
    First:=true;
    for i:=0 to Labels.Count-1 do begin
      Lb:=THackLabel(Labels.Items[i]);
      if Assigned(Lb) then begin
        if First then
          Result:=Lb.Font.Color;
        First:=false;
        Lb.Font.Color:=NewColor;
      end;
    end;
  end;
end;

function ReplaceEditToEditInteger(var Edit: TEdit): TEditInteger;
var
  AEditInteger: TEditInteger;
  AName: String;
  AText: String;
  List: TList;
  i: Integer;
begin
  Result:=nil;
  if Assigned(Edit) then begin
    List:=TList.Create;
    try
      AName:=Edit.Name;
      AText:=Edit.Text;
      GetLabelsByWinControl(Edit,List);
      AEditInteger:=TEditInteger.Create(Edit.Owner);
      AEditInteger.Parent:=Edit.Parent;
      AEditInteger.SetBounds(Edit.Left,Edit.Top,Edit.Width,Edit.Height);
      AEditInteger.TabOrder:=Edit.TabOrder;
      AEditInteger.Enabled:=Edit.Enabled;
      AEditInteger.OnChange:=Edit.OnChange;
      AEditInteger.MaxLength:=Edit.MaxLength;
      AEditInteger.Color:=Edit.Color;
      AEditInteger.Alignment:=Edit.Alignment;
      AEditInteger.Anchors:=Edit.Anchors;
      AEditInteger.Visible:=Edit.Visible;
      AEditInteger.ReadOnly:=Edit.ReadOnly;
      AEditInteger.Hint:=Edit.Hint;
      AEditInteger.Font.Assign(Edit.Font);
      Edit.Free;
      Edit:=nil;
      AEditInteger.Name:=AName;
      AEditInteger.Text:=AText;
      for i:=0 to List.Count-1 do
        TLabel(List.Items[i]).FocusControl:=AEditInteger;
      Result:=AEditInteger;
    finally
      List.Free;
    end;
  end;
end;

function ReplaceEditToEditFloat(var Edit: TEdit): TEditFloat;
var
  AEditFloat: TEditFloat;
  AName: String;
  AText: String;
  List: TList;
  i: Integer;
begin
  Result:=nil;
  if Assigned(Edit) then begin
    List:=TList.Create;
    try
      AName:=Edit.Name;
      AText:=Edit.Text;
      GetLabelsByWinControl(Edit,List);
      AEditFloat:=TEditFloat.Create(Edit.Owner);
      AEditFloat.Parent:=Edit.Parent;
      AEditFloat.SetBounds(Edit.Left,Edit.Top,Edit.Width,Edit.Height);
      AEditFloat.TabOrder:=Edit.TabOrder;
      AEditFloat.Enabled:=Edit.Enabled;
      AEditFloat.OnChange:=Edit.OnChange;
      AEditFloat.MaxLength:=Edit.MaxLength;
      AEditFloat.Color:=Edit.Color;
      AEditFloat.Alignment:=Edit.Alignment;
      AEditFloat.Anchors:=Edit.Anchors;
      AEditFloat.Visible:=Edit.Visible;
      AEditFloat.ReadOnly:=Edit.ReadOnly;
      AEditFloat.Hint:=Edit.Hint;
      AEditFloat.Font.Assign(Edit.Font);
      Edit.Free;
      Edit:=nil;
      AEditFloat.Name:=AName;
      AEditFloat.Text:=AText;
      for i:=0 to List.Count-1 do
        TLabel(List.Items[i]).FocusControl:=AEditFloat;
      Result:=AEditFloat;
    finally
      List.Free;
    end;
  end;
end;

function ReplaceDateTimePickerToEditDate(var DateTimePicker: TDateTimePicker; AClass: TEditDateClass=nil): TEditDate;
var
  AEditDate: TEditDate;
  AName: String;
  ADate: TDateTime;
  AChecked: Boolean;
  List: TList;
  i: Integer;
  NewClass: TEditDateClass;
begin
  Result:=nil;
  if Assigned(DateTimePicker) then begin
    List:=TList.Create;
    try
      AName:=DateTimePicker.Name;
      ADate:=DateTimePicker.DateTime;
      AChecked:=DateTimePicker.Checked;
      GetLabelsByWinControl(DateTimePicker,List);
      NewClass:=AClass;
      if not Assigned(NewClass) then
        NewClass:=TEditDate;
      AEditDate:=NewClass.Create(DateTimePicker.Owner);
      AEditDate.Parent:=DateTimePicker.Parent;
      AEditDate.SetBounds(DateTimePicker.Left,DateTimePicker.Top,DateTimePicker.Width,DateTimePicker.Height);
      AEditDate.TabOrder:=DateTimePicker.TabOrder;
      AEditDate.Enabled:=DateTimePicker.Enabled;
      AEditDate.OnChange:=DateTimePicker.OnChange;
      AEditDate.Color:=DateTimePicker.Color;
      AEditDate.Anchors:=DateTimePicker.Anchors;
      AEditDate.Visible:=DateTimePicker.Visible;
      AEditDate.Hint:=DateTimePicker.Hint;
      AEditDate.Font.Assign(DateTimePicker.Font);
      DateTimePicker.Free;
      DateTimePicker:=nil;
      AEditDate.Name:=AName;
      if AChecked then
        AEditDate.Date:=ADate;
      for i:=0 to List.Count-1 do
        TLabel(List.Items[i]).FocusControl:=AEditDate;

      Result:=AEditDate;
    finally
      LIst.Free;
    end;
  end;
end;

function ReplaceEditToEditPopup(var Edit: TEdit): TEditPopup;
var
  AEditPopup: TEditPopup;
  AName: String;
  AText: String;
  List: TList;
  i: Integer;
begin
  Result:=nil;
  if Assigned(Edit) then begin
    List:=TList.Create;
    try
      AName:=Edit.Name;
      AText:=Edit.Text;
      GetLabelsByWinControl(Edit,List);
      AEditPopup:=TEditPopup.Create(Edit.Owner);
      AEditPopup.Parent:=Edit.Parent;
      AEditPopup.SetBounds(Edit.Left,Edit.Top,Edit.Width,Edit.Height);
      AEditPopup.TabOrder:=Edit.TabOrder;
      AEditPopup.Enabled:=Edit.Enabled;
      AEditPopup.OnChange:=Edit.OnChange;
      AEditPopup.MaxLength:=Edit.MaxLength;
      AEditPopup.Color:=Edit.Color;
      AEditPopup.Alignment:=Edit.Alignment;
      AEditPopup.Anchors:=Edit.Anchors;
      AEditPopup.Visible:=Edit.Visible;
      AEditPopup.ReadOnly:=Edit.ReadOnly;
      AEditPopup.Hint:=Edit.Hint;
      AEditPopup.Font.Assign(Edit.Font);
      Edit.Free;
      Edit:=nil;
      AEditPopup.Name:=AName;
      AEditPopup.Text:=AText;
      for i:=0 to List.Count-1 do
        TLabel(List.Items[i]).FocusControl:=AEditPopup;
      Result:=AEditPopup;
    finally
      List.Free;
    end;
  end;
end;

function ReplaceEditToEditCurrency(var Edit: TEdit): TEditCurrency;
var
  AEditCurrency: TEditCurrency;
  AName: String;
  AText: String;
  List: TList;
  i: Integer;
begin
  Result:=nil;
  if Assigned(Edit) then begin
    List:=TList.Create;
    try
      AName:=Edit.Name;
      AText:=Edit.Text;
      GetLabelsByWinControl(Edit,List);
      AEditCurrency:=TEditCurrency.Create(Edit.Owner);
      AEditCurrency.Parent:=Edit.Parent;
      AEditCurrency.SetBounds(Edit.Left,Edit.Top,Edit.Width,Edit.Height);
      AEditCurrency.TabOrder:=Edit.TabOrder;
      AEditCurrency.Enabled:=Edit.Enabled;
      AEditCurrency.OnChange:=Edit.OnChange;
      AEditCurrency.MaxLength:=Edit.MaxLength;
      AEditCurrency.Color:=Edit.Color;
      AEditCurrency.Alignment:=Edit.Alignment;
      AEditCurrency.Anchors:=Edit.Anchors;
      AEditCurrency.Visible:=Edit.Visible;
      AEditCurrency.ReadOnly:=Edit.ReadOnly;
      AEditCurrency.Hint:=Edit.Hint;
      AEditCurrency.Font.Assign(Edit.Font);
      Edit.Free;
      Edit:=nil;
      AEditCurrency.Name:=AName;
      AEditCurrency.Text:=AText;
      for i:=0 to List.Count-1 do
        TLabel(List.Items[i]).FocusControl:=AEditCurrency;
      Result:=AEditCurrency;
    finally
      List.Free;
    end;
  end;
end;

function ReplaceEditToEditCalc(var Edit: TEdit): TEditCalc;
var
  AEditCalc: TEditCalc;
  AName: String;
  AText: String;
  List: TList;
  i: Integer;
begin
  Result:=nil;
  if Assigned(Edit) then begin
    List:=TList.Create;
    try
      AName:=Edit.Name;
      AText:=Edit.Text;
      GetLabelsByWinControl(Edit,List);
      AEditCalc:=TEditCalc.Create(Edit.Owner);
      AEditCalc.Parent:=Edit.Parent;
      AEditCalc.SetBounds(Edit.Left,Edit.Top,Edit.Width,Edit.Height);
      AEditCalc.TabOrder:=Edit.TabOrder;
      AEditCalc.Enabled:=Edit.Enabled;
      AEditCalc.OnChange:=Edit.OnChange;
      AEditCalc.MaxLength:=Edit.MaxLength;
      AEditCalc.Color:=Edit.Color;
      AEditCalc.Alignment:=Edit.Alignment;
      AEditCalc.Anchors:=Edit.Anchors;
      AEditCalc.Visible:=Edit.Visible;
      AEditCalc.Hint:=Edit.Hint;
      AEditCalc.ReadOnly:=Edit.ReadOnly;
      AEditCalc.Font.Assign(Edit.Font);
      Edit.Free;
      Edit:=nil;
      AEditCalc.Name:=AName;
      AEditCalc.Text:=AText;
      for i:=0 to List.Count-1 do
        TLabel(List.Items[i]).FocusControl:=AEditCalc;
      Result:=AEditCalc;
    finally
      List.Free;
    end;
  end;
end;

function ReplaceMemoToSynEdit(var Memo: TMemo): TSynEdit;
var
  ASynEdit: TSynEdit;
  AName: String;
  AText: String;
  List: TList;
  i: Integer;
begin
  Result:=nil;
  if Assigned(Memo) then begin
    List:=TList.Create;
    try
      AName:=Memo.Name;
      AText:=Memo.Text;
      GetLabelsByWinControl(Memo,List);
      ASynEdit:=TSynEdit.Create(Memo.Owner);
      ASynEdit.Parent:=Memo.Parent;
      ASynEdit.SetBounds(Memo.Left,Memo.Top,Memo.Width,Memo.Height);
      ASynEdit.TabOrder:=Memo.TabOrder;
      ASynEdit.Enabled:=Memo.Enabled;
      ASynEdit.OnChange:=Memo.OnChange;
//      ASynEdit.MaxLength:=Memo.MaxLength;
      ASynEdit.Color:=Memo.Color;
//      ASynEdit.Alignment:=Memo.Alignment;
      ASynEdit.Anchors:=Memo.Anchors;
      ASynEdit.Visible:=Memo.Visible;
      ASynEdit.Hint:=Memo.Hint;
      ASynEdit.ReadOnly:=Memo.ReadOnly;
      ASynEdit.Gutter.Width:=0;
      ASynEdit.RightEdge:=0;
//      ASynEdit.Font.Assign(Memo.Font);
      Memo.Free;
      Memo:=nil;
      ASynEdit.Name:=AName;
      ASynEdit.Text:=AText;
      for i:=0 to List.Count-1 do
        TLabel(List.Items[i]).FocusControl:=ASynEdit;
      Result:=ASynEdit;
    finally
      List.Free;
    end;
  end;
end;

{ TLabel }

constructor TLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFocusControls:=TObjectList.Create;
  FFocusControls.OwnsObjects:=false;
end;

destructor TLabel.Destroy;
begin
  FreeAndNilEx(FFocusControls);
  inherited Destroy;
end;

procedure TLabel.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Assigned(FFocusControls) then begin
    if (Operation = opRemove) then begin
      FFocusControls.Remove(AComponent);
    end;
  end;
end;

{ TEdit }

constructor TEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLabels:=TList.Create;
  FPassword:=False;
end;

destructor TEdit.Destroy;
begin
  FLabels.Free;
  inherited Destroy;
end;

procedure TEdit.SetAlignment(const Value: TAlignment);
begin
  FAlignment := Value;
  ReCreateWnd;
end;

procedure TEdit.SetPassword(const Value: Boolean);
begin
  if FPassword <> Value then begin
    FPassword := Value;
    PasswordChar:=#0;
    RecreateWnd;
  end;
end;

procedure TEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  if Assigned(Parent) then
    case FAlignment of
      taLeftJustify:
        Params.Style := Params.Style or ES_LEFT;
      taRightJustify:
        Params.Style := Params.Style or ES_RIGHT;
      taCenter:
        Params.Style := Params.Style or ES_CENTER;
    end;

  if FPassword then
    Params.Style := Params.Style or ES_PASSWORD;
end;

procedure TEdit.CMEnter(var Message: TCMEnter);
begin
  FOldColor:=Color;
  Color:=iff(Color<>ColorControlReadOnly,ColorControlFocused,Color);
  GetLabelsByWinControl(Self,FLabels);
  FOldLabelColor:=GetLabelsColor(FLabels,ColorControlLabelFocused,FOldLabelColor);
  inherited;
end;

procedure TEdit.CMExit(var Message: TCMExit);
begin
  GetLabelsByWinControl(Self,FLabels);
  GetLabelsColor(FLabels,FOldLabelColor,FOldLabelColor);
  Color:=FOldColor;
  inherited;
end;

{ TLabeledEdit }

constructor TLabeledEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLabels:=TList.Create;
  FLabels.Add(EditLabel);
  FPassword:=false;
end;


procedure TLabeledEdit.CreateParams(var Params: TCreateParams);
begin
  inherited;
  if FPassword then
    Params.Style := Params.Style or ES_PASSWORD;
end;

destructor TLabeledEdit.Destroy;
begin
  FLabels.Free;
  inherited;
end;

procedure TLabeledEdit.SetPassword(const Value: Boolean);
begin
  if FPassword <> Value then begin
    FPassword := Value;
    PasswordChar:=#0;
    RecreateWnd;
  end;
end;

procedure TLabeledEdit.CMEnter(var Message: TCMEnter);
begin
  FOldColor:=Color;
  Color:=iff(Color<>ColorControlReadOnly,ColorControlFocused,Color);
  FOldLabelColor:=GetLabelsColor(FLabels,ColorControlLabelFocused,FOldLabelColor);
  inherited;
end;

procedure TLabeledEdit.CMExit(var Message: TCMExit);
begin
  GetLabelsColor(FLabels,FOldLabelColor,FOldLabelColor);
  Color:=FOldColor;
  inherited;
end;

{ TMemo }

constructor TMemo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLabels:=TList.Create;
end;

destructor TMemo.Destroy;
begin
  FLabels.Free;
  inherited Destroy;
end;

procedure TMemo.CMEnter(var Message: TCMEnter);
begin
  FOldColor:=Color;
  Color:=iff(Color<>ColorControlReadOnly,ColorControlFocused,Color);
  GetLabelsByWinControl(Self,FLabels);
  FOldLabelColor:=GetLabelsColor(FLabels,ColorControlLabelFocused,FOldLabelColor);
  inherited;
end;

procedure TMemo.CMExit(var Message: TCMExit);
begin
  GetLabelsByWinControl(Self,FLabels);
  GetLabelsColor(FLabels,FOldLabelColor,FOldLabelColor);
  Color:=FOldColor;
  inherited;
end;

{ TRichEdit }

constructor TRichEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLabels:=TList.Create;
end;

destructor TRichEdit.Destroy;
begin
  FLabels.Free;
  inherited Destroy;
end;

procedure TRichEdit.CMEnter(var Message: TCMEnter);
begin
  FOldColor:=Color;
  Color:=iff(Color<>ColorControlReadOnly,ColorControlFocused,Color);
  GetLabelsByWinControl(Self,FLabels);
  FOldLabelColor:=GetLabelsColor(FLabels,ColorControlLabelFocused,FOldLabelColor);
  inherited;
end;

procedure TRichEdit.CMExit(var Message: TCMExit);
begin
  GetLabelsByWinControl(Self,FLabels);
  GetLabelsColor(FLabels,FOldLabelColor,FOldLabelColor);
  Color:=FOldColor;
  inherited;
end;

{ TSynEdit }

constructor TSynEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLabels:=TList.Create;
end;

destructor TSynEdit.Destroy;
begin
  FLabels.Free;
  inherited Destroy;
end;

procedure TSynEdit.CMEnter(var Message: TCMEnter);
begin
  FOldColor:=Color;
  Color:=iff(Color<>ColorControlReadOnly,ColorControlFocused,Color);
  GetLabelsByWinControl(Self,FLabels);
  FOldLabelColor:=GetLabelsColor(FLabels,ColorControlLabelFocused,FOldLabelColor);
  inherited;
end;

procedure TSynEdit.CMExit(var Message: TCMExit);
begin
  GetLabelsByWinControl(Self,FLabels);
  GetLabelsColor(FLabels,FOldLabelColor,FOldLabelColor);
  Color:=FOldColor;
  inherited;
end;

{ TListBox }

constructor TListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLabels:=TList.Create;
end;

destructor TListBox.Destroy;
begin
  FLabels.Free;
  inherited Destroy;
end;

function TListBox.CanFocus: Boolean;
begin
  Result:=inherited CanFocus;
end;

procedure TListBox.CMEnter(var Message: TCMEnter);
begin
  FOldColor:=Color;
  Color:=iff(Color<>ColorControlReadOnly,ColorControlFocused,Color);
  GetLabelsByWinControl(Self,FLabels);
  FOldLabelColor:=GetLabelsColor(FLabels,ColorControlLabelFocused,FOldLabelColor);
  inherited;
end;

procedure TListBox.CMExit(var Message: TCMExit);
begin
  GetLabelsByWinControl(Self,FLabels);
  GetLabelsColor(FLabels,FOldLabelColor,FOldLabelColor);
  Color:=FOldColor;
  inherited;
end;

{ TCheckListBox }

constructor TCheckListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLabels:=TList.Create;
end;

destructor TCheckListBox.Destroy;
begin
  FLabels.Free;
  inherited Destroy;
end;

procedure TCheckListBox.CMEnter(var Message: TCMEnter);
begin
  FOldColor:=Color;
  Color:=iff(Color<>ColorControlReadOnly,ColorControlFocused,Color);
  GetLabelsByWinControl(Self,FLabels);
  FOldLabelColor:=GetLabelsColor(FLabels,ColorControlLabelFocused,FOldLabelColor);
  inherited;
end;

procedure TCheckListBox.CMExit(var Message: TCMExit);
begin
  GetLabelsByWinControl(Self,FLabels);
  GetLabelsColor(FLabels,FOldLabelColor,FOldLabelColor);
  Color:=FOldColor;
  inherited;
end;

{ TComboBox }

constructor TComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLabels:=TList.Create;
end;

destructor TComboBox.Destroy;
begin
  FLabels.Free;
  inherited Destroy;
end;

function TComboBox.CanFocus: Boolean;
begin
  Result:=inherited CanFocus and Enabled;
end;

procedure TComboBox.CMEnter(var Message: TCMEnter);
begin
  FOldColor:=Color;
  Color:=iff(Color<>ColorControlReadOnly,ColorControlFocused,Color);
  GetLabelsByWinControl(Self,FLabels);
  FOldLabelColor:=GetLabelsColor(FLabels,ColorControlLabelFocused,FOldLabelColor);
  inherited;
end;

procedure TComboBox.CMExit(var Message: TCMExit);
begin
  GetLabelsByWinControl(Self,FLabels);
  GetLabelsColor(FLabels,FOldLabelColor,FOldLabelColor);
  Color:=FOldColor;
  inherited;
end;

{ TColorBox }

constructor TColorBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLabels:=TList.Create;
end;

destructor TColorBox.Destroy;
begin
  FLabels.Free;
  inherited Destroy;
end;

procedure TColorBox.CMEnter(var Message: TCMEnter);
begin
  FOldColor:=Color;
  Color:=iff(Color<>ColorControlReadOnly,ColorControlFocused,Color);
  GetLabelsByWinControl(Self,FLabels);
  FOldLabelColor:=GetLabelsColor(FLabels,ColorControlLabelFocused,FOldLabelColor);
  inherited;
end;

procedure TColorBox.CMExit(var Message: TCMExit);
begin
  GetLabelsByWinControl(Self,FLabels);
  GetLabelsColor(FLabels,FOldLabelColor,FOldLabelColor);
  Color:=FOldColor;
  inherited;
end;

{ TDateTimePicker }

constructor TDateTimePicker.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLabels:=TList.Create;
end;

destructor TDateTimePicker.Destroy;
begin
  FLabels.Free;
  inherited Destroy;
end;


procedure TDateTimePicker.CMEnter(var Message: TCMEnter);
begin
  FOldColor:=Color;
  Color:=iff(Color<>ColorControlReadOnly,ColorControlFocused,Color);
  GetLabelsByWinControl(Self,FLabels);
  FOldLabelColor:=GetLabelsColor(FLabels,ColorControlLabelFocused,FOldLabelColor);
  inherited;
end;

procedure TDateTimePicker.CMExit(var Message: TCMExit);
begin
  GetLabelsByWinControl(Self,FLabels);
  GetLabelsColor(FLabels,FOldLabelColor,FOldLabelColor);
  Color:=FOldColor;
  inherited;
end;

{ TDBEdit }

procedure TDBEdit.CMEnter(var Message: TCMEnter);
var
  lb: TLabel;
begin
  FOldColor:=Color;
  Color:=iff(Color<>ColorControlReadOnly,ColorControlFocused,Color);
  lb:=GetLabelByWinControl(Self);
  if lb<>nil then begin
    FOldLabelColor:=lb.Font.Color;
    lb.Font.Color:=ColorControlLabelFocused;
  end;
  inherited;
end;

procedure TDBEdit.CMExit(var Message: TCMExit);
var
  lb: TLabel;
begin
  lb:=GetLabelByWinControl(Self);
  if lb<>nil then begin
    lb.Font.Color:=FOldLabelColor;
  end;
  Color:=FOldColor;
  inherited;
end;

{ TDBMemo }

procedure TDBMemo.CMEnter(var Message: TCMEnter);
var
  lb: TLabel;
begin
  FOldColor:=Color;
  Color:=iff(Color<>ColorControlReadOnly,ColorControlFocused,Color);
  lb:=GetLabelByWinControl(Self);
  if lb<>nil then begin
    FOldLabelColor:=lb.Font.Color;
    lb.Font.Color:=ColorControlLabelFocused;
  end;
  inherited;
end;

procedure TDBMemo.CMExit(var Message: TCMExit);
var
  lb: TLabel;
begin
  lb:=GetLabelByWinControl(Self);
  if lb<>nil then begin
    lb.Font.Color:=FOldLabelColor;
  end;
  Color:=FOldColor;
  inherited;
end;

{ TDateEdit }

constructor TEditDate.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLabels:=TList.Create;
end;

destructor TEditDate.Destroy;
begin
  FLabels.Free;
  inherited Destroy;
end;

procedure TEditDate.CMEnter(var Message: TCMEnter);
begin
  FOldColor:=Color;
  Color:=iff(Color<>ColorControlReadOnly,ColorControlFocused,Color);
  GetLabelsByWinControl(Self,FLabels);
  FOldLabelColor:=GetLabelsColor(FLabels,ColorControlLabelFocused,FOldLabelColor);
  inherited;
end;

procedure TEditDate.CMExit(var Message: TCMExit);
begin
  GetLabelsByWinControl(Self,FLabels);
  GetLabelsColor(FLabels,FOldLabelColor,FOldLabelColor);
  Color:=FOldColor;
  inherited;
end;

function TEditDate.GetDate2: Variant;
var
  S: String;
begin
  if Date<>NullDate then begin
    S:=DateToStr(Date);
    Result:=StrToDate(S);
  end else begin
    Result:=Null;
  end;
end;

procedure TEditDate.SetDate2(Value: Variant);
var
  V: Variant;
  S: String;
begin
  V:=Value;
  if VarType(V)=varString then begin
    S:=VarToStrDef(V,'');
    V:=StrToDateDef(S,Date);
  end;
  Date:=VarToDateDef(V,Date);
end;

{ TEditPopup }

constructor TEditPopup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLabels:=TList.Create;
end;

destructor TEditPopup.Destroy;
begin
  FLabels.Free;
  inherited Destroy;
end;


procedure TEditPopup.CMEnter(var Message: TCMEnter);
begin
  FOldColor:=Color;
  Color:=iff(Color<>ColorControlReadOnly,ColorControlFocused,Color);
  GetLabelsByWinControl(Self,FLabels);
  FOldLabelColor:=GetLabelsColor(FLabels,ColorControlLabelFocused,FOldLabelColor);
  inherited;
end;

procedure TEditPopup.CMExit(var Message: TCMExit);
begin
  GetLabelsByWinControl(Self,FLabels);
  GetLabelsColor(FLabels,FOldLabelColor,FOldLabelColor);
  Color:=FOldColor;
  inherited;
end;

{ TEditCurrency }

constructor TEditCurrency.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLabels:=TList.Create;
end;

destructor TEditCurrency.Destroy;
begin
  FLabels.Free;
  inherited Destroy;
end;


procedure TEditCurrency.CMEnter(var Message: TCMEnter);
begin
  FOldColor:=Color;
  Color:=iff(Color<>ColorControlReadOnly,ColorControlFocused,Color);
  GetLabelsByWinControl(Self,FLabels);
  FOldLabelColor:=GetLabelsColor(FLabels,ColorControlLabelFocused,FOldLabelColor);
  inherited;
end;

procedure TEditCurrency.CMExit(var Message: TCMExit);
begin
  GetLabelsByWinControl(Self,FLabels);
  GetLabelsColor(FLabels,FOldLabelColor,FOldLabelColor);
  Color:=FOldColor;
  inherited;
end;

{ TEditCalc }

constructor TEditCalc.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLabels:=TList.Create;
  CheckOnExit:=false;
end;

destructor TEditCalc.Destroy;
begin
  FLabels.Free;
  inherited Destroy;
end;

function TEditCalc.GetValue: Variant;
begin
  Result:=Null;
  if Trim(Text)<>'' then
    Result:=inherited Value;
end;

procedure TEditCalc.SetValue(const AValue: Variant);
begin
  if VarIsNull(AValue) then
    Text:=''
  else
    inherited Value:=VarToExtendedDef(AValue,0.0);
end;

procedure TEditCalc.CMEnter(var Message: TCMEnter);
begin
  FOldColor:=Color;
  Color:=iff(Color<>ColorControlReadOnly,ColorControlFocused,Color);
  GetLabelsByWinControl(Self,FLabels);
  FOldLabelColor:=GetLabelsColor(FLabels,ColorControlLabelFocused,FOldLabelColor);
  inherited;
end;

procedure TEditCalc.CMExit(var Message: TCMExit);
begin
  GetLabelsByWinControl(Self,FLabels);
  GetLabelsColor(FLabels,FOldLabelColor,FOldLabelColor);
  Color:=FOldColor;
  inherited;
end;

{ TEditInteger }

constructor TEditInteger.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMaxValue:=MaxInt;
  FMinValue:=-MaxInt;
  MaxLength:=10;
  Width:=60;
  AutoSize:=true;
  Alignment:=taRightJustify;
  Text:='';
end;

function TEditInteger.GetValue: Integer;
begin
  if Text = '' then
    Result := 0
  else
    Result := StrToIntDef(Text, 0);
end;

procedure TEditInteger.SetValue(Value: Integer);
begin
  Text:=IntToStr(ChopToRange(Value));
end;

function TEditInteger.ChopToRange(Value: Integer): Integer;
begin
  Result := Value;
  if (Value > MaxValue) then
    Result := MaxValue;

  if (Value < MinValue) then
    Result := MinValue;
end;

procedure TEditInteger.SetMaxValue(Value: Integer);
begin
  FMaxValue := Value;
  if MinValue > MaxValue then
    FMinValue := MaxValue;
end;

procedure TEditInteger.SetMinValue(Value: Integer);
begin
  FMinValue := Value;
  if MaxValue < MaxValue then
    FMaxValue := MinValue;
end;

function TEditInteger.IsInRange(Value: Integer): boolean;
begin
  Result := True;
  if (Value > MaxValue) then
    Result := False;
  if (Value < MinValue) then
    Result := False;
end;

function TEditInteger.IsInRange(Value: String): boolean;
var
  eValue: Integer;
begin
  if Value = '' then
    eValue := 0
  else
    eValue := StrToIntDef(Value, 0);

  Result := IsInRange(eValue);
end;

procedure TEditInteger.KeyPress(var Key: Char);
var
  lsNewText: string;
begin
  if (Ord(Key)) < Ord(' ') then
  begin
    if Key = #13 then Key := #0 else
    inherited KeyPress(Key);
    exit;
  end;

  if not CharIsDigit(Key) and (Key <> '-') then
    Key := #0;

  if Key = '-' then
  begin
    if (MinValue >= 0) then
      Key := #0
    else if SelStart <> 0 then
      Key := #0;

    if StrLeft(lsNewText, 2) = '--' then
      Key := #0;
  end;

  if (SelStart = 0) and (Key = '0') and (StrLeft(lsNewText, 1) = '0') then
    Key := #0;

  if (SelStart = 1) and (Key = '0') and (StrLeft(lsNewText, 2) = '-0') then
    Key := #0;

  lsNewText := GetChangedText(Text, SelStart, SelLength, Key);
  if not IsInRange(lsNewText) then
    Key := #0;

  if Key <> #0 then
    inherited;
end;

{$HINTS OFF}
procedure TEditInteger.WMPaste(var Msg: TMessage);
var
  PasteText: string;
  Buffer: Integer;
  E: Integer;
begin
  Clipboard.Open;
  PasteText:=Clipboard.AsText;
  Clipboard.Close;
  Val(PasteText, Buffer, E);
  if E = 0 then
    inherited;
end;
{$HINTS ON}

{ TEditFloat }

constructor TEditFloat.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width:=70;
  FMaxValue:=MaxExtended;
  FMinValue:=-MaxExtended;
  FDecimals:=MaxDecimals;
  AutoSize:=true;
  MaxLength:=MaxDecimals;
  Alignment:=taRightJustify;
  Text:='';
end;

function TEditFloat.GetValue: Extended;
begin
  if Text = '' then
    Result := 0.0
  else
    Result := StrToFloatDef(Text, 0.0);
end;

procedure TEditFloat.SetValue(Value: Extended);
begin
  if  (Value<>0.0) then
    if (FDisplayFormat<>'') then begin
      Text:=FormatFloat(FDisplayFormat,ChopToRange(Value));
    end else
      Text:=FloatToStr(ChopToRange(Value))
end;

function TEditFloat.ChopToRange(Value: Extended): Extended;
begin
  Result := Value;
  if (Value > MaxValue) then
    Result := MaxValue;

  if (Value < MinValue) then
    Result := MinValue;
end;

procedure TEditFloat.SetDecimals(Value: Integer);
begin
  if Value < 0 then
    Value := 0;
  if Value > MaxDecimals then
    Value := MaxDecimals;
  FDecimals := Value;
end;

procedure TEditFloat.SetDisplayFormat(const Value: String);
begin
  FDisplayFormat := Value;
  SetValue(Self.Value);
end;

procedure TEditFloat.SetMaxValue(Value: Extended);
begin
  FMaxValue := Value;
  if MinValue > MaxValue then
    FMinValue := MaxValue;
end;

procedure TEditFloat.SetMinValue(Value: Extended);
begin
  FMinValue := Value;
  if MaxValue < MaxValue then
    FMaxValue := MinValue;
end;

function TEditFloat.IsInRange(Value: Extended): boolean;
begin
  Result := True;
  if (Value > MaxValue) then
    Result := False;
  if (Value < MinValue) then
    Result := False;
end;

function TEditFloat.IsInRange(Value: String): boolean;
var
  eValue: extended;
begin
  if Value = '' then
    eValue := 0.0
  else
    eValue := StrToFloatDef(Value, 0.0);

  Result := IsInRange(eValue);
end;

procedure TEditFloat.KeyPress(var Key: Char);
var
  lsNewText: string;
  iDotPos:   integer;
begin
  if (Ord(Key)) < Ord(' ') then
  begin
    inherited KeyPress(Key);
    exit;
  end;

  if Key in ['.', ','] then
    Key := DecimalSeparator;

  if not CharIsNumber(Key) then
    Key := #0;

  if Key = '-' then
  begin
    if (MinValue >= 0) then
      Key := #0
    else if SelStart <> 0 then
      Key := #0;

    if StrLeft(lsNewText, 2) = '--' then
      Key := #0;
  end;

  if (SelStart = 0) and (Key = '0') and (StrLeft(lsNewText, 1) = '0') then
    Key := #0;

  if (SelStart = 1) and (Key = '0') and (StrLeft(lsNewText, 2) = '-0') then
    Key := #0;


  iDotPos := Pos(DecimalSeparator, Text);

  if Key =DecimalSeparator then
  begin
    if (iDotPos > 0) and not ((SelLength > 0) and (SelStart <= iDotPos) and ((SelStart + SelLength) >= iDotPos)) then
      Key := #0
  end;

  if (iDotPos > 0) and (SelStart > iDotPos) and
    ((Length(Text) - iDotPos) >= FDecimals) then
  begin
    Key := #0;
  end;

  lsNewText := GetChangedText(Text, SelStart, SelLength, Key);
  if not IsInRange(lsNewText) then
    Key := #0;

  if Key <> #0 then
    inherited;
end;

procedure TEditFloat.WMPaste(var Msg: TMessage);
var
  PasteText: string;
  Buffer: Extended;
begin
  Clipboard.Open;
  PasteText:=Clipboard.AsText;
  Clipboard.Close;
  if TextToFloat(PChar(PasteText), Buffer , fvExtended) then
    inherited;
end;

procedure TEditFloat.Change;
begin
  inherited Change;
end;

{ THotKey }

constructor THotKey.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLabels:=TList.Create;
end;

destructor THotKey.Destroy;
begin
  FLabels.Free;
  inherited Destroy;
end;


procedure THotKey.CMEnter(var Message: TCMEnter);
begin
  FOldColor:=Color;
  Color:=iff(Color<>ColorControlReadOnly,ColorControlFocused,Color);
  GetLabelsByWinControl(Self,FLabels);
  FOldLabelColor:=GetLabelsColor(FLabels,ColorControlLabelFocused,FOldLabelColor);
  inherited;
end;

procedure THotKey.CMExit(var Message: TCMExit);
begin
  GetLabelsByWinControl(Self,FLabels);
  GetLabelsColor(FLabels,FOldLabelColor,FOldLabelColor);
  Color:=FOldColor;
  inherited;
end;

end.