//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "Unit2.h"
#include "Unit1.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TForm2 *Form2;
//---------------------------------------------------------------------------
__fastcall TForm2::TForm2(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------

void __fastcall TForm2::ExpressionEKeyPress(TObject *Sender, char &Key)
{
  if (Key == 13)
  {
    ResultM->Text = VarToStr(Form1->fsScript1->Evaluate(ExpressionE->Text));
    ExpressionE->SelectAll();
  }
  else
  if (Key == 27)
    Close();
}
//---------------------------------------------------------------------------

void __fastcall TForm2::FormShow(TObject *Sender)
{
  ExpressionE->SelectAll();
  ResultM->Text = "";
}
//---------------------------------------------------------------------------
