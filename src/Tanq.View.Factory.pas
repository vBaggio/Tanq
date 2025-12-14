unit Tanq.View.Factory;

interface

uses
  System.Classes,
  Tanq.View.Interfaces;

type
  TViewFactory = class
  public
    class function CreateView(AOwner: TComponent; const AKind: TViewKind): IFrameView; static;
  end;

implementation

uses
  Tanq.View.Welcome,
  Tanq.View.Abastecimento,
  Tanq.View.Reposicao,
  Tanq.View.Relatorio,
  Tanq.View.Bombas;

{ TViewFactory }

class function TViewFactory.CreateView(AOwner: TComponent; const AKind: TViewKind): IFrameView;
begin
  case AKind of
    vkWelcome:
      Result := TfrmWelcome.Create(AOwner);
    vkAbastecimento:
      Result := TfrmAbastecimento.Create(AOwner);
    vkBombas:
      Result := TfrmBombas.Create(AOwner);
    vkReposicao:
      Result := TfrmReposicao.Create(AOwner);
    vkRelatorio:
      Result := TfrmRelatorio.Create(AOwner);
  else
    Result := nil;
  end;
end;

end.
