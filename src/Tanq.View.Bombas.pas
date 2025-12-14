unit Tanq.View.Bombas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Tanq.View.Interfaces, Tanq.Controller.Bombas, Tanq.Model.Repository.DTOs;

type
  TfrmBombas = class(TForm, IFrameView)
    pnlContainer: TPanel;
    pnlTop: TPanel;
    lblTitle: TLabel;
    btnClose: TSpeedButton;
    pnlContent: TPanel;
    pnlButtons: TPanel;
    lvBombas: TListView;
    btnNovo: TBitBtn;
    btnEditar: TBitBtn;
    btnExcluir: TBitBtn;
    btnAtualizar: TBitBtn;
    procedure btnNovoClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnAtualizarClick(Sender: TObject);
    procedure lvBombasDblClick(Sender: TObject);
  private
    FBombasController: TBombasController;
    procedure ClearListData;
    procedure LoadBombas;
    procedure AbrirCadastro(const ABombaId: Int64);
    function BombaSelecionada(out ABombaId: Int64): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CanClose: Boolean;
    function CloseButton: TSpeedButton;
    function AsForm: TForm;
  end;

implementation

{$R *.dfm}

uses
  Tanq.View.BombaEdit;

type
  PInt64 = ^Int64;

{ TfrmBombas }

function TfrmBombas.AsForm: TForm;
begin
  Result := Self;
end;

procedure TfrmBombas.AbrirCadastro(const ABombaId: Int64);
begin
  var LfrmBombaEdit := TfrmBombaEdit.Create(Self, FBombasController, ABombaId);
  try
    if LfrmBombaEdit.ShowModal = mrOk then
      LoadBombas;
  finally
    LfrmBombaEdit.Free;
  end;
end;

function TfrmBombas.BombaSelecionada(out ABombaId: Int64): Boolean;
var
  LPointer: PInt64;
begin
  Result := Assigned(lvBombas.Selected) and Assigned(lvBombas.Selected.Data);
  if Result then
  begin
    LPointer := lvBombas.Selected.Data;
    ABombaId := LPointer^;
  end;
end;

procedure TfrmBombas.btnAtualizarClick(Sender: TObject);
begin
  LoadBombas;
end;

procedure TfrmBombas.btnEditarClick(Sender: TObject);
var
  LBombaId: Int64;
begin
  if not BombaSelecionada(LBombaId) then
  begin
    MessageDlg('Selecione uma bomba para editar.', mtWarning, [mbOK], 0);
    Exit;
  end;
  AbrirCadastro(LBombaId);
end;

procedure TfrmBombas.btnExcluirClick(Sender: TObject);
var
  LBombaId: Int64;
begin
  if not BombaSelecionada(LBombaId) then
  begin
    MessageDlg('Selecione uma bomba para excluir.', mtWarning, [mbOK], 0);
    Exit;
  end;

  if not FBombasController.PodeExcluir(LBombaId) then
  begin
    MessageDlg('A bomba possui movimentações e não pode ser excluída.', mtWarning, [mbOK], 0);
    Exit;
  end;

  if MessageDlg('Confirma a exclus'#227'o da bomba selecionada?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      FBombasController.ExcluirBomba(LBombaId);
      LoadBombas;
    except
      on E: Exception do
        MessageDlg(E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TfrmBombas.btnNovoClick(Sender: TObject);
begin
  AbrirCadastro(0);
end;

function TfrmBombas.CanClose: Boolean;
begin
  Result := True;
end;

procedure TfrmBombas.ClearListData;
begin
  for var I := 0 to lvBombas.Items.Count - 1 do
    if Assigned(lvBombas.Items[I].Data) then
    begin
      Dispose(PInt64(lvBombas.Items[I].Data));
      lvBombas.Items[I].Data := nil;
    end;
end;

function TfrmBombas.CloseButton: TSpeedButton;
begin
  Result := btnClose;
end;

constructor TfrmBombas.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBombasController := TBombasController.Create;
  LoadBombas;
end;

destructor TfrmBombas.Destroy;
begin
  ClearListData;
  FBombasController.Free;
  inherited Destroy;
end;

procedure TfrmBombas.LoadBombas;
var
  LId: PInt64;
begin
  var LBombas := FBombasController.ListarBombas;
  lvBombas.Items.BeginUpdate;
  try
    ClearListData;
    lvBombas.Items.Clear;
    for var LBomba in LBombas do
    begin
      var LItem := lvBombas.Items.Add;
      LItem.Caption := LBomba.BombaDescricao;
      LItem.SubItems.Add(LBomba.TanqueDescricao);
      LItem.SubItems.Add(LBomba.CombustivelDescricao);
      New(LId);
      LId^ := LBomba.BombaId;
      LItem.Data := LId;
    end;
  finally
    lvBombas.Items.EndUpdate;
  end;
end;

procedure TfrmBombas.lvBombasDblClick(Sender: TObject);
var
  LBombaId: Int64;
begin
  if BombaSelecionada(LBombaId) then
    AbrirCadastro(LBombaId);
end;

end.
