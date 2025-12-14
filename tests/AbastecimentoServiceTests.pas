unit AbastecimentoServiceTests;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  System.DateUtils,
  FireDAC.Comp.Client,
  DUnitX.TestFramework,
  Tanq.Model.Service.Abastecimento,
  Tanq.Model.Service.Interfaces,
  Tanq.Model.Repository.Interfaces,
  Tanq.Model.Repository.DTOs,
  Tanq.Model.Entity.Abastecimento,
  Tanq.Model.Entity.Bomba,
  Tanq.Model.Entity.Reposicao,
  Tanq.Model.Entity.Tanque,
  Tanq.Model.Conn.Interfaces;

type
  TFakeDbConnection = class(TInterfacedObject, IDbConnection)
  public
    BeginCalled: Integer;
    CommitCalled: Integer;
    RollbackCalled: Integer;
    InTransactionFlag: Boolean;

    function GetConn: TFDConnection;
    function Test: Boolean;
    procedure BeginTransaction;
    procedure EnsureTransaction;
    procedure Commit;
    procedure Rollback;
    function InTransaction: Boolean;
  end;

  TFakeAbastecimentoRepository = class(TInterfacedObject, IAbastecimentoRepository)
  private
    FData: TObjectList<TAbastecimento>;
    FNextId: Int64;
  public
    constructor Create;
    destructor Destroy; override;
    function FindAll: TObjectList<TAbastecimento>;
    function FindById(const AId: Int64): TAbastecimento;
    function Save(AEntity: TAbastecimento): TAbastecimento;
    property Data: TObjectList<TAbastecimento> read FData;
  end;

  TFakeTanqueRepository = class(TInterfacedObject, ITanqueRepository)
  private
    FAvailable: TDictionary<Int64, Double>;
  public
    constructor Create;
    destructor Destroy; override;
    function FindById(const ATanqueId: Int64): TTanque;
    function FindAllWithCombustivel: TArray<TTanqueCombustivelInfo>;
    function GetAvailableQuantity(const ATanqueId: Int64): Double;
    function HasAvailableQuantity(const ATanqueId: Int64; const ARequired: Double): Boolean;
    function Exists(const ATanqueId: Int64): Boolean;
    procedure SetAvailableQuantity(const ATanqueId: Int64; const AQuantidade: Double);
  end;

  TFakeBombaRepository = class(TInterfacedObject, IBombaRepository)
  private
    FBombas: TDictionary<Int64, TBombaCombustivelInfo>;
  public
    constructor Create;
    destructor Destroy; override;
    function FindAllWithCombustivel: TArray<TBombaCombustivelInfo>;
    function FindInfoById(const ABombaId: Int64): TBombaCombustivelInfo;
    function FindById(const ABombaId: Int64): TBomba;
    function Save(const ABomba: TBomba): TBomba;
    procedure Delete(const ABombaId: Int64);
    function HasMovements(const ABombaId: Int64): Boolean;
    function Exists(const ABombaId: Int64): Boolean;
    procedure AddBombaInfo(const AInfo: TBombaCombustivelInfo);
  end;

  TFakeTanqueMovimentoService = class(TInterfacedObject, ITanqueMovimentoService)
  public
    AbastecimentosRegistrados: Integer;
    ReposicoesRegistradas: Integer;
    LastAbastecimento: TAbastecimento;
    procedure RegistrarMovimento(const AAbastecimento: TAbastecimento); overload;
    procedure RegistrarMovimento(const AReposicao: TReposicao); overload;
  end;

  [TestFixture]
  TAbastecimentoServiceTests = class
  private
    FConnection: TFakeDbConnection;
    FAbastecimentoRepo: TFakeAbastecimentoRepository;
    FTanqueRepo: TFakeTanqueRepository;
    FBombaRepo: TFakeBombaRepository;
    FTanqueMovimentoSvc: TFakeTanqueMovimentoService;
    FService: TAbastecimentoService;
    procedure SeedDefaultData;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure CalcularResumo_ComDadosValidos_CalculaValores;

    [Test]
    procedure Registrar_ComDadosValidos_SalvaComMovimentoECommit;

    [Test]
    procedure Registrar_QuantidadeMaiorQueEstoque_DisparaErroERollback;

    [Test]
    procedure Registrar_BombaInvalida_DisparaErro;

    [Test]
    procedure Registrar_TanqueInvalido_DisparaErro;

    [Test]
    procedure Registrar_CombustivelNaoConfigurado_DisparaErro;

    [Test]
    procedure Registrar_EntradaInvalida_DisparaErroSemTransacao;

    [Test]
    procedure CalcularResumo_ArredondamentoDuasCasas;
  end;

