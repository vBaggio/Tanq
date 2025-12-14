unit Tanq.Model.Repository.Bomba;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  FireDAC.Comp.Client, FireDAC.Stan.Param,
  Tanq.Model.Conn.Interfaces,
  Tanq.Model.Repository.Interfaces,
  Tanq.Model.Repository.DTOs,
  Tanq.Model.Entity.Bomba;

type
  TBombaRepository = class(TInterfacedObject, IBombaRepository)
  private
    [weak] FConnection: IDbConnection;
    function MapInfo(const AQuery: TFDQuery): TBombaCombustivelInfo;
  public
    constructor Create(const AConnection: IDbConnection);
    function FindAllWithCombustivel: TArray<TBombaCombustivelInfo>;
    function FindInfoById(const ABombaId: Int64): TBombaCombustivelInfo;
    function FindById(const ABombaId: Int64): TBomba;
    function Save(const ABomba: TBomba): TBomba;
    procedure Delete(const ABombaId: Int64);
    function HasMovements(const ABombaId: Int64): Boolean;
    function Exists(const ABombaId: Int64): Boolean;
  end;

implementation

{ TBombaRepository }

constructor TBombaRepository.Create(const AConnection: IDbConnection);
begin
  inherited Create;
  FConnection := AConnection;
end;

function TBombaRepository.FindAllWithCombustivel: TArray<TBombaCombustivelInfo>;
begin
  var LItems := TList<TBombaCombustivelInfo>.Create;
  try
    var LQuery := TFDQuery.Create(nil);
    try
      LQuery.Connection := FConnection.GetConn;
      LQuery.SQL.Text :=
        'SELECT B.ID AS BOMBA_ID, B.DESCRICAO AS BOMBA_DESCRICAO, ' +
        ' T.ID AS TANQUE_ID, T.DESCRICAO AS TANQUE_DESCRICAO, T.CAPACIDADE AS TANQUE_CAPACIDADE, ' +
        ' C.ID AS COMBUSTIVEL_ID, C.DESCRICAO AS COMBUSTIVEL_DESCRICAO, C.UNIDADE AS COMBUSTIVEL_UNIDADE, C.VALOR AS COMBUSTIVEL_VALOR, C.ALIQUOTA AS COMBUSTIVEL_ALIQUOTA ' +
        'FROM BOMBA B ' +
        'JOIN TANQUE T ON T.ID = B.TANQUEID ' +
        'JOIN COMBUSTIVEL C ON C.ID = T.COMBUSTIVELID ' +
        'ORDER BY B.DESCRICAO ';
      LQuery.Open;

      while not LQuery.Eof do
      begin
        LItems.Add(MapInfo(LQuery));
        LQuery.Next;
      end;
    finally
      LQuery.Free;
    end;

    Result := LItems.ToArray;
  finally
    LItems.Free;
  end;
end;

function TBombaRepository.FindById(const ABombaId: Int64): TBomba;
begin
  Result := nil;
  var LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection.GetConn;
    LQuery.SQL.Text := 'SELECT ID, DESCRICAO, TANQUEID FROM BOMBA WHERE ID = :ID';
    LQuery.ParamByName('ID').AsLargeInt := ABombaId;
    LQuery.Open;

    if LQuery.RecordCount = 1 then
    begin
      Result := TBomba.Create;
      Result.Id := LQuery.FieldByName('ID').AsLargeInt;
      Result.Descricao := LQuery.FieldByName('DESCRICAO').AsString;
      Result.TanqueId := LQuery.FieldByName('TANQUEID').AsLargeInt;
    end;
  finally
    LQuery.Free;
  end;
end;

function TBombaRepository.MapInfo(const AQuery: TFDQuery): TBombaCombustivelInfo;
begin
  Result.BombaId := AQuery.FieldByName('BOMBA_ID').AsLargeInt;
  Result.BombaDescricao := AQuery.FieldByName('BOMBA_DESCRICAO').AsString;
  Result.TanqueId := AQuery.FieldByName('TANQUE_ID').AsLargeInt;
  Result.TanqueDescricao := AQuery.FieldByName('TANQUE_DESCRICAO').AsString;
  Result.TanqueCapacidade := AQuery.FieldByName('TANQUE_CAPACIDADE').AsFloat;
  Result.CombustivelId := AQuery.FieldByName('COMBUSTIVEL_ID').AsLargeInt;
  Result.CombustivelDescricao := AQuery.FieldByName('COMBUSTIVEL_DESCRICAO').AsString;
  Result.CombustivelUnidade := AQuery.FieldByName('COMBUSTIVEL_UNIDADE').AsString;
  Result.CombustivelValor := AQuery.FieldByName('COMBUSTIVEL_VALOR').AsCurrency;
  Result.CombustivelAliquota := AQuery.FieldByName('COMBUSTIVEL_ALIQUOTA').AsFloat;
