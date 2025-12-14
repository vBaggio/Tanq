object frmAbastecimento: TfrmAbastecimento
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmAbastecimento'
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
        Caption = 'Abastecimento'
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
          Height = 158
          Align = alTop
          Caption = 'Selecionar Bomba'
          Padding.Left = 12
          Padding.Top = 12
          Padding.Right = 12
          Padding.Bottom = 12
          TabOrder = 0
          object lblBomba: TLabel
            Left = 12
            Top = 28
            Width = 41
            Height = 15
            Caption = 'Bomba:'
          end
          object lblCombustivel: TLabel
            Left = 12
            Top = 80
            Width = 70
            Height = 15
            Caption = 'Combust'#237'vel:'
          end
          object lblTanque: TLabel
            Left = 12
            Top = 104
            Width = 41
            Height = 15
            Caption = 'Tanque:'
          end
          object lblValorUnitarioTitle: TLabel
            Left = 360
            Top = 80
            Width = 95
            Height = 15
            Caption = 'Valor por litro (R$)'
          end
          object lblEstoque: TLabel
            Left = 12
            Top = 128
            Width = 82
            Height = 15
            Caption = 'Estoque (litros):'
          end
          object lblDetalhesBomba: TLabel
            Left = 360
            Top = 50
            Width = 159
            Height = 15
            Caption = 'Nenhuma bomba selecionada'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGray
            Font.Height = -12
            Font.Name = 'Segoe UI'
            Font.Style = []
            ParentFont = False
          end
          object lblDetalhesCombustivel: TLabel
            Left = 120
            Top = 80
            Width = 10
            Height = 15
            Caption = '--'
          end
          object lblDetalhesTanque: TLabel
            Left = 120
            Top = 104
            Width = 10
            Height = 15
            Caption = '--'
          end
          object lblDetalhesValorUnitario: TLabel
            Left = 480
            Top = 80
            Width = 49
            Height = 19
            Caption = 'R$ 0,00'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -14
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblDetalhesEstoque: TLabel
            Left = 120
            Top = 128
            Width = 10
            Height = 15
            Caption = '--'
          end
          object cbBombas: TComboBox
            Left = 12
            Top = 46
            Width = 334
            Height = 23
            TabOrder = 0
            TextHint = 'Selecione a bomba'
            OnChange = cbBombasChange
          end
        end
        object grpOperacao: TGroupBox
          Left = 0
          Top = 158
          Width = 610
          Height = 206
          Align = alClient
          Caption = 'Detalhes do Abastecimento'
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
          object lblValorUnitario: TLabel
            Left = 12
            Top = 88
            Width = 44
            Height = 15
            Caption = 'Subtotal'
          end
          object lblImposto: TLabel
            Left = 12
            Top = 120
            Width = 96
            Height = 15
            Caption = 'Imposto estimado'
          end
          object lblTotal: TLabel
            Left = 12
            Top = 152
            Width = 99
            Height = 15
            Caption = 'Total com imposto'
          end
          object lblValorUnitarioValor: TLabel
            Left = 150
            Top = 88
            Width = 44
            Height = 17
            Caption = 'R$ 0,00'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -13
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblImpostoValor: TLabel
            Left = 150
            Top = 120
            Width = 44
            Height = 17
            Caption = 'R$ 0,00'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clNavy
            Font.Height = -13
            Font.Name = 'Segoe UI'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object lblTotalValor: TLabel
            Left = 150
            Top = 152
            Width = 54
            Height = 20
            Caption = 'R$ 0,00'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGreen
            Font.Height = -15
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
            TextHint = 'Ex: 40,00'
            OnChange = edtQuantidadeChange
          end
        end
      end
    end
  end
end
