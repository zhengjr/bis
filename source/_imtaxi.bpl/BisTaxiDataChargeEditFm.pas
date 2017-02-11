unit BisTaxiDataChargeEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ImgList, Menus, ActnPopup,
  BisFm, BisDataFm, BisDataEditFm, BisParam, BisControls;

type
  TBisTaxiDataChargeEditForm = class(TBisDataEditForm)
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelSum: TLabel;
    EditSum: TEdit;
    LabelAccount: TLabel;
    LabelDateCharge: TLabel;
    DateTimePickerCharge: TDateTimePicker;
    DateTimePickerChargeTime: TDateTimePicker;
    EditAccount: TEdit;
    ButtonAccount: TButton;
    LabelType: TLabel;
    ComboBoxType: TComboBox;
    LabelWho: TLabel;
    EditWho: TEdit;
    LabelDateCreate: TLabel;
    DateTimePickerCreate: TDateTimePicker;
    DateTimePickerCreateTime: TDateTimePicker;
    ButtonWho: TButton;
    PopupAccount: TPopupActionBar;
    MenuItemAccounts: TMenuItem;
    MenuItemDrivers: TMenuItem;
    MenuItemClients: TMenuItem;
    LabelFirm: TLabel;
    ComboBoxFirm: TComboBox;
    procedure ButtonAccountClick(Sender: TObject);
    procedure PopupAccountPopup(Sender: TObject);
    procedure MenuItemAccountsClick(Sender: TObject);
    procedure MenuItemDriversClick(Sender: TObject);
    procedure MenuItemClientsClick(Sender: TObject);
  private
    FShowAnotherFirms: Boolean;
    function CanSelectAccount: Boolean;
    procedure SelectAccount;
    function CanSelectDriver: Boolean;
    procedure SelectDriver;
    function CanSelectClient: Boolean;
    procedure SelectClient;
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeforeShow; override;
//    function CheckParam(Param: TBisParam): Boolean; override;
  end;

  TBisTaxiDataChargeEditFormIface=class(TBisDataEditFormIface)
  private
    FShowAnotherFirms: Boolean;
  protected
    function CreateForm: TBisForm; override;  
  public
    constructor Create(AOwner: TComponent); override;

    property ShowAnotherFirms: Boolean read FShowAnotherFirms write FShowAnotherFirms; 
  end;

  TBisTaxiDataChargeViewFormIface=class(TBisTaxiDataChargeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataChargeInsertFormIface=class(TBisTaxiDataChargeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataChargeUpdateFormIface=class(TBisTaxiDataChargeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataChargeDeleteFormIface=class(TBisTaxiDataChargeEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataChargeEditForm: TBisTaxiDataChargeEditForm;

implementation

uses BisUtils, BisTaxiConsts, BisTaxiDataChargeTypesFm, BisCore,
     BisParamEditDataSelect, BisIfaces, BisDataSet,
     BisTaxiDataReceiptTypesFm, BisTaxiDataDriversFm, BisTaxiDataClientsFm;

{$R *.dfm}

{ TBisTaxiDataChargeEditFormIface }

constructor TBisTaxiDataChargeEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataChargeEditForm;
  with Params do begin
    AddKey('CHARGE_ID').Older('OLD_CHARGE_ID');
    AddInvisible('USER_NAME');
    AddInvisible('SURNAME');
    AddInvisible('NAME');
    AddInvisible('PATRONYMIC');
    AddInvisible('ORDER_ID');
    AddComboBoxDataSelect('CHARGE_TYPE_ID','ComboBoxType','LabelType','',
                          TBisTaxiDataChargeTypesFormIface,'CHARGE_TYPE_NAME',true,false,'','NAME');
    with AddEditDataSelect('ACCOUNT_ID','EditAccount','LabelAccount','ButtonAccount',
                           SClassDataAccountsFormIface,'USER_NAME;SURNAME;NAME;PATRONYMIC',true,false) do begin
      DataAliasFormat:='%s - %s %s %s';
    end;
    AddComboBoxDataSelect('FIRM_ID','ComboBoxFirm','LabelFirm',
                          'S_OFFICES','FIRM_SMALL_NAME',false,false,'','SMALL_NAME');
    AddEditFloat('SUM_CHARGE','EditSum','LabelSum',true);
    AddEditDateTime('DATE_CHARGE','DateTimePickerCharge','DateTimePickerChargeTime','LabelDateCharge',true).ExcludeModes([emFilter]);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddEditDataSelect('WHO_CREATE_ID','EditWho','LabelWho','ButtonWho',
                       SClassDataAccountsFormIface,'WHO_USER_NAME',true,false,'ACCOUNT_ID','USER_NAME').ExcludeModes(AllParamEditModes);
    AddEditDateTime('DATE_CREATE','DateTimePickerCreate','DateTimePickerCreateTime','LabelDateCreate',true).ExcludeModes(AllParamEditModes);
  end;

end;


function TBisTaxiDataChargeEditFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    if FShowAnotherFirms then begin
      if TBisTaxiDataChargeEditForm(Result).Mode=emFilter then
        TBisTaxiDataChargeEditForm(Result).FShowAnotherFirms:=FShowAnotherFirms;
    end;
  end;
end;

{ TBisTaxiDataChargeViewFormIface }

constructor TBisTaxiDataChargeViewFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Caption:='�������� ��������';
end;

{ TBisTaxiDataChargeInsertFormIface }

constructor TBisTaxiDataChargeInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Permissions.Enabled:=true;
  ProviderName:='I_CHARGE';
  ParentProviderName:='S_CHARGES';
  Caption:='�������� ��������';
  SMessageSuccess:='�������� ������� ���������.';
end;

{ TBisTaxiDataChargeUpdateFormIface }

constructor TBisTaxiDataChargeUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_CHARGE';
  Caption:='�������� ��������';
end;

{ TBisTaxiDataChargeDeleteFormIface }

constructor TBisTaxiDataChargeDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_CHARGE';
  Caption:='������� ��������';
end;

{ TBisTaxiDataChargeEditForm }

constructor TBisTaxiDataChargeEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FShowAnotherFirms:=VarIsNull(Core.FirmId);
end;

procedure TBisTaxiDataChargeEditForm.BeforeShow;
var
  D: TDateTime;
begin
  inherited BeforeShow;
  if Mode in [emInsert,emDuplicate] then begin
    with Provider.Params do begin
      D:=Core.ServerDate;
      Find('DATE_CHARGE').SetNewValue(D);
      Find('WHO_CREATE_ID').SetNewValue(Core.AccountId);
      Find('WHO_USER_NAME').SetNewValue(Core.AccountUserName);
      Find('DATE_CREATE').SetNewValue(D);
      Find('FIRM_ID').SetNewValue(Core.FirmId);
      Find('FIRM_SMALL_NAME').SetNewValue(Core.FirmSmallName);
    end;
  end;

  Provider.ParamByName('FIRM_ID').Enabled:=FShowAnotherFirms;

  UpdateButtonState;    
end;


procedure TBisTaxiDataChargeEditForm.ButtonAccountClick(Sender: TObject);
var
  Pt: TPoint;
begin
  Pt:=PanelControls.ClientToScreen(Point(ButtonAccount.Left,ButtonAccount.Top+ButtonAccount.Height));
  PopupAccount.Popup(Pt.X,Pt.Y);
end;

function TBisTaxiDataChargeEditForm.CanSelectAccount: Boolean;
var
  AClass: TBisIfaceClass;
  AIface: TBisDataFormIface;
begin
  AClass:=Core.FindIfaceClass(SClassDataAccountsFormIface);
  Result:=Assigned(AClass) and IsClassParent(AClass,TBisDataFormIface);
  if Result then begin
    AIface:=TBisDataFormIfaceClass(AClass).Create(nil);
    try
      AIface.Init;
      Result:=AIface.CanShow;
    finally
      AIface.Free;
    end;
  end;
end;

function TBisTaxiDataChargeEditForm.CanSelectDriver: Boolean;
var
  AIface: TBisTaxiDataDriversFormIface;
begin
  AIface:=TBisTaxiDataDriversFormIface.Create(nil);
  try
    AIface.Init;
    Result:=AIface.CanShow;
  finally
    AIface.Free;
  end;
end;

{function TBisTaxiDataChargeEditForm.CheckParam(Param: TBisParam): Boolean;
begin
  Result:=inherited CheckParam(Param);
end;}

function TBisTaxiDataChargeEditForm.CanSelectClient: Boolean;
var
  AIface: TBisTaxiDataClientsFormIface;
begin
  AIface:=TBisTaxiDataClientsFormIface.Create(nil);
  try
    AIface.Init;
    Result:=AIface.CanShow;
  finally
    AIface.Free;
  end;
end;

procedure TBisTaxiDataChargeEditForm.SelectAccount;
var
  Param: TBisParamEditDataSelect;
  AClass: TBisIfaceClass;
  AIface: TBisDataFormIface;
  DS: TBisDataSet;
  P1: TBisParam;
begin
  if CanSelectAccount then begin
    AClass:=Core.FindIfaceClass(SClassDataAccountsFormIface);
    if Assigned(AClass) and IsClassParent(AClass,TBisDataFormIface) then begin
      Param:=TBisParamEditDataSelect(Provider.Params.ParamByName('ACCOUNT_ID'));
      AIface:=TBisDataFormIfaceClass(AClass).Create(nil);
      DS:=TBisDataSet.Create(nil);
      try
        AIface.LocateFields:='ACCOUNT_ID';
        AIface.LocateValues:=Param.Value;
        if AIface.SelectInto(DS) then begin
          Param.Value:=DS.FieldByName('ACCOUNT_ID').Value;
          Provider.Params.ParamByName('USER_NAME').Value:=DS.FieldByName('USER_NAME').Value;
          Provider.Params.ParamByName('SURNAME').Value:=DS.FieldByName('SURNAME').Value;
          Provider.Params.ParamByName('NAME').Value:=DS.FieldByName('NAME').Value;
          Provider.Params.ParamByName('PATRONYMIC').Value:=DS.FieldByName('PATRONYMIC').Value;
          P1:=Provider.Params.ParamByName('USER_NAME;SURNAME;NAME;PATRONYMIC');
          P1.Value:=Provider.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
        end;
      finally
        DS.Free;
        AIface.Free;
      end;
    end;
  end;
end;

procedure TBisTaxiDataChargeEditForm.SelectDriver;
var
  Param: TBisParamEditDataSelect;
  AIface: TBisTaxiDataDriversFormIface;
  DS: TBisDataSet;
  P1: TBisParam;
begin
  if CanSelectDriver then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName('ACCOUNT_ID'));
    AIface:=TBisTaxiDataDriversFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      AIface.LocateFields:='DRIVER_ID';
      AIface.LocateValues:=Param.Value;
      if AIface.SelectInto(DS) then begin
        Param.Value:=DS.FieldByName('DRIVER_ID').Value;
        Provider.Params.ParamByName('USER_NAME').Value:=DS.FieldByName('USER_NAME').Value;
        Provider.Params.ParamByName('SURNAME').Value:=DS.FieldByName('SURNAME').Value;
        Provider.Params.ParamByName('NAME').Value:=DS.FieldByName('NAME').Value;
        Provider.Params.ParamByName('PATRONYMIC').Value:=DS.FieldByName('PATRONYMIC').Value;
        P1:=Provider.Params.ParamByName('USER_NAME;SURNAME;NAME;PATRONYMIC');
        P1.Value:=Provider.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

procedure TBisTaxiDataChargeEditForm.SelectClient;
var
  Param: TBisParamEditDataSelect;
  AIface: TBisTaxiDataClientsFormIface;
  DS: TBisDataSet;
  P1: TBisParam;
begin
  if CanSelectClient then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName('ACCOUNT_ID'));
    AIface:=TBisTaxiDataClientsFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      AIface.LocateFields:='ID';
      AIface.LocateValues:=Param.Value;
      if AIface.SelectInto(DS) then begin
        Param.Value:=DS.FieldByName('ID').Value;
        Provider.Params.ParamByName('USER_NAME').Value:=DS.FieldByName('USER_NAME').Value;
        Provider.Params.ParamByName('SURNAME').Value:=DS.FieldByName('SURNAME').Value;
        Provider.Params.ParamByName('NAME').Value:=DS.FieldByName('NAME').Value;
        Provider.Params.ParamByName('PATRONYMIC').Value:=DS.FieldByName('PATRONYMIC').Value;
        P1:=Provider.Params.ParamByName('USER_NAME;SURNAME;NAME;PATRONYMIC');
        P1.Value:=Provider.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

procedure TBisTaxiDataChargeEditForm.PopupAccountPopup(Sender: TObject);
begin
  MenuItemAccounts.Enabled:=CanSelectAccount;
  MenuItemDrivers.Enabled:=CanSelectDriver;
  MenuItemClients.Enabled:=CanSelectClient;
end;

procedure TBisTaxiDataChargeEditForm.MenuItemAccountsClick(Sender: TObject);
begin
  SelectAccount;
end;


procedure TBisTaxiDataChargeEditForm.MenuItemDriversClick(Sender: TObject);
begin
  SelectDriver;
end;

procedure TBisTaxiDataChargeEditForm.MenuItemClientsClick(Sender: TObject);
begin
  SelectClient;
end;


end.