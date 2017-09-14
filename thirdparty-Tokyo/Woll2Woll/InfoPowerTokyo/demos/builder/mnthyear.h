//---------------------------------------------------------------------------
#ifndef mnthyearH
#define mnthyearH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "vcl.wwmonthcalendar.hpp"
#include <Buttons.hpp>
#include <ExtCtrls.hpp>
//---------------------------------------------------------------------------
class TYearCalendar : public TForm
{
__published:	// IDE-managed Components
    TBitBtn *BitBtn1;
    TPanel *Panel1;
    TwwDBMonthCalendar *wwDBMonthCalendar1;
private:	// User declarations
public:		// User declarations
    __fastcall TYearCalendar(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TYearCalendar *YearCalendar;
//---------------------------------------------------------------------------
#endif
