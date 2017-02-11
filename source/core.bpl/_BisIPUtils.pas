unit BisIPUtils;

interface

uses Classes;

function MatchIP(IP: String; Masks: TStrings): Boolean; overload;
function MatchIP(IP: String; Masks: String): Boolean; overload;
function IsIP(Host: String): Boolean;
function ExtractDomain(Host: String): String;
procedure GetIPList(Strings: TStringList);
procedure GetDNSList(Strings: TStringList);

implementation

uses Windows, SysUtils, Contnrs, StrUtils,
     IpTypes, IpFunctions,
     BisUtils;

type
  TIP=class(TObject)
  private
    FOct1: Byte;
    FOct2: Byte;
    FOct3: Byte;
    FOct4: Byte;
    function GetAsString: String;
    function GetAsCardinal: Cardinal;
    procedure SetAsString(const Value: String);
    procedure SetAsCardinal(const Value: Cardinal);
  protected
    class function Valid(IP: String): TIP;
    class function Max(IP: String): TIP;
    class function Min(IP: String): TIP;
  public
    procedure CopyFrom(Source: TIP);
    function Equal(Source: TIP): Boolean;

    property Oct1: Byte read FOct1 write FOct1;
    property Oct2: Byte read FOct2 write FOct2;
    property Oct3: Byte read FOct3 write FOct3;
    property Oct4: Byte read FOct4 write FOct4;

    property AsString: String read GetAsString write SetAsString;
    property AsCardinal: Cardinal read GetAsCardinal write SetAsCardinal;
  end;

  TIPInterval=class(TObject)
  private
    FIPFrom: TIP;
    FIPTo: TIP;
  public
    constructor Create;
    destructor Destroy; override;
    function Inside(IP: TIP): Boolean;

    property IPFrom: TIP read FIPFrom;
    property IPTo: TIP read FIPTo;
  end;

  TIPListType=(ltUnknown,ltIP,ltIPInterval);

  TIPList=class(TObjectList)
  public
    function FindIP(IPFrom: TIP): TIP;
    function FindIPInterval(IPFrom: TIP): TIPInterval;
    function AddIP(IPFrom: TIP): TIP;
    function AddIPInterval(IPFrom: TIP; ACount: Cardinal): TIPInterval; overload;
    function AddIPInterval(IPFrom, IPTo: TIP): TIPInterval; overload;
    function MatchIP(IP: String): Boolean;
  end;

{ TIP }

procedure TIP.CopyFrom(Source: TIP);
begin
  if Assigned(Source) then begin
    FOct1:=Source.Oct1;
    FOct2:=Source.Oct2;
    FOct3:=Source.Oct3;
    FOct4:=Source.Oct4;
  end;
end;

function TIP.Equal(Source: TIP): Boolean;
begin
  Result:=false;
  if Assigned(Source) then
    Result:=(Source.Oct1=FOct1) and (Source.Oct2=FOct2) and
            (Source.Oct3=FOct3) and (Source.Oct4=FOct4);
end;

function TIP.GetAsCardinal: Cardinal;
begin
  Result:=FOct1*16777216+FOct2*65536+FOct3*256+FOct4;
end;

function TIP.GetAsString: String;
begin
  Result:=Format('%d.%d.%d.%d',[FOct1,FOct2,FOct3,FOct4]);
end;

class function TIP.Max(IP: String): TIP;
begin
  IP:=ReplaceText(IP,'*',IntToStr(255));
  Result:=Valid(IP);
end;

class function TIP.Min(IP: String): TIP;
begin
  IP:=ReplaceText(IP,'*',IntToStr(0));
  Result:=Valid(IP);
end;

procedure TIP.SetAsCardinal(const Value: Cardinal);
begin
  //
end;

procedure TIP.SetAsString(const Value: String);
var
  IP: TIP;
begin
  IP:=Valid(Value);
  if Assigned(IP) then begin
    try
      FOct1:=IP.Oct1;
      FOct2:=IP.Oct2;
      FOct3:=IP.Oct3;
      FOct4:=IP.Oct4;
    finally
      IP.Free;
    end;
  end;
end;

class function TIP.Valid(IP: String): TIP;

  function Check(S: String; var Oct: Byte): Boolean;
  var
    Val: Integer;
  begin
    Result:=false;
    if TryStrToInt(Trim(S),Val) and (Val>=0) and (Val<=255) then begin
      Oct:=Val;
      Result:=true;
    end;
  end;
  
var
  Str: TStringList;
  Oct: Byte;
  AOct1,AOct2,AOct3: Byte;
begin
  Result:=nil;
  Str:=TStringList.Create;
  try
    GetStringsByString(IP,'.',Str);
    if Str.Count=4 then begin
      if Check(Trim(Str[0]),Oct) then begin
        AOct1:=Oct;
        if Check(Trim(Str[1]),Oct) then begin
          AOct2:=Oct;
          if Check(Trim(Str[2]),Oct) then begin
            AOct3:=Oct;
            if Check(Trim(Str[3]),Oct) then begin
              Result:=TIP.Create;
              Result.Oct1:=AOct1;
              Result.Oct2:=AOct2;
              Result.Oct3:=AOct3;
              Result.Oct4:=Oct;
            end;
          end;
        end;
      end;
    end;
  finally
    Str.Free;
  end;
