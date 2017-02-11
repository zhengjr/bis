unit BisTaxiDataDiscountTypeEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList,
  BisDataEditFm, BisParam, BisControls;

type
  TBisTaxiDataDiscountTypeEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelType: TLabel;
    ComboBoxType: TComboBox;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    LabelPercent: TLabel;
    EditPercent: TEdit;
    LabelSum: TLabel;
    EditSum: TEdit;
    LabelProc: TLabel;
    EditProc: TEdit;
  private
  public
    procedure ChangeParam(Param: TBisParam); override;
  end;

  TBisTaxiDataDiscountTypeEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDiscountTypeFilterFormIface=class(TBisTaxiDataDiscountTypeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDiscountTypeInsertFormIface=class(TBisTaxiDataDiscountTypeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDiscountTypeUpdateFormIface=class(TBisTaxiDataDiscountTypeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDiscountTypeDeleteFormIface=class(TBisTaxiDataDiscountTypeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataDiscountTypeEditForm: TBisTaxiDataDiscountTypeEditForm;

implementation

uses BisUtils;

{$R *.dfm}

{ TBisTaxiDataDiscountTypeEditFormIface }

constructor TBisTaxiDataDiscountTypeEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataDiscountTypeEditForm;
  with Params do begin
    AddKey('DISCOUNT_TYPE_ID').Older('OLD_DISCOUNT_TYPE_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddComboBox('TYPE_CALC','ComboBoxType','LabelType',true);
    AddEdit('PROC_NAME','EditProc','LabelProc');
    AddEditFloat('PERCENT','EditPercent','LabelPercent');
    AddEditFloat('DISCOUNT_SUM','EditSum','LabelSum');
    AddEditInteger('PRIORITY','EditPriority','LabelPriority');
  end;
end;

{ TBisTaxiDataDiscountTypeFilterFormIface }

constructor TBisTaxiDataDiscountTypeFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='������ ����� ���������';
end;

{ TBisTaxiDataDiscountTypeInsertFormIface }

constructor TBisTaxiDataDiscountTypeInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_DISCOUNT_TYPE';
  Caption:='������� ��� ������';
end;

{ TBisTaxiDataDiscountTypeUpdateFormIface }

constructor TBisTaxiDataDiscountTypeUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_DISCOUNT_TYPE';
  Caption:='�������� ��� ��������';
end;

{ TBisTaxiDataDiscountTypeDeleteFormIface }

constructor TBisTaxiDataDiscountTypeDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_DISCOUNT_TYPE';
  Caption:='������� ��� ��������';
end;

{ TBisTaxiDataDiscountEditForm }

procedure TBisTaxiDataDiscountTypeEditForm.ChangeParam(Param: TBisParam);
var
  TypeDiscount: Integer;
begin
  inherited ChangeParam(Param);
  if AnsiSameText(Param.ParamName,'TYPE_CALC') and not VarIsNull(Param.Value) then begin
    TypeDiscount:=VarToIntDef(Param.Value,0);
    Provider.Params.Find('PROC_NAME').Enabled:=false;
    Provider.Params.Find('PERCENT').Enabled:=false;
    Provider.Params.Find('DISCOUNT_SUM').Enabled:=false;
    case TypeDiscount of
      1: Provider.Params.Find('PROC_NAME').Enabled:=true;
      2: Provider.Params.Find('PERCENT').Enabled:=true;
      3: Provider.Params.Find('DISCOUNT_SUM').Enabled:=true;
    end;
  end;
end;

end.