unit Tanq.View.BombaEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
  Tanq.Controller.Bombas, Tanq.Model.Repository.DTOs, Tanq.Model.Entity.Bomba;

type
  TfrmBombaEdit = class(TForm)
    lblDescricao: TLabel;
    edtDescricao: TEdit;
    lblTanque: TLabel;
    cbTanques: TComboBox;
    lblCombustivel: TLabel;
    lblCombustivelValor: TLabel;
    lblEstoque: TLabel;
    lblEstoqueValor: TLabel;
    btnSalvar: TBitBtn;
    btnCancelar: TBitBtn;
    procedure cbTanquesChange(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
  private
    FBombasController: TBombasController;
    FBombaId: Int64;
    FTanques: TArray<TTanqueCombustivelInfo>;
    procedure LoadTanques;
    procedure LoadBomba;
    procedure UpdateTanqueInfo;
    function SelectedTanqueInfo(out AInfo: TTanqueCombustivelInfo): Boolean;
  public
    constructor Create(AOwner: TComponent; const AController: TBombasController; const ABombaId: Int64 = 0); reintroduce;
  end;

implementation

{$R *.dfm}

{ TfrmBombaEdit }

procedure TfrmBombaEdit.btnSalvarClick(Sender: TObject);
var
  LInfo: TTanqueCombustivelInfo;
begin
  if Trim(edtDescricao.Text) = '' then
  begin
    MessageDlg('Informe a descrição da bomba.', mtWarning, [mbOK], 0);
    edtDescricao.SetFocus;
    Exit;
  end;

  if not SelectedTanqueInfo(LInfo) then
  begin
    MessageDlg('Selecione o tanque associado.', mtWarning, [mbOK], 0);
    cbTanques.SetFocus;
    Exit;
  end;

  try
    FBombasController.SalvarBomba(FBombaId, Trim(edtDescricao.Text), LInfo.TanqueId);
    ModalResult := mrOk;
  except
    on E: Exception do
      MessageDlg(E.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmBombaEdit.cbTanquesChange(Sender: TObject);
begin
  UpdateTanqueInfo;
end;

constructor TfrmBombaEdit.Create(AOwner: TComponent;
  const AController: TBombasController; const ABombaId: Int64);
begin
  inherited Create(AOwner);
  FBombasController := AController;
  FBombaId := ABombaId;
  Position := poScreenCenter;

  LoadTanques;
  if FBombaId > 0 then
    LoadBomba
  else
    UpdateTanqueInfo;
end;

procedure TfrmBombaEdit.LoadBomba;
begin
  var LBomba := FBombasController.ObterBomba(FBombaId);
  try
    edtDescricao.Text := LBomba.Descricao;
    for var I := Low(FTanques) to High(FTanques) do
      if FTanques[I].TanqueId = LBomba.TanqueId then
      begin
        cbTanques.ItemIndex := I;
        Break;
      end;
    UpdateTanqueInfo;
  finally
    LBomba.Free;
  end;
end;

procedure TfrmBombaEdit.LoadTanques;
begin
  FTanques := FBombasController.ListarTanques;
  cbTanques.Items.BeginUpdate;
  try
    cbTanques.Clear;
    for var I := Low(FTanques) to High(FTanques) do
      cbTanques.Items.Add(
        Format('%s (%s)', [FTanques[I].TanqueDescricao, FTanques[I].CombustivelDescricao]));
    if cbTanques.Items.Count > 0 then
      cbTanques.ItemIndex := 0
    else
      cbTanques.ItemIndex := -1;
  finally
    cbTanques.Items.EndUpdate;
  end;
end;

function TfrmBombaEdit.SelectedTanqueInfo(out AInfo: TTanqueCombustivelInfo): Boolean;
begin
  Result := False;
  if (cbTanques.ItemIndex < 0) then
    Exit;

  if (cbTanques.ItemIndex >= Low(FTanques)) and
     (cbTanques.ItemIndex <= High(FTanques)) then
  begin
    AInfo := FTanques[cbTanques.ItemIndex];
    Result := True;
  end;
end;

procedure TfrmBombaEdit.UpdateTanqueInfo;
var
  LInfo: TTanqueCombustivelInfo;
begin
  if SelectedTanqueInfo(LInfo) then
  begin
    lblCombustivelValor.Caption := LInfo.CombustivelDescricao;
    lblEstoqueValor.Caption := Format('%.2f %s',
      [LInfo.TanqueEstoqueAtual, LInfo.CombustivelUnidade]);
  end
  else
  begin
    lblCombustivelValor.Caption := '--';
    lblEstoqueValor.Caption := '--';
  end;
end;

end.
