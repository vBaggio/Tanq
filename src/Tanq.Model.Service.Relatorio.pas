unit Tanq.Model.Service.Relatorio;

interface

uses
  System.SysUtils,
  Data.DB,
  Tanq.Model.Service.Interfaces,
  Tanq.Model.Service.Factory,
  Tanq.Model.Repository.Factory,
  Tanq.Model.Repository.Interfaces;

type
  TRelatorioService = class(TInterfacedObject, IRelatorioService)
  strict private
    FServiceFactory: TServiceFactory;
    FRepositoryFactory: TRepositoryFactory;
    FRepository: IRelatorioRepository;
    procedure ValidatePeriodo(const ADataInicial, ADataFinal: TDateTime);
    function AjustarInicio(const AData: TDateTime): TDateTime;
    function AjustarFim(const AData: TDateTime): TDateTime;
  public
    constructor Create(const AServiceFactory: TServiceFactory);
    function Gerar(const ADataInicial, ADataFinal: TDateTime): TDataSet;
  end;

implementation

uses
  System.DateUtils;

{ TRelatorioService }

constructor TRelatorioService.Create(const AServiceFactory: TServiceFactory);
begin
  if not Assigned(AServiceFactory) then
    raise ERelatorioException.Create('Factory de serviços não disponível.');

  FServiceFactory := AServiceFactory;
  FRepositoryFactory := FServiceFactory.RepositoryFactory;

  if not Assigned(FRepositoryFactory) then
    raise ERelatorioException.Create('Factory de repositórios não disponível.');

  FRepository := FRepositoryFactory.Relatorio;
end;

function TRelatorioService.AjustarFim(const AData: TDateTime): TDateTime;
begin
  Result := EndOfTheDay(AData);
end;

function TRelatorioService.AjustarInicio(const AData: TDateTime): TDateTime;
begin
  Result := StartOfTheDay(AData);
end;

function TRelatorioService.Gerar(const ADataInicial, ADataFinal: TDateTime): TDataSet;
var
  LInicio: TDateTime;
  LFim: TDateTime;
begin
  ValidatePeriodo(ADataInicial, ADataFinal);

  LInicio := AjustarInicio(ADataInicial);
  LFim := AjustarFim(ADataFinal);

  Result := FRepository.GerarRelatorioAbastecimento(LInicio, LFim);
end;

procedure TRelatorioService.ValidatePeriodo(const ADataInicial, ADataFinal: TDateTime);
begin
  if (ADataInicial = 0) or (ADataFinal = 0) then
    raise ERelatorioException.Create('Informe o período desejado.');

  if Trunc(ADataInicial) > Trunc(ADataFinal) then
    raise ERelatorioException.Create('Data inicial deve ser menor ou igual à data final.');
end;

end.
