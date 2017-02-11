unit MainFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisThreads, BisLocks;

type
  TMainForm = class(TForm)
    ButtonCreate: TButton;
    ButtonFree: TButton;
    ListBox: TListBox;
    ButtonCreateLots: TButton;
    Memo: TMemo;
    Timer: TTimer;
    ButtonStop: TButton;
    ButtonClear: TButton;
    CheckBoxRefresh: TCheckBox;
    ButtonRefresh: TButton;
    procedure ButtonCreateClick(Sender: TObject);
    procedure ButtonFreeClick(Sender: TObject);
    procedure ButtonCreateLotsClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure CheckBoxRefreshClick(Sender: TObject);
    procedure ButtonRefreshClick(Sender: TObject);
  private
    FThreads: TBisThreads;
    FRemoveThread: TBisWaitThread;

    procedure RefreshListbox;
    procedure ApplicationException(Sender: TObject; E: Exception);
    function GetThreadString(Thread: TBisWaitThread): String;
    function GetCriticalString(Critical: TBisCritical): String;
    function GetThreadsString(Locks: TBisLocks): String;
    procedure RemoveThreadTimeout(Thread: TBisWaitThread);
    procedure ThreadError(Thread: TBisThread; const E: Exception);
    procedure ThreadTimeout(Thread: TBisWaitThread);
    procedure ThreadEnd(Thread: TBisThread);
    procedure Log(ThreadName: String; ThreadId: Cardinal; Message: String);
    procedure ThreadLog(Thread: TBisThread; Message: String);
    procedure ThreadsItemFree(Item: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

var
  MainForm: TMainForm;

implementation

uses Math,
     BisUtils;

{$R *.dfm}

type
  TBisRemoveThread=class(TBisWaitThread)
  end;

  TBisListBoxThread=class(TBisWaitThread)
  end;

type
  TErrorObj=class(TObject)
  private
    FForm: TMainForm;
    FThreadName: String;
    FThreadId: Cardinal;
    FMessage: String;
  public
    procedure Error;
  end;

{ TErrorObj }

procedure TErrorObj.Error;
begin
  FForm.Log(FThreadName,FThreadId,FMessage);
end;
  
{ TMainForm }

constructor TMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FRemoveThread:=TBisRemoveThread.Create(1000);
  FRemoveThread.OnTimeout:=RemoveThreadTimeout;
  FRemoveThread.StopOnDestroy:=true;
  FRemoveThread.OnError:=ThreadError;
  FRemoveThread.Start;

  FThreads:=TBisThreads.Create;
  FThreads.OwnsObjects:=false;
  FThreads.Critical.MaxTimeout:=0;
  FThreads.OnItemFree:=ThreadsItemFree;

  Application.OnException:=ApplicationException;

end;

destructor TMainForm.Destroy;
begin
  FreeAndNilEx(FThreads);
  FRemoveThread.Free;
  inherited Destroy;
end;

procedure TMainForm.CheckBoxRefreshClick(Sender: TObject);
begin
  Timer.Enabled:=CheckBoxRefresh.Checked;
end;

procedure TMainForm.Log(ThreadName: String; ThreadId: Cardinal; Message: String);
begin
  Memo.Lines.Add(FormatEx('%s|%d  %s',[ThreadName,ThreadId,Message]));
end;

procedure TMainForm.ThreadLog(Thread: TBisThread; Message: String);
var
  Obj: TErrorObj;
begin
  Obj:=TErrorObj.Create;
  Obj.FForm:=Self;
  Obj.FThreadName:=Thread.Name;
  Obj.FThreadId:=Thread.ThreadID;
  Obj.FMessage:=Message;
  Thread.Synchronize(Obj.Error);
end;

procedure TMainForm.ApplicationException(Sender: TObject; E: Exception);
begin
  Log('Main',GetCurrentThreadId,E.Message);
end;

function TMainForm.GetCriticalString(Critical: TBisCritical): String;
begin
  Result:='';
  if Assigned(Critical) then begin
    Result:=FormatEx('LCount (%d) RCount (%d) ThreadId (%d)',
                     [Critical.Section.LockCount,
                      Critical.Section.RecursionCount,
                      Critical.Section.OwningThread]);
  end;
end;

function TMainForm.GetThreadsString(Locks: TBisLocks): String;
begin
  Result:='';
  if Assigned(Locks) then begin
    Result:=FormatEx('%s',[GetCriticalString(Locks.Critical)]);
  end;
end;

function TMainForm.GetThreadString(Thread: TBisWaitThread): String;
begin
  Result:='';
  if Assigned(Thread) and (Thread is TBisListBoxThread) then begin
    Result:=FormatEx('%s|%d Timeout (%d) Counter (%d)',
                     [Thread.Name,Thread.ThreadID,Thread.Timeout,Thread.Counter]);
  end;
end;

procedure TMainForm.RefreshListbox;
var
  Thread: TBisListBoxThread;
  i: Integer;
  ThreadIndex: TBisListBoxThread;
begin
  if FThreads.TryLock then begin
    ListBox.Items.BeginUpdate;
    try
      ThreadIndex:=nil;
      if ListBox.ItemIndex<>-1 then
        ThreadIndex:=TBisListBoxThread(ListBox.Items.Objects[ListBox.ItemIndex]);

      ListBox.Clear;
      for i:=0 to FThreads.Count-1 do begin
        Thread:=TBisListBoxThread(FThreads.Items[i]);
        ListBox.Items.AddObject(GetThreadString(Thread),Thread);
      end;

      ListBox.ItemIndex:=ListBox.Items.IndexOfObject(ThreadIndex);
    finally
      ListBox.Items.EndUpdate;
      FThreads.UnLock;
    end;
  end;
end;

procedure TMainForm.RemoveThreadTimeout(Thread: TBisWaitThread);
var
  Index: Integer;
begin
  try
    if Assigned(FThreads) and not FThreads.Destroying then begin
      ThreadLog(Thread,GetThreadsString(FThreads)+' lock begin');
      if FThreads.TryLock(300) then begin
        ThreadLog(Thread,GetThreadsString(FThreads)+' lock end');
        try
          if not FThreads.Empty then begin
            Index:=RandomRange(0,FThreads.Count-1);
            FThreads[Index].FreeOnEnd:=false;
            FThreads.Delete(Index);
          end;
        finally
          FThreads.UnLock;
          ThreadLog(Thread,GetThreadsString(FThreads)+' unlock');
        end;
      end else
        ThreadLog(Thread,GetThreadsString(FThreads)+' lock failed');
    end;
  finally
    Thread.Reset;
  end;
end;

procedure TMainForm.ThreadTimeout(Thread: TBisWaitThread);
begin
  try
    Sleep(500);
  finally
    if Thread.Counter<20 then
      Thread.Reset;
  end;
end;

procedure TMainForm.TimerTimer(Sender: TObject);
begin
  RefreshListbox;
end;

procedure TMainForm.ThreadError(Thread: TBisThread; const E: Exception);
begin
  if not (csDestroying in ComponentState) then
    ThreadLog(Thread,E.Message);
end;

procedure TMainForm.ThreadsItemFree(Item: TObject);
var
  Thread: TBisListBoxThread;
begin
  if Assigned(Item) and (Item is TBisListBoxThread) then begin
    Thread:=TBisListBoxThread(Item);
    ThreadLog(Thread,'Before '+iff(Thread.FreeOnEnd,'FreeOnEnd','Free'));
    if not FThreads.OwnsObjects and not Thread.FreeOnEnd then
      Thread.Free;
  end;
end;

procedure TMainForm.ThreadEnd(Thread: TBisThread);
begin
  if Assigned(FThreads) and not FThreads.Destroying then begin
    ThreadLog(Thread,GetThreadsString(FThreads)+' lock begin');
    if FThreads.TryLock then begin
      ThreadLog(Thread,GetThreadsString(FThreads)+' lock end');
      try
        Sleep(500);
        FThreads.Remove(Thread);
      finally
        FThreads.UnLock;
        ThreadLog(Thread,GetThreadsString(FThreads)+' unlock');
      end;
    end else
      ThreadLog(Thread,GetThreadsString(FThreads)+' lock failed');
  end;
end;

procedure TMainForm.ButtonClearClick(Sender: TObject);
begin
  Memo.Lines.Clear;
end;

procedure TMainForm.ButtonCreateClick(Sender: TObject);
var
  Thread: TBisListBoxThread;
begin
  FThreads.Lock;
  try
    Thread:=TBisListBoxThread.Create(RandomRange(100,1000));
    Thread.OnTimeout:=ThreadTimeout;
    Thread.OnEnd:=ThreadEnd;
    Thread.OnError:=ThreadError;
    Thread.StopOnDestroy:=false;
    Thread.FreeOnEnd:=true;
    FThreads.Add(Thread);
    Thread.Start;
    ListBox.Items.AddObject(GetThreadString(Thread),Thread);
  finally
    FThreads.UnLock;
  end;
end;

procedure TMainForm.ButtonCreateLotsClick(Sender: TObject);
var
  i: Integer;
begin
  for i:=0 to 39 do
    ButtonCreateClick(nil);
end;

procedure TMainForm.ButtonFreeClick(Sender: TObject);
var
  Thread: TBisListBoxThread;
begin
  if ListBox.ItemIndex<>-1 then begin
    Log('Main',GetCurrentThreadId,GetThreadsString(FThreads)+' lock begin');
    FThreads.Lock;
    Log('Main',GetCurrentThreadId,GetThreadsString(FThreads)+' lock end');
    try
      Thread:=TBisListBoxThread(ListBox.Items.Objects[ListBox.ItemIndex]);
      Thread.FreeOnEnd:=false;
      FThreads.Remove(Thread);
      ListBox.Items.Delete(ListBox.ItemIndex);
    finally
      FThreads.UnLock;
      Log('Main',GetCurrentThreadId,GetThreadsString(FThreads)+' unlock');
    end;
  end;
end;

procedure TMainForm.ButtonRefreshClick(Sender: TObject);
begin
  RefreshListbox;
end;

procedure TMainForm.ButtonStopClick(Sender: TObject);
begin
  if ButtonStop.Caption='Stop' then begin
    FRemoveThread.Stop;
    ButtonStop.Caption:='Start';
  end else begin
    FRemoveThread.Start;
    ButtonStop.Caption:='Stop';
  end;
end;

end.