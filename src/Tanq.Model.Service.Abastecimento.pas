unit Tanq.Model.Service.Abastecimento;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  System.Math,
  Tanq.Model.Conn.Interfaces,
  Tanq.Model.Service.Interfaces,
  Tanq.Model.Service.Factory,
  Tanq.Model.Repository.Factory,
  Tanq.Model.Repository.Interfaces,
  Tanq.Model.Repository.DTOs,
  Tanq.Model.Entity.Abastecimento;

type
  TAbastecimentoService = class(TInterfacedObject, IAbastecimentoService)
  private
    FConnection: IDbConnection;
    FRepositoryFactory: TRepositoryFactory;
    FServiceFactory: TServiceFactory;

    FAbastecimentoRepository: IAbastecimentoRepository;
    FTanqueRepository: ITanqueRepository;
    FBombaRepository: IBombaRepository;
    FTanqueMovimentoService: ITanqueMovimentoService;

    procedure ValidateInput(const ABombaId: Int64; const AQuantidade: Double;
      const AUsuarioId: Int64; const ADataHora: TDateTime);
    procedure ValidateEntity(AAbastecimento: TAbastecimento);
    function GetBombaInfo(const ABombaId: Int64): TBombaCombustivelInfo;
    procedure EnsureDisponibilidade(const ATanqueId: Int64; const AQuantidade: Double);
    function BuildResumo(const ABombaInfo: TBombaCombustivelInfo;
      const AQuantidade: Double): TAbastecimentoResumo;
    function BuildAbastecimento(const ABombaInfo: TBombaCombustivelInfo;
      const AUsuarioId: Int64; const AQuantidade: Double;
      const ADataHora: TDateTime): TAbastecimento;
  public
    constructor Create(const AServiceFactory: TServiceFactory);
    constructor CreateForTests(const AAbastecimentoRepository: IAbastecimentoRepository;
      const ATanqueRepository: ITanqueRepository; const ABombaRepository: IBombaRepository;
      const ATanqueMovimentoService: ITanqueMovimentoService; const AConnection: IDbConnection);

    function CalcularResumo(const ABombaId: Int64; const AQuantidade: Double): TAbastecimentoResumo;
    function Registrar(const ABombaId: Int64; const AQuantidade: Double; const AUsuarioId: Int64; const ADataHora: TDateTime): TAbastecimento;
    function ObterPorId(const AId: Int64): TAbastecimento;
    function ListarTodos: TObjectList<TAbastecimento>;
  end;

implementation

{ TAbastecimentoService }

constructor TAbastecimentoService.Create(const AServiceFactory: TServiceFactory);
begin
  if not Assigned(AServiceFactory) then
    raise EAbastecimentoValidation.Create('Factory de serviços não disponível.');

  FServiceFactory := AServiceFactory;
  FRepositoryFactory := FServiceFactory.RepositoryFactory;

  if not Assigned(FRepositoryFactory) then
    raise EAbastecimentoValidation.Create('Factory de repositórios não disponível.');

  FAbastecimentoRepository := FRepositoryFactory.Abastecimento;
  FTanqueRepository := FRepositoryFactory.Tanque;
  FBombaRepository := FRepositoryFactory.Bomba;
  FTanqueMovimentoService := FServiceFactory.TanqueMovimento;
  FConnection := FRepositoryFactory.Connection;
end;

constructor TAbastecimentoService.CreateForTests(
  const AAbastecimentoRepository: IAbastecimentoRepository;
  const ATanqueRepository: ITanqueRepository; const ABombaRepository: IBombaRepository;
  const ATanqueMovimentoService: ITanqueMovimentoService; const AConnection: IDbConnection);
begin
  if not Assigned(AAbastecimentoRepository) then
    raise EAbastecimentoValidation.Create('Repositório de abastecimento não disponível.');

  if not Assigned(ATanqueRepository) then
    raise EAbastecimentoValidation.Create('Repositório de tanque não disponível.');

  if not Assigned(ABombaRepository) then
    raise EAbastecimentoValidation.Create('Repositório de bomba não disponível.');

  if not Assigned(ATanqueMovimentoService) then
    raise EAbastecimentoValidation.Create('Serviço de movimento de tanque não disponível.');

  if not Assigned(AConnection) then
    raise EAbastecimentoValidation.Create('Conexão não disponível.');

  FServiceFactory := nil;
  FRepositoryFactory := nil;
  FAbastecimentoRepository := AAbastecimentoRepository;
  FTanqueRepository := ATanqueRepository;
  FBombaRepository := ABombaRepository;
  FTanqueMovimentoService := ATanqueMovimentoService;
  FConnection := AConnection;
end;

function TAbastecimentoService.CalcularResumo(const ABombaId: Int64;
  const AQuantidade: Double): TAbastecimentoResumo;
var
  LBombaInfo: TBombaCombustivelInfo;
begin
  if ABombaId <= 0 then
    raise EAbastecimentoValidation.Create('Bomba inválida.');

  if AQuantidade < 0 then
    raise EAbastecimentoValidation.Create('Quantidade deve ser maior ou igual a zero.');

  LBombaInfo := GetBombaInfo(ABombaId);
  Result := BuildResumo(LBombaInfo, AQuantidade);
end;

function TAbastecimentoService.BuildResumo(
  const ABombaInfo: TBombaCombustivelInfo;
  const AQuantidade: Double): TAbastecimentoResumo;
