unit Tanq.Model.Service.Bomba;

interface

uses
  System.SysUtils,
  Tanq.Model.Service.Interfaces,
  Tanq.Model.Service.Factory,
  Tanq.Model.Repository.Factory,
  Tanq.Model.Repository.Interfaces,
  Tanq.Model.Repository.DTOs,
  Tanq.Model.Entity.Bomba;

type
  TBombaService = class(TInterfacedObject, IBombaService)
  private
    FRepositoryFactory: TRepositoryFactory;
    FServiceFactory: TServiceFactory;

    FBombaRepository: IBombaRepository;
    FTanqueRepository: ITanqueRepository;

    function UpdateAvailableQuantity(const AInfo: TBombaCombustivelInfo): TBombaCombustivelInfo;
    procedure ValidateBomba(const ABomba: TBomba);
  public
    constructor Create(const AServiceFactory: TServiceFactory);

    function ListarComCombustivel: TArray<TBombaCombustivelInfo>;
    function ObterInfo(const ABombaId: Int64): TBombaCombustivelInfo;
    function ListarTanques: TArray<TTanqueCombustivelInfo>;
    function ObterBomba(const ABombaId: Int64): TBomba;
    function Salvar(const ABomba: TBomba): TBomba;
    procedure Excluir(const ABombaId: Int64);
    function PodeExcluir(const ABombaId: Int64): Boolean;
  end;

implementation

uses
  Tanq.Model.Entity.Tanque;

{ TBombaService }

constructor TBombaService.Create(const AServiceFactory: TServiceFactory);
begin
  if not Assigned(AServiceFactory) then
    raise EBombaServiceException.Create('Factory de serviços não disponível.');

  FServiceFactory := AServiceFactory;
  FRepositoryFactory := FServiceFactory.RepositoryFactory;

  if not Assigned(FRepositoryFactory) then
    raise EBombaServiceException.Create('Factory de repositórios não disponível.');

  FBombaRepository := FRepositoryFactory.Bomba;
  FTanqueRepository := FRepositoryFactory.Tanque;
end;

function TBombaService.UpdateAvailableQuantity(const AInfo: TBombaCombustivelInfo): TBombaCombustivelInfo;
begin
  Result := AInfo;
  if (Result.TanqueId > 0) then
    Result.TanqueEstoqueAtual := FTanqueRepository.GetAvailableQuantity(Result.TanqueId)
  else
    Result.TanqueEstoqueAtual := 0;
end;

function TBombaService.ListarComCombustivel: TArray<TBombaCombustivelInfo>;
begin
  Result := FBombaRepository.FindAllWithCombustivel;
  for var I := Low(Result) to High(Result) do
    Result[I] := UpdateAvailableQuantity(Result[I]);
end;

function TBombaService.ListarTanques: TArray<TTanqueCombustivelInfo>;
begin
  Result := FTanqueRepository.FindAllWithCombustivel;
  for var I := Low(Result) to High(Result) do
    Result[I].TanqueEstoqueAtual := FTanqueRepository.GetAvailableQuantity(Result[I].TanqueId);
end;

function TBombaService.ObterInfo(const ABombaId: Int64): TBombaCombustivelInfo;
begin
  Result := FBombaRepository.FindInfoById(ABombaId);

  if Result.BombaId = 0 then
    raise EBombaServiceException.CreateFmt('Bomba %d não encontrada.', [ABombaId]);

  Result := UpdateAvailableQuantity(Result);
end;

function TBombaService.ObterBomba(const ABombaId: Int64): TBomba;
begin
  Result := FBombaRepository.FindById(ABombaId);
  if not Assigned(Result) then
    raise EBombaServiceException.CreateFmt('Bomba %d não encontrada.', [ABombaId]);
end;

procedure TBombaService.ValidateBomba(const ABomba: TBomba);
begin
  if not Assigned(ABomba) then
    raise EBombaServiceException.Create('Bomba inválida.');

  if ABomba.Descricao.Trim = '' then
    raise EBombaServiceException.Create('Informe a descrição da bomba.');

  if not FTanqueRepository.Exists(ABomba.TanqueId) then
    raise EBombaServiceException.Create('Tanque inválido');
end;

function TBombaService.Salvar(const ABomba: TBomba): TBomba;
begin
  ValidateBomba(ABomba);
  Result := FBombaRepository.Save(ABomba);
end;

procedure TBombaService.Excluir(const ABombaId: Int64);
begin
  if not PodeExcluir(ABombaId) then
    raise EBombaServiceException.Create('Não é possível excluir a bomba selecionada.');

  FBombaRepository.Delete(ABombaId);
end;

function TBombaService.PodeExcluir(const ABombaId: Int64): Boolean;
var
  LBomba: TBomba;
begin
  LBomba := FBombaRepository.FindById(ABombaId);
  if not Assigned(LBomba) then
    raise EBombaServiceException.CreateFmt('Bomba %d não encontrada.', [ABombaId]);
  try
    Result := not FBombaRepository.HasMovements(ABombaId);
  finally
    LBomba.Free;
  end;
end;

end.
