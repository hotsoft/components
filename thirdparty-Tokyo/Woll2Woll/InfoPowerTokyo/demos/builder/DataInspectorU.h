//---------------------------------------------------------------------------
#ifndef DataInspectorUH
#define DataInspectorUH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "vcl.wwclearpanel.hpp"
#include "vcl.wwDataInspector.hpp"
#include "vcl.wwdbedit.hpp"
#include "vcl.wwDBNavigator.hpp"
#include "vcl.wwdotdot.hpp"
#include "vcl.wwintl.hpp"
#include "vcl.wwriched.hpp"
#include "vcl.wwSpeedButton.hpp"
#include <ComCtrls.hpp>
#include <DB.hpp>
#include <Dialogs.hpp>
#include <ExtCtrls.hpp>
#include <ExtDlgs.hpp>
#include <Graphics.hpp>
#include <Grids.hpp>
#include <ImgList.hpp>
#include <Mask.hpp>
#include <ComCtrls.hpp>
#include <Db.hpp>
#include <Dialogs.hpp>
#include <ExtCtrls.hpp>
#include <ExtDlgs.hpp>
#include <Graphics.hpp>
#include <Grids.hpp>
#include <ImgList.hpp>
#include <Mask.hpp>
#include <DB.hpp>
#include <Datasnap.DBClient.hpp>
//---------------------------------------------------------------------------
class TDataInspectorDemo : public TForm
{
__published:	// IDE-managed Components
        TImage *Image1;
        TwwDataInspector *wwDataInspector1;
        TwwDBRichEdit *wwDBRichEdit1;
        TwwDBComboDlg *wwDBComboDlg1;
        TwwDBNavigator *wwDBNavigator1;
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
        TButton *Button1;
        TButton *Button2;
        TwwDBRichEdit *wwDBRichEdit2;
        TwwDataInspector *OptionsInspector;
		TDataSource *wwDataSource1;
        TOpenPictureDialog *OpenPictureDialog1;
        TImageList *ImageList1;
        TwwIntl *wwIntl1;
	TClientDataSet *ClientDataSet1;
	TStringField *ClientDataSet1FirstName;
	TStringField *ClientDataSet1LastName;
	TStringField *ClientDataSet1MiddleName;
	TStringField *ClientDataSet1Street;
	TStringField *ClientDataSet1City;
	TStringField *ClientDataSet1State;
	TStringField *ClientDataSet1Zip;
	TStringField *ClientDataSet1Country;
	TStringField *ClientDataSet1PhoneNumber;
	TStringField *ClientDataSet1FaxNumber;
	TStringField *ClientDataSet1Company;
	TStringField *ClientDataSet1JobTitle;
	TFloatField *ClientDataSet1EmployeeNo;
	TDateTimeField *ClientDataSet1StartDateTime;
	TDateField *ClientDataSet1StartDate;
	TFloatField *ClientDataSet1NumberOrders;
	TTimeField *ClientDataSet1WorkingHourStartTime;
	TTimeField *ClientDataSet1WorkingHourEndTime;
	TStringField *ClientDataSet1PayType;
	TFloatField *ClientDataSet1PayRate;
	TStringField *ClientDataSet1Supervisor;
	TStringField *ClientDataSet1SSN;
	TMemoField *ClientDataSet1RichEdit;
	TStringField *ClientDataSet1Sabatical;
	TMemoField *ClientDataSet1Memo;
        void __fastcall LabelLineStyleChanged(
          TwwDataInspector *Sender, TwwInspectorItem *Item,
          UnicodeString NewValue);
        void __fastcall DataLineStyleChanged(
          TwwDataInspector *Sender, TwwInspectorItem *Item,
          UnicodeString NewValue);
        void __fastcall OptionsInspectorItems0ItemChanged(
          TwwDataInspector *Sender, TwwInspectorItem *Item,
          UnicodeString NewValue);
        void __fastcall wwDataInspector1BeforePaint(
          TwwDataInspector *Sender);
        void __fastcall OptionsInspectorCalcDataPaintText(
          TwwDataInspector *Sender, TwwInspectorItem *Item,
          UnicodeString &PaintText);
        void __fastcall wwTable1CalcFields(TDataSet *DataSet);
        void __fastcall HideShowDataChanged(
          TwwDataInspector *Sender, TwwInspectorItem *Item,
          UnicodeString NewValue);
        void __fastcall Button2Click(TObject *Sender);
        void __fastcall Button1Click(TObject *Sender);
private:	// User declarations
public:		// User declarations
        __fastcall TDataInspectorDemo(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TDataInspectorDemo *DataInspectorDemo;
//---------------------------------------------------------------------------
#endif
