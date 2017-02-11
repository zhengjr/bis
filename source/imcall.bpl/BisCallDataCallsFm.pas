unit BisCallDataCallsFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, DB,
  BisFm, BisDataFrm, BisDataGridFm,
  BisCallDataCallEditFm;

type

  TBisCallDataCallsForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  end;

  TBisCallDataCallsFormIface=class(TBisDataGridFormIface)                                    
  private
    FViewMode: TBisCallDataCallViewMode;
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;

    property ViewMode: TBisCallDataCallViewMode read FViewMode write FViewMode;
  end;

  TBisCallDataInCallsFormIface=class(TBisCallDataCallsFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisCallDataOutCallsFormIface=class(TBisCallDataCallsFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallDataCallsForm: TBisCallDataCallsForm;

implementation

uses BisCallDataCallsFrm;

{$R *.dfm}

{ TBisCallDataCallsFormIface }

constructor TBisCallDataCallsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallDataCallsForm;
  Permissions.Enabled:=true;
  ChangeFrameProperties:=false;

  FViewMode:=vmFull;
end;

function TBisCallDataCallsFormIface.CreateForm: TBisForm;
var
  Form: TBisCallDataCallsForm;
begin
  Result:=inherited CreateForm;
  if Assigned(Result) and (Result is TBisCallDataCallsForm) then begin
    Form:=TBisCallDataCallsForm(Result);
    if Assigned(Form.DataFrame) and (Form.DataFrame is TBisCallDataCallsFrame) then
      TBisCallDataCallsFrame(Form.DataFrame).ViewMode:=FViewMode;
  end;
end;

{ TBisCallDataCallsForm }

class function TBisCallDataCallsForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisCallDataCallsFrame;
end;

{ TBisCallDataInCallsFormIface }

constructor TBisCallDataInCallsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ViewMode:=vmIncoming;
end;

{ TBisCallDataOutCallsFormIface }

constructor TBisCallDataOutCallsFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ViewMode:=vmOutgoing;
end;

end.