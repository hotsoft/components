/**************************}
{ FastScript v1.0          }
{ Bitmap demo              }
{**************************/

void MakePattern(TBitmap b)
{ 
  for (int i = 0; i < b.Width; i++)
    for (int j = 0; j < b.Height; j++)
      if (((i + j) % 3) == 0)
        b.Canvas.Pixels[i, j] = clWhite; else
        b.Canvas.Pixels[i, j] = clBlack;
}

{
  TBitmap bmp = new TBitmap;
  bmp.Width = 100;
  bmp.Height = 100;
  MakePattern(bmp);
  bmp.SaveToFile("test.bmp");
  delete bmp;
  ShowMessage("BMP file saved successfully");
}
