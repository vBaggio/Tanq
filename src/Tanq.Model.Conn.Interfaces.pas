unit Tanq.Model.Conn.Interfaces;

interface

uses
  FireDAC.Comp.Client;

type
  IDbConnection = interface
    ['{2492B380-6589-494E-9944-5DCB60A46AED}']
    function GetConn: TFDConnection;
    function Test: Boolean;
    procedure BeginTransaction;
    procedure EnsureTransaction;
    procedure Commit;
    procedure Rollback;
    function InTransaction: Boolean;
  end;

implementation

end.
