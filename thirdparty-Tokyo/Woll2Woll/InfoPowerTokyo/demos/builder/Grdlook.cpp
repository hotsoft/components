//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "Grdlook.h"
//---------------------------------------------------------------------------
#pragma link "vcl.wwdbgrid"
#pragma link "vcl.wwdbigrd"
#pragma link "vcl.wwdblook"
#pragma link "vcl.wwdotdot"
#pragma link "vcl.wwdbedit"
#pragma link "vcl.wwidlg"
#pragma link "vcl.wwDialog"
#pragma link "vcl.wwriched"
#pragma resource "*.dfm"
TGridDemo *GridDemo;
//---------------------------------------------------------------------------
__fastcall TGridDemo::TGridDemo(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
// Demo program uses two grids connected to the same table
// This code causes each grid to display slightly different fields
void __fastcall TGridDemo::TabbedNotebook1Change(TObject *Sender, int NewTab,
	bool &AllowChange)
{
   //Post to prevent record from locking twice
   if (CustomerTable->Modified)CustomerTable->Post();
}
//---------------------------------------------------------------------------
void __fastcall TGridDemo::FormShow(TObject *Sender)
{
 TabbedNotebook1->PageIndex = 0;
}
//---------------------------------------------------------------------------
void __fastcall TGridDemo::wwLookupDialog1UserButton1Click(TObject *Sender,
	TDataSet *LookupTable)
{
   MessageDlg("Attach any code you want to this button.", mtInformation,
      TMsgDlgButtons() << mbOK, 0);
}
//---------------------------------------------------------------------------
void __fastcall TGridDemo::Button1Click(TObject *Sender)
{
/*   ((TTable *)wwLookupDialog1->LookupTable)->IndexName = "";
   ((TTable *)wwLookupDialog1->LookupTable)->SetKey();
   ((TTable *)wwLookupDialog1->LookupTable)->FieldByName("Zip")->AsString = CustomerTableZip->AsString;
   ((TTable *)wwLookupDialog1->LookupTable)->GotoKey();
*/
   if (wwLookupDialog1->Execute()) {
      CustomerTable->Edit();
      CustomerTableZip->AsString = wwLookupDialog1->LookupTable->FieldByName("Zip")->AsString;
      CustomerTableCity->AsString = wwLookupDialog1->LookupTable->FieldByName("City")->AsString;
      CustomerTableState->AsString = wwLookupDialog1->LookupTable->FieldByName("State")->AsString;
   }
}
//---------------------------------------------------------------------------
void __fastcall TGridDemo::BitBtn2Click(TObject *Sender)
{
 Close();	
}
//---------------------------------------------------------------------------
void __fastcall TGridDemo::FormCloseQuery(TObject *Sender, bool &CanClose)
{
CustomerTable->CheckBrowseMode();	
}
//---------------------------------------------------------------------------
