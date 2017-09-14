//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "Combos.h"
//---------------------------------------------------------------------------
#pragma link "vcl.Wwdbdlg"
#pragma link "vcl.wwdblook"
#pragma resource "*.dfm"
TLookupForm *LookupForm;
//---------------------------------------------------------------------------
__fastcall TLookupForm::TLookupForm(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TLookupForm::wwDBLookupCombo1CloseUp(TObject *Sender,
	TDataSet *LookupTable, TDataSet *FillTable, bool modified)
{
   if (!FillCheckBox->Checked) return;
   if (!modified) return;

   Zip->Text = LookupTable->FieldByName("Zip")->AsString;
   City->Text = LookupTable->FieldByName("City")->AsString;
   State->Text = LookupTable->FieldByName("State")->AsString;
}
//---------------------------------------------------------------------------
void __fastcall TLookupForm::wwDBLookupCombo1DropDown(TObject *Sender)
{
    if (AlignRightCheckBox->Checked)
       wwDBLookupCombo1->DropDownAlignment = taRightJustify;
    else
       wwDBLookupCombo1->DropDownAlignment = taLeftJustify;
}
//---------------------------------------------------------------------------
void __fastcall TLookupForm::wwDBLookupCombo2DropDown(TObject *Sender)
{
    if (AlignRightCheckBox->Checked)
       wwDBLookupCombo2->DropDownAlignment = taRightJustify;
    else wwDBLookupCombo2->DropDownAlignment = taLeftJustify;
}
//---------------------------------------------------------------------------
void __fastcall TLookupForm::FormActivate(TObject *Sender)
{
   if (!initialized) {
      ShowButton->Checked = True;
      AutoDropDownCheckBox->Checked = True;
      initialized = True;
   }
}
//---------------------------------------------------------------------------
void __fastcall TLookupForm::FormClose(TObject *Sender, TCloseAction &Action)
{
 CustomerTable->CheckBrowseMode();
}
//---------------------------------------------------------------------------
void __fastcall TLookupForm::wwDBLookupComboDlg1UserButton1Click(
	TObject *Sender, TDataSet *LookupTable)
{
   MessageDlg("Attach your own code to these programmable buttons to expand this dialog's capabilities.",
      mtInformation, TMsgDlgButtons() << mbOK, 0);
}
//---------------------------------------------------------------------------
void __fastcall TLookupForm::wwDBLookupComboDlg1DropDown(TObject *Sender)
{
  TwwDBLookupDlgOptions TempOptions = wwDBLookupComboDlg1->Options;

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

  wwDBLookupComboDlg1->Options = TempOptions;

  if (ShowUserButtonCheckBox->Checked)
     wwDBLookupComboDlg1->UserButton1Caption = "New";
  else wwDBLookupComboDlg1->UserButton1Caption = "";
	
}
//---------------------------------------------------------------------------
void __fastcall TLookupForm::wwDBLookupComboDlg1InitDialog(TwwLookupDlg *Dialog)
{
 Dialog->wwIncrementalSearch1->ShowMatchText = wwDBLookupComboDlg1->ShowMatchText;	
}
//---------------------------------------------------------------------------
void __fastcall TLookupForm::AutoDropDownCheckBoxClick(TObject *Sender)
{
    wwDBLookupCombo1->AutoDropDown = AutoDropDownCheckBox->Checked;
    wwDBLookupCombo2->AutoDropDown = AutoDropDownCheckBox->Checked;	
}
//---------------------------------------------------------------------------
void __fastcall TLookupForm::ShowButtonClick(TObject *Sender)
{
    wwDBLookupCombo1->ShowButton = ShowButton->Checked;
    wwDBLookupCombo2->ShowButton = ShowButton->Checked;	
}
//---------------------------------------------------------------------------
void __fastcall TLookupForm::QuickenStyle1Click(TObject *Sender)
{
   wwDBLookupCombo1->ShowMatchText = ((TCheckBox *)Sender)->Checked;
   wwDBLookupCombo2->ShowMatchText = ((TCheckBox *)Sender)->Checked;
}
//---------------------------------------------------------------------------
void __fastcall TLookupForm::QuickenStyle2Click(TObject *Sender)
{
   wwDBLookupComboDlg1->ShowMatchText = ((TCheckBox *)Sender)->Checked;
}
//---------------------------------------------------------------------------
