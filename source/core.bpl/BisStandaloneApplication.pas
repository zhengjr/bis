unit BisStandaloneApplication;

interface

uses Windows, Messages, Classes, SysUtils, Forms,
     BisApplication, BisObject, BisFm;

type
  TBisStandaloneApplicationForm=class(TBisForm)
  protected
    procedure DoShow; override;
  end;

  TBisStandaloneApplication=class(TBisApplication)
  private
    FTemp: TForm;
    FApplicationHandle: HWnd;
    FInstance: TFarProc;
    FDefWndProc: TFarProc;
    procedure WndProc(var Message: TMessage);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Init; override;
    procedure Run; override;
    procedure Terminate; override;
    procedure FreeTemp; override;
    function TempExists: Boolean; override;

  end;

implementation

uses Graphics, Types,
     BisConsts, BisExceptions, BisDialogs, BisUtils, BisCore;

{ TBisStandaloneApplicationForm }

procedure TBisStandaloneApplicationForm.DoShow;
begin
  inherited DoShow;
end;

{ TBisStandaloneApplication }

constructor TBisStandaloneApplication.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  SetProcessShutdownParameters($100,SHUTDOWN_NORETRY);
  FInstance:=MakeObjectInstance(WndProc);
end;

destructor TBisStandaloneApplication.Destroy;
begin
  FreeObjectInstance(FInstance);
  inherited Destroy;
end;

procedure TBisStandaloneApplication.Init;
begin
  Forms.Application.Initialize;
  inherited Init;
 // Forms.Application.MainFormOnTaskbar:=True; ????
  Forms.Application.CreateForm(TBisStandaloneApplicationForm,FTemp);
end;

procedure TBisStandaloneApplication.Run;
begin
  inherited Run;
  FApplicationHandle:=Forms.Application.Handle;
  try
    FDefWndProc:=Pointer(GetWindowLong(FApplicationHandle,GWL_WNDPROC));
    SetWindowLong(FApplicationHandle,GWL_WNDPROC,Longint(FInstance));
    Forms.Application.Run;
  finally
    SetWindowLong(FApplicationHandle,GWL_WNDPROC,LongInt(FDefWndProc));
  end;
end;

procedure TBisStandaloneApplication.Terminate;
begin
  Forms.Application.Terminate;
end;

procedure TBisStandaloneApplication.WndProc(var Message: TMessage);

  procedure Default;
  begin
    with Message do
      Result:=CallWindowProc(FDefWndProc,FApplicationHandle,Msg,wParam,lParam);
  end;

  procedure EndSession;
  var
    Mode:TBisApplicationExitMode;
  begin
    if TWMEndSession(Message).EndSession then begin
      Mode:=emShutdown;
      if (Cardinal(Message.lParam)=ENDSESSION_LOGOFF) then
        Mode:=emLogOff
      else if (Cardinal(Message.lParam)=ENDSESSION_DEFAULT) then
        Mode:=emDefault;
      DoExit(Mode);
      if Mode<>emDefault then
        Default
      else
        Forms.Application.Terminate;  
    end else
      Default;
  end;

  procedure QueryEndSession;
  begin
    Default;
  end;

begin
  if Assigned(FDefWndProc) then
    with Message do
      case Msg of
        WM_ENDSESSION: EndSession;
        WM_QUERYENDSESSION: QueryEndSession;
      else
        Default;
      end;
end;

procedure TBisStandaloneApplication.FreeTemp;
begin
  FreeAndNilEx(FTemp);
end;

function TBisStandaloneApplication.TempExists: Boolean;
begin
  Result:=Assigned(FTemp);
end;


end.