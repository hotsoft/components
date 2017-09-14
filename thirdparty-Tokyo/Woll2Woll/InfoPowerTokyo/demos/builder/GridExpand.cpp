//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "GridExpand.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "vcl.wwcheckbox"
#pragma link "vcl.wwDataInspector"
#pragma link "vcl.wwdbgrid"
#pragma link "vcl.wwdbigrd"
#pragma link "vcl.wwriched"
#pragma resource "*.dfm"
TGridExpandForm *GridExpandForm;
//---------------------------------------------------------------------------
__fastcall TGridExpandForm::TGridExpandForm(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TGridExpandForm::Table1CalcFields(TDataSet *DataSet)
{
   DataSet->FieldByName("Name")->AsString=
     DataSet->FieldByName("First_Name")->AsString + " " +
     DataSet->FieldByName("Last_Name")->AsString;
   DataSet->FieldByName("ShippingAddress")->AsString=
     DataSet->FieldByName("Address_1")->AsString + " " +
     DataSet->FieldByName("City")->AsString; + " " +
     DataSet->FieldByName("State")->AsString + " " +
     DataSet->FieldByName("Zip")->AsString;
}
//---------------------------------------------------------------------------
