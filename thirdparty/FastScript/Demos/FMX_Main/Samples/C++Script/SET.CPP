/****************************/
/* FastScript v1.0          */
/* Set demo                 */
/****************************/

int i, j;
string s;

{
  s = "Hello World!\n\rIt's working!";

  j = 0;
  for(i = 1; i <= Length(s); i++)
    if (s[i] in [" ", "!", Chr(0x0)..Chr(0x1f), "'"])
      j++;

  ShowMessage(j);
}
    