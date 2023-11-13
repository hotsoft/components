object FormCharListEditor: TFormCharListEditor
  Left = 393
  Top = 304
  Caption = 'FormCharListEditor'
  ClientHeight = 602
  ClientWidth = 761
  Color = clBtnFace
  Constraints.MinHeight = 640
  Constraints.MinWidth = 777
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnMouseWheel = FormMouseWheel
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sPanel10: TsPanel
    Left = 0
    Top = 0
    Width = 761
    Height = 602
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 12
    TabOrder = 0
    object sPanel2: TsPanel
      Tag = 2
      Left = 461
      Top = 12
      Width = 288
      Height = 578
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object sPageControl1: TsPageControl
        Left = 0
        Top = 0
        Width = 288
        Height = 249
        ActivePage = sTabSheet1
        Align = alClient
        Images = acDM.sCharImageList1
        TabHeight = 26
        TabOrder = 0
        OnChange = sPageControl1Change
        AccessibleDisabledPages = False
        TabPadding = 12
        object sTabSheet1: TsTabSheet
          BorderWidth = 4
          Caption = 'System fonts'
          ImageIndex = 5
          object sListBox1: TsListBox
            Left = 0
            Top = 27
            Width = 272
            Height = 178
            Align = alClient
            Columns = 2
            TabOrder = 0
            OnClick = sListBox1Click
            BoundLabel.Caption = 'Font name:'
            BoundLabel.Layout = sclLeftTop
          end
          object sComboBox1: TsComboBox
            Left = 0
            Top = 0
            Width = 272
            Height = 21
            Align = alTop
            BoundLabel.Caption = 'Charset:'
            DropDownCount = 20
            Style = csDropDownList
            ItemIndex = -1
            TabOrder = 1
            OnChange = sComboBox1Change
            Items.Strings = (
              'ANSI_CHARSET'
              'DEFAULT_CHARSET'
              'SYMBOL_CHARSET'
              'SHIFTJIS_CHARSET'
              'HANGEUL_CHARSET'
              'GB2312_CHARSET'
              'CHINESEBIG5_CHARSET'
              'OEM_CHARSET'
              'JOHAB_CHARSET'
              'HEBREW_CHARSET'
              'ARABIC_CHARSET'
              'GREEK_CHARSET'
              'TURKISH_CHARSET'
              'VIETNAMESE_CHARSET'
              'THAI_CHARSET'
              'EASTEUROPE_CHARSET'
              'RUSSIAN_CHARSET'
              'MAC_CHARSET'
              'BALTIC_CHARSET')
          end
          object sPanel8: TsPanel
            Left = 0
            Top = 21
            Width = 272
            Height = 6
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 2
          end
        end
        object sTabSheet2: TsTabSheet
          BorderWidth = 3
          Caption = 'Embedded fonts'
          ImageIndex = 1
          object sListBox2: TsListBox
            Left = 0
            Top = 47
            Width = 274
            Height = 160
            Align = alClient
            TabOrder = 0
            OnClick = sListBox2Click
            BoundLabel.Layout = sclLeftTop
            OnBeforeItemDraw = sListBox2BeforeItemDraw
          end
          object sPanel4: TsPanel
            Left = 0
            Top = 0
            Width = 274
            Height = 43
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 1
            object sSpeedButton5: TsSpeedButton
              Left = 0
              Top = 0
              Width = 68
              Height = 43
              Align = alLeft
              Caption = 'Add fonts...'
              Flat = True
              Layout = blGlyphTop
              Spacing = 2
              OnClick = sSpeedButton5Click
              Images = acDM.sCharImageList1
              ImageIndex = 2
            end
            object sSpeedButton6: TsSpeedButton
              Left = 204
              Top = 0
              Width = 70
              Height = 43
              Align = alClient
              Caption = 'Clear all'
              Flat = True
              Layout = blGlyphTop
              Spacing = 2
              OnClick = sSpeedButton6Click
              Images = acDM.sCharImageList1
              ImageIndex = 6
            end
            object sSpeedButton7: TsSpeedButton
              Left = 68
              Top = 0
              Width = 68
              Height = 43
              Align = alLeft
              Caption = 'Delete'
              Enabled = False
              Flat = True
              Layout = blGlyphTop
              Spacing = 2
              OnClick = sSpeedButton7Click
              Images = acDM.sCharImageList1
              ImageIndex = 3
            end
            object sSpeedButton11: TsSpeedButton
              Left = 136
              Top = 0
              Width = 68
              Height = 43
              Align = alLeft
              Caption = 'Update all'
              Enabled = False
              Flat = True
              Layout = blGlyphTop
              Spacing = 2
              OnClick = sSpeedButton11Click
              Images = acDM.sCharImageList1
              ImageIndex = 24
            end
          end
          object sPanel5: TsPanel
            Left = 0
            Top = 43
            Width = 274
            Height = 4
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 2
          end
        end
      end
      object sPanel7: TsPanel
        Tag = 1
        Left = 0
        Top = 542
        Width = 288
        Height = 36
        Align = alBottom
        BevelOuter = bvNone
        BorderWidth = 4
        TabOrder = 1
        object sButton1: TsBitBtn
          Tag = 1
          Left = 122
          Top = 9
          Width = 81
          Height = 27
          Anchors = [akTop, akRight]
          Caption = 'OK'
          Default = True
          ModalResult = 1
          TabOrder = 0
          OnClick = sButton1Click
          ImageIndex = 0
          Images = acDM.sCharImageList1
        end
        object sButton2: TsBitBtn
          Tag = 1
          Left = 207
          Top = 9
          Width = 81
          Height = 27
          Anchors = [akTop, akRight]
          Cancel = True
          Caption = 'Cancel'
          ModalResult = 2
          TabOrder = 1
          ImageIndex = 12
          Images = acDM.sCharImageList1
        end
      end
      object sPanel1: TsPanel
        Left = 0
        Top = 249
        Width = 288
        Height = 12
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
      end
      object sPageControl2: TsPageControl
        Left = 0
        Top = 261
        Width = 288
        Height = 281
        ActivePage = sTabSheet3
        Align = alBottom
        Images = acDM.sCharImageList1
        TabHeight = 26
        TabOrder = 3
        AccessibleDisabledPages = False
        TabPadding = 12
        OnPageChanging = sPageControl2PageChanging
        object sTabSheet3: TsTabSheet
          Caption = 'Char options'
          ImageIndex = -1
          object sLabel3: TsLabel
            Left = 232
            Top = 132
            Width = 15
            Height = 13
            Caption = 'x 1'
            Enabled = False
          end
          object sLabel1: TsLabel
            Left = 77
            Top = 132
            Width = 23
            Height = 13
            Alignment = taRightJustify
            Caption = 'Size:'
            Enabled = False
          end
          object sLabel4: TsLabel
            Left = 232
            Top = 160
            Width = 6
            Height = 13
            Caption = '0'
            Enabled = False
          end
          object sLabel2: TsLabel
            Left = 44
            Top = 160
            Width = 56
            Height = 13
            Alignment = taRightJustify
            Caption = 'Vert offset:'
            Enabled = False
          end
          object sLabel5: TsLabel
            Left = 69
            Top = 187
            Width = 31
            Height = 13
            Alignment = taRightJustify
            Caption = 'Angle:'
            Enabled = False
          end
          object sLabel6: TsLabel
            Left = 232
            Top = 187
            Width = 6
            Height = 13
            Caption = '0'
            Enabled = False
          end
          object sColorBox1: TsColorBox
            Left = 99
            Top = 16
            Width = 160
            Height = 22
            BoundLabel.Active = True
            BoundLabel.Indent = 3
            BoundLabel.Caption = 'Default color:'
            Style = [cbIncludeNone, cbCustomColor, cbSkinColors]
            ShowColorName = False
            Selected = clNone
            NoneColorColor = clNone
            Enabled = False
            TabOrder = 0
            OnChange = sColorBox1Change
          end
          object sTrackBar1: TsTrackBar
            Left = 101
            Top = 128
            Width = 129
            Height = 27
            Enabled = False
            Max = 100
            Min = -100
            TabOrder = 1
            TickStyle = tsNone
            OnUserChange = sTrackBar1Change
          end
          object sCheckBox1: TsCheckBox
            Left = 109
            Top = 215
            Width = 94
            Height = 17
            Caption = 'Draw contour'
            Enabled = False
            TabOrder = 2
            OnClick = sCheckBox1Click
          end
          object sTrackBar2: TsTrackBar
            Left = 101
            Top = 155
            Width = 129
            Height = 27
            Enabled = False
            Min = -10
            TabOrder = 3
            TickStyle = tsNone
            OnUserChange = sTrackBar2Change
          end
          object sTrackBar3: TsTrackBar
            Left = 101
            Top = 182
            Width = 129
            Height = 27
            Enabled = False
            Max = 359
            TabOrder = 4
            TickStyle = tsNone
            OnUserChange = sTrackBar3UserChange
          end
          object sGroupBox1: TsGroupBox
            Left = 12
            Top = 44
            Width = 257
            Height = 65
            Caption = 'Gradient'
            TabOrder = 5
            AutoChildrenStates = csAsChecked
            CheckBoxVisible = True
            OnCheckBoxChanged = sGroupBox1CheckBoxChanged
            object sColorBox3: TsColorBox
              Tag = 1
              Left = 87
              Top = 26
              Width = 160
              Height = 22
              BoundLabel.Active = True
              BoundLabel.Indent = 3
              BoundLabel.Caption = 'Second color:'
              Style = [cbIncludeNone, cbCustomColor, cbSkinColors]
              ShowColorName = False
              Selected = clNone
              NoneColorColor = clNone
              Enabled = False
              TabOrder = 0
              OnChange = sColorBox3Change
            end
          end
        end
        object sTabSheet5: TsTabSheet
          Caption = 'Char'
          ImageIndex = -1
          TabVisible = False
        end
        object sTabSheet4: TsTabSheet
          Tag = 1
          Caption = 'Added char'
          ImageIndex = -1
          object sSpeedButton8: TsSpeedButton
            Tag = 1
            Left = 95
            Top = 32
            Width = 109
            Height = 53
            AllowAllUp = True
            GroupIndex = 1
            Flat = True
            Spacing = 6
            OnMouseDown = sSpeedButton8MouseDown
            OnMouseUp = sSpeedButton1MouseUp
            ButtonStyle = tbsDropDown
            SkinData.SkinSection = 'EDIT'
            Images = CharImageSmall
            Blend = 25
            ImageIndex = 0
          end
          object sLabel8: TsLabel
            Left = 62
            Top = 66
            Width = 27
            Height = 13
            Alignment = taRightJustify
            Caption = 'Char:'
          end
          object sSpeedButton9: TsSpeedButton
            Tag = 1
            Left = 215
            Top = 60
            Width = 34
            Height = 25
            OnClick = sSpeedButton9Click
            DisabledGlyphKind = [dgGrayed]
            Images = acDM.sCharImageList1
            GlyphColorTone = clRed
            ImageIndex = 12
            ShowCaption = False
          end
          object sLabel9: TsLabel
            Tag = 2
            Left = 66
            Top = 136
            Width = 23
            Height = 13
            Alignment = taRightJustify
            Caption = 'Size:'
          end
          object sLabel7: TsLabel
            Tag = 2
            Left = 236
            Top = 136
            Width = 11
            Height = 13
            Caption = '%'
          end
          object sColorBox2: TsColorBox
            Tag = 2
            Left = 96
            Top = 97
            Width = 153
            Height = 22
            BoundLabel.Active = True
            BoundLabel.Indent = 3
            BoundLabel.Caption = 'Default color:'
            Style = [cbIncludeNone, cbCustomColor, cbSkinColors]
            ShowColorName = False
            Selected = clNone
            NoneColorColor = clNone
            TabOrder = 0
            OnChange = sColorBox2Change
          end
          object sTrackBar4: TsTrackBar
            Tag = 2
            Left = 88
            Top = 132
            Width = 142
            Height = 25
            Max = 100
            Min = 25
            Position = 50
            TabOrder = 1
            TickStyle = tsNone
            OnChange = sTrackBar4Change
          end
        end
      end
    end
    object sPanel3: TsPanel
      Left = 12
      Top = 12
      Width = 437
      Height = 578
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object sPanel6: TsPanel
        Left = 0
        Top = 0
        Width = 437
        Height = 26
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object sSpeedButton1: TsSpeedButton
          Left = 0
          Top = 0
          Width = 101
          Height = 26
          Align = alLeft
          AllowAllUp = True
          GroupIndex = 2
          Caption = 'Add new'
          Flat = True
          Spacing = 6
          OnMouseDown = sSpeedButton1MouseDown
          OnMouseUp = sSpeedButton1MouseUp
          ButtonStyle = tbsDropDown
          Images = acDM.sCharImageList1
          Blend = 25
          ImageIndex = 2
        end
        object sSpeedButton2: TsSpeedButton
          Left = 198
          Top = 0
          Width = 92
          Height = 26
          Align = alLeft
          Caption = 'Delete'
          Enabled = False
          Flat = True
          Spacing = 6
          OnClick = sSpeedButton2Click
          Images = acDM.sCharImageList1
          Blend = 25
          ImageIndex = 3
        end
        object sSpeedButton4: TsSpeedButton
          Left = 290
          Top = 0
          Width = 92
          Height = 26
          Align = alLeft
          Caption = 'Remove all'
          Enabled = False
          Flat = True
          Spacing = 6
          OnClick = sSpeedButton4Click
          Images = acDM.sCharImageList1
          Blend = 25
          ImageIndex = 6
        end
        object sSpeedButton3: TsSpeedButton
          Tag = 1
          Left = 101
          Top = 0
          Width = 97
          Height = 26
          Align = alLeft
          AllowAllUp = True
          GroupIndex = 1
          Caption = 'Change'
          Flat = True
          Spacing = 6
          OnMouseDown = sSpeedButton3MouseDown
          OnMouseUp = sSpeedButton1MouseUp
          ButtonStyle = tbsDropDown
          Images = acDM.sCharImageList1
          Blend = 25
          ImageIndex = 19
        end
      end
      object sListView1: TsListView
        Left = 0
        Top = 30
        Width = 437
        Height = 526
        Align = alClient
        Columns = <>
        DragMode = dmAutomatic
        HideSelection = False
        LargeImages = CharImageList
        MultiSelect = True
        ReadOnly = True
        PopupMenu = PopupMenu1
        TabOrder = 1
        OnClick = sListView1Click
        OnDragDrop = sListView1DragDrop
        OnDragOver = sListView1DragOver
        OnResize = sListView1Resize
      end
      object sPanel9: TsPanel
        Left = 0
        Top = 26
        Width = 437
        Height = 4
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 2
      end
      object sSplitView1: TsSplitView
        Left = 0
        Top = 556
        Width = 437
        Height = 22
        BlurData.Mode = bmNone
        CloseStyle = svcaCompact
        CompactSize = 22
        Opened = False
        OpenedSize = 200
        Placement = svpaBottom
        BevelOuter = bvNone
        TabOrder = 3
        object sSpeedButton10: TsSpeedButton
          Left = 0
          Top = 0
          Width = 437
          Height = 22
          Align = alTop
          Caption = 'Preview'
          Flat = True
          OnClick = sSpeedButton10Click
          Images = acDM.sCharImageList1
          ImageIndex = 4
        end
        object sPanel12: TsPanel
          Left = 0
          Top = 22
          Width = 437
          Height = 0
          OnPaint = sPanel12Paint
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
        end
      end
    end
    object sPanel11: TsPanel
      Left = 449
      Top = 12
      Width = 12
      Height = 578
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 2
    end
  end
  object CharImageList: TsCharImageList
    EmbeddedFonts = <>
    Items = <>
    Left = 202
    Top = 129
  end
  object sSkinProvider1: TsSkinProvider
    AddedTitle.Font.Charset = DEFAULT_CHARSET
    AddedTitle.Font.Color = clNone
    AddedTitle.Font.Height = -11
    AddedTitle.Font.Name = 'Tahoma'
    AddedTitle.Font.Style = []
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 230
    Top = 129
  end
  object sOpenDialog1: TsOpenDialog
    DefaultExt = '*.ttf'
    Filter = 
      'Supported fonts|*.ttf;*.otf|TrueType fonts|*.ttf|OpenType fonts|' +
      '*.otf'
    Options = [ofAllowMultiSelect, ofEnableSizing]
    Left = 258
    Top = 129
  end
  object PopupMenu1: TPopupMenu
    Left = 308
    Top = 236
    object S1: TMenuItem
      Caption = 'Select all'
      ShortCut = 16449
      OnClick = S1Click
    end
  end
  object CharImageSmall: TsCharImageList
    Height = 32
    Width = 35
    EmbeddedFonts = <
      item
        FontName = 'FontAwesome'
        FontData = {}
      end>
    Items = <
      item
        Char = 168
      end>
    Left = 701
    Top = 325
    Bitmap = {}
  end
end
