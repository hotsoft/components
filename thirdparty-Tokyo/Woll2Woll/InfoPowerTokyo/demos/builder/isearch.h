//---------------------------------------------------------------------------
#ifndef isearchH
#define isearchH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <DBCtrls.hpp>
#include <Mask.hpp>
#include <DB.hpp>
#include "vcl.wwidlg.hpp"
#include "vcl.wwDialog.hpp"
#include <Db.hpp>
#include <Datasnap.DBClient.hpp>
//---------------------------------------------------------------------------
class TSearchForm : public TForm
{
__published:	// IDE-managed Components
	TLabel *Label2;
	TLabel *Label3;
	TLabel *Label4;
	TLabel *Label5;
	TLabel *Label6;
	TLabel *Label7;
	TLabel *Label8;
	TLabel *Label9;
	TLabel *Label11;
	TLabel *Label10;
	TLabel *Label12;
	TGroupBox *GroupBox1;
	TCheckBox *OKCancelCheckBox;
	TCheckBox *FixFirstColumnCheckBox;
	TCheckBox *ShowStatusBarCheckBox;
	TCheckBox *ShowUserButtonCheckBox;
	TCheckBox *ShowSearchByCheckbox;
	TCheckBox *GroupControlsCheckBox;
	TGroupBox *GroupBox2;
	TLabel *Label1;
	TBitBtn *BitBtn1;
	TDBEdit *EditCustomerNo;
	TDBEdit *EditCompanyName;
	TDBEdit *EditFirstName;
	TDBEdit *EditLastName;
	TDBEdit *EditStreet;
	TDBEdit *EditCity;
	TDBEdit *EditState;
	TDBEdit *EditZip;
	TDBEdit *EditPhoneNumber;
	TDBEdit *EditFirstContactDate;
	TDBEdit *EditBuyer;
	TButton *Button1;
	TDataSource *wwDataSource1;
	TwwSearchDialog *wwSearchDialog1;
	TClientDataSet *CustomerTable;
	void __fastcall FormClose(TObject *Sender, TCloseAction &Action);
	void __fastcall BitBtn1Click(TObject *Sender);
	void __fastcall wwSearchDialog1UserButton1Click(TObject *Sender,
	TDataSet *LookupTable);
private:	// User declarations
public:		// User declarations
	__fastcall TSearchForm(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TSearchForm *SearchForm;
//---------------------------------------------------------------------------
#endif
