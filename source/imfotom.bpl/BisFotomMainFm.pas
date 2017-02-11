unit BisFotomMainFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, StdCtrls,
  ComCtrls, ExtCtrls, DB, ActnList, ToolWin, ImgList, Menus,
  frxBarCod,
  BisFm, BisIfaces, BisProvider, BisFotomCatalogFm, BisFotomCanon, BisControls,
  BisDataFrm, BisDataGridFrm, BisDataEditFm, BisFieldNames, BisOrders, BisBarCodeScanner,
  BisFotomSendFm, BisFotomResultFrm, BisComPort,
  BisFotomMainFmIntf;

type
  TBisFotomMainFormImage=class(TGraphicControl)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisFotomMainForm = class(TBisForm,IBisFotomMainForm)
    PanelScanner: TPanel;
    GroupBoxDevices: TGroupBox;
    ButtonScannerConnect: TButton;
    LabelFoto: TLabel;
    MemoDevice: TMemo;
    ButtonFotoConnect: TButton;
    GroupBoxCatalog: TGroupBox;
    LabelBarcode: TLabel;
    LabelName: TLabel;
    EditBarcode: TEdit;
    ButtonBarcode: TButton;
    MemoName: TMemo;
    GroupBoxFoto: TGroupBox;
    PanelBarcode: TPanel;
    PanelFoto: TPanel;
    ImageFoto: TImage;
    ImageBarcode: TImage;
    LabelScanner: TLabel;
    ButtonMatch: TButton;
    ActionList: TActionList;
    ActionMatch: TAction;
    GroupBoxResult: TGroupBox;
    PanelResult: TPanel;
    ControlBar: TControlBar;
    ToolBarFoto: TToolBar;
    ToolButtonZoomIn: TToolButton;
    ActionZoomIn: TAction;
    ActionZoomOut: TAction;
    ActionReset: TAction;
    ToolButtonZoomOut: TToolButton;
    ToolButtonReset: TToolButton;
    ImageList: TImageList;
    PanelProgress: TPanel;
    ProgressBarFoto: TProgressBar;
    ToolButtonCamera: TToolButton;
    ActionCameraOn: TAction;
    TimerFoto: TTimer;
    procedure ButtonBarcodeClick(Sender: TObject);
    procedure EditBarcodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditBarcodeChange(Sender: TObject);
    procedure ButtonFotoConnectClick(Sender: TObject);
    procedure ButtonFotoDisconnectClick(Sender: TObject);
    procedure EditBarcodeKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ActionMatchExecute(Sender: TObject);
    procedure ActionMatchUpdate(Sender: TObject);
    procedure ImageFotoProgress(Sender: TObject; Stage: TProgressStage;
      PercentDone: Byte; RedrawNow: Boolean; const R: TRect; const Msg: string);
    procedure ActionZoomInExecute(Sender: TObject);
    procedure ActionZoomInUpdate(Sender: TObject);
    procedure ActionZoomOutExecute(Sender: TObject);
    procedure ActionZoomOutUpdate(Sender: TObject);
    procedure ActionResetExecute(Sender: TObject);
    procedure ActionResetUpdate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonScannerConnectClick(Sender: TObject);
    procedure ButtonScannerDisconnectClick(Sender: TObject);
    procedure ActionCameraOnExecute(Sender: TObject);
    procedure TimerFotoTimer(Sender: TObject);
    procedure ActionCameraOnUpdate(Sender: TObject);
    procedure ImageFotoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FProviderCatalog: TBisProvider;
    FResultFrame: TBisFotomResultFrame;
    FFieldNameDateCreate: TBisFieldName;
    FChangesPresent: Boolean;
    FDisableScrolled: Boolean;

    FInputFile: String;
    FOutputFile: String;
    FOutputDir: String;
    FDataTag: String;
    FRowTag: String;
    FNameTag: String;
    FCodeTag: String;
    FBarcodeTag: String;
    FProducerTag: String;
    FOwnerTag: String;
    FCountryTag: String;
    FFileNameTag: String;
    FDateCreateTag: String;
    FUploadTag: String;
    FAutoConnectScanner: Boolean;
    FAutoDisconnectScanner: Boolean;
    FAutoConnectPhoto: Boolean;
    FAutoDisconnectPhoto: Boolean;
    FDeviceName: String;
    FImageMaxWidth: Integer;
    FImageMaxHeight: Integer;
    FImageWidth: Integer;
    FImageHeight: Integer;
    FZoomStep: Integer;
    FRadius: Integer;

    FDateCreateFormat: String;
    FTimeAfterPhoto: Integer;
    FPort: String;
    FBaudRate: TBisComPortBaudRate;
    FDataBits: TBisComPortDataBits;
    FStopBits: TBisComPortStopBits;
    FParityBits: TBisComPortParityBits;
    FNewName: String;
    FNewCode: String;
    FNewProducer: String;
    FNewCountry: String;
    FNewOwner: String;
    FDemoString: String;

    FWebProtocol: String;
    FWebHost: String;
    FWebPort: Integer;
    FWebPath: String;
    FUseProxy: Boolean;
    FProxyHost: String;
    FProxyPort: Integer;
    FProxyUser: String;
    FProxyPassword: String;
    FFormParam: String;
    FShellCommand: String;
    FSuccessString: String;
    FRunAfterLoad: Boolean;
    FDeleteAfterLoad: Boolean;
    FPhotoCount: Integer;

    FTempBitmap: TBitmap;
    FTempImage: TBisFotomMainFormImage;
    FBarcode: TfrxBarcode;
    FCanon: TBisFotomCanon;
    FScanner: TBisBarcodeScanner;

    function SearchBarcode: Boolean;
    procedure RefreshName(Provider: TBisProvider);
    procedure LoadXmlFile(FileXml: String; Provider: TBisProvider);
    procedure LoadInputFile;
    procedure LoadOutputFile;
