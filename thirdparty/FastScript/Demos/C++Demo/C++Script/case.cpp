/****************************/
/* FastScript v1.0          */
/* 'Case' operator demo     */
/****************************/

int i, j;

void OK(int n)
{
  ShowMessage(n);
}

{
  i = 0;

  switch (i)
  {
    case 1: j = 1;
    case 2..10: { j = 2; j++; }
    default: { j = 10; }
  }

  OK(j);
}
    