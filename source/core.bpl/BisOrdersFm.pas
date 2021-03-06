unit BisOrdersFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, DBGrids, DBCtrls, DB,
  BisOrders, BisProvider;

type
  TBisOrdersForm = class(TForm)
    PanelButton: TPanel;
    ButtonCancel: TButton;
    ButtonOk: TButton;
    PanelGrid: TPanel;
    Grid: TDBGrid;
    DBNavigator: TDBNavigator;
    Bevel: TBevel;
    DataSource: TDataSource;
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FProvider: TBisProvider;
    FOrders: TBisOrders;
    procedure FillTypes(PickList: TStrings);
    procedure FieldTypeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
    procedure FieldTypeSetText(Sender: TField; const Text: string);
    procedure GetOrders;
    procedure FillOrders;
    procedure SetOrders(Value: TBisOrders);
  public
    property Orders: TBisOrders read FOrders write SetOrders;
  end;

var
  BisOrdersForm: TBisOrdersForm;

implementation

uses TypInfo, Consts, 
     BisUtils;

{$R *.dfm}

{ TSgtsBaseOrdersForm }

procedure TBisOrdersForm.FormCreate(Sender: TObject);
begin
  FProvider:=TBisProvider.Create(nil);
  with FProvider.FieldDefs do begin
    Add('NAME',ftString,100);
    Add('TYPE',ftInteger);
  end;
  FProvider.CreateTable;
  with FProvider.Fields[1] do begin
    OnGetText:=FieldTypeGetText;
    OnSetText:=FieldTypeSetText;
    Alignment:=taLeftJustify;
  end;

  DataSource.DataSet:=FProvider;

  FillTypes(Grid.Columns.Items[1].PickList);
end;

procedure TBisOrdersForm.FormDestroy(Sender: TObject);
begin
  FProvider.Free;
end;

procedure TBisOrdersForm.FillTypes(PickList: TStrings);
var
  i: Integer;
  PInfo: PTypeInfo;
  PData: PTypeData;
begin
  PickList.BeginUpdate;
  try
    PickList.Clear;
    PData:=nil;
    PInfo:=TypeInfo(TBisOrderType);
    if Assigned(PInfo) then
      PData:=GetTypeData(PInfo);
    if Assigned(PData) then
      for i:=PData.MinValue to PData.MaxValue do begin
        PickList.Add(GetEnumName(PInfo,i));
      end;
  finally
    PickList.EndUpdate;
  end;
end;

procedure TBisOrdersForm.FieldTypeGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  if (Sender.AsInteger in [0..Grid.Columns.Items[1].PickList.Count-1]) and
      not FProvider.IsEmpty then
    Text:=Grid.Columns.Items[1].PickList[Sender.AsInteger];
end;

procedure TBisOrdersForm.FieldTypeSetText(Sender: TField; const Text: string);
var
  Index: Integer;
begin
  Index:=Grid.Columns.Items[1].PickList.IndexOf(Text);
  if Index in [0..Grid.Columns.Items[1].PickList.Count-1] then
    Sender.AsInteger:=Index;
end;


procedure TBisOrdersForm.SetOrders(Value: TBisOrders);
begin
  FOrders:=Value;
  FillOrders;
end;

procedure TBisOrdersForm.ButtonCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TBisOrdersForm.ButtonOkClick(Sender: TObject);
begin
  GetOrders;
  ModalResult:=mrOk;
end;

procedure TBisOrdersForm.GetOrders;
begin
  if Assigned(FOrders) then begin
    FOrders.Clear;
    FProvider.BeginUpdate;
    try
      FProvider.First;
      while not FProvider.Eof do begin
        FOrders.Add(FProvider.FieldByName('NAME').AsString,
                    TBisOrderType(FProvider.FieldByName('TYPE').AsInteger));
        FProvider.Next;
      end;
    finally
      FProvider.EndUpdate;
    end;
  end;
end;

procedure TBisOrdersForm.FillOrders;
var
  i: Integer;
  Item: TBisOrder;
begin
  if Assigned(FOrders) then begin
    FProvider.BeginUpdate;
    try
      FProvider.EmptyTable;
      for i:=0 to FOrders.Count-1 do begin
        Item:=FOrders.Items[i];
        FProvider.Append;
        FProvider.FieldByName('NAME').AsString:=Item.FieldName;
        FProvider.FieldByName('TYPE').AsInteger:=Integer(Item.OrderType);
        FProvider.Post;
      end;
      FProvider.First;
    finally
      FProvider.EndUpdate;
    end;
  end;
end;

end.
