unit BisThreads;

interface

uses Classes, SysUtils, SyncObjs, Contnrs,
     BisLocks;

const
  ThreadNameAddress=$406D1388;

type
  TBisThreadNameInfo = record
    RecType: LongWord;  // Must be 0x1000
    Name: PChar;        // Pointer to name (in user address space)
    ThreadID: LongWord; // Thread ID (-1 indicates caller thread)
    Flags: LongWord;    // Reserved for future use. Must be zero
  end;
  PBisThreadNameInfo=^TBisThreadNameInfo;

  TBisThread=class;
  
  TBisThreadEvent=procedure(Thread: TBisThread) of object;
  TBisThreadErrorEvent=procedure(Thread: TBisThread; const E: Exception) of object;
  TBisThreadPriority=TThreadPriority;

  TBisThread=class(TBisCritical)
  private
    FName: String;
    FOnEnd: TBisThreadEvent;
    FOnBegin: TBisThreadEvent;
    FOnWork: TBisThreadEvent;
    FOnError: TBisThreadErrorEvent;
    FOnDestroy: TBisThreadEvent;
    FWorkPeriod: Int64;
    FWorking: Boolean;
    FThread: TThread;
    FPriority: TBisThreadPriority;
    FStopOnDestroy: Boolean;
    FDestroyed: Boolean;
    FFreeOnEnd: Boolean;

    procedure SetName(const Value: String);
    function GetTerminated: Boolean;
    function GetHandle: THandle;
    function GetThreadID: THandle;
    procedure ThreadExecute(Sender: TObject);
    procedure ThreadDestroy(Sender: TObject);
    function GetSuspended: Boolean;
  protected
    procedure Execute; virtual;
    procedure DoBegin; virtual;
    procedure DoEnd; virtual;
    procedure DoWork; virtual;
    procedure DoError(const E: Exception); virtual;
    procedure DoDestroy; virtual;

    property Destroyed: Boolean read FDestroyed;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Terminate; virtual;

    function CanStart: Boolean; virtual;
    procedure Start(Wait: Boolean=false); virtual;
    function CanPause: Boolean; virtual;
    procedure Pause; virtual;
    function CanStop: Boolean; virtual;
    procedure Stop; virtual;

    function Exists: Boolean;
    procedure Synchronize(AMethod: TThreadMethod);
    procedure Queue(AMethod: TThreadMethod);
    class procedure StaticSynchronize(AMethod: TThreadMethod);
    class procedure StaticQueue(AMethod: TThreadMethod);

    property Terminated: Boolean read GetTerminated;
    property Suspended: Boolean read GetSuspended;
    property Working: Boolean read FWorking;
    property WorkPeriod: Int64 read FWorkPeriod;
    property Handle: THandle read GetHandle;
    property ThreadID: THandle read GetThreadID;

    property Name: String read FName write SetName;
    property Priority: TBisThreadPriority read FPriority write FPriority;
    property StopOnDestroy: Boolean read FStopOnDestroy write FStopOnDestroy;
    property FreeOnEnd: Boolean read FFreeOnEnd write FFreeOnEnd; 

    property OnBegin: TBisThreadEvent read FOnBegin write FOnBegin;
    property OnEnd: TBisThreadEvent read FOnEnd write FOnEnd;
    property OnWork: TBisThreadEvent read FOnWork write FOnWork;
    property OnError: TBisThreadErrorEvent read FOnError write FOnError;
    property OnDestroy: TBisThreadEvent read FOnDestroy write FOnDestroy;   
  end;

  TBisThreads=class;

  TBisThreadsRemoveEvent=procedure (Sender: TBisThreads; Item: TBisThread) of object;

  TBisThreads=class(TBisCriticals)
  private
    FDestroying: Boolean;
    FOnItemRemove: TBisThreadsRemoveEvent;
    function GetItems(Index: Integer): TBisThread;
  protected
    procedure DoItemRemove(Item: TObject); overload; override; deprecated;
    procedure DoItemRemove(Item: TBisThread); reintroduce; overload; virtual; 
  public
    destructor Destroy; override;
    procedure Stop; virtual;

    property Items[Index: Integer]: TBisThread read GetItems; default;
    property Destroying: Boolean read FDestroying;

    property OnItemRemove: TBisThreadsRemoveEvent read FOnItemRemove write FOnItemRemove;
  end;

  TBisWaitThread=class;

  TBisWaitThreadEvent=procedure(Thread: TBisWaitThread) of object;

  TBisWaitThread=class(TBisThread)
  private
    FEvent: TEvent;
    FReset: Boolean;
    FTimeout: Cardinal;
    FCounter: Cardinal;
    FOnTimeout: TBisWaitThreadEvent;
    FRestrictByZero: Boolean;
  protected
    procedure DoWork; override;
    procedure DoTimeout; virtual;
  public
    constructor Create; overload; override;
    constructor Create(const Timeout: Cardinal); reintroduce; overload; virtual;
    destructor Destroy; override;
    procedure Terminate; override;
    procedure Stop; override;
    function CanStart: Boolean; override;
    procedure Reset; virtual;

    property Counter: Cardinal read FCounter;

    property Timeout: Cardinal read FTimeout write FTimeout;
    property RestrictByZero: Boolean read FRestrictByZero write FRestrictByZero;

    property OnTimeout: TBisWaitThreadEvent read FOnTimeout write FOnTimeout;
  end;

  TBisThreadList=class(TThreadList)
  public
    function NameByID(const ID: THandle; const Default: String=''): String;
  end;

