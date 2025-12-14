program TanqTests;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  AbastecimentoServiceTests in 'tests\AbastecimentoServiceTests.pas';

var
  Runner: ITestRunner;
  Results: IRunResults;
  LResultsPath: string;

begin
  TDUnitX.CheckCommandLine;
  Runner := TDUnitX.CreateRunner;
  Runner.UseRTTI := True;
  Runner.AddLogger(TDUnitXConsoleLogger.Create(True));
  LResultsPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'TestResults.xml';
  Runner.AddLogger(TDUnitXXMLNUnitFileLogger.Create(LResultsPath));
  Results := Runner.Execute;
  if not Results.AllPassed then
    System.ExitCode := 1;
  Writeln('Pressione ENTER para sair...');
  Readln;
end.

