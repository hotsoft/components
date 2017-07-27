//---------------------------------------------------------------------------
#ifndef Unit1H
#define Unit1H
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "fs_iclassesrtti.hpp"
#include "fs_iformsrtti.hpp"
#include "fs_igraphicsrtti.hpp"
#include "fs_iinterpreter.hpp"
#include "fs_synmemo.hpp"
#include "fs_tree.hpp"
#include "fs_itools.hpp"
#include <ComCtrls.hpp>
#include <Dialogs.hpp>
#include <ExtCtrls.hpp>
#include <ImgList.hpp>
#include <ToolWin.hpp>
#include "fs_ibasic.hpp"
#include "fs_icpp.hpp"
#include "fs_ijs.hpp"
#include "fs_ipascal.hpp"
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
        TToolBar *ToolBar1;
        TPanel *Panel1;
        TLabel *Label2;
        TComboBox *LangCB;
        TToolButton *LoadBtn;
        TToolButton *RunBtn;
        TToolButton *ToolButton1;
        TPanel *Panel2;
        TToolButton *EvaluateB;
        TfsTree *fsTree1;
        TSplitter *Splitter2;
        TfsSyntaxMemo *Memo;
        TSplitter *Splitter1;
        TMemo *Status;
        TImageList *ImageList1;
        TOpenDialog *OpenDialog1;
        TfsScript *fsScript1;
        TfsClassesRTTI *frClassesRTTI1;
        TfsGraphicsRTTI *frGraphicsRTTI1;
        TfsFormsRTTI *frFormsRTTI1;
        TfsPascal *fsPascal1;
        TfsCPP *fsCPP1;
        void __fastcall FormCreate(TObject *Sender);
        void __fastcall LoadBtnClick(TObject *Sender);
        void __fastcall LangCBClick(TObject *Sender);
        void __fastcall RunBtnClick(TObject *Sender);
        void __fastcall EvaluateBClick(TObject *Sender);
private:	// User declarations
        void __fastcall fsScript1RunLine(TfsScript *Sender,
          const AnsiString UnitName, const AnsiString SourcePos);
public:		// User declarations
        Boolean FRunning;
        Boolean FStopped;
        __fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
