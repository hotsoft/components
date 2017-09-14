//---------------------------------------------------------------------------

#ifndef GridMasterDetailH
#define GridMasterDetailH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "vcl.wwcheckbox.hpp"
#include "vcl.wwdbgrid.hpp"
#include "vcl.wwdbigrd.hpp"
#include <Buttons.hpp>
#include <Db.hpp>
#include <Grids.hpp>
#include <ImgList.hpp>
#include <DB.hpp>
#include <Datasnap.DBClient.hpp>
//---------------------------------------------------------------------------
class TMasterDetailGridForm : public TForm
{
__published:	// IDE-managed Components
        TSpeedButton *SpeedButton1;
        TwwDBGrid *CustomerGrid;
        TwwDBGrid *InvoiceGrid;
        TwwExpandButton *wwExpandButton1;
        TwwDBGrid *ItemsGrid;
        TwwExpandButton *wwExpandButton2;
        TDataSource *DataSource1;
        TDataSource *DataSource2;
        TDataSource *DataSource3;
        TImageList *ImageList1;
	TClientDataSet *CustomerClientDataSet;
	TIntegerField *CustomerClientDataSetOrders;
	TFloatField *CustomerClientDataSetCustNo;
	TStringField *CustomerClientDataSetCompany;
	TStringField *CustomerClientDataSetAddr1;
	TStringField *CustomerClientDataSetAddr2;
	TStringField *CustomerClientDataSetCity;
	TStringField *CustomerClientDataSetState;
	TStringField *CustomerClientDataSetZip;
	TStringField *CustomerClientDataSetCountry;
	TStringField *CustomerClientDataSetPhone;
	TStringField *CustomerClientDataSetFAX;
	TFloatField *CustomerClientDataSetTaxRate;
	TStringField *CustomerClientDataSetContact;
	TDateTimeField *CustomerClientDataSetLastInvoiceDate;
	TClientDataSet *InvoiceClientDataSet;
	TFloatField *InvoiceClientDataSetCustNo;
	TStringField *InvoiceClientDataSetCompany;
	TStringField *InvoiceClientDataSetAddr1;
	TStringField *InvoiceClientDataSetAddr2;
	TStringField *InvoiceClientDataSetCity;
	TStringField *InvoiceClientDataSetState;
	TStringField *InvoiceClientDataSetZip;
	TStringField *InvoiceClientDataSetCountry;
	TStringField *InvoiceClientDataSetPhone;
	TStringField *InvoiceClientDataSetFAX;
	TFloatField *InvoiceClientDataSetTaxRate;
	TStringField *InvoiceClientDataSetContact;
	TDateTimeField *InvoiceClientDataSetLastInvoiceDate;
	TFloatField *InvoiceClientDataSetOrderNo;
	TFloatField *InvoiceClientDataSetCustNo_1;
	TDateTimeField *InvoiceClientDataSetSaleDate;
	TDateTimeField *InvoiceClientDataSetShipDate;
	TIntegerField *InvoiceClientDataSetEmpNo;
	TStringField *InvoiceClientDataSetShipToContact;
	TStringField *InvoiceClientDataSetShipToAddr1;
	TStringField *InvoiceClientDataSetShipToAddr2;
	TStringField *InvoiceClientDataSetShipToCity;
	TStringField *InvoiceClientDataSetShipToState;
	TStringField *InvoiceClientDataSetShipToZip;
	TStringField *InvoiceClientDataSetShipToCountry;
	TStringField *InvoiceClientDataSetShipToPhone;
	TStringField *InvoiceClientDataSetShipVIA;
	TStringField *InvoiceClientDataSetPO;
	TStringField *InvoiceClientDataSetTerms;
	TStringField *InvoiceClientDataSetPaymentMethod;
	TCurrencyField *InvoiceClientDataSetItemsTotal;
	TFloatField *InvoiceClientDataSetTaxRate_1;
	TCurrencyField *InvoiceClientDataSetFreight;
	TCurrencyField *InvoiceClientDataSetAmountPaid;
	TIntegerField *InvoiceClientDataSetItems;
	TClientDataSet *ItemsClientDataSet1;
	TFloatField *ItemsClientDataSet1OrderNo;
	TFloatField *ItemsClientDataSet1ItemNo;
	TFloatField *ItemsClientDataSet1PartNo;
	TIntegerField *ItemsClientDataSet1Qty;
	TFloatField *ItemsClientDataSet1Discount;
        void __fastcall InvoiceGridUpdateFooter(TObject *Sender);
        void __fastcall CustomerGridCalcTitleImage(TObject *Sender,
          TField *Field, TwwTitleImageAttributes &TitleImageAttributes);
        void __fastcall InvoiceGridBeforePaint(TObject *Sender);
private:	// User declarations
    bool InUpdateFooter;
public:		// User declarations
        __fastcall TMasterDetailGridForm(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TMasterDetailGridForm *MasterDetailGridForm;
//---------------------------------------------------------------------------
#endif
