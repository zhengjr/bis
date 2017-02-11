unit BisTaxiDataCallEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, DB, ImgList, Menus, ActnPopup, Buttons,
  BisFm, BisDataFm, BisDataEditFm, BisParam,
  BisAudioWaveFrm,
  BisCallDataCallEditFm,
  BisControls;                                                                                           

type
  TBisTaxiDataCallEditForm = class(TBisCallDataCallEditForm)
    PopupAccount: TPopupActionBar;
    MenuItemAccounts: TMenuItem;
    MenuItemDrivers: TMenuItem;
    MenuItemClients: TMenuItem;
    MenuItemDispatchers: TMenuItem;
    procedure ButtonCallerClick(Sender: TObject);
    procedure PopupAccountPopup(Sender: TObject);
    procedure MenuItemAccountsClick(Sender: TObject);
    procedure ButtonAcceptorClick(Sender: TObject);
    procedure MenuItemDriversClick(Sender: TObject);
    procedure MenuItemClientsClick(Sender: TObject);
    procedure MenuItemDispatchersClick(Sender: TObject);
  private
    FLastButton: TButton;
    function CanSelectAccount: Boolean;
    procedure SelectAccount(Alias: String);
    function CanSelectDriver: Boolean;
    procedure SelectDriver(Alias: String);
    function CanSelectClient: Boolean;
    procedure SelectClient(Alias: String);
    function CanSelectDispatcher: Boolean;
    procedure SelectDispatcher(Alias: String);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TBisTaxiDataCallEditFormIface=class(TBisCallDataCallEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCallViewFormIface=class(TBisTaxiDataCallEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCallInsertFormIface=class(TBisTaxiDataCallEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCallUpdateFormIface=class(TBisTaxiDataCallEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataCallDeleteFormIface=class(TBisTaxiDataCallEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataCallEditForm: TBisTaxiDataCallEditForm;

implementation

uses DateUtils,
     BisUtils, BisCore, BisFilterGroups, BisParamEditDataSelect,
     BisProvider, BisIfaces, BisDataSet, BisDialogs,
     BisDesignDataAccountsFm,
     BisTaxiConsts, BisTaxiDataDriversFm, BisTaxiDataDispatchersFm, BisTaxiDataClientsFm;

{$R *.dfm}

{ TBisTaxiDataCallEditFormIface }

constructor TBisTaxiDataCallEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataCallEditForm;
  Params.AddInvisible('ORDER_ID');
end;

{ TBisTaxiDataCallViewFormIface }

constructor TBisTaxiDataCallViewFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  with TBisCallDataCallViewFormIface.CreateInited(nil) do begin
    try
      Self.Caption:=Caption;
    finally
      Free;
    end;
  end;
end;

{ TBisTaxiDataCallInsertFormIface }

constructor TBisTaxiDataCallInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  with TBisCallDataCallInsertFormIface.CreateInited(nil) do begin
    try
      Self.ProviderName:=ProviderName;
      Self.Caption:=Caption;
    finally
      Free;
    end;
  end;
end;

{ TBisTaxiDataCallUpdateFormIface }

constructor TBisTaxiDataCallUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  with TBisCallDataCallUpdateFormIface.CreateInited(nil) do begin
    try
      Self.ProviderName:=ProviderName;
      Self.Caption:=Caption;
    finally
      Free;
    end;
  end;
end;

{ TBisTaxiDataCallDeleteFormIface }

constructor TBisTaxiDataCallDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  with TBisCallDataCallDeleteFormIface.CreateInited(nil) do begin
    try
      Self.ProviderName:=ProviderName;
      Self.Caption:=Caption;
    finally
      Free;
    end;
  end;
end;

{ TBisTaxiDataCallEditForm }

constructor TBisTaxiDataCallEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TBisTaxiDataCallEditForm.Destroy;
begin
  inherited Destroy;
end;

procedure TBisTaxiDataCallEditForm.MenuItemAccountsClick(Sender: TObject);
begin
  SelectAccount(iff(FLastButton=ButtonCaller,'CALLER','ACCEPTOR'));
end;

procedure TBisTaxiDataCallEditForm.MenuItemClientsClick(Sender: TObject);
begin
  SelectClient(iff(FLastButton=ButtonCaller,'CALLER','ACCEPTOR'));
end;

procedure TBisTaxiDataCallEditForm.MenuItemDispatchersClick(Sender: TObject);
begin
  SelectDispatcher(iff(FLastButton=ButtonCaller,'CALLER','ACCEPTOR'));
end;

procedure TBisTaxiDataCallEditForm.MenuItemDriversClick(Sender: TObject);
begin
  SelectDriver(iff(FLastButton=ButtonCaller,'CALLER','ACCEPTOR'));
end;

procedure TBisTaxiDataCallEditForm.ButtonAcceptorClick(Sender: TObject);
var
  Pt: TPoint;
begin
  Pt:=GroupBoxAcceptor.ClientToScreen(Point(ButtonAcceptor.Left,ButtonAcceptor.Top+ButtonAcceptor.Height));
  PopupAccount.Popup(Pt.X,Pt.Y);
  FLastButton:=ButtonAcceptor;
end;

procedure TBisTaxiDataCallEditForm.ButtonCallerClick(Sender: TObject);
var
  Pt: TPoint;
begin
  Pt:=GroupBoxCaller.ClientToScreen(Point(ButtonCaller.Left,ButtonCaller.Top+ButtonCaller.Height));
  PopupAccount.Popup(Pt.X,Pt.Y);
  FLastButton:=ButtonCaller;
end;

procedure TBisTaxiDataCallEditForm.PopupAccountPopup(Sender: TObject);
begin
  MenuItemAccounts.Enabled:=CanSelectAccount;
//  MenuItemDispatchers.Enabled:=CanSelectDispatcher;
  MenuItemDrivers.Enabled:=CanSelectDriver;
  MenuItemClients.Enabled:=CanSelectClient;
end;

function TBisTaxiDataCallEditForm.CanSelectAccount: Boolean;
begin
  with TBisDesignDataAccountsFormIface.CreateInited(nil) do begin
    try
      Result:=CanShow;
    finally
      Free;
    end;
  end;
end;

procedure TBisTaxiDataCallEditForm.SelectAccount(Alias: String);
var
  Param: TBisParamEditDataSelect;
  AIface: TBisDesignDataAccountsFormIface;
  DS: TBisDataSet;
  P1: TBisParam;
begin
  if CanSelectAccount then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName(Alias+'_ID'));
    AIface:=TBisDesignDataAccountsFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      AIface.LocateFields:='ACCOUNT_ID';
      AIface.LocateValues:=Param.Value;
      if AIface.SelectInto(DS) then begin
        Param.Value:=DS.FieldByName('ACCOUNT_ID').Value;
        Provider.Params.ParamByName(Alias+'_USER_NAME').Value:=DS.FieldByName('USER_NAME').Value;
        Provider.Params.ParamByName(Alias+'_SURNAME').Value:=DS.FieldByName('SURNAME').Value;
        Provider.Params.ParamByName(Alias+'_NAME').Value:=DS.FieldByName('NAME').Value;
        Provider.Params.ParamByName(Alias+'_PATRONYMIC').Value:=DS.FieldByName('PATRONYMIC').Value;
        if Mode<>emFilter then
          Provider.Params.ParamByName(Alias+'_PHONE').Value:=DS.FieldByName('PHONE').AsString;
        P1:=Provider.Params.ParamByName(Alias+'_USER_NAME;'+Alias+'_SURNAME;'+Alias+'_NAME;'+Alias+'_PATRONYMIC');
        P1.Value:=Provider.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

function TBisTaxiDataCallEditForm.CanSelectDriver: Boolean;
begin
  with TBisTaxiDataDriversFormIface.CreateInited(nil) do begin
    try
      Result:=CanShow;
    finally
      Free;
    end;
  end;
end;

procedure TBisTaxiDataCallEditForm.SelectDriver(Alias: String);
var
  Param: TBisParamEditDataSelect;
  AIface: TBisTaxiDataDriversFormIface;
  DS: TBisDataSet;
  P1: TBisParam;
begin
  if CanSelectDriver then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName(Alias+'_ID'));
    AIface:=TBisTaxiDataDriversFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      AIface.LocateFields:='DRIVER_ID';
      AIface.LocateValues:=Param.Value;
      if AIface.SelectInto(DS) then begin
        Param.Value:=DS.FieldByName('DRIVER_ID').Value;
        Provider.Params.ParamByName(Alias+'_USER_NAME').Value:=DS.FieldByName('USER_NAME').Value;
        Provider.Params.ParamByName(Alias+'_SURNAME').Value:=DS.FieldByName('SURNAME').Value;
        Provider.Params.ParamByName(Alias+'_NAME').Value:=DS.FieldByName('NAME').Value;
        Provider.Params.ParamByName(Alias+'_PATRONYMIC').Value:=DS.FieldByName('PATRONYMIC').Value;
        if Mode<>emFilter then
          Provider.Params.ParamByName(Alias+'_PHONE').Value:=DS.FieldByName('PHONE').AsString;
        P1:=Provider.Params.ParamByName(Alias+'_USER_NAME;'+Alias+'_SURNAME;'+Alias+'_NAME;'+Alias+'_PATRONYMIC');
        P1.Value:=Provider.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

function TBisTaxiDataCallEditForm.CanSelectClient: Boolean;
begin
  with TBisTaxiDataClientsFormIface.CreateInited(nil) do begin
    try
      Result:=CanShow;
    finally
      Free;
    end;
  end;
end;

procedure TBisTaxiDataCallEditForm.SelectClient(Alias: String);
var
  Param: TBisParamEditDataSelect;
  AIface: TBisTaxiDataClientsFormIface;
  DS: TBisDataSet;
  P1: TBisParam;
begin
  if CanSelectClient then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName(Alias+'_ID'));
    AIface:=TBisTaxiDataClientsFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      AIface.LocateFields:='ID';
      AIface.LocateValues:=Param.Value;
      if AIface.SelectInto(DS) then begin
        Param.Value:=DS.FieldByName('ID').Value;
        Provider.Params.ParamByName(Alias+'_NAME').Value:=DS.FieldByName('NEW_NAME').AsString;
        Provider.Params.ParamByName(Alias+'_USER_NAME').Value:=DS.FieldByName('NEW_NAME').Value;
        Provider.Params.ParamByName(Alias+'_SURNAME').Value:=DS.FieldByName('SURNAME').Value;
        Provider.Params.ParamByName(Alias+'_NAME').Value:=DS.FieldByName('NAME').Value;
        Provider.Params.ParamByName(Alias+'_PATRONYMIC').Value:=DS.FieldByName('PATRONYMIC').Value;
        if Mode<>emFilter then
          Provider.Params.ParamByName(Alias+'_PHONE').Value:=DS.FieldByName('PHONE').AsString;
        P1:=Provider.Params.ParamByName(Alias+'_USER_NAME;'+Alias+'_SURNAME;'+Alias+'_NAME;'+Alias+'_PATRONYMIC');
        P1.Value:=Provider.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

function TBisTaxiDataCallEditForm.CanSelectDispatcher: Boolean;
begin
  with TBisTaxiDataDispatchersFormIface.CreateInited(nil) do begin
    try
      Result:=CanShow;
    finally
      Free;
    end;
  end;
end;

procedure TBisTaxiDataCallEditForm.SelectDispatcher(Alias: String);
var
  Param: TBisParamEditDataSelect;
  AIface: TBisTaxiDataDispatchersFormIface;
  DS: TBisDataSet;
  P1: TBisParam;
begin
  if CanSelectDispatcher then begin
    Param:=TBisParamEditDataSelect(Provider.Params.ParamByName(Alias+'_ID'));
    AIface:=TBisTaxiDataDispatchersFormIface.Create(nil);
    DS:=TBisDataSet.Create(nil);
    try
      AIface.LocateFields:='DISPATCHER_ID';
      AIface.LocateValues:=Param.Value;
      if AIface.SelectInto(DS) then begin
        Param.Value:=DS.FieldByName('DISPATCHER_ID').Value;
        Provider.Params.ParamByName(Alias+'_USER_NAME').Value:=DS.FieldByName('USER_NAME').Value;
        Provider.Params.ParamByName(Alias+'_SURNAME').Value:=DS.FieldByName('SURNAME').Value;
        Provider.Params.ParamByName(Alias+'_NAME').Value:=DS.FieldByName('NAME').Value;
        Provider.Params.ParamByName(Alias+'_PATRONYMIC').Value:=DS.FieldByName('PATRONYMIC').Value;
        P1:=Provider.Params.ParamByName(Alias+'_USER_NAME;'+Alias+'_SURNAME;'+Alias+'_NAME;'+Alias+'_PATRONYMIC');
        P1.Value:=Provider.Params.ValueByParam(P1.ParamFormat,P1.ParamName);
      end;
    finally
      DS.Free;
      AIface.Free;
    end;
  end;
end;

end.