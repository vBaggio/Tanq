unit Tanq.Model.Service.Factory;

interface

uses
  Tanq.Model.Service.Interfaces,
  Tanq.Model.Repository.Factory;

type
  TServiceFactory = class
  strict private
    FRepositoryFactory: TRepositoryFactory;
    FOwnsRepositoryFactory: Boolean;

    function EnsureRepositoryFactory: TRepositoryFactory;
  public
    constructor Create(const ARepositoryFactory: TRepositoryFactory = nil);
    destructor Destroy; override;

    function RepositoryFactory: TRepositoryFactory;

    function Abastecimento: IAbastecimentoService;
    function TanqueMovimento: ITanqueMovimentoService;
    function Reposicao: IReposicaoService;
    function Bomba: IBombaService;
    function Relatorio: IRelatorioService;
  end;
implementation

uses
  System.SysUtils,
  Tanq.Model.Service.Abastecimento,
  Tanq.Model.Service.TanqueMovimento,
  Tanq.Model.Service.Reposicao,
  Tanq.Model.Service.Bomba,
  Tanq.Model.Service.Relatorio,
  Tanq.Model.Conn.Factory;

{ TServiceFactory }
{ TServiceFactory }

constructor TServiceFactory.Create(const ARepositoryFactory: TRepositoryFactory);
begin
  inherited Create;
  if Assigned(ARepositoryFactory) then
  begin
    FRepositoryFactory := ARepositoryFactory;
    FOwnsRepositoryFactory := False;
  end
  else
  begin
    FRepositoryFactory := TRepositoryFactory.Create(TDbConnectionFactory.Default);
    FOwnsRepositoryFactory := True;
  end;
end;

destructor TServiceFactory.Destroy;
begin
  if FOwnsRepositoryFactory then
    FRepositoryFactory.Free;
  inherited Destroy;
end;

function TServiceFactory.EnsureRepositoryFactory: TRepositoryFactory;
begin
  Result := FRepositoryFactory;
  if not Assigned(Result) then
  begin
    FRepositoryFactory := TRepositoryFactory.Create(TDbConnectionFactory.Default);
    FOwnsRepositoryFactory := True;
    Result := FRepositoryFactory;
  end;
end;

function TServiceFactory.RepositoryFactory: TRepositoryFactory;
begin
  Result := EnsureRepositoryFactory;
end;

function TServiceFactory.Abastecimento: IAbastecimentoService;
begin
  Result := TAbastecimentoService.Create(Self);
end;

function TServiceFactory.Bomba: IBombaService;
begin
  Result := TBombaService.Create(Self);
end;

function TServiceFactory.Reposicao: IReposicaoService;
begin
  Result := TReposicaoService.Create(Self);
end;

function TServiceFactory.TanqueMovimento: ITanqueMovimentoService;
begin
  Result := TTanqueMovimentoService.Create(Self);
end;

function TServiceFactory.Relatorio: IRelatorioService;
begin
  Result := TRelatorioService.Create(Self);
end;

end.
