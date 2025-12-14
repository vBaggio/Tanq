unit Tanq.View.Relatorio.Abastecimento;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, RLReport, Data.DB, Vcl.StdCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TfrmRelAbastecimento = class(TForm)
    Report: TRLReport;
    Header: TRLBand;
    lblTitulo: TRLLabel;
    lblPeriodo: TRLLabel;
    GrupoDia: TRLGroup;
    srcRelatorio: TDataSource;
    HeaderDia: TRLBand;
    txtDATA_DIA: TRLDBText;
    RLLabel1: TRLLabel;
    GrupoTanque: TRLGroup;
    FooterDia: TRLBand;
    HeaderTanque: TRLBand;
    DetalheTanque: TRLBand;
    txtTanque: TRLDBText;
    lblTanque: TRLLabel;
    RLLabel2: TRLLabel;
    RLDBText1: TRLDBText;
    HeaderColunasTanque: TRLBand;
    lblHora: TRLLabel;
    RLLabel3: TRLLabel;
    RLLabel4: TRLLabel;
    RLLabel5: TRLLabel;
    RLLabel6: TRLLabel;
    RLLabel7: TRLLabel;
    RLLabel8: TRLLabel;
    RLDBText2: TRLDBText;
    RLDBText3: TRLDBText;
    RLDBText4: TRLDBText;
    RLDBText5: TRLDBText;
    SumTanque: TRLBand;
    RLDBText6: TRLDBText;
    RLDBText7: TRLDBText;
    RLDBText8: TRLDBText;
    ReportSummary: TRLBand;
    RLDBResult1: TRLDBResult;
    RLDBResult2: TRLDBResult;
    RLDBResult3: TRLDBResult;
    RLDBResult4: TRLDBResult;
    RLDBResult6: TRLDBResult;
    RLLabel10: TRLLabel;
    RLLabel11: TRLLabel;
    RLLabel13: TRLLabel;
    RLLabel9: TRLLabel;
    RLLabel12: TRLLabel;
    RLDBResult5: TRLDBResult;
    RLLabel14: TRLLabel;
    RLDBResult7: TRLDBResult;
  private

  public
    procedure PrepararRelatorio(const ADataSet: TDataSet;
      const ADataInicial, ADataFinal: TDateTime);
  end;

implementation

{$R *.dfm}

procedure TfrmRelAbastecimento.PrepararRelatorio(const ADataSet: TDataSet;
  const ADataInicial, ADataFinal: TDateTime);
const
  PERIOD_FORMAT = 'dd/mm/yyyy';
begin
  if not Assigned(ADataSet) then
    raise EArgumentNilException.Create('Dataset do relatorio nao foi informado.');

  lblPeriodo.Caption := Format('%s ate %s', [
    FormatDateTime(PERIOD_FORMAT, ADataInicial),
    FormatDateTime(PERIOD_FORMAT, ADataFinal)
  ]);

  srcRelatorio.DataSet := ADataSet;
  Report.DataSource := srcRelatorio;

  try
    Report.PreviewModal;
  finally
    Report.DataSource := nil;
    srcRelatorio.DataSet := nil;
  end;
end;

end.
