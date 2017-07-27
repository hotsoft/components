/****************************/
/* FastScript v1.0          */
/* 'If' operator demo       */
/****************************/

void OK(int n)
{
  ShowMessage(n);
}

{
  int i = 10;

  if(i == 10) { i = 1; }

  if (i == 1) OK(1);
  else if (i == 2) OK(2);
  else if (i == 3) OK(3);
  else if (i == 4) OK(4);
  else if (i == 5) OK(5);
}
    