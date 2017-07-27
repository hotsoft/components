unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses fs_xml;

procedure MakeFile(xml: String);
var
  i: Integer;
  s: String;
  fs: TFileStream;
begin
  fs := TFileStream.Create('..\fs_ilang.pas', fmCreate);

  s :=
'{******************************************}'#13#10 +
'{                                          }'#13#10 +
'{             FastScript v1.0              }'#13#10 +
'{              Language file               }'#13#10 +
'{                                          }'#13#10 +
'{     (c) 2003 by Alexander Tzyganenko,    }'#13#10 +
'{             Fast Reports, Inc            }'#13#10 +
'{                                          }'#13#10 +
'{******************************************}'#13#10 +
''#13#10 +
'unit fs_ilang;'#13#10 +
''#13#10 +
'interface'#13#10 +
''#13#10 +
'const'#13#10 +
'  fs_LANG = ';

  fs.Write(s[1], Length(s));

  while Length(xml) > 0 do
  begin
    i := 75;
    repeat
      Dec(i);
      s := QuotedStr(Copy(xml, 1, i));
    until Length(s) <= 74;

    Delete(xml, 1, i);
    s := #13#10 + '  ' + s;
    if Length(xml) <> 0 then
      s := s + ' +';
    fs.Write(s[1], Length(s));
  end;

  s :=
';'#13#10 +
''#13#10 +
'implementation'#13#10 +
''#13#10 +
'end.'#13#10;

  fs.Write(s[1], Length(s));
  fs.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  XML: TfsXMLDocument;
  ms: TMemoryStream;
  s: String;
begin
  ms := TMemoryStream.Create;
  XML := TfsXMLDocument.Create;
  XML.LoadFromFile('..\fs_ilang.xml');
  XML.SaveToStream(ms);
  XML.Free;

  ms.Position := 0;
  SetLength(s, ms.Size);
  ms.Read(s[1], ms.Size);
  ms.Free;

  MakeFile(s);
end;

end.
