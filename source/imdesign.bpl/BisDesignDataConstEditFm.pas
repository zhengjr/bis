unit BisDesignDataConstEditFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,                                   
  Dialogs, StdCtrls, ExtCtrls, ImgList,
  BisDataEditFm, BisSynEdit, BisControls;

type
  TBisDesignDataConstEditForm = class(TBisDataEditForm)
    LabelName: TLabel;
    EditName: TEdit;
    LabelDescription: TLabel;
    MemoDescription: TMemo;
    LabelValue: TLabel;
    MemoValue: TMemo;
    ButtonName: TButton;
    CheckBoxEnabled: TCheckBox;
    ComboBoxType: TComboBox;
    procedure ButtonNameClick(Sender: TObject);
    procedure ComboBoxTypeChange(Sender: TObject);
  private
    FXmlHighlighter: TBisSynXmlSyn;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BeforeShow; override;
  end;

  TBisDesignDataConstEditFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataConstInsertFormIface=class(TBisDesignDataConstEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataConstUpdateFormIface=class(TBisDesignDataConstEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataConstDeleteFormIface=class(TBisDesignDataConstEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignDataConstEditForm: TBisDesignDataConstEditForm;

implementation

uses SynEdit,
     BisUtils, BisParam,
     BisParamSynEdit;

{$R *.dfm}

{ TBisDesignDataConstEditFormIface }

constructor TBisDesignDataConstEditFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataConstEditForm;
  with Params do begin
    with AddEdit('NAME','EditName','LabelName',true) do begin
      IsKey:=true;
      Older('OLD_NAME');
    end;
    AddMemo('DESCRIPTION','MemoDescription','LabelDescription');
    AddSynEdit('VALUE','MemoValue','LabelValue',true);
    AddCheckBox('ENABLED','CheckBoxEnabled',1);
  end;
end;

{ TBisDesignDataConstInsertFormIface }

constructor TBisDesignDataConstInsertFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='I_CONST';
end;

{ TBisDesignDataConstUpdateFormIface }

constructor TBisDesignDataConstUpdateFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='U_CONST';
end;

{ TBisDesignDataConstDeleteFormIface }

constructor TBisDesignDataConstDeleteFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ProviderName:='D_CONST';
end;

{ TBisDesignDataConstEditForm }

constructor TBisDesignDataConstEditForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FXmlHighlighter:=TBisSynXmlSyn.Create(Self);
end;

destructor TBisDesignDataConstEditForm.Destroy;
begin
  inherited Destroy;
end;

procedure TBisDesignDataConstEditForm.BeforeShow;
begin
  inherited BeforeShow;
  ButtonName.Enabled:=not (Mode in [emDelete,emFilter]);
end;

procedure TBisDesignDataConstEditForm.ButtonNameClick(Sender: TObject);
begin
  Provider.Params.ParamByName('NAME').Value:=GetUniqueID;
end;

procedure TBisDesignDataConstEditForm.ComboBoxTypeChange(Sender: TObject);
var
  Param: TBisParamSynEdit;
begin
  Param:=TBisParamSynEdit(Provider.ParamByName('VALUE'));
  case ComboBoxType.ItemIndex of
    0: Param.SynEdit.Highlighter:=nil;
    1: Param.SynEdit.Highlighter:=FXmlHighlighter;
  end;
end;


end.
