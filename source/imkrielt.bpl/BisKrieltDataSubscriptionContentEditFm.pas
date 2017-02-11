unit BisKrieltDataSubscriptionContentEditFm;

interface                                                                                                  

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls, ImgList;

type
  TBisKrieltDataSubscriptionContentEditForm = class(TBisDataEditForm)
    LabelView: TLabel;
    EditView: TEdit;
    ButtonView: TButton;
    LabelType: TLabel;
    EditType: TEdit;
    ButtonType: TButton;
    LabelOperation: TLabel;
    EditOperation: TEdit;
    ButtonOperation: TButton;
    LabelSubscription: TLabel;
    EditSubscription: TEdit;
    ButtonSubscription: TButton;
    LabelPublishing: TLabel;
    EditPublishing: TEdit;
    ButtonPublishing: TButton;
  private
    { Private declarations }
  public
    procedure Execute; override;
  end;

  TBisKrieltDataSubscriptionContentEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataSubscriptionContentFilterFormIface=class(TBisKrieltDataSubscriptionContentEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataSubscriptionContentInsertFormIface=class(TBisKrieltDataSubscriptionContentEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataSubscriptionContentUpdateFormIface=class(TBisKrieltDataSubscriptionContentEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataSubscriptionContentDeleteFormIface=class(TBisKrieltDataSubscriptionContentEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataSubscriptionContentEditForm: TBisKrieltDataSubscriptionContentEditForm;

implementation

uses BisKrieltConsts, BisKrieltDataSubscriptionsFm, BisKrieltDataViewsFm,
     BisKrieltDataTypesFm, BisKrieltDataOperationsFm, BisKrieltDataPublishingFm,
     BisCore, BisFilterGroups;

{$R *.dfm}

{ TBisKrieltDataSubscriptionContentEditFormIface }

constructor TBisKrieltDataSubscriptionContentEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataSubscriptionContentEditForm;
  with Params do begin
    AddEditDataSelect('SUBSCRIPTION_ID','EditSubscription','LabelSubscription','ButtonSubscription',
                       TBisKrieltDataSubscriptionsFormIface,'SUBSCRIPTION_NAME',true,true,'','NAME').Older('OLD_SUBSCRIPTION_ID');
    AddEditDataSelect('PUBLISHING_ID','EditPublishing','LabelPublishing','ButtonPublishing',
                      TBisKrieltDataPublishingFormIface,'PUBLISHING_NAME',true,true,'','NAME').Older('OLD_PUBLISHING_ID');
    AddEditDataSelect('VIEW_ID','EditView','LabelView','ButtonView',
                      TBisKrieltDataViewsFormIface,'VIEW_NAME',true,true,'','NAME').Older('OLD_VIEW_ID');
    AddEditDataSelect('TYPE_ID','EditType','LabelType','ButtonType',
                      TBisKrieltDataTypesFormIface,'TYPE_NAME',true,true,'','NAME').Older('OLD_TYPE_ID');
    AddEditDataSelect('OPERATION_ID','EditOperation','LabelOperation','ButtonOperation',
                      TBisKrieltDataOperationsFormIface,'OPERATION_NAME',true,true,'','NAME').Older('OLD_OPERATION_ID');
  end;
end;

{ TBisKrieltDataSubscriptionContentFilterFormIface }

constructor TBisKrieltDataSubscriptionContentFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

{ TBisKrieltDataSubscriptionContentInsertFormIface }

constructor TBisKrieltDataSubscriptionContentInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_SUBSCRIPTION_CONTENT';
end;

{ TBisKrieltDataSubscriptionContentUpdateFormIface }

constructor TBisKrieltDataSubscriptionContentUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_SUBSCRIPTION_CONTENT';
end;

{ TBisKrieltDataSubscriptionContentDeleteFormIface }

constructor TBisKrieltDataSubscriptionContentDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_SUBSCRIPTION_CONTENT';
end;


{ TBisKrieltDataSubscriptionContentEditForm }

procedure TBisKrieltDataSubscriptionContentEditForm.Execute;
begin
  inherited Execute;
end;

end.