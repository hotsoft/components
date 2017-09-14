//---------------------------------------------------------------------------
#ifndef PicturesH
#define PicturesH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <Tabnotbk.hpp>
#include <ComCtrls.hpp>
#include "vcl.wwdbedit.hpp"
#include <Mask.hpp>
#include "vcl.wwdbspin.hpp"
#include <DBCtrls.hpp>
#include <ExtCtrls.hpp>
#include <DB.hpp>
#include "vcl.wwdbedit.hpp"
#include <Db.hpp>
#include <Datasnap.DBClient.hpp>
//---------------------------------------------------------------------------
class TPictureForm : public TForm
{
__published:    // IDE-managed Components 
    TTabbedNotebook *TabbedNotebook1;
    TLabel *Label1;
    TLabel *Label3;
    TLabel *Label4;
    TLabel *Label5;
    TLabel *Label6;
    TLabel *Label7;
    TwwDBEdit *ColorEdit;
    TwwDBEdit *ZipEdit;
    TwwDBEdit *PhoneEdit;
    TwwDBEdit *CapitalFirstEdit;
    TwwDBEdit *CapitalizedWordsEdit;
    TButton *ResetButton;
    TwwDBEdit *TimeStampEdit;
    TCheckBox *AutoFillCheckbox;
    TLabel *Label8;
    TLabel *Label9;
    TLabel *Label2;
    TwwDBSpinEdit *DateDBEdit;
    TwwDBEdit *Zip_DBEdit;
    TDBNavigator *DBNavigator1;
    TRadioGroup *RadioGroup1;
    TwwDBEdit *PhonDBEdit;
    TCheckBox *AutoFillBound;
    TMemo *Memo1;
	TDataSource *wwDataSource1;
    TStatusBar *StatusBar1;
	TClientDataSet *ClientDataSet2;
	TClientDataSet *ClientDataSet1;
    void __fastcall ResetButtonClick(TObject *Sender);
    void __fastcall FormShow(TObject *Sender);
    void __fastcall EditCheckValue(TObject *Sender,
      Boolean PassesPictureTest);
    void __fastcall EditEnter(TObject *Sender);
    void __fastcall EditExit(TObject *Sender);
    void __fastcall AutoFillCheckboxClick(TObject *Sender);
    void __fastcall ResetButtonEnter(TObject *Sender);
	
	
private:        // User declarations
public:         // User declarations
    virtual __fastcall TPictureForm(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TPictureForm *PictureForm;
//---------------------------------------------------------------------------
#endif
