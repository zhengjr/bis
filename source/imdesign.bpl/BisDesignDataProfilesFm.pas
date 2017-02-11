unit BisDesignDataProfilesFm;

interface
                                                                                                         
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList;

type
  TBisDesignDataProfilesForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisDesignDataProfilesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BiDesignDataProfilesForm: TBisDesignDataProfilesForm;

implementation

{$R *.dfm}

uses BisDesignDataProfileEditFm;

{ TBisDesignDataProfilesFormIface }

constructor TBisDesignDataProfilesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataProfilesForm;
  FilterClass:=TBisDesignDataProfileEditFormIface;
  InsertClass:=TBisDesignDataProfileInsertFormIface;
  UpdateClass:=TBisDesignDataProfileUpdateFormIface;
  DeleteClass:=TBisDesignDataProfileDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  ProviderName:='S_PROFILES';
  with FieldNames do begin
    AddKey('APPLICATION_ID');
    AddKey('ACCOUNT_ID');
    AddInvisible('PROFILE');
    Add('APPLICATION_NAME','����������',150);
    Add('USER_NAME','�����',150);
  end;
  Orders.Add('APPLICATION_NAME');
  Orders.Add('USER_NAME');
end;

end.