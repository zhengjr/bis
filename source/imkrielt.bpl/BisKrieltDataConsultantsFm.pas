unit BisKrieltDataConsultantsFm;

interface                                                                                         

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList,
  BisDataGridFm, BisFm, BisDataGridFrm, BisDataFrm;

type
  TBisKrieltDataConsultantsForm = class(TBisDataGridForm)
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

  TBisKrieltDataConsultantsFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BiKrieltDataConsultantsForm: TBisKrieltDataConsultantsForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisKrieltDataConsultantEditFm;

{ TBisKrieltDataConsultantsFormIface }

constructor TBisKrieltDataConsultantsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisKrieltDataConsultantsForm;
  Permissions.Enabled:=true;
  FilterClass:=TBisKrieltDataConsultantEditFormIface;
  InsertClass:=TBisKrieltDataConsultantInsertFormIface;
  UpdateClass:=TBisKrieltDataConsultantUpdateFormIface;
  DeleteClass:=TBisKrieltDataConsultantDeleteFormIface;
  ProviderName:='S_CONSULTANTS';
  with FieldNames do begin
    AddKey('CONSULTANT_ID');
    AddInvisible('FIRM_ID');
    AddInvisible('FIRM_SMALL_NAME');
    AddInvisible('DATE_CREATE');
    AddInvisible('PASSWORD');
    AddInvisible('PHONE');
    AddInvisible('JOB_TITLE');
    AddInvisible('LOCKED');
    AddInvisible('DESCRIPTION');
    Add('SURNAME','�������',110);
    Add('NAME','���',100);
    Add('PATRONYMIC','��������',115);
    Add('USER_NAME','�����',100);
    Add('EMAIL','Email',100);
  end;
  Orders.Add('SURNAME');
  Orders.Add('NAME');
  Orders.Add('PATRONYMIC');
end;

{ TBisKrieltDataConsultantsForm }

constructor TBisKrieltDataConsultantsForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TBisKrieltDataConsultantsForm.Destroy;
begin
  inherited Destroy;
end;

end.