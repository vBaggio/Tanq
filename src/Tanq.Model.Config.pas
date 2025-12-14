unit Tanq.Model.Config;

interface

uses
  System.SysUtils;

type
  TConfigDatabase = record
  public
    Host: string;
    Port: Integer;
    Database: string;
    UserName: string;
    Password: string;

    function IsConfigured: Boolean;
    function IsAlias: Boolean;
    function IsPath: Boolean;
    function ResolveDatabasePath(const ABaseDir: string = ''): string;
    function IsLocalhost: Boolean;
    class function Default: TConfigDatabase; static;
  end;

  TConfig = class
  private
    FDatabase: TConfigDatabase;
  public
    constructor Create;
    procedure ApplyDefaults;
    procedure Assign(const ASource: TConfig);
    function Clone: TConfig;

    property Database: TConfigDatabase read FDatabase write FDatabase;
  end;

implementation

uses
  System.IOUtils,
  System.StrUtils;

{ TConfigDatabase }

class function TConfigDatabase.Default: TConfigDatabase;
begin
  Result.Host := '127.0.0.1';
  Result.Port := 3050;
  Result.Database := '';
  Result.UserName := 'SYSDBA';
  Result.Password := 'masterkey';
end;

function TConfigDatabase.IsConfigured: Boolean;
begin
  Result := (Host.Trim <> '') and (Trim(Database) <> '') and (Trim(UserName) <> '');
end;

function TConfigDatabase.IsPath: Boolean;
begin
  Result := not IsAlias;
end;

function TConfigDatabase.IsAlias: Boolean;
var
  LValue: string;
begin
  LValue := Trim(Database);
  Result := (LValue <> '') and
            (Pos(':', LValue) = 0) and
            (Pos('\', LValue) = 0) and
            (Pos('/', LValue) = 0) and
            (Pos('.', LValue) = 0);
end;

function TConfigDatabase.ResolveDatabasePath(const ABaseDir: string): string;
var
  LValue: string;
  LBase: string;
  LDefaultName: string;
begin
  LValue := Trim(Database);

  if IsAlias then
    Exit(LValue);

  if ABaseDir = '' then
    LBase := ExtractFilePath(ParamStr(0))
  else
    LBase := ABaseDir;

  if LValue = '' then
  begin
    LDefaultName := ChangeFileExt(ExtractFileName(ParamStr(0)), '.fdb');
    Exit(TPath.GetFullPath(TPath.Combine(LBase, LDefaultName)));
  end;

  if TPath.IsPathRooted(LValue) then
    Result := TPath.GetFullPath(LValue)
  else
    Result := TPath.GetFullPath(TPath.Combine(LBase, LValue));
end;

function TConfigDatabase.IsLocalhost: Boolean;
begin
  var LHost := Trim(Host);
  Result := (LHost.IsEmpty) or LHost.Equals('localhost') or LHost.Equals('127.0.0.1');
end;

{ TConfig }

procedure TConfig.ApplyDefaults;
begin
  FDatabase := TConfigDatabase.Default;
end;

constructor TConfig.Create;
begin
  inherited Create;
  ApplyDefaults;
end;

procedure TConfig.Assign(const ASource: TConfig);
begin
  if not Assigned(ASource) then
    Exit;
  FDatabase := ASource.Database;
end;

function TConfig.Clone: TConfig;
begin
  Result := TConfig.Create;
  Result.Assign(Self);
end;

end.
