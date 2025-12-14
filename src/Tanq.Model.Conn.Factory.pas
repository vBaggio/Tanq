unit Tanq.Model.Conn.Factory;

interface

uses
  Tanq.Model.Conn.Interfaces;

type
  TDbConnectionFactory = class
  strict private
    class var FDefault: IDbConnection;
  public
    class function Default: IDbConnection;
  end;

implementation

uses
  Tanq.Model.Conn.Firebird;

{ TDbConnectionFactory }

class function TDbConnectionFactory.Default: IDbConnection;
begin
  if not Assigned(FDefault) then
  begin
    FDefault := TFirebirdConnection.Create;
  end;
  Result := FDefault;
end;

end.
