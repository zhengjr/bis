unit BisKrieltDataPlacementEditFm;

interface
                                                                                                    
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ImgList,
  BisDataEditFm, BisParam, BisControls;

type
  TBisKrieltDataPlacementEditForm = class(TBisDataEditForm)
    LabelPage: TLabel;
    EditPage: TEdit;
    ButtonPage: TButton;
    LabelBanner: TLabel;
    EditBanner: TEdit;
    LabelAccount: TLabel;
    EditAccount: TEdit;
    ButtonAccount: TButton;
    LabelPlace: TLabel;
    ComboBoxPlace: TComboBox;
    LabelDateBegin: TLabel;
    DateTimePickerBegin: TDateTimePicker;
    LabelDateEnd: TLabel;
    DateTimePickerEnd: TDateTimePicker;
    LabelWhoplaced: TLabel;
    EditWhoplaced: TEdit;
    ButtonWhoplaced: TButton;
    LabelDatePlaced: TLabel;
    DateTimePickerDatePlacedDate: TDateTimePicker;
    DateTimePickerDatePlacedTime: TDateTimePicker;
    LabelPriority: TLabel;
    EditPriority: TEdit;
    LabelCounter: TLabel;
    EditCounter: TEdit;
    CheckBoxRestricted: TCheckBox;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeforeShow; override;
  end;

  TBisKrieltDataPlacementEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataPlacementFilterFormIface=class(TBisKrieltDataPlacementEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataPlacementInsertFormIface=class(TBisKrieltDataPlacementEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataPlacementUpdateFormIface=class(TBisKrieltDataPlacementEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataPlacementDeleteFormIface=class(TBisKrieltDataPlacementEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataPlacementEditForm: TBisKrieltDataPlacementEditForm;

implementation

uses Dateutils,
     BisKrieltDataBannersFm, BisKrieltDataPagesFm,
     BisCore, BisFilterGroups, BisKrieltConsts;

{$R *.dfm}

{ TBisKrieltDataPlacementEditFormIface }

constructor TBisKrieltDataPlacementEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataPlacementEditForm;
  with Params do begin
    AddKey('PLACEMENT_ID').Older('OLD_PLACEMENT_ID');
    AddEditDataSelect('BANNER_ID','EditBanner','LabelBanner','ButtonBanner',
                      TBisKrieltDataBannersFormIface,'BANNER_NAME',true,false,'','NAME');
    AddEditDataSelect('PAGE_ID','EditPage','LabelPage','ButtonPage',
                      TBisKrieltDataPagesFormIface,'PAGE_NAME',false,false,'','NAME');
    AddEditDataSelect('ACCOUNT_ID','EditAccount','LabelAccount','ButtonAccount',
                      SIfaceClassDataRolesAndAccountsFormIface,'USER_NAME',false,false);
    AddComboBoxTextIndex('PLACE','ComboBoxPlace','LabelPlace',true);
    AddEditDate('DATE_BEGIN','DateTimePickerBegin','LabelDateBegin',true).FilterCondition:=fcEqualGreater;
    AddEditDate('DATE_END','DateTimePickerEnd','LabelDateEnd').FilterCondition:=fcEqualLess;
    AddEditInteger('PRIORITY','EditPriority','LabelPriority',true);
    AddEditInteger('COUNTER','EditCounter','LabelCounter');
    AddCheckBox('RESTRICTED','CheckBoxRestricted');
    AddEditDataSelect('WHO_PLACED','EditWhoplaced','LabelWhoplaced','ButtonWhoplaced',
                      SIfaceClassDataAccountsFormIface,'WHO_PLACED_NAME',true,false,'ACCOUNT_ID','USER_NAME').ExcludeModes(AllParamEditModes);
    AddEditDateTime('DATE_PLACED','DateTimePickerDatePlacedDate','DateTimePickerDatePlacedTime','LabelDatePlaced',true).ExcludeModes(AllParamEditModes);
  end;
end;

{ TBisKrieltDataPlacementFilterFormIface }

constructor TBisKrieltDataPlacementFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

{ TBisKrieltDataPlacementInsertFormIface }

constructor TBisKrieltDataPlacementInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_PLACEMENT';
end;

{ TBisKrieltDataPlacementUpdateFormIface }

constructor TBisKrieltDataPlacementUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_PLACEMENT';
end;

{ TBisKrieltDataPlacementDeleteFormIface }

constructor TBisKrieltDataPlacementDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_PLACEMENT';
end;


{ TBisKrieltDataPlacementEditForm }

constructor TBisKrieltDataPlacementEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TBisKrieltDataPlacementEditForm.BeforeShow;
begin
  inherited BeforeShow;
  if Mode in [emInsert,emDuplicate] then begin
    with Provider.Params do begin
      Find('DATE_BEGIN').SetNewValue(DateOf(Date));
      Find('WHO_PLACED').SetNewValue(Core.AccountId);
      Find('WHO_PLACED_NAME').SetNewValue(Core.AccountUserName);
      Find('DATE_PLACED').SetNewValue(Now);
    end;
  end;
  UpdateButtonState;
end;


end.