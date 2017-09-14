//---------------------------------------------------------------------------
#ifndef selfiltH
#define selfiltH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
//---------------------------------------------------------------------------
class TSelectSaveFilter : public TForm
{
__published:	// IDE-managed Components
	TListBox *FiltersBox;
	TButton *Button1;
	TButton *Button2;
	void __fastcall FiltersBoxDblClick(TObject *Sender);
	void __fastcall FiltersBoxKeyDown(TObject *Sender, WORD &Key,
	TShiftState Shift);
private:	// User declarations
public:		// User declarations
	__fastcall TSelectSaveFilter(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TSelectSaveFilter *SelectSaveFilter;
//---------------------------------------------------------------------------
#endif
