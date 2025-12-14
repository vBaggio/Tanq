unit Tanq.Model.Service.Reposicao;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Tanq.Model.Conn.Interfaces,
  Tanq.Model.Service.Interfaces,
  Tanq.Model.Service.Factory,
  Tanq.Model.Repository.Factory,
  Tanq.Model.Repository.Interfaces,
  Tanq.Model.Entity.Reposicao,
  Tanq.Model.Entity.Tanque;

type
  TReposicaoService = class(TInterfacedObject, IReposicaoService)
  private
    FRepositoryFactory: TRepositoryFactory;
    FServiceFactory: TServiceFactory;

    FReposicaoRepository: IReposicaoRepository;
    FTanqueRepository: ITanqueRepository;
    FTanqueMovimentoService: ITanqueMovimentoService;

    procedure ValidateInput(const ATanqueId: Int64; const AQuantidade: Double; const AUsuarioId: Int64; const ADataHora: TDateTime);
    function GetTanque(const ATanqueId: Int64): TTanque;
    procedure EnsureCapacidade(const ATanque: TTanque; const AQuantidade: Double);

    function BuildReposicao(const ATanque: TTanque; const AQuantidade: Double;
      const AUsuarioId: Int64; const ADataHora: TDateTime; const AObservacao: string): TReposicao;

  public
    constructor Create(const AServiceFactory: TServiceFactory);

    function Registrar(const ATanqueId: Int64; const AQuantidade: Double;
      const AUsuarioId: Int64; const ADataHora: TDateTime;
      const AObservacao: string = ''): TReposicao;
    function ObterPorId(const AId: Int64): TReposicao;
    function ListarTodos: TObjectList<TReposicao>;
  end;

implementation

{ TReposicaoService }

constructor TReposicaoService.Create(const AServiceFactory: TServiceFactory);
begin
  if not Assigned(AServiceFactory) then
    raise EReposicaoValidation.Create('Factory de serviços não disponível.');

  FServiceFactory := AServiceFactory;
  FRepositoryFactory := FServiceFactory.RepositoryFactory;

  if not Assigned(FRepositoryFactory) then
    raise EReposicaoValidation.Create('Factory de repositórios não disponível.');

  FReposicaoRepository := FRepositoryFactory.Reposicao;
  FTanqueRepository := FRepositoryFactory.Tanque;
  FTanqueMovimentoService := FServiceFactory.TanqueMovimento;
end;

procedure TReposicaoService.ValidateInput(const ATanqueId: Int64;
  const AQuantidade: Double; const AUsuarioId: Int64;
  const ADataHora: TDateTime);
begin
  if ATanqueId <= 0 then
    raise EReposicaoValidation.Create('Tanque inválido.');

  if AQuantidade <= 0 then
    raise EReposicaoValidation.Create('Quantidade deve ser maior que zero.');

  if AUsuarioId <= 0 then
    raise EReposicaoValidation.Create('Usuário inválido.');

  if ADataHora = 0 then
    raise EReposicaoValidation.Create('Data/Hora inválida.');
end;

function TReposicaoService.GetTanque(const ATanqueId: Int64): TTanque;
begin
  Result := FTanqueRepository.FindById(ATanqueId);
  if not Assigned(Result) then
    raise EReposicaoValidation.CreateFmt('Tanque %d não encontrado.', [ATanqueId]);

  if Result.CombustivelId = 0 then
    raise EReposicaoValidation.CreateFmt('Tanque %d não possui combustível configurado.', [ATanqueId]);
end;

procedure TReposicaoService.EnsureCapacidade(const ATanque: TTanque;
  const AQuantidade: Double);
begin
  var LSaldoAtual := FTanqueRepository.GetAvailableQuantity(ATanque.Id);
  if LSaldoAtual + AQuantidade > ATanque.Capacidade then
    raise EReposicaoValidation.CreateFmt(
      'Tanque %d suporta até %.2f litros. Estoque atual %.2f.',
      [ATanque.Id, ATanque.Capacidade, LSaldoAtual]
    );
end;

function TReposicaoService.BuildReposicao(const ATanque: TTanque;
  const AQuantidade: Double; const AUsuarioId: Int64;
  const ADataHora: TDateTime; const AObservacao: string): TReposicao;
begin
  Result := TReposicao.Create;
  Result.DataHora := ADataHora;
  Result.TanqueId := ATanque.Id;
  Result.CombustivelId := ATanque.CombustivelId;
  Result.Quantidade := AQuantidade;
  Result.UsuarioId := AUsuarioId;
  Result.Observacao := AObservacao;
end;

function TReposicaoService.ListarTodos: TObjectList<TReposicao>;
begin
  Result := FReposicaoRepository.FindAll;
end;

function TReposicaoService.ObterPorId(const AId: Int64): TReposicao;
begin
  Result := FReposicaoRepository.FindById(AId);
end;

function TReposicaoService.Registrar(const ATanqueId: Int64;
  const AQuantidade: Double; const AUsuarioId: Int64;
  const ADataHora: TDateTime; const AObservacao: string): TReposicao;
begin
  ValidateInput(ATanqueId, AQuantidade, AUsuarioId, ADataHora);

  var LReposicao: TReposicao;
  var LTanque := GetTanque(ATanqueId);
  try
    EnsureCapacidade(LTanque, AQuantidade);
    LReposicao := BuildReposicao(LTanque, AQuantidade, AUsuarioId, ADataHora, AObservacao);
  finally
    LTanque.Free;
  end;

  FRepositoryFactory.Connection.BeginTransaction;
  try
    Result := FReposicaoRepository.Save(LReposicao);
    FTanqueMovimentoService.RegistrarMovimento(Result);
    FRepositoryFactory.Connection.Commit;
  except
    FRepositoryFactory.Connection.Rollback;
    if Assigned(LReposicao) then
      LReposicao.Free;
    raise;
  end;
end;

end.
