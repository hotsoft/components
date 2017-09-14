//---------------------------------------------------------------------------
#ifndef grdbttnH
#define grdbttnH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "vcl.wwdbgrid.hpp"
#include "vcl.wwdbigrd.hpp"
#include "Grids.hpp"
#include <Buttons.hpp>
#include "vcl.wwriched.hpp"
#include <ComCtrls.hpp>
#include <DB.hpp>
#include "vcl.wwrcdvw.hpp"
#include "vcl.wwDialog.hpp"
#include <Db.hpp>
#include <ImgList.hpp>
#include <Datasnap.DBClient.hpp>
#include <System.ImageList.hpp>
//---------------------------------------------------------------------------
class TBtnGridForm : public TForm
{
__published:	// IDE-managed Components
	TwwDBGrid *wwDBGrid1;
	TwwIButton *wwDBGrid1IButton;
	TwwDBRichEdit *wwDBRichEdit1;
	TDataSource *wwDataSource1;
	TwwRecordViewDialog *wwRecordViewDialog1;
        TImageList *ImageList1;
	TClientDataSet *ClientDataSet1;
	void __fastcall wwDBGrid1IButtonClick(TObject *Sender);
        void __fastcall wwDBGrid1CalcTitleImage(TObject *Sender,
          TField *Field, TwwTitleImageAttributes &TitleImageAttributes);
	void __fastcall wwDBGrid1TitleButtonClick(TObject *Sender, UnicodeString AFieldName);

private:	// User declarations
public:		// User declarations
	__fastcall TBtnGridForm(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TBtnGridForm *BtnGridForm;
//---------------------------------------------------------------------------
#endif