implementation

{ TFakeDbConnection }

procedure TFakeDbConnection.BeginTransaction;
begin
  Inc(BeginCalled);
  InTransactionFlag := True;
end;

procedure TFakeDbConnection.Commit;
begin
  Inc(CommitCalled);
  InTransactionFlag := False;
end;

procedure TFakeDbConnection.EnsureTransaction;
begin
  if not InTransactionFlag then
    BeginTransaction;
end;

function TFakeDbConnection.GetConn: TFDConnection;
begin
  Result := nil;
end;

function TFakeDbConnection.InTransaction: Boolean;
begin
  Result := InTransactionFlag;
end;

procedure TFakeDbConnection.Rollback;
begin
  Inc(RollbackCalled);
  InTransactionFlag := False;
end;

function TFakeDbConnection.Test: Boolean;
begin
  Result := True;
end;

{ TFakeAbastecimentoRepository }

constructor TFakeAbastecimentoRepository.Create;
begin
  inherited Create;
  FData := TObjectList<TAbastecimento>.Create(True);
  FNextId := 1;
end;

destructor TFakeAbastecimentoRepository.Destroy;
begin
  FData.Free;
  inherited;
end;

function TFakeAbastecimentoRepository.FindAll: TObjectList<TAbastecimento>;
begin
  Result := TObjectList<TAbastecimento>.Create(False);
  Result.AddRange(FData.ToArray);
end;

function TFakeAbastecimentoRepository.FindById(const AId: Int64): TAbastecimento;
var
  LItem: TAbastecimento;
begin
  Result := nil;
  for LItem in FData do
    if LItem.Id = AId then
      Exit(LItem);
end;

function TFakeAbastecimentoRepository.Save(AEntity: TAbastecimento): TAbastecimento;
begin
  if AEntity.Id = 0 then
  begin
    AEntity.Id := FNextId;
    Inc(FNextId);
  end;
  FData.Add(AEntity);
  Result := AEntity;
end;

{ TFakeTanqueRepository }

constructor TFakeTanqueRepository.Create;
begin
  inherited Create;
  FAvailable := TDictionary<Int64, Double>.Create;
end;

destructor TFakeTanqueRepository.Destroy;
begin
  FAvailable.Free;
  inherited;
end;

function TFakeTanqueRepository.Exists(const ATanqueId: Int64): Boolean;
begin
  Result := FAvailable.ContainsKey(ATanqueId);
end;

function TFakeTanqueRepository.FindAllWithCombustivel: TArray<TTanqueCombustivelInfo>;
begin
  Result := [];
end;

function TFakeTanqueRepository.FindById(const ATanqueId: Int64): TTanque;
begin
  Result := nil;
end;

function TFakeTanqueRepository.GetAvailableQuantity(const ATanqueId: Int64): Double;
begin
  if not FAvailable.TryGetValue(ATanqueId, Result) then
    Result := 0;
end;

function TFakeTanqueRepository.HasAvailableQuantity(const ATanqueId: Int64;
  const ARequired: Double): Boolean;
begin
  Result := GetAvailableQuantity(ATanqueId) >= ARequired;
end;

procedure TFakeTanqueRepository.SetAvailableQuantity(const ATanqueId: Int64;
  const AQuantidade: Double);
begin
  FAvailable.AddOrSetValue(ATanqueId, AQuantidade);
end;

{ TFakeBombaRepository }

constructor TFakeBombaRepository.Create;
begin
  inherited Create;
  FBombas := TDictionary<Int64, TBombaCombustivelInfo>.Create;
end;

destructor TFakeBombaRepository.Destroy;
begin
  FBombas.Free;
  inherited;
end;

procedure TFakeBombaRepository.AddBombaInfo(const AInfo: TBombaCombustivelInfo);
begin
  FBombas.AddOrSetValue(AInfo.BombaId, AInfo);
end;

procedure TFakeBombaRepository.Delete(const ABombaId: Int64);
begin
  FBombas.Remove(ABombaId);
end;

function TFakeBombaRepository.Exists(const ABombaId: Int64): Boolean;
begin
  Result := FBombas.ContainsKey(ABombaId);
end;

function TFakeBombaRepository.FindAllWithCombustivel: TArray<TBombaCombustivelInfo>;
begin
  Result := FBombas.Values.ToArray;
end;

function TFakeBombaRepository.FindById(const ABombaId: Int64): TBomba;
begin
  Result := nil;
end;

function TFakeBombaRepository.FindInfoById(const ABombaId: Int64): TBombaCombustivelInfo;
begin
  if not FBombas.TryGetValue(ABombaId, Result) then
    Result := Default(TBombaCombustivelInfo);
