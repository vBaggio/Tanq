unit Tanq.Model.Entity.Combustivel;

interface

uses
  System.SysUtils;

type
  TCombustivel = class
  private
    FId: Int64;
    FDescricao: string;
    FUnidade: string;
    FValor: Currency;
    FAliquota: Double;
  public
    property Id: Int64 read FId write FId;
    property Descricao: string read FDescricao write FDescricao;
    property Unidade: string read FUnidade write FUnidade;
    property Valor: Currency read FValor write FValor;
    property Aliquota: Double read FAliquota write FAliquota;
  end;

implementation

end.