//    procedure ProviderCatalogNewRecord(DataSet: TDataSet);
    procedure UpdateShapeBarcode;
    procedure RefreshButtonFoto;
    procedure CanonStatus(Sender: TObject; const Message: String);
    procedure CanonOpenViewFinder(Sender: TObject);
    procedure CanonCloseViewFinder(Sender: TObject);
    procedure DrawDemoString(AWidth, AHeight: Integer; ACanvas: TCanvas);
    procedure CanonDrawFrame(Sender: TObject; Graphic: TGraphic);
    procedure CanonDrawPicture(Sender: TObject; Bitmap: TBitmap);
    procedure CanonProgress(Sender: TObject; Percent: Integer);
    procedure LoadPictureFromResult;
    procedure NewProgress(Percent: Integer);
    procedure ScannerBarcode(Sender: TObject; const Barcode: String);
    procedure ScannerStatus(Sender: TObject; const Message: String);
    procedure RefreshButtonScanner;

    // IBisMainForm

    procedure ResultFrameProviderAfterScroll(DataSet: TDataSet);

    function GetOutputDir: String;
    function GetOutputFile: String;
    function GetDataTag: String;
    function GetRowTag: String;
    function GetDateCreateTag: String;
    function GetDateCreateFormat: String;
    function GetUploadTag: String;
    function GetBarcodeTag: String;
    function GetCodeTag: String;
    function GetNameTag: String;
    function GetProducerTag: String;
    function GetCountryTag: String;
    function GetOwnerTag: String;
    function GetFileNameTag: String;

    function GetSuccessString: String;
    function GetFormParam: String;
    function GetPhotoCount: Integer;
    function GetDeleteAfterLoad: Boolean;
    function GetRunAfterLoad: Boolean;
    function GetShellCommand: String;

    function GetWebProtocol: String;
    function GetWebHost: String;
    function GetWebPort: Integer;
    function GetWebPath: String;
    function GetUseProxy: Boolean;
    function GetProxyHost: String;
    function GetProxyPort: Integer;
    function GetProxyUser: String;
    function GetProxyPassword: String;
    
    function GetDisableScrolled: Boolean;
    procedure SetDisableScrolled(Value: Boolean);
    function GetChangesPresent: Boolean;
    procedure SetChangesPresent(Value: Boolean);

    procedure UpdateForm;
    procedure CameraOn;
    procedure CameraOff;

  protected
    property OutputDir: String read FOutputDir;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TBisFotomMainFormIface=class(TBisFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisFotomMainForm: TBisFotomMainForm;

var
  MainIface: TBisIface=nil;

implementation

uses StrUtils,
     BisFotomConsts, {BisXmlDocument, }BisLogger, BisUtils, BisConsts,
     BisPicture, BisCore, BisDialogs, BisFotomImagePreviewFm;

{$R *.dfm}


{ TBisFotomMainFormIface }

constructor TBisFotomMainFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisFotomMainForm;
  AutoShow:=true;
  ApplicationCreateForm:=true;
//  ShowType:=stNormal;
end;

{ TBisFotomMainFormImage }

constructor TBisFotomMainFormImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle:=ControlStyle+[csOpaque];
end;

{ TBisFotomMainForm }

constructor TBisFotomMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  MemoName.Color:=ColorControlReadOnly;
  MemoDevice.Color:=MemoName.Color;
  PanelFoto.Color:=MemoName.Color;
  ActionMatch.Enabled:=false;

  FBarcode:=TfrxBarcode.Create(Self);
  FBarcode.Typ:=bcCodeEAN13;

  FTempBitmap:=TBitmap.Create;

  FTempImage:=TBisFotomMainFormImage.Create(Self);
  FTempImage.Align:=alClient;

  FImageWidth:=320;
  FImageHeight:=240;
  FZoomStep:=1;
  FBaudRate:=br9600;

  FInputFile:=ConfigRead('InputFile',FInputFile);
  FOutputFile:=ConfigRead('OutputFile',FOutputFile);
  FOutputDir:=ExtractFileDir(FOutputFile);
  if not DirectoryExists(FOutputDir) then
    FOutputDir:=ExtractFileDir(Core.CmdLine.FileName);
  FDataTag:=ConfigRead('DataTag','DATA');
  FRowTag:=ConfigRead('RowTag','ROW');
  FNameTag:=ConfigRead('NameTag',SFieldName);
  FCodeTag:=ConfigRead('CodeTag',SFieldCode);
  FBarcodeTag:=ConfigRead('BarcodeTag',SFieldBarcode);
  FProducerTag:=ConfigRead('ProducerTag',SFieldProducer);
  FOwnerTag:=ConfigRead('OwnerTag',SFieldOwner);
  FCountryTag:=ConfigRead('CountryTag',SFieldCountry);
  FFileNameTag:=ConfigRead('FileNameTag',SFieldFileName);
  FDateCreateTag:=ConfigRead('DateCreateTag',SFieldDateCreate);
  FUploadTag:=ConfigRead('UploadTag',SFieldUpload);
  FAutoConnectScanner:=ConfigRead('AutoConnectScanner',FAutoConnectScanner);
  FAutoDisconnectScanner:=ConfigRead('AutoDisconnectScanner',FAutoDisconnectScanner);
  FAutoConnectPhoto:=ConfigRead('AutoConnectPhoto',FAutoConnectPhoto);
  FAutoDisconnectPhoto:=ConfigRead('AutoDisconnectPhoto',FAutoDisconnectPhoto);
  FDeviceName:=ConfigRead('DeviceName',FDeviceName);
  FImageMaxWidth:=ConfigRead('ImageMaxWidth',FImageMaxWidth);
  FImageMaxHeight:=ConfigRead('ImageMaxHeight',FImageMaxHeight);
  FImageWidth:=ConfigRead('ImageWidth',FImageWidth);
  FImageHeight:=ConfigRead('ImageHeight',FImageHeight);
  FZoomStep:=ConfigRead('ZoomStep',FZoomStep);
  FRadius:=ConfigRead('Radius',FRadius);

  FDateCreateFormat:=ConfigRead('DateCreateFormat',FDateCreateFormat);
  FPort:=ConfigRead('Port',FPort);
  FBaudRate:=ConfigRead('BaudRate',FBaudRate);
  FDataBits:=ConfigRead('DataBits',FDataBits);
  FStopBits:=ConfigRead('StopBits',FStopBits);
  FParityBits:=ConfigRead('ParityBits',FParityBits);
  FTimeAfterPhoto:=ConfigRead('TimeAfterPhoto',FTimeAfterPhoto);
  FNewName:=ConfigRead('NewName',FNewName);
  FNewCode:=ConfigRead('NewCode',FNewCode);
  FNewProducer:=ConfigRead('NewProducer',FNewProducer);
  FNewCountry:=ConfigRead('NewCountry',FNewCountry);
  FNewOwner:=ConfigRead('NewOwner',FNewOwner);
  Caption:=ConfigRead('Caption',Caption);

  FDemoString:='';
  Core.LocalBase.ReadParam('DemoString',FDemoString);

  FWebProtocol:=ConfigRead('WebProtocol',FWebProtocol);
  FWebHost:=ConfigRead('WebHost',FWebHost);
  FWebPort:=ConfigRead('WebPort',FWebPort);
  FWebPath:=ConfigRead('WebPath',FWebPath);
  FUseProxy:=ConfigRead('UseProxy',FUseProxy);
  FProxyHost:=ConfigRead('ProxyHost',FProxyHost);
  FProxyPort:=ConfigRead('ProxyPort',FProxyPort);
  FProxyUser:=ConfigRead('ProxyUser',FProxyUser);
  FProxyPassword:=ConfigRead('ProxyPassword',FProxyPassword);
  FFormParam:=ConfigRead('FormParam',FFormParam);
  FShellCommand:=ConfigRead('ShellCommand',FShellCommand);
  FSuccessString:=ConfigRead('SuccessString',FSuccessString);
  FRunAfterLoad:=ConfigRead('RunAfterLoad',FRunAfterLoad);
  FDeleteAfterLoad:=ConfigRead('DeleteAfterLoad',FDeleteAfterLoad);
  FPhotoCount:=ConfigRead('PhotoCount',FPhotoCount);

  TimerFoto.Interval:=FTimeAfterPhoto;

  FProviderCatalog:=TBisProvider.Create(Self);
  with FProviderCatalog do begin
    FieldDefs.Add(SFieldID,ftString,32);
    FieldDefs.Add(SFieldBarcode,ftString,100);
    FieldDefs.Add(SFieldCode,ftString,100);
    FieldDefs.Add(SFieldName,ftString,250);
    FieldDefs.Add(SFieldProducer,ftString,100);
    FieldDefs.Add(SFieldCountry,ftString,100);
    FieldDefs.Add(SFieldOwner,ftString,100);
    CreateTable;
//    OnNewRecord:=ProviderCatalogNewRecord;
  end;

  FResultFrame:=TBisFotomResultFrame.Create(Self);
  with FResultFrame do begin
    MainForm:=Self;
    Parent:=PanelResult;
    Align:=alClient;
    with Provider.FieldNames do begin
      AddKey(SFieldID);
      AddInvisible(SFieldOwner);
      FFieldNameDateCreate:=Add(SFieldDateCreate,'���� ��������',110);
      Add(SFieldBarcode,'�����-���',90);
      Add(SFieldCode,'���',110);
      Add(SFieldName,'������������',150);
      Add(SFieldFileName,'���� �����������',230);
      AddCheckBox(SFieldUpload,'��������',30);
    end;
    Provider.CreateStructure(FProviderCatalog);
    with Provider.FieldDefs do begin
      Add(SFieldDateCreate,ftDateTime);
      Add(SFieldFileName,ftString,250);
      Add(SFieldUpload,ftInteger);
    end;
    Provider.CreateTable;
    TDateTimeField(Provider.FieldByName(SFieldDateCreate)).DisplayFormat:=FDateCreateFormat;
    Provider.AfterScroll:=ResultFrameProviderAfterScroll;

    Init;
  end;


  FCanon:=TBisFotomCanon.Create(Self);
  FCanon.DeviceName:=FDeviceName;
  FCanon.ImageWidth:=FImageWidth;
  FCanon.ImageHeight:=FImageHeight;
  FCanon.ZoomStep:=FZoomStep;
  FCanon.OnStatus:=CanonStatus;
  FCanon.OnOpenViewFinder:=CanonOpenViewFinder;
  FCanon.OnCloseViewFinder:=CanonCloseViewFinder;
  FCanon.OnDrawFrame:=CanonDrawFrame;
  FCanon.OnDrawPicture:=CanonDrawPicture;
  FCanon.OnProgress:=CanonProgress;

  FScanner:=TBisBarcodeScanner.Create(Self);
  FScanner.BarCodeSize:=EditBarcode.MaxLength;
  FScanner.Port:=FPort;
  FScanner.BaudRate:=FBaudRate;
  FScanner.StopBits:=FStopBits;
  FScanner.DataBits:=FDataBits;
  FScanner.ParityBits:=FParityBits;
  FScanner.OnBarcode:=ScannerBarcode;
  FScanner.OnStatus:=ScannerStatus;

  UpdateShapeBarcode;

  LoadInputFile;
  LoadOutputFile;

  if FAutoConnectScanner then
    ButtonScannerConnect.Click;

  if FAutoConnectPhoto then begin
    ButtonFotoConnect.Click;
    if not ActionCameraOn.Checked then
      LoadPictureFromResult;
  end else
   LoadPictureFromResult;

end;

destructor TBisFotomMainForm.Destroy;
begin
  if FAutoDisconnectScanner then
    FScanner.Disconnect;
  FScanner.Free;
  if FAutoDisconnectPhoto then
    FCanon.Disconnect;
  FCanon.Free;
  FResultFrame.Free;
  FProviderCatalog.Free;
  FTempImage.Free;
  FTempBitmap.Free;
  FBarcode.Free;
  inherited Destroy;
end;

function TBisFotomMainForm.GetBarcodeTag: String;
begin
  Result:=FBarcodeTag;
end;

function TBisFotomMainForm.GetChangesPresent: Boolean;
begin
  Result:=FChangesPresent;
end;

function TBisFotomMainForm.GetCodeTag: String;
begin
  Result:=FCodeTag;
end;

function TBisFotomMainForm.GetCountryTag: String;
begin
  Result:=FCountryTag;
end;

function TBisFotomMainForm.GetDataTag: String;
begin
  Result:=FDataTag;
end;

function TBisFotomMainForm.GetDateCreateFormat: String;
begin
  Result:=FDateCreateFormat;
end;

function TBisFotomMainForm.GetDateCreateTag: String;
begin
  Result:=FDateCreateTag;
end;

function TBisFotomMainForm.GetDeleteAfterLoad: Boolean;
begin
  Result:=FDeleteAfterLoad;
end;

function TBisFotomMainForm.GetDisableScrolled: Boolean;
begin
  Result:=FDisableScrolled;
end;

function TBisFotomMainForm.GetFileNameTag: String;
begin
  Result:=FFileNameTag;
end;

function TBisFotomMainForm.GetFormParam: String;
begin
  Result:=FFormParam;
end;

function TBisFotomMainForm.GetPhotoCount: Integer;
begin
  Result:=FPhotoCount;
end;

function TBisFotomMainForm.GetNameTag: String;
begin
  Result:=FNameTag;
end;

function TBisFotomMainForm.GetOutputDir: String;
begin
  Result:=FOutputDir;
end;

function TBisFotomMainForm.GetOutputFile: String;
begin
  Result:=FOutputFile;
end;

function TBisFotomMainForm.GetOwnerTag: String;
begin
  Result:=FOwnerTag;
end;

function TBisFotomMainForm.GetProducerTag: String;
begin
  Result:=FProducerTag;
end;

function TBisFotomMainForm.GetProxyHost: String;
begin
  Result:=FProxyHost;
end;

function TBisFotomMainForm.GetProxyPassword: String;
begin
  Result:=FProxyPassword;
end;

function TBisFotomMainForm.GetProxyPort: Integer;
begin
  Result:=FProxyPort;
end;

function TBisFotomMainForm.GetProxyUser: String;
begin
  Result:=FProxyUser;
end;

function TBisFotomMainForm.GetRowTag: String;
begin
  Result:=FRowTag;
end;

function TBisFotomMainForm.GetRunAfterLoad: Boolean;
begin
  Result:=FRunAfterLoad;
end;

function TBisFotomMainForm.GetUploadTag: String;
begin
  Result:=FUploadTag;
end;

function TBisFotomMainForm.GetUseProxy: Boolean;
begin
  Result:=FUseProxy;
end;

function TBisFotomMainForm.GetWebHost: String;
begin
  Result:=FWebHost;
end;

function TBisFotomMainForm.GetWebPath: String;
begin
  Result:=FWebPath;
end;

function TBisFotomMainForm.GetWebPort: Integer;
begin
  Result:=FWebPort;
end;

function TBisFotomMainForm.GetWebProtocol: String;
begin
  Result:=FWebProtocol;
end;

function TBisFotomMainForm.GetShellCommand: String;
begin
  Result:=FShellCommand;
end;

function TBisFotomMainForm.GetSuccessString: String;
begin
  Result:=FSuccessString;
end;

procedure TBisFotomMainForm.SetChangesPresent(Value: Boolean);
begin
  FChangesPresent:=Value;
end;

procedure TBisFotomMainForm.SetDisableScrolled(Value: Boolean);
begin
  FDisableScrolled:=Value;
end;

procedure TBisFotomMainForm.ResultFrameProviderAfterScroll(DataSet: TDataSet);
begin
  if not FDisableScrolled then begin
    RefreshName(FResultFrame.Provider);
    UpdateShapeBarcode;
    LoadPictureFromResult;
  end;
end;

procedure TBisFotomMainForm.EditBarcodeChange(Sender: TObject);
begin
  MemoName.Clear;
  UpdateShapeBarcode;
end;

procedure TBisFotomMainForm.EditBarcodeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=VK_RETURN) then begin
    MemoName.Clear;
    UpdateShapeBarcode;
    if SearchBarcode then begin
      RefreshName(FProviderCatalog);
      ActionMatch.Execute;
    end else begin
      ShowWarning(Format('������ �� �����-���� %s �� ������.',[EditBarcode.Text]));
    end;
  end;
