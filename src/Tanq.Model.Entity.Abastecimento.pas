unit Tanq.Model.Entity.Abastecimento;

interface

uses
  System.SysUtils;

type
  TAbastecimento = class
  private
    FId: Int64;
    FDataHora: TDateTime;
    FQuantidade: Double;
    FValorUnitario: Currency;
    FAliquota: Double;
    FValorTotal: Currency;
    FCombustivelId: Int64;
    FUsuarioId: Int64;
    FBombaId: Int64;
    FTanqueId: Int64;
  public
    property Id: Int64 read FId write FId;
    property DataHora: TDateTime read FDataHora write FDataHora;
    property Quantidade: Double read FQuantidade write FQuantidade;
    property ValorUnitario: Currency read FValorUnitario write FValorUnitario;
    property Aliquota: Double read FAliquota write FAliquota;
    property ValorTotal: Currency read FValorTotal write FValorTotal;
    property CombustivelId: Int64 read FCombustivelId write FCombustivelId;
    property UsuarioId: Int64 read FUsuarioId write FUsuarioId;
    property BombaId: Int64 read FBombaId write FBombaId;
    property TanqueId: Int64 read FTanqueId write FTanqueId;
  end;

implementation

end.
