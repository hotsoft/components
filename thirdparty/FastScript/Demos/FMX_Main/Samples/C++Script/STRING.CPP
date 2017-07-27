/****************************/
/* FastScript v1.0          */
/* String demo              */
/****************************/

{
  string s = "Hello World!\n\rIt's working!";

  int j = 0;
  for(int i = 1; i <= Length(s); i++)
    if (s[i] == " ")
      j++;

  ShowMessage(j);
}
    