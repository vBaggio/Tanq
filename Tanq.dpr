program Tanq;

uses
  Vcl.Forms,
  Tanq.View.Main in 'src\Tanq.View.Main.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
