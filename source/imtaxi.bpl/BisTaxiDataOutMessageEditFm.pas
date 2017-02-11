unit BisTaxiDataOutMessageEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, DB, ImgList, Menus, ActnPopup,
  BisFm, BisDataFm, BisDataEditFm, BisParam,
  BisMessDataOutMessageEditFm, BisMessDataOutMessageFilterFm, BisMessDataOutMessageInsertExFm,
  BisControls;

type
  TBisTaxiDataOutMessageEditForm = class(TBisMessDataOutMessageEditForm)
    PopupAccount: TPopupActionBar;
    MenuItemAccounts: TMenuItem;
    MenuItemDrivers: TMenuItem;
    MenuItemClients: TMenuItem;
    procedure ButtonRecipientClick(Sender: TObject);
    procedure PopupAccountPopup(Sender: TObject);
    procedure MenuItemAccountsClick(Sender: TObject);
    procedure MenuItemDriversClick(Sender: TObject);
    procedure MenuItemClientsClick(Sender: TObject);
  private
    function CanSelectAccount: Boolean;
    procedure SelectAccount;
    function CanSelectDriver: Boolean;
    procedure SelectDriver;
    function CanSelectClient: Boolean;
    procedure SelectClient;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataOutMessageEditFormIface=class(TBisMessDataOutMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataOutMessageViewFormIface=class(TBisTaxiDataOutMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataOutMessageInsertFormIface=class(TBisTaxiDataOutMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataOutMessageInsertExFormIface=class(TBisMessDataOutMessageInsertExFormIface)
  end;

  TBisTaxiDataOutMessageUpdateFormIface=class(TBisTaxiDataOutMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataOutMessageDeleteFormIface=class(TBisTaxiDataOutMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataOutMessageEditForm: TBisTaxiDataOutMessageEditForm;

implementation

uses BisUtils, BisCore, BisFilterGroups, BisParamEditDataSelect,
     BisProvider, BisIfaces, BisDataSet,
     BisDesignDataAccountsFm, BisMessDataPatternMessagesFm,
     BisTaxiDataDriversFm, BisTaxiDataClientsFm;

{$R *.dfm}

{ TBisTaxiDataOutMessageEditFormIface }

constructor TBisTaxiDataOutMessageEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataOutMessageEditForm;
  Params.AddInvisible('ORDER_ID');
end;

{ TBisTaxiDataOutMessageViewFormIface }

constructor TBisTaxiDataOutMessageViewFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  with TBisMessDataOutMessageViewFormIface.CreateInited(nil) do begin
    try
      Self.Caption:=Caption;
    finally
      Free;
    end;
  end;
end;

{ TBisTaxiDataOutMessageInsertFormIface }

constructor TBisTaxiDataOutMessageInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  with TBisMessDataOutMessageInsertFormIface.CreateInited(nil) do begin
    try
      Self.Permissions.Enabled:=Permissions.Enabled;
      Self.ProviderName:=ProviderName;
      Self.ParentProviderName:=ParentProviderName;
      Self.Caption:=Caption;
      Self.SMessageSuccess:=SMessageSuccess;
      Self.Params.Find('TYPE_MESSAGE').Value:=Params.Find('TYPE_MESSAGE').Value;
    finally
      Free;
    end;
  end;
end;

{ TBisTaxiDataOutMessageUpdateFormIface }

constructor TBisTaxiDataOutMessageUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  with TBisMessDataOutMessageUpdateFormIface.CreateInited(nil) do begin
    try
      Self.ProviderName:=ProviderName;
      Self.Caption:=Caption;
    finally
      Free;
    end;
  end;
end;

{ TBisTaxiDataOutMessageDeleteFormIface }

constructor TBisTaxiDataOutMessageDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  with TBisMessDataOutMessageDeleteFormIface.CreateInited(nil) do begin
    try
      Self.ProviderName:=ProviderName;
      Self.Caption:=Caption;
    finally
      Free;
    end;
  end;
end;

{ TBisTaxiDataOutMessageEditForm }

constructor TBisTaxiDataOutMessageEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TBisTaxiDataOutMessageEditForm.ButtonRecipientClick(Sender: TObject);
var
  Pt: TPoint;
begin
  Pt:=PanelControls.ClientToScreen(Point(ButtonRecipient.Left,ButtonRecipient.Top+ButtonRecipient.Height));
  PopupAccount.Popup(Pt.X,Pt.Y);
end;

function TBisTaxiDataOutMessageEditForm.CanSelectAccount: Boolean;
begin
  with TBisDesignDataAccountsFormIface.CreateInited(nil) do begin
    try
      Result:=CanShow;
    finally
      Free;
    end;
  end;
end;

function TBisTaxiDataOutMessageEditForm.CanSelectDriver: Boolean;
begin
  with TBisTaxiDataDriversFormIface.CreateInited(nil) do begin
    try
      Result:=CanShow;
    finally
      Free;
    end;
  end;
end;

function TBisTaxiDataOutMessageEditForm.CanSelectClient: Boolean;
begin
  with TBisTaxiDataClientsFormIface.CreateInited(nil) do begin
    try
      Result:=CanShow;
    finally
      Free;
    end;
  end;
end;

procedure TBisTaxiDataOutMessageEditForm.SelectAccount;
var
  Param: TBisParamEditDataSelect;
  AIface: TBisDesignDataAccountsFormIface;
  DS: TBisDataSet;
  P1: TBisParam;
begin
  if CanSelectAccount then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName('RECIPIENT_ID'));
    AIface:=TBisDesignDataAccountsFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      AIface.LocateFields:='ACCOUNT_ID';
      AIface.LocateValues:=Param.Value;
      if AIface.SelectInto(DS) then begin
        Param.Value:=DS.FieldByName('ACCOUNT_ID').Value;
        Provider.Params.ParamByName('RECIPIENT_USER_NAME').Value:=DS.FieldByName('USER_NAME').Value;
        Provider.Params.ParamByName('RECIPIENT_SURNAME').Value:=DS.FieldByName('SURNAME').Value;
        Provider.Params.ParamByName('RECIPIENT_NAME').Value:=DS.FieldByName('NAME').Value;
        Provider.Params.ParamByName('RECIPIENT_PATRONYMIC').Value:=DS.FieldByName('PATRONYMIC').Value;
        Provider.Params.ParamByName('CONTACT').Value:=DS.FieldByName('PHONE').Value;
        P1:=Provider.Params.ParamByName('RECIPIENT_USER_NAME;RECIPIENT_SURNAME;RECIPIENT_NAME;RECIPIENT_PATRONYMIC');
        P1.Value:=Provider.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

procedure TBisTaxiDataOutMessageEditForm.SelectDriver;
var
  Param: TBisParamEditDataSelect;
  AIface: TBisTaxiDataDriversFormIface;
  DS: TBisDataSet;
  P1: TBisParam;
begin
  if CanSelectDriver then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName('RECIPIENT_ID'));
    AIface:=TBisTaxiDataDriversFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      AIface.LocateFields:='DRIVER_ID';
      AIface.LocateValues:=Param.Value;
      if AIface.SelectInto(DS) then begin
        Param.Value:=DS.FieldByName('DRIVER_ID').Value;
        Provider.Params.ParamByName('RECIPIENT_USER_NAME').Value:=DS.FieldByName('USER_NAME').Value;
        Provider.Params.ParamByName('RECIPIENT_SURNAME').Value:=DS.FieldByName('SURNAME').Value;
        Provider.Params.ParamByName('RECIPIENT_NAME').Value:=DS.FieldByName('NAME').Value;
        Provider.Params.ParamByName('RECIPIENT_PATRONYMIC').Value:=DS.FieldByName('PATRONYMIC').Value;
        Provider.Params.ParamByName('CONTACT').Value:=DS.FieldByName('PHONE').Value;
        P1:=Provider.Params.ParamByName('RECIPIENT_USER_NAME;RECIPIENT_SURNAME;RECIPIENT_NAME;RECIPIENT_PATRONYMIC');
        P1.Value:=Provider.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

procedure TBisTaxiDataOutMessageEditForm.SelectClient;
var
  Param: TBisParamEditDataSelect;
  AIface: TBisTaxiDataClientsFormIface;
  DS: TBisDataSet;
  P1: TBisParam;
begin
  if CanSelectClient then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName('RECIPIENT_ID'));
    AIface:=TBisTaxiDataClientsFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      AIface.LocateFields:='ID';
      AIface.LocateValues:=Param.Value;
      if AIface.SelectInto(DS) then begin
        Param.Value:=DS.FieldByName('ID').Value;
        Provider.Params.ParamByName('RECIPIENT_USER_NAME').Value:=DS.FieldByName('NEW_NAME').Value;
        Provider.Params.ParamByName('RECIPIENT_SURNAME').Value:=DS.FieldByName('SURNAME').Value;
        Provider.Params.ParamByName('RECIPIENT_NAME').Value:=DS.FieldByName('NAME').Value;
        Provider.Params.ParamByName('RECIPIENT_PATRONYMIC').Value:=DS.FieldByName('PATRONYMIC').Value;
        Provider.Params.ParamByName('CONTACT').Value:=DS.FieldByName('PHONE').Value;
        P1:=Provider.Params.ParamByName('RECIPIENT_USER_NAME;RECIPIENT_SURNAME;RECIPIENT_NAME;RECIPIENT_PATRONYMIC');
        P1.Value:=Provider.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

procedure TBisTaxiDataOutMessageEditForm.PopupAccountPopup(Sender: TObject);
begin
  MenuItemAccounts.Enabled:=CanSelectAccount;
  MenuItemDrivers.Enabled:=CanSelectDriver;
  MenuItemClients.Enabled:=CanSelectClient;
end;

procedure TBisTaxiDataOutMessageEditForm.MenuItemAccountsClick(Sender: TObject);
begin
  SelectAccount;
end;

procedure TBisTaxiDataOutMessageEditForm.MenuItemClientsClick(Sender: TObject);
begin
  SelectClient;
end;

procedure TBisTaxiDataOutMessageEditForm.MenuItemDriversClick(Sender: TObject);
begin
  SelectDriver;
end;

end.