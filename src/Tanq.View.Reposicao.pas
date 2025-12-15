unit Tanq.View.Reposicao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.StrUtils,
  Tanq.View.Interfaces,
  Tanq.Controller.Reposicao,
  Tanq.Model.Repository.DTOs;

type
  TfrmReposicao = class(TForm, IFrameView)
    pnlContainer: TPanel;
    pnlTop: TPanel;
    lblTitle: TLabel;
    btnClose: TSpeedButton;
    pnlContent: TPanel;
    pnlButtons: TPanel;
    btnConfirmar: TBitBtn;
    btnCancelar: TBitBtn;
    pnlMain: TPanel;
    grpSelecao: TGroupBox;
    lblTanque: TLabel;
    cbTanques: TComboBox;
    lblCombustivel: TLabel;
    lblCapacidade: TLabel;
    lblEstoque: TLabel;
    lblDetalhesTanque: TLabel;
    lblDetalhesCombustivel: TLabel;
    lblDetalhesCapacidade: TLabel;
    lblDetalhesEstoque: TLabel;
    grpOperacao: TGroupBox;
    lblQuantidade: TLabel;
    edtQuantidade: TEdit;
    lblObservacao: TLabel;
    memObservacao: TMemo;
    lblEstoqueAtual: TLabel;
    lblEstoqueAtualValor: TLabel;
    lblEstoqueApos: TLabel;
    lblEstoqueAposValor: TLabel;
    lblCapacidadeDisponivel: TLabel;
    lblCapacidadeDisponivelValor: TLabel;
    procedure btnConfirmarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure cbTanquesChange(Sender: TObject);
    procedure edtQuantidadeChange(Sender: TObject);
  private
    FController: TReposicaoController;
    FResumoAtual: TReposicaoResumo;
    procedure LoadTanques;
    procedure ClearDetalhes;
    procedure UpdateResumo(const AResumo: TReposicaoResumo);
    procedure UpdateTotais(const AResumo: TReposicaoResumo);
    procedure HabilitarConfirmar;
    procedure ConfirmarReposicao;
    procedure Cancelar;
  public
    constructor Create(AOwner: TComponent); override;
    function CanClose: Boolean;
    function CloseButton: TSpeedButton;
    function AsForm: TForm;
  end;

implementation

{$R *.dfm}

{ TfrmReposicao }

function TfrmReposicao.AsForm: TForm;
begin
  Result := Self;
end;

procedure TfrmReposicao.btnCancelarClick(Sender: TObject);
begin
  Cancelar;
end;

procedure TfrmReposicao.btnConfirmarClick(Sender: TObject);
begin
  ConfirmarReposicao;
end;

procedure TfrmReposicao.Cancelar;
begin
  cbTanques.ItemIndex := -1;
  edtQuantidade.Clear;
  memObservacao.Clear;
  ClearDetalhes;
  HabilitarConfirmar;
end;

procedure TfrmReposicao.cbTanquesChange(Sender: TObject);
begin
  ClearDetalhes;
  if cbTanques.ItemIndex < 0 then
    Exit;

  var LTanqueId := Int64(cbTanques.Items.Objects[cbTanques.ItemIndex]);
  try
    FResumoAtual := FController.ObterResumoTanque(LTanqueId);
    UpdateResumo(FResumoAtual);
    edtQuantidadeChange(Sender);
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

function TfrmReposicao.CanClose: Boolean;
begin
  Result := True;
end;

procedure TfrmReposicao.ClearDetalhes;
begin
  lblDetalhesTanque.Caption := 'Nenhum tanque selecionado';
  lblDetalhesCombustivel.Caption := '--';
  lblDetalhesCapacidade.Caption := '--';
  lblDetalhesEstoque.Caption := '--';
  FResumoAtual := Default(TReposicaoResumo);
  UpdateTotais(FResumoAtual);
end;

