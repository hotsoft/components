/****************************/
/* FastScript v1.0          */
/* Local variables demo     */
/****************************/

int i;

void OK(int i)
{
  ShowMessage(i);
  i = 11;
}

{
  i = 10;

  if(i == 10)
    OK(1);

  OK(i);
}
    