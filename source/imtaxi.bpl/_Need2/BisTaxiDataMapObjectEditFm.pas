unit BisTaxiDataMapObjectEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList,
  BisDataEditFm, BisParam, BisControls;

type                                                                                                       
  TBisTaxiDataMapObjectEditForm = class(TBisDataEditForm)
    LabelLon: TLabel;
    EditLon: TEdit;
    LabelLat: TLabel;
    EditLat: TEdit;
    LabelStreet: TLabel;
    EditStreet: TEdit;
    ButtonStreet: TButton;
    LabelHouse: TLabel;
    EditHouse: TEdit;
  private
  public
    procedure BeforeShow; override;

  end;

  TBisTaxiDataMapObjectEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataMapObjectFilterFormIface=class(TBisTaxiDataMapObjectEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataMapObjectInsertFormIface=class(TBisTaxiDataMapObjectEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataMapObjectUpdateFormIface=class(TBisTaxiDataMapObjectEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataMapObjectDeleteFormIface=class(TBisTaxiDataMapObjectEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataMapObjectEditForm: TBisTaxiDataMapObjectEditForm;

implementation

uses BisUtils, BisTaxiConsts, BisParamEditFloat,
     BisDesignDataStreetsFm;

{$R *.dfm}

{ TBisTaxiDataMapObjectEditFormIface }

constructor TBisTaxiDataMapObjectEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataMapObjectEditForm;
  with Params do begin
    AddInvisible('LOCALITY_PREFIX');
    AddInvisible('LOCALITY_NAME');
    AddInvisible('STREET_PREFIX');
    AddInvisible('STREET_NAME');
    with AddEditDataSelect('STREET_ID','EditStreet','LabelStreet','ButtonStreet',
                            TBisDesignDataStreetsFormIface,'STREET_PREFIX;STREET_NAME;LOCALITY_PREFIX;LOCALITY_NAME',
                            true,true,'STREET_ID','PREFIX;NAME;LOCALITY_PREFIX;LOCALITY_NAME') do begin
      DataAliasFormat:='%s%s, %s%s';
      Older('OLD_STREET_ID');
      ExcludeModes([emFilter]);
    end;
    with AddEdit('HOUSE','EditHouse','LabelHouse',true) do begin
      IsKey:=true;
      Older('OLD_HOUSE');
    end;
    with AddEditFloat('LAT','EditLat','LabelLat',true) do begin
      ParamFormat:='#0.000000000';
      ExcludeModes([emFilter]);
    end;
    with AddEditFloat('LON','EditLon','LabelLon',true) do begin
      ParamFormat:='#0.000000000';
      ExcludeModes([emFilter]);
    end;
  end;
end;

{ TBisTaxiDataMapObjectFilterFormIface }

constructor TBisTaxiDataMapObjectFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='������ �������� �����';
end;

{ TBisTaxiDataMapObjectInsertFormIface }

constructor TBisTaxiDataMapObjectInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_MAP_OBJECT';
  Caption:='������� ������ �����';
end;

{ TBisTaxiDataMapObjectUpdateFormIface }

constructor TBisTaxiDataMapObjectUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_MAP_OBJECT';
  Caption:='�������� ������ �����';
end;

{ TBisTaxiDataMapObjectDeleteFormIface }

constructor TBisTaxiDataMapObjectDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_MAP_OBJECT';
  Caption:='������� ������ �����';
end;

{ TBisTaxiDataMapObjectEditForm }

procedure TBisTaxiDataMapObjectEditForm.BeforeShow;
begin
  inherited BeforeShow;
{  with Provider.Params do begin
    TBisParamEditFloat(Find('LAT')).EditFloat.Decimals:=9;
    TBisParamEditFloat(Find('LON')).EditFloat.Decimals:=9;
  end;}
end;

end.