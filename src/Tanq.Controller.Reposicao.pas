unit Tanq.Controller.Reposicao;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Tanq.Model.Repository.DTOs,
  Tanq.Model.Entity.Reposicao,
  Tanq.Model.Service.Interfaces,
  Tanq.Model.Service.Factory;

type
  TReposicaoController = class
  private
    FServiceFactory: TServiceFactory;
    FReposicaoService: IReposicaoService;
    FBombaService: IBombaService;

    function BuildResumo(const ATanqueInfo: TBombaCombustivelInfo;
      const AQuantidade: Double): TReposicaoResumo;
    function EnsureTanqueInfo(const ATanqueId: Int64): TBombaCombustivelInfo;
    function UniqueTanques(const AInfos: TArray<TBombaCombustivelInfo>): TArray<TBombaCombustivelInfo>;
  public
    constructor Create;
    destructor Destroy; override;

    function ListarTanques: TArray<TBombaCombustivelInfo>;
    function ObterResumoTanque(const ATanqueId: Int64): TReposicaoResumo;
    function CalcularResumo(const ATanqueId: Int64;
      const AQuantidade: Double): TReposicaoResumo;
    function RegistrarReposicao(const ATanqueId: Int64; const AQuantidade: Double;
      const AUsuarioId: Int64; const ADataHora: TDateTime;
      const AObservacao: string): TReposicao;
  end;

implementation

{ TReposicaoController }

function TReposicaoController.BuildResumo(
  const ATanqueInfo: TBombaCombustivelInfo;
  const AQuantidade: Double): TReposicaoResumo;
begin
  Result.TanqueInfo := ATanqueInfo;
  Result.QuantidadeSolicitada := AQuantidade;
  Result.EstoqueAtual := ATanqueInfo.TanqueEstoqueAtual;
  Result.EstoqueAposEntrada := ATanqueInfo.TanqueEstoqueAtual + AQuantidade;
  Result.CapacidadeTotal := ATanqueInfo.TanqueCapacidade;
  Result.CapacidadeDisponivel := Result.CapacidadeTotal - Result.EstoqueAposEntrada;
  if Result.CapacidadeDisponivel < 0 then
    Result.CapacidadeDisponivel := 0;
end;

function TReposicaoController.CalcularResumo(const ATanqueId: Int64;
  const AQuantidade: Double): TReposicaoResumo;
begin
  var LTanqueInfo := EnsureTanqueInfo(ATanqueId);
  Result := BuildResumo(LTanqueInfo, AQuantidade);
end;

constructor TReposicaoController.Create;
begin
  FServiceFactory := TServiceFactory.Create;

  FReposicaoService := FServiceFactory.Reposicao;
  FBombaService := FServiceFactory.Bomba;
end;

destructor TReposicaoController.Destroy;
begin
  FServiceFactory.Free;
  inherited Destroy;
end;

function TReposicaoController.EnsureTanqueInfo(const ATanqueId: Int64): TBombaCombustivelInfo;
begin
  if ATanqueId <= 0 then
    raise EReposicaoValidation.Create('Selecione um tanque válido.');

  var LTanques := ListarTanques;
  for var Info in LTanques do
    if Info.TanqueId = ATanqueId then
      Exit(Info);

  raise EReposicaoValidation.CreateFmt('Tanque %d não encontrado.', [ATanqueId]);
end;

function TReposicaoController.ListarTanques: TArray<TBombaCombustivelInfo>;
begin
  var LInfos := FBombaService.ListarComCombustivel;
  Result := UniqueTanques(LInfos);
end;

function TReposicaoController.ObterResumoTanque(
  const ATanqueId: Int64): TReposicaoResumo;
begin
  var LTanqueInfo := EnsureTanqueInfo(ATanqueId);
  Result := BuildResumo(LTanqueInfo, 0);
end;

function TReposicaoController.RegistrarReposicao(
  const ATanqueId: Int64; const AQuantidade: Double;
  const AUsuarioId: Int64; const ADataHora: TDateTime;
  const AObservacao: string): TReposicao;
begin
  if not Assigned(FReposicaoService) then
    raise EReposicaoValidation.Create('Serviço de reposição indisponível.');

  Result := FReposicaoService.Registrar(ATanqueId, AQuantidade, AUsuarioId, ADataHora, AObservacao);
end;

function TReposicaoController.UniqueTanques(const AInfos: TArray<TBombaCombustivelInfo>): TArray<TBombaCombustivelInfo>;
begin
  var LDict := TDictionary<Int64, Boolean>.Create;
  var LList := TList<TBombaCombustivelInfo>.Create;
  try
    for var Info in AInfos do
      if (Info.TanqueId > 0) and (not LDict.ContainsKey(Info.TanqueId)) then
      begin
        LDict.Add(Info.TanqueId, True);
        LList.Add(Info);
      end;

    Result := LList.ToArray;
  finally
    LList.Free;
    LDict.Free;
  end;
end;

end.
