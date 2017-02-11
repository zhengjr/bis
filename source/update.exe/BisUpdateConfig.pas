unit BisUpdateConfig;

interface

uses Classes, IniFiles;

type

  TBisUpdateConfigMode=(cmDefault,cmBase64);

  TBisUpdateConfig=class(TComponent)
  private
    FIniFile: TMemIniFile;
    FFileName: String;
    function GetAsText: String;
    procedure SetAsText(Value: String);
  public
    constructor Create(AOwner: Tcomponent); override;
    destructor Destroy; override;
    
    procedure Load; virtual;
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromFile(const FileName: string);
    procedure SaveToFile(const FileName: string);
    procedure UpdateFile;
    procedure LoadFromString(const S: String);
    procedure Write(const Section,Param: String; Value: Variant; Mode: TBisUpdateConfigMode=cmDefault);
    function Read(const Section,Param: String; Default: Variant; Mode: TBisUpdateConfigMode=cmDefault): Variant;
    procedure ReadSection(const Section: String; Strings: TStrings);
    procedure ReadSectionValues(const Section: String; Strings: TStrings);
    procedure AddSectionText(const SectionName, SectionText: String);
    function Exists(const Section,Param: String): Boolean;
    function Empty: Boolean;

    property Text: String read GetAsText write SetAsText;
    property FileName: String read FFileName write FFileName;
    property IniFile: TMemIniFile read FIniFile write FIniFile;
  end;

implementation

uses SysUtils, Variants, TypInfo, DIMime;

function Base64ToStr(S: String): String;
begin
  try
    Result:=MimeDecodeString(S);
  except
  end;
end;

function StrToBase64(S: String): String;
begin
  try
    Result:=MimeEncodeStringNoCRLF(S);
  except
  end;
end;
     
{ TBisUpdateConfig }

constructor TBisUpdateConfig.Create(AOwner: Tcomponent);
begin
  inherited Create(AOwner);
  FIniFile:=TMemIniFile.Create('');
end;

destructor TBisUpdateConfig.Destroy;
begin
  FIniFile.Free;
  inherited Destroy;
end;

procedure TBisUpdateConfig.Load;
begin
  LoadFromFile(FFileName);
end;

procedure TBisUpdateConfig.LoadFromStream(Stream: TStream);
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    List.LoadFromStream(Stream);
    FIniFile.SetStrings(List);
  finally
    List.Free;
  end;
end;

procedure TBisUpdateConfig.SaveToStream(Stream: TStream);
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    FIniFile.GetStrings(List);
    List.SaveToStream(Stream);
  finally
    List.Free;
  end;
end;

procedure TBisUpdateConfig.LoadFromFile(const FileName: string);
var
  fs: TFileStream;
begin
  if FileExists(FileName) then begin
    fs:=nil;
    try
      try
        fs:=TFileStream.Create(FileName,fmOpenRead);
        LoadFromStream(fs);
        FFileName:=FileName;
      except
      end;
    finally
      fs.Free;
    end;
  end;
end;

procedure TBisUpdateConfig.SaveToFile(const FileName: string);
var
  fs: TFileStream;
begin
  fs:=nil;
  try
    fs:=TFileStream.Create(FileName,fmCreate);
    SaveToStream(fs);
  finally
    fs.Free;
  end;
end;

procedure TBisUpdateConfig.Write(const Section,Param: String; Value: Variant; Mode: TBisUpdateConfigMode=cmDefault);
begin
  case VarType(Value) of
     varSmallint, varInteger, varShortInt, varByte, varWord, varLongWord, varInt64: begin
       FIniFile.WriteInteger(Section,Param,Value);
     end;
     varOleStr, varStrArg, varString: begin
       case Mode of
         cmDefault: FIniFile.WriteString(Section,Param,Value);
         cmBase64: FIniFile.WriteString(Section,Param,StrToBase64(Value));
       end;
     end;
     varBoolean: begin
       FIniFile.WriteBool(Section,Param,Value);
     end;
     varSingle, varDouble, varCurrency: begin
       FIniFile.WriteFloat(Section,Param,Value);
     end;
     varDate: begin
       FIniFile.WriteDateTime(Section,Param,Value);
     end;
  else
    case Mode of
      cmDefault: FIniFile.WriteString(Section,Param,VarToStrDef(Value,''));
      cmBase64: FIniFile.WriteString(Section,Param,StrToBase64(VarToStrDef(Value,''))); 
    end;
  end;
end;

function TBisUpdateConfig.Read(const Section,Param: String; Default: Variant; Mode: TBisUpdateConfigMode=cmDefault): Variant;
var
  V: Word;
  S: String;
begin
  V:=VarType(Default);
  case V of
     varSmallint, varInteger, varShortInt, varByte, varWord, varLongWord, varInt64: begin
       Result:=FIniFile.ReadInteger(Section,Param,Default);
     end;
     varOleStr, varStrArg, varString: begin
       case Mode of
         cmDefault: Result:=FIniFile.ReadString(Section,Param,Default);
         cmBase64: Result:=Base64ToStr(FIniFile.ReadString(Section,Param,StrToBase64(Default)));
       end;
     end;
     varBoolean: begin
       Result:=FIniFile.ReadBool(Section,Param,Default);
     end;
     varSingle, varDouble, varCurrency: begin
       Result:=FIniFile.ReadFloat(Section,Param,Default);
     end;
     varDate: begin
       Result:=FIniFile.ReadDateTime(Section,Param,Default);
     end;
  else
    S:=FIniFile.ReadString(Section,Param,VarToStrDef(Default,''));
    case Mode of
      cmDefault: Result:=S;
      cmBase64: Result:=Base64ToStr(S);
    end;
  end;
end;

function TBisUpdateConfig.Empty: Boolean;
begin
  Result:=Trim(Text)='';
end;

function TBisUpdateConfig.Exists(const Section, Param: String): Boolean;
begin
  Result:=FIniFile.SectionExists(Section);
  if Result then
    FIniFile.ValueExists(Section,Param);
end;

procedure TBisUpdateConfig.ReadSection(const Section: String; Strings: TStrings);
begin
  FIniFile.ReadSection(Section,Strings);
end;

procedure TBisUpdateConfig.ReadSectionValues(const Section: String; Strings: TStrings);
begin
  FIniFile.ReadSectionValues(Section,Strings);
end;

procedure TBisUpdateConfig.UpdateFile;
begin
  SaveToFile(FFileName);
end;

procedure TBisUpdateConfig.LoadFromString(const S: String);
var
  Stream: TStringStream;
begin
  Stream:=TStringStream.Create(S);
  try
    Stream.Position:=0;
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

function TBisUpdateConfig.GetAsText: String;
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    FIniFile.GetStrings(List);
    Result:=List.Text;
  finally
    List.Free;
  end;
end;

procedure TBisUpdateConfig.SetAsText(Value: String);
var
  List: TStringList;
begin
  List:=TStringList.Create;
  try
    List.Text:=Value;
    FIniFile.SetStrings(List);
  finally
    List.Free;
  end;
end;

procedure TBisUpdateConfig.AddSectionText(const SectionName, SectionText: String);
var
  List: TStringList;
begin
  List:=TStringList.Create;
  try
    List.Text:=SectionText;
    List.Insert(0,'['+SectionName+']');
    FIniFile.SetStrings(List);
  finally
    List.Free;
  end;
end;

end.