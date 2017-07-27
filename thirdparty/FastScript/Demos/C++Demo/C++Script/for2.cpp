/****************************/
/* FastScript v1.0          */
/* 'For' operator demo 2    */
/****************************/

int i, j;


void OK(int n)
{
  ShowMessage(n);
}

{
  j = 1;
  for(i = 9; i>=0; i--)
    j = i;

  OK(j);
}
    