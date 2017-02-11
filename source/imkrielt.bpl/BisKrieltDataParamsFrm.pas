unit BisKrieltDataParamsFrm;

interface                                                                                                 

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin,
  ExtCtrls, Grids, DBGrids, StdCtrls, Contnrs,

  BisDataGridFrm, BisKrieltDataParamValuesFm;

type
  TBisKrieltDataParamsFrameIfaces=class(TObjectList)
  public
    function FindParamById(ParamId: Variant): TBisKrieltDataParamValuesFormIface;
  end;

  TBisKrieltDataParamsFrame = class(TBisDataGridFrame)
    ToolBar1: TToolBar;
    N18: TMenuItem;
    ToolButtonValues: TToolButton;
    ActionValues: TAction;
    MenuItemValues: TMenuItem;
    procedure ActionValuesExecute(Sender: TObject);
    procedure ActionValuesUpdate(Sender: TObject);
  private
    FIfaces: TBisKrieltDataParamsFrameIfaces;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CanValues: Boolean;
    procedure Values;
  end;

implementation

uses BisProvider, BisDialogs, BisUtils, BisKrieltDataParamEditFm, BisFilterGroups;

{$R *.dfm}

{ TBisKrieltDataParamsFrameIfaces }

function TBisKrieltDataParamsFrameIfaces.FindParamById(ParamId: Variant): TBisKrieltDataParamValuesFormIface;
var
  i: Integer;
  Obj: TObject;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Obj:=Items[i];
    if Assigned(Obj) and (Obj is TBisKrieltDataParamValuesFormIface) then begin
      if VarSameValue(TBisKrieltDataParamValuesFormIface(Obj).ParamId,ParamId) then begin
        Result:=TBisKrieltDataParamValuesFormIface(Obj);
        exit;
      end;
    end;
  end;
end;

{ TBisKrieltDataParamsFrame }

constructor TBisKrieltDataParamsFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIfaces:=TBisKrieltDataParamsFrameIfaces.Create;
end;

destructor TBisKrieltDataParamsFrame.Destroy;
begin
  FIfaces.Free;
  inherited Destroy;
end;

procedure TBisKrieltDataParamsFrame.ActionValuesExecute(Sender: TObject);
begin
  Values;
end;

procedure TBisKrieltDataParamsFrame.ActionValuesUpdate(Sender: TObject);
begin
  ActionValues.Enabled:=CanValues;
end;

function TBisKrieltDataParamsFrame.CanValues: Boolean;
var
  Iface: TBisKrieltDataParamValuesFormIface;
begin
  Result:=Provider.Active and not Provider.Empty;
  if Result then begin
    Result:=TBisKrieltDataParamType(Provider.FieldByName('PARAM_TYPE').AsInteger) in [dptList];
    if Result then begin
      Iface:=TBisKrieltDataParamValuesFormIface.Create(nil);
      try
        Iface.Init;
        Result:=Iface.CanShow;
      finally
        Iface.Free;
      end;
    end;
  end;
end;

procedure TBisKrieltDataParamsFrame.Values;
var
  Iface: TBisKrieltDataParamValuesFormIface;
  ParamId: Variant;
  ParamName: String;
begin
  if CanValues then begin
    ParamId:=Provider.FieldByName('PARAM_ID').Value;
    ParamName:=Provider.FieldByName('NAME').AsString;
    Iface:=FIfaces.FindParamById(ParamId);
    if not Assigned(Iface) then begin
      Iface:=TBisKrieltDataParamValuesFormIface.Create(Self);
      Iface.ParamId:=ParamId;
      Iface.ParamName:=ParamName;
      Iface.MaxFormCount:=1;
      Iface.FilterOnShow:=false;
      FIfaces.Add(Iface);
      Iface.Init;
      Iface.FilterGroups.Add.Filters.Add('PARAM_ID',fcEqual,ParamId);
    end;
    Iface.Caption:=FormatEx('%s => %s',[ActionValues.Hint,ParamName]);
    Iface.ShowType:=ShowType;
    if AsModal then
      Iface.ShowModal
    else Iface.Show;    
  end;
end;

end.