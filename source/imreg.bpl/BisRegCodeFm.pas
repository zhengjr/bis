unit BisRegCodeFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDialogFm, BisControls;

type
  TBisRegCodeForm = class(TBisDialogForm)
    LabelCode: TLabel;
    GroupBoxDesc: TGroupBox;
    MemoDesc: TMemo;
    MemoCode: TMemo;
    procedure MemoCodeChange(Sender: TObject);
    procedure MemoCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
  public
  end;

var
  BisRegCodeForm: TBisRegCodeForm;

implementation

{$R *.dfm}

{ TBisRegCodeForm }

procedure TBisRegCodeForm.MemoCodeChange(Sender: TObject);
begin
  ButtonOk.Enabled:=Trim(MemoCode.Text)<>'';
end;

procedure TBisRegCodeForm.MemoCodeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_ESCAPE then
    ButtonCancel.Click;

  if Key=VK_RETURN then
    ButtonOk.Click;
end;

end.