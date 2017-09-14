//---------------------------------------------------------------------------
#ifndef DemoLocH
#define DemoLocH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ExtCtrls.hpp>
#include <DBCtrls.hpp>
#include <Mask.hpp>
#include <DB.hpp>
#include "vcl.wwlocate.hpp"
#include <Menus.hpp>
#include "vcl.wwDialog.hpp"
#include <Db.hpp>
#include <Datasnap.DBClient.hpp>
//---------------------------------------------------------------------------
class TLocate : public TForm
{
__published:	// IDE-managed Components
	TPanel *Panel2;
	TScrollBox *ScrollBox;
	TLabel *Label1;
	TLabel *Label2;
	TLabel *Label3;
	TLabel *Label4;
	TLabel *Label5;
	TLabel *Label6;
	TLabel *Label7;
	TLabel *Label8;
	TLabel *Label9;
	TLabel *Label10;
	TLabel *Label11;
	TDBEdit *EditCustomerNo;
	TDBEdit *EditCompanyName;
	TDBEdit *EditFirstName;
	TDBEdit *EditLastName;
	TDBEdit *EditStreet;
	TDBEdit *EditCity;
	TDBEdit *EditState;
	TDBEdit *EditZip;
	TDBEdit *EditBuyer;
	TDBEdit *EditFirstContactDate;
	TDBEdit *EditPhoneNumber;
	TDBNavigator *DBNavigator1;
	TDataSource *DataSource1;
	TwwLocateDialog *wwLocateDialog1;
	TMainMenu *MainMenu1;
	TMenuItem *File2;
	TMenuItem *Exit1;
	TMenuItem *File1;
	TMenuItem *FindFieldValue1;
	TMenuItem *FindNext1;
	TClientDataSet *ClientDataSet1;
	void __fastcall FindFieldValue1Click(TObject *Sender);
	void __fastcall Exit1Click(TObject *Sender);
	void __fastcall FindNext1Click(TObject *Sender);
	void __fastcall FormShow(TObject *Sender);
private:	// User declarations
public:		// User declarations
	__fastcall TLocate(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TLocate *Locate;
//---------------------------------------------------------------------------
#endif
