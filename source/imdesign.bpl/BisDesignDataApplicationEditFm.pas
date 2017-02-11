unit BisDesignDataApplicationEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisDataEditFm, BisControls, ImgList;
                                                                                                               
type
  TBisDesignDataApplicationEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    CheckBoxLocked: TCheckBox;
    LabelVersion: TLabel;
    EditVersion: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisDesignDataApplicationEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataApplicationInsertFormIface=class(TBisDesignDataApplicationEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataApplicationUpdateFormIface=class(TBisDesignDataApplicationEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataApplicationDeleteFormIface=class(TBisDesignDataApplicationEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignDataApplicationEditForm: TBisDesignDataApplicationEditForm;

implementation

{$R *.dfm}

{ TBisDesignDataApplicationEditFormIface }

constructor TBisDesignDataApplicationEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataApplicationEditForm;
  with Params do begin
    AddKey('APPLICATION_ID').Older('OLD_APPLICATION_ID');
    AddEdit('NAME','EditName','LabelName',true);
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription',false);
    AddEdit('VERSION','EditVersion','LabelVersion');
    AddCheckBox('LOCKED','CheckBoxLocked');
  end;
end;

{ TBisDesignDataApplicationInsertFormIface }

constructor TBisDesignDataApplicationInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_APPLICATION';
end;

{ TBisDesignDataApplicationUpdateFormIface }

constructor TBisDesignDataApplicationUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_APPLICATION';
end;

{ TBisDesignDataApplicationDeleteFormIface }

constructor TBisDesignDataApplicationDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_APPLICATION';
end;

end.