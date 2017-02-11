unit BisMapFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls,
  BisFm, BisMapFrm;

type
  TBisMapForm = class(TBisForm)
    StatusBar: TStatusBar;
    PanelFrame: TPanel;
  private
    FMapFrameClass: TBisMapFrameClass;
    FMapFrame: TBisMapFrame;
  protected
    function GetMapFrameClass: TBisMapFrameClass; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    function CanShow: Boolean; override;
    procedure BeforeShow; override;

    property MapFrame: TBisMapFrame read FMapFrame;
  end;

  TBisMapFormIface=class(TBisFormIface)
  private
    FMapId: String;
    function GetLastForm: TBisMapForm;
    function CanRefreshMap(Sender: TBisMapFrame): Boolean;
  protected
    function CreateForm: TBisForm; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure BeforeFormShow; override;

    property LastForm: TBisMapForm read GetLastForm;

    property MapId: String read FMapId write FMapId;
  published
  end;

  TBisMapFormIfaceClass=class of TBisMapFormIface;

var
  BisMapForm: TBisMapForm;

implementation

{$R *.dfm}

uses BisUtils;

{ TBisMapFormIface }

constructor TBisMapFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisMapForm;
  OnlyOneForm:=false;
  ChangeFormCaption:=true;
  Permissions.Enabled:=true;
end;

destructor TBisMapFormIface.Destroy;
begin
  inherited Destroy;
end;

function TBisMapFormIface.GetLastForm: TBisMapForm;
begin
  Result:=TBisMapForm(inherited LastForm);
end;

procedure TBisMapFormIface.Init;
begin
  inherited Init;
end;

function TBisMapFormIface.CreateForm: TBisForm;
begin
  Result:=inherited CreateForm;
  if Assigned(LastForm) then begin
    with LastForm do begin
      if Assigned(MapFrame) then begin
        MapFrame.OnCanRefreshMap:=CanRefreshMap;
      end;
    end;
  end;
end;

procedure TBisMapFormIface.BeforeFormShow;
begin
  inherited BeforeFormShow;
  if Assigned(LastForm) then begin
    with LastForm do begin
      if Assigned(MapFrame) then begin
        MapFrame.MapId:=FMapId;
      end;
    end;
  end;
end;

function TBisMapFormIface.CanRefreshMap(Sender: TBisMapFrame): Boolean;
begin
  Result:=Permissions.Exists(SPermissionShow);
end;

{ TBisMapForm }

constructor TBisMapForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CloseMode:=cmFree;
  SizesStored:=true;
  FMapFrameClass:=GetMapFrameClass;
  if Assigned(FMapFrameClass) then begin
    FMapFrame:=FMapFrameClass.Create(Self);
    FMapFrame.Parent:=PanelFrame;
    FMapFrame.Align:=alClient;
  end;
end;

destructor TBisMapForm.Destroy;
begin
  FreeAndNilEx(FMapFrame);
  inherited Destroy;
end;

function TBisMapForm.GetMapFrameClass: TBisMapFrameClass;
begin
  Result:=TBisMapFrame;
end;

procedure TBisMapForm.Init;
begin
  inherited Init;
  if Assigned(FMapFrame) then
    FMapFrame.Init;
end;

function TBisMapForm.CanShow: Boolean;
begin
  Result:=inherited CanShow and
          Assigned(FMapFrame);
  if Result and not Visible then begin
    FMapFrame.OpenMap;
    Result:=FMapFrame.MapLoaded;
  end;
end;

procedure TBisMapForm.BeforeShow;
begin
  inherited BeforeShow;
{  if Assigned(FMapFrame) then begin
    FMapFrame.OpenMap;
  end;}
end;

end.