unit NewUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dws2Exprs, dws2Symbols, StdCtrls;

type
  TNotifyEvent2=procedure (Sender1: TObject; Sender2: TObject) of object;

  TNewForm = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    procedure FormClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FInfo: TProgramInfo;
    FNewOnClick: String;
    FOnClick2: TNotifyEvent2;
  public
    procedure Click; override;
    property Info: TProgramInfo read FInfo write FInfo;
    property NewOnClick: String read FNewOnClick write FNewOnClick;
  published
    property OnClick2: TNotifyEvent2 read FOnClick2 write FOnClick2;
  end;

var
  NewForm: TNewForm;

implementation

{$R *.dfm}

procedure TNewForm.FormClick(Sender: TObject);
var
  V: Variant;
  Func: IInfo;
  Prop: TPropertySymbol;
  sym: TSymbol;
begin
(*  if Assigned(FInfo) then begin
      sym:=FInfo.Caller.Root.RootTable.FindSymbol(FNewOnClick);
      if Assigned(sym) then begin
        Func:=FInfo.Caller.Root.Info.Func[FNewOnClick];
        if Assigned(Func) then begin
          Func.Parameter['Sender'].Value:=FInfo.Caller.Root.Info.RegisterExternalObject(Self,false,true);
          Func.Call;
        end;
      end else begin
        sym:=FInfo.ScriptObj.ClassSym.Members.FindSymbol(FNewOnClick);
        if Assigned(sym) then begin
{          FInfo.ScriptObj.ClassSym.
          if Assigned(Func) then begin
            Func.Parameter['Sender'].Value:=FInfo.RegisterExternalObject(Self,false,true);
            Func.Call;
          end;        }
        end;
      end;
  end else*)
    ShowMessage('Nil');

end;


procedure TNewForm.FormDestroy(Sender: TObject);
begin
  ShowMessage('FormDestroy');
end;

procedure TNewForm.Click;
begin
  inherited Click();
  if Assigned(FOnClick2) then
    FOnClick2(Self,nil);
end;

initialization
  RegisterClass(TnewForm);
  RegisterClass(TButton);

end.