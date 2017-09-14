//---------------------------------------------------------------------------
#ifndef savefiltH
#define savefiltH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "vcl.wwdbgrid.hpp"
#include "vcl.wwdbigrd.hpp"
#include "Grids.hpp"
#include "vcl.wwfltdlg.hpp"
#include <DB.hpp>
#include <Menus.hpp>
#include "wwsavflt.h"
#include "vcl.wwDialog.hpp"
#include <Db.hpp>
#include <Datasnap.DBClient.hpp>
//---------------------------------------------------------------------------
class TSaveFilterDemo : public TForm
{
__published:	// IDE-managed Components
	TwwDBGrid *wwDBGrid1;
	TMemo *Memo1;
	TwwFilterDialog *wwFilterDialog1;
	TDataSource *wwDataSource1;
	TMainMenu *MainMenu1;
	TMenuItem *Filter1;
	TMenuItem *Filter2;
	TMenuItem *ClearFilter1;
	TMenuItem *LoadFilter1;
	TMenuItem *SaveFilter1;
	TMenuItem *Exit1;
	TClientDataSet *ClientDataSet1;
	void __fastcall LoadFilter1Click(TObject *Sender);
	void __fastcall Exit1Click(TObject *Sender);
	void __fastcall SaveFilter1Click(TObject *Sender);
	void __fastcall ClearFilter1Click(TObject *Sender);
	void __fastcall Filter2Click(TObject *Sender);
	void __fastcall FormShow(TObject *Sender);
private:	// User declarations
    void __fastcall TSaveFilterDemo::LoadFilter();
public:		// User declarations
	__fastcall TSaveFilterDemo(TComponent* Owner);
    TwwSaveFilter *wwSaveFilter1;
};
//---------------------------------------------------------------------------
extern TSaveFilterDemo *SaveFilterDemo;
//---------------------------------------------------------------------------
#endif