end;

{ TIPInterval }

constructor TIPInterval.Create;
begin
  inherited Create;
  FIPFrom:=TIP.Create;
  FIPTo:=TIP.Create;
end;

destructor TIPInterval.Destroy;
begin
  FIPTo.Free;
  FIPFrom.Free;
  inherited;
end;

function TIPInterval.Inside(IP: TIP): Boolean;
begin
  Result:=false;
  if Assigned(IP) then begin
    Result:=(IPFrom.AsCardinal<=IP.AsCardinal) and
            (IPTo.AsCardinal>=IP.AsCardinal);
  end;
end;

{ TIPList }

function TIPList.FindIP(IPFrom: TIP): TIP;
var
  i: Integer;
  Item: TIP;
begin
  Result:=nil;
  if Assigned(IPFrom) then begin
    for i:=0 to Count-1 do begin
      if (Items[i] is TIP) then begin
        Item:=TIP(Items[i]);
        if Item.Equal(IPFrom) then begin
          Result:=Item;
          break;
        end;
      end;
    end;
  end;
end;

function TIPList.FindIPInterval(IPFrom: TIP): TIPInterval;
var
  i: Integer;
  Item: TIPInterval;
begin
  Result:=nil;
  if Assigned(IPFrom) then begin
    for i:=0 to Count-1 do begin
      if (Items[i] is TIPInterval) then begin
        Item:=TIPInterval(Items[i]);
        if Item.Inside(IPFrom) then begin
          Result:=Item;
          break;
        end;
      end;
    end;
  end;
end;

function TIPList.AddIP(IPFrom: TIP): TIP;
begin
  Result:=nil;
  if not Assigned(FindIP(IPFrom)) then begin
    Result:=TIP.Create;
    if Assigned(IPFrom) then
      Result.CopyFrom(IPFrom);
    inherited Add(Result);
  end;
end;

function TIPList.AddIPInterval(IPFrom: TIP; ACount: Cardinal): TIPInterval;
begin
  Result:=nil;
  if Assigned(IPFrom) then begin
    Result:=TIPInterval.Create;
    Result.IPFrom.CopyFrom(IPFrom);
    Result.IPTo.CopyFrom(IPFrom);
    Result.IPTo.Oct4:=Result.IPTo.Oct4+ACount;
    inherited Add(Result);
  end;
end;

function TIPList.AddIPInterval(IPFrom, IPTo: TIP): TIPInterval;
begin
  Result:=nil;
  if Assigned(IPFrom) and Assigned(IPTo) then begin
    Result:=TIPInterval.Create;
    Result.IPFrom.CopyFrom(IPFrom);
    Result.IPTo.CopyFrom(IPTo);
    inherited Add(Result);
  end;
end;

function TIPList.MatchIP(IP: String): Boolean;
var
  IPFrom: TIP;
begin
  Result:=false;
  IPFrom:=TIP.Valid(IP);
  if Assigned(IPFrom) then begin
    try
      Result:=Assigned(FindIP(IPFrom));
      if not Result then
        Result:=Assigned(FindIPInterval(IPFrom));
    finally
      IPFrom.Free;
    end;
  end;
end;

{ }

function MatchIP(IP: String; Masks: TStrings): Boolean;
var
  IPList: TIPList;

  function TryBy(S: String): Boolean;
  var
    IPFrom, IPTo: TIP;
  begin
    Result:=false;
    IPFrom:=TIP.Valid(S);
    if Assigned(IPFrom) then begin
      try
        Result:=Assigned(IPList.AddIP(IPFrom));
      finally
        IPFrom.Free;
      end;
    end else begin
      IPFrom:=TIP.Min(S);
      if Assigned(IPFrom) then begin
        try
          IPTo:=TIP.Max(S);
          if Assigned(IPTo) then begin
            try
              Result:=Assigned(IPList.AddIPInterval(IPFrom,IPTo));
            finally
              IPTo.Free;
            end;
          end;
        finally
          IPFrom.Free;
        end;
      end;
    end;
  end;

  function TryByCount(S: String): Boolean;
  var
    IPFrom: TIP;
    Count: Integer;
    Str: TStringList;
  begin
    Result:=false;
    Str:=TStringList.Create;
    try
      GetStringsByString(S,'/',Str);
      if Str.Count>=1 then begin
        IPFrom:=TIP.Valid(Trim(Str[0]));
        if Assigned(IPFrom) then begin
          try
            if Str.Count=2 then begin
              Count:=0;
              if TryStrToInt(Trim(Str[1]),Count) then begin
                if (IPFrom.Oct4+Count)>255 then
                  Count:=255-IPFrom.Oct4;
              end;
              if Count=0 then
                Count:=255-IPFrom.Oct4;
              Result:=Assigned(IPList.AddIPInterval(IPFrom,Count));
            end else
              Result:=Assigned(IPList.AddIP(IPFrom));
          finally
            IPFrom.Free;
          end;
        end;
      end;
    finally
      Str.Free;
    end;
  end;

  function TryByInterval(S: String): Boolean;
  var
    IPFrom, IPTo: TIP;
    Str: TStringList;
  begin
    Result:=false;
    Str:=TStringList.Create;
    try
      GetStringsByString(S,'-',Str);
      if Str.Count>=1 then begin
        IPFrom:=TIP.Min(Trim(Str[0]));
        if Assigned(IPFrom) then begin
          try
            if Str.Count=2 then begin
              IPTo:=TIP.Max(Trim(Str[1]));
              if Assigned(IPTo) then begin
                try
                  Result:=Assigned(IPList.AddIPInterval(IPFrom,IPTo));
                finally
                  IPTo.Free;
                end;
              end;
            end else
              Result:=Assigned(IPList.AddIP(IPFrom));
          finally
            IPFrom.Free;
          end;
        end;
      end;
    finally
      Str.Free;
    end;
  end;