end;

procedure TBisFotomMainForm.EditBarcodeKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  MemoName.Clear;
  UpdateShapeBarcode;
  if SearchBarcode then
    RefreshName(FProviderCatalog);
end;

procedure TBisFotomMainForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  Ret: Integer;
begin
  if FChangesPresent then begin
    Ret:=ShowQuestionCancel('����� � ����������� ����������?');
    case Ret of
      mrYes: begin
        Update;
        FResultFrame.ExportRecords;
      end;
      mrNo: ;
      mrCancel: Action:=caNone;
    end;
  end;
end;

procedure TBisFotomMainForm.FormShow(Sender: TObject);
begin
  MemoDevice.HandleNeeded;
  if MemoDevice.HandleAllocated and MemoDevice.Visible then
    SendMessage(MemoDevice.Handle,EM_LINESCROLL,0,MemoDevice.Lines.Count-1);

end;

procedure TBisFotomMainForm.ImageFotoClick(Sender: TObject);
var
  FileName: String;
  AForm: TBisFotomImagePreviewForm;
begin
  if FResultFrame.Provider.Active and not FResultFrame.Provider.IsEmpty then begin
    FileName:=FResultFrame.Provider.FieldByName(SFieldFileName).AsString;
    FileName:=Format('%s%s%s',[FOutputDir,PathDelim,FileName]);
    if FileExists(FileName) then begin
      AForm:=TBisFotomImagePreviewForm.Create(nil);
      try
        AForm.Image.Picture.LoadFromFile(FileName);
        AForm.ShowModal;
      finally
        AForm.Free;
      end;
    end;
  end;
