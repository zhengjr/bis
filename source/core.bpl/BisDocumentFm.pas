unit BisDocumentFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, ActiveX,
  BisFm;

type
  TBisDocumentForm = class(TBisForm)
    PanelFrame: TPanel;
    StatusBar: TStatusBar;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TBisDocumentFormIface=class(TBisFormIface)
  private
    FDocumentId: Variant;
    FOleClass: String;
    FDocumentVisible: Boolean;
    FLastOleObject: IOleObject;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CanShow: Boolean; override;
    procedure Show; override;
    function ShowModal: TModalResult; override;


    property LastOleObject: IOleObject read FLastOleObject;

    property DocumentId: Variant read FDocumentId write FDocumentId;
    property OleClass: String read FOleClass write FOleClass;
    property DocumentVisible: Boolean read FDocumentVisible write FDocumentVisible;

  end;

  TBisDocumentFormIfaceClass=class of TBisDocumentFormIface;

var
  BisDocumentForm: TBisDocumentForm;

implementation

uses ComObj,
     BisCore, BisConnectionUtils;

{$R *.dfm}

{ TBisDocumentFormIface }

constructor TBisDocumentFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=nil;
  OnlyOneForm:=false;
  ShowType:=stMdiChild;
  Permissions.Enabled:=true;
  FDocumentVisible:=true;
end;

destructor TBisDocumentFormIface.Destroy;
begin
  FLastOleObject:=nil;
  inherited Destroy;
end;

function TBisDocumentFormIface.CanShow: Boolean;
begin
  Result:=inherited CanShow and
          (Trim(FDocumentId)<>'') and (Trim(FOleClass)<>'');
end;

procedure TBisDocumentFormIface.Show;
var
  AStream: TMemoryStream;
  OleObject: IOleObject;
  Storage: IStorage;
//  Stream: IStream;
  LockBytes: ILockBytes;
  DataHandle: HGlobal;
  Buffer: Pointer;
  ClassID: TClsid;
  PersistStorage: IPersistStorage;
//  PersistStream: IPersistStream;
  R: TRect;
  OldCursor: TCursor;
begin
  if CanShow then begin
    AStream:=TMemoryStream.Create;
    try
      if DefaultLoadDocument(FDocumentId,AStream) then begin

        AStream.Position:=0;

        DataHandle:=GlobalAlloc(GMEM_MOVEABLE,AStream.Size);
        if DataHandle=0 then OutOfMemoryError;
        try
          OldCursor:=Screen.Cursor;
          Screen.Cursor:=crHourGlass;
          Buffer:=GlobalLock(DataHandle);
          try
            AStream.Read(Buffer^,AStream.Size);

            OleCheck(CreateILockBytesOnHGlobal(DataHandle,True,LockBytes));
            if Assigned(LockBytes) then begin
              OleObject:=nil;
              ClassID:=ProgIDToClassID(FOleClass);
              OleCheck(CoCreateInstance(ClassID,nil,CLSCTX_INPROC_HANDLER or CLSCTX_INPROC_SERVER,IOleObject,OleObject));

              if Assigned(OleObject) then begin
                if StgIsStorageILockBytes(LockBytes)=S_OK then begin
                  OleObject.QueryInterface(IPersistStorage,PersistStorage);
                  if Assigned(PersistStorage) then begin
                    OleCheck(StgOpenStorageOnILockBytes(LockBytes,nil,STGM_READWRITE or STGM_SHARE_EXCLUSIVE,nil,0,Storage));
                    if Assigned(Storage) then
                      OleCheck(PersistStorage.Load(Storage));
                  end;
                end else begin
               {   OleObject.QueryInterface(IPersistStorage,PersistStorage);
                  if Assigned(PersistStorage) then begin
                    OleCheck(StgOpenStorageOnILockBytes(LockBytes,nil,STGM_READWRITE or STGM_SHARE_EXCLUSIVE,nil,0,Storage));
                    if Assigned(Storage) then
                      OleCheck(PersistStorage.Load(Storage));
                  end else begin
                    OleObject.QueryInterface(IPersistStream,PersistStream);
                    if Assigned(PersistStream) then begin
                      OleCheck(CreateStreamOnHGlobal(DataHandle,true,Stream));
                      if Assigned(Stream) then
                        OleCheck(PersistStream.Load(Stream));
                    end;
                  end; }
                end;

                FLastOleObject:=OleObject;

                OleCheck(OleObject.SetHostNames(PWideChar(WideString(Application.Title)),PWideChar(WideString(Caption))));
                OleCheck(OleRun(OleObject));
                if FDocumentVisible then
                  OleCheck(OleObject.DoVerb(OLEIVERB_SHOW, nil, nil, 0, 0, R));

              end;
            end;
          finally
            GlobalUnlock(DataHandle);
            Screen.Cursor:=OldCursor;
          end;
        except
          if DataHandle <> 0 then GlobalFree(DataHandle);
          raise;
        end;
      end;
    finally
      AStream.Free;
    end;
  end;
end;

function TBisDocumentFormIface.ShowModal: TModalResult;
begin
  Show;
  Result:=mrOk;
end;

{ TBisDocumentForm }

constructor TBisDocumentForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CloseMode:=cmFree;
end;

end.
