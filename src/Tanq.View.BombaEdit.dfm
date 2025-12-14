object frmBombaEdit: TfrmBombaEdit
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Bomba'
  ClientHeight = 220
  ClientWidth = 420
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 13
  object lblDescricao: TLabel
    Left = 16
    Top = 16
    Width = 49
    Height = 13
    Caption = 'Descri'#231#227'o'
  end
  object lblTanque: TLabel
    Left = 16
    Top = 72
    Width = 38
    Height = 13
    Caption = 'Tanque'
  end
  object lblCombustivel: TLabel
    Left = 16
    Top = 128
    Width = 66
    Height = 13
    Caption = 'Combust'#237'vel:'
  end
  object lblCombustivelValor: TLabel
    Left = 96
    Top = 128
    Width = 8
    Height = 13
    Caption = '--'
  end
  object lblEstoque: TLabel
    Left = 16
    Top = 152
    Width = 45
    Height = 13
    Caption = 'Estoque:'
  end
  object lblEstoqueValor: TLabel
    Left = 96
    Top = 152
    Width = 8
    Height = 13
    Caption = '--'
  end
  object edtDescricao: TEdit
    Left = 16
    Top = 32
    Width = 385
    Height = 21
    TabOrder = 0
  end
  object cbTanques: TComboBox
    Left = 16
    Top = 88
    Width = 385
    Height = 21
    Style = csDropDownList
    TabOrder = 1
    OnChange = cbTanquesChange
  end
  object btnSalvar: TBitBtn
    Left = 224
    Top = 176
    Width = 85
    Height = 30
    Caption = 'Salvar'
    Kind = bkOK
    NumGlyphs = 2
    TabOrder = 2
    OnClick = btnSalvarClick
  end
  object btnCancelar: TBitBtn
    Left = 316
    Top = 176
    Width = 85
    Height = 30
    Caption = 'Cancelar'
    Kind = bkCancel
    NumGlyphs = 2
    TabOrder = 3
  end
end
