//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "Lkquery.h"
//---------------------------------------------------------------------------
#pragma link "vcl.wwdbgrid"
#pragma link "vcl.wwdbigrd"
#pragma link "vcl.wwdblook"
#pragma link "vcl.wwriched"
#pragma link "vcl.wwdbdlg"
#pragma resource "*.dfm"
TTableQueryForm *TableQueryForm;
//---------------------------------------------------------------------------
__fastcall TTableQueryForm::TTableQueryForm(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TTableQueryForm::RadioGroup1Click(TObject *Sender)
{
   if (((TRadioGroup *)Sender)->ItemIndex==0)
      wwDBGrid1->SetControlType("Zip", fctCustom, "wwDBLookupCombo1");
   else
      wwDBGrid1->SetControlType("Zip", fctCustom, "wwDBLookupComboDlg1");
}
//---------------------------------------------------------------------------
