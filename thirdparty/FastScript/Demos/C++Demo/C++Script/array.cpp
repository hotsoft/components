/***************************/
/* FastScript v1.0         */
/* Arrays demo             */
/***************************/

int i, j;
string ar[10], s;


void OK(string s)
{
  ShowMessage(s);
}

{
  for(i = 0; i < 10; i++)
    ar[i] = IntToStr(i);

  s = "";
  for(i = 0; i< 10; i++)
    s += ar[i];

  OK(s);
}
    