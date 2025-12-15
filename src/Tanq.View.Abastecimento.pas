unit Tanq.View.Abastecimento;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.StrUtils,
  Tanq.View.Interfaces,
  Tanq.Controller.Abastecimento,
  Tanq.Model.Service.Interfaces,
  Tanq.Model.Repository.DTOs;

type
  TfrmAbastecimento = class(TForm, IFrameView)
    pnlContainer: TPanel;
    pnlTop: TPanel;
    lblTitle: TLabel;
    btnClose: TSpeedButton;
    pnlContent: TPanel;
    pnlButtons: TPanel;
    pnlMain: TPanel;
    grpSelecao: TGroupBox;
    lblBomba: TLabel;
    cbBombas: TComboBox;
    lblCombustivel: TLabel;
    lblTanque: TLabel;
    lblValorUnitarioTitle: TLabel;
    lblEstoque: TLabel;
    grpOperacao: TGroupBox;
    lblQuantidade: TLabel;
    edtQuantidade: TEdit;
    lblValorUnitario: TLabel;
    lblImposto: TLabel;
    lblTotal: TLabel;
    btnConfirmar: TBitBtn;
    btnCancelar: TBitBtn;
    lblDetalhesBomba: TLabel;
    lblDetalhesCombustivel: TLabel;
    lblDetalhesTanque: TLabel;
    lblDetalhesValorUnitario: TLabel;
    lblDetalhesEstoque: TLabel;
    lblValorUnitarioValor: TLabel;
    lblImpostoValor: TLabel;
    lblTotalValor: TLabel;
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure edtQuantidadeChange(Sender: TObject);
    procedure cbBombasChange(Sender: TObject);
  private
    FController: TAbastecimentoController;
    FResumoAtual: TAbastecimentoResumo;
    procedure LoadBombas;
    procedure ClearDetalhes;
    procedure UpdateResumo(const AResumo: TAbastecimentoResumo);
    procedure UpdateTotais(const AResumo: TAbastecimentoResumo);
    procedure HabilitarConfirmar;
    procedure ConfirmarAbastecimento;
    procedure Cancelar;
  public
    constructor Create(AOwner: TComponent); override;
    function CanClose: Boolean;
    function CloseButton: TSpeedButton;
    function AsForm: TForm;
  end;

implementation

{$R *.dfm}

{ TfrmAbastecimento }

function TfrmAbastecimento.AsForm: TForm;
begin
  Result := Self;
end;

function TfrmAbastecimento.CanClose: Boolean;
begin
  Result := True;
end;

procedure TfrmAbastecimento.cbBombasChange(Sender: TObject);
begin
  ClearDetalhes;
  if cbBombas.ItemIndex < 0 then
    Exit;

  var LBombaId := Int64(cbBombas.Items.Objects[cbBombas.ItemIndex]);
  try
    FResumoAtual := FController.ObterResumoBomba(LBombaId);
    UpdateResumo(FResumoAtual);
    edtQuantidadeChange(Sender);
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

function TfrmAbastecimento.CloseButton: TSpeedButton;
begin
  Result := btnClose;
end;

constructor TfrmAbastecimento.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FController := TAbastecimentoController.Create;
  LoadBombas;
  ClearDetalhes;
  HabilitarConfirmar;
end;

procedure TfrmAbastecimento.edtQuantidadeChange(Sender: TObject);
var
  LQuantidade: Double;
begin
   TryStrToFloat(edtQuantidade.Text, LQuantidade);

  if (cbBombas.ItemIndex < 0) or (LQuantidade <= 0) then
  begin
    UpdateTotais(Default(TAbastecimentoResumo));
    HabilitarConfirmar;
    Exit;
  end;

  try
    FResumoAtual := FController.CalcularTotais(Int64(cbBombas.Items.Objects[cbBombas.ItemIndex]), LQuantidade);
    UpdateTotais(FResumoAtual);
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;

  HabilitarConfirmar;
end;

procedure TfrmAbastecimento.btnCancelarClick(Sender: TObject);
begin
  Cancelar;
end;