var
  i: Integer;
  S: String;
begin
  Result:=false;
  if Assigned(Masks) then begin
    IPList:=TIPList.Create;
    try
      for i:=0 to Masks.Count-1 do begin
        S:=Trim(Masks[i]);
        if not TryBy(S) then
          if not TryByCount(S) then
            TryByInterval(S);
      end;
      Result:=IPList.MatchIP(IP);
    finally
      IPList.Free;
    end;
  end;
end;

function MatchIP(IP: String; Masks: String): Boolean;
var
  Strings: TStringList;
begin
  Strings:=TStringList.Create;
  try
    Strings.Text:=Masks;
    Result:=MatchIP(IP,Strings);
  finally
    Strings.Free;
  end;
end;

function IsIP(Host: String): Boolean;
var
  Strings: TStringList;
  i: Integer;
  V: Integer;
begin
  Strings:=TStringList.Create;
  try
    Result:=false;
    GetStringsByString(Host,'.',Strings);
    if Strings.Count=4 then begin
      for i:=0 to Strings.Count-1 do begin
        Result:=TryStrToInt(Strings[i],V);
      end;
    end;
  finally
    Strings.Free;
  end;
end;

function ExtractDomain(Host: String): String;
var
  Strings: TStringList;
  i, N: Integer;
begin
  Strings:=TStringList.Create;
  try
    Result:=Host;
    GetStringsByString(Host,'.',Strings);
    if Strings.Count>1 then begin
      Result:='';
      N:=0;
      if Strings.Count>2 then
        N:=Strings.Count-2;
      for i:=Strings.Count-1 downto N do begin
        Result:=Strings[i]+iff(Result<>'','.'+Result,'');
      end;
    end;
  finally
    Strings.Free;
  end;
end;

procedure GetIPList(Strings: TStringList);
var
  PAdapter, PMem: PipAdapterInfo;
  OutBufLen: ULONG;
  PIPAddr: PIpAddrString;
  S: String;
begin
  if Assigned(Strings) then begin
    try
      VVGetAdaptersInfo(PAdapter, OutBufLen);
      PMem:=PAdapter;
      try
        while Assigned(PAdapter) do begin

          if Assigned(PAdapter.CurrentIpAddress) then begin
            S:=PAdapter.CurrentIpAddress.IpAddress.S;
            if Strings.IndexOf(S)=-1 then
               Strings.Add(S);
          end;

          PIPAddr:=@PAdapter.IpAddressList;
          repeat
            if Assigned(PIPAddr) then begin
              S:=PIPAddr.IpAddress.S;
              if Strings.IndexOf(S)=-1 then
                Strings.Add(S);
              PIPAddr:=PIPAddr.Next;
            end;
          until not Assigned(PIPAddr);

          PAdapter:=PAdapter.Next;
        end;
      finally
        if Assigned(PMem) then
          Freemem(PMem, OutBufLen);
      end;
    except
      //
    end;
  end;
end;

procedure GetDNSList(Strings: TStringList);
var
  P: PfixedInfo;
  OutBufLen: ULONG;
  PIPAddr: PIpAddrString;
  S: String;
begin
  if Assigned(Strings) then begin
    try
      VVGetNetworkParams(P,OutBufLen);
      try
        if Assigned(P) then begin

          if Assigned(P.CurrentDnsServer) then begin
            S:=P.CurrentDnsServer.IpAddress.S;
            if Strings.IndexOf(S)=-1 then
               Strings.Add(S);
          end;

          PIPAddr:=@P.DnsServerList;
          repeat
            if Assigned(PIPAddr) then begin
              S:=PIPAddr.IpAddress.S;
              if Strings.IndexOf(S)=-1 then
                Strings.Add(S);
              PIPAddr:=PIPAddr.Next;
            end;
          until not Assigned(PIPAddr);
          
        end;
      finally
        if Assigned(P) then
          Freemem(P,OutBufLen);
      end;
    except
      //
    end;
  end;
end;

end.