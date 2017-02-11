unit BisKrieltObjectDeleteFm;

interface                                                                                                   

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  IdCoderHeader,
  BisDataEditFm, BisControls, BisParam, ImgList;

type
  TBisKrieltObjectDeleteForm = class(TBisDataEditForm)
    LabelPublishing: TLabel;
    EditPublishing: TEdit;
    ButtonPublishing: TButton;
    LabelTypeDelete: TLabel;
    ComboBoxTypeDelete: TComboBox;
    LabelDateBegin: TLabel;
    DateTimePickerBegin: TDateTimePicker;
    LabelAccount: TLabel;
    EditAccount: TEdit;
    ButtonAccount: TButton;
    DateTimePickerBeginTime: TDateTimePicker;
    LabelView: TLabel;
    LabelType: TLabel;
    LabelOperation: TLabel;
    EditView: TEdit;
    ButtonView: TButton;
    EditType: TEdit;
    ButtonType: TButton;
    EditOperation: TEdit;
    ButtonOperation: TButton;
    LabelDateEnd: TLabel;
    DateTimePickerEnd: TDateTimePicker;
    DateTimePickerEndTime: TDateTimePicker;
    EditEmail: TEdit;
    LabelEmail: TLabel;
    GroupBoxNotify: TGroupBox;
    MemoNotify: TMemo;
    PanelSubject: TPanel;
    LabelSubject: TLabel;
    EditSubject: TEdit;
    procedure MemoNotifyKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FAdminEmail: String;
    FAdminName: String;
    FAccountName: String;
    function SendEmail: Boolean;
    procedure ReplaceNotify;
    procedure MessageInitializeISO(var VTransferHeader: TTransfer; var VHeaderEncoding: Char;  var VCharSet: string);

  public
    constructor Create(AOwner: TComponent); override;
    procedure BeforeShow; override;
    function SaveChanges: Boolean; override;
    procedure Execute; override;
  end;

  TBisKrieltObjectDeleteFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltObjectDeleteForm: TBisKrieltObjectDeleteForm;

procedure RefreshObject(ObjectId: String);

implementation

uses Dateutils, DB, StrUtils,
     IdSMTP, IdMessage,
     IpHlpApi, IpTypes, IPFunctions,
     BisCore, BisFilterGroups, BisKrieltConsts, BisProvider, BisDialogs, BisUtils, BisVariants,
     BisKrieltDataPublishingFm, BisKrieltDataViewsFm,
     BisKrieltDataTypesFm, BisKrieltDataOperationsFm;

{$R *.dfm}

procedure RefreshObject(ObjectId: String);
var
  P: TBisProvider;
begin
  P:=TBisProvider.Create(nil);
  try
    P.ProviderName:='R_OBJECT';
    P.Params.AddInvisible('OBJECT_ID').Value:=ObjectId;
    P.Execute;
  finally
    P.Free;
  end;
end;

function GetAccountEmail(AccountId: String; var AName: String): String;
var
  P: TBisProvider;
begin
  Result:='';
  P:=TBisProvider.Create(nil);
  try
    P.ProviderName:='S_ACCOUNTS';
    P.FieldNames.Add('EMAIL');
    P.FieldNames.Add('NAME');
    P.FilterGroups.Add.Filters.Add('ACCOUNT_ID',fcEqual,AccountId);
    P.Open;
    if P.Active and not P.IsEmpty then begin
      Result:=P.FieldByName('EMAIL').AsString;
      AName:=P.FieldByName('NAME').AsString;
    end;
  finally
    P.Free;
  end;
end;

{ TBisKrieltObjectDeleteFormIface }

