//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "Pictures.h"
//---------------------------------------------------------------------------
#pragma link "vcl.wwdbedit"
#pragma link "vcl.wwdbedit"
#pragma resource "*.dfm"

TPictureForm *PictureForm;
//---------------------------------------------------------------------------
__fastcall TPictureForm::TPictureForm(TComponent* Owner)
  : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TPictureForm::ResetButtonClick(TObject *Sender)
{
  int i;

  for (i=0;i<=ComponentCount - 1;i++)
     if ((dynamic_cast<TwwDBEdit *>(Components[i])) &&
        (((TwwDBEdit *)Components[i])->DataSource == NULL))
              ((TwwDBEdit *)Components[i])->Clear();
}
//---------------------------------------------------------------------
void __fastcall TPictureForm::FormShow(TObject *Sender)
{
  TwwCustomMaskEdit *MyPicture;
  if (ClientDataSet2->IndexFieldNames != "Mask")
	 ClientDataSet2->IndexFieldNames="Mask";

  TLocateOptions Opts;
  Opts.Clear();
  //Opts << loPartialKey;
  for (int i= 0;i<=ComponentCount - 1;i++)
  {
	MyPicture = dynamic_cast<TwwDBEdit *>(Components[i]);
	if (MyPicture){
	  if (ClientDataSet2->Locate("mask", MyPicture->Picture->PictureMask, Opts))
		MyPicture->Hint = ClientDataSet2->FieldByName("Desc")->AsString;
	}
  }
}
//---------------------------------------------------------------------
void __fastcall TPictureForm::EditCheckValue(TObject *Sender,
      Boolean PassesPictureTest)
{
  if (PassesPictureTest) ((TwwDBCustomEdit *)Sender)->Color = clWhite;
  else ((TwwDBCustomEdit *)Sender)->Color = clYellow;
}
//---------------------------------------------------------------------
void __fastcall TPictureForm::EditEnter(TObject *Sender)
{
   StatusBar1->SimpleText = "Picture: " + ((TwwCustomMaskEdit *)Sender)->Picture->PictureMask;
}
//---------------------------------------------------------------------
void __fastcall TPictureForm::EditExit(TObject *Sender)
{
   StatusBar1->SimpleText = "";
}

//---------------------------------------------------------------------
void __fastcall TPictureForm::AutoFillCheckboxClick(TObject *Sender)
{
   TwwDBEdit * MyPicture;
   for (int i=0;i<=ComponentCount-1;i++)
   {
      MyPicture = dynamic_cast<TwwDBEdit *>(Components[i]);
      if (MyPicture)
         if ((TabbedNotebook1->PageIndex==1) ^ (MyPicture->DataSource == NULL))  // { Control is on current tab page }
            MyPicture->Picture->AutoFill = ((TCheckBox *)Sender)->Checked;
   }
}

//---------------------------------------------------------------------
void __fastcall TPictureForm::ResetButtonEnter(TObject *Sender)
{
   StatusBar1->SimpleText = "Clear all the Edit Boxes of content";
}
//---------------------------------------------------------------------
