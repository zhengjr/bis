unit BisParam;

interface

uses Classes, Contnrs, Controls, DB, Variants,
     BisFilterGroups;

type
  TBisParam=class;

  TBisParamChangeEvent=procedure(Param: TBisParam) of object;
  TBisParamFindEvent=function (ParamName: String; Counter: Integer): TBisParam of object;
  TBisParamLinkControlsEvent=procedure (Parent: TWinControl) of object;
  TBisParamFindComponentEvent=function (Param: TBisParam; ComponentName: String): TComponent of object;

  TBisParamEditMode=(emInsert,emDuplicate,emUpdate,emDelete,emFilter,emView);
  TBisParamEditModes=set of TBisParamEditMode;

  TBisParam=class(TObject)
  private
    FTempValue: Variant;
    FParamName: String;
    FParamType: TParamType;
    FDataType: TFieldType;
    FIsKey: Boolean;
    FDefaultValue: Variant;
    FRequired: Boolean;
    FStoredValue: Variant;
    FOnChange: TBisParamChangeEvent;
    FOnKeyDown: TKeyEvent;
    FOlders: TStringList;
    FOnLinkControls: TBisParamLinkControlsEvent;
    FOnFind: TBisParamFindEvent;
    FOldValue: Variant;
    FFirstOldValue: Boolean;
    FModes: TBisParamEditModes;
    FFilterCondition: TBisFilterCondition;
    FParamFormat: String;
    FFilterCaption: String;
    FOnFindComponent: TBisParamFindComponentEvent;
    FDuplicates: TStringList;
    FCaptionName: String;
    FControlName: String;
//    FEmptyValue: Variant;
    function GetAsDateTime: TDateTime;
    function GetAsExtended: Extended;
    function GetAsInteger: Integer;
    function GetAsString: string;
    function GetAsBoolean: Boolean;
  protected
    function UseTempValue: Boolean; virtual;
    function GetValue: Variant; virtual;
    procedure SetValue(const AValue: Variant); virtual;
    function GetSize: Integer; virtual;
    procedure SetSize(const Value: Integer); virtual;
    function GetPrecision: Integer; virtual;
    procedure SetPrecision(const Value: Integer); virtual;
    function GetEmpty: Boolean; virtual;
    function GetCaption: String; virtual;
    function GetControl: TWinControl; virtual;
    function GetAuto: Boolean; virtual;
    procedure SetAlignment(const Value: TAlignment); virtual;
    function GetAlignment: TAlignment; virtual;
    function GetVisible: Boolean; virtual;
    function GetEnabled: Boolean; virtual;
    procedure SetEnabled(const Value: Boolean); virtual;
    procedure SetVisible(const Value: Boolean); virtual;
    procedure GetControls(List: TList); virtual;
    function GetEmptyValue: Variant; virtual;
    function UseInFilter: Boolean; virtual;
    procedure GetFilters(Group: TBisFilterGroup); virtual;

    procedure DoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    function DoFindComponent(ComponentName: String): TComponent;

  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure CopyFrom(Source: TBisParam; WithReset: Boolean=true); virtual;
    procedure LinkControls(Parent: TWinControl); virtual;
    procedure WriteData(Writer: TWriter); virtual;
    procedure ReadData(Reader: TReader); virtual;
    procedure Refresh; virtual;
    procedure Clear; virtual;
    function Same(const AParamName: String): Boolean; virtual;

    procedure DoChange(Sender: TBisParam);
    procedure ValueToStored;
    procedure Older(const FieldName: String);
    procedure Reset; virtual;
    function Find(ParamName: String; Counter: Integer=0): TBisParam;
    function Changed: Boolean;
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromFile(const FileName: String);
    procedure SaveToFile(const FileName: String);
    procedure SetNewValue(AValue: Variant);
    procedure SetAutoValue;
    procedure ExcludeModes(AModes: TBisParamEditModes);
    procedure CopyToFilterGroups(FilterGroups: TBisFilterGroups);

    property ParamName: String read FParamName write FParamName;
    property ParamType: TParamType read FParamType write FParamType;
    property ParamFormat: String read FParamFormat write FParamFormat;
    property Value: Variant read GetValue write SetValue;
    property DataType: TFieldType read FDataType write FDataType;
    property IsKey: Boolean read FIsKey write FIsKey;
    property DefaultValue: Variant read FDefaultValue write FDefaultValue;
    property Size: Integer read GetSize write SetSize;
    property Precision: Integer read GetPrecision write SetPrecision;
    property Required: Boolean read FRequired write FRequired;
    property StoredValue: Variant read FStoredValue write FStoredValue;
    property OldValue: Variant read FOldValue write FOldValue;
    property Alignment: TAlignment read GetAlignment write SetAlignment;
    property Modes: TBisParamEditModes read FModes write FModes;
    property Visible: Boolean read GetVisible write SetVisible;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property FilterCondition: TBisFilterCondition read FFilterCondition write FFilterCondition;
    property FilterCaption: String read FFilterCaption write FFilterCaption;
    property CaptionName: String read FCaptionName write FCaptionName;
    property ControlName: String read FControlName write FControlName;
