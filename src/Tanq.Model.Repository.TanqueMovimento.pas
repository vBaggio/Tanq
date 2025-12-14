unit Tanq.Model.Repository.TanqueMovimento;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client, FireDAC.Stan.Param,
  Tanq.Model.Conn.Interfaces,
  Tanq.Model.Repository.Interfaces,
  Tanq.Model.Entity.TanqueMovimento;

type
  TTanqueMovimentoRepository = class(TInterfacedObject, ITanqueMovimentoRepository)
  private
    [weak] FConnection: IDbConnection;
  public
    constructor Create(const AConnection: IDbConnection);
    function Save(const AMov: TTanqueMovimento): TTanqueMovimento;
  end;

implementation

{ TTanqueMovimentoRepository }

constructor TTanqueMovimentoRepository.Create(const AConnection: IDbConnection);
begin
  inherited Create;
  FConnection := AConnection;
end;

function TTanqueMovimentoRepository.Save(const AMov: TTanqueMovimento): TTanqueMovimento;
begin
  if not Assigned(AMov) then
    raise Exception.Create('Movimento não informado.');

  var LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection.GetConn;
    LQuery.SQL.Text :=
      'INSERT INTO TANQUE_MOVIMENTO (DATAHORA, TANQUEID, COMBUSTIVELID, USUARIOID, TIPOMOVIMENTO, QUANTIDADE, ORIGEMTIPO, ORIGEMID, OBSERVACAO) ' +
      'VALUES (:DATAHORA, :TANQUEID, :COMBUSTIVELID, :USUARIOID, :TIPOMOVIMENTO, :QUANTIDADE, :ORIGEMTIPO, :ORIGEMID, :OBSERVACAO) RETURNING ID ';

    LQuery.ParamByName('DATAHORA').AsDateTime := AMov.DataHora;
    LQuery.ParamByName('TANQUEID').AsLargeInt := AMov.TanqueId;
    LQuery.ParamByName('COMBUSTIVELID').AsLargeInt := AMov.CombustivelId;
    LQuery.ParamByName('USUARIOID').AsLargeInt := AMov.UsuarioId;
    LQuery.ParamByName('TIPOMOVIMENTO').AsSmallInt := AMov.TipoMovimento;
    LQuery.ParamByName('QUANTIDADE').AsFloat := AMov.Quantidade;
    LQuery.ParamByName('ORIGEMTIPO').AsString := AMov.OrigemTipo;
    LQuery.ParamByName('ORIGEMID').AsLargeInt := AMov.OrigemId;
    LQuery.ParamByName('OBSERVACAO').AsString := AMov.Observacao;

    LQuery.Open;
    if LQuery.RecordCount > 0 then
      AMov.Id := LQuery.FieldByName('ID').AsLargeInt;

    Result := AMov;
  finally
    LQuery.Free;
  end;
end;

end.
