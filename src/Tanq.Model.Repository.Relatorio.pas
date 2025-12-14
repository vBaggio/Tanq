unit Tanq.Model.Repository.Relatorio;

interface

uses
  System.SysUtils,
  Data.DB,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  Tanq.Model.Conn.Interfaces,
  Tanq.Model.Repository.Interfaces;

type
  TRelatorioRepository = class(TInterfacedObject, IRelatorioRepository)
  strict private
    [weak] FConnection: IDbConnection;
  public
    constructor Create(const AConnection: IDbConnection);
    function GerarRelatorioAbastecimento(const ADataInicial, ADataFinal: TDateTime): TDataSet;
  end;

implementation

{ TRelatorioRepository }

constructor TRelatorioRepository.Create(const AConnection: IDbConnection);
begin
  inherited Create;
  FConnection := AConnection;
end;

function TRelatorioRepository.GerarRelatorioAbastecimento(
  const ADataInicial, ADataFinal: TDateTime): TDataSet;
var
  LQuery: TFDQuery;
begin
  LQuery := TFDQuery.Create(nil);
  try
    LQuery.Connection := FConnection.GetConn;

    LQuery.SQL.Add('SELECT CAST(A.DATAHORA AS DATE) AS DATA_DIA, CAST(A.DATAHORA AS TIME) AS HORA, A.DATAHORA, ');
    LQuery.SQL.Add(' T.ID AS TANQUE_ID, T.DESCRICAO AS TANQUE_DESCRICAO, ');
    LQuery.SQL.Add(' C.ID AS COMBUSTIVEL_ID,  C.DESCRICAO AS COMBUSTIVEL_DESCRICAO, ');
    LQuery.SQL.Add(' B.ID AS BOMBA_ID, B.DESCRICAO AS BOMBA_DESCRICAO,');
    LQuery.SQL.Add(' A.QUANTIDADE AS QUANTIDADE_LITROS, A.VALORUN AS VALOR_UNITARIO, A.ALIQ AS ALIQUOTA,');
    LQuery.SQL.Add(' ROUND(A.QUANTIDADE * A.VALORUN, 2) AS TOTAL_SEM_IMPOSTO,');
    LQuery.SQL.Add(' ROUND(A.QUANTIDADE * A.VALORUN * (A.ALIQ / 100), 2) AS VALOR_IMPOSTO, ');
    LQuery.SQL.Add(' A.VALORTOT  AS TOTAL_COM_IMPOSTO ');
    LQuery.SQL.Add('FROM ABASTECIMENTO A ');
    LQuery.SQL.Add('JOIN BOMBA B ON B.ID = A.BOMBAID ');
    LQuery.SQL.Add('JOIN TANQUE T ON T.ID = A.TANQUEID ');
    LQuery.SQL.Add('JOIN COMBUSTIVEL C ON C.ID = A.COMBUSTIVELID ');
    LQuery.SQL.Add('WHERE CAST(A.DATAHORA AS DATE) BETWEEN :DATA_INICIO AND :DATA_FIM ');
    LQuery.SQL.Add('ORDER BY CAST(A.DATAHORA AS DATE), T.ID, A.DATAHORA ');

    LQuery.ParamByName('DATA_INICIO').AsDateTime := ADataInicial;
    LQuery.ParamByName('DATA_FIM').AsDateTime := ADataFinal;

    LQuery.Open;

    Result := LQuery;
  except
    LQuery.Free;
    raise;
  end;
end;

end.
