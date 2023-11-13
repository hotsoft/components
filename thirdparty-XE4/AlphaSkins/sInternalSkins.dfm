object FormInternalSkins: TFormInternalSkins
  Left = 552
  Top = 239
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Internal skins'
  ClientHeight = 393
  ClientWidth = 503
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 430
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  object sPanel1: TsPanel
    Left = 0
    Top = 35
    Width = 503
    Height = 358
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 12
    TabOrder = 0
    object sPanel3: TsPanel
      Left = 252
      Top = 12
      Width = 239
      Height = 334
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object sGroupBox1: TsGroupBox
        Left = 8
        Top = 0
        Width = 231
        Height = 174
        Caption = 'Skin info:'
        TabOrder = 0
        object sLabel10: TsLabel
          Left = 11
          Top = 116
          Width = 210
          Height = 46
          AutoSize = False
          Caption = 'Description:'
          WordWrap = True
        end
        object sLabel11: TsLabel
          Left = 50
          Top = 93
          Width = 29
          Height = 16
          Alignment = taRightJustify
          BiDiMode = bdLeftToRight
          Caption = 'Size:'
          ParentBiDiMode = False
        end
        object sLabel12: TsLabel
          Left = 82
          Top = 93
          Width = 50
          Height = 16
          Caption = 'sLabel12'
        end
        object sLabel9: TsLabel
          Left = 82
          Top = 70
          Width = 43
          Height = 16
          Caption = 'sLabel9'
        end
        object sLabel5: TsLabel
          Left = 18
          Top = 70
          Width = 61
          Height = 16
          Alignment = taRightJustify
          BiDiMode = bdLeftToRight
          Caption = 'File name:'
          ParentBiDiMode = False
        end
        object sLabel4: TsLabel
          Left = 36
          Top = 47
          Width = 43
          Height = 16
          Alignment = taRightJustify
          BiDiMode = bdLeftToRight
          Caption = 'Author:'
          ParentBiDiMode = False
        end
        object sLabel8: TsLabel
          Left = 82
          Top = 47
          Width = 43
          Height = 16
          Caption = 'sLabel8'
        end
        object sLabel7: TsLabel
          Left = 82
          Top = 24
          Width = 43
          Height = 16
          Caption = 'sLabel7'
        end
        object sLabel3: TsLabel
          Left = 31
          Top = 24
          Width = 48
          Height = 16
          Alignment = taRightJustify
          BiDiMode = bdLeftToRight
          Caption = 'Version:'
          ParentBiDiMode = False
        end
      end
      object sBitBtn1: TsBitBtn
        Left = 152
        Top = 304
        Width = 87
        Height = 30
        Anchors = [akLeft, akBottom]
        Cancel = True
        Caption = 'Exit'
        Default = True
        Spacing = 6
        TabOrder = 1
        OnClick = sBitBtn1Click
        Blend = 30
        ImageIndex = 13
        Images = acDM.sCharImageList1
      end
      object sGroupBox2: TsGroupBox
        Left = 8
        Top = 180
        Width = 231
        Height = 109
        Caption = 'External storage:'
        TabOrder = 2
        object sLabel1: TsLabel
          Left = 7
          Top = 19
          Width = 218
          Height = 34
          AutoSize = False
          Caption = 'sLabel1'
          WordWrap = True
        end
        object sButton6: TsBitBtn
          Left = 50
          Top = 57
          Width = 173
          Height = 44
          Caption = 'Update internal skins from storage'
          Margin = 8
          Spacing = 12
          TabOrder = 0
          OnClick = sButton6Click
          Blend = 30
          ImageIndex = 24
          Images = acDM.sCharImageList1
        end
      end
    end
    object ListBox1: TsListBox
      Left = 12
      Top = 12
      Width = 240
      Height = 334
      Align = alClient
      Ctl3D = True
      ItemHeight = 18
      ParentCtl3D = False
      Sorted = True
      TabOrder = 1
      OnClick = ListBox1Click
      SkinData.SkinSection = 'EDIT'
    end
  end
  object sPanel6: TsPanel
    Left = 0
    Top = 0
    Width = 503
    Height = 35
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object sSpeedButton1: TsSpeedButton
      Left = 12
      Top = 6
      Width = 81
      Height = 29
      Caption = 'Add...'
      Flat = True
      Spacing = 6
      OnClick = sSpeedButton1Click
      Images = acDM.sCharImageList1
      ImageIndex = 2
    end
    object sSpeedButton2: TsSpeedButton
      Left = 93
      Top = 6
      Width = 87
      Height = 29
      Caption = 'Rename'
      Enabled = False
      Flat = True
      Spacing = 6
      OnClick = sSpeedButton2Click
      Images = acDM.sCharImageList1
      ImageIndex = 14
    end
    object sSpeedButton3: TsSpeedButton
      Left = 180
      Top = 6
      Width = 87
      Height = 29
      Caption = 'Delete'
      Enabled = False
      Flat = True
      Spacing = 6
      OnClick = sSpeedButton3Click
      Images = acDM.sCharImageList1
      ImageIndex = 3
    end
    object sSpeedButton4: TsSpeedButton
      Left = 267
      Top = 6
      Width = 81
      Height = 29
      Caption = 'Clear'
      Flat = True
      Spacing = 6
      OnClick = sSpeedButton4Click
      Images = acDM.sCharImageList1
      ImageIndex = 22
    end
    object sSpeedButton5: TsSpeedButton
      Left = 348
      Top = 6
      Width = 87
      Height = 29
      Caption = 'Extract'
      Enabled = False
      Flat = True
      Spacing = 6
      OnClick = sSpeedButton5Click
      Images = acDM.sCharImageList1
      ImageIndex = 15
    end
  end
  object sSkinProvider1: TsSkinProvider
    ShowAppIcon = False
    CaptionAlignment = taCenter
    TitleButtons = <>
    TitleIcon.Visible = False
    Left = 104
    Top = 95
  end
end
