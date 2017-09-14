//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "GridMasterDetail.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "vcl.wwcheckbox"
#pragma link "vcl.wwdbgrid"
#pragma link "vcl.wwdbigrd"
#pragma resource "*.dfm"
TMasterDetailGridForm *MasterDetailGridForm;
//---------------------------------------------------------------------------
__fastcall TMasterDetailGridForm::TMasterDetailGridForm(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TMasterDetailGridForm::InvoiceGridUpdateFooter(
	  TObject *Sender)
{
  double  ItemsTotal, totalinvoice;
  TBookmark curBookmark;

  if (InUpdateFooter) return;

  InUpdateFooter = true;
  ItemsTotal= 0.0; //balanceDue:=0.0;
  try {
	InvoiceClientDataSet->DisableControls();
	curBookmark = InvoiceClientDataSet->Bookmark;
	while (!InvoiceClientDataSet->Eof)
	{
	  ItemsTotal= ItemsTotal + InvoiceClientDataSet->FieldByName("ItemsTotal")->AsCurrency;
	  InvoiceClientDataSet->Next();
	}
	InvoiceClientDataSet->Bookmark = curBookmark;
	InvoiceClientDataSet->EnableControls();
	InvoiceGrid->ColumnByName("ItemsTotal")->FooterValue=
	  FloatToStrF(ItemsTotal, ffCurrency, 10, 2);
	InUpdateFooter = false;
  } catch (...) {
	InUpdateFooter = false;
  }
}
//---------------------------------------------------------------------------
void __fastcall TMasterDetailGridForm::CustomerGridCalcTitleImage(
      TObject *Sender, TField *Field,
      TwwTitleImageAttributes &TitleImageAttributes)
{
   if (Field->FieldName=="Orders")
      TitleImageAttributes.ImageIndex=2;
}
//---------------------------------------------------------------------------
void __fastcall TMasterDetailGridForm::InvoiceGridBeforePaint(
      TObject *Sender)
{
   // Paint to detail grids the same bitmap as the master grid sp
   // that alternating row color of master grid is respected
   TwwDBGrid * grid = (TwwDBGrid *)Sender;
   if (CustomerGrid->IsActiveRowAlternatingColor())
   {
      grid->Canvas->CopyRect(ClientRect,
         CustomerGrid->PaintOptions->AlternatingColorBitmap->Canvas,
         grid->ClientRect);
   }
   else {
      grid->Canvas->CopyRect(ClientRect,
         CustomerGrid->PaintOptions->OrigBitmap->Canvas,
         grid->ClientRect);
   }
}
//---------------------------------------------------------------------------
