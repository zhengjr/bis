unit BisReportEditorFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls,
  BisFm;

type
  TBisReportEditorForm = class(TBisForm)
    StatusBar: TStatusBar;
    PanelReport: TPanel;
  private
    FSSaveChanges: String;
    FOnSaveChanges: TNotifyEvent;
    FFileName: String;
    FReportId: Variant;
    FOnPreview: TNotifyEvent;
  protected
    procedure DoSaveChanges; virtual;
    procedure DoPreview; virtual;
    function GetFileName: String; virtual;
    procedure SetFileName(const Value: String); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    function CloseQuery: Boolean; override;
    procedure BeforeShow; override;
    procedure LoadFromStream(Stream: TStream); virtual;
    procedure LoadFromFile(const FileName: String); virtual;
    procedure SaveToStream(Stream: TStream); virtual;
    procedure SaveToFile(const FileName: String); virtual;
    function Modified: Boolean; virtual;

    property FileName: String read GetFileName write SetFileName;
    property ReportId: Variant read FReportId write FReportId;

    property OnSaveChanges: TNotifyEvent read FOnSaveChanges write FOnSaveChanges;
    property OnPreview: TNotifyEvent read FOnPreview write FOnPreview;
  published
    property SSaveChanges: String read FSSaveChanges write FSSaveChanges;
  end;

  TBisReportEditorFormClass=class of TBisReportEditorForm;

  TBisReportEditorFormIface=class(TBisFormIface)
  private
    FStream: TStream;
    FFileName: String;
    FOnSaveChanges: TNotifyEvent;
    FReportId: Variant;
    FOnPreview: TNotifyEvent;
    function GetLastForm: TBisReportEditorForm;
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeforeFormShow; override;

    property LastForm: TBisReportEditorForm read GetLastForm;
    property Stream: TStream read FStream write FStream;
    property FileName: String read FFileName write FFileName;
    property ReportId: Variant read FReportId write FReportId;

    property OnSaveChanges: TNotifyEvent read FOnSaveChanges write FOnSaveChanges;
    property OnPreview: TNotifyEvent read FOnPreview write FOnPreview;
  end;

  TBisReportEditorFormIfaceClass=class of TBisReportEditorFormIface;


var
  BisReportEditorForm: TBisReportEditorForm;

implementation

{$R *.dfm}

uses
     BisDialogs;

{ TBisReportEditorFormIface }

constructor TBisReportEditorFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisReportEditorForm;
  ChangeFormCaption:=true;
  OnlyOneForm:=false;
end;

destructor TBisReportEditorFormIface.Destroy;
begin

  inherited Destroy;
end;

function TBisReportEditorFormIface.GetLastForm: TBisReportEditorForm;
begin
  Result:=TBisReportEditorForm(inherited LastForm);
end;

function TBisReportEditorFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(LastForm) then begin
    LastForm.OnSaveChanges:=FOnSaveChanges;
    LastForm.OnPreview:=FOnPreview;
  end;
end;

procedure TBisReportEditorFormIface.BeforeFormShow;
begin
  inherited BeforeFormShow;
  if Assigned(LastForm) then begin
    LastForm.FileName:=FFileName;
    LastForm.ReportId:=FReportId;
    LastForm.LoadFromStream(FStream);
  end;
end;


{ TBisReportEditorForm }

constructor TBisReportEditorForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CloseMode:=cmFree;
  FSSaveChanges:='��������� ���������?';
end;

procedure TBisReportEditorForm.DoPreview;
begin
  if Assigned(FOnPreview) then
    FOnPreview(Self);
end;

procedure TBisReportEditorForm.DoSaveChanges;
begin
  if Assigned(FOnSaveChanges) then
    FOnSaveChanges(Self);
end;

function TBisReportEditorForm.GetFileName: String;
begin
  Result:='';
end;

procedure TBisReportEditorForm.LoadFromFile(const FileName: String);
begin
end;

procedure TBisReportEditorForm.LoadFromStream(Stream: TStream);
begin
end;

function TBisReportEditorForm.Modified: Boolean;
begin
  Result:=false;
end;

procedure TBisReportEditorForm.SaveToFile(const FileName: String);
begin
end;

procedure TBisReportEditorForm.SaveToStream(Stream: TStream);
begin
end;

procedure TBisReportEditorForm.SetFileName(const Value: String);
begin
  FFileName:=Value;
end;

procedure TBisReportEditorForm.BeforeShow;
begin
  inherited BeforeShow;
end;

function TBisReportEditorForm.CloseQuery: Boolean;
begin
  Result:=inherited CloseQuery;
  if Result and Modified then begin
    case ShowQuestionCancel(FSSaveChanges,mbCancel) of
      mrYes: begin
        Result:=true;
        DoSaveChanges;
      end;
      mrNo: begin
        Result:=true;
      end;
      mrCancel: Result:=false;
    end;
  end;
end;



end.