constructor TBisKrieltObjectDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltObjectDeleteForm;
  with Params do begin
    AddInvisible('OBJECT_ID').Older('OLD_OBJECT_ID');
    AddInvisible('STATUS');
    AddEditDataSelect('PUBLISHING_ID','EditPublishing','LabelPublishing','ButtonPublishing',
                      TBisKrieltDataPublishingFormIface,'PUBLISHING_NAME',true,true,'','NAME').Older('OLD_PUBLISHING_ID');
    AddEditDataSelect('VIEW_ID','EditView','LabelView','ButtonView',
                      TBisKrieltDataViewsFormIface,'VIEW_NAME',true,false,'','NAME');
    AddEditDataSelect('TYPE_ID','EditType','LabelType','ButtonType',
                      TBisKrieltDataTypesFormIface,'TYPE_NAME',true,false,'','NAME');
    AddEditDataSelect('OPERATION_ID','EditOperation','LabelOperation','ButtonOperation',
                      TBisKrieltDataOperationsFormIface,'OPERATION_NAME',true,false,'','NAME');
    AddEditDataSelect('ACCOUNT_ID','EditAccount','LabelAccount','ButtonAccount',
                      SIfaceClassDataAccountsFormIface,'USER_NAME',true,false);
    AddEdit('EMAIL','EditEmail','LabelEmail',true).ParamType:=ptUnknown;
    AddEditDateTime('DATE_BEGIN','DateTimePickerBegin','DateTimePickerBeginTime','LabelDateBegin',true);
    AddEditDateTime('DATE_END','DateTimePickerEnd','DateTimePickerEndTime','LabelDateEnd',true);
  end;
  ProviderName:='D_PUBLISHING_OBJECT';
end;

{ TBisKrieltObjectEditForm }

constructor TBisKrieltObjectDeleteForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

end;

procedure TBisKrieltObjectDeleteForm.BeforeShow;
begin
  inherited BeforeShow;
  FAdminEmail:=GetAccountEmail(Core.AccountId,FAdminName);
  Provider.Params.ParamByName('EMAIL').SetNewValue(GetAccountEmail(Provider.Params.ParamByName('ACCOUNT_ID').Value,FAccountName));
  Provider.Params.ParamByName('EMAIL').Enabled:=true;
  ReplaceNotify;
end;

procedure TBisKrieltObjectDeleteForm.ReplaceNotify;
var
  Str: TStringList;

  procedure AddValue(AName: String; AValue: Variant);
  var
    Obj: TBisVariant;
  begin
    Obj:=TBisVariant.Create;
    Obj.Value:=AValue;
    Str.AddObject(AName,Obj);
  end;

  procedure AddDetail;
  var
    P: TBisProvider;
    Detail: TStringList;
  begin
    P:=TBisProvider.Create(nil);
    Detail:=TStringList.Create;
    try
      P.ProviderName:='S_OBJECT_PARAMS';
      P.FieldNames.Add('PARAM_NAME');
      P.FieldNames.Add('VALUE');
      P.FilterGroups.Add.Filters.Add('OBJECT_ID',fcEqual,Provider.Params.ParamByName('OBJECT_ID').Value);
      P.Orders.Add('PARAM_NAME');
      P.Open;
      if P.Active then begin
        P.First;
        while not P.Eof do begin
          Detail.Add(Format('%s: %s',[P.FieldByName('PARAM_NAME').AsString,
                                      P.FieldByName('VALUE').AsString]));
          P.Next;
        end;
      end;
      AddValue('%DETAIL',Trim(Detail.Text));
    finally
      Detail.Free;
      P.Free;
    end;
  end;

var
  i: Integer;
  Obj: TBisVariant;
  S: String;
begin
  Str:=TStringList.Create;
  try

    AddValue('%ACCOUNT_NAME',FAccountName);

    with Provider.Params do begin
      AddValue('%ACCOUNT_ID',ParamByName('ACCOUNT_ID').Value);
      AddValue('%OBJECT_ID',ParamByName('OBJECT_ID').Value);
      AddValue('%DATE_BEGIN',ParamByName('DATE_BEGIN').Value);
      AddValue('%VIEW_NAME',ParamByName('VIEW_NAME').Value);
      AddValue('%TYPE_NAME',ParamByName('TYPE_NAME').Value);
      AddValue('%OPERATION_NAME',ParamByName('OPERATION_NAME').Value);
    end;

