unit BisConnectionEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, DB, Grids, DBGrids, DBCtrls,
  BisDialogFm, BisConnections, BisDataSet, BisCmdLine, BisControls;

type
  TBisConnectionEditForm = class(TBisDialogForm)
    DataSource: TDataSource;
    DBGrid: TDBGrid;
    GroupBoxValue: TGroupBox;
    DBMemoValue: TDBMemo;
    PanelConnections: TPanel;
    LabelConnection: TLabel;
    ComboBoxConnections: TComboBox;
    ButtonSave: TButton;
    procedure ButtonOkClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure ComboBoxConnectionsChange(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure DBGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FDataSet: TBisDataSet;
    FOldConnection: TBisConnection;
    FSColumnParameter: String;
    FSColumnDescription: String;
    procedure FillConnections;
    function FindConnection(Value: TBisConnection): Integer; overload;
    function FindConnection(AName: String): TBisConnection; overload;
    procedure SetConnection(const Value: TBisConnection);
    function GetConnection: TBisConnection;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override; 

    procedure DisableConnections;

    property Connection: TBisConnection read GetConnection write SetConnection;
  published
    property SColumnParameter: String read FSColumnParameter write FSColumnParameter;
    property SColumnDescription: String read FSColumnDescription write FSColumnDescription; 
  end;

  TBisConnectionEditFormIface=class(TBisDialogFormIface)
  private
    FConnectionName: String;
  public
    constructor Create(AOwner: TComponent); override;
    procedure ShowByCommand(Param: TBisCmdParam; const Command: String); override;
    procedure BeforeFormShow; override;
  end;

var
  BisConnectionEditForm: TBisConnectionEditForm;

implementation

{$R *.dfm}

uses BisConsts, BisConnectionModules, BisCore;

{ TBisConnectionEditFormIface }

constructor TBisConnectionEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisConnectionEditForm;
end;

procedure TBisConnectionEditFormIface.ShowByCommand(Param: TBisCmdParam; const Command: String);
begin
  FConnectionName:=Param.Next(Command);
///  FConnectionName:=Core.CmdLine.ValueByParam(SCmdParamCommand,1);
  ShowModal;
end;

procedure TBisConnectionEditFormIface.BeforeFormShow;
begin
  inherited BeforeFormShow;
  if Assigned(LastForm) then begin
    with TBisConnectionEditForm(LastForm) do begin
      Connection:=FindConnection(FConnectionName);
    end;
  end;
end;


{ TBisConnectionEditForm }

constructor TBisConnectionEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  SizeGrip.Visible:=true;

  FDataSet:=TBisDataSet.Create(Self);
  with FDataSet.FieldDefs do begin
    Add(SFieldName,ftString,MaxFieldNameSize);
    Add(SFieldDescription,ftString,MaxFieldDescriptionSize);
    Add(SFieldValue,ftString,MaxFieldDescriptionSize);
    Add(SFieldVisible,ftInteger);
  end;
  FDataSet.CreateTable();

  DataSource.DataSet:=FDataSet;

  FSColumnParameter:='��������';
  FSColumnDescription:='��������';

  FillConnections;
end;

procedure TBisConnectionEditForm.DBGridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  OldBrush: TBrush;
  AGrid: TDbGrid;
begin
  AGrid:=TDbGrid(Sender);
  if not (gdFocused in State) and (gdSelected in State) then begin
    OldBrush:=TBrush.Create;
    OldBrush.Assign(AGrid.Canvas.Brush);
    try
      AGrid.Canvas.Brush.Color:=clGray;
      AGrid.Canvas.FillRect(Rect);
      AGrid.Canvas.Font.Color:=clHighlightText;
      AGrid.Canvas.TextOut(Rect.Left+2,Rect.Top+2,Column.Field.Text);
    finally
      AGrid.Canvas.Brush.Assign(OldBrush);
      OldBrush.Free;
    end;
  end else
    AGrid.DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;

destructor TBisConnectionEditForm.Destroy;
begin
  FDataSet.Free;
  inherited Destroy;
end;

procedure TBisConnectionEditForm.DisableConnections;
begin
  LabelConnection.Enabled:=false;
  ComboBoxConnections.Enabled:=false;
  ComboBoxConnections.Color:=clBtnFace;
end;

procedure TBisConnectionEditForm.FillConnections;
var
  i: Integer;
  j: Integer;
  Module: TBisConnectionModule;
  AConnection: TBisConnection;
begin
  ComboBoxConnections.Items.BeginUpdate;
  try
    ComboBoxConnections.Items.Clear;
    for i:=0 to Core.ConnectionModules.Count-1 do begin
      Module:=Core.ConnectionModules.Items[i];
      if Module.Enabled then begin
        for j:=0 to Module.Connections.Count-1 do begin
          AConnection:=Module.Connections.Items[j];
          if AConnection.Enabled then begin
            ComboBoxConnections.Items.AddObject(AConnection.Caption,AConnection);
          end;
        end;
      end;
    end;
    if ComboBoxConnections.Items.Count>0 then begin
       ComboBoxConnections.ItemIndex:=0;
       FOldConnection:=Connection;
       ComboBoxConnectionsChange(nil);
    end;
    ButtonSave.Enabled:=ComboBoxConnections.ItemIndex<>-1;
  finally
    ComboBoxConnections.Items.EndUpdate;
  end;
end;

procedure TBisConnectionEditForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_ESCAPE then begin
    Close;
  end;
end;

function TBisConnectionEditForm.GetConnection: TBisConnection;
begin
  Result:=nil;
  if ComboBoxConnections.ItemIndex<>-1 then
    Result:=TBisConnection(ComboBoxConnections.Items.Objects[ComboBoxConnections.ItemIndex]);
end;

procedure TBisConnectionEditForm.Init;
begin
  inherited Init;
  DBGrid.Columns.Items[0].Title.Caption:=FSColumnParameter;
  DBGrid.Columns.Items[1].Title.Caption:=FSColumnDescription;
end;

function TBisConnectionEditForm.FindConnection(Value: TBisConnection): Integer;
var
  i: Integer;
  AConnection: TBisConnection;
begin
  Result:=-1;
  for i:=0 to ComboBoxConnections.Items.Count-1 do begin
    AConnection:=TBisConnection(ComboBoxConnections.Items.Objects[i]);
    if AConnection=Value then begin
      Result:=i;
      exit;
    end;
  end;
end;

function TBisConnectionEditForm.FindConnection(AName: String): TBisConnection;
var
  i: Integer;
  AConnection: TBisConnection;
  S: String;
begin
  Result:=nil;
  for i:=0 to ComboBoxConnections.Items.Count-1 do begin
    AConnection:=TBisConnection(ComboBoxConnections.Items.Objects[i]);
    S:=Copy(AConnection.ObjectName,1,Length(AName));
    if AnsiSameText(S,AName) then begin
      Result:=AConnection;
      exit;
    end;
  end;
end;

procedure TBisConnectionEditForm.SetConnection(const Value: TBisConnection);
begin
  ComboBoxConnections.ItemIndex:=FindConnection(Value);
  ComboBoxConnectionsChange(nil);
end;

procedure TBisConnectionEditForm.ButtonOkClick(Sender: TObject);
begin
  if Assigned(Connection) then begin
    Connection.Params.CopyFromDataSet(FDataSet,false);
    Connection.SaveParams;
  end;
  ModalResult:=mrOk;
end;

procedure TBisConnectionEditForm.ButtonSaveClick(Sender: TObject);
begin
  if Assigned(Connection) then begin
    Connection.Params.CopyFromDataSet(FDataSet,false);
    Connection.SaveParams;
  end;
end;

procedure TBisConnectionEditForm.ComboBoxConnectionsChange(Sender: TObject);
begin
  if FOldConnection<>Connection then begin
    if Assigned(FOldConnection) then
       FOldConnection.Params.CopyFromDataSet(FDataSet,false);
    FOldConnection:=Connection;
  end;
  if Assigned(Connection) then
    Connection.Params.CopyToDataSet(FDataSet,true);
end;

procedure TBisConnectionEditForm.DBGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_DELETE then
    Key:=0;  

end;


end.