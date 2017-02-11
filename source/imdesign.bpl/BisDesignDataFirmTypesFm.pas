unit BisDesignDataFirmTypesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,                                       
  Dialogs, BisDataGridFm, StdCtrls, ExtCtrls, ComCtrls, BisFm, ActnList;

type
  TBisDesignDataFirmTypesForm = class(TBisDataGridForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisDesignDataFirmTypesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignDataFirmTypesForm: TBisDesignDataFirmTypesForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisDesignDataFirmTypeEditFm;

{ TBisDesignDataFirmTypesFormIface }

constructor TBisDesignDataFirmTypesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataFirmTypesForm;
  FilterClass:=TBisDesignDataFirmTypeEditFormIface;
  InsertClass:=TBisDesignDataFirmTypeInsertFormIface;
  UpdateClass:=TBisDesignDataFirmTypeUpdateFormIface;
  DeleteClass:=TBisDesignDataFirmTypeDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  ProviderName:='S_FIRM_TYPES';
  with FieldNames do begin
    AddKey('FIRM_TYPE_ID');
    Add('NAME','������������',150);
    Add('DESCRIPTION','��������',200);
    AddInvisible('PRIORITY');
  end;
  Orders.Add('PRIORITY');
end;

end.