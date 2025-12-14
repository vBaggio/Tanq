object frmBombas: TfrmBombas
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmBombas'
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
        Caption = 'Bombas'
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
      object lvBombas: TListView
        Left = 15
        Top = 0
        Width = 610
        Height = 359
        Align = alClient
        Columns = <
          item
            Caption = 'Descri'#231#227'o'
            Width = 240
          end
          item
            Caption = 'Tanque'
            Width = 180
          end
          item
            Caption = 'Combust'#237'vel'
            Width = 160
          end>
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        OnDblClick = lvBombasDblClick
      end
      object pnlButtons: TPanel
        Left = 15
        Top = 359
        Width = 610
        Height = 60
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          610
          60)
        object btnNovo: TBitBtn
          Left = 0
          Top = 12
          Width = 90
          Height = 36
          Caption = 'Novo'
          TabOrder = 0
          OnClick = btnNovoClick
        end
        object btnEditar: TBitBtn
          Left = 98
          Top = 12
          Width = 90
          Height = 36
          Caption = 'Editar'
          TabOrder = 1
          OnClick = btnEditarClick
        end
        object btnExcluir: TBitBtn
          Left = 196
          Top = 12
          Width = 90
          Height = 36
          Caption = 'Excluir'
          TabOrder = 2
          OnClick = btnExcluirClick
        end
        object btnAtualizar: TBitBtn
          Left = 482
          Top = 12
          Width = 120
          Height = 36
          Anchors = [akLeft, akTop, akRight]
          Caption = 'Atualizar'
          TabOrder = 3
          OnClick = btnAtualizarClick
        end
      end
    end
  end
end
