program Tanq;

uses
  Vcl.Forms,
  Tanq.View.Interfaces in 'src\Tanq.View.Interfaces.pas',
  Tanq.View.Factory in 'src\Tanq.View.Factory.pas',
  Tanq.View.Main in 'src\Tanq.View.Main.pas' {frmMain},
  Tanq.View.Welcome in 'src\Tanq.View.Welcome.pas' {frmWelcome},
  Tanq.View.Abastecimento in 'src\Tanq.View.Abastecimento.pas' {frmAbastecimento},
  Tanq.View.Bombas in 'src\Tanq.View.Bombas.pas' {frmBombas},
  Tanq.View.BombaEdit in 'src\Tanq.View.BombaEdit.pas' {frmBombaEdit},
  Tanq.View.Reposicao in 'src\Tanq.View.Reposicao.pas' {frmReposicao},
  Tanq.View.Relatorio in 'src\Tanq.View.Relatorio.pas' {frmRelatorio},
  Tanq.View.Relatorio.Abastecimento in 'src\Tanq.View.Relatorio.Abastecimento.pas' {frmRelAbastecimento},
  Tanq.Controller.Abastecimento in 'src\Tanq.Controller.Abastecimento.pas',
  Tanq.Controller.Reposicao in 'src\Tanq.Controller.Reposicao.pas',
  Tanq.Controller.Bombas in 'src\Tanq.Controller.Bombas.pas',
  Tanq.Controller.Relatorio in 'src\Tanq.Controller.Relatorio.pas',
  Tanq.Model.Config in 'src\Tanq.Model.Config.pas',
  Tanq.Model.Conn.Interfaces in 'src\Tanq.Model.Conn.Interfaces.pas',
  Tanq.Model.Conn.Factory in 'src\Tanq.Model.Conn.Factory.pas',
  Tanq.Model.Conn.Firebird in 'src\Tanq.Model.Conn.Firebird.pas',
  Tanq.Model.Entity.Usuario in 'src\Tanq.Model.Entity.Usuario.pas',
  Tanq.Model.Entity.Combustivel in 'src\Tanq.Model.Entity.Combustivel.pas',
  Tanq.Model.Entity.Tanque in 'src\Tanq.Model.Entity.Tanque.pas',
  Tanq.Model.Entity.Bomba in 'src\Tanq.Model.Entity.Bomba.pas',
  Tanq.Model.Entity.Abastecimento in 'src\Tanq.Model.Entity.Abastecimento.pas',
  Tanq.Model.Entity.Reposicao in 'src\Tanq.Model.Entity.Reposicao.pas',
  Tanq.Model.Entity.TanqueMovimento in 'src\Tanq.Model.Entity.TanqueMovimento.pas',
  Tanq.Model.Repository.Interfaces in 'src\Tanq.Model.Repository.Interfaces.pas',
  Tanq.Model.Repository.Factory in 'src\Tanq.Model.Repository.Factory.pas',
  Tanq.Model.Repository.DTOs in 'src\Tanq.Model.Repository.DTOs.pas',
  Tanq.Model.Repository.Combustivel in 'src\Tanq.Model.Repository.Combustivel.pas',
  Tanq.Model.Repository.Bomba in 'src\Tanq.Model.Repository.Bomba.pas',
  Tanq.Model.Repository.Tanque in 'src\Tanq.Model.Repository.Tanque.pas',
  Tanq.Model.Repository.Abastecimento in 'src\Tanq.Model.Repository.Abastecimento.pas',
  Tanq.Model.Repository.Reposicao in 'src\Tanq.Model.Repository.Reposicao.pas',
  Tanq.Model.Repository.TanqueMovimento in 'src\Tanq.Model.Repository.TanqueMovimento.pas',
  Tanq.Model.Repository.Relatorio in 'src\Tanq.Model.Repository.Relatorio.pas',
  Tanq.Model.Service.Interfaces in 'src\Tanq.Model.Service.Interfaces.pas',
  Tanq.Model.Service.Factory in 'src\Tanq.Model.Service.Factory.pas',
  Tanq.Model.Service.ConfigLoader in 'src\Tanq.Model.Service.ConfigLoader.pas',
  Tanq.Model.Service.Abastecimento in 'src\Tanq.Model.Service.Abastecimento.pas',
  Tanq.Model.Service.Reposicao in 'src\Tanq.Model.Service.Reposicao.pas',
  Tanq.Model.Service.TanqueMovimento in 'src\Tanq.Model.Service.TanqueMovimento.pas',
  Tanq.Model.Service.Bomba in 'src\Tanq.Model.Service.Bomba.pas',
  Tanq.Model.Service.Relatorio in 'src\Tanq.Model.Service.Relatorio.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