end;

function TFakeBombaRepository.HasMovements(const ABombaId: Int64): Boolean;
begin
  Result := False;
end;

function TFakeBombaRepository.Save(const ABomba: TBomba): TBomba;
begin
  Result := ABomba;
end;

{ TFakeTanqueMovimentoService }

procedure TFakeTanqueMovimentoService.RegistrarMovimento(
  const AAbastecimento: TAbastecimento);
begin
  Inc(AbastecimentosRegistrados);
  LastAbastecimento := AAbastecimento;
end;

procedure TFakeTanqueMovimentoService.RegistrarMovimento(
  const AReposicao: TReposicao);
begin
  Inc(ReposicoesRegistradas);
end;

{ TAbastecimentoServiceTests }

procedure TAbastecimentoServiceTests.SeedDefaultData;
var
  LBomba: TBombaCombustivelInfo;
begin
  LBomba.BombaId := 1;
  LBomba.TanqueId := 10;
  LBomba.CombustivelId := 5;
  LBomba.CombustivelValor := 5.00;
  LBomba.CombustivelAliquota := 13;
  LBomba.TanqueEstoqueAtual := 100;
  FBombaRepo.AddBombaInfo(LBomba);
  FTanqueRepo.SetAvailableQuantity(10, 100);
end;

procedure TAbastecimentoServiceTests.Setup;
begin
  FConnection := TFakeDbConnection.Create;
  FAbastecimentoRepo := TFakeAbastecimentoRepository.Create;
  FTanqueRepo := TFakeTanqueRepository.Create;
  FBombaRepo := TFakeBombaRepository.Create;
  FTanqueMovimentoSvc := TFakeTanqueMovimentoService.Create;
  SeedDefaultData;
  FService := TAbastecimentoService.CreateForTests(FAbastecimentoRepo, FTanqueRepo,
    FBombaRepo, FTanqueMovimentoSvc, FConnection);
end;

procedure TAbastecimentoServiceTests.TearDown;
begin
  FService := nil;
  FTanqueMovimentoSvc := nil;
  FBombaRepo := nil;
  FTanqueRepo := nil;
  FAbastecimentoRepo := nil;
  FConnection := nil;
end;

procedure TAbastecimentoServiceTests.CalcularResumo_ComDadosValidos_CalculaValores;
var
  LResumo: TAbastecimentoResumo;
begin
  LResumo := FService.CalcularResumo(1, 10);
  Assert.AreEqual(50.00, Double(LResumo.ValorBruto), 0.001, 'ValorBruto');
  Assert.AreEqual(6.50, Double(LResumo.ValorImposto), 0.001, 'ValorImposto');
  Assert.AreEqual(56.50, Double(LResumo.ValorTotal), 0.001, 'ValorTotal');
  Assert.AreEqual(90.0, LResumo.EstoqueAposSaida, 0.001, 'EstoqueAposSaida');
end;

procedure TAbastecimentoServiceTests.Registrar_ComDadosValidos_SalvaComMovimentoECommit;
var
  LAbastecimento: TAbastecimento;
begin
  LAbastecimento := FService.Registrar(1, 20, 99, EncodeDateTime(2025, 1, 1, 10, 0, 0, 0));

  Assert.IsNotNull(LAbastecimento, 'Abastecimento retornado');
  Assert.AreEqual<Int64>(1, LAbastecimento.Id, 'Id atribuido');
  Assert.AreEqual(20.0, LAbastecimento.Quantidade, 0.001, 'Quantidade');
  Assert.AreEqual<Integer>(99, LAbastecimento.UsuarioId, 'UsuarioId');
  Assert.AreEqual<Integer>(1, FConnection.BeginCalled, 'BeginTransaction chamado');
  Assert.AreEqual<Integer>(1, FConnection.CommitCalled, 'Commit chamado');
  Assert.AreEqual<Integer>(0, FConnection.RollbackCalled, 'Rollback nao deve ser chamado');
  Assert.AreEqual<Integer>(1, FAbastecimentoRepo.Data.Count, 'Repositorio deve salvar entidade');
  Assert.AreEqual<Integer>(1, FTanqueMovimentoSvc.AbastecimentosRegistrados, 'Movimento registrado');
end;

