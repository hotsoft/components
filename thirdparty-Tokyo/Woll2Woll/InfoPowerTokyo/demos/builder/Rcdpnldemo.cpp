//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "Rcdpnldemo.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "vcl.wwdbcomb"
#pragma link "vcl.wwdbedit"
#pragma link "vcl.wwDBNavigator"
#pragma link "vcl.wwdotdot"
#pragma link "vcl.wwrcdpnl"
#pragma link "vcl.wwSpeedButton"
#pragma link "vcl.wwclearpanel"
#pragma resource "*.dfm"
TRecordPanelDemo *RecordPanelDemo;
//---------------------------------------------------------------------------
__fastcall TRecordPanelDemo::TRecordPanelDemo(TComponent* Owner)
    : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TRecordPanelDemo::FormShow(TObject *Sender)
{
//   OrigApplicationHint = Application->OnHint;
   Application->OnHint= FormChangeHint;
   Session->GetDatabaseNames(AliasComboBox->Items);
   AliasComboBox->ItemIndex= AliasComboBox->Items->IndexOf("InfoDemo5");
   Session->GetTableNames(AliasComboBox->Text, "", true, false, TableComboBox->Items);
   TableComboBox->ItemIndex= TableComboBox->Items->IndexOf("IP4CUST.DB");

}
//---------------------------------------------------------------------------

void __fastcall TRecordPanelDemo::FormClose(TObject *Sender,
      TCloseAction &Action)
{
//   Application->OnHint= OrigApplicationHint;
   Application->OnHint= NULL;

}
//---------------------------------------------------------------------------

void __fastcall TRecordPanelDemo::LayoutClick(TObject *Sender)
{
  if (((TRadioGroup *)Sender)->ItemIndex == 0)
     wwRecordViewPanel1->Style= rvpsVertical;
  else
     wwRecordViewPanel1->Style= rvpsHorizontal;

  ConsistentEditWidthCheckbox->Enabled = (wwRecordViewPanel1->Style == rvpsVertical);
}
//---------------------------------------------------------------------------


void __fastcall TRecordPanelDemo::ConsistentEditWidthCheckboxClick(
      TObject *Sender)
{
   if (((TCheckBox *)Sender)->Checked){
      Layout->ItemIndex= 0;
      wwRecordViewPanel1->Options=
        (wwRecordViewPanel1->Options << rvopConsistentEditWidth);
   }
   else
      wwRecordViewPanel1->Options= (wwRecordViewPanel1->Options >> rvopConsistentEditWidth);

}

void __fastcall TRecordPanelDemo::FormChangeHint(TObject *Sender)
{
   StatusBar1->Panels->Items[0]->Text = Application->Hint;

}

//---------------------------------------------------------------------------

void __fastcall TRecordPanelDemo::AliasComboBoxChange(TObject *Sender)
{
   Session->GetTableNames(AliasComboBox->Text, "",
      true, false, TableComboBox->Items);
   TableComboBox->Text= "";
   wwTable1->Active= false;
}
//---------------------------------------------------------------------------

void __fastcall TRecordPanelDemo::TableComboBoxChange(TObject *Sender)
{
  if (TableComboBox->DroppedDown==true) return;
  if (TableComboBox->Text=="") return;
  if (AliasComboBox->Text=="") return;

  wwRecordViewPanel1->Selected->Clear();
  wwTable1->Active= false;
  wwTable1->IndexName= "";
  wwTable1->TableName= TableComboBox->Text;
  wwTable1->DatabaseName= AliasComboBox->Text;
  wwTable1->Active= true;
}
//---------------------------------------------------------------------------

