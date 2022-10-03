object clHTTPRequestEditorDlg: TclHTTPRequestEditorDlg
  Left = 435
  Top = 112
  Width = 371
  Height = 344
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeToolWin
  Caption = 'HTTP Request Editor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnHide = FormHide
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 355
    Height = 8
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 0
    Top = 8
    Width = 6
    Height = 268
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 1
  end
  object Panel3: TPanel
    Left = 349
    Top = 8
    Width = 6
    Height = 268
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 0
    Top = 276
    Width = 355
    Height = 30
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    object Panel7: TPanel
      Left = 132
      Top = 0
      Width = 223
      Height = 30
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnOK: TButton
        Left = 16
        Top = 5
        Width = 91
        Height = 22
        Caption = '&OK'
        Default = True
        ModalResult = 1
        TabOrder = 0
      end
      object btnCancel: TButton
        Left = 116
        Top = 5
        Width = 91
        Height = 22
        Cancel = True
        Caption = '&Cancel'
        ModalResult = 2
        TabOrder = 1
      end
    end
  end
  object PageControl: TPageControl
    Left = 6
    Top = 8
    Width = 343
    Height = 268
    ActivePage = tsItems
    Align = alClient
    TabOrder = 4
    OnChange = PageControlChange
    object tsItems: TTabSheet
      Caption = '  Items  '
      object Panel5: TPanel
        Left = 0
        Top = 6
        Width = 6
        Height = 228
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 0
      end
      object Panel6: TPanel
        Left = 0
        Top = 0
        Width = 335
        Height = 6
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 1
      end
      object Panel8: TPanel
        Left = 0
        Top = 234
        Width = 335
        Height = 6
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 2
      end
      object pnButtons: TPanel
        Left = 229
        Top = 6
        Width = 106
        Height = 228
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 3
        object btnAdd: TButton
          Left = 8
          Top = 0
          Width = 91
          Height = 22
          Caption = '&Add...'
          TabOrder = 0
          OnClick = btnAddClick
        end
        object btnDelete: TButton
          Left = 8
          Top = 30
          Width = 91
          Height = 22
          Caption = '&Delete'
          TabOrder = 1
          OnClick = btnDeleteClick
        end
        object btnUp: TButton
          Left = 8
          Top = 59
          Width = 91
          Height = 22
          Caption = 'Move &Up'
          TabOrder = 2
          OnClick = btnUpClick
        end
        object btnDown: TButton
          Left = 8
          Top = 88
          Width = 91
          Height = 22
          Caption = 'Move Dow&n'
          TabOrder = 3
          OnClick = btnDownClick
        end
      end
      object ItemList: TListBox
        Left = 6
        Top = 6
        Width = 223
        Height = 228
        Align = alClient
        ItemHeight = 13
        PopupMenu = pmItems
        TabOrder = 4
        OnDblClick = ItemListDblClick
      end
    end
    object tsContent: TTabSheet
      Caption = '  Content  '
      DesignSize = (
        335
        240)
      object pDetails: TPanel
        Left = 6
        Top = 8
        Width = 331
        Height = 235
        Anchors = [akLeft, akTop, akRight, akBottom]
        BevelOuter = bvNone
        TabOrder = 0
      end
    end
  end
  object pmItems: TPopupMenu
    Left = 228
    Top = 6
    object miAdd: TMenuItem
      Caption = '&Add...'
      ShortCut = 45
      OnClick = btnAddClick
    end
    object miDelete: TMenuItem
      Caption = '&Delete'
      ShortCut = 46
      OnClick = btnDeleteClick
    end
    object miUp: TMenuItem
      Caption = 'Move &Up'
      OnClick = btnUpClick
    end
    object miDown: TMenuItem
      Caption = 'Move Dow&n'
      OnClick = btnDownClick
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miBuildUrl: TMenuItem
      Caption = 'Build by &Url...'
      OnClick = miBuildUrlClick
    end
    object miBuildFile: TMenuItem
      Caption = 'Build by &File...'
      OnClick = miBuildFileClick
    end
    object miBuildText: TMenuItem
      Caption = 'Build by &Text...'
      OnClick = miBuildTextClick
    end
  end
end