procedure TfrmAbastecimento.btnConfirmarClick(Sender: TObject);
begin
  ConfirmarAbastecimento;
end;

procedure TfrmAbastecimento.Cancelar;
begin
  edtQuantidade.Clear;
  cbBombas.ItemIndex := -1;
  ClearDetalhes;
  HabilitarConfirmar;
end;

procedure TfrmAbastecimento.ClearDetalhes;
begin
  lblDetalhesBomba.Caption := 'Nenhuma bomba selecionada';
  lblDetalhesCombustivel.Caption := '--';
  lblDetalhesTanque.Caption := '--';
  lblDetalhesValorUnitario.Caption := 'R$ 0,00';
  lblDetalhesEstoque.Caption := '--';
  FResumoAtual := Default(TAbastecimentoResumo);
  UpdateTotais(FResumoAtual);
end;

procedure TfrmAbastecimento.ConfirmarAbastecimento;
var
  LBombaId: Int64;
  LQuantidade: Double;
begin
  if cbBombas.ItemIndex < 0 then
  begin
    MessageDlg('Selecione uma bomba para continuar.', mtWarning, [mbOK], 0);
    Exit;
  end;

  if not TryStrToFloat(StringReplace(edtQuantidade.Text, ',', '.', [rfReplaceAll]), LQuantidade) then
  begin
    MessageDlg('Informe uma quantidade válida.', mtWarning, [mbOK], 0);
    edtQuantidade.SetFocus;
    Exit;
  end;

  LBombaId := Int64(cbBombas.Items.Objects[cbBombas.ItemIndex]);
  try
    var LResult := FController.RegistrarAbastecimento(LBombaId, LQuantidade, 1, Now);
    MessageDlg(Format('Abastecimento %d registrado com sucesso.', [LResult.Id]), mtInformation, [mbOK], 0);
    Cancelar;
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmAbastecimento.HabilitarConfirmar;
var
  LQuantidade: Double;
begin
  btnConfirmar.Enabled := (cbBombas.ItemIndex >= 0) and
    TryStrToFloat(StringReplace(edtQuantidade.Text, ',', '.', [rfReplaceAll]), LQuantidade) and
    (LQuantidade > 0);
end;

procedure TfrmAbastecimento.LoadBombas;
var
  LInfos: TArray<TBombaCombustivelInfo>;
  Info: TBombaCombustivelInfo;
begin
  cbBombas.Items.BeginUpdate;
  try
    cbBombas.Clear;
    LInfos := FController.ListarBombas;
    for Info in LInfos do
      cbBombas.Items.AddObject(Format('%s (%s)', [Info.BombaDescricao, Info.CombustivelDescricao]), TObject(Info.BombaId));
  finally
    cbBombas.Items.EndUpdate;
  end;
end;
procedure TfrmAbastecimento.UpdateResumo(const AResumo: TAbastecimentoResumo);
begin
  lblDetalhesBomba.Caption := AResumo.BombaInfo.BombaDescricao;
  lblDetalhesCombustivel.Caption := Format('%s (%s)', [AResumo.BombaInfo.CombustivelDescricao, AResumo.BombaInfo.CombustivelUnidade]);
  lblDetalhesTanque.Caption := Format('%s - Capacidade: %.2f L', [AResumo.BombaInfo.TanqueDescricao, AResumo.BombaInfo.TanqueCapacidade]);
  lblDetalhesValorUnitario.Caption := Format('R$ %.2f', [AResumo.BombaInfo.CombustivelValor]);
  lblDetalhesEstoque.Caption := Format(' %.2f L', [AResumo.BombaInfo.TanqueEstoqueAtual]);
end;

procedure TfrmAbastecimento.UpdateTotais(const AResumo: TAbastecimentoResumo);
begin
  lblValorUnitarioValor.Caption := Format('R$ %.2f', [AResumo.ValorBruto]);
  lblImpostoValor.Caption := Format('R$ %.2f', [AResumo.ValorImposto]);
  lblTotalValor.Caption := Format('R$ %.2f', [AResumo.ValorTotal]);
end;

end.
