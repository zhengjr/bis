unit BisPicture;

interface

uses Classes, Controls, Graphics, jpeg, SysUtils, GifImage;

type
  TBisPicture=class(TPicture)
  public
    function GetGraphicClass(Header: array of byte): TGraphicClass;
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
    function Empty: Boolean;
    procedure Assign(Source: TPersistent); override;
  end;


implementation

uses BisConsts;

{ TBisPicture }

function TBisPicture.GetGraphicClass(Header: array of byte): TGraphicClass;
begin
  Result:=nil;
  if (Header[0]=66) and
     (Header[1]=77) then begin
    Result:=TBitmap;
    exit;
  end;
  if (Header[0]=255) and
     (Header[1]=216) and
     (Header[2]=255) and
     (Header[3]=224) then begin
    Result:=TJPEGImage;
    exit;
  end;
  if (Header[0]=255) and
     (Header[1]=216) and
     (Header[2]=255) and
     (Header[3]=225) then begin
    Result:=TJPEGImage;
    exit;
  end;
  if (Header[0]=0) and
     (Header[1]=0) and
     (Header[2]=1) and
     (Header[3]=0) then begin
    Result:=TIcon;
    exit;
  end;
  if (Header[0]=215) and
     (Header[1]=205) and
     (Header[2]=198) and
     (Header[3]=154) then begin
    Result:=TMetafile;
    exit;
  end;
  if (Header[0]=71) and
     (Header[1]=73) and
     (Header[2]=70) then begin
    Result:=TGIFImage;
    exit;
  end;
end;

procedure TBisPicture.LoadFromStream(Stream: TStream);
var
  GraphicClass: TGraphicClass;
  NewGraphic: TGraphic;
  Header: array[0..3] of byte;
  OldPos: Int64;
begin
  if Stream.Size=0 then begin
    Assign(nil);
    exit;
  end;
  FillChar(Header,SizeOf(Header),0);
  OldPos:=Stream.Position;
  Stream.Read(Header,4);
  Stream.Position:=OldPos;
  GraphicClass:=GetGraphicClass(Header);
  if GraphicClass=nil then begin
    Graphic:=nil;
    exit;
  end;

  NewGraphic:= GraphicClass.Create;
  try
    NewGraphic.LoadFromStream(Stream);
    Graphic:=NewGraphic;
    Changed(Self);
  finally
    NewGraphic.Free;
  end;
end;

procedure TBisPicture.SaveToStream(Stream: TStream);
begin
 if Graphic<>nil then
   Graphic.SaveToStream(Stream);
end;

function TBisPicture.Empty: Boolean;
begin
  Result:=not Assigned(Graphic);
end;

procedure TBisPicture.Assign(Source: TPersistent);
begin
  inherited;
end;

end.