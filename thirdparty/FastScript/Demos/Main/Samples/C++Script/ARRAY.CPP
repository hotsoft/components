/***************************/
/* FastScript v1.0         */
/* Arrays demo             */
/***************************/

{
  string ar[10];

  for(int i = 0; i < 10; i++)
    ar[i] = IntToStr(i);

  string s = "";
  for(i = 0; i < 10; i++)
    s += ar[i];

  ShowMessage(s);
}
    