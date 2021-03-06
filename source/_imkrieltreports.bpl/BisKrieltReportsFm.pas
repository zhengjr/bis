unit BisKrieltReportsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisFm, BisIfaces, StdCtrls, ComCtrls, CheckLst, ExtCtrls;

type
  TBisKrieltReportsForm = class(TBisForm)
    ReportParamsGroupBox: TGroupBox;
    ActionLabel: TLabel;
    RealtyTypeLabel: TLabel;
    ReportLabel: TLabel;
    ActionComboBox: TComboBox;
    RealtyTypeComboBox: TComboBox;
    ReportComboBox: TComboBox;
    PeriodGroupBox: TGroupBox;
    BeginDateTimePicker: TDateTimePicker;
    EndDateTimePicker: TDateTimePicker;
    PeriodBeginLabel: TLabel;
    PeriodEndLabel: TLabel;
    ExportProgressGroupBox: TGroupBox;
    ExportProgressBar: TProgressBar;
    AllRecordsLabel: TLabel;
    ExportRecordsLabel: TLabel;
    StartExportButton: TButton;
    CloseExportButtonButton: TButton;
    ListGroupBox: TGroupBox;
    AddButton: TButton;
    DeleteButton: TButton;
    ClearButton: TButton;
    ExportTimer: TTimer;
    AllListBox: TListBox;
    ButtonPeriod: TButton;
    LabelPublishing: TLabel;
    EditPublishing: TEdit;
    ButtonPublishing: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ActionComboBoxChange(Sender: TObject);
    procedure RealtyTypeComboBoxChange(Sender: TObject);
    procedure ReportComboBoxChange(Sender: TObject);
    procedure StartExportButtonClick(Sender: TObject);
    procedure CloseExportButtonButtonClick(Sender: TObject);
    procedure ExportTimerTimer(Sender: TObject);
    procedure AddButtonClick(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure ButtonPublishingClick(Sender: TObject);
    procedure ButtonPeriodClick(Sender: TObject);
  private
    FPublishingId: Variant;
    FIssueId: Variant;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltReportsFormIface=class(TBisFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltReportsForm: TBisKrieltReportsForm;

var
  BisKrieltReportsIface: TBisIface=nil;

implementation

uses DateUtils,
  BisInterfaces, BisKrieltReportsSellResidential,
  BisKrieltReportsSellUnresidential, BisKrieltReportsBuy,
  BisKrieltReportsDeliverResidential, BisKrieltReportsDeliverUnresidential,
  BisKrieltReportsDeliverLand, BisKrieltReportsShootResidential,
  BisKrieltReportsShootUnresidential, BisKrieltReportsShootLand,
  BisKrieltReportsChange, BisKrieltReportsUtils,
  BisCore, BisDataFm, BisProvider, BisUtils, BisFilterGroups;

{$R *.dfm}

{ TBisKrieltReportsFormIface }

constructor TBisKrieltReportsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltReportsForm;
  Available:=true;
  OnlyOneForm:=true;
  Permissions.Enabled:=true;
end;

{ TBisKrieltReportsForm }

procedure TBisKrieltReportsForm.AddButtonClick(Sender: TObject);
begin
  AllListBox.Items.Add(ActionComboBox.Text+'. '+RealtyTypeComboBox.Text+'. '+ReportComboBox.Text+'.');
end;

procedure TBisKrieltReportsForm.ButtonPeriodClick(Sender: TObject);
var
  AClass: TBisIfaceClass;
  AIface: TBisDataFormIface;
  P: TBisProvider;
begin
  AClass:=Core.FindIfaceClass('TBisKrieltHbookIssuesFormIface');
  if Assigned(AClass) and IsClassParent(AClass,TBisDataFormIface) then begin
    AIface:=TBisDataFormIfaceClass(AClass).Create(nil);
    P:=TBisProvider.Create(nil);
    try
      AIface.LocateFields:='ISSUE_ID';
      AIface.LocateValues:=FIssueId;
      AIface.FilterGroups.Add.Filters.Add('PUBLISHING_ID',fcEqual,FPublishingId);
      if AIface.SelectInto(P) then begin
        FIssueId:=P.FieldByName('ISSUE_ID').Value;
        BeginDateTimePicker.Date:=DateOf(P.FieldByName('DATE_BEGIN').AsDateTime);
        EndDateTimePicker.Date:=DateOf(P.FieldByName('DATE_END').AsDateTime);
      end;
    finally
      P.Free;
      AIface.Free;
    end;
  end;
end;

procedure TBisKrieltReportsForm.ButtonPublishingClick(Sender: TObject);
var
  AClass: TBisIfaceClass;
  AIface: TBisDataFormIface;
  P: TBisProvider;
begin
  AClass:=Core.FindIfaceClass('TBisKrieltHbookPublishingFormIface');
  if Assigned(AClass) and IsClassParent(AClass,TBisDataFormIface) then begin
    AIface:=TBisDataFormIfaceClass(AClass).Create(nil);
    P:=TBisProvider.Create(nil);
    try
      AIface.LocateFields:='PUBLISHING_ID';
      AIface.LocateValues:=FPublishingId;
      if AIface.SelectInto(P) then begin
        FPublishingId:=P.FieldByName('PUBLISHING_ID').Value;
        EditPublishing.Text:=P.FieldByName('NAME').AsString;
      end;
    finally
      P.Free;
      AIface.Free;
    end;
  end;
end;

procedure TBisKrieltReportsForm.ClearButtonClick(Sender: TObject);
begin
  AllListBox.Items.Clear;
end;

procedure TBisKrieltReportsForm.CloseExportButtonButtonClick(Sender: TObject);
begin
  inherited;
  Close;
end;

constructor TBisKrieltReportsForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BeginDateTimePicker.Date:=Date;
  EndDateTimePicker.Date:=Date;
  FPublishingId:=Null;
  FIssueId:=Null;
end;

procedure TBisKrieltReportsForm.DeleteButtonClick(Sender: TObject);
begin
  AllListBox.Items.Delete(AllListBox.ItemIndex);
end;

procedure TBisKrieltReportsForm.ExportTimerTimer(Sender: TObject);
begin

  if AllListBox.Items.Count=0 then begin
    ClearButton.Enabled:=False;
    StartExportButton.Enabled:=False;
  end else begin
    ClearButton.Enabled:=True;
    StartExportButton.Enabled:=True;
  end;

  if AllListBox.ItemIndex=-1 Then
    DeleteButton.Enabled:=False
  else
    DeleteButton.Enabled:=True;
end;

procedure TBisKrieltReportsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  Action:=caFree;
end;

procedure TBisKrieltReportsForm.ActionComboBoxChange(Sender: TObject);
begin
  if (ActionComboBox.Text='������') then Begin
    RealtyTypeComboBox.Items.Clear;
    ReportComboBox.Items.Clear;
    RealtyTypeComboBox.Items.Add('�����');
    RealtyTypeComboBox.Items.Add('�������');
  End;
  if (ActionComboBox.Text='�����') then Begin
    RealtyTypeComboBox.Items.Clear;
    ReportComboBox.Items.Clear;
    RealtyTypeComboBox.Items.Add('������� �����');
    RealtyTypeComboBox.Items.Add('������� �������');
    RealtyTypeComboBox.Items.Add('�����');
    RealtyTypeComboBox.Items.Add('�������');
    RealtyTypeComboBox.Items.Add('�����');
  End;
  if (ActionComboBox.Text='���� � ������') then Begin
    RealtyTypeComboBox.Items.Clear;
    ReportComboBox.Items.Clear;
    RealtyTypeComboBox.Items.Add('�����');
    RealtyTypeComboBox.Items.Add('�������');
    RealtyTypeComboBox.Items.Add('�����');
  End;
  if (ActionComboBox.Text='����� � ������') then Begin
    RealtyTypeComboBox.Items.Clear;
    ReportComboBox.Items.Clear;
    RealtyTypeComboBox.Items.Add('�����');
    RealtyTypeComboBox.Items.Add('�������');
    RealtyTypeComboBox.Items.Add('�����');
  End;
  if (ActionComboBox.Text='�������') then Begin
    RealtyTypeComboBox.Items.Clear;
    ReportComboBox.Items.Clear;
    RealtyTypeComboBox.Items.Add('������� �����');
    RealtyTypeComboBox.Items.Add('������� �������');
    RealtyTypeComboBox.Items.Add('�����');
    RealtyTypeComboBox.Items.Add('�������');
    RealtyTypeComboBox.Items.Add('�����');
  End;
  RealtyTypeComboBox.ItemIndex:=-1;
  AddButton.Enabled:=False;
end;

procedure TBisKrieltReportsForm.RealtyTypeComboBoxChange(Sender: TObject);
begin
  if (ActionComboBox.Text='������') And (RealtyTypeComboBox.Text='�����') then begin
    ReportComboBox.Items.Clear;
    ReportComboBox.Items.Add('�������� � �. ����������');
    ReportComboBox.Items.Add('�������� � ������ ���������� �������');
    ReportComboBox.Items.Add('����, �������� � �. ����������');
    ReportComboBox.Items.Add('����, �������� � ������ ���������� �������');
    ReportComboBox.Items.Add('��������� � �. ����������');
    ReportComboBox.Items.Add('���������� ����');
    ReportComboBox.Items.Add('����');
  end;
  if (ActionComboBox.Text='������') And (RealtyTypeComboBox.Text='�������') then begin
    ReportComboBox.Items.Clear;
    ReportComboBox.Items.Add('����� � �. ����������');
    ReportComboBox.Items.Add('����� � ������ ���������� �������');
    ReportComboBox.Items.Add('�������� ��������� � �. ����������');
    ReportComboBox.Items.Add('�������� ��������� � ������ ���������� �������');
    ReportComboBox.Items.Add('������, ���� � �. ����������');
    ReportComboBox.Items.Add('������, ���� � ������ ���������� �������');
    ReportComboBox.Items.Add('������ � �. ����������');
    ReportComboBox.Items.Add('������ � ������ ���������� �������');
    ReportComboBox.Items.Add('���������, ���� � �. ����������');
    ReportComboBox.Items.Add('���������, ���� � ������ ���������� �������');
    ReportComboBox.Items.Add('������������ � �. ����������');
    ReportComboBox.Items.Add('������������ � ������ ���������� �������');
    ReportComboBox.Items.Add('������ � �. ����������');
    ReportComboBox.Items.Add('������ � ������ ���������� �������');
    ReportComboBox.Items.Add('���������� ���������� � �. ����������');
    ReportComboBox.Items.Add('���������� ���������� � ������ ���������� �������');
  end;
  if (ActionComboBox.Text='�����') And (RealtyTypeComboBox.Text='������� �����') then begin
    ReportComboBox.Items.Clear;
    ReportComboBox.Items.Add('������� � �. ����������');
    ReportComboBox.Items.Add('������� � ������ ���������� �������');
  end;
  if (ActionComboBox.Text='�����') And (RealtyTypeComboBox.Text='������� �������') then begin
    ReportComboBox.Items.Clear;
    ReportComboBox.Items.Add('� �. ����������');
    ReportComboBox.Items.Add('� ������ ���������� �������');
  end;
  if (ActionComboBox.Text='�����') And (RealtyTypeComboBox.Text='�����') then begin
    ReportComboBox.Items.Clear;
    ReportComboBox.Items.Add('�������� � �. ����������');
    ReportComboBox.Items.Add('�������� � ������ ���������� �������');
    ReportComboBox.Items.Add('����, ��������, ��������� � �. ����������');
    ReportComboBox.Items.Add('����, ��������, ��������� � ������ ���������� �������');
    ReportComboBox.Items.Add('���������� ����');
    ReportComboBox.Items.Add('���� (� ���������� ������)');
    ReportComboBox.Items.Add('���� (�� ���������� �������)');
  end;
  if (ActionComboBox.Text='�����') And (RealtyTypeComboBox.Text='�������') then begin
    ReportComboBox.Items.Clear;
    ReportComboBox.Items.Add('� �. ����������');
    ReportComboBox.Items.Add('� ������ ���������� �������');
  end;
  if (ActionComboBox.Text='�����') And (RealtyTypeComboBox.Text='�����') then begin
    ReportComboBox.Items.Clear;
    ReportComboBox.Items.Add('� �. ����������');
    ReportComboBox.Items.Add('� ������ ���������� �������');
    ReportComboBox.Items.Add('�� ����������� ��������');
  end;
  if (ActionComboBox.Text='���� � ������') And (RealtyTypeComboBox.Text='�����') then begin
    ReportComboBox.Items.Clear;
    ReportComboBox.Items.Add('�������� � �. ����������');
    ReportComboBox.Items.Add('�������� � ������ ���������� �������');
    ReportComboBox.Items.Add('����, �������� � �. ����������');
    ReportComboBox.Items.Add('����, �������� � ������ ���������� �������');
    ReportComboBox.Items.Add('��������� � �. ����������');
    ReportComboBox.Items.Add('���������� ����, ��������');
    ReportComboBox.Items.Add('����');
  end;
  if (ActionComboBox.Text='���� � ������') And (RealtyTypeComboBox.Text='�������') then begin
    ReportComboBox.Items.Clear;
    ReportComboBox.Items.Add('����� � �. ����������');
    ReportComboBox.Items.Add('����� � ������ ���������� �������');
    ReportComboBox.Items.Add('�������� ��������� � �. ����������');
    ReportComboBox.Items.Add('�������� ��������� � ������ ���������� �������');
    ReportComboBox.Items.Add('������, ���� � �. ����������');
    ReportComboBox.Items.Add('������, ���� � ������ ���������� �������');
    ReportComboBox.Items.Add('������ � �. ����������');
    ReportComboBox.Items.Add('������ � ������ ���������� �������');
    ReportComboBox.Items.Add('���������, ���� � �. ����������');
    ReportComboBox.Items.Add('���������, ���� � ������ ���������� �������');
    ReportComboBox.Items.Add('������������ � �. ����������');
    ReportComboBox.Items.Add('������������ � ������ ���������� �������');
    ReportComboBox.Items.Add('������, ����� � �. ����������');
    ReportComboBox.Items.Add('������, ����� � ������ ���������� �������');
    ReportComboBox.Items.Add('���������� ���������� � �. ����������');
    ReportComboBox.Items.Add('���������� ���������� � ������ ���������� �������');
  end;
  if (ActionComboBox.Text='���� � ������') And (RealtyTypeComboBox.Text='�����') then begin
    ReportComboBox.Items.Clear;
    ReportComboBox.Items.Add('����� � �. ����������');
    ReportComboBox.Items.Add('����� � ������ ���������� �������');
    ReportComboBox.Items.Add('����� �� ����������� ��������');
  end;
  if (ActionComboBox.Text='����� � ������') And (RealtyTypeComboBox.Text='�����') then begin
    ReportComboBox.Items.Clear;
    ReportComboBox.Items.Add('�������� � �. ����������');
    ReportComboBox.Items.Add('�������� � ������ ���������� �������');
    ReportComboBox.Items.Add('����, ��������, ��������� � �. ����������');
    ReportComboBox.Items.Add('����, ��������, ��������� � ������ ���������� �������');
    ReportComboBox.Items.Add('���������� ����');
    ReportComboBox.Items.Add('���� (� ���������� ������)');
    ReportComboBox.Items.Add('���� (�� ���������� �������)');
  end;
  if (ActionComboBox.Text='����� � ������') And (RealtyTypeComboBox.Text='�������') then begin
    ReportComboBox.Items.Clear;
    ReportComboBox.Items.Add('� �. ����������');
    ReportComboBox.Items.Add('� ������ ���������� �������');
  end;
  if (ActionComboBox.Text='����� � ������') And (RealtyTypeComboBox.Text='�����') then begin
    ReportComboBox.Items.Clear;
    ReportComboBox.Items.Add('� �. ����������');
    ReportComboBox.Items.Add('� ������ ���������� �������');
    ReportComboBox.Items.Add('�� ����������� ��������');
  end;
  if (ActionComboBox.Text='�������') And (RealtyTypeComboBox.Text='������� �����') then begin
    ReportComboBox.Items.Clear;
    ReportComboBox.Items.Add('������� � �. ����������');
    ReportComboBox.Items.Add('������� � ������ ���������� �������');
  end;
  if (ActionComboBox.Text='�������') And (RealtyTypeComboBox.Text='������� �������') then begin
    ReportComboBox.Items.Clear;
    ReportComboBox.Items.Add('� �. ����������');
    ReportComboBox.Items.Add('� ������ ���������� �������');
  end;
  if (ActionComboBox.Text='�������') And (RealtyTypeComboBox.Text='�����') then begin
    ReportComboBox.Items.Clear;
    ReportComboBox.Items.Add('�������� � �. ����������');
    ReportComboBox.Items.Add('�������� � ������ ���������� �������');
    ReportComboBox.Items.Add('����, ��������, ��������� � �. ����������');
    ReportComboBox.Items.Add('����, ��������, ��������� � ������ ���������� �������');
    ReportComboBox.Items.Add('���������� ����');
    ReportComboBox.Items.Add('���� (� ���������� ������)');
    ReportComboBox.Items.Add('���� (�� ���������� �������)');
  end;
  if (ActionComboBox.Text='�������') And (RealtyTypeComboBox.Text='�������') then begin
    ReportComboBox.Items.Clear;
    ReportComboBox.Items.Add('� �. ����������');
    ReportComboBox.Items.Add('� ������ ���������� �������');
  end;
  if (ActionComboBox.Text='�������') And (RealtyTypeComboBox.Text='�����') then begin
    ReportComboBox.Items.Clear;
    ReportComboBox.Items.Add('� �. ����������');
    ReportComboBox.Items.Add('� ������ ���������� �������');
    ReportComboBox.Items.Add('�� ����������� ��������');
  end;
  ReportComboBox.ItemIndex:=-1;
  AddButton.Enabled:=False;
end;

procedure TBisKrieltReportsForm.ReportComboBoxChange(Sender: TObject);
begin
  if (ReportComboBox.Text<>'') then
    AddButton.Enabled:=True
  else
    AddButton.Enabled:=False;
end;

procedure TBisKrieltReportsForm.StartExportButtonClick(Sender: TObject);
var DateBegin, DateEnd: TDate;
  I: Integer;
begin
  DateBegin:=BeginDateTimePicker.Date;
  DateEnd:=EndDateTimePicker.Date;

  If (DateBegin<=DateEnd) Then Begin

    for I:=0 to AllListBox.Items.Count-1 do begin

      SetFormExportInProgress(Self);

      if (AllListBox.Items.Strings[I]='������. �����. �������� � �. ����������.') then ExportSellApartmentsKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='������. �����. �������� � ������ ���������� �������.') then ExportSellApartmentsOthers(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='������. �����. ����, �������� � �. ����������.') then ExportSellHousesCottagesKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='������. �����. ����, �������� � ������ ���������� �������.') then ExportSellHousesCottagesOthers(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='������. �����. ��������� � �. ����������.') then ExportSellTownHousesKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='������. �����. ���������� ����.') then ExportSellOutsideHouses(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='������. �����. ����.') then ExportSellDatchas(Self, DateBegin, DateEnd);

      if (AllListBox.Items.Strings[I]='������. �������. ����� � �. ����������.') Then ExportSellOfficesKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='������. �������. ����� � ������ ���������� �������.') Then ExportSellOfficesOthers(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='������. �������. �������� ��������� � �. ����������.') Then ExportSellTradePremisesKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='������. �������. �������� ��������� � ������ ���������� �������.') Then ExportSellTradePremisesOthers(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='������. �������. ������, ���� � �. ����������.') Then ExportSellBasesKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='������. �������. ������, ���� � ������ ���������� �������.') Then ExportSellBasesOthers(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='������. �������. ������ � �. ����������.') Then ExportSellBuildingsKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='������. �������. ������ � ������ ���������� �������.') Then ExportSellBuildingsOthers(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='������. �������. ���������, ���� � �. ����������.') Then ExportSellRestaurantsKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='������. �������. ���������, ���� � ������ ���������� �������.') Then ExportSellRestaurantsOthers(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='������. �������. ������������ � �. ����������.') Then ExportSellProductionsKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='������. �������. ������������ � ������ ���������� �������.') Then ExportSellProductionsOthers(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='������. �������. ������ � �. ����������.') Then ExportSellGaragesKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='������. �������. ������ � ������ ���������� �������.') Then ExportSellGaragesOthers(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='������. �������. ���������� ���������� � �. ����������.') Then ExportSellFreePurposeKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='������. �������. ���������� ���������� � ������ ���������� �������.') Then ExportSellFreePurposeOthers(Self, DateBegin, DateEnd);

      if (AllListBox.Items.Strings[I]='�����. ������� �����. ������� � �. ����������.') Then ExportBuyShareResidentialKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='�����. ������� �����. ������� � ������ ���������� �������.') Then ExportBuyShareResidentialOthers(Self, DateBegin, DateEnd);

      if (AllListBox.Items.Strings[I]='�����. ������� �������. � �. ����������.') Then ExportBuyShareUnresidentialKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='�����. ������� �������. � ������ ���������� �������.') Then ExportBuyShareUnresidentialOthers(Self, DateBegin, DateEnd);

      if (AllListBox.Items.Strings[I]='�����. �����. �������� � �. ����������.') Then ExportBuyApartmentsKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='�����. �����. �������� � ������ ���������� �������.') Then ExportBuyApartmentsOthers(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='�����. �����. ����, ��������, ��������� � �. ����������.') Then ExportBuyHousesCottagesTownHousesKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='�����. �����. ����, ��������, ��������� � ������ ���������� �������.') Then ExportBuyHousesCottagesTownHousesOthers(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='�����. �����. ���������� ����.') Then ExportBuyOutsideHouses(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='�����. �����. ���� (� ���������� ������).') Then ExportBuyDatchasInPoint(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='�����. �����. ���� (�� ���������� �������).') Then ExportBuyDatchasOutPoint(Self, DateBegin, DateEnd);

      if (AllListBox.Items.Strings[I]='�����. �������. � �. ����������.') Then ExportBuyUnresidentialKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='�����. �������. � ������ ���������� �������.') Then ExportBuyUnresidentialOthers(Self, DateBegin, DateEnd);

      if (AllListBox.Items.Strings[I]='�����. �����. � �. ����������.') Then ExportBuyLandKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='�����. �����. � ������ ���������� �������.') Then ExportBuyLandOthers(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='�����. �����. �� ����������� ��������.') Then ExportBuyLandOutPoint(Self, DateBegin, DateEnd);

      if (AllListBox.Items.Strings[I]='���� � ������. �����. �������� � �. ����������.') Then ExportDeliverApartmentsKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='���� � ������. �����. �������� � ������ ���������� �������.') Then ExportDeliverApartmentsOthers(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='���� � ������. �����. ����, �������� � �. ����������.') Then ExportDeliverHousesCottagesKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='���� � ������. �����. ����, �������� � ������ ���������� �������.') Then ExportDeliverHousesCottagesOthers(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='���� � ������. �����. ��������� � �. ����������.') Then ExportDeliverTownHousesKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='���� � ������. �����. ���������� ����, ��������.') Then ExportDeliverOutsideHousesCottages(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='���� � ������. �����. ����.') Then ExportDeliverDatchas(Self, DateBegin, DateEnd);

      if (AllListBox.Items.Strings[I]='���� � ������. �������. ����� � �. ����������.') Then ExportDeliverOfficesKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='���� � ������. �������. ����� � ������ ���������� �������.') Then ExportDeliverOfficesOthers(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='���� � ������. �������. �������� ��������� � �. ����������.') Then ExportDeliverTradePremisesKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='���� � ������. �������. �������� ��������� � ������ ���������� �������.') Then ExportDeliverTradePremisesOthers(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='���� � ������. �������. ������, ���� � �. ����������.') Then ExportDeliverBasesKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='���� � ������. �������. ������, ���� � ������ ���������� �������.') Then ExportDeliverBasesOthers(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='���� � ������. �������. ������ � �. ����������.') Then ExportDeliverBuildingsKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='���� � ������. �������. ������ � ������ ���������� �������.') Then ExportDeliverBuildingsOthers(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='���� � ������. �������. ���������, ���� � �. ����������.') Then ExportDeliverRestaurantsKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='���� � ������. �������. ���������, ���� � ������ ���������� �������.') Then ExportDeliverRestaurantsOthers(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='���� � ������. �������. ������������ � �. ����������.') Then ExportDeliverProductionsKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='���� � ������. �������. ������������ � ������ ���������� �������.') Then ExportDeliverProductionsOthers(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='���� � ������. �������. ������, ����� � �. ����������.') Then ExportDeliverGaragesKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='���� � ������. �������. ������, ����� � ������ ���������� �������.') Then ExportDeliverGaragesOthers(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='���� � ������. �������. ���������� ���������� � �. ����������.') Then ExportDeliverFreePurposeKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='���� � ������. �������. ���������� ���������� � ������ ���������� �������.') Then ExportDeliverFreePurposeOthers(Self, DateBegin, DateEnd);

      if (AllListBox.Items.Strings[I]='���� � ������. �����. ����� � �. ����������.') Then ExportDeliverLandKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='���� � ������. �����. ����� � ������ ���������� �������.') Then ExportDeliverLandOthers(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='���� � ������. �����. ����� �� ����������� ��������.') Then ExportDeliverLandOutPoint(Self, DateBegin, DateEnd);

      if (AllListBox.Items.Strings[I]='����� � ������. �����. �������� � �. ����������.') Then ExportShootApartmentsKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='����� � ������. �����. �������� � ������ ���������� �������.') Then ExportShootApartmentsOthers(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='����� � ������. �����. ����, ��������, ��������� � �. ����������.') Then ExportShootHousesCottagesTownHousesKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='����� � ������. �����. ����, ��������, ��������� � ������ ���������� �������.') Then ExportShootHousesCottagesTownHousesOthers(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='����� � ������. �����. ���������� ����.') Then ExportShootOutsideHouses(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='����� � ������. �����. ���� (� ���������� ������).') Then ExportShootDatchasInPoint(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='����� � ������. �����. ���� (�� ���������� �������).') Then ExportShootDatchasOutPoint(Self, DateBegin, DateEnd);

      if (AllListBox.Items.Strings[I]='����� � ������. �������. � �. ����������.') Then ExportShootUnresidentialKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='����� � ������. �������. � ������ ���������� �������.') Then ExportShootUnresidentialOthers(Self, DateBegin, DateEnd);

      if (AllListBox.Items.Strings[I]='����� � ������. �����. � �. ����������.') Then ExportShootLandKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='����� � ������. �����. � ������ ���������� �������.') Then ExportShootLandOthers(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='����� � ������. �����. �� ����������� ��������.') Then ExportShootLandOutPoint(Self, DateBegin, DateEnd);

      if (AllListBox.Items.Strings[I]='�������. ������� �����. ������� � �. ����������.') Then ExportChangeShareResidentialKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='�������. ������� �����. ������� � ������ ���������� �������.') Then ExportChangeShareResidentialOthers(Self, DateBegin, DateEnd);

      if (AllListBox.Items.Strings[I]='�������. ������� �������. � �. ����������.') Then ExportChangeShareUnresidentialKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='�������. ������� �������. � ������ ���������� �������.') Then ExportChangeShareUnresidentialOthers(Self, DateBegin, DateEnd);

      if (AllListBox.Items.Strings[I]='�������. �����. �������� � �. ����������.') Then ExportChangeApartmentsKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='�������. �����. �������� � ������ ���������� �������.') Then ExportChangeApartmentsOthers(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='�������. �����. ����, ��������, ��������� � �. ����������.') Then ExportChangeHousesCottagesTownHousesKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='�������. �����. ����, ��������, ��������� � ������ ���������� �������.') Then ExportChangeHousesCottagesTownHousesOthers(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='�������. �����. ���������� ����.') Then ExportChangeOutsideHouses(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='�������. �����. ���� (� ���������� ������).') Then ExportChangeDatchasInPoint(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='�������. �����. ���� (�� ���������� �������).') Then ExportChangeDatchasOutPoint(Self, DateBegin, DateEnd);

      if (AllListBox.Items.Strings[I]='�������. �������. � �. ����������.') Then ExportChangeUnresidentialKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='�������. �������. � ������ ���������� �������.') Then ExportChangeUnresidentialOthers(Self, DateBegin, DateEnd);

      if (AllListBox.Items.Strings[I]='�������. �����. � �. ����������.') Then ExportChangeLandKrs(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='�������. �����. � ������ ���������� �������.') Then ExportChangeLandOthers(Self, DateBegin, DateEnd);
      if (AllListBox.Items.Strings[I]='�������. �����. �� ����������� ��������.') Then ExportChangeLandOutPoint(Self, DateBegin, DateEnd);

    end;

    SetDefaultForm(Self);
    
  End Else
    ShowMessage('���� ������ ������� ������ ���� ���������!');

end;

end.
