object frmReposicao: TfrmReposicao
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmReposicao'
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
    object pnlTop: TPanel
      Left = 0
      Top = 0
      Width = 640
      Height = 56
      Align = alTop
      BevelOuter = bvNone
      Padding.Left = 15
      Padding.Top = 5
      Padding.Right = 15
      Padding.Bottom = 5
      TabOrder = 0
      object lblTitle: TLabel
        AlignWithMargins = True
        Left = 15
        Top = 5
        Width = 570
        Height = 46
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        Caption = 'Reposi'#231#227'o'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12615680
        Font.Height = -24
        Font.Name = 'Roboto'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
      end
      object btnClose: TSpeedButton
        Left = 585
        Top = 5
        Width = 40
        Height = 46
        Align = alRight
        Caption = #10005
        Flat = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
    object pnlContent: TPanel
      Left = 0
      Top = 56
      Width = 640
      Height = 424
      Align = alClient
      BevelOuter = bvNone
      Padding.Left = 15
      Padding.Right = 15
      Padding.Bottom = 5
      TabOrder = 1
      object pnlButtons: TPanel
        Left = 15
        Top = 364
        Width = 610
        Height = 55
        Align = alBottom
        BevelOuter = bvNone
        Padding.Right = 5
        TabOrder = 1
        object btnConfirmar: TBitBtn
          AlignWithMargins = True
          Left = 365
          Top = 10
          Width = 115
          Height = 35
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 10
          Align = alRight
          Caption = 'Confirmar'
          Kind = bkOK
          NumGlyphs = 2
          TabOrder = 0
          OnClick = btnConfirmarClick
        end
        object btnCancelar: TBitBtn
          AlignWithMargins = True
          Left = 490
          Top = 10
          Width = 115
          Height = 35
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 0
          Margins.Bottom = 10
          Align = alRight
          Caption = 'Cancelar'
          Kind = bkCancel
          NumGlyphs = 2
          TabOrder = 1
          OnClick = btnCancelarClick
        end
      end
      object pnlMain: TPanel
        Left = 15
        Top = 0
        Width = 610
        Height = 364
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object grpSelecao: TGroupBox
          Left = 0
          Top = 0
          Width = 610
          Height = 170
          Align = alTop
          Caption = 'Selecionar Tanque'
          Padding.Left = 12
          Padding.Top = 12
          Padding.Right = 12
          Padding.Bottom = 12
          TabOrder = 0
          object lblTanque: TLabel
            Left = 12
            Top = 28
            Width = 41
            Height = 15
            Caption = 'Tanque:'
          end
          object lblCombustivel: TLabel
            Left = 12
            Top = 84
            Width = 70
            Height = 15
            Caption = 'Combust'#237'vel:'
          end
          object lblCapacidade: TLabel
            Left = 12
            Top = 110
            Width = 62
            Height = 15
            Caption = 'Capacidade'
          end
          object lblEstoque: TLabel
            Left = 12
            Top = 136
            Width = 74
            Height = 15
            Caption = 'Estoque atual:'
          end
          object lblDetalhesTanque: TLabel
            Left = 360
            Top = 50
            Width = 153
            Height = 15
            Caption = 'Nenhum tanque selecionado'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGray
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
          object lblDetalhesCombustivel: TLabel
            Left = 120
            Top = 84
            Width = 10
            Height = 15
            Caption = '--'
          end
          object lblDetalhesCapacidade: TLabel
            Left = 120
            Top = 110
            Width = 10
            Height = 15
            Caption = '--'
          end
          object lblDetalhesEstoque: TLabel
            Left = 120
            Top = 136
            Width = 10
            Height = 15
            Caption = '--'
          end
          object cbTanques: TComboBox
            Left = 12
            Top = 46
            Width = 334
            Height = 23
            TabOrder = 0
            TextHint = 'Selecione o tanque'
            OnChange = cbTanquesChange
          end
        end
        object grpOperacao: TGroupBox
          Left = 0
          Top = 170
          Width = 610
          Height = 194
          Align = alClient
          Caption = 'Detalhes da Reposi'#231#227'o'
          Padding.Left = 12
          Padding.Top = 12
          Padding.Right = 12
          Padding.Bottom = 12
          TabOrder = 1
          object lblQuantidade: TLabel
            Left = 12
            Top = 32
            Width = 99
            Height = 15
            Caption = 'Quantidade (litros)'
          end
          object lblObservacao: TLabel
            Left = 220
            Top = 32
            Width = 62
            Height = 15
            Caption = 'Observa'#231#227'o'
          end
          object lblEstoqueAtual: TLabel
            Left = 12
            Top = 92
            Width = 71
            Height = 15
            Caption = 'Estoque atual'
          end
          object lblEstoqueApos: TLabel
            Left = 12
            Top = 120
            Width = 124
            Height = 15
            Caption = 'Estoque ap'#243's reposi'#231#227'o'
          end
          object lblCapacidadeDisponivel: TLabel
            Left = 12
            Top = 148
            Width = 164
            Height = 15
            Caption = 'Capacidade dispon'#237'vel restante'
          end
          object lblEstoqueAtualValor: TLabel
            Left = 220
            Top = 92
            Width = 36
            Height = 17
            Caption = '0,00 L'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -13
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblEstoqueAposValor: TLabel
            Left = 220
            Top = 120
            Width = 36
            Height = 17
            Caption = '0,00 L'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -13
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblCapacidadeDisponivelValor: TLabel
            Left = 220
            Top = 148
            Width = 36
            Height = 17
            Caption = '0,00 L'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGreen
            Font.Height = -13
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object edtQuantidade: TEdit
            Left = 12
            Top = 50
            Width = 180
            Height = 23
            TabOrder = 0
            TextHint = 'Ex: 500,00'
            OnChange = edtQuantidadeChange
          end
          object memObservacao: TMemo
            Left = 220
            Top = 50
            Width = 370
            Height = 30
            ScrollBars = ssVertical
            TabOrder = 1
          end
        end
      end
    end
  end
end
