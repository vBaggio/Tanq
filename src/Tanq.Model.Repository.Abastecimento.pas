unit Tanq.Model.Repository.Abastecimento;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  FireDAC.Comp.Client, FireDAC.Stan.Param,
  Tanq.Model.Conn.Interfaces,
  Tanq.Model.Repository.Interfaces,
  Tanq.Model.Entity.Abastecimento;

type
  TAbastecimentoRepository = class(TInterfacedObject, IAbastecimentoRepository)
  private
    [weak] FConnection: IDbConnection;
    function MapAbastecimento(const AQuery: TFDQuery): TAbastecimento;
  public
    constructor Create(const AConnection: IDbConnection);
    function FindAll: TObjectList<TAbastecimento>;
    function FindById(const AId: Int64): TAbastecimento;
    function Save(AEntity: TAbastecimento): TAbastecimento;
  end;

implementation

{ TAbastecimentoRepository }

constructor TAbastecimentoRepository.Create(const AConnection: IDbConnection);
begin
  inherited Create;
  FConnection := AConnection;
end;

function TAbastecimentoRepository.MapAbastecimento(const AQuery: TFDQuery): TAbastecimento;
begin
  Result := TAbastecimento.Create;
  Result.Id := AQuery.FieldByName('ID').AsLargeInt;
  Result.DataHora := AQuery.FieldByName('DATAHORA').AsDateTime;
  Result.Quantidade := AQuery.FieldByName('QUANTIDADE').AsFloat;
  Result.ValorUnitario := AQuery.FieldByName('VALORUN').AsCurrency;
  Result.Aliquota := AQuery.FieldByName('ALIQ').AsFloat;
  Result.ValorTotal := AQuery.FieldByName('VALORTOT').AsCurrency;
  Result.CombustivelId := AQuery.FieldByName('COMBUSTIVELID').AsLargeInt;
  Result.UsuarioId := AQuery.FieldByName('USUARIOID').AsLargeInt;
  Result.BombaId := AQuery.FieldByName('BOMBAID').AsLargeInt;
  Result.TanqueId := AQuery.FieldByName('TANQUEID').AsLargeInt;
end;

function TAbastecimentoRepository.FindAll: TObjectList<TAbastecimento>;
begin
  Result := TObjectList<TAbastecimento>.Create(True);
  var LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection.GetConn;
    LQuery.SQL.Text := 'SELECT * FROM ABASTECIMENTO ORDER BY DATAHORA DESC';
    LQuery.Open;

    while not LQuery.Eof do
    begin
      Result.Add(MapAbastecimento(LQuery));
      LQuery.Next;
    end;
  finally
    LQuery.Free;
  end;
end;

function TAbastecimentoRepository.FindById(const AId: Int64): TAbastecimento;
begin
  Result := nil;
  var LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection.GetConn;
    LQuery.SQL.Text := 'SELECT * FROM ABASTECIMENTO WHERE ID = :ID';
    LQuery.ParamByName('ID').AsLargeInt := AId;
    LQuery.Open;

    if LQuery.RecordCount > 0 then
      Result := MapAbastecimento(LQuery);
  finally
    LQuery.Free;
  end;
end;

function TAbastecimentoRepository.Save(AEntity: TAbastecimento): TAbastecimento;
begin
  if not Assigned(AEntity) then
    raise Exception.Create('Entity não pode ser nil');

  var LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection.GetConn;
    if AEntity.Id = 0 then
    begin
      LQuery.SQL.Text :=
        'INSERT INTO ABASTECIMENTO (DATAHORA, QUANTIDADE, VALORUN, ALIQ, VALORTOT, COMBUSTIVELID, USUARIOID, BOMBAID, TANQUEID) ' +
        'VALUES (:DATAHORA, :QUANTIDADE, :VALORUN, :ALIQ, :VALORTOT, :COMBUSTIVELID, :USUARIOID, :BOMBAID, :TANQUEID) RETURNING ID ';

      LQuery.ParamByName('DATAHORA').AsDateTime := AEntity.DataHora;
      LQuery.ParamByName('QUANTIDADE').AsFloat := AEntity.Quantidade;
      LQuery.ParamByName('VALORUN').AsCurrency := AEntity.ValorUnitario;
      LQuery.ParamByName('ALIQ').AsFloat := AEntity.Aliquota;
      LQuery.ParamByName('VALORTOT').AsCurrency := AEntity.ValorTotal;
      LQuery.ParamByName('COMBUSTIVELID').AsLargeInt := AEntity.CombustivelId;
      LQuery.ParamByName('USUARIOID').AsLargeInt := AEntity.UsuarioId;
      LQuery.ParamByName('BOMBAID').AsLargeInt := AEntity.BombaId;
      LQuery.ParamByName('TANQUEID').AsLargeInt := AEntity.TanqueId;

      LQuery.Open;
      if not LQuery.Eof then
        AEntity.Id := LQuery.FieldByName('ID').AsLargeInt;

      Result := AEntity;
    end
    else
    begin
      LQuery.SQL.Text :=
        'UPDATE ABASTECIMENTO SET DATAHORA = :DATAHORA, QUANTIDADE = :QUANTIDADE, VALORUN = :VALORUN, ALIQ = :ALIQ, VALORTOT = :VALORTOT, ' +
        'COMBUSTIVELID = :COMBUSTIVELID, USUARIOID = :USUARIOID, BOMBAID = :BOMBAID, TANQUEID = :TANQUEID ' +
        'WHERE ID = :ID';

      LQuery.ParamByName('DATAHORA').AsDateTime := AEntity.DataHora;
      LQuery.ParamByName('QUANTIDADE').AsFloat := AEntity.Quantidade;
      LQuery.ParamByName('VALORUN').AsCurrency := AEntity.ValorUnitario;
      LQuery.ParamByName('ALIQ').AsFloat := AEntity.Aliquota;
      LQuery.ParamByName('VALORTOT').AsCurrency := AEntity.ValorTotal;
      LQuery.ParamByName('COMBUSTIVELID').AsLargeInt := AEntity.CombustivelId;
      LQuery.ParamByName('USUARIOID').AsLargeInt := AEntity.UsuarioId;
      LQuery.ParamByName('BOMBAID').AsLargeInt := AEntity.BombaId;
      LQuery.ParamByName('TANQUEID').AsLargeInt := AEntity.TanqueId;
      LQuery.ParamByName('ID').AsLargeInt := AEntity.Id;

      LQuery.ExecSQL;
      Result := AEntity;
    end;
  finally
    LQuery.Free;
  end;
end;

end.
