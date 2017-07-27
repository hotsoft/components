//***************************/
//* FastScript v1.0         */
//* Arrays demo             */
//***************************/


  var ar[10];

  for(var i = 0; i < 10; i++)
    ar[i] = IntToStr(i);

  var s = "";
  for(i = 0; i < 10; i++)
    s += ar[i];

  ShowMessage(s);

   