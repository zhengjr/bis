unit BisTaxiDataReceiptTypeEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisParam, BisControls, ImgList;

type
  TBisTaxiDataReceiptTypeEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelSum: TLabel;
    EditSum: TEdit;
  private
  public
  end;

  TBisTaxiDataReceiptTypeEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataReceiptTypeFilterFormIface=class(TBisTaxiDataReceiptTypeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataReceiptTypeInsertFormIface=class(TBisTaxiDataReceiptTypeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataReceiptTypeUpdateFormIface=class(TBisTaxiDataReceiptTypeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataReceiptTypeDeleteFormIface=class(TBisTaxiDataReceiptTypeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataReceiptTypeEditForm: TBisTaxiDataReceiptTypeEditForm;

implementation

uses BisUtils;

{$R *.dfm}

{ TBisTaxiDataReceiptTypeEditFormIface }

constructor TBisTaxiDataReceiptTypeEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataReceiptTypeEditForm;
  with Params do begin
    AddKey('RECEIPT_TYPE_ID').Older('OLD_RECEIPT_TYPE_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddEditFloat('SUM_RECEIPT','EditSum','LabelSum');
  end;
end;

{ TBisTaxiDataReceiptTypeFilterFormIface }

constructor TBisTaxiDataReceiptTypeFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='������ ����� �����������';
end;

{ TBisTaxiDataReceiptTypeInsertFormIface }

constructor TBisTaxiDataReceiptTypeInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_RECEIPT_TYPE';
  Caption:='������� ��� �����������';
end;

{ TBisTaxiDataReceiptTypeUpdateFormIface }

constructor TBisTaxiDataReceiptTypeUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_RECEIPT_TYPE';
  Caption:='�������� ��� �����������';
end;

{ TBisTaxiDataReceiptTypeDeleteFormIface }

constructor TBisTaxiDataReceiptTypeDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_RECEIPT_TYPE';
  Caption:='������� ��� �����������';
end;

end.