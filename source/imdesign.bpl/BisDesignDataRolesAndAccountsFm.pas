unit BisDesignDataRolesAndAccountsFm;

interface
                                                                                                
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, DB,
  VirtualTrees, 
  BisFm, BisDataFrm, BisFieldNames, BisDataTreeFm, BisDataTreeFrm, BisDataGridFm;

type
  TBisDesignDataRolesAndAccountsFrame=class(TBisDataTreeFrame)
  private
    procedure TreeClick(Sender: TObject);
    function GetNewUserName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
  public
    constructor Create(AOwner: TComponent); override;
    procedure OpenRecords; override;
    procedure Init; override;
  end;

  TBisDesignDataRolesAndAccountsForm = class(TBisDataTreeForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDesignDataRolesAndAccountsFormIface=class(TBisDataTreeFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisDesignDataRolesAndAccountsForm: TBisDesignDataRolesAndAccountsForm;

implementation

uses BisFilterGroups, BisOrders, BisProvider, BisUtils, BisDialogs;

{$R *.dfm}

{ TBisDesignDataRolesAndAccountsFrame }

constructor TBisDesignDataRolesAndAccountsFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  with Provider do begin
    ProviderName:='S_ROLES_ACCOUNTS';
    with FieldNames do begin
      AddKey('ACCOUNT_ID');
      AddParentKey('PARENT_ID');
      AddInvisible('NAME');
      AddInvisible('SURNAME');
      AddInvisible('PATRONYMIC');
      AddInvisible('USER_NAME');
      AddInvisible('PHONE');

      AddCalculate('NEW_USER_NAME','������������',GetNewUserName,ftString,400,300);
    end;
  end;

  ActionView.Visible:=false;
  ActionInsert.Visible:=false;
  ActionDuplicate.Visible:=false;
  ActionUpdate.Visible:=false;
  ActionDelete.Visible:=false;

  Tree.OnClick:=TreeClick;
end;

function TBisDesignDataRolesAndAccountsFrame.GetNewUserName(FieldName: TBisFieldName; DataSet: TDataSet): Variant;
var
  S1, S2, S3, S4: String;
begin
  Result:=Null;
  if DataSet.Active then begin
    if VarIsNull(DataSet.FieldByName('PARENT_ID').Value) then begin
      Result:=DataSet.FieldByName('USER_NAME').Value;
    end else begin
      S1:=DataSet.FieldByName('USER_NAME').AsString;
      S2:=DataSet.FieldByName('SURNAME').AsString;
      S3:=DataSet.FieldByName('NAME').AsString;
      S4:=DataSet.FieldByName('PATRONYMIC').AsString;
      Result:=FormatEx('%s - %s %s %s',[S1,S2,S3,S4]);
    end;
  end;
end;

procedure TBisDesignDataRolesAndAccountsFrame.Init;
begin
  inherited Init;
end;

procedure TBisDesignDataRolesAndAccountsFrame.OpenRecords;
begin
  inherited OpenRecords;
end;

procedure TBisDesignDataRolesAndAccountsFrame.TreeClick(Sender: TObject);
begin
end;

{ TBisDesignDataAccountsFormIface }

constructor TBisDesignDataRolesAndAccountsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisDesignDataRolesAndAccountsForm;
  Permissions.Enabled:=true;
  ChangeFrameProperties:=false;
end;

{ TBisDesignDataRolesAndAccountsForm }

constructor TBisDesignDataRolesAndAccountsForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

class function TBisDesignDataRolesAndAccountsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisDesignDataRolesAndAccountsFrame;
end;

end.