//    property EmptyValue: Variant read FEmptyValue write FEmptyValue;

    property Caption: String read GetCaption;
    property Empty: Boolean read GetEmpty;
    property Control: TWinControl read GetControl;
    property Auto: Boolean read GetAuto;
    property Olders: TStringList read FOlders;
    property Duplicates: TStringList read FDuplicates;

    property AsDateTime: TDateTime read GetAsDateTime;
    property AsExtended: Extended read GetAsExtended;
    property AsInteger: Integer read GetAsInteger;
    property AsString: string read GetAsString;
    property AsBoolean: Boolean read GetAsBoolean;


    property OnChange: TBisParamChangeEvent read FOnChange write FOnChange;
    property OnKeyDown: TKeyEvent read FOnKeyDown write FOnKeyDown;
    property OnLinkControls: TBisParamLinkControlsEvent read FOnLinkControls write FOnLinkControls;
    property OnFind: TBisParamFindEvent read FOnFind write FOnFind;
    property OnFindComponent: TBisParamFindComponentEvent read FOnFindComponent write FOnFindComponent;
  end;

  TBisParamClass=class of TBisParam;

const
  AllParamEditModes=[emInsert,emDuplicate,emUpdate,emDelete,emFilter,emView];

implementation

uses SysUtils, TypInfo,
     BisUtils, BisControls, BisConsts, BisVariants;

{ TBisParam }

constructor TBisParam.Create;
begin
  inherited Create;
  FOlders:=TStringList.Create;
  FDuplicates:=TStringList.Create;
  FModes:=[emInsert,emDuplicate,emUpdate,emDelete,emFilter,emView];
  FFilterCondition:=fcEqual;
  FTempValue:=Null;
//  FEmptyValue:=Null;
end;

destructor TBisParam.Destroy;
begin
  FDuplicates.Free;
  FOlders.Free;
  inherited Destroy;
end;

procedure TBisParam.DoChange(Sender: TBisParam);
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

function TBisParam.DoFindComponent(ComponentName: String): TComponent;
begin
  Result:=nil;
  if Assigned(FOnFindComponent) then
    Result:=FOnFindComponent(Self,ComponentName);
end;

procedure TBisParam.DoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Assigned(FOnKeyDown) then
    FOnKeyDown(Sender,Key,Shift);
end;

procedure TBisParam.ExcludeModes(AModes: TBisParamEditModes);
begin
  FModes:=FModes-AModes;
end;

procedure TBisParam.Older(const FieldName: String);
begin
  FOlders.Add(FieldName);
end;

function TBisParam.Find(ParamName: String; Counter: Integer=0): TBisParam;
begin
  Result:=nil;
  if Assigned(FOnFind) then
    Result:=FOnFind(ParamName,Counter);
end;

procedure TBisParam.CopyFrom(Source: TBisParam; WithReset: Boolean);
begin
  if Assigned(Source) then begin
    if WithReset then begin
      Reset;
      Source.Reset;
    end;

    OldValue:=Source.OldValue;
    FFirstOldValue:=Source.FFirstOldValue;
    ParamName:=Source.ParamName;
    ParamType:=Source.ParamType;
    ParamFormat:=Source.ParamFormat;
    Value:=Source.Value;
    DataType:=Source.DataType;
    IsKey:=Source.IsKey;
    DefaultValue:=Source.DefaultValue;
    Size:=Source.Size;
    Precision:=Source.Precision;
    Required:=Source.Required;
    StoredValue:=Source.StoredValue;
    Alignment:=Source.Alignment;
    Modes:=Source.Modes;
    Visible:=Source.Visible;
    Enabled:=Source.Enabled;
    FilterCondition:=Source.FilterCondition;
    FilterCaption:=Source.FilterCaption;
    CaptionName:=Source.CaptionName;
    ControlName:=Source.ControlName;
//    EmptyValue:=Source.EmptyValue;
    Olders.Assign(Source.Olders);
    Duplicates.Assign(Source.Duplicates);
    OnChange:=Source.OnChange;
    OnKeyDown:=Source.OnKeyDown;
    OnLinkControls:=Source.OnLinkControls;
  end;
end;

