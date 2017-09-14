//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "selfilt.h"
//---------------------------------------------------------------------------
#pragma resource "*.dfm"
TSelectSaveFilter *SelectSaveFilter;
//---------------------------------------------------------------------------
__fastcall TSelectSaveFilter::TSelectSaveFilter(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TSelectSaveFilter::FiltersBoxDblClick(TObject *Sender)
{
   ModalResult = mrOk;	
}
//---------------------------------------------------------------------------
void __fastcall TSelectSaveFilter::FiltersBoxKeyDown(TObject *Sender, WORD &Key,
	TShiftState Shift)
{
   if ((Key == VK_DELETE) && (FiltersBox->ItemIndex != -1))
      FiltersBox->Items->Delete(FiltersBox->ItemIndex);
}
//---------------------------------------------------------------------------
