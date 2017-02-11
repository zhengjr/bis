unit BisDetailMsgFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, OleCtrls, SHDocVw, BisFm;

type
  TBisDetailMsgForm = class(TForm)
    iIcon: TImage;
    bTimer: TSpeedButton;
    Timer: TTimer;
    ButtonOk: TButton;
    ButtonDetail: TButton;
    MemoMessage: TMemo;
    PanelDetail: TPanel;
    WebBrowserDetail: TWebBrowser;
    procedure FormCreate(Sender: TObject);
    procedure ButtonDetailClick(Sender: TObject);
    procedure bTimerClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FDetailed: Boolean;
    FDlgType: TMsgDlgType;
    FSeconds: Integer;
    FHelpContext: Integer;

    FSConfirmation: String;
    FSWarning: String;
    FSError: String;
    FSInformation: String;
    FSSuspendTimer: String;
    FSResumeTimer: String;
    FSButtonCaptionOK: String;
  public
    property DlgType: TMsgDlgType read FDlgType write FDlgType;
    property Seconds: Integer read FSeconds write FSeconds;
    property HelpContext: Integer read FHelpContext write FHelpContext;

  published
    property SConfirmation: String read FSConfirmation write FSConfirmation;
    property SWarning: String read FSWarning write FSWarning;
    property SError: String read FSError write FSError;
    property SInformation: String read FSInformation write FSInformation;
    property SSuspendTimer: String read FSSuspendTimer write FSSuspendTimer;
    property SResumeTimer: String read FSResumeTimer write FSResumeTimer;
    property SButtonCaptionOK: String read FSButtonCaptionOK write FSButtonCaptionOK;
  end;

var
  BisDetailMsgForm: TBisDetailMsgForm;

procedure BisDetailMessageBox(Msg, Title: string; DlgType: TMsgDlgType; HelpContext: Integer;
                              Seconds: Integer; Detailed: Boolean=false; UseTimer: Boolean=true);

implementation

{$R *.dfm}

uses BisConsts, BisCore, BisUtils, BisCoreUtils;

const
  IconIDs: array[TMsgDlgType] of PChar = (IDI_EXCLAMATION, IDI_HAND,
                                          IDI_ASTERISK, IDI_QUESTION, nil);

procedure BisDetailMessageBox(Msg, Title: string; DlgType: TMsgDlgType; HelpContext: Integer;
                              Seconds: Integer; Detailed: Boolean=false; UseTimer: Boolean=true);
var
  Form: TBisDetailMsgForm;
begin
  Form:=TBisDetailMsgForm.Create(nil);
  try
    TranslateObject(Form);
    Form.Font.Assign(Screen.HintFont);
    Form.MemoMessage.Lines.Text:=Msg;
    Form.Caption:=Title;
    Form.DlgType:=DlgType;
    Form.Seconds:=Seconds;
    Form.HelpContext:=HelpContext;
    if UseTimer then
      Form.bTimer.Hint := Form.SSuspendTimer
    else
      Form.bTimer.Hint := Form.SResumeTimer;
    Form.bTimer.Down:=UseTimer;
    Form.bTimer.Visible:=UseTimer;
    Form.ShowModal;
  finally
    Form.Free;
  end;
end;

{ TBisDetailMsgForm }

procedure TBisDetailMsgForm.FormCreate(Sender: TObject);
begin
  inherited;
  FDetailed:=true;
  ButtonDetailClick(nil);

  FSConfirmation:='�������������';
  FSWarning:='��������������';
  FSError:='������';
  FSInformation:='����������';
  FSSuspendTimer:='���������� ������';
  FSResumeTimer:='��������� ������';
  FSButtonCaptionOK:='��';
end;

procedure TBisDetailMsgForm.FormShow(Sender: TObject);
var
  IconID: PChar;
begin
  bTimer.Visible := bTimer.Visible and (Seconds > 0);

  IconID := IconIDs[DlgType];

  if IconID <> nil then
    iIcon.Picture.Icon.Handle := LoadIcon(0, IconID)
  else
    iIcon.Picture.Icon := Application.Icon;

  if Caption = '' then
    if DlgType <> mtCustom then begin
      case DlgType of
        mtWarning: Caption:=FSWarning;
        mtError: Caption:=FSError;
        mtInformation: Caption:=FSInformation;
        mtConfirmation: Caption:=FSConfirmation;
      end;
    end else
      Caption := Application.Title;

  Left := (Screen.Width div 2) - (Width div 2);
  Top := (Screen.Height div 2) - (Height div 2);

  Timer.Enabled := bTimer.Visible;
end;

procedure TBisDetailMsgForm.TimerTimer(Sender: TObject);
begin
  Dec(FSeconds);
  if bTimer.Visible then
    ButtonOk.Caption:=Core.Translate(SButtonCaptionOK) + ' (' + IntToStr(FSeconds) + ')'
  else ButtonOk.Caption:=Core.Translate(SButtonCaptionOK);
  if FSeconds <= 0 then
  begin
    ModalResult:=ButtonOk.ModalResult;
    bTimer.Down:=False;
    Timer.Enabled:=False
  end
end;

procedure TBisDetailMsgForm.bTimerClick(Sender: TObject);
begin
  Timer.Enabled := bTimer.Down;
  if bTimer.Down then
    bTimer.Hint := Core.Translate(SSuspendTimer)
  else
    bTimer.Hint := Core.Translate(SResumeTimer);
end;

procedure TBisDetailMsgForm.ButtonDetailClick(Sender: TObject);
begin
  if FDetailed then
    Height:=95
  else Height:=300;
  FDetailed:=not FDetailed;
end;

end.