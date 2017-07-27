' FastScript v1.0          
' Files demo               


dim fs, s

  fs = new TFileStream("test.txt", fmCreate)

  s = "Testing file..."
  fs.Write(s, Length(s))
  fs.Write(#13#10, 2)
  s = "Tested OK!"#13#10
  fs.Write(s, Length(s))

  delete fs
