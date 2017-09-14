//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "DataInspectorU.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "vcl.wwclearpanel"
#pragma link "vcl.wwDataInspector"
#pragma link "vcl.wwdbedit"
#pragma link "vcl.wwDBNavigator"
#pragma link "vcl.wwdotdot"
#pragma link "vcl.wwintl"
#pragma link "vcl.wwriched"
#pragma link "vcl.wwSpeedButton"
#pragma resource "*.dfm"
TDataInspectorDemo *DataInspectorDemo;
//---------------------------------------------------------------------------
__fastcall TDataInspectorDemo::TDataInspectorDemo(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TDataInspectorDemo::LabelLineStyleChanged(
      TwwDataInspector *Sender, TwwInspectorItem *Item,
      UnicodeString NewValue)
{
   wwDataInspector1->LineStyleCaption=
      TwwDataInspectorLineStyle(atoi((const char *)NewValue.c_str()));
   Sender->InvalidateRow(Sender->GetRowByItem(Item->ParentItem)); // Invalidate parent item
}
//---------------------------------------------------------------------------
void __fastcall TDataInspectorDemo::DataLineStyleChanged(
      TwwDataInspector *Sender, TwwInspectorItem *Item,
      UnicodeString NewValue)
{
   wwDataInspector1->LineStyleData=
      TwwDataInspectorLineStyle(atoi((const char *)NewValue.c_str()));
   Sender->InvalidateRow(Sender->GetRowByItem(Item->ParentItem)); // Invalidate parent item
}
//---------------------------------------------------------------------------
void __fastcall TDataInspectorDemo::OptionsInspectorItems0ItemChanged(
      TwwDataInspector *Sender, TwwInspectorItem *Item,
      UnicodeString NewValue)
{
   wwDataInspector1->Invalidate();
}
//---------------------------------------------------------------------------
void __fastcall TDataInspectorDemo::wwDataInspector1BeforePaint(
      TwwDataInspector *Sender)
{
/*   if (!OptionsInspector->GetItemByTagString("Bitmap")->Checked) return;

   for (int i=0; i<=(Sender->Width / Image1->Picture->Width); i++)
	 for (int j=0; j<=(Sender->Height / Image1->Picture->Height); j++)
		Sender->Canvas->Draw(i*Image1->Picture->Width,
		   j*Image1->Picture->Height,Image1->Picture->Bitmap);
*/
}
//---------------------------------------------------------------------------
void __fastcall TDataInspectorDemo::OptionsInspectorCalcDataPaintText(
      TwwDataInspector *Sender, TwwInspectorItem *Item,
      UnicodeString &PaintText)
{
  TwwInspectorItem * CurItem;
  // Paint parent nodes based on child node

  if ((Item->Caption == "Line Style") ||
      (Item->Caption == "Custom Glyphs"))
  {
      CurItem = Item->GetFirstChild(true, false);
      PaintText= "";
      while (CurItem) {
         if (PaintText!="") PaintText= PaintText + ",";
         PaintText= PaintText + CurItem->DisplayText;
         CurItem = CurItem->GetNextSibling(true);
      }
      PaintText= "[" + PaintText + "]";
  }
}
//---------------------------------------------------------------------------
void __fastcall TDataInspectorDemo::wwTable1CalcFields(TDataSet *DataSet)
{
  TDataSet * ds = DataSet;
  ds->FieldByName("Name")->AsString= ds->FieldByName("FirstName")->AsString+" "+
                          ds->FieldByName("MiddleName")->AsString+" "+
                          ds->FieldByName("LastName")->AsString;
  ds->FieldByName("Address")->AsString=ds->FieldByName("Street")->AsString+ "\r\n" +
                         ds->FieldByName("City")->AsString+", "+
                         ds->FieldByName("State")->AsString+", "+
                         ds->FieldByName("Zip")->AsString+ "\r\n";
                         ds->FieldByName("Country")->AsString;
  ds->FieldByName("Salary")->AsString= "$"+ds->FieldByName("PayRate")->AsString+" "+
                          ds->FieldByName("PayType")->AsString;
  ds->FieldByName("Schedule")->AsString= ds->FieldByName("WorkingHourStartTime")->AsString+"->"+
                          ds->FieldByName("WorkingHourEndTime")->AsString;

}
//---------------------------------------------------------------------------
void __fastcall TDataInspectorDemo::HideShowDataChanged(
      TwwDataInspector *Sender, TwwInspectorItem *Item,
      UnicodeString NewValue)
{
  bool val = (NewValue == "True");
  wwDataInspector1->GetItemByCaption(Item->TagString)->Visible = val;
  if (Item->TagString == "Employment Data")
  {
     Sender->GetItemByCaption("Show Salary")->Visible = val;
     Sender->GetItemByCaption("Show Schedule")->Visible = val;
  }
}
//---------------------------------------------------------------------------
void __fastcall TDataInspectorDemo::Button2Click(TObject *Sender)
{
   TwwInspectorItem * curItem = wwDataInspector1->GetFirstChild(true);
   while (curItem) {
      curItem->Expanded = true;
      curItem = curItem->GetNext(true, false);
   }
}
//---------------------------------------------------------------------------

void __fastcall TDataInspectorDemo::Button1Click(TObject *Sender)
{
   TwwInspectorItem * curItem = wwDataInspector1->GetFirstChild(true);
   while (curItem) {
      curItem->Expanded = false;
      curItem = curItem->GetNext(true, false);
   }
}
//---------------------------------------------------------------------------