end;

function TBombaRepository.Save(const ABomba: TBomba): TBomba;
begin
  if not Assigned(ABomba) then
    raise Exception.Create('Bomba inválida.');

  var LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection.GetConn;
    if ABomba.Id = 0 then
    begin
      LQuery.SQL.Text :=
        'INSERT INTO BOMBA (DESCRICAO, TANQUEID) VALUES (:DESCRICAO, :TANQUEID) RETURNING ID';
      LQuery.ParamByName('DESCRICAO').AsString := ABomba.Descricao;
      LQuery.ParamByName('TANQUEID').AsLargeInt := ABomba.TanqueId;
      LQuery.Open;
      ABomba.Id := LQuery.FieldByName('ID').AsLargeInt;
    end
    else
    begin
      LQuery.SQL.Text := 'UPDATE BOMBA SET DESCRICAO = :DESCRICAO, TANQUEID = :TANQUEID WHERE ID = :ID';
      LQuery.ParamByName('ID').AsLargeInt := ABomba.Id;
      LQuery.ParamByName('DESCRICAO').AsString := ABomba.Descricao;
      LQuery.ParamByName('TANQUEID').AsLargeInt := ABomba.TanqueId;
      LQuery.ExecSQL;
    end;
  finally
    LQuery.Free;
  end;

  Result := ABomba;
end;

procedure TBombaRepository.Delete(const ABombaId: Int64);
begin
  var LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection.GetConn;
    LQuery.SQL.Text := 'DELETE FROM BOMBA WHERE ID = :ID';
    LQuery.ParamByName('ID').AsLargeInt := ABombaId;
    LQuery.ExecSQL;
  finally
    LQuery.Free;
  end;
end;

function TBombaRepository.Exists(const ABombaId: Int64): Boolean;
begin
  var LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection.GetConn;
    LQuery.SQL.Text := 'SELECT ID FROM BOMBA WHERE ID = :ID ';
    LQuery.ParamByName('ID').AsLargeInt := ABombaId;
    LQuery.Open;
    Result := LQuery.RecordCount > 0;
  finally
    LQuery.Free;
  end;
end;

function TBombaRepository.HasMovements(const ABombaId: Int64): Boolean;
begin
  var LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection.GetConn;
    LQuery.SQL.Text := 'SELECT FIRST 1 ID FROM ABASTECIMENTO WHERE BOMBAID = :ID ';
    LQuery.ParamByName('ID').AsLargeInt := ABombaId;
    LQuery.Open;
    Result := LQuery.RecordCount > 0;
  finally
    LQuery.Free;
  end;
end;

function TBombaRepository.FindInfoById(const ABombaId: Int64): TBombaCombustivelInfo;
begin
  FillChar(Result, SizeOf(Result), 0);
  var LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection.GetConn;
    LQuery.SQL.Text :=
      'SELECT B.ID AS BOMBA_ID, B.DESCRICAO AS BOMBA_DESCRICAO,' +
      ' T.ID AS TANQUE_ID, T.DESCRICAO AS TANQUE_DESCRICAO, T.CAPACIDADE AS TANQUE_CAPACIDADE, ' +
      ' C.ID AS COMBUSTIVEL_ID, C.DESCRICAO AS COMBUSTIVEL_DESCRICAO, C.UNIDADE AS COMBUSTIVEL_UNIDADE, C.VALOR AS COMBUSTIVEL_VALOR, C.ALIQUOTA AS COMBUSTIVEL_ALIQUOTA ' +
      ' FROM BOMBA B ' +
      'JOIN TANQUE T ON T.ID = B.TANQUEID ' +
      'JOIN COMBUSTIVEL C ON C.ID = T.COMBUSTIVELID ' +
      'WHERE B.ID = :ID';
    LQuery.ParamByName('ID').AsLargeInt := ABombaId;
    LQuery.Open;

    if LQuery.RecordCount > 0 then
      Result := MapInfo(LQuery);
  finally
    LQuery.Free;
  end;
end;

end.
