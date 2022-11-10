object frmUpdateInfo: TfrmUpdateInfo
  Left = 299
  Top = 55
  BorderStyle = bsDialog
  Caption = 'Update Info'
  ClientHeight = 249
  ClientWidth = 375
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 12
    Top = 212
    Width = 351
    Height = 2
  end
  object lblInfo: TLabel
    Left = 17
    Top = 10
    Width = 339
    Height = 39
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 19
    Top = 70
    Width = 33
    Height = 13
    Caption = 'Author'
  end
  object Label3: TLabel
    Left = 19
    Top = 116
    Width = 40
    Height = 13
    Caption = 'Updates'
  end
  object Label5: TLabel
    Left = 19
    Top = 93
    Width = 37
    Height = 13
    Caption = 'Product'
  end
  object Label7: TLabel
    Left = 19
    Top = 186
    Width = 28
    Height = 13
    Caption = 'E-Mail'
  end
  object edtAuthor: TEdit
    Left = 97
    Top = 66
    Width = 261
    Height = 21
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 0
    Text = 'edtAuthor'
  end
  object edtProduct: TEdit
    Left = 97
    Top = 89
    Width = 261
    Height = 21
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 1
    Text = 'edtProduct'
  end
  object edtEmail: TEdit
    Left = 97
    Top = 183
    Width = 261
    Height = 21
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 2
    Text = 'edtEmail'
  end
  object btnUpdate: TButton
    Left = 97
    Top = 221
    Width = 72
    Height = 22
    Caption = '&Update Now'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object btnCancel: TButton
    Left = 190
    Top = 221
    Width = 87
    Height = 22
    Cancel = True
    Caption = 'Do &Not Update'
    ModalResult = 2
    TabOrder = 4
  end
  object memUpdates: TMemo
    Left = 97
    Top = 112
    Width = 260
    Height = 69
    Color = clBtnFace
    Lines.Strings = (
      'memUpdates')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 5
  end
end
