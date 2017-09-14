//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "dtpicker.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "vcl.wwdbdatetimepicker"
#pragma link "vcl.wwDBNavigator"
#pragma link "vcl.wwriched"
#pragma link "vcl.wwSpeedButton"
#pragma link "vcl.wwclearpanel"
#pragma resource "*.dfm"
TDateTimePickerForm *DateTimePickerForm;
//---------------------------------------------------------------------------
__fastcall TDateTimePickerForm::TDateTimePickerForm(TComponent* Owner)
    : TForm(Owner)
{
}
//---------------------------------------------------------------------------


void __fastcall TDateTimePickerForm::DropdownOptionsClick(TObject *Sender)
{
   TwwMonthOption Option;
   TwwMonthOptions TempOptions;
   TwwDBDateTimePicker * MyDTP;
   if (Sender == ShowTodayCheckbox) Option = mdoNoToday;
   else if (Sender == ShowTodayCircleCheckbox) Option = mdoNoTodayCircle;
   else Option = mdoWeekNumbers;

   for (int i=0;i<=ComponentCount-1;i++)
   {
      MyDTP = dynamic_cast<TwwDBDateTimePicker *>(Components[i]);
      if (MyDTP) {
         TempOptions = MyDTP->CalendarAttributes->Options;
         if ((Sender == ShowTodayCheckbox) || (Sender ==ShowTodayCircleCheckbox))
         {
            if (((TCheckBox *)Sender)->Checked) TempOptions >> Option;
            else TempOptions << Option;
         }
         else {
            if (((TCheckBox *)Sender)->Checked) TempOptions << Option;
            else TempOptions >> Option;
         }
         MyDTP->CalendarAttributes->Options = TempOptions;
      }
   }
}
//---------------------------------------------------------------------------
void __fastcall TDateTimePickerForm::RadioGroup1Click(TObject *Sender)
{
   TwwDBDateTimePicker * MyDTP;
   TwwMonthOptions TempOptions;
   for (int i=0;i<=ComponentCount-1;i++)
   {
      MyDTP = dynamic_cast<TwwDBDateTimePicker *>(Components[i]);
      if (MyDTP) {
         TempOptions = MyDTP->CalendarAttributes->Options;
         if (((TRadioGroup *)Sender)->ItemIndex==0) TempOptions >> mdoDayState;
         else TempOptions << mdoDayState;
         MyDTP->CalendarAttributes->Options = TempOptions;
      }
   }

}
//---------------------------------------------------------------------------
void __fastcall TDateTimePickerForm::ComboBox1Change(TObject *Sender)
{
   TwwDBDateTimePicker * MyDTP;
   for (int i=0;i<=ComponentCount-1;i++)
   {
      MyDTP = dynamic_cast<TwwDBDateTimePicker *>(Components[i]);
      if (MyDTP) {
         if (ComboBox1->Text == "Center") MyDTP->CalendarAttributes->Alignment = wwdtaCenter;
         else if (ComboBox1->Text == "Right") MyDTP->CalendarAttributes->Alignment = wwdtaRight;
         else MyDTP->CalendarAttributes->Alignment = wwdtaLeft;
      }
   }
}
//---------------------------------------------------------------------------
// Holiday is not based on date but based on day of week
int IsSpecialHoliday(int WeekNo, int DayNo, int Month, int Day, int Year)
{
   int curdayindex= DayOfWeek(StrToDate(IntToStr(Month)+"/1/"+IntToStr(Year)));

   if ((curdayindex<=DayNo) && (Day == DayNo-curdayindex+7*(WeekNo-1)+1)) return true;
   else if ((curdayindex>DayNo) && (Day == 8-(curdayindex-DayNo)+7*(WeekNo-1))) return true;
   else return false;
}

void __fastcall TDateTimePickerForm::wwDBDateTimePicker2CalcBoldDay(TObject *Sender,
      TDate ADate, int Month, int Day, int Year, bool &Accept)
{
   Accept = false;
   int i = DayOfWeek(ADate);
   switch (RadioGroup1->ItemIndex) {
      case 1:
         if (DayOfWeek(ADate)==1) Accept = true;
         else if (DayOfWeek(ADate)==7) Accept = true;
         break;

      case 2:
         if (Month == 1) {
            if (Day==1) Accept = true; // New Years Day
			else if (IsSpecialHoliday(3,2, Month, Day, Year)) Accept = true; //Birthday of Martin Luther King, third Monday in January.
         }
         else if (Month==2){
            Accept = (
            (Day==2) || // GroundHog Day
            (Day==12) || // Lincoln's Birthday
            (Day==14) || // Valentines Day
			IsSpecialHoliday(3,2, Month, Day, Year)); //Washington's Birthday, third Monday in February.
         }
         else if (Month==3){
            Accept = (Day==17); // St.Patricks Day
         }
         else if (Month==4){
            Accept = (Day==1); // April Fool's Day
         }
         else if (Month==5){
            Accept = (
               IsSpecialHoliday(2,1, Month, Day, Year) ||  //Mother's Day
               ((i==2) && ((31-Day)<=6))); //Memorial Day - Last Monday in May
         }
         else if (Month==6){
            Accept = (
                (Day==14)  ||       // Flag Day
				IsSpecialHoliday(3,1, Month, Day, Year) ); //Father's Day - 3rd Sunday in June
         }
         else if (Month==7){
            Accept = (Day==4); // Independence Day
         }
         else if (Month==8){
         }
         else if (Month==9){
			if (IsSpecialHoliday(1,2, Month, Day, Year)) Accept = true;  //Labor Day - first Monday in September.
         }
         else if (Month==10){
            Accept = ((Day==31) || // Halloween
					   IsSpecialHoliday(2,2, Month, Day, Year)); //Columbus Day second Monday in October.
         }
         else if (Month==11){
			Accept = ((Day==11) || // Veterans Day
                       IsSpecialHoliday(4,5, Month, Day, Year)); // Thanksgiving
         }
         else if (Month==12){
            Accept = (Day==25);
         }
         break;

      case 3:
		 if (IsSpecialHoliday(1,6, Month, Day, Year) ||
			 IsSpecialHoliday(3,6, Month, Day, Year)) Accept =True;
         break;
   }
}
//---------------------------------------------------------------------------
