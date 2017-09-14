//---------------------------------------------------------------------------
#ifndef DemoH
#define DemoH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include <ExtCtrls.hpp>
#include "vcl.wwriched.hpp"
#include <ComCtrls.hpp>
#include <Tabnotbk.hpp>
#include "vcl.Wwintl.hpp"
#include <Data.DB.hpp>
#include <Data.Win.ADODB.hpp>
#include <Datasnap.DBClient.hpp>
//---------------------------------------------------------------------------
class TMainDemo : public TForm
{
__published:	// IDE-managed Components
        TPageControl *PageControl1;
        TTabSheet *TabSheet1;
        TBevel *Bevel3;
        TwwDBRichEdit *wwDBRichEdit2;
        TButton *Button3;
        TButton *Button5;
        TButton *Button13;
        TButton *Button15;
        TButton *Button19;
        TButton *Button29;
        TButton *Button30;
        TButton *Button31;
        TButton *Button33;
        TButton *Button39;
        TTabSheet *TabSheet12;
        TwwDBRichEdit *wwDBRichEdit10;
        TPageControl *PageControl2;
        TTabSheet *TabSheet13;
        TwwDBRichEdit *wwDBRichEdit13;
        TButton *Button22;
        TTabSheet *TabSheet14;
        TwwDBRichEdit *wwDBRichEdit12;
        TButton *Button23;
        TTabSheet *TabSheet3;
        TLabel *Label1;
        TBevel *Bevel1;
        TwwDBRichEdit *wwDBRichEditDemo;
        TButton *Button20;
        TButton *RichLabelDemoButton;
        TTabSheet *TabSheet2;
        TButton *Button1;
        TwwDBRichEdit *wwDBRichEdit7;
        TwwDBRichEdit *wwDBRichEdit8;
        TButton *Button12;
        TTabSheet *TabSheet7;
        TwwDBRichEdit *wwDBRichEdit5;
        TButton *Button16;
        TButton *Button8;
        TTabSheet *TabSheet11;
        TButton *Button24;
        TwwDBRichEdit *wwDBRichEdit14;
        TButton *Button25;
        TTabSheet *TabSheet4;
        TButton *Button4;
        TButton *Button6;
        TwwDBRichEdit *wwDBRichEdit9;
        TButton *Button7;
        TTabSheet *TabSheet6;
        TwwDBRichEdit *wwDBRichEdit4;
        TButton *Button9;
        TButton *Button17;
        TButton *Button40;
        TTabSheet *TabSheet8;
        TwwDBRichEdit *wwDBRichEdit6;
        TButton *Button14;
        TTabSheet *TabSheet9;
        TGroupBox *GroupBox8;
        TCheckBox *CheckBox1;
        TCheckBox *CheckBox2;
        TRadioGroup *RadioGroup1;
        TwwDBRichEdit *wwDBRichEdit11;
        TTabSheet *TabSheet5;
        TwwDBRichEdit *wwDBRichEdit3;
        TButton *Button26;
        TButton *Button27;
        TTabSheet *TabSheet15;
        TwwDBRichEdit *wwDBRichEdit15;
        TButton *Button28;
        TButton *Button32;
        TTabSheet *TabSheet16;
        TwwDBRichEdit *wwDBRichEdit16;
        TButton *Button35;
        TTabSheet *TabSheet17;
        TwwDBRichEdit *wwDBRichEdit18;
        TButton *Button37;
        TTabSheet *TabSheet18;
        TwwDBRichEdit *wwDBRichEdit17;
        TButton *Button36;
        TTabSheet *TabSheet19;
        TwwDBRichEdit *wwDBRichEdit19;
        TButton *Button38;
        TPanel *Panel1;
        TLabel *Label31;
        TButton *Button2;
        TwwDBRichEdit *wwDBRichEdit1;
        TwwIntl *wwIntl1;
	void __fastcall Button2Click(TObject *Sender);
	void __fastcall Button3Click(TObject *Sender);
	void __fastcall Button5Click(TObject *Sender);
	void __fastcall Button13Click(TObject *Sender);
	void __fastcall Button15Click(TObject *Sender);
	void __fastcall Button19Click(TObject *Sender);
	void __fastcall Button1Click(TObject *Sender);
	void __fastcall Button20Click(TObject *Sender);
	void __fastcall Button4Click(TObject *Sender);
	void __fastcall Button6Click(TObject *Sender);
	void __fastcall Button7Click(TObject *Sender);
	void __fastcall Button12Click(TObject *Sender);
	void __fastcall Button9Click(TObject *Sender);
	void __fastcall Button17Click(TObject *Sender);
	void __fastcall Button16Click(TObject *Sender);
	void __fastcall Button8Click(TObject *Sender);
	void __fastcall Button14Click(TObject *Sender);
	void __fastcall CheckBox1Click(TObject *Sender);
	void __fastcall CheckBox2Click(TObject *Sender);
	void __fastcall RadioGroup1Click(TObject *Sender);
	void __fastcall FormShow(TObject *Sender);
	
	
	
    void __fastcall Button22Click(TObject *Sender);
    void __fastcall Button23Click(TObject *Sender);
    void __fastcall Button24Click(TObject *Sender);
    void __fastcall Button25Click(TObject *Sender);
    void __fastcall Button21Click(TObject *Sender);
        void __fastcall Button28Click(TObject *Sender);
        void __fastcall Button27Click(TObject *Sender);
        void __fastcall Button26Click(TObject *Sender);
        void __fastcall Button30Click(TObject *Sender);
        void __fastcall Button31Click(TObject *Sender);
        void __fastcall Button39Click(TObject *Sender);
private:	// User declarations
public:		// User declarations
	__fastcall TMainDemo(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TMainDemo *MainDemo;
//---------------------------------------------------------------------------
#endif
