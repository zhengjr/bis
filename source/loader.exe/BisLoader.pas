unit BisLoader;

interface

procedure InitLoader;

var
  ConfigFileName: String='';
  CheckUpdate: Boolean=true;

implementation

uses Windows, Classes, SysUtils, ComServ, XPMan,
     BisObject, BisLoaderCmdLine, BisLoaderResource, BisLoaderUpdate,
     BisCoreIntf;

const
  SParamCore='core';
  SParamInfo='info';
  SParamNoUpdate='noupdate';
  SInfoFile='info.hex';
  SCoreFile='core.bpl';
  SUpdateFile='update.exe';
  SClassCore='TBisCore';
  SBisInfo='BISINFO';
  SBisCryptInfo='TBISCRYPTINFO';

var
  FCmdLine: TBisLoaderCmdLine=nil;
  FClassCore: TBisObjectClass=nil;

function ExpandFileNameEx(FileName: String): String;
var
  Dir: String;
  ModuleName: String;
begin
  Result:=ExpandFileName(FileName);
  ModuleName:=GetModuleName(HInstance);
  Dir:=ExtractFileDir(ModuleName);
  if SetCurrentDir(Dir) then
    Result:=ExpandFileName(FileName);
end;

function PrepareFileName(FileName,Param: string): String;
begin
  Result:=ExpandFileNameEx(FileName);
  if FCmdLine.ParamExists(Param) then begin
    Result:=FCmdLine.ValueByParam(Param);
  end;
  Result:=ExpandFileNameEx(Result);
end;

function Update: Boolean;
var
  Flag: Boolean;
  UpdateFileName: String;
begin
  Result:=false;
  if CheckUpdate then begin
    Flag:=not FCmdLine.ParamExists(SParamNoUpdate);
    if Flag then begin
      UpdateFileName:=ExpandFileNameEx(SUpdateFile);
      if FileExists(UpdateFileName) then
        Result:=UpdateFiles(FCmdLine.Text,UpdateFileName);
    end;
  end;
end;

function UpdateInfo: Boolean;
var
  InfoFileName: String;
  CoreFileName: String;
  Flag: Boolean;
begin
  Result:=FCmdLine.ParamExists(SParamInfo);
  CoreFileName:=PrepareFileName(SCoreFile,SParamCore);
  InfoFileName:=PrepareFileName(SInfoFile,SParamInfo);
  Flag:=FCmdLine.ParamExists(SParamInfo);
  if FileExists(CoreFileName) and FileExists(InfoFileName) and Flag then
    UpdateResource(SBisInfo,SBisCryptInfo,CoreFileName,InfoFileName);
end;

function LoadCore: Boolean;
var
  Package: HMODULE;
  FileName: String;
begin
  Result:=false;
  FileName:=PrepareFileName(SCoreFile,SParamCore);
  if FileExists(FileName) then begin
    Package:=LoadPackage(FileName);
    if Package<>0 then begin
      FClassCore:=TBisObjectClass(GetClass(SClassCore));
      Result:=Assigned(FClassCore);
    end;
  end;
end;

procedure InitLoader;
var
  Core: IBisCore;
  CoreObject: TBisObject;
begin
  if not Update then
    if not UpdateInfo and LoadCore then begin
      CoreObject:=FClassCore.Create(nil);
      try
        Core:=CoreObject as IBisCore;
        if Assigned(Core) then begin
          Core.ConfigFileName:=ConfigFileName;
          Core.Init;
          if Core.Inited then begin
            try
              case ComServer.StartMode of
                ComServ.smStandalone: Core.RunStandalone;
                ComServ.smAutomation: Core.RunAutomation;
                ComServ.smRegServer: Core.RunRegserver;
                ComServ.smUnregServer: Core.RunUnregserver;
              end;
            finally
              Core.Done;
            end;
          end;
        end;
      finally
        CoreObject.Free;
      end;
    end;
end;

initialization
  FCmdLine:=TBisLoaderCmdLine.Create;

finalization
  FCmdLine.Free;
  
end.
