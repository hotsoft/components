object osFilterInspector: TosFilterInspector
  Left = 345
  Top = 197
  BorderIcons = []
  BorderStyle = bsSizeToolWin
  BorderWidth = 4
  Caption = 'Dados para pesquisa'
  ClientHeight = 383
  ClientWidth = 412
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCloseQuery = FormCloseQuery
  DesignSize = (
    412
    383)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = -6
    Top = 345
    Width = 102
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = '* Campos obrigat'#243'rios'
    ExplicitTop = 304
  end
  object DataInspector: TwwDataInspector
    Left = 0
    Top = 4
    Width = 411
    Height = 339
    DisableThemes = False
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    Items = <>
    DefaultRowHeight = 18
    CaptionWidth = 187
    Options = [ovColumnResize, ovRowResize, ovHighlightActiveRow, ovCenterCaptionVert]
    CaptionFont.Charset = DEFAULT_CHARSET
    CaptionFont.Color = clWindowText
    CaptionFont.Height = -11
    CaptionFont.Name = 'MS Sans Serif'
    CaptionFont.Style = []
    LineStyleCaption = ovLight3DLine
    LineStyleData = ovLight3DLine
    OnKeyPress = DataInspectorKeyPress
  end
  object btnOK: TButton
    Left = 254
    Top = 352
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancela: TButton
    Left = 336
    Top = 352
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancela'
    ModalResult = 2
    TabOrder = 2
  end
end
