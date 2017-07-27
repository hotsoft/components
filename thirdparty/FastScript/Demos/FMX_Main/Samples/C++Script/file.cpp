/**************************}
{ FastScript v1.0          }
{ Files demo               }
{**************************/

{
  TFileStream fs = new TFileStream("test.txt", fmCreate);

  String s = "Testing file...";
  fs.Write(s, Length(s));
  fs.Write("\r\n", 2);
  s = "Tested OK!\r\n";
  fs.Write(s, Length(s));

  delete fs;
}