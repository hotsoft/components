'**************************
' FastScript v1.0          
' Bitmap demo              
'**************************

sub MakePattern(b)
  dim i, j
  for i = 0 to b.Width - 1
    for j = 0 to b.Height - 1
      if ((i + j) mod 3) = 0 then
        b.Pixels[i, j] = claWhite 
      else
        b.Pixels[i, j] = claBlack
      end if
    next
  next
end sub


  dim bmp = new TBitmap(100, 100)
  MakePattern(bmp)
  bmp.SaveToFile("test.bmp")
  delete bmp
  ShowMessage("BMP file saved successfully")