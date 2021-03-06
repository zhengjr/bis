unit BisTaxiDataDriverInMessageEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, DB, ImgList,
  BisDataEditFm, BisParam, BisControls;

type
  TBisTaxiDataDriverInMessageEditForm = class(TBisDataEditForm)
    LabelSender: TLabel;
    EditSender: TEdit;
    LabelDateSend: TLabel;
    DateTimePickerSend: TDateTimePicker;
    DateTimePickerSendTime: TDateTimePicker;
    ButtonSender: TButton;
    LabelDateIn: TLabel;
    DateTimePickerIn: TDateTimePicker;
    DateTimePickerInTime: TDateTimePicker;
    LabelType: TLabel;
    ComboBoxType: TComboBox;
    LabelContact: TLabel;
    EditContact: TEdit;
    LabelText: TLabel;
    MemoText: TMemo;
    LabelCodeMessage: TLabel;
    EditCodeMessage: TEdit;
    ButtonCodeMessage: TButton;
  private
  public
    constructor Create(AOwner: TComponent); override;
    procedure BeforeShow; override;
    procedure ChangeParam(Param: TBisParam); override;

  end;

  TBisTaxiDataDriverInMessageEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDriverInMessageInsertFormIface=class(TBisTaxiDataDriverInMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDriverInMessageUpdateFormIface=class(TBisTaxiDataDriverInMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataDriverInMessageDeleteFormIface=class(TBisTaxiDataDriverInMessageEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataDriverInMessageEditForm: TBisTaxiDataDriverInMessageEditForm;

function GetTypeMessageByIndex(Index: Integer): String;

implementation

uses BisUtils, BisCore, BisFilterGroups, BisValues, BisTaxiConsts, 
     BisParamEditDataSelect, BisTaxiDataDriversFm, BisTaxiDataCodeMessagesFm;

{$R *.dfm}

function GetTypeMessageByIndex(Index: Integer): String;
begin
  Result:='';
  case Index of
    0: Result:='SMS';
//    1: Result:='Email';
  end;
end;


{ TBisTaxiDataDriverInMessageEditFormIface }

constructor TBisTaxiDataDriverInMessageEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataDriverInMessageEditForm;
  with Params do begin
    AddKey('IN_MESSAGE_ID').Older('OLD_IN_MESSAGE_ID');
    AddInvisible('OPERATOR_ID');
    AddInvisible('OPERATOR_NAME');
    AddInvisible('CAR_CALLSIGN',ptUnknown);
    AddInvisible('CAR_COLOR',ptUnknown);
    AddInvisible('CAR_BRAND',ptUnknown);
    AddInvisible('CAR_STATE_NUM',ptUnknown);
    AddComboBoxIndex('TYPE_MESSAGE','ComboBoxType','LabelType',true);
    AddEditDataSelect('SENDER_ID','EditSender','LabelSender','ButtonSender',
                       TBisTaxiDataDriversFormIface,'SENDER_NAME',true,false,'DRIVER_ID','USER_NAME');
    AddEditDataSelect('CODE_MESSAGE_ID','EditCodeMessage','LabelCodeMessage','ButtonCodeMessage',
                       TBisTaxiDataCodeMessagesFormIface,'CODE');
    AddEdit('CONTACT','EditContact','LabelContact',true);
    AddMemo('TEXT_IN','MemoText','LabelText');
    AddEditDateTime('DATE_IN','DateTimePickerIn','DateTimePickerInTime','LabelDateIn',true);
    AddEditDateTime('DATE_SEND','DateTimePickerSend','DateTimePickerSendTime','LabelDateSend',true);
  end;
end;

{ TBisTaxiDataDriverInMessageInsertFormIface }

constructor TBisTaxiDataDriverInMessageInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_IN_MESSAGE';
  Caption:='������� �������� ���������';
end;

{ TBisTaxiDataDriverInMessageUpdateFormIface }

constructor TBisTaxiDataDriverInMessageUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_IN_MESSAGE';
  Caption:='�������� �������� ���������';
end;

{ TBisTaxiDataDriverInMessageDeleteFormIface }

constructor TBisTaxiDataDriverInMessageDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_IN_MESSAGE';
  Caption:='������� �������� ���������';
end;

{ TBisTaxiDataDriverInMessageEditForm }

constructor TBisTaxiDataDriverInMessageEditForm.Create(AOwner: TComponent);
var
  i: Integer;
begin
  inherited Create(AOwner);

  ComboBoxType.Clear;
  for i:=0 to 0 do
    ComboBoxType.Items.Add(GetTypeMessageByIndex(i));

end;

procedure TBisTaxiDataDriverInMessageEditForm.BeforeShow;
begin
  inherited BeforeShow;
end;

procedure TBisTaxiDataDriverInMessageEditForm.ChangeParam(Param: TBisParam);
var
  ParamSender: TBisParamEditDataSelect;
  ParamType: TBisParam;
  V: TBisValue;
begin
  inherited ChangeParam(Param);

  if AnsiSameText(Param.ParamName,'SENDER_NAME') and not Param.Empty then begin
    ParamSender:=TBisParamEditDataSelect(Provider.Params.ParamByName('SENDER_ID'));
    if Mode in [emInsert,emDuplicate] then begin
      if not ParamSender.Empty then begin
        ParamType:=Provider.Params.ParamByName('TYPE_MESSAGE');
        case ParamType.AsInteger of
          0: Provider.Params.ParamByName('CONTACT').Value:=ParamSender.Values.GetValue('PHONE');
        end;
      end;
    end;
    V:=ParamSender.Values.Find('CAR_CALLSIGN');
    if Assigned(V) then Provider.Params.ParamByName('CAR_CALLSIGN').SetNewValue(V.Value);
    V:=ParamSender.Values.Find('CAR_COLOR');
    if Assigned(V) then Provider.Params.ParamByName('CAR_COLOR').SetNewValue(V.Value);
    V:=ParamSender.Values.Find('CAR_BRAND');
    if Assigned(V) then Provider.Params.ParamByName('CAR_BRAND').SetNewValue(V.Value);
    V:=ParamSender.Values.Find('CAR_STATE_NUM');
    if Assigned(V) then Provider.Params.ParamByName('CAR_STATE_NUM').SetNewValue(V.Value);
  end;

end;


end.
