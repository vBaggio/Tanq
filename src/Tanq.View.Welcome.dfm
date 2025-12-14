object frmWelcome: TfrmWelcome
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmWelcome'
  ClientHeight = 480
  ClientWidth = 640
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object pnlContainer: TPanel
    AlignWithMargins = True
    Left = 0
    Top = 0
    Width = 640
    Height = 480
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    object lblTitle: TLabel
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 640
      Height = 49
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = 'Bem-vindo ao Tanq'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 12615680
      Font.Height = -24
      Font.Name = 'Roboto'
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
    end
    object lblDescription: TLabel
      AlignWithMargins = True
      Left = 3
      Top = 52
      Width = 634
      Height = 425
      Align = alClient
      Alignment = taCenter
      Caption = 
        'Realize opera'#231#245'es ou visualize relat'#243'rios selecionando uma das o' +
        'p'#231#245'es acima.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Roboto'
      Font.Style = []
      ParentFont = False
      WordWrap = True
      ExplicitWidth = 560
      ExplicitHeight = 19
    end
  end
end
