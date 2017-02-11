unit BisKrieltDataArticlesFrm;
                                                                                                
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnPopup, ImgList, ActnList, DB, ComCtrls, ToolWin,
  ExtCtrls, Grids, DBGrids, StdCtrls, Contnrs,

  BisDataGridFrm, BisKrieltDataCommentsFm;

type
  TBisKrieltDataArticlesFrameIfaces=class(TObjectList)
  public
    function FindCommentById(ArticleId: Variant): TBisKrieltDataCommentsFormIface;
  end;

  TBisKrieltDataArticlesFrame = class(TBisDataGridFrame)
    ToolBar1: TToolBar;
    N18: TMenuItem;
    ToolButtonComments: TToolButton;
    ActionComments: TAction;
    MenuItemComments: TMenuItem;
    procedure ActionCommentsExecute(Sender: TObject);
    procedure ActionCommentsUpdate(Sender: TObject);
  private
    FIfaces: TBisKrieltDataArticlesFrameIfaces;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CanComments: Boolean;
    procedure Comments;
  end;

implementation

uses BisProvider, BisDialogs, BisUtils, BisFilterGroups;

{$R *.dfm}

{ TBisKrieltDataArticlesFrameIfaces }

function TBisKrieltDataArticlesFrameIfaces.FindCommentById(ArticleId: Variant): TBisKrieltDataCommentsFormIface;
var
  i: Integer;
  Obj: TObject;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Obj:=Items[i];
    if Assigned(Obj) and (Obj is TBisKrieltDataCommentsFormIface) then begin
      if VarSameValue(TBisKrieltDataCommentsFormIface(Obj).ArticleId,ArticleId) then begin
        Result:=TBisKrieltDataCommentsFormIface(Obj);
        exit;
      end;
    end;
  end;
end;

{ TBisKrieltDataColumnsFrame }

constructor TBisKrieltDataArticlesFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIfaces:=TBisKrieltDataArticlesFrameIfaces.Create;
end;

destructor TBisKrieltDataArticlesFrame.Destroy;
begin
  FIfaces.Free;
  inherited Destroy;
end;

procedure TBisKrieltDataArticlesFrame.ActionCommentsExecute(Sender: TObject);
begin
  Comments;
end;

procedure TBisKrieltDataArticlesFrame.ActionCommentsUpdate(Sender: TObject);
begin
  ActionComments.Enabled:=CanComments;
end;

function TBisKrieltDataArticlesFrame.CanComments: Boolean;
var
  Iface: TBisKrieltDataCommentsFormIface;
begin
  Result:=Provider.Active and not Provider.Empty;
  if Result then begin
    Iface:=TBisKrieltDataCommentsFormIface.Create(nil);
    try
      Iface.Init;
      Result:=Iface.CanShow;
    finally
      Iface.Free;
    end;
  end;
end;

procedure TBisKrieltDataArticlesFrame.Comments;
var
  Iface: TBisKrieltDataCommentsFormIface;
  ArticleId: Variant;
  ArticleTitle: String;
begin
  if CanComments then begin
    ArticleId:=Provider.FieldByName('ARTICLE_ID').Value;
    ArticleTitle:=Provider.FieldByName('TITLE').AsString;
    Iface:=FIfaces.FindCommentById(ArticleId);
    if not Assigned(Iface) then begin
      Iface:=TBisKrieltDataCommentsFormIface.Create(Self);
      Iface.ArticleId:=ArticleId;
      Iface.ArticleTitle:=ArticleTitle;
      Iface.MaxFormCount:=1;
      Iface.FilterOnShow:=false;
      FIfaces.Add(Iface);
      Iface.Init;
      Iface.LoadOptions;
      Iface.FilterGroups.Add.Filters.Add('ARTICLE_ID',fcEqual,ArticleId).CheckCase:=true;
    end;
    Iface.Caption:=FormatEx('%s => %s',[ActionComments.Hint,ArticleTitle]);
    Iface.ShowType:=ShowType;
    if AsModal then
      Iface.ShowModal
    else Iface.Show;
  end;
end;

end.