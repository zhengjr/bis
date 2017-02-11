unit BisHttpServerHandlerIngitMap;

interface

uses Classes,
     HTTPApp,
     BisHttpServerHandlerModules, BisHttpServerHandlers,
     BisHttpServerHandlerIngitMapWm;

type

  TBisHttpServerHandlerIngitMap=class(TBisHttpServerHandler)
  private
    FWebModule: TBisHttpServerHandlerIngitMapWebModule;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    function HandleRequest(Request: TWebRequest; Response: TWebResponse): Boolean; override;
    procedure CopyFrom(Source: TBisHttpServerHandler); override;

  end;

procedure InitHttpServerHandlerModule(AModule: TBisHttpServerHandlerModule); stdcall;

exports
  InitHttpServerHandlerModule;

implementation

uses SysUtils,
     BisCore, BisUtils, BisConsts, BisHttpServerHandlerIngitMapConsts;

procedure InitHttpServerHandlerModule(AModule: TBisHttpServerHandlerModule); stdcall;
begin
  AModule.HandlerClass:=TBisHttpServerHandlerIngitMap;
end;

{ TBisHttpServerHandlerIngitMap }

constructor TBisHttpServerHandlerIngitMap.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWebModule:=TBisHttpServerHandlerIngitMapWebModule.Create(Self);
  FWebModule.Handler:=Self;
end;

destructor TBisHttpServerHandlerIngitMap.Destroy;
begin
  FWebModule.Free;
  inherited Destroy;
end;

procedure TBisHttpServerHandlerIngitMap.Init;
var
  MapFileName: String;
begin
  inherited Init;
  MapFileName:=Params.AsString(SParamMapFileName);
  if not FMapFrame.MapLoaded then begin
    FMapFrame.LoadFromFile(MapFileName);
    FMapFrame.PrepareMap;
  end;
end;

function TBisHttpServerHandlerIngitMap.HandleRequest(Request: TWebRequest; Response: TWebResponse): Boolean;
begin
  if FWebModule is TBisHttpServerHandlerIngitMapWebModule then begin
    //

  end;
  Result:=IWebRequestHandler(FWebModule).HandleRequest(Request,Response);
end;

procedure TBisHttpServerHandlerIngitMap.CopyFrom(Source: TBisHttpServerHandler);
begin
  inherited CopyFrom(Source);
  if Assigned(Source) then begin
    //
  end;
end;

end.