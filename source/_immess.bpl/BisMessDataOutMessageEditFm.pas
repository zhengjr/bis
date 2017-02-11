unit BisMessDataOutMessageEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, DB, ImgList,
  BisFm, BisDataEditFm, BisParam, BisControls;

type
  TBisMessDataOutMessageEditForm = class(TBisDataEditForm)
    LabelRecipient: TLabel;
    EditRecipient: TEdit;
    LabelDateCreate: TLabel;
    DateTimePickerCreate: TDateTimePicker;
    DateTimePickerCreateTime: TDateTimePicker;
    ButtonRecipient: TButton;
    LabelDateOut: TLabel;
    DateTimePickerOut: TDateTimePicker;
    DateTimePickerOutTime: TDateTimePicker;
    LabelType: TLabel;
    ComboBoxType: TComboBox;
    LabelContact: TLabel;
    EditContact: TEdit;
    LabelCreator: TLabel;
    EditCreator: TEdit;
    LabelPriority: TLabel;
    ComboBoxPriority: TComboBox;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    MemoText: TMemo;
    ButtonPattern: TButton;
    LabelCounter: TLabel;
    LabelDateBegin: TLabel;
    DateTimePickerBegin: TDateTimePicker;
    DateTimePickerBeginTime: TDateTimePicker;
    LabelDateEnd: TLabel;
    DateTimePickerEnd: TDateTimePicker;
    DateTimePickerEndTime: TDateTimePicker;
    procedure MemoTextChange(Sender: TObject);
    procedure ButtonPatternClick(Sender: TObject);
  private
    FSHigh: String;
    FSNormal: String;
    FSLow: String;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Init; override;
    procedure BeforeShow; override;
    procedure ChangeParam(Param: TBisParam); override;
  published
    property SHigh: String read FSHigh write FSHigh;
    property SNormal: String read FSNormal write FSNormal;
    property SLow: String read FSLow write FSLow;
  end;

  TBisMessDataOutMessageEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataOutMessageInsertFormIface=class(TBisMessDataOutMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataOutMessageUpdateFormIface=class(TBisMessDataOutMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisMessDataOutMessageDeleteFormIface=class(TBisMessDataOutMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisMessDataOutMessageEditForm: TBisMessDataOutMessageEditForm;

function GetTypeMessageByIndex(Index: Integer): String;

implementation

uses BisUtils, BisCore, BisFilterGroups, BisMessConsts, BisParamEditDataSelect,
     BisProvider, BisMessDataPatternMessagesFm, BisMessDataAccountsFm;

{$R *.dfm}

function GetTypeMessageByIndex(Index: Integer): String;
begin
  Result:='';
  case Index of
    0: Result:='SMS';
//    1: Result:='Email';
  end;
end;


{ TBisMessDataOutMessageEditFormIface }

constructor TBisMessDataOutMessageEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisMessDataOutMessageEditForm;
  with Params do begin
    AddKey('OUT_MESSAGE_ID').Older('OLD_OUT_MESSAGE_ID');
    AddInvisible('LOCKED');
    AddComboBoxIndex('TYPE_MESSAGE','ComboBoxType','LabelType',true).Value:=0;
    AddComboBoxIndex('PRIORITY','ComboBoxPriority','LabelPriority',true);
    if IsMainModule then begin
      AddEditDataSelect('RECIPIENT_ID','EditRecipient','LabelRecipient','ButtonRecipient',
                         TBisMessDataAccountsFormIface,'RECIPIENT_NAME',false,false,'ACCOUNT_ID','USER_NAME');
    end else begin
      AddEditDataSelect('RECIPIENT_ID','EditRecipient','LabelRecipient','ButtonRecipient',
                         SIfaceClassDataAccountsFormIface,'RECIPIENT_NAME',false,false,'ACCOUNT_ID','USER_NAME');
    end;
    AddEdit('CONTACT','EditContact','LabelContact',true);
    AddMemo('TEXT_OUT','MemoText','LabelCounter');
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddEditDateTime('DATE_BEGIN','DateTimePickerBegin','DateTimePickerBeginTime','LabelDateBegin',true);
    AddEditDateTime('DATE_END','DateTimePickerEnd','DateTimePickerEndTime','LabelDateEnd');
    AddEditDateTime('DATE_OUT','DateTimePickerOut','DateTimePickerOutTime','LabelDateOut');
    if IsMainModule then begin
      AddEditDataSelect('CREATOR_ID','EditCreator','LabelCreator','',
                         TBisMessDataAccountsFormIface,'CREATOR_NAME',true,false,'ACCOUNT_ID','USER_NAME').ExcludeModes(AllParamEditModes);
    end else begin
      AddEditDataSelect('CREATOR_ID','EditCreator','LabelCreator','',
                         SIfaceClassDataAccountsFormIface,'CREATOR_NAME',true,false,'ACCOUNT_ID','USER_NAME').ExcludeModes(AllParamEditModes);
    end;
    AddEditDateTime('DATE_CREATE','DateTimePickerCreate','DateTimePickerCreateTime','LabelDateCreate',true).ExcludeModes(AllParamEditModes);
  end;
end;

{ TBisMessDataOutMessageInsertFormIface }

constructor TBisMessDataOutMessageInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Permissions.Enabled:=true;
  ProviderName:='I_OUT_MESSAGE';
  ParentProviderName:='S_OUT_MESSAGES';
  Caption:='������� ��������� ���������';
  SMessageSuccess:='��������� ������� �������.';
end;

{ TBisMessDataOutMessageUpdateFormIface }

constructor TBisMessDataOutMessageUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_OUT_MESSAGE';
  Caption:='�������� ��������� ���������';
end;

{ TBisMessDataOutMessageDeleteFormIface }

constructor TBisMessDataOutMessageDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_OUT_MESSAGE';
  Caption:='������� ��������� ���������';
end;

{ TBisMessDataOutMessageEditForm }

constructor TBisMessDataOutMessageEditForm.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);

  ComboBoxType.Clear;
  for i:=0 to 0 do
    ComboBoxType.Items.Add(GetTypeMessageByIndex(i));

  FSHigh:='�������';
  FSNormal:='����������';
  FSLow:='������';

end;

procedure TBisMessDataOutMessageEditForm.Init;
var
  OldIndex: Integer;
begin
  inherited Init;
  OldIndex:=ComboBoxPriority.ItemIndex;
  try
    ComboBoxPriority.Items.Strings[0]:=FSHigh;
    ComboBoxPriority.Items.Strings[1]:=FSNormal;
    ComboBoxPriority.Items.Strings[2]:=FSLow;
  finally
    ComboBoxPriority.ItemIndex:=OldIndex;
  end;
end;

procedure TBisMessDataOutMessageEditForm.MemoTextChange(Sender: TObject);
begin
  LabelCounter.Caption:=IntToStr(Length(MemoText.Lines.Text));
end;

procedure TBisMessDataOutMessageEditForm.BeforeShow;
var
  D: TDateTime;
begin
  inherited BeforeShow;
  if Mode in [emInsert,emDuplicate] then begin
    D:=Core.ServerDate;
    ActiveControl:=EditContact;
    with Provider.Params do begin
      Find('TYPE_MESSAGE').SetNewValue(0);
      Find('PRIORITY').SetNewValue(1);
      Find('DATE_BEGIN').SetNewValue(D);
      Find('CREATOR_ID').SetNewValue(Core.AccountId);
      Find('CREATOR_NAME').SetNewValue(Core.AccountUserName);
      Find('DATE_CREATE').SetNewValue(D);
    end;
  end;
  LabelCounter.Enabled:=not (Mode in [emDelete]);
  ButtonPattern.Enabled:=LabelCounter.Enabled;
  UpdateButtonState;
  MemoTextChange(nil);
end;

procedure TBisMessDataOutMessageEditForm.ButtonPatternClick(Sender: TObject);
var
  AIface: TBisMessDataPatternMessagesFormIface;
  P: TBisProvider;
begin
  AIface:=TBisMessDataPatternMessagesFormIface.Create(nil);
  P:=TBisProvider.Create(nil);
  try
    AIface.Init;
//    AIface.ShowType:=stNormal;
    if AIface.SelectInto(P) then begin
      if P.Active and not P.Empty then begin
        Provider.Params.ParamByName('TEXT_OUT').Value:=P.FieldByName('TEXT_PATTERN').Value;
        MemoTextChange(nil);
      end;
    end;
  finally
    P.Free;
    AIface.Free;
  end;
end;

procedure TBisMessDataOutMessageEditForm.ChangeParam(Param: TBisParam);
var
  ParamRecipient: TBisParamEditDataSelect;
  ParamType: TBisParam;
begin
  inherited ChangeParam(Param);
  if AnsiSameText(Param.ParamName,'RECIPIENT_NAME') and not Param.Empty then begin
    if Mode in [emInsert] then begin
      ParamRecipient:=TBisParamEditDataSelect(Provider.Params.ParamByName('RECIPIENT_ID'));
      if not ParamRecipient.Empty then begin
        ParamType:=Provider.Params.ParamByName('TYPE_MESSAGE');
        case ParamType.AsInteger of
          0: Provider.Params.ParamByName('CONTACT').Value:=ParamRecipient.Values.GetValue('PHONE');
        end;
      end;
    end;
  end;
end;


end.