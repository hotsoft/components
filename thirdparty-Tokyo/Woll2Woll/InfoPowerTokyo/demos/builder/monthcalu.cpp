//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "monthcalu.h"
#include "mnthyear.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "vcl.wwdbdatetimepicker"
#pragma link "vcl.wwdbedit"
#pragma link "vcl.wwdbspin"
#pragma link "vcl.wwmonthcalendar"
#pragma resource "*.dfm"
TMonthCalendarForm *MonthCalendarForm;
//---------------------------------------------------------------------------
__fastcall TMonthCalendarForm::TMonthCalendarForm(TComponent* Owner)
    : TForm(Owner)
{
}

//---------------------------------------------------------------------------
void __fastcall TMonthCalendarForm::wwDBDateTimePicker1Change(TObject *Sender)
{
   wwDBDateTimePicker2->MinDate = wwDBDateTimePicker1->Date;
   wwDBMonthCalendar1->MinDate = wwDBDateTimePicker1->Date;

}
//---------------------------------------------------------------------------
void __fastcall TMonthCalendarForm::wwDBDateTimePicker2Change(TObject *Sender)
{
   wwDBDateTimePicker1->MaxDate = wwDBDateTimePicker2->Date;
   wwDBMonthCalendar1->MaxDate = wwDBDateTimePicker2->Date;

}
//---------------------------------------------------------------------------
void __fastcall TMonthCalendarForm::Button1Click(TObject *Sender)
{
  ShowMessage("You selected: "+ DateToStr(wwDBMonthCalendar1->StartDate)+
              " to "+ DateToStr(wwDBMonthCalendar1->EndDate));

}
//---------------------------------------------------------------------------
void __fastcall TMonthCalendarForm::CheckBox5Click(TObject *Sender)
{
  wwDBMonthCalendar1->PopupYearOptions->ShowEditYear=
    ((TCheckBox *)Sender)->Checked;

}
//---------------------------------------------------------------------------
void __fastcall TMonthCalendarForm::wwDBSpinEdit3Change(TObject *Sender)
{
  if (wwDBSpinEdit3->Text != "") {
     if (wwDBSpinEdit3->Text.Length()==4)
        wwDBMonthCalendar1->PopupYearOptions->StartYear = wwDBSpinEdit3->Value;
     else wwDBMonthCalendar1->PopupYearOptions->StartYear = 1990;
  }
}
//---------------------------------------------------------------------------
void __fastcall TMonthCalendarForm::wwDBSpinEdit2Change(TObject *Sender)
{
  if (wwDBSpinEdit2->Text != "")
  {
     wwDBMonthCalendar1->PopupYearOptions->NumberColumns =
        wwDBSpinEdit2->Value;
  }
}
//---------------------------------------------------------------------------
void __fastcall TMonthCalendarForm::CheckBox4Click(TObject *Sender)
{
  bool val = ((TCheckBox *)Sender)->Checked;

  if (val)
     wwDBMonthCalendar1->Options = (wwDBMonthCalendar1->Options << mdoDayState);
  else
     wwDBMonthCalendar1->Options = (wwDBMonthCalendar1->Options >> mdoDayState);
  RadioButton1->Enabled = val;
  RadioButton2->Enabled = val;
  RadioButton3->Enabled = val;
  RadioButton4->Enabled = val;
}

//---------------------------------------------------------------------------
// Holiday is not based on date but based on day of week
int SpecialHoliday(int WeekNo, int DayNo, int Month, int Day, int Year)
{
   int curdayindex= DayOfWeek(StrToDate(IntToStr(Month)+"/1/"+IntToStr(Year)));

   if ((curdayindex<=DayNo) && (Day == DayNo-curdayindex+7*(WeekNo-1)+1)) return true;
   else if ((curdayindex>DayNo) && (Day == 8-(curdayindex-DayNo)+7*(WeekNo-1))) return true;
   else return false;
}

