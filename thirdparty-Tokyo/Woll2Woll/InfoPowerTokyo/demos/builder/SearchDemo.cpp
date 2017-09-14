//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "SearchDemo.h"
//---------------------------------------------------------------------------
#pragma link "vcl.wwkeycb"
#pragma link "vcl.wwdbcomb"
#pragma link "vcl.wwdbedit"
#pragma link "vcl.wwdotdot"
#pragma resource "*.dfm"
TIncrSearch *IncrSearch;
//---------------------------------------------------------------------------
__fastcall TIncrSearch::TIncrSearch(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TIncrSearch::wwKeyCombo1Change(TObject *Sender)
{
   wwIncrementalSearch1->Text= "";
   wwIncrementalSearch1->SetFocus();
}
//---------------------------------------------------------------------------
