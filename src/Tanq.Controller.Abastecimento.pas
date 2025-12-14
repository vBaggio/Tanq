unit Tanq.Controller.Abastecimento;

interface

uses
  System.SysUtils,
  Tanq.Model.Repository.DTOs,
  Tanq.Model.Entity.Abastecimento,
  Tanq.Model.Service.Interfaces,
  Tanq.Model.Service.Factory;

  type
  TAbastecimentoController = class
  private
    FAbastecimentoService: IAbastecimentoService;
    FBombaService: IBombaService;

    FServiceFactory: TServiceFactory;
  public
    constructor Create;
    destructor Destroy; override;

    function ListarBombas: TArray<TBombaCombustivelInfo>;
    function ObterResumoBomba(const ABombaId: Int64): TAbastecimentoResumo;
    function CalcularTotais(const ABombaId: Int64; const AQuantidade: Double): TAbastecimentoResumo;
    function RegistrarAbastecimento(const ABombaId: Int64; const AQuantidade: Double;
      const AUsuarioId: Int64; const ADataHora: TDateTime): TAbastecimento;
  end;

implementation

function TAbastecimentoController.CalcularTotais(const ABombaId: Int64;
  const AQuantidade: Double): TAbastecimentoResumo;
begin
  Result := FAbastecimentoService.CalcularResumo(ABombaId, AQuantidade);
end;

constructor TAbastecimentoController.Create;
begin
  inherited Create;
  FServiceFactory := TServiceFactory.Create;

  FAbastecimentoService := FServiceFactory.Abastecimento;
  FBombaService := FServiceFactory.Bomba;
end;

destructor TAbastecimentoController.Destroy;
begin
  FServiceFactory.Free;
  inherited Destroy;
end;

function TAbastecimentoController.ListarBombas: TArray<TBombaCombustivelInfo>;
begin
  Result := FBombaService.ListarComCombustivel;
end;

function TAbastecimentoController.ObterResumoBomba(const ABombaId: Int64): TAbastecimentoResumo;
begin
  Result := FAbastecimentoService.CalcularResumo(ABombaId, 0);
end;

function TAbastecimentoController.RegistrarAbastecimento(
  const ABombaId: Int64; const AQuantidade: Double;
  const AUsuarioId: Int64; const ADataHora: TDateTime): TAbastecimento;
begin
  Result := FAbastecimentoService.Registrar(ABombaId, AQuantidade, AUsuarioId, ADataHora);
end;

end.
