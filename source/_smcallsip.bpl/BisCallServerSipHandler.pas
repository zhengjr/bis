unit BisCallServerSipHandler;

interface

uses Windows, Classes, ZLib, mmSystem,
     IdGlobal, IdSocketHandle, IdUDPServer,
     BisEvents, BisCrypter,
     BisSipPhone, BisSip, BisSdp, BisRtp, BisWave,
     BisCallServerHandlerModules, BisCallServerHandlers,
     BisCallServerChannels;

type
  TBisCallServerSipHandler=class;

  TBisCallServerSipChannels=class;

  TBisCallServerSipChannel=class(TBisCallServerChannel)
  private
    FHandler: TBisCallServerSipHandler;
    FLine: TBisSipPhoneLine;
    FLock: TCriticalSection;
//    FSendStream: TMemoryStream;
    FOutFormat: PWaveFormatEx;
    FCreatorId: Variant;
    FDateCreate: TDateTime;
    FCallId: Variant;
    FCallerId: Variant;
    FCallerPhone: Variant;
    FDirection: TBisCallServerChannelDirection;
  protected
    function GetActive: Boolean; override;
    function GetDirection: TBisCallServerChannelDirection; override;
    function GetCallerPhone: Variant; override;
    function GetCreatorId: Variant; override;
    function GetDateCreate: TDateTime; override;
    function GetChannelName: String; override;
    function GetInFormat: PWaveFormatEx; override;
    function GetOutFormat: PWaveFormatEx; override;
    procedure SetOutFormat(const Value: PWaveFormatEx); override;
    function GetInDataSize: Integer; override;
    function GetLocation: TBisCallServerChannelLocation; override;
    function GetVolume: Integer; override;
    function GetListenThread: TThread; override;

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Dial(Acceptor: Variant; AcceptorType: TBisCallServerChannelAcceptorType); override;
    procedure Answer; override;
    procedure Hangup; override;
    procedure Hold; override;
    procedure UnHold; override;
    procedure PlayStart(Stream: TStream; LoopCount: Integer=MaxInt); override;
    procedure PlayStop; override;
{    procedure SendStart; override;
    procedure SendStop; override;}
    procedure Send(const Data: Pointer; const DataSize: Cardinal); override;

    procedure InData(const Data: Pointer; const DataSize: Cardinal);
