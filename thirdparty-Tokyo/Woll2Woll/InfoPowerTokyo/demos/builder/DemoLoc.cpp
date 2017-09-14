//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "DemoLoc.h"
//---------------------------------------------------------------------------
#pragma link "vcl.wwlocate"
#pragma link "vcl.wwDialog"
#pragma resource "*.dfm"
TLocate *Locate;
//---------------------------------------------------------------------------
__fastcall TLocate::TLocate(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TLocate::FindFieldValue1Click(TObject *Sender)
{
   //   { Change default search field to be the active field }
   /*
   if (ActiveControl->InheritsFrom(__classid(TDBEdit))){
	  if (wwLocateDialog1->SearchField != ((TDBEdit *)ActiveControl)->DataField)
	  {
	   wwLocateDialog1->FieldValue = "";
	   wwLocateDialog1->SearchField = ((TDBEdit *)ActiveControl)->DataField;
	  }
   }
   */
   wwLocateDialog1->Execute();
}
//---------------------------------------------------------------------------
void __fastcall TLocate::Exit1Click(TObject *Sender)
{
   Close();
}
//---------------------------------------------------------------------------
void __fastcall TLocate::FindNext1Click(TObject *Sender)
{
   //{ If first time then change default search field to be the active field }
   if (wwLocateDialog1->FieldValue=="")  {
      if (ActiveControl->InheritsFrom(__classid(TDBEdit)))
         wwLocateDialog1->SearchField = ((TDBEdit *)ActiveControl)->DataField;
   }
   wwLocateDialog1->FindNext();
}
//---------------------------------------------------------------------------
void __fastcall TLocate::FormShow(TObject *Sender)
{
   Width = (Width * PixelsPerInch) / 96;
   Height = (Height * PixelsPerInch) / 96;
}
//---------------------------------------------------------------------------
