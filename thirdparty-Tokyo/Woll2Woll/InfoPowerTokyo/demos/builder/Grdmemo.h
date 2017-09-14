//---------------------------------------------------------------------------
#ifndef GrdmemoH
#define GrdmemoH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "vcl.wwdbgrid.hpp"
#include "vcl.wwdbigrd.hpp"
#include "Grids.hpp"
#include <Buttons.hpp>
#include <DB.hpp>
#include "vcl.wwriched.hpp"
#include <ComCtrls.hpp>
#include <Datasnap.DBClient.hpp>
//---------------------------------------------------------------------------
class TGridMemoApp : public TForm
{
__published:	// IDE-managed Components
	TwwDBGrid *wwDBGrid1;
	TBitBtn *CancelBtn;
	TBitBtn *BitBtn2;
	TDataSource *CustomerSource;
        TwwDBRichEdit *wwDBRichEdit1;
	TClientDataSet *ClientDataSet1;
	void __fastcall BitBtn2Click(TObject *Sender);
	void __fastcall wwDBGrid1MemoOpen(TwwDBGrid *Grid, TwwMemoDialog *MemoDialog);
	void __fastcall wwDBGrid1CreateHintWindow(TObject *Sender, TwwGridHintWindow *HintWindow,
          TField *AField, TRect &R, bool &WordWrap, int &MaxWidth,
          int &MaxHeight, bool &DoDefault);
private:	// User declarations
public:		// User declarations
	__fastcall TGridMemoApp(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TGridMemoApp *GridMemoApp;
//---------------------------------------------------------------------------
#endif
