unit Tanq.Model.Repository.DTOs;

interface

type
  TBombaCombustivelInfo = record
    BombaId: Int64;
    BombaDescricao: string;
    TanqueId: Int64;
    TanqueDescricao: string;
    TanqueCapacidade: Double;
    TanqueEstoqueAtual: Double;
    CombustivelId: Int64;
    CombustivelDescricao: string;
    CombustivelUnidade: string;
    CombustivelValor: Currency;
    CombustivelAliquota: Double;
  end;

  TTanqueCombustivelInfo = record
    TanqueId: Int64;
    TanqueDescricao: string;
    TanqueCapacidade: Double;
    TanqueEstoqueAtual: Double;
    CombustivelId: Int64;
    CombustivelDescricao: string;
    CombustivelUnidade: string;
    CombustivelValor: Currency;
    CombustivelAliquota: Double;
  end;

  TAbastecimentoResumo = record
    BombaInfo: TBombaCombustivelInfo;
    QuantidadeSolicitada: Double;
    EstoqueAtual: Double;
    EstoqueAposSaida: Double;
    ValorUnitario: Currency;
    Aliquota: Double;
    ValorBruto: Currency;
    ValorImposto: Currency;
    ValorTotal: Currency;
  end;

  TReposicaoResumo = record
    TanqueInfo: TBombaCombustivelInfo;
    QuantidadeSolicitada: Double;
    EstoqueAtual: Double;
    EstoqueAposEntrada: Double;
    CapacidadeTotal: Double;
    CapacidadeDisponivel: Double;
  end;

implementation

end.
