//---------------------------------------------------------------------------
#ifndef rcdpnldemo2H
#define rcdpnldemo2H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "vcl.wwDataInspector.hpp"
#include "vcl.wwdblook.hpp"
#include "vcl.wwrcdpnl.hpp"
#include "vcl.wwriched.hpp"
#include <Buttons.hpp>
#include <ComCtrls.hpp>
#include <Db.hpp>
#include <Grids.hpp>
#include <DB.hpp>
#include <Datasnap.DBClient.hpp>
//---------------------------------------------------------------------------
class TRecordViewDemoForm2 : public TForm
{
__published:	// IDE-managed Components
        TSpeedButton *SpeedButton1;
        TwwRecordViewPanel *wwRecordViewPanel1;
        TwwDBRichEdit *wwDBRichEdit1;
        TwwDBLookupCombo *wwDBLookupCombo1;
        TwwDBRichEdit *wwDBRichEdit2;
        TwwDataInspector *Options;
	TDataSource *wwDataSource1;
	TClientDataSet *ClientDataSet1;
	TClientDataSet *ClientDataSet2;
	TIntegerField *ClientDataSet1CustomerNo;
	TStringField *ClientDataSet1Buyer;
	TStringField *ClientDataSet1CompanyName;
	TStringField *ClientDataSet1FirstName;
	TStringField *ClientDataSet1LastName;
	TStringField *ClientDataSet1Street;
	TStringField *ClientDataSet1City;
	TStringField *ClientDataSet1State;
	TStringField *ClientDataSet1Zip;
	TDateField *ClientDataSet1FirstContactDate;
	TStringField *ClientDataSet1PhoneNumber;
	TMemoField *ClientDataSet1Information;
	TBlobField *ClientDataSet1RichEdit;
	TStringField *ClientDataSet1RequestedDemo;
	TBooleanField *ClientDataSet1Logical;
        void __fastcall FocusStyleChanged(
          TwwDataInspector *Sender, TwwInspectorItem *Item,
		  UnicodeString NewValue);
		void __fastcall BorderChanged(
		  TwwDataInspector *Sender, TwwInspectorItem *Item,
		  UnicodeString NewValue);
		void __fastcall LabelsBeneathControlChanged(
		  TwwDataInspector *Sender, TwwInspectorItem *Item,
          UnicodeString NewValue);
        void __fastcall LayoutChanged(TwwDataInspector *Sender,
          TwwInspectorItem *Item, UnicodeString NewValue);
	void __fastcall OptionsCalcDataPaintText(TwwDataInspector *Sender, TwwInspectorItem *Item,
          UnicodeString &PaintText);
	void __fastcall OptionsItems0Items0ItemChanged(TwwDataInspector *Sender, TwwInspectorItem *Item,
          UnicodeString NewValue);
	void __fastcall OptionsItems0Items1ItemChanged(TwwDataInspector *Sender, TwwInspectorItem *Item,
          UnicodeString NewValue);
	void __fastcall OptionsItems0ItemChanged(TwwDataInspector *Sender, TwwInspectorItem *Item,
          UnicodeString NewValue);
private:	// User declarations
public:		// User declarations
        __fastcall TRecordViewDemoForm2(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TRecordViewDemoForm2 *RecordViewDemoForm2;
//---------------------------------------------------------------------------
#endif