function TfrmReposicao.CloseButton: TSpeedButton;
begin
  Result := btnClose;
end;

procedure TfrmReposicao.ConfirmarReposicao;
var
  LTanqueId: Int64;
  LQuantidade: Double;
begin
  if cbTanques.ItemIndex < 0 then
  begin
    MessageDlg('Selecione um tanque para continuar.', mtWarning, [mbOK], 0);
    Exit;
  end;

  if not TryStrToFloat(StringReplace(edtQuantidade.Text, ',', '.', [rfReplaceAll]), LQuantidade) then
  begin
    MessageDlg('Informe uma quantidade válida.', mtWarning, [mbOK], 0);
    edtQuantidade.SetFocus;
    Exit;
  end;

  LTanqueId := Int64(cbTanques.Items.Objects[cbTanques.ItemIndex]);
  try
    var LResult := FController.RegistrarReposicao(LTanqueId, LQuantidade, 1, Now, Trim(memObservacao.Text));
    MessageDlg(Format('Reposição %d registrada com sucesso.', [LResult.Id]), mtInformation, [mbOK], 0);
    Cancelar;
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

constructor TfrmReposicao.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FController := TReposicaoController.Create;
  LoadTanques;
  ClearDetalhes;
  HabilitarConfirmar;
end;

procedure TfrmReposicao.edtQuantidadeChange(Sender: TObject);
var
  LQuantidade: Double;
begin
  TryStrToFloat(edtQuantidade.Text, LQuantidade);

  if (cbTanques.ItemIndex < 0) or (LQuantidade <= 0) then
  begin
    UpdateTotais(Default(TReposicaoResumo));
    HabilitarConfirmar;
    Exit;
  end;

  try
    FResumoAtual := FController.CalcularResumo(Int64(cbTanques.Items.Objects[cbTanques.ItemIndex]), LQuantidade);
    UpdateTotais(FResumoAtual);
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;

  HabilitarConfirmar;
end;

procedure TfrmReposicao.HabilitarConfirmar;
var
  LQuantidade: Double;
begin
  btnConfirmar.Enabled := (cbTanques.ItemIndex >= 0) and
    TryStrToFloat(StringReplace(edtQuantidade.Text, ',', '.', [rfReplaceAll]), LQuantidade) and
    (LQuantidade > 0);
end;

procedure TfrmReposicao.LoadTanques;
var
  LInfos: TArray<TBombaCombustivelInfo>;
  Info: TBombaCombustivelInfo;
begin
  cbTanques.Items.BeginUpdate;
  try
    cbTanques.Clear;
    LInfos := FController.ListarTanques;
    for Info in LInfos do
      cbTanques.Items.AddObject(Format('%s (%s)', [Info.TanqueDescricao, Info.CombustivelDescricao]), TObject(Info.TanqueId));
  finally
    cbTanques.Items.EndUpdate;
  end;
end;

procedure TfrmReposicao.UpdateResumo(const AResumo: TReposicaoResumo);
begin
  lblDetalhesTanque.Caption := AResumo.TanqueInfo.TanqueDescricao;
  lblDetalhesCombustivel.Caption := AResumo.TanqueInfo.CombustivelDescricao;
  lblDetalhesCapacidade.Caption := Format('%.2f L', [AResumo.TanqueInfo.TanqueCapacidade]);
  lblDetalhesEstoque.Caption := Format('%.2f L', [AResumo.TanqueInfo.TanqueEstoqueAtual]);
end;

procedure TfrmReposicao.UpdateTotais(const AResumo: TReposicaoResumo);
begin
  lblEstoqueAtualValor.Caption := Format('%.2f L', [AResumo.EstoqueAtual]);
  lblEstoqueAposValor.Caption := Format('%.2f L', [AResumo.EstoqueAposEntrada]);
  lblCapacidadeDisponivelValor.Caption := Format('%.2f L', [AResumo.CapacidadeDisponivel]);
end;

end.
