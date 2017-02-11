unit BisRegInit;

interface

uses BisIfaceModules, BisModules, BisCoreObjects,
     BisCoreIntf;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;                 

exports
  InitIfaceModule;

implementation

uses BisCore,
     BisRegFm;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
begin
  with AModule.Ifaces do begin
    AddClass(TBisRegFormIface);
  end;
end;

end.