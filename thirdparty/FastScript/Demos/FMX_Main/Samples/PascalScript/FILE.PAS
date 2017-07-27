{**************************}
{ FastScript v1.0          }
{ Files demo               }
{**************************}

var
  fs: TFileStream;
  s: String;
begin
  fs := TFileStream.Create('test.txt', fmCreate);

  s := 'Testing file...';
  fs.Write(s, Length(s));
  fs.Write(#13#10, 2);
  s := 'Tested OK!'#13#10;
  fs.Write(s, Length(s));

  fs.Free;
end.