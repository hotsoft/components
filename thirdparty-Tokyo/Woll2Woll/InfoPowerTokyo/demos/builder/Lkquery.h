//---------------------------------------------------------------------------
#ifndef LkqueryH
#define LkqueryH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ComCtrls.hpp>
#include "vcl.wwdbgrid.hpp"
#include "vcl.wwdbigrd.hpp"
#include "Grids.hpp"
#include "vcl.wwdblook.hpp"
#include "vcl.wwriched.hpp"
#include <ExtCtrls.hpp>
#include "vcl.wwdbdlg.hpp"
#include <DB.hpp>
#include <DBTables.hpp>
#include <Db.hpp>
//---------------------------------------------------------------------------
class TTableQueryForm : public TForm
{
__published:	// IDE-managed Components
	TButton *Button1;
	TPageControl *PageControl1;
	TTabSheet *TabSheet2;
	TwwDBGrid *wwDBGrid1;
	TwwDBLookupCombo *wwDBLookupCombo1;
	TRadioGroup *RadioGroup1;
	TwwDBLookupComboDlg *wwDBLookupComboDlg1;
	TTabSheet *TabSheet1;
	TLabel *Label1;
	TLabel *Label2;
	TwwDBLookupCombo *wwDBLookupCombo2;
	TwwDBLookupComboDlg *wwDBLookupComboDlg2;
	TwwDBRichEdit *wwDBRichEdit2;
	TDataSource *ZipDS;
	TDataSource *CustDS;
	TQuery *CustQuery;
	TIntegerField *CustQueryCustomerNo;
	TStringField *CustQueryCompanyName;
	TStringField *CustQueryState;
	TStringField *CustQueryZip;
	TStringField *CustQueryBuyer;
	TStringField *CustQueryFirstName;
	TStringField *CustQueryLastName;
	TStringField *CustQueryStreet;
	TDateField *CustQueryFirstContactDate;
	TStringField *CustQueryPhoneNumber;
	TMemoField *CustQueryInformation;
	TBlobField *CustQueryRichEdit;
	TStringField *CustQueryRequestedDemo;
	TBooleanField *CustQueryLogical;
	TStringField *CustQueryCity;
	TQuery *ZipQuery;
	TQuery *wwQuery1;
    TwwDBRichEdit *wwDBRichEdit1;
	void __fastcall RadioGroup1Click(TObject *Sender);
private:	// User declarations
public:		// User declarations
	__fastcall TTableQueryForm(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TTableQueryForm *TableQueryForm;
//---------------------------------------------------------------------------
#endif
