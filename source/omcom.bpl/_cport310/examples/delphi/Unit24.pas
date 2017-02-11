unit Unit24;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  BisBarcodeScanner;

type
  TForm24 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FBarcodeScanner: TBisBarcodeScanner;
    procedure BarcodeScannerBarcode(Sender: TObject; const Barcode: String);
    procedure BarcodeScannerStatus(Sender: TObject; const Message: String);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  Form24: TForm24;

implementation

{$R *.dfm}

{ TForm24 }

constructor TForm24.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBarcodeScanner:=TBisBarcodeScanner.Create(nil);
  FBarcodeScanner.OnBarcode:=BarcodeScannerBarcode;
  FBarcodeScanner.OnStatus:=BarcodeScannerStatus;
end;

destructor TForm24.Destroy;
begin
  FBarcodeScanner.Free;
  inherited Destroy;
end;

procedure TForm24.BarcodeScannerBarcode(Sender: TObject; const Barcode: String);
begin
  Edit1.Text:=Barcode;
end;

procedure TForm24.BarcodeScannerStatus(Sender: TObject; const Message: String);
begin
  Memo1.Lines.Add(Message);
end;

procedure TForm24.Button1Click(Sender: TObject);
begin
  FBarcodeScanner.Port:=Edit2.Text;
  FBarcodeScanner.Connect;
  Button1.Enabled:=not FBarcodeScanner.Connected;
  Button2.Enabled:=not Button1.Enabled;
end;


procedure TForm24.Button2Click(Sender: TObject);
begin
  FBarcodeScanner.Disconnet;
  Button1.Enabled:=not FBarcodeScanner.Connected;
  Button2.Enabled:=not Button1.Enabled;
end;

end.