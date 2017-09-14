//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "rcdpnldemo2.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "vcl.wwDataInspector"
#pragma link "vcl.wwdblook"
#pragma link "vcl.wwrcdpnl"
#pragma link "vcl.wwriched"
#pragma resource "*.dfm"
TRecordViewDemoForm2 *RecordViewDemoForm2;
//---------------------------------------------------------------------------
__fastcall TRecordViewDemoForm2::TRecordViewDemoForm2(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------

void __fastcall TRecordViewDemoForm2::FocusStyleChanged(
      TwwDataInspector *Sender, TwwInspectorItem *Item,
	  UnicodeString NewValue)
{
   // Convert integer string to TwwEditFocusStyle
   wwRecordViewPanel1->EditFrame->FocusStyle =
      TwwEditFocusStyle(atoi((const char *)NewValue.c_str()));
   wwRecordViewPanel1->RecreateControls();
}
//---------------------------------------------------------------------------



void __fastcall TRecordViewDemoForm2::BorderChanged(
      TwwDataInspector *Sender, TwwInspectorItem *Item,
	  UnicodeString NewValue)
{
   TwwEditFrameEnabledType NewBorderStyle;

   if (Item->Caption=="Left") NewBorderStyle = efLeftBorder;
   else if (Item->Caption=="Right") NewBorderStyle = efRightBorder;
   else if (Item->Caption=="Top") NewBorderStyle = efTopBorder;
   else if (Item->Caption=="Bottom") NewBorderStyle = efBottomBorder;

   TwwRecordViewPanel * rp = wwRecordViewPanel1;
   if (Item->ParentItem->Caption == "Non-focus Borders")
   {
      if (Item->Checked)
        rp->EditFrame->NonFocusBorders << NewBorderStyle;
      else
        rp->EditFrame->NonFocusBorders >> NewBorderStyle;
   }
   else {
      if (Item->Checked)
        rp->EditFrame->FocusBorders << NewBorderStyle;
      else
        rp->EditFrame->FocusBorders >> NewBorderStyle;
   }
   rp->RecreateControls();
   Sender->InvalidateRow(Sender->GetRowByItem(Item->ParentItem)); // Invalidate parent item
}
//---------------------------------------------------------------------------


void __fastcall TRecordViewDemoForm2::LabelsBeneathControlChanged(
      TwwDataInspector *Sender, TwwInspectorItem *Item,
	  UnicodeString NewValue)
{
   if (Item->Checked)
      wwRecordViewPanel1->Options =
      wwRecordViewPanel1->Options << rvopLabelsBeneathControl;
   else
      wwRecordViewPanel1->Options =
      wwRecordViewPanel1->Options >> rvopLabelsBeneathControl;
   wwRecordViewPanel1->RecreateControls();

}
//---------------------------------------------------------------------------

void __fastcall TRecordViewDemoForm2::LayoutChanged(
      TwwDataInspector *Sender, TwwInspectorItem *Item,
	  UnicodeString NewValue)
{
    if (NewValue=="1") wwRecordViewPanel1->Style= rvpsHorizontal;
    else wwRecordViewPanel1->Style= rvpsVertical;

    Sender->GetItemByCaption("Labels Beneath Edit Controls")->Visible=
       (NewValue=="1")
;
}
//---------------------------------------------------------------------------

void __fastcall TRecordViewDemoForm2::OptionsCalcDataPaintText(TwwDataInspector *Sender,
          TwwInspectorItem *Item, UnicodeString &PaintText)
{
  TwwInspectorItem * CurItem;
  // Paint parent nodes based on child node

  if ((Item->Caption == "Non-focus Borders") ||
      (Item->Caption == "Focus Borders"))
  {
      CurItem = Item->GetFirstChild(true, false);
      PaintText= "";
      while (CurItem) {
         if (CurItem->Checked)
         {
            if (PaintText!="") PaintText= PaintText + ",";
            PaintText= PaintText + CurItem->Caption;
         }
         CurItem = CurItem->GetNextSibling(true);
      }
      PaintText= "[" + PaintText + "]";
  }
}
//---------------------------------------------------------------------------

void __fastcall TRecordViewDemoForm2::OptionsItems0Items0ItemChanged(TwwDataInspector *Sender,
          TwwInspectorItem *Item, UnicodeString NewValue)
{
   wwRecordViewPanel1->EditFrame->Transparent = (NewValue == "True");
   wwRecordViewPanel1->RecreateControls();

}
//---------------------------------------------------------------------------

void __fastcall TRecordViewDemoForm2::OptionsItems0Items1ItemChanged(TwwDataInspector *Sender,
          TwwInspectorItem *Item, UnicodeString NewValue)
{
   // Convert integer string to TwwEditFocusStyle
   wwRecordViewPanel1->EditFrame->NonFocusStyle =
	  TwwEditFocusStyle(atoi((const char *)NewValue.c_str()));
   wwRecordViewPanel1->RecreateControls();
}
//---------------------------------------------------------------------------

void __fastcall TRecordViewDemoForm2::OptionsItems0ItemChanged(TwwDataInspector *Sender,
          TwwInspectorItem *Item, UnicodeString NewValue)
{
   int i;
   TwwEditFrame * FrameEffects;
   bool FrameEnabled;

   FrameEnabled= (NewValue == "True");
   wwRecordViewPanel1->EditFrame->Enabled = FrameEnabled;
   wwRecordViewPanel1->RecreateControls();

   for (i=0; i<=Item->Items->Count-1; i++)
	  Item->Items->Items[i]->Visible = FrameEnabled;

   for (i=0; i<=wwRecordViewPanel1->ControlCount-1; i++)
   {
	  TCustomEdit * CurrentControl = dynamic_cast<TCustomEdit *>(wwRecordViewPanel1->Controls[i]);
	  //FrameEffects = TwwEditFrame::Get(__classid(TwwEditFrame), wwRecordViewPanel1->Controls[i]);
	  FrameEffects = TwwEditFrame::Get(wwRecordViewPanel1->Controls[i]);
	  if ((FrameEffects) && (CurrentControl))
	  {
		 if (FrameEnabled) // Custom framing needs borderstyle as bsNone
		 {
			((TEdit *)CurrentControl)->BorderStyle= bsNone;
		 }
		 else {
			((TEdit *)CurrentControl)->BorderStyle= bsSingle;
		 }
	  }
   }
   wwRecordViewPanel1->Invalidate();

}
//---------------------------------------------------------------------------


