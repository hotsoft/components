object HttpRequestChooser: THttpRequestChooser
  Left = 218
  Top = 111
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Http Request Chooser'
  ClientHeight = 64
  ClientWidth = 256
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  DesignSize = (
    256
    64)
  PixelsPerInch = 96
  TextHeight = 13
  object lblCaption: TLabel
    Left = 5
    Top = 12
    Width = 37
    Height = 13
    Caption = 'Caption'
  end
  object btnOK: TButton
    Left = 91
    Top = 40
    Width = 75
    Height = 22
    Anchors = [akRight, akBottom]
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
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
end
