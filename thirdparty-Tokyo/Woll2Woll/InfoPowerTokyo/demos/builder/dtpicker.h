//---------------------------------------------------------------------------
#ifndef dtpickerH
#define dtpickerH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "vcl.wwdbdatetimepicker.hpp"
#include "vcl.wwDBNavigator.hpp"
#include "vcl.wwriched.hpp"
#include "vcl.wwSpeedButton.hpp"
#include <ComCtrls.hpp>
#include <Db.hpp>
#include <ExtCtrls.hpp>
#include "vcl.wwclearpanel.hpp"
#include <DB.hpp>
#include <Datasnap.DBClient.hpp>
//---------------------------------------------------------------------------
class TDateTimePickerForm : public TForm
{
__published:	// IDE-managed Components
    TPanel *Panel1;
    TLabel *Label5;
    TLabel *Label8;
    TLabel *Label9;
    TLabel *Label7;
    TwwDBDateTimePicker *wwDBDateTimePicker1;
    TwwDBDateTimePicker *wwDBDateTimePicker2;
    TwwDBDateTimePicker *wwDBDateTimePicker3;
    TwwDBDateTimePicker *wwDBDateTimePicker4;
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
    TPageControl *PageControl1;
    TTabSheet *TabSheet1;
    TwwDBRichEdit *wwDBRichEdit3;
    TwwDBRichEdit *wwDBRichEdit2;
    TTabSheet *TabSheet2;
    TLabel *Label1;
    TCheckBox *ShowTodayCircleCheckbox;
    TCheckBox *ShowTodayCheckbox;
    TCheckBox *ShowWeekNumberCheckbox;
    TComboBox *ComboBox1;
    TRadioGroup *RadioGroup1;
    TwwDBRichEdit *wwDBRichEdit4;
    TDataSource *wwDataSource1;
	TClientDataSet *ClientDataSet1;void __fastcall DropdownOptionsClick(TObject *Sender);
    void __fastcall RadioGroup1Click(TObject *Sender);
    void __fastcall ComboBox1Change(TObject *Sender);
    void __fastcall wwDBDateTimePicker2CalcBoldDay(TObject *Sender,
          TDate ADate, int Month, int Day, int Year, bool &Accept);
    
private:	// User declarations
public:		// User declarations
    __fastcall TDateTimePickerForm(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TDateTimePickerForm *DateTimePickerForm;
//---------------------------------------------------------------------------
#endif
