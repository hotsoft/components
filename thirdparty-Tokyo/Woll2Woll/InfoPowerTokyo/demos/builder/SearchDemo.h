//---------------------------------------------------------------------------
#ifndef SearchDemoH
#define SearchDemoH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ExtCtrls.hpp>
#include <DBCtrls.hpp>
#include <Mask.hpp>
#include "vcl.wwkeycb.hpp"
#include <Buttons.hpp>
#include <DB.hpp>
#include <Db.hpp>
#include "vcl.wwdbcomb.hpp"
#include "vcl.wwdbedit.hpp"
#include "vcl.wwdotdot.hpp"
#include <Datasnap.DBClient.hpp>
//---------------------------------------------------------------------------
class TIncrSearch : public TForm
{
__published:	// IDE-managed Components
	TPanel *Panel2;
	TLabel *Label1;
	TLabel *Label2;
	TLabel *Label3;
	TDBEdit *DBEdit2;
	TDBEdit *DBEdit1;
	TDBEdit *DBEdit3;
	TPanel *Panel1;
	TLabel *Label12;
	TLabel *Label13;
	TwwKeyCombo *wwKeyCombo1;
	TwwIncrementalSearch *wwIncrementalSearch1;
	TMemo *Memo2;
	TBitBtn *CancelBtn;
	TDataSource *DataSource1;
	TClientDataSet *ClientDataSet1;
	void __fastcall wwKeyCombo1Change(TObject *Sender);
private:	// User declarations
public:		// User declarations
	__fastcall TIncrSearch(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TIncrSearch *IncrSearch;
//---------------------------------------------------------------------------
#endif
