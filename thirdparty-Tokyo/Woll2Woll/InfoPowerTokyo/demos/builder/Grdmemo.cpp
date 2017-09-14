//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "Grdmemo.h"
//---------------------------------------------------------------------------
#pragma link "vcl.wwdbgrid"
#pragma link "vcl.wwdbigrd"
#pragma link "vcl.wwriched"
#pragma resource "*.dfm"
TGridMemoApp *GridMemoApp;
//---------------------------------------------------------------------------
__fastcall TGridMemoApp::TGridMemoApp(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TGridMemoApp::BitBtn2Click(TObject *Sender)
{
Close();
}
//---------------------------------------------------------------------------
void __fastcall TGridMemoApp::wwDBGrid1MemoOpen(TwwDBGrid *Grid,
	TwwMemoDialog *MemoDialog)
{
 MemoDialog->DlgLeft = 15;
}
//---------------------------------------------------------------------------
void __fastcall TGridMemoApp::wwDBGrid1CreateHintWindow(TObject *Sender, TwwGridHintWindow *HintWindow,
		  TField *AField, TRect &R, bool &WordWrap, int &MaxWidth,
		  int &MaxHeight, bool &DoDefault)
{
  WordWrap = True;
  TBlobField * MyBlobField = dynamic_cast<TBlobField *>(AField);

  if (MyBlobField)
	 MaxWidth = 100;
  MaxHeight = Screen->Height;
}
//---------------------------------------------------------------------------

