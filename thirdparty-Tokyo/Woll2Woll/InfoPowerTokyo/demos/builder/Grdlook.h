//---------------------------------------------------------------------------
#ifndef GrdlookH
#define GrdlookH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Tabnotbk.hpp>
#include <ComCtrls.hpp>
#include "vcl.wwdbgrid.hpp"
#include "vcl.wwdbigrd.hpp"
#include "vcl.wwdblook.hpp"
#include "vcl.wwdotdot.hpp"
#include "vcl.wwdbedit.hpp"
#include <Mask.hpp>
#include <Buttons.hpp>
#include <DB.hpp>
#include "vcl.wwidlg.hpp"
#include "vcl.wwDialog.hpp"
#include <Db.hpp>
#include "vcl.wwriched.hpp"
#include <Grids.hpp>
#include <Datasnap.DBClient.hpp>
//---------------------------------------------------------------------------
class TGridDemo : public TForm
{
__published:	// IDE-managed Components
	TTabbedNotebook *TabbedNotebook1;
	TwwDBGrid *wwDBGrid1;
	TMemo *Memo2;
	TwwDBGrid *wwDBGrid2;
	TwwDBLookupCombo *wwDBLookupCombo2;
	TwwDBLookupCombo *wwDBLookupCombo1;
	TButton *Button1;
	TBitBtn *BitBtn2;
	TDataSource *CustomerSource;
	TwwLookupDialog *wwLookupDialog1;
    TwwDBRichEdit *wwDBRichEdit1;
	TClientDataSet *ZipTable;
	TClientDataSet *CustomerTable;
	TStringField *CustomerTableLastName;
	TStringField *CustomerTableFirstName;
	TStringField *CustomerTableBuyer;
	TStringField *CustomerTableZip;
	TStringField *CustomerTableZipCity;
	TStringField *CustomerTableCompanyName;
	TIntegerField *CustomerTableCustomerNo;
	TStringField *CustomerTableStreet;
	TStringField *CustomerTableCity;
	TStringField *CustomerTableState;
	TDateField *CustomerTableFirstContactDate;
	TStringField *CustomerTablePhoneNumber;
	TMemoField *CustomerTableInformation;
	TStringField *CustomerTableRequestedDemo;
	TBooleanField *CustomerTableLogical;
	void __fastcall TabbedNotebook1Change(TObject *Sender, int NewTab,
	bool &AllowChange);
	void __fastcall FormShow(TObject *Sender);
	void __fastcall wwLookupDialog1UserButton1Click(TObject *Sender,
	TDataSet *LookupTable);
	void __fastcall Button1Click(TObject *Sender);
	void __fastcall BitBtn2Click(TObject *Sender);
	void __fastcall FormCloseQuery(TObject *Sender, bool &CanClose);
    
private:	// User declarations
public:		// User declarations
	__fastcall TGridDemo(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TGridDemo *GridDemo;
//---------------------------------------------------------------------------
#endif
