//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "grdbttn.h"
//---------------------------------------------------------------------------
#pragma link "vcl.wwdbgrid"
#pragma link "vcl.wwdbigrd"
#pragma link "vcl.wwriched"
#pragma link "vcl.wwrcdvw"
#pragma link "vcl.wwDialog"
#pragma resource "*.dfm"
TBtnGridForm *BtnGridForm;
//---------------------------------------------------------------------------
__fastcall TBtnGridForm::TBtnGridForm(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TBtnGridForm::wwDBGrid1IButtonClick(TObject *Sender)
{
wwRecordViewDialog1->Execute();
}
//---------------------------------------------------------------------------
void __fastcall TBtnGridForm::wwDBGrid1CalcTitleImage(TObject *Sender,
	  TField *Field, TwwTitleImageAttributes &TitleImageAttributes)
{
	if (Field->FieldName==ClientDataSet1->IndexFieldNames)
	  TitleImageAttributes.ImageIndex= 4;
	else
	  TitleImageAttributes.ImageIndex= -1;
}
//---------------------------------------------------------------------------
void __fastcall TBtnGridForm::wwDBGrid1TitleButtonClick(TObject *Sender, UnicodeString AFieldName)

{
   wwDBGrid1->SetOrder(AFieldName, false);
}
//---------------------------------------------------------------------------

