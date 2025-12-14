unit Tanq.View.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  Vcl.Menus,
  Tanq.View.Interfaces;

type
  TfrmMain = class(TForm)
    pnlContent: TPanel;
    pnlContentHost: TPanel;
    pnlNavBar: TPanel;
    lblTitle: TLabel;
    pnlNavButtons: TPanel;
    btnBombas: TSpeedButton;
    btnReposicao: TSpeedButton;
    btnAbastecimento: TSpeedButton;
    btlRelatorio: TSpeedButton;
    procedure btnBombasMouseEnter(Sender: TObject);
    procedure btnBombasMouseLeave(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnBombasClick(Sender: TObject);
    procedure btnAbastecimentoClick(Sender: TObject);
    procedure btnReposicaoClick(Sender: TObject);
    procedure btlRelatorioClick(Sender: TObject);
  private
    FCurrentView: IFrameView;
  public
    procedure ClearContentHost;
    function  CloseCurrentChildFrame: Boolean;
    procedure LoadChildFrame(const AKind: TViewKind);
    procedure WireCloseButton(const AView: IFrameView);
    procedure HandleCloseButtonClick(Sender: TObject);
  end;

var
  frmMain: TfrmMain;

implementation

uses
  Tanq.View.Factory;

{$R *.dfm}

procedure TfrmMain.btnBombasClick(Sender: TObject);
begin
  LoadChildFrame(vkBombas);
end;

procedure TfrmMain.btnAbastecimentoClick(Sender: TObject);
begin
  LoadChildFrame(vkAbastecimento);
end;

procedure TfrmMain.btnReposicaoClick(Sender: TObject);
begin
  LoadChildFrame(vkReposicao);
end;

procedure TfrmMain.btlRelatorioClick(Sender: TObject);
begin
  LoadChildFrame(vkRelatorio);
end;

procedure TfrmMain.btnBombasMouseEnter(Sender: TObject);
begin
  TSpeedButton(Sender).Font.Color := $00C08000;
end;

procedure TfrmMain.btnBombasMouseLeave(Sender: TObject);
begin
  TSpeedButton(Sender).Font.Color := clWhite;
end;

procedure TfrmMain.ClearContentHost;
begin
  while pnlContentHost.ControlCount > 0 do
  begin
    pnlContentHost.Controls[0].Parent := nil;
    pnlContentHost.Controls[0].Free;
  end;
end;

function TfrmMain.CloseCurrentChildFrame: Boolean;
begin
  if not Assigned(FCurrentView) then
    Exit(True);

  if not FCurrentView.CanClose then
    Exit(False);

  var LForm := FCurrentView.AsForm;
  LForm.Close;
  LForm.Parent := nil;
  FreeAndNil(LForm);
  FCurrentView := nil;

  Result := True;
  ClearContentHost;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CloseCurrentChildFrame;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FCurrentView := nil;
  DoubleBuffered := True;
  pnlContent.DoubleBuffered := True;
  pnlContentHost.DoubleBuffered := True;
  LoadChildFrame(vkWelcome);
end;

procedure TfrmMain.HandleCloseButtonClick(Sender: TObject);
begin
  CloseCurrentChildFrame;
  ActiveControl := nil;
  LoadChildFrame(vkWelcome);
end;

procedure TfrmMain.LoadChildFrame(const AKind: TViewKind);
begin
  if not CloseCurrentChildFrame then
    Exit;

  var LNewView := TViewFactory.CreateView(Self, AKind);

  if not Assigned(LNewView) then
    Exit;

  var LForm := LNewView.AsForm;
  LForm.BorderStyle := bsNone;
  LForm.Parent := pnlContentHost;
  LForm.Align := alClient;
  LForm.Show;

  FCurrentView := LNewView;
  WireCloseButton(FCurrentView);
end;

procedure TfrmMain.WireCloseButton(const AView: IFrameView);
begin
  if not Assigned(AView) then
    Exit;

  var LButton := AView.CloseButton;
  if Assigned(LButton) then
  begin
    LButton.OnClick := HandleCloseButtonClick;
    LButton.Cursor := crHandPoint;
  end;
end;

end.
