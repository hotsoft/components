/****************************/
/* FastScript v1.0          */
/*'while' operator demo     */
/****************************/

int i, j;

void OK(int n)
{
  ShowMessage(n);
}

{
  j = 1;
  i = 0;
  while (i < 10)
  {
    j++;
    Inc(i);
  }

  OK(j);
}
    