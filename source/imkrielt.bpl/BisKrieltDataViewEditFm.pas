unit BisKrieltDataViewEditFm;

interface                                                                                                  

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls, ComCtrls, ImgList;

type
  TBisKrieltDataViewEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelNum: TLabel;
    EditNum: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisKrieltDataViewEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataViewInsertFormIface=class(TBisKrieltDataViewEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataViewUpdateFormIface=class(TBisKrieltDataViewEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisKrieltDataViewDeleteFormIface=class(TBisKrieltDataViewEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisKrieltDataViewEditForm: TBisKrieltDataViewEditForm;

implementation

{$R *.dfm}

{ TBisKrieltDataViewEditFormIface }

constructor TBisKrieltDataViewEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataViewEditForm;
  with Params do begin
    AddKey('VIEW_ID').Older('OLD_VIEW_ID');
    AddEdit('NUM','EditNum','LabelNum',true);
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
  end;
end;

{ TBisKrieltDataViewInsertFormIface }

constructor TBisKrieltDataViewInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_VIEW';
end;

{ TBisKrieltDataViewUpdateFormIface }

constructor TBisKrieltDataViewUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_VIEW';
end;

{ TBisKrieltDataViewDeleteFormIface }

constructor TBisKrieltDataViewDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_VIEW';
end;

end.