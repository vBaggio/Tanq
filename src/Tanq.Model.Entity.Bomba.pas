unit Tanq.Model.Entity.Bomba;

interface

uses
  System.SysUtils;

type
  TBomba = class
  private
    FId: Int64;
    FDescricao: string;
    FTanqueId: Int64;
  public
    property Id: Int64 read FId write FId;
    property Descricao: string read FDescricao write FDescricao;
    property TanqueId: Int64 read FTanqueId write FTanqueId;
  end;

implementation

end.