end;

procedure TBisFotomMainForm.ImageFotoProgress(Sender: TObject;
  Stage: TProgressStage; PercentDone: Byte; RedrawNow: Boolean; const R: TRect;
  const Msg: string);
begin
  case Stage of
    psStarting: NewProgress(0);
    psRunning: NewProgress(PercentDone);
    psEnding: NewProgress(0);
  end;
end;

procedure TBisFotomMainForm.RefreshName(Provider: TBisProvider);
var
  Flag: Boolean;
begin
  MemoName.Clear;
  if Provider.Active and not Provider.IsEmpty then begin
    Flag:=true;
    if Provider=FProviderCatalog then
      Flag:=FProviderCatalog.Locate(SFieldBarcode,Trim(EditBarcode.Text),[loCaseInsensitive])
    else begin
      EditBarcode.OnChange:=nil;
      try
        EditBarcode.Text:='';
        EditBarcode.Text:=Provider.FieldByName(SFieldBarCode).AsString;
      finally
        EditBarcode.OnChange:=EditBarcodeChange;
      end;
    end;

    if Flag then begin
      MemoName.Lines.Add(Format('���: %s',[Provider.FieldByName(SFieldCode).AsString]));
      MemoName.Lines.Add(Format('������������: %s',[Provider.FieldByName(SFieldName).AsString]));
      MemoName.Lines.Add(Format('�������������: %s',[Provider.FieldByName(SFieldProducer).AsString]));
      MemoName.Lines.Add(Format('������: %s',[Provider.FieldByName(SFieldCountry).AsString]));
    end;
  end;