var
  GlobalThreads: TBisThreadList=nil;
  UseThreadNames: Boolean=true;

procedure SetThreadName(AName: String);
procedure OutputThread(const S: String);

implementation

uses Windows,
     BisUtils;

var
  MainThreadName: String='Main';

type
  TBisRealThread=class(TThread)
  public
    FName: String;
    FExecuting: Boolean;
    FOnExecute: TNotifyEvent;
    FOnDestroy: TNotifyEvent;
    function WaitFor: Boolean;
  protected
    procedure DoDestroy;
    procedure DoExecute;
  public
    constructor Create(Name: String);
    destructor Destroy; override;
    procedure Execute; override;
    procedure CleanUp;
    function Exists: Boolean;
  end;

procedure ClearThreads;
var
  i: Integer;
  Item: TBisRealThread;
  List: TList;
begin
  if Assigned(GlobalThreads) then begin
    List:=GlobalThreads.LockList;
    try
      for i:=List.Count-1 downto 0 do begin
        Item:=TBisRealThread(List.Items[i]);
        if Item.Exists then
          TerminateThread(Item.Handle,0);
        List.Remove(Item);
      end;
    finally
      GlobalThreads.UnlockList;
    end;
  end;
end;

{ TBisThreadList }

function TBisThreadList.NameByID(const ID: THandle; const Default: String=''): String;
var
  List: TList;
  i: Integer;
  Item: TBisRealThread;
begin
  List:=LockList;
  try
    Result:=Default;
    if MainThreadID=ID then
      Result:=MainThreadName
    else
      for i:=0 to List.Count-1 do begin
        Item:=TBisRealThread(List.Items[i]);
        if Item.Exists and (Item.ThreadID=ID) then begin
          Result:=Item.FName;
          exit;
        end;
      end;
  finally
    UnlockList;
  end;
end;

procedure SetThreadName(AName: String);
var
  LThreadNameInfo: TBisThreadNameInfo;
begin
  if UseThreadNames and (Trim(AName)<>'') then begin
    try
      with LThreadNameInfo do begin
        RecType := $1000;
        Name := PChar(AName);
        ThreadID := $FFFFFFFF;
        Flags := 0;
      end;
      try
        // This is a wierdo Windows way to pass the info in
        RaiseException(ThreadNameAddress, 0, SizeOf(LThreadNameInfo) div SizeOf(LongWord),PDWord(@LThreadNameInfo));
      except
        //
      end;

    finally
      if GetCurrentThreadId=MainThreadID then
        MainThreadName:=AName;
    end;
  end;
