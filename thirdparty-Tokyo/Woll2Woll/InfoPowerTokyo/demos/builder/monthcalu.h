//---------------------------------------------------------------------------
#ifndef monthcaluH
#define monthcaluH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "vcl.wwdbdatetimepicker.hpp"
#include "vcl.wwdbedit.hpp"
#include "vcl.wwdbspin.hpp"
#include "vcl.wwmonthcalendar.hpp"
#include <ComCtrls.hpp>
#include <ExtCtrls.hpp>
#include <Mask.hpp>
//---------------------------------------------------------------------------
class TMonthCalendarForm : public TForm
{
__published:	// IDE-managed Components
    TPanel *Panel1;
    TLabel *Label10;
    TGroupBox *GroupBox1;
    TLabel *Label1;
    TLabel *Label6;
    TButton *Button1;
    TCheckBox *CheckBox8;
    TwwDBSpinEdit *wwDBSpinEdit1;
    TButton *Button2;
    TGroupBox *GroupBox2;
    TLabel *Label4;
    TLabel *Label5;
    TLabel *Label7;
    TwwDBSpinEdit *wwDBSpinEdit2;
    TwwDBSpinEdit *wwDBSpinEdit3;
    TCheckBox *CheckBox5;
    TGroupBox *GroupBox3;
    TLabel *Label8;
    TCheckBox *CheckBox2;
    TCheckBox *CheckBox1;
    TCheckBox *CheckBox3;
    TGroupBox *GroupBox4;
    TLabel *Label9;
    TCheckBox *CheckBox4;
    TRadioButton *RadioButton1;
    TRadioButton *RadioButton2;
    TRadioButton *RadioButton3;
    TRadioButton *RadioButton4;
    TGroupBox *GroupBox5;
    TLabel *Label2;
    TLabel *Label3;
    TwwDBDateTimePicker *wwDBDateTimePicker1;
    TwwDBDateTimePicker *wwDBDateTimePicker2;
    TPanel *Panel2;
    TwwDBMonthCalendar *wwDBMonthCalendar1;
    TStatusBar *StatusBar1;
    void __fastcall wwDBDateTimePicker1Change(TObject *Sender);
    void __fastcall wwDBDateTimePicker2Change(TObject *Sender);
    void __fastcall Button1Click(TObject *Sender);
    void __fastcall CheckBox5Click(TObject *Sender);
    void __fastcall wwDBSpinEdit3Change(TObject *Sender);
    void __fastcall wwDBSpinEdit2Change(TObject *Sender);
    void __fastcall CheckBox4Click(TObject *Sender);
    void __fastcall wwDBMonthCalendar1CalcBoldDay(TObject *Sender,
          TDate ADate, int Month, int Day, int Year, bool &Accept);
    void __fastcall CheckBox2Click(TObject *Sender);
    void __fastcall CheckBox1Click(TObject *Sender);
    void __fastcall CheckBox3Click(TObject *Sender);
    void __fastcall RadioButton1Click(TObject *Sender);
    
    void __fastcall CheckBox8Click(TObject *Sender);
    void __fastcall wwDBSpinEdit1Change(TObject *Sender);
    void __fastcall Button2Click(TObject *Sender);
    void __fastcall wwDBMonthCalendar1MouseMove(TObject *Sender,
          TShiftState Shift, int X, int Y, int Month, int Day, int Year);
private:	// User declarations
public:		// User declarations
    __fastcall TMonthCalendarForm(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TMonthCalendarForm *MonthCalendarForm;
//---------------------------------------------------------------------------
#endif
