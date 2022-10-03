object HttpActionInfo: THttpActionInfo
  Left = 218
  Top = 111
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Http form Action Url'
  ClientHeight = 87
  ClientWidth = 492
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  DesignSize = (
    492
    87)
  PixelsPerInch = 96
  TextHeight = 13
  object lblCaption: TLabel
    Left = 6
    Top = 12
    Width = 205
    Height = 13
    Caption = 'Your form tag has the following action URl.'
  end
  object btnOK: TButton
    Left = 209
    Top = 59
    Width = 75
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object edtAction: TEdit
    Left = 5
    Top = 30
    Width = 481
    Height = 21
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 0
  end
end
