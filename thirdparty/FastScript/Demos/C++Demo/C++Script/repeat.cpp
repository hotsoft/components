/****************************/
/* FastScript v1.0          */
/*'do..while' operator demo */
/****************************/

int i, j;

void OK(int n)
{
  ShowMessage(n);
}

{
  j = 1;
  i = 0;
  do
    i++;
  while (i!=10);

  OK(i);
}
    