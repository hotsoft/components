/****************************/
/* FastScript v1.0          */
/* Default params demo      */
/****************************/

void OK(int i = 1, int j = 1)
{
  ShowMessage(IntToStr(i) + " " + IntToStr(j));
}

{
  OK();
  OK(0);
  OK(1, 2);
}