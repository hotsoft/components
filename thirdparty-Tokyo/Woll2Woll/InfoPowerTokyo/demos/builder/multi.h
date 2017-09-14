//---------------------------------------------------------------------------
#ifndef multiH
#define multiH
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
#include <Db.hpp>
#include <Datasnap.DBClient.hpp>
//---------------------------------------------------------------------------
class TMultiSelectForm : public TForm
{
__published:	// IDE-managed Components
	TwwDBGrid *wwDBGrid1;
	TButton *DeleteButton;
	TButton *Button1;
	TButton *Button2;
	TGroupBox *GroupBox1;
	TCheckBox *CheckBox1;
	TCheckBox *CheckBox2;
	TCheckBox *CheckBox3;
	TBitBtn *BitBtn2;
	TwwDBRichEdit *wwDBRichEdit1;
	TDataSource *wwDataSource1;
	TClientDataSet *ClientDataSet1;
	TBooleanField *ClientDataSet1Selected;
	TStringField *ClientDataSet1Code;
	TStringField *ClientDataSet1Description;
	void __fastcall FormShow(TObject *Sender);
	void __fastcall wwDBGrid1CalcCellColors(TObject *Sender, TField *Field,
	TGridDrawState State, bool Highlight, TFont *AFont, TBrush *ABrush);
	
	void __fastcall Button2Click(TObject *Sender);
	void __fastcall Button1Click(TObject *Sender);
	void __fastcall BitBtn2Click(TObject *Sender);
	void __fastcall DeleteButtonClick(TObject *Sender);
	void __fastcall CheckBox3Click(TObject *Sender);
	void __fastcall CheckBox1Click(TObject *Sender);
	void __fastcall CheckBox2Click(TObject *Sender);
private:	// User declarations
    void __fastcall  TMultiSelectForm::PopulateTable();
public:		// User declarations
	__fastcall TMultiSelectForm(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TMultiSelectForm *MultiSelectForm;
//---------------------------------------------------------------------------
#endif
