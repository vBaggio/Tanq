unit Tanq.View.Relatorio;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, System.DateUtils, System.UITypes,
  Tanq.View.Interfaces, Tanq.Controller.Relatorio;

type
  TfrmRelatorio = class(TForm, IFrameView)
    pnlContainer: TPanel;
    pnlTop: TPanel;
    lblTitle: TLabel;
    btnClose: TSpeedButton;
    pnlContent: TPanel;
    pnlButtons: TPanel;
    pnlFilters: TPanel;
    lblDataInicial: TLabel;
    lblDataFinal: TLabel;
    dtpInicio: TDateTimePicker;
    dtpFim: TDateTimePicker;
    GroupBox1: TGroupBox;
    btnGerar: TButton;
    procedure btnGerarClick(Sender: TObject);
  private
    FController: TRelatorioController;
    function TryObterPeriodo(out ADataInicial, ADataFinal: TDate): Boolean;
    procedure MostrarErro(const AMensagem: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CanClose: Boolean;
    function CloseButton: TSpeedButton;
    function AsForm: TForm;
  end;

implementation

{$R *.dfm}

{ TfrmRelatorio }

function TfrmRelatorio.AsForm: TForm;
begin
  Result := Self;
end;

procedure TfrmRelatorio.btnGerarClick(Sender: TObject);
var
  LDataInicial: TDate;
  LDataFinal: TDate;
begin
  if not TryObterPeriodo(LDataInicial, LDataFinal) then
    Exit;

  try
    FController.GerarRelatorioAbastecimento(LDataInicial, LDataFinal);
  except
    on E: Exception do
      MostrarErro(E.Message);
  end;
end;

function TfrmRelatorio.CanClose: Boolean;
begin
  Result := True;
end;

function TfrmRelatorio.CloseButton: TSpeedButton;
begin
  Result := btnClose;
end;

constructor TfrmRelatorio.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FController := TRelatorioController.Create;
  dtpInicio.Date := Date;
  dtpFim.Date := Date;
end;

destructor TfrmRelatorio.Destroy;
begin
  FController.Free;
  inherited Destroy;
end;

procedure TfrmRelatorio.MostrarErro(const AMensagem: string);
begin
  MessageDlg(AMensagem, mtError, [mbOK], 0);
end;

function TfrmRelatorio.TryObterPeriodo(out ADataInicial, ADataFinal: TDate): Boolean;
begin
  ADataInicial := dtpInicio.Date;
  ADataFinal := dtpFim.Date;

  Result := False;

  if (ADataInicial = 0) or (ADataFinal = 0) then
  begin
    MostrarErro('Informe o periodo desejado.');
    Exit;
  end;

  if CompareDate(ADataInicial, ADataFinal) = 1 then
  begin
    MostrarErro('Data inicial deve ser menor ou igual a data final.');
    Exit;
  end;

  Result := True;
end;

end.
