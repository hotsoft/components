//---------------------------------------------------------------------------
#ifndef rcdvwH
#define rcdvwH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "vcl.wwdbgrid.hpp"
#include "vcl.wwdbigrd.hpp"
#include "Grids.hpp"
#include <Buttons.hpp>
#include <ExtCtrls.hpp>
#include "vcl.wwdbcomb.hpp"
#include "vcl.wwdotdot.hpp"
#include "vcl.wwdbedit.hpp"
#include <Mask.hpp>
#include "vcl.wwdblook.hpp"
#include "vcl.wwriched.hpp"
#include <ComCtrls.hpp>
#include <DB.hpp>
#include "vcl.wwrcdvw.hpp"
#include <Menus.hpp>
#include "vcl.wwDialog.hpp"
#include <Db.hpp>
#include <Datasnap.DBClient.hpp>
//---------------------------------------------------------------------------
class TRecordViewDemoForm : public TForm
{
__published:	// IDE-managed Components
	TLabel *Label1;
	TwwDBGrid *wwDBGrid1;
	TwwIButton *wwDBGrid1IButton;
	TGroupBox *GroupBox1;
	TRadioGroup *RecordViewStyle;
	TRadioGroup *DialogStyle;
	TCheckBox *EmbedControls;
	TCheckBox *CustomMainMenu;
	TCheckBox *ShowNavigator;
	TCheckBox *ShowOKCancel;
	TwwDBComboBox *wwDBComboBox1;
	TwwDBLookupCombo *wwDBLookupCombo1;
	TwwDBRichEdit *wwDBRichEdit1;
	TDataSource *wwDataSource1;
	TwwRecordViewDialog *wwRecordViewDialog1;
	TMainMenu *RecordViewMenu;
	TMenuItem *First1;
	TMenuItem *Exit1;
	TMenuItem *Edit1;
	TMenuItem *Insert1;
	TMenuItem *Cancel1;
	TMenuItem *Post1;
	TMenuItem *Record1;
	TMenuItem *First2;
	TMenuItem *Prior1;
	TMenuItem *Next1;
	TMenuItem *Last1;
	TClientDataSet *ClientDataSet1;
	void __fastcall Exit1Click(TObject *Sender);
	void __fastcall Edit1Click(TObject *Sender);
	void __fastcall Insert1Click(TObject *Sender);
	void __fastcall Cancel1Click(TObject *Sender);
	void __fastcall Post1Click(TObject *Sender);
	void __fastcall First2Click(TObject *Sender);
	void __fastcall Prior1Click(TObject *Sender);
	void __fastcall Next1Click(TObject *Sender);
	void __fastcall Last1Click(TObject *Sender);
	void __fastcall wwDBGrid1IButtonClick(TObject *Sender);
private:	// User declarations
public:		// User declarations
	__fastcall TRecordViewDemoForm(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TRecordViewDemoForm *RecordViewDemoForm;
//---------------------------------------------------------------------------
#endif
