unit Tanq.View.Welcome;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons, Tanq.View.Interfaces;

type
  TfrmWelcome = class(TForm, IFrameView)
    pnlContainer: TPanel;
    lblTitle: TLabel;
    lblDescription: TLabel;
  private
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    function CanClose: Boolean;
    function CloseButton: TSpeedButton;
    function AsForm: TForm;
  end;

implementation

{$R *.dfm}

{ TForm1 }

function TfrmWelcome.AsForm: TForm;
begin
  Result := Self;
end;

function TfrmWelcome.CanClose: Boolean;
begin
  Result := True;
end;

function TfrmWelcome.CloseButton: TSpeedButton;
begin
  Result := nil;
end;

constructor TfrmWelcome.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

end.
