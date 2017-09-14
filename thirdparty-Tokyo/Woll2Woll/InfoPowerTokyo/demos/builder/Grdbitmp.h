//---------------------------------------------------------------------------
#ifndef GrdbitmpH
#define GrdbitmpH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <DBCtrls.hpp>
#include "vcl.wwdbgrid.hpp"
#include "vcl.wwdbigrd.hpp"
#include "Grids.hpp"
#include "vcl.wwdbcomb.hpp"
#include "vcl.wwdotdot.hpp"
#include "vcl.wwdbedit.hpp"
#include <Mask.hpp>
#include "vcl.wwdbspin.hpp"
#include <ExtCtrls.hpp>
#include <DB.hpp>
#include "vcl.wwDBNavigator.hpp"
#include "vcl.wwriched.hpp"
#include "vcl.wwSpeedButton.hpp"
#include <ComCtrls.hpp>
#include "vcl.wwclearpanel.hpp"
#include <ImgList.hpp>
#include <Datasnap.DBClient.hpp>
//---------------------------------------------------------------------------
class TBitmapForm : public TForm
{
__published:	// IDE-managed Components
	TDBText *DBText1;
	TDBText *DBText2;
	TDBText *DBText3;
	TwwDBComboBox *PayMethCombo;
	TDataSource *CustomerDS;
	TDataSource *InvoiceDS;
    TwwDBGrid *InvoiceGrid;
    TwwDBNavigator *wwDBNavigator1;
    TwwNavButton *wwDBNavigator1First;
    TwwNavButton *wwDBNavigator1PriorPage;
    TwwNavButton *wwDBNavigator1Prior;
    TwwNavButton *wwDBNavigator1Next;
    TwwNavButton *wwDBNavigator1NextPage;
	TwwNavButton *wwDBNavigator1Last;
    TwwNavButton *wwDBNavigator1SaveBookmark;
    TwwNavButton *wwDBNavigator1RestoreBookmark;
    TImageList *ImageList1;
        TwwDBRichEdit *wwDBRichEdit1;
	TClientDataSet *CustomerTable;
	TIntegerField *CustomerTableCustomerNo;
	TStringField *CustomerTableCompanyName;
	TStringField *CustomerTableFirstName;
	TStringField *CustomerTableLastName;
	TStringField *CustomerTableCity;
	TStringField *CustomerTableState;
	TStringField *CustomerTableZip;
	TStringField *CustomerTableBuyer;
	TStringField *CustomerTableStreet;
	TDateField *CustomerTableFirstContactDate;
	TStringField *CustomerTablePhoneNumber;
	TMemoField *CustomerTableInformation;
	TStringField *CustomerTableRequestedDemo;
	TBooleanField *CustomerTableLogical;
	TStringField *CustomerTableFullName;
	TStringField *CustomerTableFullAddress;
	TDataSetField *CustomerTableInvoiceTable;
	TClientDataSet *InvoiceTable;
	TIntegerField *InvoiceTableCustomerNo;
	TFloatField *InvoiceTableInvoiceNo;
	TFloatField *InvoiceTablePaymentMethod;
	TCurrencyField *InvoiceTableTotalInvoice;
	TDateField *InvoiceTablePurchaseDate;
	TCurrencyField *InvoiceTableBalanceDue;
	TIntegerField *InvoiceTablePayImageIndex;
	TDateTimeField *InvoiceTableMyDate;
	TClientDataSet *ClientDataSet1;
	void __fastcall CustomerTableCalcFields(TDataSet *DataSet);
	void __fastcall InvoiceGridCalcCellColors(TObject *Sender, TField *Field,
	TGridDrawState State, bool Highlight, TFont *AFont, TBrush *ABrush);
	void __fastcall InvoiceDSDataChange(TObject *Sender, TField *Field);
	void __fastcall InvoiceGridDblClick(TObject *Sender);
	void __fastcall InvoiceGridKeyDown(TObject *Sender, WORD &Key,
	TShiftState Shift);
	void __fastcall PayMethComboCloseUp(TwwDBComboBox *Sender, bool Select);
    void __fastcall InvoiceGridUpdateFooter(TObject *Sender);
    void __fastcall InvoiceTableCalcFields(TDataSet *DataSet);
	void __fastcall InvoiceGridCalcTitleAttributes(TObject *Sender, UnicodeString AFieldName,
		  TFont *AFont, TBrush *ABrush, TAlignment &ATitleAlignment);

private:	// User declarations
	void __fastcall ToggleBitmaps();
	bool InUpdateFooter;
public:		// User declarations
	__fastcall TBitmapForm(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TBitmapForm *BitmapForm;
//---------------------------------------------------------------------------
#endif
