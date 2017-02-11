unit BisBall;

interface

uses BisIfaceModules, BisModules, BisCoreObjects,
     BisCoreIntf;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;

exports
  InitIfaceModule;
                                       
implementation

uses BisCore, BisBallConsts,
     BisBallMainFm, BisBallDataDealersFm, BisBallDataTiragesFm,
     BisBallImportTicketsFm, BisBallManageTicketFm, BisBallLotteryFm,
     BisBallDistrTicketsFm, BisBallExportFm;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
begin
  IsMainModule:=Core.IfaceModules.IsFirstModule(AModule);
  with AModule do begin

    if IsMainModule then
      Ifaces.AddClass(TBisBallMainFormIface);

    Classes.Add(TBisBallDataDealersFormIface);
    Classes.Add(TBisBallDataTiragesFormIface);
    Classes.Add(TBisBallImportTicketsFormIface);
    Classes.Add(TBisBallDistrTicketsFormIface);
    Classes.Add(TBisBallManageTicketFormIface);
    Classes.Add(TBisBallLotteryFormIface);
    Classes.Add(TBisBallExportFormIface);
      
    TiragesIface:=TBisBallDataTiragesFormIface(Ifaces.AddClass(TBisBallDataTiragesFormIface));
    ImportIface:=TBisBallImportTicketsFormIface(Ifaces.AddClass(TBisBallImportTicketsFormIface));
    ManageIface:=TBisBallManageTicketFormIface(Ifaces.AddClass(TBisBallManageTicketFormIface));
    DistrIface:=TBisBallDistrTicketsFormIface(Ifaces.AddClass(TBisBallDistrTicketsFormIface));
    LotteryIface:=TBisBallLotteryFormIface(Ifaces.AddClass(TBisBallLotteryFormIface));
    ExportIface:=TBisBallExportFormIface(Ifaces.AddClass(TBisBallExportFormIface));

  end;
end;

end.