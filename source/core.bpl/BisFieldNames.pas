unit BisFieldNames;

interface

uses Windows, Classes, Contnrs, DB, Graphics, Types, Variants,
     BisCoreObjects;

type
  TBisFieldNames=class;
  TBisFieldName=class;

  TBisFieldNameAlignment=(daDefault,daLeft,daCenter,daRight);
  TBisFieldNameFuncType=(ftNone,ftSum,ftDistinct);
  TBisFieldNameVisualType=(vtDefault,vtCheckBox,vtRadioButton);

  TBisFieldNameCalculateEvent=function(FieldName: TBisFieldName; DataSet: TDataSet): Variant of object;

  TBisFieldName=class(TObject)
  private
    FFieldNames: TBisFieldNames;
    FFieldName: String;
    FCaption: String;
    FWidth: Integer;
    FAlignment: TBisFieldNameAlignment;
    FIsKey: Boolean;
    FVisible: Boolean;
    FPrecision: Integer;
    FDataType: TFieldType;
    FSize: Integer;
    FDuplicates: TStringList;
    FDisplayFormat: string;
    FOnCalculate: TBisFieldNameCalculateEvent;
    FFuncType: TBisFieldNameFuncType;
    FVisualType: TBisFieldNameVisualType;
    FIsParent: Boolean;
    FField: TField;
    FData: Pointer;
    FCalculated: Boolean;
    function GetFieldName: String;
    procedure SetFieldName(const Value: String);
    procedure SetOnCalculate(const Value: TBisFieldNameCalculateEvent);
    function GetDataType: TFieldType;
    procedure SetDataType(const Value: TFieldType);
    function GetIndex: Integer;
  public
    constructor Create(AFieldNames: TBisFieldNames); reintroduce;
    destructor Destroy; override;

    procedure CopyFrom(Source: TBisFieldName);

    property FieldName: String read GetFieldName write SetFieldName;
    property Caption: String read FCaption write FCaption;
    property Width: Integer read FWidth write FWidth;
    property Alignment: TBisFieldNameAlignment read FAlignment write FAlignment;
    property IsKey: Boolean read FIsKey write FisKey;
    property IsParent: Boolean read FIsParent write FIsParent;
    property Visible: Boolean read FVisible write FVisible;
    property DataType: TFieldType read GetDataType write SetDataType;
    property Size: Integer read FSize write FSize;
    property Precision: Integer read FPrecision write FPrecision;
    property DisplayFormat: string read FDisplayFormat write FDisplayFormat;
    property FuncType: TBisFieldNameFuncType read FFuncType write FFuncType;
    property VisualType: TBisFieldNameVisualType read FVisualType write FVisualType;
    property Field: TField read FField write FField;
    property Data: Pointer read FData write FData;
    property Calculated: Boolean read FCalculated write FCalculated;

    property Index: Integer read GetIndex;

    property OnCalculate: TBisFieldNameCalculateEvent read FOnCalculate write SetOnCalculate;
  end;

  TBisFieldNames=class(TObjectList)
  private
    function GetItem(Index: Integer): TBisFieldName;
  public
    function Find(const FieldName: string; Counter: Integer=0): TBisFieldName;
    function FieldByName(FieldName: String; Counter: Integer=0): TBisFieldName;

    function Add(FieldName: TBisFieldName): Boolean; overload;
    function Add(const FieldName: string; const Caption: String=''; Width: Integer=0): TBisFieldName; overload;
    function AddInvisible(const FieldName: string): TBisFieldName;
    function AddKey(const FieldName: string): TBisFieldName;
    function AddParentKey(const FieldName: string): TBisFieldName;
    function AddCalculate(const FieldName,Caption: string; OnCalculate: TBisFieldNameCalculateEvent;
                          DataType: TFieldType; Size: Integer=0; Width: Integer=0): TBisFieldName;
    function AddCheckBox(const FieldName, Caption: String; Width: Integer=0): TBisFieldName;
    function AddRadioButton(const FieldName, Caption: String; Width: Integer=0): TBisFieldName;

    procedure CopyFrom(Source: TBisFieldNames; IsClear: Boolean=true);

    procedure WriteData(Writer: TWriter);
    procedure ReadData(Reader: TReader);

    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);

    procedure SetNilToCalculateEvents;

    property Items[Index: Integer]: TBisFieldName read GetItem;
  end;

implementation

