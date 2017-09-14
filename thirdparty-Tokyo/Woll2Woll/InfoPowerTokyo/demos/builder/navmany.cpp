//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "navmany.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "vcl.wwdbgrid"
#pragma link "vcl.wwdbigrd"
#pragma link "vcl.wwDBNavigator"
#pragma link "vcl.wwriched"
#pragma link "vcl.wwSpeedButton"
#pragma link "vcl.wwclearpanel"
#pragma resource "*.dfm"
TNavigatorForm1 *NavigatorForm1;
//---------------------------------------------------------------------------
__fastcall TNavigatorForm1::TNavigatorForm1(TComponent* Owner)
    : TForm(Owner)
{
}
//---------------------------------------------------------------------------
