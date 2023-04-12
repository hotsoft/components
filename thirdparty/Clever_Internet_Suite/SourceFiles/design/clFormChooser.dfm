object HttpFormChooser: THttpFormChooser
  Left = 218
  Top = 111
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Http Form Chooser'
  ClientHeight = 221
  ClientWidth = 263
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  DesignSize = (
    263
    221)
  PixelsPerInch = 96
  TextHeight = 13
  object lblCaption: TLabel
    Left = 6
    Top = 12
    Width = 192
    Height = 13
    Caption = 'Your Html has more than one form tags.'
  end
  object Label1: TLabel
    Left = 6
    Top = 28
    Width = 251
    Height = 13
    Caption = 'Please specify which form you are about to process.'
  end
  object btnOK: TButton
    Left = 94
    Top = 193
    Width = 75
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object ListBox: TListBox
    Left = 6
    Top = 48
    Width = 249
    Height = 139
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
    OnDblClick = ListBoxDblClick
  end
end
