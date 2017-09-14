//---------------------------------------------------------------------------
#ifndef navigatorcombH
#define navigatorcombH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "vcl.wwDBNavigator.hpp"
#include "vcl.wwrcdpnl.hpp"
#include "vcl.wwriched.hpp"
#include "vcl.wwSpeedButton.hpp"
#include <ComCtrls.hpp>
#include <Db.hpp>
#include <ExtCtrls.hpp>
#include "vcl.wwclearpanel.hpp"
#include <ImgList.hpp>
#include <DB.hpp>
#include <Datasnap.DBClient.hpp>
//---------------------------------------------------------------------------
class TCombinedForm : public TForm
{
__published:	// IDE-managed Components
	TDataSource *wwDataSource1;
	TDataSource *wwDataSource2;
    TwwDBNavigator *Navigator;
    TwwNavButton *wwDBNavigator1First;
    TwwNavButton *wwDBNavigator1PriorPage;
    TwwNavButton *wwDBNavigator1Prior;
    TwwNavButton *wwDBNavigator1Next;
    TwwNavButton *wwDBNavigator1NextPage;
    TwwNavButton *wwDBNavigator1Last;
    TwwNavButton *wwDBNavigator1Insert;
    TwwNavButton *wwDBNavigator1Delete;
    TwwNavButton *wwDBNavigator1Edit;
    TwwNavButton *wwDBNavigator1Post;
    TwwNavButton *wwDBNavigator1Cancel;
    TwwNavButton *wwDBNavigator1Refresh;
    TwwNavButton *wwDBNavigator1SaveBookmark;
    TwwNavButton *wwDBNavigator1RestoreBookmark;
    TwwNavButton *NavigatorButton;
    TwwNavButton *NavigatorButton1;
    TwwNavButton *NavigatorButton2;
    TStatusBar *StatusBar1;
    TPanel *Panel1;
    TSplitter *Splitter2;
    TPanel *Panel2;
    TwwRecordViewPanel *wwRecordViewPanel2;
    TPanel *Panel3;
    TwwDBRichEdit *wwDBRichEdit1;
    TwwRecordViewPanel *wwRecordViewPanel1;
    TImageList *ImageList1;
	TClientDataSet *Customers;
	TClientDataSet *Invoices;
    void __fastcall NavigatorButton2Click(TObject *Sender);
    void __fastcall FormDestroy(TObject *Sender);
    void __fastcall FormCreate(TObject *Sender);
private:	// User declarations
    void __fastcall ActiveControlChange(TObject *Sender);

public:		// User declarations
    __fastcall TCombinedForm(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TCombinedForm *CombinedForm;
//---------------------------------------------------------------------------
#endif
