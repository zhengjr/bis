unit BisTaxiDataFirmDiscountEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  BisDataEditFm, BisParam, BisControls, ImgList;

type
  TBisTaxiDataFirmDiscountEditForm = class(TBisDataEditForm)
    LabelFirm: TLabel;
    EditFirm: TEdit;
    ButtonFirm: TButton;
    LabelDiscount: TLabel;
    EditDiscount: TEdit;
    ButtonDiscount: TButton;
    LabelPriority: TLabel;
    EditPriority: TEdit;
  private
  public
    procedure ChangeParam(Param: TBisParam); override;
  end;

  TBisTaxiDataFirmDiscountEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataFirmDiscountFilterFormIface=class(TBisTaxiDataFirmDiscountEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataFirmDiscountInsertFormIface=class(TBisTaxiDataFirmDiscountEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataFirmDiscountUpdateFormIface=class(TBisTaxiDataFirmDiscountEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataFirmDiscountDeleteFormIface=class(TBisTaxiDataFirmDiscountEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataFirmDiscountEditForm: TBisTaxiDataFirmDiscountEditForm;

implementation

uses BisUtils, BisTaxiConsts, BisTaxiDataDiscountsFm, BisCore, BisParamEditDataSelect;

{$R *.dfm}

{ TBisTaxiDataFirmDiscountEditFormIface }

constructor TBisTaxiDataFirmDiscountEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataFirmDiscountEditForm;
  with Params do begin
    AddInvisible('TYPE_DISCOUNT');
    AddInvisible('PROC_NAME');
    AddInvisible('PERCENT');
    AddInvisible('DISCOUNT_SUM');
    AddEditDataSelect('FIRM_ID','EditFirm','LabelFirm','ButtonFirm',
                      SClassDataFirmsFormIface,'FIRM_SMALL_NAME',true,true,'','SMALL_NAME').Older('OLD_FIRM_ID');
    AddEditDataSelect('DISCOUNT_ID','EditDiscount','LabelDiscount','ButtonDiscount',
                      TBisTaxiDataDiscountsFormIface,'DISCOUNT_NAME',true,true,'','NAME').Older('OLD_DISCOUNT_ID');
    AddEditInteger('PRIORITY','EditPriority','LabelPriority');                      
  end;
end;


{ TBisTaxiDataFirmDiscountFilterFormIface }

constructor TBisTaxiDataFirmDiscountFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='������ ������ �� ��������';
end;

{ TBisTaxiDataFirmDiscountInsertFormIface }

constructor TBisTaxiDataFirmDiscountInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_FIRM_DISCOUNT';
  Caption:='������� ������ �������';
end;

{ TBisTaxiDataFirmDiscountUpdateFormIface }

constructor TBisTaxiDataFirmDiscountUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_FIRM_DISCOUNT';
  Caption:='�������� ������ � �������';
end;

{ TBisTaxiDataFirmDiscountDeleteFormIface }

constructor TBisTaxiDataFirmDiscountDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_FIRM_DISCOUNT';
  Caption:='������� ������ � �������';
end;

{ TBisTaxiDataFirmDiscountEditForm }

procedure TBisTaxiDataFirmDiscountEditForm.ChangeParam(Param: TBisParam);
var
  DiscountParam: TBisParamEditDataSelect;
begin
  inherited ChangeParam(Param);
  if AnsiSameText(Param.ParamName,'DISCOUNT_NAME') then begin
    DiscountParam:=TBisParamEditDataSelect(Provider.Params.ParamByName('DISCOUNT_ID'));
    if DiscountParam.Empty then begin
      Provider.Params.ParamByName('TYPE_DISCOUNT').Value:=Null;
      Provider.Params.ParamByName('PROC_NAME').Value:=Null;
      Provider.Params.ParamByName('PERCENT').Value:=Null;
      Provider.Params.ParamByName('DISCOUNT_SUM').Value:=Null;
    end else begin
      Provider.Params.ParamByName('TYPE_DISCOUNT').Value:=DiscountParam.Values.GetValue('TYPE_DISCOUNT');
      Provider.Params.ParamByName('PROC_NAME').Value:=DiscountParam.Values.GetValue('PROC_NAME');
      Provider.Params.ParamByName('PERCENT').Value:=DiscountParam.Values.GetValue('PERCENT');
      Provider.Params.ParamByName('DISCOUNT_SUM').Value:=DiscountParam.Values.GetValue('DISCOUNT_SUM');
    end;
  end;
end;

end.