//    AddDetail;

    AddValue('%ADMIN_NAME',FAdminName);
    AddValue('%ADMIN_EMAIL',FAdminEmail);

    S:=MemoNotify.Lines.Text;
    for i:=0 to Str.Count-1 do begin
      Obj:=TBisVariant(Str.Objects[i]);
      S:=ReplaceText(S,Str[i],VarToStrDef(Obj.Value,''));
    end;
    MemoNotify.Lines.Text:=S;

  finally
    ClearStrings(Str);
    Str.Free;
  end;
end;

function TBisKrieltObjectDeleteForm.SendEmail: Boolean;
var
  ParamEmail: TBisParam;
  Server: String;
  Client: TIdSMTP;
  Msg: TIdMessage;
  OldCursor: TCursor;
begin
  Result:=false;
  ParamEmail:=Provider.Params.Find('EMAIL');
  if (Trim(FAdminEmail)<>'') and Assigned(ParamEmail) and not ParamEmail.Empty then begin
    Server:=Copy(FAdminEmail,Pos('@',FAdminEmail)+1,Length(FAdminEmail));
    if Trim(Server)<>'' then begin
      OldCursor:=Screen.Cursor;
      Screen.Cursor:=crHourGlass;
      Client:=TIdSMTP.Create(nil);
      Msg:=TIdMessage.Create(nil);
      try
        Msg.From.Address:=FAdminEmail;
        Msg.From.Name:=FAdminName;
        Msg.Sender.Text:=Msg.From.Text;
        Msg.Recipients.EMailAddresses:=ParamEmail.Value;
        Msg.Subject:=EditSubject.Text;
        Msg.Body.Text:=MemoNotify.Lines.Text;
        Msg.Encoding:=meMIME;
        Msg.CharSet:='windows-1251';
        Msg.ContentType:='text/plain';
        Msg.ContentTransferEncoding:='base64';
        Msg.OnInitializeISO:=MessageInitializeISO;

        Client.Host:=Server;
        Client.MailAgent:='';
        Client.Connect;
        Client.Send(Msg);
        Client.Disconnect();

        Result:=true;
      finally
        Msg.Free;
        Client.Free;
        Screen.Cursor:=OldCursor;
      end;
    end;
  end;
end;

function TBisKrieltObjectDeleteForm.SaveChanges: Boolean;
var
  Ret: Boolean;
begin
  Result:=false;

  if ComboBoxTypeDelete.ItemIndex=-1 then begin
    ShowError('�������� ��� ��������.');
    ComboBoxTypeDelete.SetFocus;
    exit;
  end;

  Ret:=true;
  
  case ComboBoxTypeDelete.ItemIndex of
    0: begin
      if Provider.Params.ParamByName('EMAIL').Empty then begin
        ShowError('����������� ����������� ����� ����������.');
        EditEmail.SetFocus;
        exit;
      end;
      if Trim(FAdminEmail)='' then begin
        ShowError('����������� ����������� ����� �����������.');
        exit;
      end;
      Ret:=SendEmail;
    end;
  end;

  Result:=Ret and inherited SaveChanges;
end;

procedure TBisKrieltObjectDeleteForm.Execute;
begin
  case ComboBoxTypeDelete.ItemIndex of
    0,1: begin
      Mode:=emUpdate;
      Provider.ProviderName:='U_PUBLISHING_OBJECT';
      Provider.Params.ParamByName('STATUS').SetNewValue(2);
    end;
    2: Provider.ProviderName:='D_PUBLISHING_OBJECT';
  end;
  inherited Execute;
  case ComboBoxTypeDelete.ItemIndex of
    0,1: RefreshObject(Provider.Params.ParamByName('OBJECT_ID').Value);
  end;
end;

procedure TBisKrieltObjectDeleteForm.MemoNotifyKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key=VK_ESCAPE then
    Close;
end;

procedure TBisKrieltObjectDeleteForm.MessageInitializeISO(
  var VTransferHeader: TTransfer; var VHeaderEncoding: Char;
  var VCharSet: string);
begin
  VCharSet:='windows-1251';
end;

end.