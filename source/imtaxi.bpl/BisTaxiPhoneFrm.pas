unit BisTaxiPhoneFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ImgList, StdCtrls, Buttons, Menus, ActnPopup,
  BisFrm, BisCallPhoneFrm;

type
  TBisTaxiPhoneFrame = class(TBisCallPhoneFrame)
    N1: TMenuItem;
    N2: TMenuItem;
    MenuItemOrder: TMenuItem;
    MenuItemBlack: TMenuItem;
    procedure PopupActionBarPopup(Sender: TObject);
    procedure MenuItemBlackClick(Sender: TObject);
    procedure MenuItemOrderClick(Sender: TObject);
  private
    function CanBlackInsert: Boolean;
    procedure BlackInsert;
    function CanOrderInsert: Boolean;
    procedure OrderInsert;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses DateUtils,
     BisUtils, BisCore, BisFm,
     BisCallResultFm,
     BisTaxiDataBlackEditFm, BisTaxiOrdersFm, BisTaxiOrdersFrm,
     BisTaxiOrderEditFm;

{$R *.dfm}

{ TBisTaxiPhoneFrame }

constructor TBisTaxiPhoneFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TBisTaxiPhoneFrame.Destroy;
begin
  inherited Destroy;
end;

procedure TBisTaxiPhoneFrame.MenuItemBlackClick(Sender: TObject);
begin
  BlackInsert;
end;

procedure TBisTaxiPhoneFrame.MenuItemOrderClick(Sender: TObject);
begin
  OrderInsert;
end;

function TBisTaxiPhoneFrame.CanBlackInsert: Boolean;
begin
  Result:=Trim(CallRealName)<>'';
  if Result then begin
    with TBisTaxiDataBlackInsertFormIface.CreateInited(nil) do begin
      try
        Result:=CanShow;
      finally
        Free;
      end;
    end;
  end;
end;

procedure TBisTaxiPhoneFrame.BlackInsert;
var
  AIface: TBisTaxiDataBlackInsertFormIface;
begin
  if CanBlackInsert then begin
    AIface:=TBisTaxiDataBlackInsertFormIface.Create(nil);
    try
      AIface.Init;
      AIface.ShowType:=stMdiChild;
      AIface.Params.ParamByName('PHONE').SetNewValue(Trim(CallRealName));
      AIface.ChangesExists:=true;
      AIface.ShowModal;
    finally
      AIface.Free;
    end;
  end;
end;

function TBisTaxiPhoneFrame.CanOrderInsert: Boolean;
var
  AIface: TBisTaxiOrdersFormIface;
begin
  Result:=Trim(CallRealName)<>'';
  if Result then begin
    AIface:=TBisTaxiOrdersFormIface(Core.FindIface(TBisTaxiOrdersFormIface));
    if Assigned(AIface) then begin
      Result:=AIface.CanShow and Assigned(AIface.LastForm) and
              Assigned(AIface.LastForm.OrdersFrame) and AIface.LastForm.OrdersFrame.CanInsertRecord;
    end;
  end;
end;

procedure TBisTaxiPhoneFrame.OrderInsert;
var
  OrdersIface: TBisTaxiOrdersFormIface;
  OrdersFrame: TBisTaxiOrdersFrame;
begin
  if CanOrderInsert then begin
    OrdersIface:=TBisTaxiOrdersFormIface(Core.FindIface(TBisTaxiOrdersFormIface));
    if Assigned(OrdersIface) then begin
      OrdersFrame:=OrdersIface.LastForm.OrdersFrame;
      if Assigned(OrdersFrame) then
        OrdersFrame.InsertRecordWithPhone(Trim(CallRealName),CallId);
    end;
  end;
end;

procedure TBisTaxiPhoneFrame.PopupActionBarPopup(Sender: TObject);
begin
  inherited PopupActionBarPopup(Sender);
  MenuItemOrder.Enabled:=CanOrderInsert;
  MenuItemBlack.Enabled:=CanBlackInsert;
end;

end.
