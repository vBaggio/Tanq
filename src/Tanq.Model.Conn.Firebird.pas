unit Tanq.Model.Conn.Firebird;

interface

uses
  FireDAC.Comp.Client, FireDAC.Stan.Def, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.Phys.Intf,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.VCLUI.Wait,
  Tanq.Model.Conn.Interfaces;

type
  TFirebirdConnection = class(TInterfacedObject, IDbConnection)
  strict private
    FConnection: TFDConnection;
    FDriverLink: TFDPhysFBDriverLink;
    procedure ConfigureParams;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IDbConnection;

    function GetConn: TFDConnection;
    function Test: Boolean;
    procedure BeginTransaction;
    procedure EnsureTransaction;
    procedure Commit;
    procedure Rollback;
    function InTransaction: Boolean;
  end;

implementation

uses
  System.SysUtils, System.IOUtils,
  Tanq.Model.Service.ConfigLoader;

{ TFirebirdConnection }

constructor TFirebirdConnection.Create;
begin
  //cofigura driver para usar fbclient.dll do diretório do .exe
  FDriverLink := TFDPhysFBDriverLink.Create(nil);
  FDriverLink.DriverID := 'FB';
  var LDLLPath := TPath.Combine(ExtractFilePath(ParamStr(0)), 'fbclient.dll');
  if not TFile.Exists(LDLLPath) then
    raise Exception.CreateFmt('fbclient.dll não encontrado em %s', [LDLLPath]);
  FDriverLink.VendorLib := LDLLPath;

  //configura conexão
  FConnection := TFDConnection.Create(nil);
  FConnection.LoginPrompt := False;
  FConnection.ResourceOptions.AutoReconnect := True;
end;

destructor TFirebirdConnection.Destroy;
begin
  FConnection.Free;
  FDriverLink.Free;
  inherited;
end;

procedure TFirebirdConnection.ConfigureParams;
begin
  ReloadConfig;

  FConnection.DriverName := 'FB';
  with FConnection.Params do
  begin
    Clear;
    Add('DriverID=FB');
    Add('Database=' + Config.Database.ResolveDatabasePath);
    Add('Server=' + Config.Database.Host);
    Add('Port=' + IntToStr(Config.Database.Port));
    Add('User_Name=' + Config.Database.Username);
    Add('Password=' + Config.Database.Password);
    Add('Protocol=TCPIP');
    Add('CharacterSet=UTF8');
  end;
end;

function TFirebirdConnection.GetConn: TFDConnection;
begin
  if FConnection.Connected then
    Exit(FConnection);

  ConfigureParams;

  FConnection.Connected := True;

  Result := FConnection;
end;

class function TFirebirdConnection.New: IDbConnection;
begin
  Result := Self.Create;
end;

function TFirebirdConnection.Test: Boolean;
begin
  try
    Self.GetConn;
    Result := FConnection.Connected ;
  except
    Result := False ;
  end;
end;

procedure TFirebirdConnection.BeginTransaction;
begin
  GetConn.StartTransaction;
end;

procedure TFirebirdConnection.EnsureTransaction;
begin
  if not InTransaction then
    BeginTransaction;
end;

procedure TFirebirdConnection.Commit;
begin
  if InTransaction then
    FConnection.Commit;
end;

procedure TFirebirdConnection.Rollback;
begin
  if InTransaction then
    FConnection.Rollback;
end;

function TFirebirdConnection.InTransaction: Boolean;
begin
  Result := Assigned(FConnection) and FConnection.InTransaction;
end;

end.
