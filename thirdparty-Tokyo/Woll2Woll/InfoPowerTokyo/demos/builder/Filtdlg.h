//---------------------------------------------------------------------------
#ifndef FiltdlgH
#define FiltdlgH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Buttons.hpp>
#include <Tabnotbk.hpp>
#include <ComCtrls.hpp>
#include "vcl.wwdbgrid.hpp"
#include "vcl.wwdbigrd.hpp"
#include "Grids.hpp"
#include "vcl.wwriched.hpp"
#include "vcl.wwfltdlg.hpp"
#include <DB.hpp>
#include "vcl.wwDialog.hpp"
#include <Db.hpp>
#include "vcl.wwfltdlg.hpp"
#include <TabNotBk.hpp>
#include <Data.Win.ADODB.hpp>
#include <Datasnap.DBClient.hpp>
//---------------------------------------------------------------------------
class TFilterDialogForm : public TForm
{
__published:	// IDE-managed Components
	TLabel *Label1;
	TLabel *Label2;
	TLabel *Label3;
	TBitBtn *BitBtn1;
	TGroupBox *GroupBox1;
	TCheckBox *SearchTypeCheckbox;
	TCheckBox *ShowFieldOrderCheckbox;
	TCheckBox *ViewSummaryCheckbox;
	TCheckBox *CheckBox1;
	TCheckBox *CheckBox2;
	TTabbedNotebook *TabbedNotebook1;
	TwwDBGrid *wwDBGrid1;
	TwwDBGrid *wwDBGrid4;
	TwwDBRichEdit *wwDBRichEdit2;
	TGroupBox *GroupBox2;
	TwwDBGrid *wwDBGrid3;
	TGroupBox *GroupBox3;
	TwwDBGrid *wwDBGrid2;
	TMemo *Memo3;
	TwwDBGrid *wwDBGrid5;
	TwwDBRichEdit *wwDBRichEdit1;
	TwwFilterDialog *wwFilterDialog1;
	TDataSource *CustomerDS;
	TDataSource *Customer2QueryDS;
	TwwFilterDialog *wwFilterDialog3;
	TDataSource *CustInvDS;
	TwwFilterDialog *wwFilterDialog2;
	TDataSource *Customer1QueryDS;
    TwwDBRichEdit *wwDBRichEdit3;
	TClientDataSet *ClientDataSet1;
	TADOQuery *Customer1Query;
	TADOQuery *ADOQuery1;
	TWideStringField *ADOQuery1CustomerID;
	TWideStringField *ADOQuery1CompanyName;
	TWideStringField *ADOQuery1City;
	TADOQuery *ADOQuery2;
	TAutoIncField *ADOQuery2OrderID;
	TWideStringField *ADOQuery2CustomerID;
	TIntegerField *ADOQuery2EmployeeID;
	TDateTimeField *ADOQuery2OrderDate;
	TDateTimeField *ADOQuery2RequiredDate;
	TDateTimeField *ADOQuery2ShippedDate;
	TIntegerField *ADOQuery2ShipVia;
	TBCDField *ADOQuery2Freight;
	TWideStringField *ADOQuery2ShipName;
	TWideStringField *ADOQuery2ShipAddress;
	TWideStringField *ADOQuery2ShipCity;
	TWideStringField *ADOQuery2ShipRegion;
	TWideStringField *ADOQuery2ShipPostalCode;
	TWideStringField *ADOQuery2ShipCountry;
	TADOConnection *ADOConnection1;
	void __fastcall BitBtn1Click(TObject *Sender);
	void __fastcall SearchTypeCheckboxClick(TObject *Sender);
	void __fastcall ShowFieldOrderCheckboxClick(TObject *Sender);
	void __fastcall ViewSummaryCheckboxClick(TObject *Sender);
	void __fastcall CheckBox1Click(TObject *Sender);
	void __fastcall wwDBGrid3CalcCellColors(TObject *Sender, TField *Field,
	TGridDrawState State, bool Highlight, TFont *AFont, TBrush *ABrush);
	void __fastcall TabbedNotebook1Change(TObject *Sender, int NewTab,
	bool &AllowChange);
	void __fastcall CheckBox2Click(TObject *Sender);
	
private:	// User declarations
public:		// User declarations
	__fastcall TFilterDialogForm(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TFilterDialogForm *FilterDialogForm;
//---------------------------------------------------------------------------
#endif
