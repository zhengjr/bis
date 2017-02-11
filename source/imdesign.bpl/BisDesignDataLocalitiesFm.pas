unit BisDesignDataLocalitiesFm;

interface
                                                                                                            
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList,
  BisDataFrm, BisDataGridFm, BisDesignDataLocalitiesFrm;

type
  TBisDesignDataLocalitiesForm = class(TBisDataGridForm)
  private
    { Private declarations }
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  public
    { Public declarations }
  end;

  TBisDesignDataLocalitiesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignDataLocalitiesForm: TBisDesignDataLocalitiesForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisDesignDataLocalityEditFm;

{ TBisDesignDataLocalitiesFormIface }

constructor TBisDesignDataLocalitiesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataLocalitiesForm;
  FilterClass:=TBisDesignDataLocalityEditFormIface;
  InsertClass:=TBisDesignDataLocalityInsertFormIface;
  UpdateClass:=TBisDesignDataLocalityUpdateFormIface;
  DeleteClass:=TBisDesignDataLocalityDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  ProviderName:='S_LOCALITIES';
  with FieldNames do begin
    AddKey('LOCALITY_ID');
    Add('NAME','������������',280);
    Add('PREFIX','�������',70);
  end;
  Orders.Add('NAME');
end;

{ TBisDesignDataLocalitiesForm }

class function TBisDesignDataLocalitiesForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisDesignDataLocalitiesFrame;
end;

end.