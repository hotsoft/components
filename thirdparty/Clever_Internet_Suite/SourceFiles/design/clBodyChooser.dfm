object clMessageBodyChooser: TclMessageBodyChooser
  Left = 218
  Top = 111
  ActiveControl = ComboBox
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Item Chooser'
  ClientHeight = 64
  ClientWidth = 252
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lkpType: TLabel
    Left = 5
    Top = 12
    Width = 24
    Height = 13
    Caption = 'Type'
  end
  object btnOK: TButton
    Left = 91
    Top = 40
    Width = 75
    Height = 22
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object btnCancel: TButton
    Left = 175
    Top = 40
    Width = 75
    Height = 22
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object ComboBox: TComboBox
    Left = 46
    Top = 8
    Width = 204
    Height = 21
    Style = csDropDownList
    DropDownCount = 20
    ItemHeight = 13
    TabOrder = 2
  end
end
