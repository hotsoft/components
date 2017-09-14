//---------------------------------------------------------------------------

#ifndef GridExpandH
#define GridExpandH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "vcl.wwcheckbox.hpp"
#include "vcl.wwDataInspector.hpp"
#include "vcl.wwdbgrid.hpp"
#include "vcl.wwdbigrd.hpp"
#include "vcl.wwriched.hpp"
#include <ComCtrls.hpp>
#include <Db.hpp>
#include <Grids.hpp>
#include <DB.hpp>
#include <Datasnap.DBClient.hpp>
//---------------------------------------------------------------------------
class TGridExpandForm : public TForm
{
__published:	// IDE-managed Components
        TwwDBGrid *wwDBGrid1;
        TwwDBRichEdit *wwDBRichEdit2;
        TwwDataInspector *wwDataInspector1;
        TwwExpandButton *wwExpandButton1;
        TwwDataInspector *wwDataInspector2;
        TwwExpandButton *wwExpandButton2;
        TwwDBRichEdit *wwDBRichEdit1;
        TDataSource *DataSource1;
	TClientDataSet *ClientDataSet1;
	TFloatField *ClientDataSet1ACCT_NBR;
	TStringField *ClientDataSet1FIRST_NAME;
	TStringField *ClientDataSet1LAST_NAME;
	TBlobField *ClientDataSet1RINTERESTS;
	TBlobField *ClientDataSet1IMAGE;
	TSmallintField *ClientDataSet1PAYMETHOD;
	TFloatField *ClientDataSet1BALANCEDUE;
	TStringField *ClientDataSet1SEX;
	TBooleanField *ClientDataSet1MARRIED;
	TStringField *ClientDataSet1CITY;
	TSmallintField *ClientDataSet1EDUCATION;
	TStringField *ClientDataSet1ADDRESS_1;
	TStringField *ClientDataSet1STATE;
	TStringField *ClientDataSet1ZIP;
	TStringField *ClientDataSet1TELEPHONE;
	TDateField *ClientDataSet1DATE_OPEN;
	TStringField *ClientDataSet1INTERESTS;
	TFloatField *ClientDataSet1SS_NUMBER;
	TStringField *ClientDataSet1PICTURE;
	TDateField *ClientDataSet1BIRTH_DATE;
	TStringField *ClientDataSet1RISK_LEVEL;
	TStringField *ClientDataSet1OCCUPATION;
	TStringField *ClientDataSet1OBJECTIVES;
	TStringField *ClientDataSet1CREDRATING;
	TStringField *ClientDataSet1Name;
	TStringField *ClientDataSet1ShippingAddress;
        void __fastcall Table1CalcFields(TDataSet *DataSet);
private:	// User declarations
public:		// User declarations
        __fastcall TGridExpandForm(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TGridExpandForm *GridExpandForm;
//---------------------------------------------------------------------------
#endif