end;

procedure OutputThread(const S: String);
var
  S1: String;
  ID: THandle;
begin
  ID:=GetCurrentThreadId;
  S1:=GlobalThreads.NameByID(ID,IntToStr(ID));
  Output(S1+' > '+S);
end;

{ TBisRealThread }

constructor TBisRealThread.Create(Name: String);
begin
  inherited Create(true);
  GlobalThreads.Add(Self);
  FName:=Name;
end;

destructor TBisRealThread.Destroy;
begin
  WaitFor;
  DoDestroy;
  GlobalThreads.Remove(Self);
  inherited Destroy;
end;

procedure TBisRealThread.DoDestroy;
begin
  if Assigned(FOnDestroy) then
    FOnDestroy(Self);
end;

procedure TBisRealThread.DoExecute;
begin
  if Assigned(FOnExecute) then
    FOnExecute(Self);
end;

procedure TBisRealThread.CleanUp;
begin
  FOnDestroy:=nil;
  FOnExecute:=nil;
end;

function TBisRealThread.WaitFor: Boolean;
var
  H: array[0..1] of THandle;
  WaitResult: Cardinal;
  Msg: TMsg;
  Flags: DWORD;
  TID: THandle;
begin
  Result:=false;
  if not FreeOnTerminate and GetHandleInformation(Handle,Flags) then begin
    if Suspended then
      Resume;
    H[0] := Handle;
    TID:=GetCurrentThreadId;
    if TID = MainThreadID then
    begin
      WaitResult := 0;
      H[1] := SyncEvent;
      repeat
        if WaitResult = WAIT_OBJECT_0 + 2 then
          PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE);
        WaitResult := MsgWaitForMultipleObjects(2, H, False, 1000, QS_SENDMESSAGE);
        CheckThreadError(WaitResult <> WAIT_FAILED);
        if WaitResult = WAIT_OBJECT_0 + 1 then
          CheckSynchronize;
      until WaitResult = WAIT_OBJECT_0;
    end else begin
      if (TID<>ThreadID) or ((TID=ThreadID) and not FExecuting) then
        WaitForSingleObject(H[0], INFINITE);
    end;
    Result:=true;
  end;
end;

function TBisRealThread.Exists: Boolean;
var
  Ret: DWord;
begin
  Ret:=WaitForSingleObject(Handle,0);
  Result:=Ret=WAIT_TIMEOUT;
end;

procedure TBisRealThread.Execute;
begin
  FExecuting:=true;
  try
    SetThreadName(FName);
    DoExecute;
  finally
    FExecuting:=false;
  end;
end;

{ TBisThread }

constructor TBisThread.Create;
begin
  inherited Create;
  FName:=Copy(ClassName,5,Length(ClassName)-4-Length('Thread'));
end;

destructor TBisThread.Destroy;
begin
  DoDestroy;
  FOnBegin:=nil;
  FOnWork:=nil;
  FOnEnd:=nil;
  FOnError:=nil;
  FOnDestroy:=nil;
  FFreeOnEnd:=false;
  if StopOnDestroy then
    Stop
  else
    Terminate;
  inherited Destroy;
  FDestroyed:=true;
end;

procedure TBisThread.ThreadDestroy(Sender: TObject);
begin
  if FThread=Sender then
    FThread:=nil;
end;

procedure TBisThread.ThreadExecute(Sender: TObject);
begin
  try
    Execute;
  finally
    if Assigned(Self) and not FDestroyed and FFreeOnEnd then
      Free;
  end;
end;

procedure TBisThread.DoBegin;
begin
  if Assigned(Self) and not FDestroyed and Assigned(FOnBegin) then
    FOnBegin(Self);
end;

procedure TBisThread.DoEnd;
begin
  if Assigned(Self) and not FDestroyed and Assigned(FOnEnd) then
    FOnEnd(Self);
