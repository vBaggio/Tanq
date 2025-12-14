unit Tanq.Controller.Relatorio;

interface

uses
  System.SysUtils,
  Data.DB,
  Tanq.Model.Service.Interfaces,
  Tanq.Model.Service.Factory;

type
  TRelatorioController = class
  private
    FServiceFactory: TServiceFactory;
    FRelatorioService: IRelatorioService;
  public
    constructor Create;
    destructor Destroy; override;

    procedure GerarRelatorioAbastecimento(const ADataInicial, ADataFinal: TDateTime);
  end;

implementation

uses
  Tanq.View.Relatorio.Abastecimento;

{ TRelatorioController }

constructor TRelatorioController.Create;
begin
  inherited Create;
  FServiceFactory := TServiceFactory.Create;
  FRelatorioService := FServiceFactory.Relatorio;
end;

destructor TRelatorioController.Destroy;
begin
  FServiceFactory.Free;
  inherited Destroy;
end;

procedure TRelatorioController.GerarRelatorioAbastecimento(
  const ADataInicial, ADataFinal: TDateTime);
var
  LDataSet: TDataSet;
  LRelatorio: TfrmRelAbastecimento;
begin
  LDataSet := FRelatorioService.Gerar(ADataInicial, ADataFinal);
  LRelatorio := TfrmRelAbastecimento.Create(nil);
  try
    LRelatorio.PrepararRelatorio(LDataSet, ADataInicial, ADataFinal);
  finally
    LRelatorio.Free;
    LDataSet.Free;
  end;
end;

end.