end;

procedure TBisFotomMainForm.ScannerBarcode(Sender: TObject; const Barcode: String);
begin
  if EditBarcode.Enabled then begin
    EditBarcode.Text:=Barcode;
    EditBarcode.SetFocus;
    EditBarcode.SelStart:=Length(Barcode);
    MemoName.Clear;
    UpdateShapeBarcode;
    if SearchBarcode then begin
      RefreshName(FProviderCatalog);
    end else begin
      ShowWarning(Format('������ �� �����-���� %s �� ������.',[EditBarcode.Text]));
    end;
  end;
end;

function TBisFotomMainForm.SearchBarcode: Boolean;
var
  OldFilter: String;
  OldFiltered: Boolean;
begin
  Result:=false;
  if (Trim(EditBarcode.Text)<>'') and FProviderCatalog.Active then begin
    OldFilter:=FProviderCatalog.Filter;
    OldFiltered:=FProviderCatalog.Filtered;
    try
      FProviderCatalog.Filter:=Format('%s=%s',[SFieldBarcode,QuotedStr(Trim(EditBarcode.Text))]);
      FProviderCatalog.Filtered:=true;
      Result:=FProviderCatalog.RecordCount>0;
    finally
      FProviderCatalog.Filter:=OldFilter;
      FProviderCatalog.Filtered:=OldFiltered;
    end;
  end;
end;

procedure TBisFotomMainForm.UpdateForm;
begin
  Update;
end;

procedure TBisFotomMainForm.UpdateShapeBarcode;
var
  dL: Integer;
  Barcode: String;
  S: String;
begin
  try
    Barcode:=Trim(EditBarcode.Text);
    if Barcode='' then begin
      ImageBarcode.Visible:=false;
    end else begin
      ImageBarcode.Visible:=true;
      dL:=EditBarcode.MaxLength-Length(Barcode);
      S:=Barcode+DupeString('0',dL);
      FBarcode.Text:=S;
      FBarcode.DrawBarcode(ImageBarcode.Canvas,Rect(15,3,140,ImageBarcode.Height),true);
    end;
  except
  end;
end;

procedure TBisFotomMainForm.ButtonBarcodeClick(Sender: TObject);
var
  Form: TBisFotomCatalogForm;
  OldActive: Boolean;
begin
  Form:=TBisFotomCatalogForm.Create(nil);
  OldActive:=ActionCameraOn.Checked;
  if OldActive then begin
    if Assigned(ImageFoto.Picture.Graphic) then begin
      ImageFoto.Picture.Graphic.Assign(FTempBitmap);
      ImageFoto.Visible:=true;
    end;
  end;
  FCanon.OnDrawFrame:=nil;
  FScanner.OnBarcode:=nil;
  try
    Form.Init;
    Form.DataFrame.Provider.ParentDataSet:=FProviderCatalog;
    Form.LocateFields:=SFieldBarcode;
    Form.LocateValues:=Trim(EditBarcode.Text);
    if Form.ShowModal=mrOk then begin
      with Form.DataFrame do begin
        if Provider.Active and not Provider.IsEmpty then begin
          EditBarcode.Text:=Provider.FieldByName(SFieldBarcode).AsString;
          MemoName.Clear;
          UpdateShapeBarcode;
          if SearchBarcode then
            RefreshName(FProviderCatalog);
        end;
      end;
      EditBarcode.SetFocus;
      EditBarcode.SelStart:=Length(EditBarcode.Text);
    end;
  finally
    FScanner.OnBarcode:=ScannerBarcode;
    FCanon.OnDrawFrame:=CanonDrawFrame;
    if OldActive then begin
      ImageFoto.Visible:=false;
    end;
    Form.Free;
  end;
end;

procedure TBisFotomMainForm.LoadXmlFile(FileXml: String; Provider: TBisProvider);
{var
  Xml: TBisXmlDocument;
  i,j: Integer;
  Node, Item, Item2: TBisXmlDocumentNode;
  Field: TField;}
begin
{  if FileExists(FileXml) then begin
    Provider.BeginUpdate;
    Xml:=TBisXmlDocument.Create(nil);
    try
      try
        Xml.LoadFromFile(FileXml);
        Node:=nil;
        if not Xml.Empty then begin
          for i:=0 to Xml.Nodes.Count-1 do begin
            Item:=Xml.Nodes.Items[i];
            if AnsiSameText(Item.NodeName,FDataTag) then begin
              Node:=Item;
              break;
            end;
          end;
        end;
        if Assigned(Node) then begin
          Provider.EmptyTable;
          for i:=0 to Node.ChildNodes.Count-1 do begin
            Item:=Node.ChildNodes.Items[i];
            if AnsiSameText(Item.NodeName,FRowTag) then begin
              Provider.Append;
              Provider.FieldByName(SFieldID).Value:=GetUniqueID;
              for j:=0 to Item.ChildNodes.Count-1 do begin
                Item2:=Item.ChildNodes.Items[j];
                Field:=nil;
                if AnsiSameText(Item2.NodeName,FNameTag) then Field:=Provider.FindField(SFieldName);
                if AnsiSameText(Item2.NodeName,FCodeTag) then Field:=Provider.FindField(SFieldCode);
                if AnsiSameText(Item2.NodeName,FBarcodeTag) then Field:=Provider.FindField(SFieldBarcode);
                if AnsiSameText(Item2.NodeName,FProducerTag) then Field:=Provider.FindField(SFieldProducer);
                if AnsiSameText(Item2.NodeName,FOwnerTag) then Field:=Provider.FindField(SFieldOwner);
                if AnsiSameText(Item2.NodeName,FCountryTag) then Field:=Provider.FindField(SFieldCountry);
                if AnsiSameText(Item2.NodeName,FFileNameTag) then Field:=Provider.FindField(SFieldFileName);
                if AnsiSameText(Item2.NodeName,FDateCreateTag) then Field:=Provider.FindField(SFieldDateCreate);
                if AnsiSameText(Item2.NodeName,FUploadTag) then Field:=Provider.FindField(SFieldUpload);

                if Assigned(Field) and not Item2.Empty then begin
                  try
                    Field.Value:=Item2.NodeValue;
                  except
                  end;
                end;

              end;
              Provider.Post;
            end;
          end;
        end;
      except
        on E: Exception do
          LoggerWrite(E.Message,ltError);
      end;
    finally
      Xml.Free;
      Provider.EndUpdate;
    end;
  end;}
