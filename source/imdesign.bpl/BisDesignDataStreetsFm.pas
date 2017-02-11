unit BisDesignDataStreetsFm;

interface

uses                                                                                                  
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList,
  BisFm, BisDataFrm, BisDataGridFm, BisDataGridFrm, BisDataEditFm;

type
  TBisDesignDataStreetsFrame=class(TBisDataGridFrame)
  private
    FLocalityId: Variant;
    FLocalityName: String;
    FLocalityPrefix: String;
  protected
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); override;  
  public
    property LocalityId: Variant read FLocalityId write FLocalityId;
    property LocalityName: String read FLocalityName write FLocalityName;
    property LocalityPrefix: String read FLocalityPrefix write FLocalityPrefix;
  end;

  TBisDesignDataStreetsForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  end;

  TBisDesignDataStreetsFormIface=class(TBisDataGridFormIface)
  private
    FLocalityId: Variant;
    FLocalityName: String;
    FLocalityPrefix: String;
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;

    property LocalityId: Variant read FLocalityId write FLocalityId;
    property LocalityName: String read FLocalityName write FLocalityName;
    property LocalityPrefix: String read FLocalityPrefix write FLocalityPrefix; 
  end;

var
  BisDesignDataStreetsForm: TBisDesignDataStreetsForm;

implementation

{$R *.dfm}

uses BisFilterGroups, BisDesignDataStreetEditFm, BisParam, BisUtils, BisParamEditDataSelect;

{ TBisDesignDataStreetsFrame }

procedure TBisDesignDataStreetsFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
var
  ParamId: TBisParamEditDataSelect;
  ParamName: TBisParam;
begin
  inherited BeforeIfaceExecute(AIface);
  if Assigned(AIface) then begin
    ParamId:=TBisParamEditDataSelect(AIface.Params.Find('LOCALITY_ID'));
    if Assigned(ParamId) and not VarIsNull(FLocalityId) then begin
      ParamId.Value:=FLocalityId;
      AIface.Params.ParamByName('LOCALITY_NAME').Value:=FLocalityName;
      AIface.Params.ParamByName('LOCALITY_PREFIX').Value:=FLocalityPrefix;
      ParamName:=AIface.Params.Find('LOCALITY_PREFIX;LOCALITY_NAME');
      if Assigned(ParamName) then begin
        ParamName.Value:=FormatEx(ParamId.DataAliasFormat,[FLocalityPrefix,FLocalityName]);
      end;
      ParamId.ExcludeModes(AllParamEditModes);
    end;
  end;
end;

{ TBisDesignDataStreetsFormIface }

constructor TBisDesignDataStreetsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLocalityId:=Null;
  FormClass:=TBisDesignDataStreetsForm;
  FilterClass:=TBisDesignDataStreetFilterFormIface;
  InsertClass:=TBisDesignDataStreetInsertFormIface;
  UpdateClass:=TBisDesignDataStreetUpdateFormIface;
  DeleteClass:=TBisDesignDataStreetDeleteFormIface;
  Permissions.Enabled:=true;
//  Available:=true;
  ProviderName:='S_STREETS';
  with FieldNames do begin
    AddKey('STREET_ID');
    AddInvisible('LOCALITY_ID');
    AddInvisible('LOCALITY_PREFIX');
    Add('NAME','������������',200);
    Add('PREFIX','�������',70);
    Add('LOCALITY_NAME','���������� �����',130);
  end;
  Orders.Add('NAME');
end;

function TBisDesignDataStreetsFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) then begin
    with TBisDesignDataStreetsForm(Result) do begin
      TBisDesignDataStreetsFrame(DataFrame).LocalityId:=FLocalityId;
      TBisDesignDataStreetsFrame(DataFrame).LocalityName:=FLocalityName;
      TBisDesignDataStreetsFrame(DataFrame).LocalityPrefix:=FLocalityPrefix;
    end;
  end;
end;

{ TBisDesignDataStreetsForm }

class function TBisDesignDataStreetsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisDesignDataStreetsFrame;
end;

end.