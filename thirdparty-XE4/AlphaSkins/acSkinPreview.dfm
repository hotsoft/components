object FormSkinPreview: TFormSkinPreview
  Left = 507
  Top = 411
  Caption = 'Skin preview'
  ClientHeight = 196
  ClientWidth = 308
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  TextHeight = 13
  object sEdit1: TsEdit
    Left = 16
    Top = 16
    Width = 273
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = 'Text'
    SkinData.SkinManager = PreviewManager
    BoundLabel.Caption = 'Label'
  end
  object sStatusBar1: TsStatusBar
    Left = 0
    Top = 177
    Width = 308
    Height = 19
    Panels = <>
    SkinData.SkinManager = PreviewManager
  end
  object sPanel1: TsPanel
    Left = 8
    Top = 48
    Width = 289
    Height = 70
    SkinData.SkinManager = PreviewManager
    SkinData.SkinSection = 'PANEL_LOW'
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvLowered
    TabOrder = 2
    object sGroupBox1: TsGroupBox
      Left = 16
      Top = 8
      Width = 257
      Height = 49
      Caption = 'GroupBox'
      TabOrder = 0
      SkinData.SkinManager = PreviewManager
      object sCheckBox1: TsCheckBox
        Left = 24
        Top = 20
        Width = 82
        Height = 17
        Caption = 'CheckBox 1'
        TabOrder = 0
        SkinData.SkinManager = PreviewManager
      end
      object sCheckBox2: TsCheckBox
        Left = 128
        Top = 20
        Width = 82
        Height = 17
        Caption = 'CheckBox 2'
        TabOrder = 1
        SkinData.SkinManager = PreviewManager
      end
    end
  end
  object sPanel2: TsPanel
    Left = 8
    Top = 128
    Width = 289
    Height = 41
    SkinData.SkinManager = PreviewManager
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 3
    object sBitBtn1: TsBitBtn
      Left = 130
      Top = 6
      Width = 75
      Height = 29
      Anchors = [akRight, akBottom]
      Caption = 'Button 1'
      TabOrder = 0
      AnimatEvents = []
      SkinData.SkinManager = PreviewManager
    end
    object sBitBtn2: TsBitBtn
      Left = 208
      Top = 6
      Width = 75
      Height = 29
      Anchors = [akRight, akBottom]
      Caption = 'Button 2'
      TabOrder = 1
      AnimatEvents = []
      SkinData.SkinManager = PreviewManager
    end
  end
  object sSkinProvider1: TsSkinProvider
    SkinData.SkinManager = PreviewManager
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 272
    Top = 40
  end
  object PreviewManager: TsSkinManager
    AnimEffects.DialogShow.Active = False
    AnimEffects.FormShow.Time = 100
    AnimEffects.FormHide.Time = 100
    AnimEffects.PageChange.Active = False
    AnimEffects.SkinChanging.Active = False
    AnimEffects.SkinChanging.Time = 200
    ButtonsOptions.OldGlyphsMode = False
    Active = False
    ExtendedBorders = True
    IsDefault = False
    InternalSkins = <>
    SkinDirectory = 'c:\Skins'
    SkinInfo = 'N/A'
    ThirdParty.ThirdEdits = 
      'TEdit'#13#10'TMemo'#13#10'TMaskEdit'#13#10'TLabeledEdit'#13#10'THotKey'#13#10'TListBox'#13#10'TCheck' +
      'ListBox'#13#10'TDBListBox'#13#10'TRichEdit'#13#10'TDBMemo'#13#10'TSynEdit'#13#10'TSynMemo'#13#10'TDB' +
      'SynEdit'#13#10'TDBLookupListBox'#13#10'TDBRichEdit'#13#10'TDBCtrlGrid'#13#10'TDateTimePi' +
      'cker'#13#10'TDBEdit'
    ThirdParty.ThirdButtons = 'TButton'
    ThirdParty.ThirdBitBtns = 'TBitBtn'
    ThirdParty.ThirdCheckBoxes = 'TCheckBox'#13#10'TRadioButton'#13#10'TDBCheckBox'#13#10'TGroupButton'
    ThirdParty.ThirdGroupBoxes = 'TGroupBox'#13#10'TDBRadioGroup'#13#10'TRadioGroup'
    ThirdParty.ThirdListViews = 'TListView'
    ThirdParty.ThirdPanels = 'TPanel'#13#10'TDBCtrlPanel'
    ThirdParty.ThirdGrids = 
      'TStringGrid'#13#10'TDrawGrid'#13#10'TRichView'#13#10'TDBRichViewEdit'#13#10'TRichViewEdi' +
      't'#13#10'TDBRichView'#13#10'TValueListEditor'#13#10'TDBGrid'
    ThirdParty.ThirdTreeViews = 'TTreeView'#13#10'TRzTreeView'#13#10'TDBTreeView'
    ThirdParty.ThirdComboBoxes = 'TComboBox'#13#10'TColorBox'#13#10'TDBComboBox'
    ThirdParty.ThirdWWEdits = 
      'TDBLookupComboBox'#13#10'TwwDBComboBox'#13#10'TwwDBCustomCombo'#13#10'TwwDBCustomL' +
      'ookupCombo'
    ThirdParty.ThirdVirtualTrees = 
      'TVirtualStringTree'#13#10'TVirtualStringTreeDB'#13#10'TEasyListview'#13#10'TVirtua' +
      'lExplorerListView'#13#10'TVirtualExplorerTreeView'#13#10'TVirtualDrawTree'
    ThirdParty.ThirdGridEh = 'TDBGridEh'
    ThirdParty.ThirdPageControl = ' '
    ThirdParty.ThirdTabControl = ' '
    ThirdParty.ThirdToolBar = ' '
    ThirdParty.ThirdStatusBar = ' '
    ThirdParty.ThirdSpeedButton = ' '
    ThirdParty.ThirdScrollControl = ' '
    ThirdParty.ThirdUpDown = ' '
    ThirdParty.ThirdScrollBar = ' '
    ThirdParty.ThirdStaticText = ' '
    ThirdParty.ThirdNativePaint = ' '
    Left = 272
    Top = 8
  end
end