procedure TAbastecimentoServiceTests.Registrar_QuantidadeMaiorQueEstoque_DisparaErroERollback;
begin
  FTanqueRepo.SetAvailableQuantity(10, 5);

  Assert.WillRaise(
    procedure
    begin
      FService.Registrar(1, 10, 1, Now);
    end,
    EAbastecimentoValidation
  );

  Assert.AreEqual<Integer>(0, FConnection.BeginCalled, 'Nao deve abrir transacao em falha de validacao');
  Assert.AreEqual<Integer>(0, FConnection.RollbackCalled, 'Nao deve dar rollback sem transacao');
  Assert.AreEqual<Integer>(0, FConnection.CommitCalled, 'Commit nao deve ocorrer');
end;

procedure TAbastecimentoServiceTests.Registrar_BombaInvalida_DisparaErro;
begin
  FBombaRepo.Delete(1);

  Assert.WillRaise(
    procedure
    begin
      FService.Registrar(1, 10, 1, Now);
    end,
    EAbastecimentoValidation
  );

  Assert.AreEqual<Integer>(0, FConnection.BeginCalled, 'Nao deve abrir transacao');
  Assert.AreEqual<Integer>(0, FConnection.RollbackCalled, 'Nao deve dar rollback');
  Assert.AreEqual<Integer>(0, FConnection.CommitCalled, 'Commit nao deve ocorrer');
end;

procedure TAbastecimentoServiceTests.Registrar_TanqueInvalido_DisparaErro;
var
  LBomba: TBombaCombustivelInfo;
begin
  LBomba := FBombaRepo.FindInfoById(1);
  LBomba.TanqueId := 999;
  FBombaRepo.AddBombaInfo(LBomba);

  Assert.WillRaise(
    procedure
    begin
      FService.Registrar(1, 10, 1, Now);
    end,
    EAbastecimentoValidation
  );

  Assert.AreEqual<Integer>(0, FConnection.BeginCalled, 'Nao deve abrir transacao');
  Assert.AreEqual<Integer>(0, FConnection.RollbackCalled, 'Nao deve dar rollback');
  Assert.AreEqual<Integer>(0, FConnection.CommitCalled, 'Commit nao deve ocorrer');
end;

procedure TAbastecimentoServiceTests.Registrar_CombustivelNaoConfigurado_DisparaErro;
var
  LBomba: TBombaCombustivelInfo;
begin
  LBomba := FBombaRepo.FindInfoById(1);
  LBomba.CombustivelId := 0;
  FBombaRepo.AddBombaInfo(LBomba);

  Assert.WillRaise(
    procedure
    begin
      FService.Registrar(1, 10, 1, Now);
    end,
    EAbastecimentoValidation
  );

  Assert.AreEqual<Integer>(0, FConnection.BeginCalled, 'Nao deve abrir transacao');
  Assert.AreEqual<Integer>(0, FConnection.RollbackCalled, 'Nao deve dar rollback');
  Assert.AreEqual<Integer>(0, FConnection.CommitCalled, 'Commit nao deve ocorrer');
end;

procedure TAbastecimentoServiceTests.Registrar_EntradaInvalida_DisparaErroSemTransacao;
begin
  Assert.WillRaise(
    procedure
    begin
      FService.Registrar(0, 10, 1, Now);
    end,
    EAbastecimentoValidation
  );

  Assert.WillRaise(
    procedure
    begin
      FService.Registrar(1, 0, 1, Now);
    end,
    EAbastecimentoValidation
  );

  Assert.WillRaise(
    procedure
    begin
      FService.Registrar(1, 10, 0, Now);
    end,
    EAbastecimentoValidation
  );

  Assert.WillRaise(
    procedure
    begin
      FService.Registrar(1, 10, 1, 0);
    end,
    EAbastecimentoValidation
  );

  Assert.AreEqual<Integer>(0, FConnection.BeginCalled, 'Nao deve abrir transacao');
  Assert.AreEqual<Integer>(0, FConnection.RollbackCalled, 'Nao deve dar rollback');
  Assert.AreEqual<Integer>(0, FConnection.CommitCalled, 'Commit nao deve ocorrer');
end;

procedure TAbastecimentoServiceTests.CalcularResumo_ArredondamentoDuasCasas;
var
  LResumo: TAbastecimentoResumo;
begin
  LResumo := FService.CalcularResumo(1, 1.999);
  Assert.AreEqual(10.00, Double(LResumo.ValorBruto), 0.001, 'ValorBruto arredondado');
  Assert.AreEqual(1.30, Double(LResumo.ValorImposto), 0.001, 'ValorImposto arredondado');
  Assert.AreEqual(11.30, Double(LResumo.ValorTotal), 0.001, 'ValorTotal arredondado');
  Assert.AreEqual(98.001, LResumo.EstoqueAposSaida, 0.001, 'Estoque apos saida');
end;

initialization
  TDUnitX.RegisterTestFixture(TAbastecimentoServiceTests);

end.
