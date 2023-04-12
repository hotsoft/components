inherited Form1: TForm1
  Left = 372
  Top = 217
  Caption = 'GMAIL SMTP client with OAuth - Sample'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlMain: TPanel
    object Label5: TLabel
      Left = 16
      Top = 16
      Width = 24
      Height = 13
      Caption = 'From'
    end
    object Label6: TLabel
      Left = 16
      Top = 43
      Width = 12
      Height = 13
      Caption = 'To'
    end
    object Label7: TLabel
      Left = 16
      Top = 70
      Width = 36
      Height = 13
      Caption = 'Subject'
    end
    object edtFrom: TEdit
      Left = 56
      Top = 13
      Width = 553
      Height = 21
      TabOrder = 0
      Text = 'user@gmail.com'
    end
    object edtTo: TEdit
      Left = 56
      Top = 40
      Width = 553
      Height = 21
      TabOrder = 1
      Text = 'johndoe@domain.com'
    end
    object edtSubject: TEdit
      Left = 56
      Top = 67
      Width = 553
      Height = 21
      TabOrder = 2
      Text = 'Sample message'
    end
    object memBody: TMemo
      Left = 16
      Top = 94
      Width = 593
      Height = 227
      Lines.Strings = (
        'This is a sample email')
      TabOrder = 3
    end
    object btnSend: TButton
      Left = 488
      Top = 329
      Width = 121
      Height = 25
      Caption = 'Send'
      TabOrder = 4
      OnClick = btnSendClick
    end
  end
  object clSmtp1: TclSmtp
    MailAgent = 'Clever Internet Suite v 7.0'
    Left = 64
    Top = 232
  end
  object clMailMessage1: TclMailMessage
    ToList = <>
    CCList = <>
    BCCList = <>
    Date = 40009.488706053240000000
    CharSet = 'iso-8859-1'
    ContentType = 'text/plain'
    Left = 112
    Top = 232
  end
  object clOAuth1: TclOAuth
    UserAgent = 'CleverComponents OAUTH 2.0'
    EnterCodeFormCaption = 'Enter Authorization Code'
    SuccessHtmlResponse = 
      '<html><body><h3 style="color:green;margin:30px">OAuth Authorizat' +
      'ion Successful!</h3></body></html>'
    FailedHtmlResponse = 
      '<html><body><h3 style="color:red;margin:30px">OAuth Authorizatio' +
      'n Failed!</h3></body></html>'
    Left = 160
    Top = 232
  end
end