end;

procedure TBisThread.DoWork;
begin
  if Assigned(Self) and not FDestroyed and Assigned(FOnWork) then
    FOnWork(Self);
end;

procedure TBisThread.DoError(const E: Exception);
begin
  if Assigned(Self) and not FDestroyed and Assigned(FOnError) then
    FOnError(Self,E);
end;

procedure TBisThread.DoDestroy;
begin
  if Assigned(Self) and not FDestroyed and Assigned(FOnDestroy) then
    FOnDestroy(Self);
end;

procedure TBisThread.Execute;
var
  Tick, Freq: Int64;
begin
  FWorking:=true;
  try
    try
      FWorkPeriod:=0;
      try
        DoBegin;
        try
          Tick:=GetTickCount(Freq);
          try
            DoWork;
          finally
            FWorkPeriod:=GetTickDifference(Tick,Freq,dtMilliSec);
          end;
        except
          On E: Exception do
            DoError(E);
        end;
      finally
        DoEnd;
      end;
    except
      On E: Exception do
        DoError(E);
    end;
  finally
    FWorking:=false;
  end;
end;

procedure TBisThread.SetName(const Value: String);
begin
  FName := Value;
  if Assigned(FThread) and (FThread.ThreadID=GetCurrentThreadId) then
    SetThreadName(FName);
end;

function TBisThread.CanStart: Boolean;
begin
  Result:=not Assigned(FThread) or (Assigned(FThread) and FThread.Suspended);
end;

procedure TBisThread.Start(Wait: Boolean=false);
begin
  if CanStart then begin
    if Assigned(FThread) then
      FThread.Resume
    else begin
      FThread:=TBisRealThread.Create(FName);
      TBisRealThread(FThread).FOnExecute:=ThreadExecute;
      TBisRealThread(FThread).FOnDestroy:=ThreadDestroy;
      FThread.FreeOnTerminate:=not Wait;
      FThread.Priority:=FPriority;
      FThread.Resume;
    end;
    if Wait then
      FThread.WaitFor;
  end;
end;

class procedure TBisThread.StaticQueue(AMethod: TThreadMethod);
begin
  TBisRealThread.StaticQueue(nil,AMethod);
end;

class procedure TBisThread.StaticSynchronize(AMethod: TThreadMethod);
begin
  TBisRealThread.StaticSynchronize(nil,AMethod);
end;

function TBisThread.CanStop: Boolean;
begin
  Result:=Assigned(FThread);
end;

procedure TBisThread.Stop;
begin
  if CanStop then begin
    if (GetCurrentThreadId=FThread.ThreadID) and
       TBisRealThread(FThread).FExecuting then
      Terminate
    else begin
      TBisRealThread(FThread).CleanUp;
      FThread.FreeOnTerminate:=false;
      FThread.Terminate;
      FreeAndNilEx(FThread);
    end;
  end;
end;

function TBisThread.CanPause: Boolean;
begin
  Result:=Assigned(FThread) and not FThread.Suspended;
end;

procedure TBisThread.Pause;
begin
  if CanPause then
    FThread.Suspend;
end;

procedure TBisThread.Terminate;
begin
  if Assigned(FThread) then begin
    TBisRealThread(FThread).CleanUp;
    FThread.FreeOnTerminate:=true;
    FThread.Terminate;
    FThread:=nil;
  end;
end;

function TBisThread.Exists: Boolean;
begin
  Result:=FWorking;
  if Assigned(FThread) then
    Result:=TBisRealThread(FThread).Exists;
end;

function TBisThread.GetHandle: THandle;
begin
  Result:=0;
  if Assigned(FThread) then
    Result:=FThread.Handle;
end;

function TBisThread.GetSuspended: Boolean;
{var
  Ret: DWord;   }
begin
  Result:=Assigned(FThread) and TBisRealThread(FThread).Suspended;
 { if not Result and not Terminated then begin
    Ret:=ResumeThread(FThread.Handle);
    Result:=Ret>0;
  end; }  