uses SysUtils, DBConsts,
     BisConsts;

{ TBisFieldName }

{function TBisFieldName.Calculate: Variant;
begin
  Result:=Unassigned;
  if Assigned(FOnCalculate) then
    Result:=FOnCalculate(Self);
end;}

constructor TBisFieldName.Create(AFieldNames: TBisFieldNames);
begin
  inherited Create;
  FFieldNames:=AFieldNames;
  FDuplicates:=TStringList.Create;
end;

destructor TBisFieldName.Destroy;
begin
  FDuplicates.Free;
  inherited Destroy;
end;

function TBisFieldName.GetDataType: TFieldType;
begin
  Result:=FDataType;
  if Assigned(Field) then
    Result:=Field.DataType;
end;

function TBisFieldName.GetFieldName: String;
begin
  Result:=FFieldName;
end;

function TBisFieldName.GetIndex: Integer;
begin
  Result:=-1;
  if Assigned(FFieldNames) then
    Result:=FFieldNames.IndexOf(Self);
end;

procedure TBisFieldName.SetDataType(const Value: TFieldType);
begin
  FDataType:=Value;
end;

procedure TBisFieldName.SetFieldName(const Value: String);
begin
  FFieldName:=Value;
end;

procedure TBisFieldName.SetOnCalculate(const Value: TBisFieldNameCalculateEvent);
begin
  FOnCalculate := Value;
  FCalculated:=Assigned(FOnCalculate);
end;

procedure TBisFieldName.CopyFrom(Source: TBisFieldName);
begin
  if Assigned(Source) then begin
    FieldName:=Source.FieldName;
    Caption:=Source.Caption;
    Width:=Source.Width;
    Alignment:=Source.Alignment;
    IsKey:=Source.IsKey;
    IsParent:=Source.IsParent;
    Visible:=Source.Visible;
    DataType:=Source.DataType;
    Size:=Source.Size;
    Precision:=Source.Precision;
    DisplayFormat:=Source.DisplayFormat;
//    CalculateName:=Source.CalculateName;
    FuncType:=Source.FuncType;
    VisualType:=Source.VisualType;
    Data:=Source.Data;
//    Duplicates.Assign(Source.Duplicates);
    OnCalculate:=Source.OnCalculate;
  end;
end;

{ TBisFieldNames }

function TBisFieldNames.Add(const FieldName: string; const Caption: String; Width: Integer): TBisFieldName;
begin
  Result:=Find(FieldName);
  if not Assigned(Result) then begin
    Result:=TBisFieldName.Create(Self);
    inherited Add(Result);
  end;

  Result.FieldName:=FieldName;
  Result.Caption:=Caption;
  Result.Width:=Width;
  Result.Visible:=true;

end;

function TBisFieldNames.Add(FieldName: TBisFieldName): Boolean;
begin
  Result:=inherited Add(FieldName)>-1;
end;

function TBisFieldNames.AddCalculate(const FieldName, Caption: string; OnCalculate: TBisFieldNameCalculateEvent;
                                     DataType: TFieldType; Size, Width: Integer): TBisFieldName;
begin
  Result:=Add(FieldName,Caption,Width);
  if Assigned(Result) then begin
    Result.OnCalculate:=OnCalculate;
    Result.DataType:=DataType;
    Result.Size:=Size;
  end;
end;

function TBisFieldNames.AddCheckBox(const FieldName, Caption: String; Width: Integer): TBisFieldName;
begin
  Result:=Add(FieldName,Caption,Width);
  if Assigned(Result) then begin
    Result.VisualType:=vtCheckBox;
  end;
end;

function TBisFieldNames.AddRadioButton(const FieldName, Caption: String; Width: Integer): TBisFieldName;
begin
  Result:=Add(FieldName,Caption,Width);
  if Assigned(Result) then begin
    Result.VisualType:=vtRadioButton;
  end;
end;

function TBisFieldNames.AddInvisible(const FieldName: string): TBisFieldName;
begin
  Result:=Add(FieldName,'');
  if Assigned(Result) then
    Result.Visible:=false;
end;

function TBisFieldNames.AddKey(const FieldName: string): TBisFieldName;
begin
  Result:=AddInvisible(FieldName);
  if Assigned(Result) then
    Result.IsKey:=true;
end;

function TBisFieldNames.AddParentKey(const FieldName: string): TBisFieldName;
begin
  Result:=AddInvisible(FieldName);
  if Assigned(Result) then
    Result.IsParent:=true;
