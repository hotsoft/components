/****************************/
/* FastScript v1.0          */
/* 'For' operator demo 1    */
/****************************/

int i, j;

void OK(int n)
{
  ShowMessage(n);
}

{
  j = 1;
  for(i = 0; i < 10; i++)
    j++;

  OK(j);
}
    