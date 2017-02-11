unit BisTaxiDataClientGroupsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList,
  BisDataTreeFm, BisDataGridFm;

type
  TBisTaxiDataClientGroupsForm = class(TBisDataTreeForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TBisTaxiDataClientGroupsFormIface=class(TBisDataTreeFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataClientGroupsForm: TBisTaxiDataClientGroupsForm;

implementation

uses BisTaxiDataClientGroupEditFm;

{$R *.dfm}

{ TBisTaxiDataClientGroupsFormIface }

constructor TBisTaxiDataClientGroupsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataClientGroupsForm;
  FilterClass:=TBisTaxiDataClientGroupEditFormIface;
  ViewClass:=TBisTaxiDataClientGroupViewFormIface;
  InsertClasses.Add(TBisTaxiDataClientGroupInsertFormIface);
  InsertClasses.Add(TBisTaxiDataClientGroupInsertChildFormIface);
  UpdateClass:=TBisTaxiDataClientGroupUpdateFormIface;
  DeleteClass:=TBisTaxiDataClientGroupDeleteFormIface;
  Permissions.Enabled:=true;
  ProviderName:='S_CLIENT_GROUPS';
  with FieldNames do begin
    AddKey('CLIENT_GROUP_ID');
    AddParentKey('PARENT_ID');
    AddInvisible('DESCRIPTION');
    Add('NAME','������������',250);
    Add('PARENT_NAME','��������',150);
    Add('PRIORITY','�������',50);
  end;
  Orders.Add('LEVEL');
  Orders.Add('PRIORITY');
end;

end.