unit BisDesignDataLocksFm;

interface

uses                                                                                                         
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList;

type
  TBisDesignDataLocksForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisDesignDataLocksFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BiDesignDataLocksForm: TBisDesignDataLocksForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisDesignDataLockEditFm;

{ TBisDesignDataLocksFormIface }

constructor TBisDesignDataLocksFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataLocksForm;
  FilterClass:=TBisDesignDataLockEditFormIface;
  InsertClass:=TBisDesignDataLockInsertFormIface;
  UpdateClass:=TBisDesignDataLockUpdateFormIface;
  DeleteClass:=TBisDesignDataLockDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  ProviderName:='S_LOCKS';
  with FieldNames do begin
    AddKey('LOCK_ID');
    AddInvisible('APPLICATION_ID');
    AddInvisible('ACCOUNT_ID');
    AddInvisible('DESCRIPTION');
    AddInvisible('IP_LIST');
    Add('APPLICATION_NAME','����������',100);
    Add('USER_NAME','������������',100);
    Add('DATE_BEGIN','���� ������',100);
    Add('DATE_END','���� ���������',100);
    Add('METHOD','�����',100);
    Add('OBJECT','������',100).Visible:=false;
  end;
  Orders.Add('APPLICATION_NAME');
  Orders.Add('DATE_BEGIN');
end;

end.