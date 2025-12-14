unit Tanq.Model.Entity.Usuario;

interface

uses
  System.SysUtils;

type
  TUsuario = class
  private
    FId: Int64;
    FNome: string;
  public
    property Id: Int64 read FId write FId;
    property Nome: string read FNome write FNome;
  end;

implementation

end.
