//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "gridctrl.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "vcl.wwclearbuttongroup"
#pragma link "vcl.wwDataInspector"
#pragma link "vcl.wwdbgrid"
#pragma link "vcl.wwdbigrd"
#pragma link "vcl.wwradiogroup"
#pragma link "vcl.wwriched"
#pragma resource "*.dfm"
TGridControlsForm *GridControlsForm;
//---------------------------------------------------------------------------
__fastcall TGridControlsForm::TGridControlsForm(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------
