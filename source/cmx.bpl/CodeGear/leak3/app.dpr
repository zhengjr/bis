program app;

uses
  Forms,
  SysUtils;

{$R *.res}

var
  Package: HModule;
begin
  Application.Initialize;
  Package:=LoadPackage('core.bpl');
  if Package<>0 then begin
  end;
end.