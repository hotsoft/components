//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "Filtdlg.h"
//---------------------------------------------------------------------------
#pragma link "vcl.wwdbgrid"
#pragma link "vcl.wwdbigrd"
#pragma link "vcl.wwriched"
#pragma link "vcl.wwfltdlg"
#pragma link "vcl.wwDialog"
#pragma link "vcl.wwfltdlg"
#pragma resource "*.dfm"
TFilterDialogForm *FilterDialogForm;
//---------------------------------------------------------------------------
__fastcall TFilterDialogForm::TFilterDialogForm(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TFilterDialogForm::BitBtn1Click(TObject *Sender)
{
   switch (TabbedNotebook1->PageIndex) {
   case 0: wwFilterDialog1->Execute(); break;
   case 1: wwFilterDialog2->Execute(); break;
   case 2: wwFilterDialog3->Execute(); break;
   /* Performance Tip: Executing a multi-table query when selecting all records
      can be quite time-consuming.  Therefore you may wish to
      point your datasource to a TTable when showing all records, and then
      switch to a TQuery when you want to select a subset. */
   case 3: wwFilterDialog1->Execute(); break;
   default: break;
   }
}
//---------------------------------------------------------------------------
void __fastcall TFilterDialogForm::SearchTypeCheckboxClick(TObject *Sender)
{
   if (((TCheckBox *)Sender)->Checked)
   {
      wwFilterDialog1->Options = TwwFilterDialogOptions(wwFilterDialog1->Options)
       << fdShowValueRangeTab;
      wwFilterDialog2->Options = TwwFilterDialogOptions(wwFilterDialog2->Options)
       << fdShowValueRangeTab;
      wwFilterDialog3->Options = TwwFilterDialogOptions(wwFilterDialog3->Options)
       << fdShowValueRangeTab;
   }
   else {
      wwFilterDialog1->Options = TwwFilterDialogOptions(wwFilterDialog1->Options)
       >> fdShowValueRangeTab;
      wwFilterDialog2->Options = TwwFilterDialogOptions(wwFilterDialog2->Options)
       >> fdShowValueRangeTab;
      wwFilterDialog3->Options = TwwFilterDialogOptions(wwFilterDialog3->Options)
       >> fdShowValueRangeTab;
   }	
}
//---------------------------------------------------------------------------
void __fastcall TFilterDialogForm::ShowFieldOrderCheckboxClick(TObject *Sender)
{
   if (((TCheckBox *)Sender)->Checked)
   {
      wwFilterDialog1->Options = TwwFilterDialogOptions(wwFilterDialog1->Options)
       << fdShowFieldOrder;
      wwFilterDialog2->Options = TwwFilterDialogOptions(wwFilterDialog2->Options)
       << fdShowFieldOrder;
      wwFilterDialog3->Options = TwwFilterDialogOptions(wwFilterDialog3->Options)
       << fdShowFieldOrder;
   }
   else {
      wwFilterDialog1->Options = TwwFilterDialogOptions(wwFilterDialog1->Options)
       >> fdShowFieldOrder;
      wwFilterDialog2->Options = TwwFilterDialogOptions(wwFilterDialog2->Options)
       >> fdShowFieldOrder;
      wwFilterDialog3->Options = TwwFilterDialogOptions(wwFilterDialog3->Options)
       >> fdShowFieldOrder;
   }
	
}
//---------------------------------------------------------------------------
void __fastcall TFilterDialogForm::ViewSummaryCheckboxClick(TObject *Sender)
{
   if (((TCheckBox *)Sender)->Checked)
   {
      wwFilterDialog1->Options = TwwFilterDialogOptions(wwFilterDialog1->Options)
       << fdShowViewSummary;
      wwFilterDialog2->Options = TwwFilterDialogOptions(wwFilterDialog2->Options)
       << fdShowViewSummary;
      wwFilterDialog3->Options = TwwFilterDialogOptions(wwFilterDialog3->Options)
       << fdShowViewSummary;
   }
   else {
      wwFilterDialog1->Options = TwwFilterDialogOptions(wwFilterDialog1->Options)
       >> fdShowViewSummary;
      wwFilterDialog2->Options = TwwFilterDialogOptions(wwFilterDialog2->Options)
       >> fdShowViewSummary;
      wwFilterDialog3->Options = TwwFilterDialogOptions(wwFilterDialog3->Options)
       >> fdShowViewSummary;
   }
	
}
//---------------------------------------------------------------------------
void __fastcall TFilterDialogForm::CheckBox1Click(TObject *Sender)
{
   if (((TCheckBox *)Sender)->Checked)
   {
      wwFilterDialog1->Options = TwwFilterDialogOptions(wwFilterDialog1->Options)
       << fdShowOKCancel;
      wwFilterDialog2->Options = TwwFilterDialogOptions(wwFilterDialog2->Options)
       << fdShowOKCancel;
      wwFilterDialog3->Options = TwwFilterDialogOptions(wwFilterDialog3->Options)
       << fdShowOKCancel;
   }
   else {
      wwFilterDialog1->Options = TwwFilterDialogOptions(wwFilterDialog1->Options)
       >> fdShowOKCancel;
      wwFilterDialog2->Options = TwwFilterDialogOptions(wwFilterDialog2->Options)
       >> fdShowOKCancel;
      wwFilterDialog3->Options = TwwFilterDialogOptions(wwFilterDialog3->Options)
       >> fdShowOKCancel;
   }

}
//---------------------------------------------------------------------------
void __fastcall TFilterDialogForm::wwDBGrid3CalcCellColors(TObject *Sender, TField *Field,
	TGridDrawState State, bool Highlight, TFont *AFont, TBrush *ABrush)
{
  if ((Field->FieldName == "Balance Due") && (Field->AsFloat > 0)) AFont->Color = clRed;
}
//---------------------------------------------------------------------------
void __fastcall TFilterDialogForm::TabbedNotebook1Change(TObject *Sender, int NewTab,
	bool &AllowChange)
{
   switch (NewTab)  {
     case 1:  if (!Customer1Query->Active) {
                Screen->Cursor = crHourGlass;
                Customer1Query->Active = True;
                Screen->Cursor = crDefault;
              }
              break;
     case 2:  Screen->Cursor = crHourGlass;
			  //Customer2Query->Active = True;
			  Screen->Cursor = crDefault;
			  break;
	 default: break;
   }
}
//---------------------------------------------------------------------------
void __fastcall TFilterDialogForm::CheckBox2Click(TObject *Sender)
{
   if (((TCheckBox *)Sender)->Checked)
   {
      wwFilterDialog1->Options = TwwFilterDialogOptions(wwFilterDialog1->Options)
       << fdShowNonMatching;
      wwFilterDialog2->Options = TwwFilterDialogOptions(wwFilterDialog2->Options)
       << fdShowNonMatching;
      wwFilterDialog3->Options = TwwFilterDialogOptions(wwFilterDialog3->Options)
       << fdShowNonMatching;
   }
   else {
      wwFilterDialog1->Options = TwwFilterDialogOptions(wwFilterDialog1->Options)
       >> fdShowNonMatching;
      wwFilterDialog2->Options = TwwFilterDialogOptions(wwFilterDialog2->Options)
       >> fdShowNonMatching;
      wwFilterDialog3->Options = TwwFilterDialogOptions(wwFilterDialog3->Options)
       >> fdShowNonMatching;
   }
}
//---------------------------------------------------------------------------
