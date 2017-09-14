//---------------------------------------------------------------------------
#include <vcl.h>
#include <stdlib.h>
#pragma hdrstop

#include "multi.h"
//---------------------------------------------------------------------------
#pragma link "vcl.wwdbgrid"
#pragma link "vcl.wwdbigrd"
#pragma link "vcl.wwriched"
#pragma resource "*.dfm"
TMultiSelectForm *MultiSelectForm;
//---------------------------------------------------------------------------
__fastcall TMultiSelectForm::TMultiSelectForm(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TMultiSelectForm::PopulateTable()
{
   int i, computeCode;

   wwDBGrid1->SelectedList->Clear();  //{ Clear selected list }

   Randomize();
   ClientDataSet1->DisableControls();
   for (i=1;i<=100;i++)
   {
	  computeCode = random(32767);
	  computeCode = i * 100;
	  //if (!ClientDataSet1->Locate("Code", inttostr(computeCode),[])
	  {
		 ClientDataSet1->Insert();
		 ClientDataSet1->FieldByName("Code")->AsString = IntToStr(computeCode);
		 ClientDataSet1->FieldByName("Description")->AsString = "Description for " + IntToStr(computeCode);
		 ClientDataSet1->CheckBrowseMode();
	  }
   }
   ClientDataSet1->EnableControls();
   ClientDataSet1->First();


}
//---------------------------------------------------------------------------
void __fastcall TMultiSelectForm::FormShow(TObject *Sender)
{
   PopulateTable();
}
//---------------------------------------------------------------------------
void __fastcall TMultiSelectForm::wwDBGrid1CalcCellColors(TObject *Sender,
	TField *Field, TGridDrawState State, bool Highlight, TFont *AFont,
	TBrush *ABrush)
{
   if (Field->FieldName=="Selected") ABrush->Color= clBtnFace;
   else if ((!Highlight) && (((TwwDBGrid *)Sender)->IsSelected())) {
      ABrush->Color = clYellow;
      AFont->Color = clBlack;
   }
}
//---------------------------------------------------------------------------
void __fastcall TMultiSelectForm::Button2Click(TObject *Sender)
{
   wwDBGrid1->UnselectAll();
}
//---------------------------------------------------------------------------
void __fastcall TMultiSelectForm::Button1Click(TObject *Sender)
{
   wwDBGrid1->SelectAll();
}
//---------------------------------------------------------------------------
void __fastcall TMultiSelectForm::BitBtn2Click(TObject *Sender)
{
   Close();
}
//---------------------------------------------------------------------------
void __fastcall TMultiSelectForm::DeleteButtonClick(TObject *Sender)
{
   TDataSet * ds= wwDBGrid1->DataSource->DataSet;
   ds->DisableControls();   //{ Disable controls to improve performance }
   for (int i = 0; i<wwDBGrid1->SelectedList->Count;i++)
   {
	  ds->GotoBookmark(wwDBGrid1->SelectedList->Items[i]);
	  ds->FreeBookmark(wwDBGrid1->SelectedList->Items[i]);
      ds->Delete();          // { Delete Record }
   }
   wwDBGrid1->SelectedList->Clear();  //{ Clear selected record list since they are all deleted}
   ds->EnableControls();
}
//---------------------------------------------------------------------------
void __fastcall TMultiSelectForm::CheckBox3Click(TObject *Sender)
{
      wwDBGrid1->DataSource->DataSet->FieldByName("Selected")->Visible
         = ((TCheckBox *)Sender)->Checked;
      wwDBGrid1->SizeLastColumn();
}
//---------------------------------------------------------------------------
void __fastcall TMultiSelectForm::CheckBox1Click(TObject *Sender)
{
    if (((TCheckBox *)Sender)->Checked)
       wwDBGrid1->MultiSelectOptions = wwDBGrid1->MultiSelectOptions << msoShiftSelect;
    else wwDBGrid1->MultiSelectOptions = wwDBGrid1->MultiSelectOptions >> msoShiftSelect;
}
//---------------------------------------------------------------------------
void __fastcall TMultiSelectForm::CheckBox2Click(TObject *Sender)
{
    if (((TCheckBox *)Sender)->Checked)
       wwDBGrid1->MultiSelectOptions = wwDBGrid1->MultiSelectOptions << msoAutoUnselect;
    else wwDBGrid1->MultiSelectOptions = wwDBGrid1->MultiSelectOptions >> msoAutoUnselect;
}
//---------------------------------------------------------------------------
