unit Tanq.Model.Repository.Factory;

interface

uses
  Tanq.Model.Conn.Interfaces,
  Tanq.Model.Repository.Interfaces;

type
  TRepositoryFactory = class
  private
    [weak] FConnection: IDbConnection;
  public
    constructor Create(const AConnection: IDbConnection);

    function Connection: IDbConnection;
    function Combustivel: ICombustivelRepository;
    function Bomba: IBombaRepository;
    function Tanque: ITanqueRepository;
    function Abastecimento: IAbastecimentoRepository;
    function Reposicao: IReposicaoRepository;
    function TanqueMovimento: ITanqueMovimentoRepository;
    function Relatorio: IRelatorioRepository;
  end;

implementation

uses
  Tanq.Model.Repository.Combustivel,
  Tanq.Model.Repository.Bomba,
  Tanq.Model.Repository.Tanque,
  Tanq.Model.Repository.Abastecimento,
  Tanq.Model.Repository.Reposicao,
  Tanq.Model.Repository.TanqueMovimento,
  Tanq.Model.Repository.Relatorio;

{ TRepositoryFactory }
 
constructor TRepositoryFactory.Create(const AConnection: IDbConnection);
begin
  inherited Create;
  FConnection := AConnection;
end;

function TRepositoryFactory.Connection: IDbConnection;
begin
  Result := FConnection;
end;

function TRepositoryFactory.Combustivel: ICombustivelRepository;
begin
  Result := TCombustivelRepository.Create(FConnection);
end;

function TRepositoryFactory.Bomba: IBombaRepository;
begin
  Result := TBombaRepository.Create(FConnection);
end;

function TRepositoryFactory.Tanque: ITanqueRepository;
begin
  Result := TTanqueRepository.Create(FConnection);
end;

function TRepositoryFactory.Abastecimento: IAbastecimentoRepository;
begin
  Result := TAbastecimentoRepository.Create(FConnection);
end;

function TRepositoryFactory.Reposicao: IReposicaoRepository;
begin
  Result := TReposicaoRepository.Create(FConnection);
end;

function TRepositoryFactory.TanqueMovimento: ITanqueMovimentoRepository;
begin
  Result := TTanqueMovimentoRepository.Create(FConnection);
end;

function TRepositoryFactory.Relatorio: IRelatorioRepository;
begin
  Result := TRelatorioRepository.Create(FConnection);
end;

end.
