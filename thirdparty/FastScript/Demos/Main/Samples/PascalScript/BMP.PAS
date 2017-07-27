{**************************}
{ FastScript v1.0          }
{ Bitmap demo              }
{**************************}

var
  bmp: TBitmap;

procedure MakePattern(b: TBitmap);
var
  i, j: Integer;
begin
  for i := 0 to b.Width - 1 do
    for j := 0 to b.Height - 1 do
      if ((i + j) mod 3) = 0 then
        b.Canvas.Pixels[i, j] := clWhite else
        b.Canvas.Pixels[i, j] := clBlack;
end;

begin
  bmp := TBitmap.Create;
  bmp.Width := 100;
  bmp.Height := 100;
  MakePattern(bmp);
  bmp.SaveToFile('test.bmp');
  bmp.Free;
  ShowMessage('BMP file saved successfully');
end.
