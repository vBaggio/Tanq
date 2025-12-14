unit Tanq.Model.Entity.TanqueMovimento;

interface

uses
  System.SysUtils;

type
  TTanqueMovimento = class
  private
    FId: Int64;
    FDataHora: TDateTime;
    FTanqueId: Int64;
    FCombustivelId: Int64;
    FUsuarioId: Int64;
    FTipoMovimento: Smallint;
    FQuantidade: Double;
    FOrigemTipo: string;
    FOrigemId: Int64;
    FObservacao: string;
  public
    property Id: Int64 read FId write FId;
    property DataHora: TDateTime read FDataHora write FDataHora;
    property TanqueId: Int64 read FTanqueId write FTanqueId;
    property CombustivelId: Int64 read FCombustivelId write FCombustivelId;
    property UsuarioId: Int64 read FUsuarioId write FUsuarioId;
    property TipoMovimento: Smallint read FTipoMovimento write FTipoMovimento;
    property Quantidade: Double read FQuantidade write FQuantidade;
    property OrigemTipo: string read FOrigemTipo write FOrigemTipo;
    property OrigemId: Int64 read FOrigemId write FOrigemId;
    property Observacao: string read FObservacao write FObservacao;
  end;

implementation

end.
