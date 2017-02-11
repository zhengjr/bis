unit BisCallcHbookPatternsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList;

type
  TBisCallcHbookPatternsForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisCallcHbookPatternsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcHbookPatternsForm: TBisCallcHbookPatternsForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisCallcHbookPatternEditFm;

{ TBisCallcHbookPatternsFormIface }

constructor TBisCallcHbookPatternsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcHbookPatternsForm;
  InsertClass:=TBisCallcHbookPatternInsertFormIface;
  UpdateClass:=TBisCallcHbookPatternUpdateFormIface;
  DeleteClass:=TBisCallcHbookPatternDeleteFormIface;
  Permissions.Enabled:=true;
  Available:=true;
  ProviderName:='S_PATTERNS';
  with FieldNames do begin
    AddKey('PATTERN_ID');
    AddInvisible('PATTERN');
    Add('NAME','������������',150);
    Add('DESCRIPTION','��������',250);
  end;
  Orders.Add('NAME');
end;

end.