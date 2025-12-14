unit Tanq.Model.Repository.Tanque;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  FireDAC.Comp.Client, FireDAC.Stan.Param,
  Tanq.Model.Conn.Interfaces,
  Tanq.Model.Repository.Interfaces,
  Tanq.Model.Repository.DTOs,
  Tanq.Model.Entity.Tanque;

type
  TTanqueRepository = class(TInterfacedObject, ITanqueRepository)
  private
    [weak] FConnection: IDbConnection;
    function MapTanque(const AQuery: TFDQuery): TTanque;
  public
    constructor Create(const AConnection: IDbConnection);
    function FindById(const ATanqueId: Int64): TTanque;
    function FindAllWithCombustivel: TArray<TTanqueCombustivelInfo>;
    function GetAvailableQuantity(const ATanqueId: Int64): Double;
    function HasAvailableQuantity(const ATanqueId: Int64; const ARequired: Double): Boolean;
    function Exists(const ATanqueId: Int64): Boolean;
  end;

implementation

{ TTanqueRepository }

constructor TTanqueRepository.Create(const AConnection: IDbConnection);
begin
  inherited Create;
  FConnection := AConnection;
end;

function TTanqueRepository.FindById(const ATanqueId: Int64): TTanque;
begin
  Result := nil;
  var LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection.GetConn;
    LQuery.SQL.Text := 'SELECT * FROM TANQUE WHERE ID = :ID ';
    LQuery.ParamByName('ID').AsLargeInt := ATanqueId;
    LQuery.Open;

    if LQuery.RecordCount > 0  then
      Result := MapTanque(LQuery)

  finally
    LQuery.Free;
  end;
end;

function TTanqueRepository.Exists(const ATanqueId: Int64): Boolean;
begin
  var LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection.GetConn;
    LQuery.SQL.Text := 'SELECT ID FROM TANQUE WHERE ID = :ID ';
    LQuery.ParamByName('ID').AsLargeInt := ATanqueId;
    LQuery.Open;

    Result := LQuery.RecordCount > 0;
  finally
    LQuery.Free;
  end;
end;

function TTanqueRepository.FindAllWithCombustivel: TArray<TTanqueCombustivelInfo>;
var
  LItems: TList<TTanqueCombustivelInfo>;
  LQuery: TFDQuery;
  LInfo: TTanqueCombustivelInfo;
begin
  LItems := TList<TTanqueCombustivelInfo>.Create;
  try
    LQuery := TFDQuery.Create(nil);
    try
      LQuery.Connection := FConnection.GetConn;
      LQuery.SQL.Text :=
        'SELECT T.ID AS TANQUE_ID, T.DESCRICAO AS TANQUE_DESCRICAO, T.CAPACIDADE AS TANQUE_CAPACIDADE, ' +
        'C.ID AS COMBUSTIVEL_ID, C.DESCRICAO AS COMBUSTIVEL_DESCRICAO, C.UNIDADE AS COMBUSTIVEL_UNIDADE, ' +
        'C.VALOR AS COMBUSTIVEL_VALOR, C.ALIQUOTA AS COMBUSTIVEL_ALIQUOTA ' +
        'FROM TANQUE T ' +
        'JOIN COMBUSTIVEL C ON C.ID = T.COMBUSTIVELID ' +
        'ORDER BY T.DESCRICAO';
      LQuery.Open;

      while not LQuery.Eof do
      begin
        FillChar(LInfo, SizeOf(LInfo), 0);
        LInfo.TanqueId := LQuery.FieldByName('TANQUE_ID').AsLargeInt;
        LInfo.TanqueDescricao := LQuery.FieldByName('TANQUE_DESCRICAO').AsString;
        LInfo.TanqueCapacidade := LQuery.FieldByName('TANQUE_CAPACIDADE').AsFloat;
        LInfo.CombustivelId := LQuery.FieldByName('COMBUSTIVEL_ID').AsLargeInt;
        LInfo.CombustivelDescricao := LQuery.FieldByName('COMBUSTIVEL_DESCRICAO').AsString;
        LInfo.CombustivelUnidade := LQuery.FieldByName('COMBUSTIVEL_UNIDADE').AsString;
        LInfo.CombustivelValor := LQuery.FieldByName('COMBUSTIVEL_VALOR').AsCurrency;
        LInfo.CombustivelAliquota := LQuery.FieldByName('COMBUSTIVEL_ALIQUOTA').AsFloat;
        LItems.Add(LInfo);
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

function TTanqueRepository.GetAvailableQuantity(const ATanqueId: Int64): Double;
begin
  var LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection.GetConn;
    //TODO tratar para caso seja mudado o combust�vel do tanque, calcular saldo considerando apenas o ultimo idcombustivel com base na coluna datahora
    LQuery.SQL.Text := 'SELECT COALESCE(SUM(CASE WHEN TIPOMOVIMENTO = 1 THEN -QUANTIDADE ELSE QUANTIDADE END), 0) AS SALDO FROM TANQUE_MOVIMENTO WHERE TANQUEID = :TID';
    LQuery.ParamByName('TID').AsLargeInt := ATanqueId;
    LQuery.Open;

    if LQuery.RecordCount > 0 then
      Result := LQuery.FieldByName('SALDO').AsFloat
    else
      Result := 0.0;
  finally
    FreeandNil(LQuery);
  end;
end;

function TTanqueRepository.HasAvailableQuantity(const ATanqueId: Int64; const ARequired: Double): Boolean;
begin
  Result := GetAvailableQuantity(ATanqueId) >= ARequired;
end;

function TTanqueRepository.MapTanque(const AQuery: TFDQuery): TTanque;
begin
  Result := TTanque.Create;
  Result.Id := AQuery.FieldByName('ID').AsLargeInt;
  Result.Descricao := AQuery.FieldByName('DESCRICAO').AsString;
  Result.Capacidade := AQuery.FieldByName('CAPACIDADE').AsFloat;
  Result.CombustivelId := AQuery.FieldByName('COMBUSTIVELID').AsLargeInt;
end;

end.
