//---------------------------------------------------------------------------
#include <vcl.h>
#include <math.h>
#pragma hdrstop

#include "Demo.h"

#include "gridctrl.h"
#include "combos.h"
#include "demoloc.h"
#include "dtpicker.h"
#include "filtdlg.h"
#include "grdbitmp.h"
#include "grdbttn.h"
#include "grdlook.h"
#include "grdmemo.h"
#include "isearch.h"
#include "lkdtl.h"
#include "multi.h"
#include "pictures.h"
#include "rcdvw.h"
#include "searchdemo.h"
#include "savefilt.h"
#include "monthcalu.h"
#include "navmany.h"
#include "navigatorcomb.h"
#include "rcdpnldemo2.h"
#include "datainspectoru.h"
#include "dbchecku.h"
#include "gridmasterdetail.h"
#include "gridexpand.h"

//---------------------------------------------------------------------------
#pragma link "vcl.wwriched"
#pragma link "vcl.wwintl"
#pragma resource "*.dfm"
TMainDemo *MainDemo;
//---------------------------------------------------------------------------
__fastcall TMainDemo::TMainDemo(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TMainDemo::Button2Click(TObject *Sender)
{
wwDBRichEdit1->Execute();
}
//---------------------------------------------------------------------------
void __fastcall TMainDemo::Button3Click(TObject *Sender)
{
  Screen->Cursor = crHourGlass;
  TForm *tempform = new TGridDemo(Application);
  Screen->Cursor = crDefault;
  tempform->ShowModal();
  tempform->Free();
}
//---------------------------------------------------------------------------
void __fastcall TMainDemo::Button5Click(TObject *Sender)
{
  Screen->Cursor = crHourGlass;
  TForm *tempform = new TGridMemoApp(Application);
  Screen->Cursor = crDefault;
  tempform->ShowModal();
  tempform->Free();
}
//---------------------------------------------------------------------------
void __fastcall TMainDemo::Button13Click(TObject *Sender)
{
  Screen->Cursor = crHourGlass;
  TForm *tempform = new TBitmapForm(Application);
  Screen->Cursor = crDefault;
  tempform->ShowModal();
  tempform->Free();
}
//---------------------------------------------------------------------------
void __fastcall TMainDemo::Button15Click(TObject *Sender)
{
  Screen->Cursor = crHourGlass;
  TForm *tempform = new TMultiSelectForm(Application);
  Screen->Cursor = crDefault;
  tempform->ShowModal();
  tempform->Free();
}
//---------------------------------------------------------------------------
void __fastcall TMainDemo::Button19Click(TObject *Sender)
{
  Screen->Cursor = crHourGlass;
  TForm *tempform = new TBtnGridForm(Application);
  Screen->Cursor = crDefault;
  tempform->ShowModal();
  tempform->Free();
}
//---------------------------------------------------------------------------
void __fastcall TMainDemo::Button1Click(TObject *Sender)
{
  Screen->Cursor = crHourGlass;
  TForm *tempform = new TRecordViewDemoForm(Application);
  Screen->Cursor = crDefault;
  tempform->ShowModal();
  tempform->Free();
}
//---------------------------------------------------------------------------
void __fastcall TMainDemo::Button20Click(TObject *Sender)
{
   wwDBRichEditDemo->Execute();
}
//---------------------------------------------------------------------------
void __fastcall TMainDemo::Button4Click(TObject *Sender)
{
  Screen->Cursor = crHourGlass;
  TForm *tempform = new TSearchForm(Application);
  Screen->Cursor = crDefault;
  tempform->ShowModal();
  tempform->Free();
}
//---------------------------------------------------------------------------
void __fastcall TMainDemo::Button6Click(TObject *Sender)
{
  Screen->Cursor = crHourGlass;
  TForm *tempform = new TIncrSearch(Application);
  Screen->Cursor = crDefault;
  tempform->ShowModal();
  tempform->Free();
}
//---------------------------------------------------------------------------
void __fastcall TMainDemo::Button7Click(TObject *Sender)
{
  Screen->Cursor = crHourGlass;
  TForm *tempform = new TLocate(Application);
  Screen->Cursor = crDefault;
  tempform->ShowModal();
  tempform->Free();
}
//---------------------------------------------------------------------------
void __fastcall TMainDemo::Button12Click(TObject *Sender)
{
  Screen->Cursor = crHourGlass;
  TForm *tempform = new TRecordViewDemoForm2(Application);
  Screen->Cursor = crDefault;
  tempform->ShowModal();
  tempform->Free();
}

//---------------------------------------------------------------------------
void __fastcall TMainDemo::Button9Click(TObject *Sender)
{
  Screen->Cursor = crHourGlass;
  TForm *tempform = new TLookupForm(Application);
  Screen->Cursor = crDefault;
  tempform->ShowModal();
  tempform->Free();
}
//---------------------------------------------------------------------------
void __fastcall TMainDemo::Button17Click(TObject *Sender)
{
  Screen->Cursor = crHourGlass;
  TForm *tempform = new TDetailComboForm(Application);
  Screen->Cursor = crDefault;
  tempform->ShowModal();
  tempform->Free();
}
//---------------------------------------------------------------------------
void __fastcall TMainDemo::Button16Click(TObject *Sender)
{
  Screen->Cursor = crHourGlass;
  TForm *tempform = new TFilterDialogForm(Application);
  Screen->Cursor = crDefault;
  tempform->ShowModal();
  tempform->Free();
}
//---------------------------------------------------------------------------
void __fastcall TMainDemo::Button8Click(TObject *Sender)
{
  Screen->Cursor = crHourGlass;
  TForm *tempform = new TSaveFilterDemo(Application);
  Screen->Cursor = crDefault;
  tempform->ShowModal();
  tempform->Free();
}
//---------------------------------------------------------------------------
void __fastcall TMainDemo::Button14Click(TObject *Sender)
{
  Screen->Cursor = crHourGlass;
  TForm *tempform = new TPictureForm(Application);
  Screen->Cursor = crDefault;
  tempform->ShowModal();
  tempform->Free();
}
//---------------------------------------------------------------------------
void __fastcall TMainDemo::CheckBox1Click(TObject *Sender)
{
  wwIntl1->OKCancelBitmapped = ((TCheckBox *)Sender)->Checked;
  wwIntl1->Connected = false;
  wwIntl1->Connected = true;
}
//---------------------------------------------------------------------------
void __fastcall TMainDemo::CheckBox2Click(TObject *Sender)
{
   if (((TCheckBox *)Sender)->Checked)
      wwIntl1->DialogFontStyle = wwIntl1->DialogFontStyle << fsBold;
   else
      wwIntl1->DialogFontStyle = wwIntl1->DialogFontStyle >> fsBold;

  wwIntl1->Connected = false;
  wwIntl1->Connected = true;
}
//---------------------------------------------------------------------------
void __fastcall TMainDemo::RadioGroup1Click(TObject *Sender)
{
   if (((TRadioGroup *)Sender)->ItemIndex==0)
      wwIntl1->CheckBoxInGridStyle = cbStyleCheckmark;
   else wwIntl1->CheckBoxInGridStyle = cbStyleXmark;

  wwIntl1->Connected = false;
  wwIntl1->Connected = true;
}
//---------------------------------------------------------------------------
void __fastcall TMainDemo::FormShow(TObject *Sender)
{
   FormatSettings.ShortDateFormat = "mm/dd/yyyy";
}
//---------------------------------------------------------------------------
void __fastcall TMainDemo::Button22Click(TObject *Sender)
{
  Screen->Cursor = crHourGlass;
  TForm *tempform = new TDateTimePickerForm(Application);
  Screen->Cursor = crDefault;
  tempform->ShowModal();
  tempform->Free();

}
//---------------------------------------------------------------------------

void __fastcall TMainDemo::Button23Click(TObject *Sender)
{
  Screen->Cursor = crHourGlass;
  TForm *tempform = new TMonthCalendarForm(Application);
  Screen->Cursor = crDefault;
  tempform->ShowModal();
  tempform->Free();

}
//---------------------------------------------------------------------------

void __fastcall TMainDemo::Button24Click(TObject *Sender)
{
  Screen->Cursor = crHourGlass;
  TForm *tempform = new TNavigatorForm1(Application);
  Screen->Cursor = crDefault;
  tempform->ShowModal();
  tempform->Free();

}
//---------------------------------------------------------------------------

void __fastcall TMainDemo::Button25Click(TObject *Sender)
{
  Screen->Cursor = crHourGlass;
  TForm *tempform = new TCombinedForm(Application);
  Screen->Cursor = crDefault;
  tempform->ShowModal();
  tempform->Free();

}
//---------------------------------------------------------------------------

void __fastcall TMainDemo::Button21Click(TObject *Sender)
{
/*  Screen->Cursor = crHourGlass;
  TForm *tempform = new TRecordPanelDemo(Application);
  Screen->Cursor = crDefault;
  tempform->ShowModal();
  tempform->Free();
*/
}
//---------------------------------------------------------------------------


void __fastcall TMainDemo::Button28Click(TObject *Sender)
{
  Screen->Cursor = crHourGlass;
  TForm *tempform = new TDataInspectorDemo(Application);
  Screen->Cursor = crDefault;
  tempform->ShowModal();
  tempform->Free();
}
//---------------------------------------------------------------------------

void __fastcall TMainDemo::Button27Click(TObject *Sender)
{
  Screen->Cursor = crHourGlass;
  TForm *tempform = new TRecordViewDemoForm2(Application);
  Screen->Cursor = crDefault;
  tempform->ShowModal();
  tempform->Free();
}
//---------------------------------------------------------------------------

void __fastcall TMainDemo::Button26Click(TObject *Sender)
{
  Screen->Cursor = crHourGlass;
  TForm *tempform = new TCustomFramingForm(Application);
  Screen->Cursor = crDefault;
  tempform->ShowModal();
  tempform->Free();
}
//---------------------------------------------------------------------------


void __fastcall TMainDemo::Button30Click(TObject *Sender)
{
  Screen->Cursor = crHourGlass;
  TForm *tempform = new TGridControlsForm(Application);
  Screen->Cursor = crDefault;
  tempform->ShowModal();
  tempform->Free();

}
//---------------------------------------------------------------------------

void __fastcall TMainDemo::Button31Click(TObject *Sender)
{
  Screen->Cursor = crHourGlass;
  TForm *tempform = new TMasterDetailGridForm(Application);
  Screen->Cursor = crDefault;
  tempform->ShowModal();
  tempform->Free();

}
//---------------------------------------------------------------------------

void __fastcall TMainDemo::Button39Click(TObject *Sender)
{
  Screen->Cursor = crHourGlass;
  TForm *tempform = new TGridExpandForm(Application);
  Screen->Cursor = crDefault;
  tempform->ShowModal();
  tempform->Free();
}
//---------------------------------------------------------------------------




