unit Tanq.Model.Service.Interfaces;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Data.DB,
  Tanq.Model.Entity.Abastecimento,
  Tanq.Model.Entity.Reposicao,
  Tanq.Model.Entity.TanqueMovimento,
  Tanq.Model.Entity.Bomba,
  Tanq.Model.Repository.DTOs;

type
  EAbastecimentoValidation = class(Exception);
  EReposicaoValidation = class(Exception);
  EBombaServiceException = class(Exception);
  ERelatorioException = class(Exception);

  IAbastecimentoService = interface
    ['{B8BC5D6B-998B-46B9-980F-00B48F92AAF0}']
    function CalcularResumo(const ABombaId: Int64;
      const AQuantidade: Double): TAbastecimentoResumo;
    function Registrar(const ABombaId: Int64; const AQuantidade: Double;
      const AUsuarioId: Int64; const ADataHora: TDateTime): TAbastecimento;
    function ObterPorId(const AId: Int64): TAbastecimento;
    function ListarTodos: TObjectList<TAbastecimento>;
  end;

  ITanqueMovimentoService = interface
    ['{0B387BBC-4116-4565-8CF8-A5E4DF3F50B1}']
    procedure RegistrarMovimento(const AAbastecimento: TAbastecimento); overload;
    procedure RegistrarMovimento(const AReposicao: TReposicao); overload;
  end;

  IReposicaoService = interface
    ['{18266776-8E93-4FC8-A7E9-2EAD862A14F6}']
    function Registrar(const ATanqueId: Int64; const AQuantidade: Double;
      const AUsuarioId: Int64; const ADataHora: TDateTime;
      const AObservacao: string = ''): TReposicao;
    function ObterPorId(const AId: Int64): TReposicao;
    function ListarTodos: TObjectList<TReposicao>;
  end;

  IBombaService = interface
    ['{9AFD176E-8091-4A3A-BCDE-729A3667C920}']
    function ListarComCombustivel: TArray<TBombaCombustivelInfo>;
    function ObterInfo(const ABombaId: Int64): TBombaCombustivelInfo;
    function ListarTanques: TArray<TTanqueCombustivelInfo>;
    function ObterBomba(const ABombaId: Int64): TBomba;
    function Salvar(const ABomba: TBomba): TBomba;
    procedure Excluir(const ABombaId: Int64);
    function PodeExcluir(const ABombaId: Int64): Boolean;
  end;

  IRelatorioService = interface
    ['{5F5D7C01-AC5D-4C1D-82F3-8D92913A4A57}']
    function Gerar(const ADataInicial, ADataFinal: TDateTime): TDataSet;
  end;

implementation

end.