procedure TBisParam.GetFilters(Group: TBisFilterGroup);
var
  Param2: TBisParam;
  Condition: TBisFilterCondition;
  Filter: TBisFilter;
  Str: TStringList;
  j: Integer;
  AValue: Variant;
  Flag: Boolean;
  S: String;
begin
  if Assigned(Group) then begin
    Condition:=FilterCondition;
    case DataType of
      ftString,ftMemo: Condition:=fcLike;
    end;
    Str:=TStringList.Create;
    try
      S:=ParamName;
      if Duplicates.Count>0 then
        S:=Duplicates[Duplicates.Count-1];
      
      GetStringsByString(S,SFieldDelim,Str);
      for j:=0 to Str.Count-1 do begin
        AValue:=Value;
        Flag:=true;
        if not AnsiSameText(S,Str.Strings[j]) then begin
          Param2:=Find(Str.Strings[j]);
          if Assigned(Param2) then begin
            AValue:=Param2.Value;
          end else
            Flag:=false;
        end;
        if Flag then begin
          Filter:=Group.Filters.Add(Str.Strings[j],Condition,AValue);
          Filter.CheckCase:=false;
          Filter.LeftSide:=true;
        end;
      end;
    finally
      Str.Free;
    end;
  end;
end;

function TBisParam.UseInFilter: Boolean;
begin
  Result:=Visible and Enabled and not Empty and
          not (DataType in [ftBlob,ftOraBlob]);
end;

procedure TBisParam.CopyToFilterGroups(FilterGroups: TBisFilterGroups);
var
  Group: TBisFilterGroup;
  S: String;
begin
  if UseInFilter then begin
    S:=Caption;
    if Trim(FilterCaption)<>'' then
      S:=FilterCaption;
    Group:=FilterGroups.AddByName(S,foAnd,true);
    if Assigned(Group) then
      GetFilters(Group);
  end;
end;

function TBisParam.GetAlignment: TAlignment;
begin
  Result:=taLeftJustify;
end;

function TBisParam.GetAsBoolean: Boolean;
begin
  Result:=Boolean(AsInteger);
end;

function TBisParam.GetAsDateTime: TDateTime;
begin
  Result:=VarToDateDef(Value,0.0);
end;

function TBisParam.GetAsExtended: Extended;
begin
  Result:=VarToExtendedDef(Value,0.0);
end;

function TBisParam.GetAsInteger: Integer;
begin
  Result:=VarToIntDef(Value,0);
end;

function TBisParam.GetAsString: string;
begin
  Result:=VarToStrDef(Value,'');
end;

function TBisParam.GetAuto: Boolean;
begin
  Result:=false;
end;

function TBisParam.GetCaption: String;
var
  Component: TComponent;
begin
  Result:='';
  if Trim(FCaptionName)<>'' then begin
    Component:=DoFindComponent(FCaptionName);
    if Assigned(Component) then begin
      Result:=GetStrProp(Component,'Caption');
    end;
  end;
end;

function TBisParam.GetControl: TWinControl;
var
  Component: TComponent;
begin
  Result:=nil;
  if Trim(FControlName)<>'' then begin
    Component:=DoFindComponent(FControlName);
    if Assigned(Component) and (Component is TWinControl) then begin
      Result:=TWinControl(Component);
    end;
  end;
end;

procedure TBisParam.GetControls(List: TList);
begin
  if Assigned(List) then
    List.Add(Control);
end;

function TBisParam.GetEmptyValue: Variant;
var
  List: TStringList;
  i: Integer;
  Args: TBisVariants;
begin
  Result:=Null;
  if Trim(FParamFormat)<>'' then begin
    List:=TStringList.Create;
    Args:=TBisVariants.Create;
    try
      GetStringsByString(FParamName,SFieldDelim,List);
      for i:=0 to List.Count-1 do begin
        Args.Add(Null);
      end;
      Result:=FormatEx(FParamFormat,Args);
    finally
      Args.Free;
      List.Free;
    end;
  end;
end;

function TBisParam.GetEmpty: Boolean;
var
  V1, V2: Variant;
begin
  V1:=Value;
  V2:=GetEmptyValue;
  Result:=(VarToStrDef(V1,'')=VarToStrDef(V2,'')) or (VarToStrDef(V1,'')='');
end;

function TBisParam.GetPrecision: Integer;
begin
  Result:=0;
end;

function TBisParam.GetSize: Integer;
begin
  Result:=0;
end;

function TBisParam.GetValue: Variant;
begin
  Result:=Null;
  if UseTempValue then
    Result:=FTempValue;
end;

function TBisParam.GetVisible: Boolean;
begin
  Result:=Trim(Caption)<>'';
  if Assigned(Control) then
    Result:=Result and Control.Visible;
