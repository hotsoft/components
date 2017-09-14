//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "dbchecku.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "vcl.wwclearpanel"
#pragma link "vcl.wwdbcomb"
#pragma link "vcl.wwdbdatetimepicker"
#pragma link "vcl.wwdbedit"
#pragma link "vcl.wwDBNavigator"
#pragma link "vcl.wwdotdot"
#pragma link "vcl.wwriched"
#pragma link "vcl.wwSpeedButton"
#pragma resource "*.dfm"
TCustomFramingForm *CustomFramingForm;
//---------------------------------------------------------------------------
__fastcall TCustomFramingForm::TCustomFramingForm(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TCustomFramingForm::wwDataSource1DataChange(
      TObject *Sender, TField *Field)
{
  Label9->Caption = ":145681 :146 :" +
     ((TDataSource *)Sender)->DataSet->FieldByName("CheckNo")->AsString;
}
//---------------------------------------------------------------------------
