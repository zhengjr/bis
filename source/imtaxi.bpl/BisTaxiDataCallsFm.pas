unit BisTaxiDataCallsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, DB,
  BisFm, BisDataFrm, BisDataGridFm, BisDataEditFm,
  BisCallDataCallEditFm, BisCallDataCallsFm, BisCallDataCallsFrm;

type

  TBisTaxiDataCallsFrame=class(TBisCallDataCallsFrame)
  private
    FOrderId: Variant;
  protected
    procedure BeforeIfaceExecute(AIface: TBisDataEditFormIface); override;
  public
    constructor Create(AOwner: TComponent); override;

    property OrderId: Variant read FOrderId write FOrderId;
  end;

  TBisTaxiDataCallsForm = class(TBisCallDataCallsForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  end;

  TBisTaxiDataCallsFormIface=class(TBisCallDataCallsFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataInCallsFormIface=class(TBisTaxiDataCallsFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisTaxiDataOutCallsFormIface=class(TBisTaxiDataCallsFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataCallsForm: TBisTaxiDataCallsForm;

implementation

uses BisParam,
     BisTaxiDataCallEditFm, BisTaxiDataCallFilterFm;

{$R *.dfm}

{ TBisTaxiDataCallsFrame }

constructor TBisTaxiDataCallsFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FilterClass:=TBisTaxiDataCallFilterFormIface;
  ViewClass:=TBisTaxiDataCallViewFormIface;
  InsertClass:=TBisTaxiDataCallInsertFormIface;
  UpdateClass:=TBisTaxiDataCallUpdateFormIface;
  DeleteClass:=TBisTaxiDataCallDeleteFormIface;

  Provider.FieldNames.AddInvisible('ORDER_ID');

  FOrderId:=Null;
end;

procedure TBisTaxiDataCallsFrame.BeforeIfaceExecute(AIface: TBisDataEditFormIface);
var
  POrder: TBisParam;
begin
  inherited BeforeIfaceExecute(AIface);
  if Assigned(AIface) then begin
    with AIface.Params do begin
      POrder:=Find('ORDER_ID');
      if Assigned(POrder) then
        POrder.Value:=FOrderId;
    end;
  end;
end;

{ TBisTaxiDataCallsFormIface }

constructor TBisTaxiDataCallsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataCallsForm;
end;

{ TBisTaxiDataCallsForm }

class function TBisTaxiDataCallsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisTaxiDataCallsFrame;
end;

{ TBisTaxiDataInCallsFormIface }

constructor TBisTaxiDataInCallsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ViewMode:=vmIncoming;
end;

{ TBisTaxiDataOutCallsFormIface }

constructor TBisTaxiDataOutCallsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ViewMode:=vmOutgoing;
end;

end.