end;

procedure TBisParam.SetVisible(const Value: Boolean);
var
  List: TList;
  i: Integer;
  AControl: TControl;
begin
  List:=TList.Create;
  try
    GetControls(List);
    for i:=0 to List.Count-1 do begin
      AControl:=TControl(List.Items[i]);
      if Assigned(AControl) then begin
        AControl.Visible:=Value;
      end;
    end;
  finally
    List.Free;
  end;
end;

function TBisParam.UseTempValue: Boolean;
begin
  Result:=not Assigned(Control);
end;

function TBisParam.GetEnabled: Boolean;
begin
  Result:=true;
  if Assigned(Control) then
    Result:=Result and Control.Enabled;
end;

procedure TBisParam.SetEnabled(const Value: Boolean);
var
  List: TList;
  i: Integer;
  AControl: TControl;
begin
  List:=TList.Create;
  try
    GetControls(List);
    for i:=0 to List.Count-1 do begin
      AControl:=TControl(List.Items[i]);
      if Assigned(AControl) then begin
        AControl.Enabled:=Value;
        if AControl is TWinControl then
          EnableLabelsByWinControl(TWinControl(AControl),Value);
      end;
    end;
  finally
    List.Free;
  end;
end;

procedure TBisParam.LinkControls(Parent: TWinControl);
begin
  FDefaultValue:=Value;
  if Assigned(FOnLinkControls) then
    FOnLinkControls(Parent);
end;

procedure TBisParam.Reset;
begin
  FOldValue:=Null;
  FFirstOldValue:=false;
end;

procedure TBisParam.ValueToStored;
begin

  FStoredValue:=Value;
end;

procedure TBisParam.SetAlignment(const Value: TAlignment);
begin
end;

procedure TBisParam.SetAutoValue;
begin
  if Auto then begin
    Reset;
    FOldValue:=Value;
    DefaultValue:=FOldValue;
  end;
end;

procedure TBisParam.SetPrecision(const Value: Integer);
begin
end;

procedure TBisParam.SetSize(const Value: Integer);
begin
end;

procedure TBisParam.SetValue(const AValue: Variant);
begin
  if UseTempValue then
    FTempValue:=AValue;
  if not FFirstOldValue then begin
    FOldValue:=AValue;
    FFirstOldValue:=true;
  end;
  DoChange(Self);
end;

function TBisParam.Changed: Boolean;
begin
  Result:=not VarSameValue(Value,DefaultValue);
end;

procedure TBisParam.LoadFromStream(Stream: TStream);
var
  Buffer: String;
begin
  SetLength(Buffer,Stream.Size);
  Stream.Read(Pointer(Buffer)^,Stream.Size);
  Value:=Buffer;
end;

procedure TBisParam.SaveToStream(Stream: TStream);
var
  Buffer: String;
begin
  Buffer:=VarToStrDef(Value,'');
  Stream.Write(Pointer(Buffer)^,Length(Buffer));
end;


procedure TBisParam.LoadFromFile(const FileName: String);
var
  Stream: TFileStream;
begin
  Stream:=TFileStream.Create(FileName,fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

function TBisParam.Same(const AParamName: String): Boolean;
begin
  Result:=AnsiSameText(FParamName,AParamName);
end;

procedure TBisParam.SaveToFile(const FileName: String);
var
  Stream: TFileStream;
begin
  Stream:=TFileStream.Create(FileName,fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TBisParam.Clear;
begin
  Reset;
  Value:=Null;
//  DefaultValue:=Value;
end;

procedure TBisParam.SetNewValue(AValue: Variant);
begin
  Reset;
  Value:=AValue;
  DefaultValue:=Value;
end;

procedure TBisParam.WriteData(Writer: TWriter);
begin
end;

procedure TBisParam.ReadData(Reader: TReader);
begin
end;

procedure TBisParam.Refresh;
var
  Str: TStringList;
  i: Integer;
  P: TBisParam;
  V: Variant;
  Args: TBisVariants;
begin
  if Trim(FParamFormat)<>'' then begin
    Str:=TStringList.Create;
    Args:=TBisVariants.Create;
    try
      GetStringsByString(ParamName,SFieldDelim,Str);
      for i:=0 to Str.Count-1 do begin
        P:=Find(Str.Strings[i]);
        V:=Null;
        if Assigned(P) then
          V:=P.Value;
        Args.Add(V);
      end;
      V:=FormatEx(FParamFormat,Args);
      Value:=V;
      DefaultValue:=V;
      DoChange(Self);
    finally
      Args.Free;
      Str.Free;
    end;
  end;
end;

end.