end;

procedure TBisFotomMainForm.LoadInputFile;
begin
  LoadXmlFile(FInputFile,FProviderCatalog);
end;

procedure TBisFotomMainForm.LoadOutputFile;
begin
  FResultFrame.Provider.AfterScroll:=nil;
  try
    LoadXmlFile(FOutputFile,FResultFrame.Provider);
    FResultFrame.DoUpdateCounters;
    FResultFrame.Grid.OrderByFieldName(FFieldNameDateCreate,otDesc);
    FChangesPresent:=false;
  finally
    FResultFrame.Provider.AfterScroll:=ResultFrameProviderAfterScroll;
  end;
end;

procedure TBisFotomMainForm.RefreshButtonFoto;
begin
  ActionCameraOn.Checked:=FCanon.Connected;
  ButtonFotoConnect.Enabled:=FCanon.CanConnect;
  LabelFoto.Enabled:=FCanon.CanConnect;
  LabelFoto.Font.Color:=iff(FCanon.Connected,clRed,clWindowText);
  if not FCanon.Connected then begin
    ButtonFotoConnect.Caption:='���������';
    ButtonFotoConnect.Hint:='��������� � �������������';
    ButtonFotoConnect.OnClick:=ButtonFotoConnectClick;
  end else begin
    ButtonFotoConnect.Caption:='���������';
    ButtonFotoConnect.Hint:='��������� ���������� � �������������';
    ButtonFotoConnect.OnClick:=ButtonFotoDisconnectClick;
  end;
end;

procedure TBisFotomMainForm.RefreshButtonScanner;
begin
  ButtonScannerConnect.Enabled:=true;
  LabelScanner.Enabled:=true;
  LabelScanner.Font.Color:=iff(FScanner.Connected,clRed,clWindowText);
  if not FScanner.Connected then begin
    ButtonScannerConnect.Caption:='���������';
    ButtonScannerConnect.Hint:='��������� �� ��������';
    ButtonScannerConnect.OnClick:=ButtonScannerConnectClick;
  end else begin
    ButtonScannerConnect.Caption:='���������';
    ButtonScannerConnect.Hint:='��������� ���������� �� ��������';
    ButtonScannerConnect.OnClick:=ButtonScannerDisconnectClick;
  end;
end;

procedure TBisFotomMainForm.ButtonFotoConnectClick(Sender: TObject);
var
  OldCursor: TCursor;
begin
  OldCursor:=Screen.Cursor;
  Screen.Cursor:=crHourGlass;
  try
    FCanon.Connect;
    RefreshButtonFoto;
  finally
    Screen.Cursor:=OldCursor;
  end;
end;

procedure TBisFotomMainForm.ButtonScannerConnectClick(Sender: TObject);
var
  OldCursor: TCursor;
begin
  OldCursor:=Screen.Cursor;
  Screen.Cursor:=crHourGlass;
  try
    FScanner.Connect;
    RefreshButtonScanner;
  finally
    Screen.Cursor:=OldCursor;
  end;
end;

procedure TBisFotomMainForm.ButtonScannerDisconnectClick(Sender: TObject);
var
  OldCursor: TCursor;
begin
  OldCursor:=Screen.Cursor;
  Screen.Cursor:=crHourGlass;
  try
    FScanner.Disconnect;
    RefreshButtonScanner;
  finally
    Screen.Cursor:=OldCursor;
  end;
end;

procedure TBisFotomMainForm.ButtonFotoDisconnectClick(Sender: TObject);
var
  OldCursor: TCursor;
begin
  OldCursor:=Screen.Cursor;
  Screen.Cursor:=crHourGlass;
  try
    FCanon.Disconnect;
    RefreshButtonFoto;
  finally
    Screen.Cursor:=OldCursor;
  end;
end;

procedure TBisFotomMainForm.CameraOff;
begin
  ActionCameraOn.Checked:=true;
  ActionCameraOn.Execute;
end;

procedure TBisFotomMainForm.CameraOn;
begin
  ActionCameraOn.Checked:=false;
  ActionCameraOn.Execute;
end;

procedure TBisFotomMainForm.CanonCloseViewFinder(Sender: TObject);
begin
  FTempImage.Visible:=false;
  FTempImage.Parent:=nil;
  if Assigned(ImageFoto.Picture.Graphic) and not ImageFoto.Picture.Graphic.Empty then begin
    ImageFoto.Picture.Graphic.Assign(FTempBitmap);
    ImageFoto.Visible:=true;
  end else
    ImageFoto.Visible:=FResultFrame.Provider.Active and not FResultFrame.Provider.IsEmpty;
  LoadPictureFromResult;
end;

procedure TBisFotomMainForm.CanonOpenViewFinder(Sender: TObject);
begin
  ImageFoto.Visible:=false;
  PanelFoto.Update;
  FTempImage.Parent:=PanelFoto;
  FTempImage.Visible:=FCanon.Connected and FCanon.ViewFinderVisible;
end;

procedure TBisFotomMainForm.NewProgress(Percent: Integer);
begin
  ProgressBarFoto.Position:=Percent;
  ProgressBarFoto.Update;
end;

procedure TBisFotomMainForm.CanonProgress(Sender: TObject; Percent: Integer);
begin
  NewProgress(Percent);
end;