begin
  Result.BombaInfo := ABombaInfo;
  Result.QuantidadeSolicitada := AQuantidade;
  Result.EstoqueAtual := ABombaInfo.TanqueEstoqueAtual;
  Result.EstoqueAposSaida := ABombaInfo.TanqueEstoqueAtual - AQuantidade;
  Result.ValorUnitario := ABombaInfo.CombustivelValor;
  Result.Aliquota := ABombaInfo.CombustivelAliquota;
  Result.ValorBruto := SimpleRoundTo(AQuantidade * Result.ValorUnitario, -2);
  Result.ValorImposto := SimpleRoundTo(Result.ValorBruto * (Result.Aliquota / 100), -2);
  Result.ValorTotal := SimpleRoundTo(Result.ValorBruto + Result.ValorImposto, -2);
end;

function TAbastecimentoService.BuildAbastecimento(
  const ABombaInfo: TBombaCombustivelInfo; const AUsuarioId: Int64;
  const AQuantidade: Double;
  const ADataHora: TDateTime): TAbastecimento;
var
  LResumo: TAbastecimentoResumo;
begin
  LResumo := BuildResumo(ABombaInfo, AQuantidade);

  Result := TAbastecimento.Create;
  Result.DataHora := ADataHora;
  Result.BombaId := ABombaInfo.BombaId;
  Result.TanqueId := ABombaInfo.TanqueId;
  Result.UsuarioId := AUsuarioId;
  Result.CombustivelId := ABombaInfo.CombustivelId;
  Result.Quantidade := AQuantidade;
  Result.ValorUnitario := ABombaInfo.CombustivelValor;
  Result.Aliquota := ABombaInfo.CombustivelAliquota;
  Result.ValorTotal := LResumo.ValorTotal;
end;

procedure TAbastecimentoService.EnsureDisponibilidade(const ATanqueId: Int64;
  const AQuantidade: Double);
begin
  var LDisponivel := FTanqueRepository.GetAvailableQuantity(ATanqueId);
  if LDisponivel < AQuantidade then
    raise EAbastecimentoValidation.CreateFmt(
      'Tanque %d possui apenas %.2f litros disponíveis.',
      [ATanqueId, LDisponivel]
    );
end;

function TAbastecimentoService.ListarTodos: TObjectList<TAbastecimento>;
begin
  Result := FAbastecimentoRepository.FindAll;
end;

function TAbastecimentoService.ObterPorId(const AId: Int64): TAbastecimento;
begin
  Result := FAbastecimentoRepository.FindById(AId);
end;

procedure TAbastecimentoService.ValidateEntity(AAbastecimento: TAbastecimento);
begin
  if not FTanqueRepository.Exists(AAbastecimento.TanqueId) then
    raise EAbastecimentoValidation.Create('Tanque inválido');

  if not FBombaRepository.Exists(AAbastecimento.BombaId) then
    raise EAbastecimentoValidation.Create('Bomba inválida');
end;

procedure TAbastecimentoService.ValidateInput(const ABombaId: Int64;
  const AQuantidade: Double; const AUsuarioId: Int64;
  const ADataHora: TDateTime);
begin
  if ABombaId <= 0 then
    raise EAbastecimentoValidation.Create('Bomba inválida.');

  if AQuantidade <= 0 then
    raise EAbastecimentoValidation.Create('Quantidade deve ser maior que zero.');

  if AUsuarioId <= 0 then
    raise EAbastecimentoValidation.Create('Usuário inválido.');

  if ADataHora = 0 then
    raise EAbastecimentoValidation.Create('Data/Hora inválida.');
end;

function TAbastecimentoService.GetBombaInfo(
  const ABombaId: Int64): TBombaCombustivelInfo;
begin
  Result := FBombaRepository.FindInfoById(ABombaId);
  if Result.BombaId = 0 then
    raise EAbastecimentoValidation.CreateFmt('Bomba %d não encontrada.', [ABombaId]);

  if Result.TanqueId = 0 then
    raise EAbastecimentoValidation.CreateFmt('Bomba %d não está ligada a um tanque válido.', [ABombaId]);

  if Result.CombustivelId = 0 then
    raise EAbastecimentoValidation.CreateFmt('Tanque associado à bomba %d não possui combustível configurado.', [ABombaId]);

  Result.TanqueEstoqueAtual := FTanqueRepository.GetAvailableQuantity(Result.TanqueId);
end;

function TAbastecimentoService.Registrar(const ABombaId: Int64;
  const AQuantidade: Double; const AUsuarioId: Int64;
  const ADataHora: TDateTime): TAbastecimento;
begin
  ValidateInput(ABombaId, AQuantidade, AUsuarioId, ADataHora);

  var LBombaInfo := GetBombaInfo(ABombaId);
  EnsureDisponibilidade(LBombaInfo.TanqueId, AQuantidade);

  var LAbastecimento := BuildAbastecimento(LBombaInfo, AUsuarioId, AQuantidade, ADataHora);

  ValidateEntity(LAbastecimento);

  if not Assigned(FConnection) then
    raise EAbastecimentoValidation.Create('Conexão não configurada.');

  FConnection.BeginTransaction;
  try
    Result := FAbastecimentoRepository.Save(LAbastecimento);
    FTanqueMovimentoService.RegistrarMovimento(Result);
    FConnection.Commit;
  except
    FConnection.Rollback;
    if Assigned(LAbastecimento) then
      LAbastecimento.Free;
    raise;
  end;
end;

end.
