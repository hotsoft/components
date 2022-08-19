{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clUpdateInfoForm;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls,
{$ELSE}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
{$ENDIF}
  clWebUpdate;

type
  TfrmUpdateInfo = class(TForm)
    Bevel1: TBevel;
    lblInfo: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    edtAuthor: TEdit;
    edtProduct: TEdit;
    edtEmail: TEdit;
    btnUpdate: TButton;
    btnCancel: TButton;
    memUpdates: TMemo;
  public
    class function ShowInfo(AWebUpdate: TclWebUpdate): Boolean;
  end;

resourcestring
  cUpdateInfoCaption = 'The system detected that you are using version ''%s'', but version ''%s'' is available for downloading from %s.';

implementation

{$R *.dfm}

{ TfrmUpdateInfo }

class function TfrmUpdateInfo.ShowInfo(AWebUpdate: TclWebUpdate): Boolean;
var
  i: Integer;
  Dlg: TfrmUpdateInfo;
  product, ver: string;
  instItem: TclUpdateInfoItem;
begin
  Dlg := TfrmUpdateInfo.Create(nil);
  try
    product := AWebUpdate.ProductURL;
    if (Trim(product) = '') then
    begin
      product := 'the web';
    end;

    ver := '-';
    instItem := AWebUpdate.ActualInfo.LastItemByStatus(usSuccess);
    if (instItem <> nil) then
    begin
      ver := instItem.Version;
    end;

    Dlg.lblInfo.Caption := Format(cUpdateInfoCaption,
      [ver, AWebUpdate.UpdateInfo[AWebUpdate.UpdateInfo.Count - 1].Version, product]);
    Dlg.memUpdates.Lines.Clear();
    for i := 0 to AWebUpdate.UpdateInfo.Count - 1 do
    begin
      Dlg.memUpdates.Lines.Add(Format('Version: %s, Size: %s, URL: %s',
        [AWebUpdate.UpdateInfo[i].Version, AWebUpdate.UpdateInfo[i].Size, AWebUpdate.UpdateInfo[i].URL]));
    end;

    Dlg.edtAuthor.Text := AWebUpdate.Author;
    Dlg.edtProduct.Text := AWebUpdate.ProductName;
    Dlg.edtEmail.Text := AWebUpdate.Email;
    Result := (Dlg.ShowModal() = mrOk);
  finally
    Dlg.Free();
  end;
end;

end.