procedure TBisFotomMainForm.ScannerStatus(Sender: TObject; const Message: String);
begin
  if Trim(Message)<>'' then begin
    LoggerWrite(Format('%s: %s',['������',Message]),ltInformation);
    MemoDevice.Lines.Add(Format('%s %s: %s',[TimeToStr(Time),'������',Message]));
    MemoDevice.SelStart:=Length(MemoDevice.Text);
    MemoDevice.SelLength:=0;
    RefreshButtonScanner;
  end;
end;

procedure TBisFotomMainForm.CanonStatus(Sender: TObject; const Message: String);
begin
  if Trim(Message)<>'' then begin
    LoggerWrite(Format('%s: %s',['�����������',Message]),ltInformation);
    MemoDevice.Lines.Add(Format('%s %s: %s',[TimeToStr(Time),'�����������',Message]));
    MemoDevice.SelStart:=Length(MemoDevice.Text);
    MemoDevice.SelLength:=0;
    RefreshButtonFoto;
  end;
end;

procedure TBisFotomMainForm.DrawDemoString(AWidth, AHeight: Integer; ACanvas: TCanvas);
var
  X1,Y1,W1,H1: Integer;
begin
  if Trim(FDemoString)<>'' then begin
    ACanvas.Font.Size:=AHeight div 5;

    W1:=ACanvas.TextWidth(FDemoString);
    H1:=ACanvas.TextHeight(FDemoString);
    X1:=AWidth div 2 - W1 div 2;
    Y1:=AHeight div 2 - H1 div 2;

    ACanvas.Font.Name:=Font.Name;
    ACanvas.Brush.Style:=bsClear;
    ACanvas.Font.Color:=clBlack;
    ACanvas.TextOut(X1+2,Y1+2,FDemoString);
    ACanvas.Font.Color:=clLime;
    ACanvas.TextOut(X1,Y1,FDemoString);
  end;
end;

procedure TBisFotomMainForm.CanonDrawFrame(Sender: TObject; Graphic: TGraphic);
var
  X,Y,W,H: Integer;
  X1,Y1: Integer;
  Ration: Extended;
  OldBrush: TBrush;
  OldPen: TPen;
  RX1, RY1: Extended;
  FSightWidth, FSightHeight: Integer;
//  pt: TPoint;
begin
  if FTempImage.Visible and Assigned(FTempImage.Parent) and
     Assigned(Graphic) and not Graphic.Empty and
     (Graphic.Width<>0) and (Graphic.Height<>0) and
     (FImageWidth>0) and (FImageHeight>0) then begin

    RX1:=FImageMaxWidth/Graphic.Width;
    RY1:=FImageMaxHeight/Graphic.Height;

    FSightWidth:=Round(FImageWidth/RX1);
    FSightHeight:=Round(FImageHeight/RY1);

    FCanon.RatioX:=Graphic.Width/FSightWidth;
    FCanon.RatioY:=Graphic.Height/FSightHeight;

    OldBrush:=TBrush.Create;
    OldPen:=TPen.Create;
    try
      OldBrush.Assign(FTempBitmap.Canvas.Brush);
      OldPen.Assign(FTempBitmap.Canvas.Pen);

      Ration:=Graphic.Width/Graphic.Height;
      H:=PanelFoto.ClientHeight;
      W:=Round(H*Ration);
      X:=PanelFoto.ClientWidth div 2 - W div 2;
      Y:=PanelFoto.ClientHeight div 2 - H div 2;

      FTempBitmap.Width:=W;
      FTempBitmap.Height:=H;
      FTempBitmap.Canvas.Brush.Color:=MemoName.Color;
      FTempBitmap.Canvas.FillRect(Rect(0,0,W,H));
      FTempBitmap.Canvas.StretchDraw(Rect(0,0,W,H),Graphic);

      RX1:=FTempBitmap.Width/Graphic.Width;
      X1:=Round(FTempBitmap.Width/2 - FSightWidth/2 * RX1);

      RY1:=FTempBitmap.Height/Graphic.Height;
      Y1:=Round(FTempBitmap.Height/2 - FSightHeight/2 * RY1);

      FTempBitmap.Canvas.Brush.Style:=bsClear;
      FTempBitmap.Canvas.Pen.Color:=clLime;

{      GetCursorPos(pt);
      pt:=PanelFoto.ScreenToClient(pt);
      X1:=pt.X;
      Y1:=pt.Y;}
      FTempBitmap.Canvas.Rectangle(X1,Y1,X1+Round(FSightWidth*RX1),Y1+Round(FSightHeight*RY1));
      FTempBitmap.Canvas.Pen.Color:=clRed;
      FTempBitmap.Canvas.Ellipse(Round(FTempBitmap.Width/2 - FRadius),Round(FTempBitmap.Height/2 - FRadius),
                                 Round(FTempBitmap.Width/2 + FRadius),Round(FTempBitmap.Height/2 + FRadius));

      FTempBitmap.Canvas.MoveTo(Round(FTempBitmap.Width/2 - FRadius*1.5),Round(FTempBitmap.Height/2));
      FTempBitmap.Canvas.LineTo(Round(FTempBitmap.Width/2 + FRadius*1.5),Round(FTempBitmap.Height/2));

      FTempBitmap.Canvas.MoveTo(Round(FTempBitmap.Width/2),Round(FTempBitmap.Height/2 - FRadius*1.5));
      FTempBitmap.Canvas.LineTo(Round(FTempBitmap.Width/2),Round(FTempBitmap.Height/2 + FRadius*1.5));

      DrawDemoString(PanelFoto.ClientWidth,PanelFoto.ClientHeight,FTempBitmap.Canvas);

      FTempImage.Canvas.Draw(X,Y,FTempBitmap);
    finally
      FTempBitmap.Canvas.Pen.Assign(OldPen);
      OldPen.Free;
      FTempBitmap.Canvas.Brush.Assign(OldBrush);
      OldBrush.Free;
    end;
  end;
end;

procedure TBisFotomMainForm.CanonDrawPicture(Sender: TObject; Bitmap: TBitmap);
begin
  DrawDemoString(Bitmap.Width,Bitmap.Height,Bitmap.Canvas);
end;