void __fastcall TMonthCalendarForm::wwDBMonthCalendar1CalcBoldDay(
      TObject *Sender, TDate ADate, int Month, int Day, int Year,
      bool &Accept)
{
   Accept = false;
   int i = DayOfWeek(ADate);
   int kind;
   if (RadioButton1->Checked) kind = 1;
   else if (RadioButton2->Checked) kind = 2;
   else if (RadioButton3->Checked) kind = 3;
   else if (RadioButton4->Checked) kind = 4;

   switch (kind) {
      case 1: //Weekends
         if (DayOfWeek(ADate)==1) Accept = true;
         else if (DayOfWeek(ADate)==7) Accept = true;
         break;

      case 2: // Leap year
         if (IsLeapYear(Word(Year)) && (Month == 2) && (Day==29)) Accept = true;
         break;

      case 3: // Holidays
         if (Month == 1) {
            if (Day==1) Accept = true; // New Years Day
            else if (SpecialHoliday(3,2, Month, Day, Year)) Accept = true; //Birthday of Martin Luther King, third Monday in January.
         }
         else if (Month==2){
            Accept = (
            (Day==2) || // GroundHog Day
            (Day==12) || // Lincoln's Birthday
            (Day==14) || // Valentines Day
            SpecialHoliday(3,2, Month, Day, Year)); //Washington's Birthday, third Monday in February.
         }
         else if (Month==3){
            Accept = (Day==17); // St.Patricks Day
         }
         else if (Month==4){
            Accept = (Day==1); // April Fool's Day
         }
         else if (Month==5){
            Accept = (
               SpecialHoliday(2,1, Month, Day, Year) ||  //Mother's Day
               ((i==2) && ((31-Day)<=6))); //Memorial Day - Last Monday in May
         }
         else if (Month==6){
            Accept = (
                (Day==14)  ||       // Flag Day
                SpecialHoliday(3,1, Month, Day, Year) ); //Father's Day - 3rd Sunday in June
         }
         else if (Month==7){
            Accept = (Day==4); // Independence Day
         }
         else if (Month==8){
         }
         else if (Month==9){
            if (SpecialHoliday(1,2, Month, Day, Year)) Accept = true;  //Labor Day - first Monday in September.
         }
         else if (Month==10){
            Accept = ((Day==31) || // Halloween
                       SpecialHoliday(2,2, Month, Day, Year)); //Columbus Day second Monday in October.
         }
         else if (Month==11){
            Accept = ((Day==11) || // Veterans Day
                       SpecialHoliday(4,5, Month, Day, Year)); // Thanksgiving
         }
         else if (Month==12){
            Accept = (Day==25);
         }
         break;

      case 4: // Paydays
         if (SpecialHoliday(1,6, Month, Day, Year) ||
             SpecialHoliday(3,6, Month, Day, Year)) Accept =True;
         break;
   }

}
//---------------------------------------------------------------------------
void __fastcall TMonthCalendarForm::CheckBox2Click(TObject *Sender)
{
  bool val = ((TCheckBox *)Sender)->Checked;
  if (val)
     wwDBMonthCalendar1->Options = (wwDBMonthCalendar1->Options >> mdoNoToday);
  else
     wwDBMonthCalendar1->Options = (wwDBMonthCalendar1->Options << mdoNoToday);
}
//---------------------------------------------------------------------------
void __fastcall TMonthCalendarForm::CheckBox1Click(TObject *Sender)
{
  bool val = ((TCheckBox *)Sender)->Checked;
  if (val)
     wwDBMonthCalendar1->Options = (wwDBMonthCalendar1->Options >> mdoNoTodayCircle);
  else
     wwDBMonthCalendar1->Options = (wwDBMonthCalendar1->Options << mdoNoTodayCircle);

}
//---------------------------------------------------------------------------
void __fastcall TMonthCalendarForm::CheckBox3Click(TObject *Sender)
{
  bool val = ((TCheckBox *)Sender)->Checked;
  if (!val)
     wwDBMonthCalendar1->Options = (wwDBMonthCalendar1->Options >> mdoWeekNumbers);
  else
     wwDBMonthCalendar1->Options = (wwDBMonthCalendar1->Options << mdoWeekNumbers);

}
//---------------------------------------------------------------------------
void __fastcall TMonthCalendarForm::RadioButton1Click(TObject *Sender)
{
  wwDBMonthCalendar1->Options = (wwDBMonthCalendar1->Options >> mdoDayState);
  wwDBMonthCalendar1->Options = (wwDBMonthCalendar1->Options << mdoDayState);
}
//---------------------------------------------------------------------------
void __fastcall TMonthCalendarForm::CheckBox8Click(TObject *Sender)
{
  bool val = ((TCheckBox *)Sender)->Checked;
  Button1->Enabled = val;
  wwDBSpinEdit1->Enabled = val;
  Label1->Enabled = val;
  if (val){
     wwDBMonthCalendar1->Options = (wwDBMonthCalendar1->Options  << mdoMultiSelect);
     wwDBMonthCalendar1->MaxSelectCount = 14;
     wwDBMonthCalendar1->StartDate = wwDBMonthCalendar1->Date;
     wwDBMonthCalendar1->EndDate = wwDBMonthCalendar1->Date+13;
  }
  else
     wwDBMonthCalendar1->Options = (wwDBMonthCalendar1->Options  >> mdoMultiSelect);
}
//---------------------------------------------------------------------------
void __fastcall TMonthCalendarForm::wwDBSpinEdit1Change(TObject *Sender)
{
  if (wwDBSpinEdit1->Text != "")
    wwDBMonthCalendar1->MaxSelectCount = wwDBSpinEdit1->Value;
}
//---------------------------------------------------------------------------
void __fastcall TMonthCalendarForm::Button2Click(TObject *Sender)
{
   TForm *tempForm = new TYearCalendar(this);
   tempForm->ShowModal();
   tempForm->Free();
}
//---------------------------------------------------------------------------
void __fastcall TMonthCalendarForm::wwDBMonthCalendar1MouseMove(
      TObject *Sender, TShiftState Shift, int X, int Y, int Month, int Day,
      int Year)
{
  if (Day != 0)     //If Day is 0 then Mouse is not over a Day
     StatusBar1->Panels->Items[0]->Text = "Mouse is over the following date: " +
     DateToStr(EncodeDate(Word(Year),Word(Month),Word(Day)));
  else StatusBar1->Panels->Items[0]->Text = "Move the mouse over a date";

}
//---------------------------------------------------------------------------
