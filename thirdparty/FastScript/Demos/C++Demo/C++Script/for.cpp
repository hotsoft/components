/****************************/
/* FastScript v1.0          */
/* 'For' operator demo      */
/****************************/

int i;

void OK(int n)
{
  ShowMessage(n);
}

{
  for(i = 0; i < 10; i++)
    if(i == 1) OK(1);
    else if(i == 2) OK(2);
    else if (i == 3) OK(3);
    else if (i == 4) OK(4);
    else if (i == 5) OK(5);
}
    