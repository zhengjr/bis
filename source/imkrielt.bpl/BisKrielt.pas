unit BisKrielt;

interface

uses BisIfaceModules, BisModules, BisCoreObjects,
     BisCoreIntf;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;

exports
  InitIfaceModule;

implementation

uses BisCore, BisKrieltMainFm,
     BisKrieltDataTypesFm, BisKrieltDataViewsFm, BisKrieltDataOperationsFm, BisKrieltDataParamsFm,
     BisKrieltDataViewTypesFm, BisKrieltDataTypeOperationsFm, BisKrieltDataDesignsFm,
     BisKrieltDataInputParamsFm, BisKrieltDataAccountParamsFm,
     BisKrieltDataParamValuesFm, BisKrieltDataParamValueDependsFm, BisKrieltDataPresentationsFm,
     BisKrieltDataColumnsFm, BisKrieltDataColumnParamsFm, BisKrieltDataExportsFm,
     BisKrieltDataConsultantsFm, BisKrieltDataSubjectsFm, BisKrieltDataQuestionsFm,
     BisKrieltDataAnswersFm, BisKrieltDataArticlesFm, BisKrieltDataCommentsFm,

     BisKrieltDataAccountPresenatationsFm, BisKrieltDataServicesFm, BisKrieltDataPagesFm,
     BisKrieltDataBannersFm, BisKrieltDataPlacementsFm,
     BisKrieltDataPublishingFm, BisKrieltDataIssuesFm, BisKrieltImportFm,
     BisKrieltDataCreditProgramsFm, BisKrieltExportRtfFm, BisKrieltExportXlsFm, BisKrieltObjectsFm,
     BisKrieltDataSubscriptionsFm, BisKrieltDataAccountSubscriptionsFm,
     BisKrieltDataSubscriptionContentsFm, BisKrieltObjectsDeleteFm,

     BisKrieltRefreshIface;

procedure InitIfaceModule(AModule: TBisIfaceModule); stdcall;
var
  IsMainModule: Boolean;
begin
  IsMainModule:=Core.IfaceModules.IsFirstModule(AModule);
  with AModule do begin

    if IsMainModule then
      MainIface:=TBisKrieltMainFormIface(Ifaces.AddClass(TBisKrieltMainFormIface));

    Classes.Add(TBisKrieltDataPublishingFormIface);
    Classes.Add(TBisKrieltDataIssuesFormIface);

    Classes.Add(TBisKrieltDataViewsFormIface);
    Classes.Add(TBisKrieltDataTypesFormIface);
    Classes.Add(TBisKrieltDataOperationsFormIface);
    Classes.Add(TBisKrieltDataDesignsFormIface);
    Classes.Add(TBisKrieltDataViewTypesFormIface);
    Classes.Add(TBisKrieltDataTypeOperationsFormIface);
    Classes.Add(TBisKrieltDataParamsFormIface);
    Classes.Add(TBisKrieltDataParamValuesFormIface);
    Classes.Add(TBisKrieltDataParamValueDependsFormIface);
    Classes.Add(TBisKrieltDataPresentationsFormIface);
    Classes.Add(TBisKrieltDataColumnsFormIface);
    Classes.Add(TBisKrieltDataColumnParamsFormIface);
    Classes.Add(TBisKrieltDataExportsFormIface);

    Classes.Add(TBisKrieltImportFormIface);
    Classes.Add(TBisKrieltExportRtfFormIface);
    Classes.Add(TBisKrieltExportXlsFormIface);
    Classes.Add(TBisKrieltObjectsFormIface);
    Classes.Add(TBisKrieltObjectsDeleteFormIface);

    Classes.Add(TBisKrieltDataAccountPresentationsFormIface);
    Classes.Add(TBisKrieltDataInputParamsFormIface);
    Classes.Add(TBisKrieltDataConsultantsFormIface);
    Classes.Add(TBisKrieltDataSubjectsFormIface);
    Classes.Add(TBisKrieltDataQuestionsFormIface);
    Classes.Add(TBisKrieltDataAnswersFormIface);
    Classes.Add(TBisKrieltDataArticlesFormIface);
    Classes.Add(TBisKrieltDataCommentsFormIface);
    Classes.Add(TBisKrieltDataPagesFormIface);
    Classes.Add(TBisKrieltDataBannersFormIface);
    Classes.Add(TBisKrieltDataPlacementsFormIface);

{    Classes.Add(TBisKrieltDataTypeParamsFormIface);
    Classes.Add(TBisKrieltDataAccountParamsFormIface);


    Classes.Add(TBisKrieltDataServicesFormIface);

    Classes.Add(TBisKrieltDataCreditProgramsFormIface);
    Classes.Add(TBisKrieltDataSubscriptionsFormIface);
    Classes.Add(TBisKrieltDataAccountSubscriptionsFormIface);
    Classes.Add(TBisKrieltDataSubscriptionContentsFormIface);

    Classes.Add(TBisKrieltExportRtfFormIface);

    Classes.Add(TBisKrieltRefreshIface);}
  end;

end;

end.