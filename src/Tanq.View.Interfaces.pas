unit Tanq.View.Interfaces;

interface

uses
  System.Classes,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.Buttons;

type
  TViewKind = (
    vkWelcome,
    vkBombas,
    vkAbastecimento,
    vkReposicao,
    vkRelatorio
  );

  IFrameView = interface
    ['{5B5D3E8A-3F4B-4C87-A687-A7E8D2BF71F7}']
    function CanClose: Boolean;
    function CloseButton: TSpeedButton;
    function AsForm: TForm;
  end;

implementation

end.