end;

procedure TBisFieldNames.CopyFrom(Source: TBisFieldNames; IsClear: Boolean);
var
  i: Integer;
  Def: TBisFieldName;
  DefSource: TBisFieldName;
begin
  if Assigned(Source) then begin
    if IsClear then
      Clear;
    for i:=0 to Source.Count-1 do begin
      DefSource:=Source.Items[i];
      Def:=Add(DefSource.FieldName,DefSource.Caption,DefSource.Width);
      if Assigned(Def) then
        Def.CopyFrom(DefSource);
    end;
  end;
end;

function TBisFieldNames.FieldByName(FieldName: String; Counter: Integer): TBisFieldName;
begin
  Result:=Find(FieldName,Counter);
  if not Assigned(Result) then
    raise Exception.CreateFmt(SFieldNotFound,[FieldName]);
end;

function TBisFieldNames.Find(const FieldName: string; Counter: Integer=0): TBisFieldName;
var
  i: Integer;
  Item: TBisFieldName;
  CounterI: Integer;
begin
  Result:=nil;
  CounterI:=0;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if AnsiSameText(Item.FieldName,FieldName)  then begin
      if CounterI=Counter then begin
        Result:=Item;
        exit;
      end;
      Inc(CounterI);
    end;
  end;
end;

function TBisFieldNames.GetItem(Index: Integer): TBisFieldName;
begin
  Result:=TBisFieldName(inherited Items[Index]);
end;

procedure TBisFieldNames.WriteData(Writer: TWriter);
var
  i: Integer;
  Item: TBisFieldName;
begin
  Writer.WriteListBegin;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    Writer.WriteString(Item.FieldName);
    Writer.WriteString(Item.Caption);
    Writer.WriteInteger(Item.Width);
    Writer.WriteInteger(Integer(Item.Alignment));
    Writer.WriteBoolean(Item.IsKey);
    Writer.WriteBoolean(Item.IsParent);
    Writer.WriteBoolean(Item.Visible);
    Writer.WriteInteger(Integer(Item.DataType));
    Writer.WriteInteger(Item.Size);
    Writer.WriteInteger(Item.Precision);
    Writer.WriteString(Item.DisplayFormat);
    Writer.WriteInteger(Integer(Item.FuncType));
    Writer.WriteInteger(Integer(Item.VisualType));
    Writer.WriteBoolean(Item.Calculated);
  end;
  Writer.WriteListEnd;
end;

procedure TBisFieldNames.ReadData(Reader: TReader);
var
  Item: TBisFieldName;
begin
  Reader.ReadListBegin;
  while not Reader.EndOfList do begin
    Item:=AddInvisible(Reader.ReadString);
    if Assigned(Item) then begin
      Item.Caption:=Reader.ReadString;
      Item.Width:=Reader.ReadInteger;
      Item.Alignment:=TBisFieldNameAlignment(Reader.ReadInteger);
      Item.IsKey:=Reader.ReadBoolean;
      Item.IsParent:=Reader.ReadBoolean;
      Item.Visible:=Reader.ReadBoolean;
      Item.DataType:=TFieldType(Reader.ReadInteger);
      Item.Size:=Reader.ReadInteger;
      Item.Precision:=Reader.ReadInteger;
      Item.DisplayFormat:=Reader.ReadString;
      Item.FuncType:=TBisFieldNameFuncType(Reader.ReadInteger);
      Item.VisualType:=TBisFieldNameVisualType(Reader.ReadInteger);
      Item.Calculated:=Reader.ReadBoolean;
    end;
  end;
  Reader.ReadListEnd;
end;

procedure TBisFieldNames.SaveToStream(Stream: TStream);
var
  Writer: TWriter;
begin
  Writer:=TWriter.Create(Stream,WriterBufferSize);
  try
    WriteData(Writer);
  finally
    Writer.Free;
  end;
end;

procedure TBisFieldNames.LoadFromStream(Stream: TStream);
var
  Reader: TReader;
begin
  Reader:=TReader.Create(Stream,ReaderBufferSize);
  try
    ReadData(Reader);
  finally
    Reader.Free;
  end;
end;

procedure TBisFieldNames.SetNilToCalculateEvents;
var
  i: Integer;
begin
  for i:=0 to Count-1 do
    Items[i].OnCalculate:=nil;
end;

end.
