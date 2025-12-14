unit Tanq.Model.Repository.Reposicao;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  FireDAC.Comp.Client, FireDAC.Stan.Param,
  Tanq.Model.Conn.Interfaces,
  Tanq.Model.Repository.Interfaces,
  Tanq.Model.Entity.Reposicao;

type
  TReposicaoRepository = class(TInterfacedObject, IReposicaoRepository)
  private
    [weak] FConnection: IDbConnection;
    function MapReposicao(const AQuery: TFDQuery): TReposicao;
  public
    constructor Create(const AConnection: IDbConnection);
    function FindAll: TObjectList<TReposicao>;
    function FindById(const AId: Int64): TReposicao;
    function Save(AEntity: TReposicao): TReposicao;
  end;

implementation

{ TReposicaoRepository }

constructor TReposicaoRepository.Create(const AConnection: IDbConnection);
begin
  inherited Create;
  FConnection := AConnection;
end;

function TReposicaoRepository.MapReposicao(const AQuery: TFDQuery): TReposicao;
begin
  Result := TReposicao.Create;
  Result.Id := AQuery.FieldByName('ID').AsLargeInt;
  Result.DataHora := AQuery.FieldByName('DATAHORA').AsDateTime;
  Result.CombustivelId := AQuery.FieldByName('COMBUSTIVELID').AsLargeInt;
  Result.TanqueId := AQuery.FieldByName('TANQUEID').AsLargeInt;
  Result.Quantidade := AQuery.FieldByName('QUANTIDADE').AsFloat;
  Result.UsuarioId := AQuery.FieldByName('USUARIOID').AsLargeInt;
  Result.Observacao := AQuery.FieldByName('OBSERVACAO').AsString;
end;

function TReposicaoRepository.FindAll: TObjectList<TReposicao>;
begin
  Result := TObjectList<TReposicao>.Create(True);
  var LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection.GetConn;
    LQuery.SQL.Text := 'SELECT * FROM REPOSICAO ORDER BY DATAHORA DESC ';
    LQuery.Open;

    while not LQuery.Eof do
    begin
      Result.Add(MapReposicao(LQuery));
      LQuery.Next;
    end;
  finally
    LQuery.Free;
  end;
end;

function TReposicaoRepository.FindById(const AId: Int64): TReposicao;
begin
  Result := nil;
  var LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection.GetConn;
    LQuery.SQL.Text :='SELECT * FROM REPOSICAO WHERE ID = :ID ';
    LQuery.ParamByName('ID').AsLargeInt := AId;
    LQuery.Open;

    if LQuery.RecordCount > 0 then
      Result := MapReposicao(LQuery);
  finally
    LQuery.Free;
  end;
end;

function TReposicaoRepository.Save(AEntity: TReposicao): TReposicao;
begin
  if not Assigned(AEntity) then
    raise Exception.Create('Entity não pode ser nil');

  var LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection.GetConn;
    if AEntity.Id = 0 then
    begin
      LQuery.SQL.Text :=
        'INSERT INTO REPOSICAO (DATAHORA, COMBUSTIVELID, TANQUEID, QUANTIDADE, USUARIOID, OBSERVACAO) ' +
        'VALUES (:DATAHORA, :COMBUSTIVELID, :TANQUEID, :QUANTIDADE, :USUARIOID, :OBSERVACAO) RETURNING ID ';

      LQuery.ParamByName('DATAHORA').AsDateTime := AEntity.DataHora;
      LQuery.ParamByName('COMBUSTIVELID').AsLargeInt := AEntity.CombustivelId;
      LQuery.ParamByName('TANQUEID').AsLargeInt := AEntity.TanqueId;
      LQuery.ParamByName('QUANTIDADE').AsFloat := AEntity.Quantidade;
      LQuery.ParamByName('USUARIOID').AsLargeInt := AEntity.UsuarioId;
      LQuery.ParamByName('OBSERVACAO').AsString := AEntity.Observacao;

      LQuery.Open;
      if LQuery.RecordCount > 0 then
        AEntity.Id := LQuery.FieldByName('ID').AsLargeInt;
    end
    else
    begin
      LQuery.SQL.Text :=
        'UPDATE REPOSICAO SET DATAHORA = :DATAHORA, COMBUSTIVELID = :COMBUSTIVELID, TANQUEID = :TANQUEID, QUANTIDADE = :QUANTIDADE, '+
        'USUARIOID = :USUARIOID, OBSERVACAO = :OBSERVACAO WHERE ID = :ID';

      LQuery.ParamByName('DATAHORA').AsDateTime := AEntity.DataHora;
      LQuery.ParamByName('COMBUSTIVELID').AsLargeInt := AEntity.CombustivelId;
      LQuery.ParamByName('TANQUEID').AsLargeInt := AEntity.TanqueId;
      LQuery.ParamByName('QUANTIDADE').AsFloat := AEntity.Quantidade;
      LQuery.ParamByName('USUARIOID').AsLargeInt := AEntity.UsuarioId;
      LQuery.ParamByName('OBSERVACAO').AsString := AEntity.Observacao;
      LQuery.ParamByName('ID').AsLargeInt := AEntity.Id;

      LQuery.ExecSQL;
    end;

    Result := AEntity;
  finally
    LQuery.Free;
  end;
end;

end.
