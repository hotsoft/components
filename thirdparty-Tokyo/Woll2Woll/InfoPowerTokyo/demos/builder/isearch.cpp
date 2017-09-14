//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "isearch.h"
//---------------------------------------------------------------------------
#pragma link "vcl.wwidlg"
#pragma link "vcl.wwDialog"
#pragma resource "*.dfm"
TSearchForm *SearchForm;
//---------------------------------------------------------------------------
__fastcall TSearchForm::TSearchForm(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TSearchForm::FormClose(TObject *Sender, TCloseAction &Action)
{
   CustomerTable->CheckBrowseMode();	
}
//---------------------------------------------------------------------------
void __fastcall TSearchForm::BitBtn1Click(TObject *Sender)
{
   String userButtonCaption;

   TwwDBLookupDlgOptions TempOptions = wwSearchDialog1->Options;

   if (OKCancelCheckBox->Checked) TempOptions << opShowOKCancel;
   else TempOptions >> opShowOKCancel;

   if (FixFirstColumnCheckBox->Checked) TempOptions << opFixFirstColumn;
   else TempOptions >> opFixFirstColumn;

   if (GroupControlsCheckBox->Checked) TempOptions << opGroupControls;
   else TempOptions >> opGroupControls;

   if (ShowStatusBarCheckBox->Checked) TempOptions << opShowStatusBar;
   else TempOptions >> opShowStatusBar;

   if (ShowSearchByCheckbox->Checked) TempOptions << opShowSearchBy;
   else TempOptions >> opShowSearchBy;

   wwSearchDialog1->Options = TempOptions;

   userButtonCaption = wwSearchDialog1->UserButton1Caption;
   if (!ShowUserButtonCheckBox->Checked)
      wwSearchDialog1->UserButton1Caption = "";

   wwSearchDialog1->Execute();

   wwSearchDialog1->UserButton1Caption = userButtonCaption;
}
//---------------------------------------------------------------------------
void __fastcall TSearchForm::wwSearchDialog1UserButton1Click(TObject *Sender,
	TDataSet *LookupTable)
{
   MessageDlg("Attach any code you want to this button.", mtInformation,
      TMsgDlgButtons() << mbOK, 0);
}
//---------------------------------------------------------------------------