//    function OutData(const Data: Pointer; const DataSize: Cardinal): Boolean;

  end;

  TBisCallServerSipChannels=class(TBisCallServerChannels)
  private
    FHandler: TBisCallServerSipHandler;
    function GetItem(Index: Integer): TBisCallServerSipChannel;
  protected
     procedure DoDestroyChannel(Channel: TBisCallServerChannel); override;
  public
    function Find(Line: TBisSipPhoneLine): TBisCallServerSipChannel; reintroduce;
    function Add(Line: TBisSipPhoneLine; Direction: TBisCallServerChannelDirection; CallId: Variant): TBisCallServerSipChannel; reintroduce;
    function AddOutgoing(CallId, CallerId, CallerPhone: Variant): TBisCallServerSipChannel;
    function AddIncoming(Line: TBisSipPhoneLine): TBisCallServerSipChannel;

    property Items[Index: Integer]: TBisCallServerSipChannel read GetItem; default;
  end;

  TBisCallServerSipHandler=class(TBisCallServerHandler)
  private
    FPhone: TBisSipPhone;
    FSSendData: String;
    FSReceiveData: String;
    function GetChannels: TBisCallServerSipChannels;
    procedure PhoneSendData(Sender: TBisSipPhone; Host: String; Port: Integer; Data: String);
    procedure PhoneReceiveData(Sender: TBisSipPhone; Host: String; Port: Integer; Data: String);
    procedure PhoneError(Sender: TBisSipPhone; const Message: String);
    procedure PhoneLineCreate(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
    procedure PhoneLineDestroy(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
    function PhoneLineCheck(Sender: TBisSipPhone; Line: TBisSipPhoneLine): Boolean;
    procedure PhoneLineRing(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
    procedure PhoneLineConnect(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
    procedure PhoneLineDisconnect(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
    procedure PhoneLineInData(Sender: TBisSipPhone; Line: TBisSipPhoneLine; const Data: Pointer; const DataSize: Cardinal);
    procedure PhoneLineInExtraData(Sender: TBisSipPhone; Line: TBisSipPhoneLine; Packet: TBisRtpPacket; Rtmap: TBisSdpRtpmapAttr);
//    function PhoneLineOutData(Sender: TBisSipPhone; Line: TBisSipPhoneLine; const Data: Pointer; const DataSize: Cardinal): Boolean;
    procedure PhoneLineHold(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
    procedure PhoneLinePlayBegin(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
    procedure PhoneLinePlayEnd(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
    procedure PhoneLineTimeout(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
  protected
    function GetChannelsClass: TBisCallServerChannelsClass; override;
    function GetBusy: Boolean; override;
    function GetConnected: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Connect; override;
    procedure Disconnect; override;
    function AddOutgoingChannel(CallId,CallerId,CallerPhone: Variant): TBisCallServerChannel; override;

    property Channels: TBisCallServerSipChannels read GetChannels;

  published
    property SSendData: String read FSSendData write FSSendData;
    property SReceiveData: String read FSReceiveData write FSReceiveData;
  end;

procedure InitCallServerHandlerModule(AModule: TBisCallServerHandlerModule); stdcall;

exports
  InitCallServerHandlerModule;

implementation

uses SysUtils, Variants, DB,
     WaveUtils,
     BisCore, BisConsts, BisProvider, BisFilterGroups, BisUtils, BisConfig, BisLogger,
     BisCallServerSipHandlerConsts;

procedure InitCallServerHandlerModule(AModule: TBisCallServerHandlerModule); stdcall;
begin
  AModule.HandlerClass:=TBisCallServerSipHandler;
end;

{ TBisCallServerSipChannel }

constructor TBisCallServerSipChannel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLock:=TCriticalSection.Create;
//  FSendStream:=TMemoryStream.Create;
  FCreatorId:=Core.AccountId;
  FDateCreate:=Core.ServerDate;
  FCallId:=Null; 
  FCallerId:=Null;
  FCallerPhone:=Null;
end;

destructor TBisCallServerSipChannel.Destroy;
begin
  FLine:=nil;
//  FSendStream.Free;
  FLock.Free;
  inherited Destroy;
end;

function TBisCallServerSipChannel.GetActive: Boolean;
begin
  Result:=inherited GetActive;
  if Assigned(FLine) then
    Result:=FLine.Active;
end;

function TBisCallServerSipChannel.GetCallerPhone: Variant;
begin
  Result:=inherited GetCallerPhone;
  if Assigned(FLine) and (FLine.Direction=ldIncoming) then
    Result:=iff(FLine.Number<>'',FLine.Number,Null);
end;

function TBisCallServerSipChannel.GetChannelName: String;
begin
  Result:=inherited GetChannelName;
  if Assigned(FHandler) then
    Result:=Result+FHandler.FPhone.UserName;
end;

function TBisCallServerSipChannel.GetCreatorId: Variant;
begin
  Result:=FCreatorId;
end;

function TBisCallServerSipChannel.GetDateCreate: TDateTime;
begin
  Result:=FDateCreate;
end;

function TBisCallServerSipChannel.GetDirection: TBisCallServerChannelDirection;
begin
  Result:=inherited GetDirection;
  if Assigned(FLine) then begin
    case FLine.Direction of
      ldIncoming: Result:=cdIncoming;
      ldOutgoing: Result:=cdOutgoing;
    end;
  end else
    Result:=FDirection;
end;

function TBisCallServerSipChannel.GetInDataSize: Integer;
begin
  Result:=inherited GetInDataSize;
  if Assigned(FLine) then
    Result:=FLine.RemotePayloadLength;
end;

function TBisCallServerSipChannel.GetInFormat: PWaveFormatEx;
begin
  Result:=inherited GetInFormat;
  if Assigned(FLine) then
    Result:=FLine.InFormat;
end;

function TBisCallServerSipChannel.GetOutFormat: PWaveFormatEx;
begin
  Result:=FOutFormat;
end;

procedure TBisCallServerSipChannel.SetOutFormat(const Value: PWaveFormatEx);
begin
  FOutFormat:=Value;
end;

function TBisCallServerSipChannel.GetListenThread: TThread;
begin
  Result:=inherited GetListenThread;
  if Assigned(FLine) then
    Result:=FLine.ListenThread;
end;

function TBisCallServerSipChannel.GetLocation: TBisCallServerChannelLocation;
begin
  Result:=inherited GetLocation;
  if Assigned(FHandler) then begin
    case FHandler.Location of
      hlInternal: Result:=clInternal;
      hlExternal: Result:=clExternal;
    end;
  end;
end;

function TBisCallServerSipChannel.GetVolume: Integer;
begin
  Result:=inherited GetVolume;
  if Assigned(FHandler) then
    Result:=FHandler.Volume;
end;


procedure TBisCallServerSipChannel.Dial(Acceptor: Variant; AcceptorType: TBisCallServerChannelAcceptorType);
begin
  inherited Dial(Acceptor,AcceptorType);
  if Assigned(FLine) and not VarIsNull(Acceptor) and (AcceptorType=catPhone) then
    FLine.Dial(VarToStrDef(Acceptor,''));
end;

procedure TBisCallServerSipChannel.Answer;
begin
  inherited Answer;
  if Assigned(FLine) then
    FLine.Answer;
end;

procedure TBisCallServerSipChannel.Hangup;
begin
  inherited Hangup;
  if Assigned(FLine) then
    FLine.Hangup;
end;

procedure TBisCallServerSipChannel.Hold;
begin
  inherited Hold;
  if Assigned(FLine) then
    FLine.Hold;
end;

procedure TBisCallServerSipChannel.UnHold;
begin
  inherited UnHold;
  if Assigned(FLine) then
    FLine.UnHold;
end;

procedure TBisCallServerSipChannel.PlayStart(Stream: TStream; LoopCount: Integer);
begin
  inherited PlayStart(Stream,LoopCount);
  if Assigned(FLine) then
    FLine.PlayStart(Stream,LoopCount);
end;

procedure TBisCallServerSipChannel.PlayStop;
begin
  inherited PlayStop;
  if Assigned(FLine) then
    FLine.PlayStop;
end;

procedure TBisCallServerSipChannel.InData(const Data: Pointer; const DataSize: Cardinal);
begin
  DoData(Data,DataSize);
end;

{function TBisCallServerSipChannel.OutData(const Data: Pointer; const DataSize: Cardinal): Boolean;
var
  ASize: Cardinal;
  Temp: TMemoryStream;
begin
  FLock.Enter;
  try
    Result:=false;
    FSendStream.Position:=0;
    ASize:=FSendStream.Size;
    if ASize>=DataSize then begin
      FSendStream.Read(Data^,DataSize);
      ASize:=FSendStream.Size-FSendStream.Position;
      if ASize>0 then begin
        Temp:=TMemoryStream.Create;
        try
          Temp.CopyFrom(FSendStream,ASize);
          Temp.Position:=0;
          FSendStream.Clear;
          FSendStream.CopyFrom(Temp,ASize);
        finally
          Temp.Free;
        end;
      end else
        FSendStream.Clear;
      Result:=true;
    end;
  finally
    FLock.Leave;
  end;
end;}

procedure TBisCallServerSipChannel.Send(const Data: Pointer; const DataSize: Cardinal);
var
  Converter: TBisWaveConverter;
  L: Integer;
  D: TBytes;
begin
  FLock.Enter;
  try
    if Assigned(FLine) and Assigned(FLine.OutFormat) and Assigned(OutFormat) and not FLine.Playing then begin
      Converter:=TBisWaveConverter.Create;
      try
        Converter.BeginRewrite(OutFormat);
        Converter.Write(Data^,DataSize);
        Converter.EndRewrite;
        if Converter.ConvertTo(FLine.OutFormat) then begin
          Converter.Stream.Position:=Converter.DataOffset;
//          FSendStream.Position:=FSendStream.Size;
          L:=Converter.Stream.Size-Converter.Stream.Position;
//          FSendStream.CopyFrom(Converter.Stream,L);
          SetLength(D,L);
          Converter.Stream.Position:=Converter.DataOffset;
          Converter.Stream.Read(Pointer(D)^,L);
          FLine.SendData(D);
        end;
      finally
        Converter.Free;
      end;
    end;
  finally
    FLock.Leave;
  end;
end;

{procedure TBisCallServerSipChannel.SendStart;
begin
  inherited SendStart;
  if Assigned(FLine) then
    FLine.SendStart;
end;

procedure TBisCallServerSipChannel.SendStop;
begin
  inherited SendStop;
  if Assigned(FLine) then
    FLine.SendStop;
end;}

{ TBisCallServerSipChannels }

function TBisCallServerSipChannels.Add(Line: TBisSipPhoneLine; Direction: TBisCallServerChannelDirection; CallId: Variant): TBisCallServerSipChannel;
begin
  Result:=TBisCallServerSipChannel(AddClass(TBisCallServerSipChannel,false));
  if Assigned(Result) then begin
    Result.FCallId:=CallId;
    Result.FHandler:=FHandler;
    Result.FLine:=Line;
    Result.FDirection:=Direction;
  end;
end;

function TBisCallServerSipChannels.AddIncoming(Line: TBisSipPhoneLine): TBisCallServerSipChannel;
begin
  Result:=Add(Line,cdIncoming,Null);
  if Assigned(Result) then
    DoCreateChannel(Result);  
end;

function TBisCallServerSipChannels.AddOutgoing(CallId, CallerId, CallerPhone: Variant): TBisCallServerSipChannel;
begin
  Result:=Add(FHandler.FPhone.AddLine(ldOutgoing),cdOutgoing,CallId);
  if Assigned(Result) then begin
    Result.FCallerId:=CallerId;
    Result.FCallerPhone:=CallerPhone;
    DoCreateChannel(Result);
  end;
end;

function TBisCallServerSipChannels.Find(Line: TBisSipPhoneLine): TBisCallServerSipChannel;
var
  i: Integer;
  Item: TBisCallServerSipChannel;
begin
  Result:=nil;
  for i:=0 to Count-1 do begin
    Item:=Items[i];
    if Item.FLine=Line then begin
      Result:=Item;
      exit;
    end;
  end;
end;

function TBisCallServerSipChannels.GetItem(Index: Integer): TBisCallServerSipChannel;
begin
  Result:=TBisCallServerSipChannel(inherited Items[Index]);
end;

procedure TBisCallServerSipChannels.DoDestroyChannel(Channel: TBisCallServerChannel);
begin
  if Assigned(Channel) and (Channel is TBisCallServerSipChannel) and
     Assigned(TBisCallServerSipChannel(Channel).FLine) then begin

    TBisCallServerSipChannel(Channel).FLine.Hangup;
    FHandler.FPhone.Lines.Remove(TBisCallServerSipChannel(Channel).FLine);
    TBisCallServerSipChannel(Channel).FLine:=nil;

  end;
  inherited DoDestroyChannel(Channel);
end;

{ TBisCallServerSipHandler }

constructor TBisCallServerSipHandler.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Channels.FHandler:=Self;

  FPhone:=TBisSipPhone.Create(nil);
  FPhone.CollectInPackets:=false;
  FPhone.CollectOutPackets:=false;
  FPhone.OnSendData:=PhoneSendData;
  FPhone.OnReceiveData:=PhoneReceiveData;
  FPhone.OnError:=PhoneError;
  FPhone.OnLineCreate:=PhoneLineCreate;
  FPhone.OnLineDestroy:=PhoneLineDestroy;
  FPhone.OnLineCheck:=PhoneLineCheck;
  FPhone.OnLineRing:=PhoneLineRing;
  FPhone.OnLineConnect:=PhoneLineConnect;
  FPhone.OnLineDisconnect:=PhoneLineDisconnect;
  FPhone.OnLineInData:=PhoneLineInData;
  FPhone.OnLineInExtraData:=PhoneLineInExtraData;
//  FPhone.OnLineOutData:=PhoneLineOutData;
  FPhone.OnLineHold:=PhoneLineHold;
  FPhone.OnLinePlayBegin:=PhoneLinePlayBegin;
  FPhone.OnLinePlayEnd:=PhoneLinePlayEnd;
  FPhone.OnLineTimeout:=PhoneLineTimeout;

  FSSendData:='���������� ������ �� %s:%d => %s';
  FSReceiveData:='�������� ������ �� %s:%d => %s';
end;

destructor TBisCallServerSipHandler.Destroy;
begin
  FPhone.Free;
  inherited Destroy;
end;

function TBisCallServerSipHandler.GetBusy: Boolean;
begin
  Result:=FPhone.Busy;
end;

function TBisCallServerSipHandler.GetConnected: Boolean;
begin
  Result:=FPhone.Connected;
end;

function TBisCallServerSipHandler.GetChannels: TBisCallServerSipChannels;
begin
  Result:=TBisCallServerSipChannels(inherited Channels);
end;

function TBisCallServerSipHandler.GetChannelsClass: TBisCallServerChannelsClass;
begin
  Result:=TBisCallServerSipChannels;
end;

procedure TBisCallServerSipHandler.Init;
var
  N, V: String;
begin
  inherited Init;
  if Params.Active and not Params.Empty then begin
    Params.First;
    while not Params.Eof do begin
      N:=Params.FieldByName(SFieldName).AsString;
      V:=Params.FieldByName(SFieldValue).AsString;

      if AnsiSameText(N,SParamScheme) then FPhone.Scheme:=V;
      if AnsiSameText(N,SParamProtocol) then FPhone.Protocol:=V;
      if AnsiSameText(N,SParamUserName) then FPhone.UserName:=V;
      if AnsiSameText(N,SParamPassword) then FPhone.Password:=V;
      if AnsiSameText(N,SParamRemoteHost) then FPhone.RemoteHost:=V;
      if AnsiSameText(N,SParamRemotePort) then FPhone.RemotePort:=StrToIntDef(V,FPhone.RemotePort);
      if AnsiSameText(N,SParamLocalHost) then FPhone.LocalHost:=V;
      if AnsiSameText(N,SParamLocalPort) then FPhone.LocalPort:=StrToIntDef(V,FPhone.LocalPort);
      if AnsiSameText(N,SParamUserAgent) then FPhone.UserAgent:=V;
      if AnsiSameText(N,SParamExpires) then FPhone.Expires:=StrToIntDef(V,FPhone.Expires);
      if AnsiSameText(N,SParamMaxForwards) then FPhone.MaxForwards:=StrToIntDef(V,FPhone.MaxForwards);
      if AnsiSameText(N,SParamMaxLines) then FPhone.MaxLines:=StrToIntDef(V,FPhone.MaxLines);
      if AnsiSameText(N,SParamKeepAlive) then FPhone.KeepAlive:=StrToIntDef(V,FPhone.KeepAlive);
      if AnsiSameText(N,SParamUseReceived) then FPhone.UseReceived:=Boolean(StrToIntDef(V,Integer(FPhone.UseReceived)));
      if AnsiSameText(N,SParamUseRport) then FPhone.UseRport:=Boolean(StrToIntDef(V,Integer(FPhone.UseRport)));
      if AnsiSameText(N,SParamUseTrasnportNameInUri) then FPhone.UseTrasnportNameInUri:=Boolean(StrToIntDef(V,Integer(FPhone.UseTrasnportNameInUri)));
      if AnsiSameText(N,SParamUsePortInUri) then FPhone.UsePortInUri:=Boolean(StrToIntDef(V,Integer(FPhone.UsePortInUri)));
//      if AnsiSameText(N,SParamUseGlobalSequence) then FPhone.UseGlobalSequence:=Boolean(StrToIntDef(V,Integer(FPhone.UseGlobalSequence)));
      if AnsiSameText(N,SParamRequestRetryCount) then FPhone.RequestRetryCount:=StrToIntDef(V,FPhone.RequestRetryCount);
      if AnsiSameText(N,SParamRequestTimeOut) then FPhone.RequestTimeOut:=StrToIntDef(V,FPhone.RequestTimeOut);
      if AnsiSameText(N,SParamIdleTimeOut) then FPhone.LineIdleTimeOut:=StrToIntDef(V,FPhone.LineIdleTimeOut);
      if AnsiSameText(N,SParamDataPort) then FPhone.LineLocalPort:=StrToIntDef(V,FPhone.LineLocalPort);
      if AnsiSameText(N,SParamAudioDriverName) then FPhone.LineDriverName:=V;
      if AnsiSameText(N,SParamAudioFormatName) then FPhone.LineFormatName:=V;
      if AnsiSameText(N,SParamAudioChannels) then FPhone.LineChannels:=StrToIntDef(V,FPhone.LineChannels);
      if AnsiSameText(N,SParamAudioSamplesPerSec) then FPhone.LineSamplesPerSec:=StrToIntDef(V,FPhone.LineSamplesPerSec);
      if AnsiSameText(N,SParamAudioBitsPerSample) then FPhone.LineBitsPerSample:=StrToIntDef(V,FPhone.LineBitsPerSample);
      if AnsiSameText(N,SParamConfirmCount) then FPhone.LineConfirmCount:=StrToIntDef(V,FPhone.LineConfirmCount);
      if AnsiSameText(N,SParamHoldMode) then FPhone.LineHoldMode:=TBisSipPhoneLineHoldMode(StrToIntDef(V,Integer(FPhone.LineHoldMode)));

      Params.Next;
    end;
  end;
end;

procedure TBisCallServerSipHandler.PhoneSendData(Sender: TBisSipPhone; Host: String; Port: Integer; Data: String);
var
  S: String;
begin
  S:=Data;
  if Trim(S)='' then
    S:=VisibleControlCharacters(S);
  S:=Trim(S);  
  LoggerWrite(FormatEx(FSSendData,[Host,Port,S]));
end;

procedure TBisCallServerSipHandler.PhoneReceiveData(Sender: TBisSipPhone; Host: String; Port: Integer; Data: String);
var
  S: String;
begin
  S:=Data;
  if Trim(S)='' then
    S:=VisibleControlCharacters(S);
  S:=Trim(S);
  LoggerWrite(FormatEx(FSReceiveData,[Host,Port,S]));
end;

procedure TBisCallServerSipHandler.PhoneLineCreate(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
begin
  if Assigned(Line) then begin
    case Line.Direction of
      ldIncoming: Channels.AddIncoming(Line);
      ldOutgoing: ;
    end;
  end;
end;

procedure TBisCallServerSipHandler.PhoneLineDestroy(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
var
  Channel: TBisCallServerSipChannel;
begin
  Channel:=Channels.Find(Line);
  if Assigned(Channel) then
    Channels.Remove(Channel);
end;

procedure TBisCallServerSipHandler.PhoneError(Sender: TBisSipPhone; const Message: String);
begin
  LoggerWrite(Message,ltError);
end;

function TBisCallServerSipHandler.PhoneLineCheck(Sender: TBisSipPhone; Line: TBisSipPhoneLine): Boolean;
var
  Channel: TBisCallServerSipChannel;
begin
  Result:=false;
  Channel:=Channels.Find(Line);
  if Assigned(Channel) then begin
    case Line.Direction of
      ldIncoming: Result:=Channel.DoCheck;
      ldOutgoing: Result:=Channel.DoCheck;
    end;
  end;
end;

procedure TBisCallServerSipHandler.PhoneLineRing(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
var
  Channel: TBisCallServerSipChannel;
begin
  Channel:=Channels.Find(Line);
  if Assigned(Channel) then
    Channel.DoRing;
end;

procedure TBisCallServerSipHandler.PhoneLineConnect(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
var
  Channel: TBisCallServerSipChannel;
begin
  Channel:=Channels.Find(Line);
  if Assigned(Channel) then
    Channel.DoConnect;
end;

procedure TBisCallServerSipHandler.PhoneLineDisconnect(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
var
  Channel: TBisCallServerSipChannel;
begin
  Channel:=Channels.Find(Line);
  if Assigned(Channel) then begin
    Channel.DoDisconnect;
  end;
end;

procedure TBisCallServerSipHandler.PhoneLineInData(Sender: TBisSipPhone; Line: TBisSipPhoneLine;
                                                   const Data: Pointer; const DataSize: Cardinal);
var
  Channel: TBisCallServerSipChannel;
begin
  Channel:=Channels.Find(Line);
  if Assigned(Channel) then
    Channel.InData(Data,DataSize);
end;

procedure TBisCallServerSipHandler.PhoneLineInExtraData(Sender: TBisSipPhone; Line: TBisSipPhoneLine;
                                                        Packet: TBisRtpPacket; Rtmap: TBisSdpRtpmapAttr);
var
  D: TBytes;
  Event: Byte;
  Code: Char;
  S: String;
  Channel: TBisCallServerSipChannel;
begin
  Channel:=Channels.Find(Line);
  if Assigned(Channel) and Assigned(Packet) and Assigned(Rtmap) then begin
    case Rtmap.EncodingType of
      retTelephoneEvent: begin
        D:=Packet.Payload;
        if Length(D)>0 then begin
          Event:=D[0];
          S:=IntToStr(Event);
          if Length(S)>0 then begin
            Code:=S[1];
            case Event of
              10: Code:='*';
              11: Code:='#';
              12: Code:='A';
              13: Code:='B';
              14: Code:='C';
              15: Code:='D';
            end;
            Channel.DoCode(Code);
          end;
        end;
      end;
    end;
  end;
end;

{function TBisCallServerSipHandler.PhoneLineOutData(Sender: TBisSipPhone; Line: TBisSipPhoneLine;
                                                   const Data: Pointer; const DataSize: Cardinal): Boolean;
var
  Channel: TBisCallServerSipChannel;
begin
  Result:=false;
  Channel:=Channels.Find(Line);
  if Assigned(Channel) then
    Result:=Channel.OutData(Data,DataSize);
end;}

procedure TBisCallServerSipHandler.PhoneLineHold(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
var
  Channel: TBisCallServerSipChannel;
begin
  Channel:=Channels.Find(Line);
  if Assigned(Channel) then
    Channel.DoHold;
end;

procedure TBisCallServerSipHandler.PhoneLinePlayBegin(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
var
  Channel: TBisCallServerSipChannel;
begin
  Channel:=Channels.Find(Line);
  if Assigned(Channel) then
    Channel.DoPlayBegin;
end;

procedure TBisCallServerSipHandler.PhoneLinePlayEnd(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
var
  Channel: TBisCallServerSipChannel;
begin
  Channel:=Channels.Find(Line);
  if Assigned(Channel) then
    Channel.DoPlayEnd;
end;

procedure TBisCallServerSipHandler.PhoneLineTimeout(Sender: TBisSipPhone; Line: TBisSipPhoneLine);
var
  Channel: TBisCallServerSipChannel;
begin
  Channel:=Channels.Find(Line);
  if Assigned(Channel) then
    Channel.DoTimeout;
end;

function TBisCallServerSipHandler.AddOutgoingChannel(CallId, CallerId, CallerPhone: Variant): TBisCallServerChannel;
begin
  Result:=Channels.AddOutgoing(CallId,CallerId,CallerPhone);
end;

procedure TBisCallServerSipHandler.Connect;
begin
  inherited Connect;
  FPhone.Connect;
end;

procedure TBisCallServerSipHandler.Disconnect;
begin
  FPhone.Disconnect;
  inherited Disconnect;
end;

end.