end;

function TBisThread.GetTerminated: Boolean;
begin
  Result:=not Assigned(FThread) or
          (Assigned(FThread) and TBisRealThread(FThread).Terminated);
end;

function TBisThread.GetThreadID: THandle;
begin
  Result:=0;
  if Assigned(FThread) then
    Result:=FThread.ThreadID;
end;

procedure TBisThread.Queue(AMethod: TThreadMethod);
begin
  if not IsMainThread then begin
    if Assigned(FThread) then
      TBisRealThread(FThread).Queue(AMethod)
    else
      TBisRealThread.Queue(nil,AMethod);
  end else
    if Assigned(AMethod) then
      AMethod;
end;

procedure TBisThread.Synchronize(AMethod: TThreadMethod);
begin
  if not IsMainThread then begin
    if Assigned(FThread) then
      TBisRealThread(FThread).Synchronize(AMethod)
    else
      TBisRealThread.Synchronize(nil,AMethod);
  end else
    if Assigned(AMethod) then
      AMethod;
end;

{ TBisThreads }

destructor TBisThreads.Destroy;
begin
  FDestroying:=true;
  inherited Destroy;
end;

procedure TBisThreads.DoItemRemove(Item: TObject);
begin
  if Assigned(Item) and (Item is TBisThread) then
    DoItemRemove(TBisThread(Item));
end;

procedure TBisThreads.DoItemRemove(Item: TBisThread);
begin
  if Assigned(FOnItemRemove) then
    FOnItemRemove(Self,Item);
end;

function TBisThreads.GetItems(Index: Integer): TBisThread;
begin
  Result:=TBisThread(inherited Items[Index]);
end;

procedure TBisThreads.Stop;
var
  i: Integer;
begin
  for i:=Count-1 downto 0 do
    Items[i].Stop;
end;

{ TBisWaitThread }

constructor TBisWaitThread.Create;
begin
  inherited Create;
  FEvent:=TEvent.Create(nil,true,false,'');
end;

constructor TBisWaitThread.Create(const Timeout: Cardinal);
begin
  Create;
  FTimeout:=Timeout;
end;

destructor TBisWaitThread.Destroy;
begin
  FOnTimeout:=nil;
  FReset:=false;
  FEvent.SetEvent;
  FreeAndNil(FEvent);
  inherited Destroy;
end;

procedure TBisWaitThread.DoTimeout;
begin
  if Assigned(Self) and not Destroyed and Assigned(FOnTimeout) then
    FOnTimeout(Self);
end;

procedure TBisWaitThread.DoWork;
var
  Ret: TWaitResult;
begin
  while Assigned(Self) and not Destroyed and
        not Terminated and Assigned(FEvent) do begin
    FReset:=false;
    FEvent.ResetEvent;
    Ret:=FEvent.WaitFor(FTimeout);
    case Ret of
      wrSignaled: begin
        if not FReset then
          break;
      end;
      wrTimeout: begin
        Inc(FCounter);
        DoTimeout;
        if not FReset then
          break;
      end
    else
      break;
    end;
  end;
end;

procedure TBisWaitThread.Reset;
begin
  if Assigned(FEvent) then begin
    FReset:=true;
    FEvent.SetEvent;
  end;
end;

procedure TBisWaitThread.Stop;
begin
  if Assigned(FEvent) then begin
    FReset:=false;
    FEvent.SetEvent;
  end;
  inherited Stop;
end;

procedure TBisWaitThread.Terminate;
begin
  if Assigned(FEvent) then begin
    FReset:=false;
    FEvent.SetEvent;
  end;
  inherited Terminate;
end;

function TBisWaitThread.CanStart: Boolean;
begin
  Result:=inherited CanStart;
  if Result and FRestrictByZero then
    Result:=FTimeout>0;
end;


initialization
  SetThreadName(MainThreadName);
  GlobalThreads:=TBisThreadList.Create;

finalization
  ClearThreads;
  FreeAndNil(GlobalThreads);


end.