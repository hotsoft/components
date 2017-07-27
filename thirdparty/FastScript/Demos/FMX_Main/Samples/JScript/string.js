//****************************/
//* FastScript v1.0          */
//* String demo              */
//****************************/


  var s = "Hello World!\r\nIt's working!";
  var j = 0;

  for(var i = 1; i <= Length(s); i++)
    if (s[i] == " ")
      j++;

  ShowMessage(j);

    