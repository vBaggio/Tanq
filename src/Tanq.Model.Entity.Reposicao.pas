unit Tanq.Model.Entity.Reposicao;

interface

uses
  System.SysUtils;

type
  TReposicao = class
  private
    FId: Int64;
    FDataHora: TDateTime;
    FCombustivelId: Int64;
    FTanqueId: Int64;
    FQuantidade: Double;
    FUsuarioId: Int64;
    FObservacao: string;
  public
    property Id: Int64 read FId write FId;
    property DataHora: TDateTime read FDataHora write FDataHora;
    property CombustivelId: Int64 read FCombustivelId write FCombustivelId;
    property TanqueId: Int64 read FTanqueId write FTanqueId;
    property Quantidade: Double read FQuantidade write FQuantidade;
    property UsuarioId: Int64 read FUsuarioId write FUsuarioId;
    property Observacao: string read FObservacao write FObservacao;
  end;

implementation

end.
