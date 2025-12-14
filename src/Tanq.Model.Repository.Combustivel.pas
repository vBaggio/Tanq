unit Tanq.Model.Repository.Combustivel;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  FireDAC.Comp.Client, FireDAC.Stan.Param,
  Tanq.Model.Conn.Interfaces,
  Tanq.Model.Repository.Interfaces,
  Tanq.Model.Entity.Combustivel;

type
  TCombustivelRepository = class(TInterfacedObject, ICombustivelRepository)
  private
    [weak] FConnection: IDbConnection;
    function MapCombustivel(const AQuery: TFDQuery): TCombustivel;
  public
    constructor Create(const AConnection: IDbConnection);
    function FindAll: TObjectList<TCombustivel>;
    function FindById(const AId: Int64): TCombustivel;
  end;

implementation

{ TCombustivelRepository }

constructor TCombustivelRepository.Create(const AConnection: IDbConnection);
begin
  inherited Create;
  FConnection := AConnection;
end;

function TCombustivelRepository.FindAll: TObjectList<TCombustivel>;
begin
  Result := TObjectList<TCombustivel>.Create(True);

  var LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection.GetConn;
    LQuery.SQL.Text := 'SELECT * FROM COMBUSTIVEL ORDER BY DESCRICAO ';
    LQuery.Open;

    while not LQuery.Eof do
    begin
      Result.Add(MapCombustivel(LQuery));
      LQuery.Next;
    end;
  finally
    LQuery.Free;
  end;
end;

function TCombustivelRepository.FindById(const AId: Int64): TCombustivel;
begin
  Result := nil;
  var LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection.GetConn;
    LQuery.SQL.Text := 'SELECT * FROM COMBUSTIVEL WHERE ID = :ID';
    LQuery.ParamByName('ID').AsLargeInt := AId;
    LQuery.Open;

    if LQuery.RecordCount > 0 then
      Result := MapCombustivel(LQuery);
  finally
    LQuery.Free;
  end;
end;

function TCombustivelRepository.MapCombustivel(const AQuery: TFDQuery): TCombustivel;
begin
  Result := TCombustivel.Create;
  Result.Id := AQuery.FieldByName('ID').AsLargeInt;
  Result.Descricao := AQuery.FieldByName('DESCRICAO').AsString;
  Result.Unidade := AQuery.FieldByName('UNIDADE').AsString;
  Result.Valor := AQuery.FieldByName('VALOR').AsCurrency;
  Result.Aliquota := AQuery.FieldByName('ALIQUOTA').AsFloat;
end;

end.
