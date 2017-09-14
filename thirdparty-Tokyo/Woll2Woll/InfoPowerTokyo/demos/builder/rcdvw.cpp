//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "rcdvw.h"
//---------------------------------------------------------------------------
#pragma link "vcl.wwdbgrid"
#pragma link "vcl.wwdbigrd"
#pragma link "vcl.wwdbcomb"
#pragma link "vcl.wwdotdot"
#pragma link "vcl.wwdbedit"
#pragma link "vcl.wwdblook"
#pragma link "vcl.wwriched"
#pragma link "vcl.wwrcdvw"
#pragma link "vcl.wwDialog"
#pragma resource "*.dfm"
TRecordViewDemoForm *RecordViewDemoForm;
//---------------------------------------------------------------------------
__fastcall TRecordViewDemoForm::TRecordViewDemoForm(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TRecordViewDemoForm::Exit1Click(TObject *Sender)
{
   wwRecordViewDialog1->RecordViewForm->Close();	
}
//---------------------------------------------------------------------------
void __fastcall TRecordViewDemoForm::Edit1Click(TObject *Sender)
{
   Cancel1->Enabled=
      ((wwRecordViewDialog1->DataSource->DataSet->State == dsEdit) ||
      (wwRecordViewDialog1->DataSource->DataSet->State == dsInsert));
   Post1->Enabled = Cancel1->Enabled;
}
//---------------------------------------------------------------------------
void __fastcall TRecordViewDemoForm::Insert1Click(TObject *Sender)
{
   wwRecordViewDialog1->DataSource->DataSet->Insert();
}
//---------------------------------------------------------------------------
void __fastcall TRecordViewDemoForm::Cancel1Click(TObject *Sender)
{
   wwRecordViewDialog1->DataSource->DataSet->Cancel();
}
//---------------------------------------------------------------------------
void __fastcall TRecordViewDemoForm::Post1Click(TObject *Sender)
{
   wwRecordViewDialog1->DataSource->DataSet->CheckBrowseMode();
}
//---------------------------------------------------------------------------
void __fastcall TRecordViewDemoForm::First2Click(TObject *Sender)
{
   wwRecordViewDialog1->DataSource->DataSet->First();
}
//---------------------------------------------------------------------------
void __fastcall TRecordViewDemoForm::Prior1Click(TObject *Sender)
{
   wwRecordViewDialog1->DataSource->DataSet->Prior();
}
//---------------------------------------------------------------------------
void __fastcall TRecordViewDemoForm::Next1Click(TObject *Sender)
{
   wwRecordViewDialog1->DataSource->DataSet->Next();
}
//---------------------------------------------------------------------------
void __fastcall TRecordViewDemoForm::Last1Click(TObject *Sender)
{
   wwRecordViewDialog1->DataSource->DataSet->Last();
}
//---------------------------------------------------------------------------
void __fastcall TRecordViewDemoForm::wwDBGrid1IButtonClick(TObject *Sender)
{
   if (RecordViewStyle->ItemIndex==0)
     wwRecordViewDialog1->Style = rvsHorizontal;
   else wwRecordViewDialog1->Style = rvsVertical;

   if (DialogStyle->ItemIndex==0)
     wwRecordViewDialog1->Options = (wwRecordViewDialog1->Options << rvoModalForm) >> rvoStayOnTopForm;
   else
     wwRecordViewDialog1->Options = (wwRecordViewDialog1->Options >> rvoModalForm) << rvoStayOnTopForm;

   if (EmbedControls->Checked)
     wwRecordViewDialog1->Options= wwRecordViewDialog1->Options << rvoUseCustomControls;
   else
     wwRecordViewDialog1->Options= wwRecordViewDialog1->Options >> rvoUseCustomControls;

   if (CustomMainMenu->Checked)
     wwRecordViewDialog1->Menu = RecordViewMenu;
   else wwRecordViewDialog1->Menu = NULL;

   if (ShowNavigator->Checked)
     wwRecordViewDialog1->Options = wwRecordViewDialog1->Options >> rvoHideNavigator;
   else
     wwRecordViewDialog1->Options = wwRecordViewDialog1->Options << rvoHideNavigator;

   if (ShowOKCancel->Checked)
     wwRecordViewDialog1->OKCancelOptions= wwRecordViewDialog1->OKCancelOptions << rvokShowOKCancel;
   else
     wwRecordViewDialog1->OKCancelOptions= wwRecordViewDialog1->OKCancelOptions >> rvokShowOKCancel;

   // Leave grid button depressed for modal dialog until dialog closes
   if (DialogStyle->ItemIndex==0){
      ((TSpeedButton *)Sender)->GroupIndex = -1;
      ((TSpeedButton *)Sender)->Down= true;
   }

   wwDBGrid1->FlushChanges(); // Save any changes made to the grid to the tfield buffers
   wwRecordViewDialog1->Execute();

   // Raise grid button
   if (DialogStyle->ItemIndex==0){
      ((TSpeedButton *)Sender)->GroupIndex= 0;
      ((TSpeedButton *)Sender)->Down= false;
   }
}
//---------------------------------------------------------------------------
