unit BisDesignDataLocalitiesFrm;

interface

uses                                                                                                             
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin, StdCtrls,
  ExtCtrls, Grids, DBGrids, Contnrs,

  BisDataGridFrm, BisIfaces, BisDesignDataStreetsFm;

type

  TBisDesignDataStreetsFrameIfaces=class(TObjectList)
  public
    function FindById(LocalityId: Variant): TBisDesignDataStreetsFormIface;
  end;

  TBisDesignDataLocalitiesFrame = class(TBisDataGridFrame)
    ToolBar1: TToolBar;
    ToolButtonStreets: TToolButton;
    ActionStreets: TAction;
    N13: TMenuItem;
    MenuItemStreets: TMenuItem;
    procedure ActionStreetsExecute(Sender: TObject);
    procedure ActionStreetsUpdate(Sender: TObject);
  private
    FIfaces: TBisDesignDataStreetsFrameIfaces;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function CanStreets: Boolean;
    procedure Streets;
  end;

implementation

uses BisProvider, BisDialogs, BisUtils, BisFilterGroups;

{$R *.dfm}

{ TBisDesignDataStreetsFrameIfaces }

function TBisDesignDataStreetsFrameIfaces.FindById(LocalityId: Variant): TBisDesignDataStreetsFormIface;
var
  i: Integer;
  Obj: TObject;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Obj:=Items[i];
    if Assigned(Obj) and (Obj is TBisDesignDataStreetsFormIface) then begin
      if VarSameValue(TBisDesignDataStreetsFormIface(Obj).LocalityId,LocalityId) then begin
        Result:=TBisDesignDataStreetsFormIface(Obj);
        exit;
      end;
    end;
  end;
end;

{ TBisTaxiDataParksFrame }

constructor TBisDesignDataLocalitiesFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIfaces:=TBisDesignDataStreetsFrameIfaces.Create;
end;

destructor TBisDesignDataLocalitiesFrame.Destroy;
begin
  FIfaces.Free;
  inherited Destroy;
end;

procedure TBisDesignDataLocalitiesFrame.ActionStreetsExecute(Sender: TObject);
begin
  Streets;
end;

procedure TBisDesignDataLocalitiesFrame.ActionStreetsUpdate(Sender: TObject);
begin
  ActionStreets.Enabled:=CanStreets;
end;

function TBisDesignDataLocalitiesFrame.CanStreets: Boolean;
var
  P: TBisProvider;
  Iface: TBisDesignDataStreetsFormIface;
begin
  P:=GetCurrentProvider;
  Result:=Assigned(P) and P.Active and not P.IsEmpty;
  if Result then begin
    Iface:=TBisDesignDataStreetsFormIface.Create(Self);
    try
      Iface.Init;
      Result:=Iface.CanShow;
    finally
      Iface.Free;
    end;
  end;
end;

procedure TBisDesignDataLocalitiesFrame.Streets;
var
  Iface: TBisDesignDataStreetsFormIface;
  P: TBisProvider;
  LocalityId: Variant;
  LocalityName: String;
begin
  if CanStreets then begin
    P:=GetCurrentProvider;
    LocalityId:=P.FieldByName('LOCALITY_ID').Value;
    LocalityName:=P.FieldByName('NAME').AsString;
    Iface:=FIfaces.FindById(LocalityId);
    if not Assigned(Iface) then begin
      Iface:=TBisDesignDataStreetsFormIface.Create(Self);
      Iface.LocalityId:=LocalityId;
      Iface.LocalityName:=LocalityName;
      Iface.LocalityPrefix:=P.FieldByName('PREFIX').AsString;
      Iface.MaxFormCount:=1;
      FIfaces.Add(Iface);
      Iface.Init;
      Iface.FilterGroups.Add.Filters.Add('LOCALITY_ID',fcEqual,LocalityId);
    end;
    Iface.Caption:=FormatEx('%s => %s',[ActionStreets.Caption,LocalityName]);
    Iface.ShowType:=ShowType;
    if AsModal then
      Iface.ShowModal
    else Iface.Show;
  end;
end;

end.