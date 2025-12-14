unit Tanq.Model.Service.ConfigLoader;

interface

uses
  Tanq.Model.Config;

type
  TConfigLoader = class
  private
    class function IniPath: string;
    class procedure EnsureConfigExists;
    class procedure SaveDefaultConfig;
  public
    class function Load: TConfig;
    class procedure Save(const AConfig: TConfig);
  end;

function Config: TConfig;
procedure ReloadConfig;

implementation

uses
  System.SysUtils,
  System.IOUtils,
  System.IniFiles;

var
  GConfig: TConfig;

function Config: TConfig;
begin
  if not Assigned(GConfig) then
    ReloadConfig;

  Result := GConfig;
end;

procedure ReloadConfig;
begin
  if Assigned(GConfig) then
    FreeAndNil(GConfig);

  GConfig := TConfigLoader.Load;
end;

class function TConfigLoader.IniPath: string;
begin
  Result := ChangeFileExt(IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + ExtractFileName(ParamStr(0)), '.ini');
end;

class procedure TConfigLoader.EnsureConfigExists;
begin
  if TFile.Exists(IniPath) then
    Exit;

  SaveDefaultConfig;
end;

class procedure TConfigLoader.SaveDefaultConfig;
begin
  var LConfig := TConfig.Create;
  try
    Save(LConfig);
  finally
    LConfig.Free;
  end;
end;

class function TConfigLoader.Load: TConfig;
begin
  EnsureConfigExists;

  Result := TConfig.Create;
  var LIni := TMemIniFile.Create(IniPath);
  try
    var LDatabase := Result.Database;
    LDatabase.Host := LIni.ReadString('Database', 'host', LDatabase.Host);
    LDatabase.Port := LIni.ReadInteger('Database', 'port', LDatabase.Port);
    LDatabase.Database := LIni.ReadString('Database', 'database', LDatabase.Database);
    LDatabase.UserName := LIni.ReadString('Database', 'username', LDatabase.UserName);
    LDatabase.Password := LIni.ReadString('Database', 'password', LDatabase.Password);
    Result.Database := LDatabase;
  finally
    FreeandNil(LIni);
  end;
end;

class procedure TConfigLoader.Save(const AConfig: TConfig);
begin
  if not Assigned(AConfig) then
    Exit;

  var LIni := TMemIniFile.Create(IniPath);
  try
    LIni.WriteString('Database', 'host', AConfig.Database.Host);
    LIni.WriteInteger('Database', 'port', AConfig.Database.Port);
    LIni.WriteString('Database', 'database', AConfig.Database.Database);
    LIni.WriteString('Database', 'username', AConfig.Database.UserName);
    LIni.WriteString('Database', 'password', AConfig.Database.Password);
    LIni.UpdateFile;
  finally
    FreeandNil(LIni);
  end;
end;

initialization
  ReloadConfig;

finalization
  if Assigned(GConfig) then
    FreeAndNil(GConfig);

end.
