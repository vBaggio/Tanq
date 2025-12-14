unit Tanq.Model.Repository.Interfaces;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Data.DB,
  Tanq.Model.Entity.Combustivel,
  Tanq.Model.Entity.Bomba,
  Tanq.Model.Entity.Tanque,
  Tanq.Model.Entity.Abastecimento,
  Tanq.Model.Entity.Reposicao,
  Tanq.Model.Entity.TanqueMovimento,
  Tanq.Model.Repository.DTOs;

type
  ICombustivelRepository = interface
    ['{596E7E4A-749E-4EE6-BBB7-F66A757B5B54}']
    function FindAll: TObjectList<TCombustivel>;
    function FindById(const AId: Int64): TCombustivel;
  end;

  IBombaRepository = interface
    ['{E9F76F4B-46F7-4530-AB3A-CF319018F18F}']
    function FindAllWithCombustivel: TArray<TBombaCombustivelInfo>;
    function FindInfoById(const ABombaId: Int64): TBombaCombustivelInfo;
    function FindById(const ABombaId: Int64): TBomba;
    function Save(const ABomba: TBomba): TBomba;
    procedure Delete(const ABombaId: Int64);
    function HasMovements(const ABombaId: Int64): Boolean;
    function Exists(const ABombaId: Int64): Boolean;
  end;

  ITanqueRepository = interface
    ['{A3C2B2D9-4C7E-4F8A-9C9F-6F8B3D2E5A12}']
    function FindById(const ATanqueId: Int64): TTanque;
    function FindAllWithCombustivel: TArray<TTanqueCombustivelInfo>;
    function GetAvailableQuantity(const ATanqueId: Int64): Double;
    function HasAvailableQuantity(const ATanqueId: Int64; const ARequired: Double): Boolean;
    function Exists(const ATanqueId: Int64): Boolean;
  end;

  IAbastecimentoRepository = interface
    ['{D4B6C7E1-8F6A-4C9A-9E2A-1B2C3D4E5F60}']
    function FindAll: TObjectList<TAbastecimento>;
    function FindById(const AId: Int64): TAbastecimento;
    function Save(AEntity: TAbastecimento): TAbastecimento;
  end;

  IReposicaoRepository = interface
    ['{AC8DCC7F-EE97-4762-9D91-3F4637581742}']
    function FindAll: TObjectList<TReposicao>;
    function FindById(const AId: Int64): TReposicao;
    function Save(AEntity: TReposicao): TReposicao;
  end;

  IRelatorioRepository = interface
    ['{7D6EA0BF-16DC-49A1-AF65-2F03E82E799A}']
    function GerarRelatorioAbastecimento(const ADataInicial, ADataFinal: TDateTime): TDataSet;
  end;

  ITanqueMovimentoRepository = interface
    ['{DF1401C1-88A9-4A89-9AAB-61C6748EC611}']
    function Save(const AMovimento: TTanqueMovimento): TTanqueMovimento;
  end;

implementation

end.
