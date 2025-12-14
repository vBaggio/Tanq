unit Tanq.Controller.Bombas;

interface

uses
  System.SysUtils,
  Tanq.Model.Repository.DTOs,
  Tanq.Model.Entity.Bomba,
  Tanq.Model.Service.Interfaces,
  Tanq.Model.Service.Factory;

type
  TBombasController = class
  private
    FBombaService: IBombaService;
    FServiceFactory: TServiceFactory;
  public
    constructor Create;
    destructor Destroy; override;

    function ListarBombas: TArray<TBombaCombustivelInfo>;
    function ListarTanques: TArray<TTanqueCombustivelInfo>;
    function ObterBomba(const ABombaId: Int64): TBomba;
    procedure SalvarBomba(const ABombaId: Int64; const ADescricao: string;
      const ATanqueId: Int64);
    procedure ExcluirBomba(const ABombaId: Int64);
    function PodeExcluir(const ABombaId: Int64): Boolean;
  end;

implementation

{ TBombasController }

constructor TBombasController.Create;
begin
  FServiceFactory := TServiceFactory.Create;
  FBombaService := FServiceFactory.Bomba;
end;

destructor TBombasController.Destroy;
begin
  FServiceFactory.Free;
  inherited Destroy;
end;

procedure TBombasController.ExcluirBomba(const ABombaId: Int64);
begin
  FBombaService.Excluir(ABombaId);
end;

function TBombasController.ListarBombas: TArray<TBombaCombustivelInfo>;
begin
  Result := FBombaService.ListarComCombustivel;
end;

function TBombasController.ListarTanques: TArray<TTanqueCombustivelInfo>;
begin
  Result := FBombaService.ListarTanques;
end;

function TBombasController.ObterBomba(const ABombaId: Int64): TBomba;
begin
  Result := FBombaService.ObterBomba(ABombaId);
end;

function TBombasController.PodeExcluir(const ABombaId: Int64): Boolean;
begin
  Result := FBombaService.PodeExcluir(ABombaId);
end;

procedure TBombasController.SalvarBomba(const ABombaId: Int64;
  const ADescricao: string; const ATanqueId: Int64);
var
  LBomba: TBomba;
begin
  LBomba := TBomba.Create;
  try
    LBomba.Id := ABombaId;
    LBomba.Descricao := Trim(ADescricao);
    LBomba.TanqueId := ATanqueId;
    FBombaService.Salvar(LBomba);
  finally
    LBomba.Free;
  end;
end;

end.
