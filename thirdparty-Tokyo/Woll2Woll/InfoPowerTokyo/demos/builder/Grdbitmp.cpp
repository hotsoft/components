//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "Grdbitmp.h"
//---------------------------------------------------------------------------
#pragma link "vcl.wwdbgrid"
#pragma link "vcl.wwdbigrd"
#pragma link "vcl.wwdbcomb"
#pragma link "vcl.wwdotdot"
#pragma link "vcl.wwdbedit"
#pragma link "vcl.wwdbspin"
#pragma link "vcl.wwDBNavigator"
#pragma link "vcl.wwriched"
#pragma link "vcl.wwSpeedButton"
#pragma link "vcl.wwclearpanel"
#pragma resource "*.dfm"
TBitmapForm *BitmapForm;
//---------------------------------------------------------------------------
__fastcall TBitmapForm::TBitmapForm(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
// Allows the user to cycle through the available bitmaps in the grid.
// The three choices are V (Visa), A (American Express), and
// M (MasterCard).  The if statements check which Card the record
// contains and changes it to another card.
void __fastcall TBitmapForm::ToggleBitmaps()
{
   String PayMethod;

   InvoiceTable->Edit();
   PayMethod = InvoiceTablePaymentMethod->Text;
   if ((PayMethod.Length()==0) || (PayMethod=="-1")) PayMethod = "";

   if (PayMethod == "") PayMethod = "0";
   else if (PayMethod == "0") PayMethod = "1";
   else if (PayMethod == "1") PayMethod = "2";
   else if (PayMethod == "2") PayMethod = "-1";

//   if (PayMethod=="") InvoiceTablePaymentMethod->Clear();
//   else
   InvoiceTablePaymentMethod->AsString = PayMethod;
}
//---------------------------------------------------------------------------
/* Calculate the FullName and FullAddress fields. */
void __fastcall TBitmapForm::CustomerTableCalcFields(TDataSet *DataSet)
{
   CustomerTable->FieldByName("Full Name")->AsString=
	  CustomerTable->FieldByName("First Name")->AsString +
	  CustomerTable->FieldByName("Last Name")->AsString;
   CustomerTable->FieldByName("Full Address")->AsString =
	  CustomerTable->FieldByName("City")->AsString + ", " +
	  CustomerTable->FieldByName("State")->AsString + "  " +
	  CustomerTable->FieldByName("Zip")->AsString;
}
//---------------------------------------------------------------------------
/* If the customer owes money then paint the record red.  It checks the value of the
 "Balance Due" field and if it is greater than zero then it will change the attributes
 for every column except the one that has focus. */
void __fastcall TBitmapForm::InvoiceGridCalcCellColors(TObject *Sender,
	TField *Field, TGridDrawState State, bool Highlight, TFont *AFont,
	TBrush *ABrush)
{
   if ((!Highlight) && (InvoiceTable->FieldByName("Balance Due")->AsInteger > 0))
   {
      ABrush->Color = clRed;  //Change the background color to red
      AFont->Color = clWhite; //Change the pen color to white
   }
}
//---------------------------------------------------------------------------
/* For the mapped combobox.  If the value changes then this procedure tells the
 grid to repaint so that the bitmap can reflect the changed value. */
void __fastcall TBitmapForm::InvoiceDSDataChange(TObject *Sender, TField *Field)
{
   if ((Field != NULL) &&
      ((Field->FieldName == "Payment Method") || (Field->FieldName == "Balance Due")))
   {
      InvoiceGrid->InvalidateCurrentRow();
   }
}
//---------------------------------------------------------------------------
/* Set Specific title attributes for the Invoice Grid */
/* Cycle through credit card bitmaps when dbl-clicked */
void __fastcall TBitmapForm::InvoiceGridDblClick(TObject *Sender)
{
   if (InvoiceGrid->GetActiveField()->FieldName == "PayBitmap") ToggleBitmaps();
}
//---------------------------------------------------------------------------
void __fastcall TBitmapForm::InvoiceGridKeyDown(TObject *Sender, WORD &Key,
	TShiftState Shift)
{
   if (InvoiceGrid->GetActiveField()->FieldName == "PayImageIndex")
      if (Key==VK_SPACE) ToggleBitmaps();	
}
//---------------------------------------------------------------------------
void __fastcall TBitmapForm::PayMethComboCloseUp(TwwDBComboBox *Sender,
	bool Select)
{
  if (Select) Sender->UpdateRecord();
}

//---------------------------------------------------------------------------
void __fastcall TBitmapForm::InvoiceGridUpdateFooter(TObject *Sender)
{
  double  balanceDue, totalInvoice;
  TBookmark curBookmark;

  if (InUpdateFooter) return;

  InUpdateFooter = true;
  try {
	InvoiceTable->DisableControls();
	curBookmark = InvoiceTable->Bookmark;
	balanceDue = 0.0;
	totalInvoice = 0.0;
	while (!InvoiceTable->Eof)
	{
	  balanceDue= balanceDue + InvoiceTable->FieldByName("Balance Due")->AsCurrency;
	  totalInvoice= totalInvoice + InvoiceTable->FieldByName("Total Invoice")->AsCurrency;
	  InvoiceTable->Next();
	}
	InvoiceTable->Bookmark = curBookmark;
	InvoiceTable->EnableControls();
	InvoiceGrid->ColumnByName("Balance Due")->FooterValue=
	  FloatToStrF(balanceDue, ffCurrency, 10, 2);
	InvoiceGrid->ColumnByName("Total Invoice")->FooterValue=
	  FloatToStrF(totalInvoice, ffCurrency, 10, 2);
	InUpdateFooter = false;
  } catch (...) {
	InUpdateFooter = false;
  }
}
//---------------------------------------------------------------------------
void __fastcall TBitmapForm::InvoiceTableCalcFields(TDataSet *DataSet)
{
  DataSet->FieldByName("PayImageIndex")->AsInteger=
	 DataSet->FieldByName("Payment Method")->AsInteger;

}
//---------------------------------------------------------------------------

void __fastcall TBitmapForm::InvoiceGridCalcTitleAttributes(TObject *Sender, UnicodeString AFieldName,
          TFont *AFont, TBrush *ABrush, TAlignment &ATitleAlignment)

{
   if ((AFieldName == "Total Invoice") || (AFieldName == "Balance Due"))
      ATitleAlignment = taRightJustify;

}
//---------------------------------------------------------------------------

