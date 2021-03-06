unit BisTaxiDataOutMessagesFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, ActnList, DB,
  BisFm, BisDataFrm, BisDataGridFm;

type
  TBisTaxiDataOutMessagesForm = class(TBisDataGridForm)
  protected
    class function GetDataFrameClass: TBisDataFrameClass; override;
  end;

  TBisTaxiDataOutMessagesFormIface=class(TBisDataGridFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisTaxiDataOutMessagesForm: TBisTaxiDataOutMessagesForm;

implementation

uses BisTaxiDataOutMessagesFrm;

{$R *.dfm}

{ TBisTaxiDataOutMessagesFormIface }

constructor TBisTaxiDataOutMessagesFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisTaxiDataOutMessagesForm;
  Permissions.Enabled:=true;
  ChangeFrameProperties:=false;
end;

{ TBisTaxiDataOutMessagesForm }

class function TBisTaxiDataOutMessagesForm.GetDataFrameClass: TBisDataFrameClass;
begin
  Result:=TBisTaxiDataOutMessagesFrame;
end;



end.
