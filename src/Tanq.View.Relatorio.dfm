object frmRelatorio: TfrmRelatorio
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmRelatorio'
  ClientHeight = 480
  ClientWidth = 732
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
    Width = 732
    Height = 480
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Align = alClient
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    ExplicitWidth = 640
    object pnlTop: TPanel
      Left = 0
      Top = 0
      Width = 732
      Height = 56
      Align = alTop
      BevelOuter = bvNone
      Padding.Left = 15
      Padding.Top = 5
      Padding.Right = 15
      Padding.Bottom = 5
      TabOrder = 0
      ExplicitWidth = 640
      object lblTitle: TLabel
        AlignWithMargins = True
        Left = 15
        Top = 5
        Width = 662
        Height = 46
        Margins.Left = 0
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        Caption = 'Relatorio de Abastecimentos'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12615680
        Font.Height = -24
        Font.Name = 'Roboto'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
        ExplicitWidth = 570
      end
      object btnClose: TSpeedButton
        Left = 677
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
        ExplicitLeft = 585
      end
    end
    object pnlContent: TPanel
      Left = 0
      Top = 56
      Width = 732
      Height = 424
      Align = alClient
      BevelOuter = bvNone
      Padding.Left = 15
      Padding.Right = 15
      Padding.Bottom = 5
      TabOrder = 1
      ExplicitTop = 54
      object pnlButtons: TPanel
        Left = 15
        Top = 359
        Width = 702
        Height = 60
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitWidth = 610
      end
      object GroupBox1: TGroupBox
        Left = 32
        Top = 0
        Width = 473
        Height = 89
        Caption = 'Per'#237'odo'
        TabOrder = 1
        object pnlFilters: TPanel
          Left = 2
          Top = 17
          Width = 469
          Height = 70
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          ExplicitLeft = 32
          ExplicitWidth = 439
          ExplicitHeight = 64
          object lblDataInicial: TLabel
            Left = 15
            Top = 2
            Width = 58
            Height = 15
            Caption = 'Data inicial'
          end
          object lblDataFinal: TLabel
            Left = 239
            Top = 2
            Width = 50
            Height = 15
            Caption = 'Data final'
          end
          object dtpInicio: TDateTimePicker
            Left = 15
            Top = 25
            Width = 200
            Height = 25
            Date = 45569.000000000000000000
            Format = 'dd/MM/yyyy'
            Time = 45569.000000000000000000
            TabOrder = 0
          end
          object dtpFim: TDateTimePicker
            Left = 239
            Top = 25
            Width = 200
            Height = 25
            Date = 45569.000000000000000000
            Format = 'dd/MM/yyyy'
            Time = 45569.000000000000000000
            TabOrder = 1
          end
        end
      end
      object btnGerar: TButton
        AlignWithMargins = True
        Left = 540
        Top = 26
        Width = 155
        Height = 54
        Caption = 'Gerar relatorio'
        TabOrder = 2
        OnClick = btnGerarClick
      end
    end
  end
end
