object sColorDialogForm: TsColorDialogForm
  Left = 286
  Top = 221
  ActiveControl = sAEdit
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 388
  ClientWidth = 584
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = PickFormKeyDown
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sLabel2: TsLabel
    Left = 21
    Top = 156
    Width = 192
    Height = 17
    AutoSize = False
    Caption = 'Additional colors:'
    Layout = tlBottom
  end
  object sLabel4: TsLabel
    Left = 465
    Top = 274
    Width = 6
    Height = 13
    Caption = 'o'
  end
  object sLabel5: TsLabel
    Left = 465
    Top = 306
    Width = 11
    Height = 13
    Caption = '%'
  end
  object sLabel6: TsLabel
    Left = 465
    Top = 333
    Width = 11
    Height = 13
    Caption = '%'
  end
  object sSpeedButton1: TsSpeedButton
    Left = 17
    Top = 319
    Width = 72
    Height = 25
    Flat = True
    OnClick = sSpeedButton1Click
    ImageIndex = 8
  end
  object sBitBtn1: TsBitBtn
    Left = 94
    Top = 350
    Width = 73
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 9
    OnClick = sBitBtn1Click
    ShowFocus = False
    Grayed = True
    ImageIndex = 9
  end
  object sBitBtn2: TsBitBtn
    Left = 172
    Top = 350
    Width = 79
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 10
    OnClick = sBitBtn2Click
    ShowFocus = False
    Grayed = True
    ImageIndex = 10
  end
  object ColorPanel: TsPanel
    Left = 275
    Top = 13
    Width = 255
    Height = 255
    OnPaint = ColorPanelPaint
    BevelOuter = bvNone
    Caption = ' '
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 15
    TabStop = True
    OnMouseDown = ColorPanelMouseDown
    OnMouseMove = ColorPanelMouseMove
    OnMouseUp = ColorPanelMouseUp
  end
  object GradPanel: TsPanel
    Left = 543
    Top = 13
    Width = 20
    Height = 255
    OnPaint = GradPanelPaint
    BevelOuter = bvNone
    Caption = ' '
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 16
    TabStop = True
    OnMouseDown = GradPanelMouseDown
    OnMouseMove = GradPanelMouseMove
    OnMouseUp = GradPanelMouseUp
  end
  object sREdit: TsTrackEdit
    Left = 533
    Top = 276
    Width = 30
    Height = 21
    TabOrder = 5
    Text = '0'
    OnChange = sREditChange
    BoundLabel.Active = True
    BoundLabel.Caption = 'Red:'
    AutoPopup = False
    Increment = 1.000000000000000000
    MaxValue = 255.000000000000000000
    DecimalPlaces = 0
  end
  object sGEdit: TsTrackEdit
    Left = 533
    Top = 303
    Width = 30
    Height = 21
    TabOrder = 6
    Text = '0'
    OnChange = sREditChange
    BoundLabel.Active = True
    BoundLabel.Caption = 'Green:'
    AutoPopup = False
    Increment = 1.000000000000000000
    MaxValue = 255.000000000000000000
    DecimalPlaces = 0
  end
  object sBEdit: TsTrackEdit
    Left = 533
    Top = 330
    Width = 30
    Height = 21
    TabOrder = 7
    Text = '0'
    OnChange = sREditChange
    BoundLabel.Active = True
    BoundLabel.Caption = 'Blue:'
    AutoPopup = False
    Increment = 1.000000000000000000
    MaxValue = 255.000000000000000000
    DecimalPlaces = 0
  end
  object sBitBtn3: TsBitBtn
    Left = 275
    Top = 350
    Width = 126
    Height = 25
    Caption = 'Add color'
    TabOrder = 11
    OnClick = sBitBtn3Click
    ShowFocus = False
    Grayed = True
  end
  object sBitBtn4: TsBitBtn
    Left = 94
    Top = 319
    Width = 157
    Height = 25
    Caption = 'Define custom colors'
    Enabled = False
    TabOrder = 12
    OnClick = sBitBtn4Click
    ShowFocus = False
    Grayed = True
  end
  object sHEdit: TsTrackEdit
    Left = 430
    Top = 276
    Width = 30
    Height = 21
    TabOrder = 2
    Text = '0'
    OnChange = sHEditChange
    BoundLabel.Active = True
    BoundLabel.Caption = 'H:'
    AutoPopup = False
    Increment = 1.000000000000000000
    MaxValue = 359.000000000000000000
    DecimalPlaces = 0
  end
  object sSEdit: TsTrackEdit
    Left = 430
    Top = 303
    Width = 30
    Height = 21
    TabOrder = 3
    Text = '0'
    OnChange = sHEditChange
    BoundLabel.Active = True
    BoundLabel.Caption = 'S:'
    AutoPopup = False
    Increment = 1.000000000000000000
    DecimalPlaces = 0
  end
  object sVEdit: TsTrackEdit
    Left = 430
    Top = 330
    Width = 30
    Height = 21
    TabOrder = 4
    Text = '0'
    OnChange = sHEditChange
    BoundLabel.Active = True
    BoundLabel.Caption = 'B:'
    AutoPopup = False
    Increment = 1.000000000000000000
    DecimalPlaces = 0
  end
  object MainPal: TsColorsPanel
    Left = 10
    Top = 13
    Width = 249
    Height = 142
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 13
    TabStop = True
    OnDblClick = MainPalDblClick
    Colors.Strings = (
      'FF8080FF'
      'FF80FFFF'
      'FF80FF80'
      'FF80FF00'
      'FFFFFF80'
      'FFFF8000'
      'FFC080FF'
      'FFFF80FF'
      'FF0000FF'
      'FF00FFFF'
      'FF00FF80'
      'FF40FF00'
      'FFFFFF00'
      'FFC08000'
      'FFC08080'
      'FFFF00FF'
      'FF404080'
      'FF4080FF'
      'FF00FF00'
      'FF808000'
      'FF804000'
      'FFFF8080'
      'FF400080'
      'FF8000FF'
      'FF000080'
      'FF0080FF'
      'FF008000'
      'FF408000'
      'FFFF0000'
      'FFA00000'
      'FF800080'
      'FFFF0080'
      'FF000040'
      'FF004080'
      'FF004000'
      'FF004040'
      'FF800000'
      'FF400000'
      'FF400040'
      'FF800040'
      'FF000000'
      'FF008080'
      'FF408080'
      'FF808080'
      'FF808040'
      'FFC0C0C0'
      'FF400040'
      'FFFFFFFF')
    ColCount = 8
    ItemHeight = 17
    ItemWidth = 24
    RowCount = 6
    OnChange = MainPalChange
  end
  object AddPal: TsColorsPanel
    Left = 10
    Top = 173
    Width = 249
    Height = 108
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 14
    TabStop = True
    OnDblClick = AddPalDblClick
    Colors.Strings = (
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF')
    ColCount = 6
    ItemHeight = 28
    ItemWidth = 34
    RowCount = 3
    OnChange = MainPalChange
  end
  object sEditDecimal: TsCurrencyEdit
    Left = 73
    Top = 288
    Width = 72
    Height = 21
    Alignment = taLeftJustify
    TabOrder = 1
    OnChange = sEditDecimalChange
    BoundLabel.Active = True
    BoundLabel.Caption = 'Decimal:'
    DecimalPlaces = 0
    DisplayFormat = '0'
  end
  object sEditHex: TsMaskEdit
    Left = 187
    Top = 288
    Width = 64
    Height = 21
    CharCase = ecUpperCase
    EditMask = 'AAAAAA;1; '
    MaxLength = 6
    TabOrder = 0
    Text = '      '
    OnChange = sEditHexChange
    OnKeyPress = sEditHexKeyPress
    CheckOnExit = True
    BoundLabel.Active = True
    BoundLabel.Caption = 'Hex:'
  end
  object sBitBtn5: TsBitBtn
    Left = 17
    Top = 350
    Width = 72
    Height = 25
    Caption = 'Help'
    TabOrder = 8
    OnClick = sBitBtn5Click
    ShowFocus = False
    Grayed = True
  end
  object Panel1: TPanel
    Tag = 256
    Left = 275
    Top = 276
    Width = 126
    Height = 68
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Caption = ' '
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 17
    object SelectedPanel: TPaintBox
      Left = 0
      Top = 0
      Width = 63
      Height = 66
      Align = alLeft
      OnPaint = SelectedPanelPaint
    end
    object OldPanel: TPaintBox
      Left = 63
      Top = 0
      Width = 61
      Height = 66
      Align = alClient
      OnPaint = SelectedPanelPaint
    end
  end
  object sDragBar1: TsDragBar
    Left = 0
    Top = 0
    Width = 584
    Height = 6
    Cursor = crHandPoint
    SkinData.SkinSection = 'DRAGBAR'
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 18
    DraggedControl = Owner
  end
  object sAEdit: TsTrackEdit
    Left = 533
    Top = 356
    Width = 30
    Height = 21
    TabOrder = 19
    Text = '0'
    OnChange = sREditChange
    BoundLabel.Active = True
    BoundLabel.Caption = 'Alpha value:'
    AutoPopup = False
    Increment = 1.000000000000000000
    MaxValue = 255.000000000000000000
    DecimalPlaces = 0
  end
  object sSkinProvider1: TsSkinProvider
    ScreenSnap = True
    ShowAppIcon = False
    CaptionAlignment = taCenter
    SkinData.SkinSection = 'DIALOG'
    TitleButtons = <>
    Left = 361
    Top = 33
  end
end
