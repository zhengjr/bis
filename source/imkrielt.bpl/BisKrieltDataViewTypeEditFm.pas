unit BisKrieltDataViewTypeEditFm;

interface                                                                                                  

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList, DB,
  BisDataEditFm, BisControls;

type
  TBisKrieltDataViewTypeEditForm = class(TBisDataEditForm)
    LabelView: TLabel;
    EditView: TEdit;
    ButtonView: TButton;
    LabelType: TLabel;
    EditType: TEdit;
    ButtonType: TButton;
    LabelPriority: TLabel;
    EditPriority: TEdit;
  private
    { Private declarations }
  public
    function CanShow: Boolean; override;
  end;

  TBisKrieltDataViewTypeEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataViewTypeFilterFormIface=class(TBisKrieltDataViewTypeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataViewTypeInsertFormIface=class(TBisKrieltDataViewTypeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataViewTypeUpdateFormIface=class(TBisKrieltDataViewTypeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataViewTypeDeleteFormIface=class(TBisKrieltDataViewTypeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataViewTypeEditForm: TBisKrieltDataViewTypeEditForm;

implementation

uses BisParam, BisParamEditDataSelect, BisKrieltDataTypesFm, BisKrieltDataViewsFm;

{$R *.dfm}

{ TBisKrieltDataViewTypeEditFormIface }

constructor TBisKrieltDataViewTypeEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataViewTypeEditForm;
  with Params do begin
    AddInvisible('VIEW_NUM',ptUnknown);
    AddInvisible('VIEW_NAME',ptUnknown);
    AddInvisible('TYPE_NUM',ptUnknown);
    AddInvisible('TYPE_NAME',ptUnknown);
    with AddEditDataSelect('VIEW_ID','EditView','LabelView','ButtonView',
                           TBisKrieltDataViewsFormIface,'VIEW_NUM;VIEW_NAME',true,true,'','NUM;NAME') do begin
      DataAliasFormat:='%s - %s';                           
      Older('OLD_VIEW_ID');
    end;
    with AddEditDataSelect('TYPE_ID','EditType','LabelType','ButtonType',
                           TBisKrieltDataTypesFormIface,'TYPE_NUM;TYPE_NAME',true,true,'','NUM;NAME') do begin
      DataAliasFormat:='%s - %s';                           
      Older('OLD_TYPE_ID');
    end;
    AddEditInteger('PRIORITY','EditPriority','LabelPriority',true);
  end;
end;

{ TBisKrieltDataViewTypeFilterFormIface }

constructor TBisKrieltDataViewTypeFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

{ TBisKrieltDataViewTypeInsertFormIface }

constructor TBisKrieltDataViewTypeInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_VIEW_TYPE';
end;

{ TBisKrieltDataViewTypeUpdateFormIface }

constructor TBisKrieltDataViewTypeUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_VIEW_TYPE';
end;

{ TBisKrieltDataViewTypeDeleteFormIface }

constructor TBisKrieltDataViewTypeDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_VIEW_TYPE';
end;

{ TBisKrieltDataViewTypeEditForm }

function TBisKrieltDataViewTypeEditForm.CanShow: Boolean;
var
  Param: TBisParamEditDataSelect;
begin
  Result:=inherited CanShow;
  if Result and (Mode in [emInsert]) then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName('TYPE_ID'));
    if Assigned(Param) then
      Result:=Param.Select;
  end;
end;

end.