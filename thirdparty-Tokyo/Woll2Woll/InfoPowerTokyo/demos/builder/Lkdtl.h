//---------------------------------------------------------------------------
#ifndef LkdtlH
#define LkdtlH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "vcl.wwdblook.hpp"
#include <DB.hpp>
#include <Db.hpp>
#include "vcl.wwriched.hpp"
#include <ComCtrls.hpp>
#include <Datasnap.DBClient.hpp>
//---------------------------------------------------------------------------
class TDetailComboForm : public TForm
{
__published:	// IDE-managed Components
	TLabel *Label1;
	TLabel *Label2;
	TwwDBLookupCombo *InvoiceCombo;
	TwwDBLookupCombo *CustomerCombo;
	TButton *Button1;
	TDataSource *wwDataSource1;
    TwwDBRichEdit *wwDBRichEdit1;
	TClientDataSet *ClientDataSet1;
	TClientDataSet *ClientDataSet2;
	void __fastcall CustomerComboDropDown(TObject *Sender);
	void __fastcall CustomerComboCloseUp(TObject *Sender, TDataSet *LookupTable,
	TDataSet *FillTable, bool modified);
private:	// User declarations
    AnsiString BeforeDropDownValue;
public:		// User declarations
	__fastcall TDetailComboForm(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TDetailComboForm *DetailComboForm;
//---------------------------------------------------------------------------
#endif
