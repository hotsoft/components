{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clActionInfo;

interface

{$I ..\common\clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Forms, Classes, Controls, StdCtrls, Windows, Messages,
{$ELSE}
  Vcl.Forms, System.Classes, Vcl.Controls, Vcl.StdCtrls, Winapi.Windows, Winapi.Messages,
{$ENDIF}
  clHtmlParser;

type
  THttpActionInfo = class(TForm)
    btnOK: TButton;
    lblCaption: TLabel;
    edtAction: TEdit;
  public
    class procedure ShowAction(const AUrl: string);
  end;

implementation

{$R *.DFM}

{ THttpActionInfo }

class procedure THttpActionInfo.ShowAction(const AUrl: string);
var
  Dlg: THttpActionInfo;
begin
  Dlg := THttpActionInfo.Create(nil);
  try
    Dlg.edtAction.Text := AUrl;
    Dlg.ShowModal();
  finally
    Dlg.Free();
  end;
end;

end.
