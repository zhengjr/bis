unit BisSysUtilsUnit;

interface

uses Classes,
     BisProgram;

type

  TBisSysUtilsUnit=class(TBisUnit)
  public
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{ TBisSysUtilsUnit }

constructor TBisSysUtilsUnit.Create(AOwner: TComponent); 
begin
  inherited Create(AOwner);
  Name:='SysUtils';
end;

end.