procedure TBisFotomMainForm.ActionMatchUpdate(Sender: TObject);
begin
  ActionMatch.Enabled:=(Length(Trim(EditBarcode.Text))=EditBarcode.MaxLength) and
                        not FTempBitmap.Empty and ActionCameraOn.Checked and
                        FCanon.ViewFinderVisible;
end;

procedure TBisFotomMainForm.ActionCameraOnExecute(Sender: TObject);
begin
  ActionCameraOn.Checked:=not ActionCameraOn.Checked;
  if ActionCameraOn.Checked then begin
    CanonOpenViewFinder(nil);
  end else begin
    CanonCloseViewFinder(nil);
  end;
end;

procedure TBisFotomMainForm.TimerFotoTimer(Sender: TObject);
begin
  TimerFoto.Enabled:=false;
  EditBarcode.Enabled:=true;
  ButtonBarcode.Enabled:=true;
  FResultFrame.Enabled:=true;
  ActionCameraOn.Checked:=false;
  ActionCameraOn.Execute;
end;

procedure TBisFotomMainForm.ActionCameraOnUpdate(Sender: TObject);
begin
  ActionCameraOn.Enabled:=not TimerFoto.Enabled;
end;

procedure TBisFotomMainForm.ActionMatchExecute(Sender: TObject);
var
  FileName: String;
  ID: String;
  OldCursor: TCursor;
  Flag: Boolean;
begin
  OldCursor:=Screen.Cursor;
  Screen.Cursor:=crHourGlass;
  try
    with FResultFrame do begin
      if FProviderCatalog.Active and Provider.Active then begin
        Flag:=FProviderCatalog.Locate(SFieldBarcode,Trim(EditBarcode.Text),[loCaseInsensitive]);
        Provider.AfterScroll:=nil;
        FTempImage.Visible:=false;
        try
          ID:=GetUniqueID;
          FileName:=Format('%s%s%s.jpg',[FOutputDir,PathDelim,ID]);
          if FCanon.TakePicture(FileName) and FileExists(FileName) then begin
            Provider.Append;
            if Flag then begin
              Provider.CopyRecord(FProviderCatalog,false,false);
            end else begin
              Provider.FieldByName(SFieldBarcode).AsString:=Trim(EditBarcode.Text);
              Provider.FieldByName(SFieldCode).AsString:=FNewCode;
              Provider.FieldByName(SFieldName).AsString:=FNewName;
              Provider.FieldByName(SFieldProducer).AsString:=FNewProducer;
              Provider.FieldByName(SFieldCountry).AsString:=FNewCountry;
              Provider.FieldByName(SFieldOwner).AsString:=FNewOwner;
            end;
            Provider.FieldByName(SFieldID).AsString:=ID;
            Provider.FieldByName(SFieldDateCreate).AsDateTime:=Now;
            Provider.FieldByName(SFieldFileName).AsString:=ExtractFileName(FileName);
            Provider.FieldByName(SFieldUpload).AsInteger:=Integer(false);
            Provider.Post;
            DoUpdateCounters;
            FChangesPresent:=true;
            EditBarcode.Enabled:=false;
            ButtonBarcode.Enabled:=false;
            FResultFrame.Enabled:=false;
            FResultFrame.ExportRecords;
            ActionCameraOn.Checked:=true;
            ActionCameraOn.Execute;
            TimerFoto.Enabled:=true;
          end;
        finally
          FResultFrame.Grid.OrderByFieldName(FFieldNameDateCreate,otDesc);
          Provider.AfterScroll:=ResultFrameProviderAfterScroll;
        end;
      end;
    end;
  finally
    Screen.Cursor:=OldCursor;
  end;
end;

procedure TBisFotomMainForm.LoadPictureFromResult;
var
  FileName: String;
  OldCursor: TCursor;
begin
  if ImageFoto.Visible then begin
    if FResultFrame.Provider.Active and not FResultFrame.Provider.IsEmpty then begin
      FileName:=FResultFrame.Provider.FieldByName(SFieldFileName).AsString;
      FileName:=Format('%s%s%s',[FOutputDir,PathDelim,FileName]);
      if FileExists(FileName) then begin
        OldCursor:=Screen.Cursor;
        Screen.Cursor:=crHourGlass;
        try
          try
            ImageFoto.Picture.LoadFromFile(FileName);
          except
          end;
        finally
          Screen.Cursor:=OldCursor;
        end;
      end else
        ImageFoto.Picture.Assign(nil);
    end else
      ImageFoto.Picture.Assign(nil);
  end
end;

procedure TBisFotomMainForm.ActionZoomInExecute(Sender: TObject);
var
  OldCursor: TCursor;
begin
  OldCursor:=Screen.Cursor;
  Screen.Cursor:=crHourGlass;
  try
    FCanon.ZoomIn;
  finally
    Screen.Cursor:=OldCursor;
  end;
end;

procedure TBisFotomMainForm.ActionZoomInUpdate(Sender: TObject);
begin
  ActionZoomIn.Enabled:=not FTempBitmap.Empty and
                        FCanon.ViewFinderVisible and
                        ActionCameraOn.Checked;
end;

procedure TBisFotomMainForm.ActionZoomOutExecute(Sender: TObject);
var
  OldCursor: TCursor;
begin
  OldCursor:=Screen.Cursor;
  Screen.Cursor:=crHourGlass;
  try
    FCanon.ZoomOut;
  finally
    Screen.Cursor:=OldCursor;
  end;
end;

procedure TBisFotomMainForm.ActionZoomOutUpdate(Sender: TObject);
begin
  ActionZoomOut.Enabled:=not FTempBitmap.Empty and
                         FCanon.ViewFinderVisible and
                         ActionCameraOn.Checked;

end;

procedure TBisFotomMainForm.ActionResetExecute(Sender: TObject);
var
  OldCursor: TCursor;
begin
  OldCursor:=Screen.Cursor;
  Screen.Cursor:=crHourGlass;
  try
    FCanon.Reset;
  finally
    Screen.Cursor:=OldCursor;
  end;
end;

procedure TBisFotomMainForm.ActionResetUpdate(Sender: TObject);
begin
  ActionReset.Enabled:=not FTempBitmap.Empty and
                       FCanon.ViewFinderVisible and
                       ActionCameraOn.Checked;
end;

end.