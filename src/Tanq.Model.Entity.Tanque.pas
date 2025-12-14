unit Tanq.Model.Entity.Tanque;

interface

uses
  System.SysUtils;

type
  TTanque = class
  private
    FId: Int64;
    FDescricao: string;
    FCapacidade: Double;
    FCombustivelId: Int64;
  public
    property Id: Int64 read FId write FId;
    property Descricao: string read FDescricao write FDescricao;
    property Capacidade: Double read FCapacidade write FCapacidade;
    property CombustivelId: Int64 read FCombustivelId write FCombustivelId;
  end;

implementation

end.
