unit BisBallSecondRoundFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls, DB, Buttons,
  BisBallBarrelFrm, BisControls;

type
  TBisBallSecondRoundFrame = class(TBisBallBarrelFrame)
  public
    constructor Create(AOwner: TComponent); override;
    function GetLotteryColor(ARoundNum: Integer; ASubroundId: Variant): TColor; override;
  end;

implementation

uses BisProvider, BisConsts, BisFilterGroups;

{$R *.dfm}

{ TBisBallSecondRoundFrame }

constructor TBisBallSecondRoundFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  RoundNum:=2;
  ProviderName:='GET_SECOND_ROUND';
end;

function TBisBallSecondRoundFrame.GetLotteryColor(ARoundNum: Integer; ASubroundId: Variant): TColor;
begin
  Result:=inherited GetLotteryColor(ARoundNum,ASubroundId);
end;

end.