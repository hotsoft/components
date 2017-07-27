//**************************}
//{ FastScript v1.0          }
//{ 'is' operator demo       }
//{**************************/


  var o = new TObject;
  var p = new TPersistent;
  if (o is TObject)
    ShowMessage("o is TObject");
  if (p is TObject)
    ShowMessage("p is TObject");
  if (!(o is TPersistent))
    ShowMessage("o is not TPersistent");
