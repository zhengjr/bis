unit BisCallcTakeBellFilterFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BisFm, BisDataEditFm;

type
  TRadioGroup=class(ExtCtrls.TRadioGroup)
  end;

  TBisCallcStatusInfo=class(TObject)
  public
    var TableName, Condition: String;
  end;

  TBisCallcTakeBellFilterForm = class(TBisDataEditForm)
    RadioGroupStatuses: TRadioGroup;
  private
    procedure RefreshStatuses;
  public
    constructor Create(AOwner: TComponent); override;
    function ChangesArePresent: Boolean; override;
  end;

  TBisCallcTakeBellFilterFormIface=class(TBisDataEditFormIface)
  public
    constructor Create(AOwner: TComponent); override;
  end;

var
  BisCallcTakeBellFilterForm: TBisCallcTakeBellFilterForm;

implementation

uses BisProvider, BisUtils;

{$R *.dfm}

{ TBisCallcTakeBellFilterFormIface }

constructor TBisCallcTakeBellFilterFormIface.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormClass:=TBisCallcTakeBellFilterForm;
  Caption:='����� �������';
end;

{ TBisCallcTakeBellFilterForm }

constructor TBisCallcTakeBellFilterForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  RefreshStatuses;
end;

function TBisCallcTakeBellFilterForm.ChangesArePresent: Boolean;
begin
  Result:=RadioGroupStatuses.ItemIndex<>-1;
end;

procedure TBisCallcTakeBellFilterForm.RefreshStatuses;
var
  P: TBisProvider;
  AName: String;
  Obj: TBisCallcStatusInfo;
  Flag: Boolean;
  Index: Integer;
  H: Integer;
  WMax: Integer;
  dW: Integer;
begin
  H:=Height;
  WMax:=RadioGroupStatuses.ClientWidth-40;
  dW:=Width-WMax;
  ClearStrings(RadioGroupStatuses.Items);
  P:=TBisProvider.Create(nil);
  try
    P.ProviderName:='S_STATUSES';
    with P.FieldNames do begin
      AddInvisible('NAME');
      AddInvisible('TABLE_NAME');
      AddInvisible('CONDITION');
    end;
    P.Orders.Add('PRIORITY');
    P.Open;
    if P.Active and not P.IsEmpty then begin
      Flag:=false;
      P.First;
      while not P.Eof do begin
        Obj:=TBisCallcStatusInfo.Create;
        Obj.TableName:=P.FieldByName('TABLE_NAME').AsString;
        Obj.Condition:=P.FieldByName('CONDITION').AsString;
        AName:=P.FieldByName('NAME').AsString;
        Index:=RadioGroupStatuses.Items.AddObject(AName,Obj);
        if not Flag then begin
          Flag:=true;
          RadioGroupStatuses.ItemIndex:=Index;
        end;
        H:=H+Round(RadioGroupStatuses.Font.Size*2);
        if RadioGroupStatuses.Canvas.TextWidth(AName)>WMax then
          WMax:=RadioGroupStatuses.Canvas.TextWidth(AName);
        P.Next;
      end;
      Width:=WMax+dW;
      Height:=H;
      Constraints.MinWidth:=Width;
      Constraints.MinHeight:=Height;
    end;
  finally
    P.Free;
  end;
end;

end.