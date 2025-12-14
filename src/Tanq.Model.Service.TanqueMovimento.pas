unit Tanq.Model.Service.TanqueMovimento;

interface

uses
  Tanq.Model.Service.Interfaces,
  Tanq.Model.Service.Factory,
  Tanq.Model.Repository.Factory,
  Tanq.Model.Repository.Interfaces,
  Tanq.Model.Entity.TanqueMovimento,
  Tanq.Model.Entity.Abastecimento,
  Tanq.Model.Entity.Reposicao;

type
  TTanqueMovimentoService = class(TInterfacedObject, ITanqueMovimentoService)
  private
    FRepositoryFactory: TRepositoryFactory;
    FServiceFactory: TServiceFactory;

    FTanqueMovimentoRepository: ITanqueMovimentoRepository;

    function BuildMovimentoFromAbastecimento(const AAbastecimento: TAbastecimento): TTanqueMovimento;
    function BuildMovimentoFromReposicao(const AReposicao: TReposicao): TTanqueMovimento;
  public
    constructor Create(const AServiceFactory: TServiceFactory);

    procedure RegistrarMovimento(const AAbastecimento: TAbastecimento); overload;
    procedure RegistrarMovimento(const AReposicao: TReposicao); overload;
  end;

implementation

uses
  System.SysUtils;

{ TTanqueMovimentoService }

function TTanqueMovimentoService.BuildMovimentoFromAbastecimento(const AAbastecimento: TAbastecimento): TTanqueMovimento;
begin
  Result := TTanqueMovimento.Create;
  Result.DataHora := AAbastecimento.DataHora;
  Result.TanqueId := AAbastecimento.TanqueId;
  Result.CombustivelId := AAbastecimento.CombustivelId;
  Result.UsuarioId := AAbastecimento.UsuarioId;
  Result.TipoMovimento := 1; // saída
  Result.Quantidade := AAbastecimento.Quantidade;
  Result.OrigemTipo := 'AB';
  Result.OrigemId := AAbastecimento.Id;
  Result.Observacao := Format('Abastecimento Bomba %d', [AAbastecimento.BombaId]);
end;

constructor TTanqueMovimentoService.Create(const AServiceFactory: TServiceFactory);
begin
  if not Assigned(AServiceFactory) then
    raise Exception.Create('Factory de serviços não disponível para movimentos de tanque.');

  FServiceFactory := AServiceFactory;
  FRepositoryFactory := FServiceFactory.RepositoryFactory;

  if not Assigned(FRepositoryFactory) then
    raise Exception.Create('Factory de repositórios não disponível para movimentos de tanque.');

  FTanqueMovimentoRepository := FRepositoryFactory.TanqueMovimento;
end;

procedure TTanqueMovimentoService.RegistrarMovimento(const AAbastecimento: TAbastecimento);
begin
  if not Assigned(AAbastecimento) then
    raise Exception.Create('Abastecimento inválido');

  var LMov := BuildMovimentoFromAbastecimento(AAbastecimento);
  try
    FTanqueMovimentoRepository.Save(LMov);
  finally
    LMov.Free;
  end;
end;

function TTanqueMovimentoService.BuildMovimentoFromReposicao(const AReposicao: TReposicao): TTanqueMovimento;
begin
  Result := TTanqueMovimento.Create;
  Result.DataHora := AReposicao.DataHora;
  Result.TanqueId := AReposicao.TanqueId;
  Result.CombustivelId := AReposicao.CombustivelId;
  Result.UsuarioId := AReposicao.UsuarioId;
  Result.TipoMovimento := 0; // entrada
  Result.Quantidade := AReposicao.Quantidade;
  Result.OrigemTipo := 'RE';
  Result.OrigemId := AReposicao.Id;
  if AReposicao.Observacao <> '' then
    Result.Observacao := AReposicao.Observacao
  else
    Result.Observacao := Format('Reposição Tanque %d', [AReposicao.TanqueId]);
end;

procedure TTanqueMovimentoService.RegistrarMovimento(const AReposicao: TReposicao);
begin
  if not Assigned(AReposicao) then
    raise Exception.Create('Reposicao invalida');

  var LMov := BuildMovimentoFromReposicao(AReposicao);
  try
    FTanqueMovimentoRepository.Save(LMov);
  finally
    LMov.Free;
  end;
end;

end.
