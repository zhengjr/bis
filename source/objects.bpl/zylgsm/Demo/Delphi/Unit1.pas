unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ZylGSM;

type
  TForm1 = class(TForm)
    Memo: TMemo;
    btnOpen: TButton;
    txtNo: TEdit;
    btnSendStr: TButton;
    btnClose: TButton;
    lstPort: TListBox;
    lstBaudRate: TListBox;
    ZylGSM: TZylGSM;
    btnDial: TButton;
    btnAnswer: TButton;
    btnSendSMSText: TButton;
    txtMessage: TMemo;
    btnTerminate: TButton;
    btnSendSMSPDU: TButton;
    btnDetect: TButton;
    lblDetect: TLabel;
    btnCancel: TButton;
    procedure ZylGSMReceive(Sender: TObject; Buffer: String);
    procedure btnOpenClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSendStrClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ZylGSMDisconnect(Sender: TObject; Port: TCommPort);
    procedure ZylGSMConnect(Sender: TObject; Port: TCommPort);
    procedure btnDialClick(Sender: TObject);
    procedure btnAnswerClick(Sender: TObject);
    procedure btnSendSMSTextClick(Sender: TObject);
    procedure btnTerminateClick(Sender: TObject);
    procedure btnSendSMSPDUClick(Sender: TObject);
    procedure ZylGSMRing(Sender: TObject; CallerNumber: String);
    procedure ZylGSMNewMessage(Sender: TObject; Storage: String;
      Index: Integer);
    procedure ZylGSMReadMessage(Sender: TObject; MessageText, PhoneNumber,
      CenterNumber: String; Status: Integer);
    procedure btnDetectClick(Sender: TObject);
    procedure ZylGSMDetect(Sender: TObject; const Port: TCommPort;
      const BaudRate: TBaudRate; var Cancel: Boolean);
    procedure btnCancelClick(Sender: TObject);
  private
    FLastStorage: String;
    FLastIndex: Integer;
    FCancelDetect: Boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.ZylGSMReceive(Sender: TObject; Buffer: String);
begin
  Memo.Lines.Add(Buffer)
end;

procedure TForm1.btnOpenClick(Sender: TObject);
begin
  ZylGSM.Port := TCommPort(lstPort.ItemIndex + 1);
  ZylGSM.BaudRate := ZylGSM.IntToBaudRate(
  StrToInt(lstBaudRate.Items[lstBaudRate.ItemIndex]));
  ZylGSM.Open;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ZylGSM.Close();
end;

procedure TForm1.btnSendStrClick(Sender: TObject);
begin
  ZylGSM.SendString(txtMessage.Text + #13); 
end;

procedure TForm1.btnCloseClick(Sender: TObject);
begin
  ZylGSM.Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  comPorts: TCommPortSet;
  i: TCommPort;
begin
  comPorts := ZylGSM.GetExistingCommPorts();
  Memo.Lines.Add('Installed COMM Ports:');
  for i := spCOM1 to spCOM99 do
  begin
    if i in comPorts then
      Memo.Lines.Add(ZylGSM.CommPortToString(i));
  end;
  
  lstBaudRate.ItemIndex := 6;
end;

procedure TForm1.ZylGSMDisconnect(Sender: TObject; Port: TCommPort);
begin
  Memo.Lines.Add('Disconnected from ' + ZylGSM.CommPortToString(Port));
end;

procedure TForm1.ZylGSMConnect(Sender: TObject; Port: TCommPort);
begin
  Memo.Lines.Add('Connected to ' + ZylGSM.CommPortToString(Port));
end;

procedure TForm1.btnDialClick(Sender: TObject);
begin
  ZylGSM.DialVoice(txtNo.Text);
end;

procedure TForm1.btnAnswerClick(Sender: TObject);
begin
  ZylGSM.AnswerCall;
end;

procedure TForm1.btnSendSMSTextClick(Sender: TObject);
begin
  ZylGSM.SendSmsAsText(txtNo.Text, '', txtMessage.Text);
end;

procedure TForm1.btnTerminateClick(Sender: TObject);
begin
  ZylGSM.TerminateCall;
end;

procedure TForm1.btnSendSMSPDUClick(Sender: TObject);
begin
  ZylGSM.SendSmsAsPDU(txtNo.Text, '', txtMessage.Text);
end;

procedure TForm1.ZylGSMRing(Sender: TObject; CallerNumber: String);
begin
  Memo.Lines.Add('RING EVENT: ' + CallerNumber);
end;

procedure TForm1.ZylGSMNewMessage(Sender: TObject; Storage: String;
  Index: Integer);
begin
  Memo.Lines.Add('New SMS');
  FLastStorage:=Storage;
  FLastIndex:=Index;
end;

procedure TForm1.ZylGSMReadMessage(Sender: TObject; MessageText,
  PhoneNumber, CenterNumber: String; Status: Integer);
begin
  Memo.Lines.Add('SMS: ' + MessageText);
  Memo.Lines.Add('Caller: ' + PhoneNumber);
  Memo.Lines.Add('Center: ' + CenterNumber);
  Memo.Lines.Add('Status: ' + IntToStr(Status));
  ZylGSM.DeleteSMS(FLastStorage,FLastIndex);
end;

procedure TForm1.btnDetectClick(Sender: TObject);
var
  pPort: TCommPort;
  pBaudRate: TBaudRate;
begin
  FCancelDetect := False;
  if ZylGSM.DetectGSM(pPort, pBaudRate) then
  begin
    ShowMessage('Detected: ' + ZylGSM.CommPortToString(pPort) +
      ' BaudRate = ' + IntToStr(ZylGSM.BaudRateToInt(pBaudRate)));
    lstPort.ItemIndex := lstPort.Items.IndexOf(ZylGSM.CommPortToString(pPort));
    lstBaudRate.ItemIndex := lstBaudRate.Items.IndexOf(IntToStr(ZylGSM.BaudRateToInt(pBaudRate)));
  end
  else
  begin
    ShowMessage('No GSM detected.');
  end;
  lblDetect.Caption := ''
end;

procedure TForm1.ZylGSMDetect(Sender: TObject; const Port: TCommPort;
  const BaudRate: TBaudRate; var Cancel: Boolean);
begin
  lblDetect.Caption := 'Detecting - Port: ' + ZylGSM.CommPortToString(Port) +
      ' BaudRate: ' + IntToStr(ZylGSM.BaudRateToInt(BaudRate));
  Cancel := FCancelDetect;
end;

procedure TForm1.btnCancelClick(Sender: TObject);
begin
  FCancelDetect := True;
end;

end.