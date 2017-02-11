unit BisCallcHbookPlanEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls;

type
  TBisCallcHbookPlanEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisCallcHbookPlanEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookPlanInsertFormIface=class(TBisCallcHbookPlanEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookPlanUpdateFormIface=class(TBisCallcHbookPlanEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallcHbookPlanDeleteFormIface=class(TBisCallcHbookPlanEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcHbookPlanEditForm: TBisCallcHbookPlanEditForm;

implementation

{$R *.dfm}

{ TBisCallcHbookPlanEditFormIface }

constructor TBisCallcHbookPlanEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookPlanEditForm;
  with Params do begin
    AddKey('PLAN_ID').Older('OLD_PLAN_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
  end;
end;

{ TBisCallcHbookPlanInsertFormIface }

constructor TBisCallcHbookPlanInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_PLAN';
end;

{ TBisCallcHbookPlanUpdateFormIface }

constructor TBisCallcHbookPlanUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_PLAN';
end;

{ TBisCallcHbookPlanDeleteFormIface }

constructor TBisCallcHbookPlanDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_PLAN';
end;

end.