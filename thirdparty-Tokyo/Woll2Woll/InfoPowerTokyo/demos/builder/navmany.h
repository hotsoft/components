//---------------------------------------------------------------------------
#ifndef navmanyH
#define navmanyH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "vcl.wwdbgrid.hpp"
#include "vcl.wwdbigrd.hpp"
#include "vcl.wwDBNavigator.hpp"
#include "vcl.wwriched.hpp"
#include "vcl.wwSpeedButton.hpp"
#include <ComCtrls.hpp>
#include <Db.hpp>
#include <ExtCtrls.hpp>
#include <Grids.hpp>
#include "vcl.wwclearpanel.hpp"
#include <ImgList.hpp>
#include <DB.hpp>
#include <Datasnap.DBClient.hpp>
//---------------------------------------------------------------------------
class TNavigatorForm1 : public TForm
{
__published:	// IDE-managed Components
    TwwDBRichEdit *wwDBRichEdit1;
    TPageControl *PageControl1;
    TTabSheet *TabSheet1;
    TLabel *Label2;
    TLabel *Label3;
    TwwDBNavigator *wwDBNavigator1;
    TwwNavButton *wwDBNavigator1First;
    TwwNavButton *wwDBNavigator1PriorPage;
    TwwNavButton *wwDBNavigator1Prior;
    TwwNavButton *wwDBNavigator1Next;
    TwwNavButton *wwDBNavigator1NextPage;
    TwwNavButton *wwDBNavigator1Last;
    TwwNavButton *wwDBNavigator1Insert;
    TwwNavButton *wwDBNavigator1Delete;
    TwwNavButton *wwDBNavigator1Edit;
    TwwNavButton *wwDBNavigator1Post;
    TwwNavButton *wwDBNavigator1Cancel;
    TwwNavButton *wwDBNavigator1Refresh;
    TwwNavButton *wwDBNavigator1SaveBookmark;
    TwwNavButton *wwDBNavigator1RestoreBookmark;
    TwwNavButton *wwDBNavigator1Button;
    TwwNavButton *wwDBNavigator1Button1;
    TwwNavButton *wwDBNavigator1Button2;
    TwwNavButton *wwDBNavigator1Button3;
    TwwDBNavigator *wwDBNavigator3;
    TwwNavButton *wwDBNavigator3First;
    TwwNavButton *wwDBNavigator3PriorPage;
    TwwNavButton *wwDBNavigator3Prior;
    TwwNavButton *wwDBNavigator3Next;
    TwwNavButton *wwDBNavigator3NextPage;
    TwwNavButton *wwDBNavigator3Last;
    TwwNavButton *wwDBNavigator3Insert;
    TwwNavButton *wwDBNavigator3Delete;
    TwwNavButton *wwDBNavigator3Edit;
    TwwNavButton *wwDBNavigator3Post;
    TwwNavButton *wwDBNavigator3Cancel;
    TwwNavButton *wwDBNavigator3Refresh;
    TwwNavButton *wwDBNavigator3SaveBookmark;
    TwwNavButton *wwDBNavigator3RestoreBookmark;
    TwwDBGrid *wwDBGrid1;
    TTabSheet *TabSheet2;
    TLabel *Label4;
    TGroupBox *GroupBox1;
    TwwDBNavigator *wwDBNavigator8;
    TwwNavButton *wwDBNavigator8Edit;
    TwwNavButton *wwDBNavigator8Post;
    TwwNavButton *wwDBNavigator8Cancel;
    TwwNavButton *wwDBNavigator8Refresh;
    TwwNavButton *wwDBNavigator8SaveBookmark;
    TwwNavButton *wwDBNavigator8RestoreBookmark;
    TwwDBNavigator *wwDBNavigator5;
    TwwNavButton *wwDBNavigator5First;
    TwwNavButton *wwDBNavigator5PriorPage;
    TwwNavButton *wwDBNavigator5Prior;
    TwwNavButton *wwDBNavigator5Last;
    TwwNavButton *wwDBNavigator5NextPage;
    TwwNavButton *wwDBNavigator5Next;
    TwwDBNavigator *wwDBNavigator7;
    TwwNavButton *wwDBNavigator7Delete;
    TwwNavButton *wwDBNavigator7Post;
    TwwNavButton *wwDBNavigator7Refresh;
    TwwNavButton *wwDBNavigator7RestoreBookmark;
    TwwDBNavigator *wwDBNavigator6;
    TwwNavButton *wwNavButton7;
    TwwNavButton *wwNavButton9;
    TwwNavButton *wwNavButton11;
    TwwNavButton *wwNavButton13;
    TwwDBNavigator *wwDBNavigator4;
    TwwNavButton *wwDBNavigator4First;
    TwwNavButton *wwDBNavigator4PriorPage;
    TwwNavButton *wwDBNavigator4Prior;
    TwwNavButton *wwDBNavigator4Next;
    TwwNavButton *wwDBNavigator4NextPage;
    TwwNavButton *wwDBNavigator4Last;
    TwwNavButton *wwDBNavigator4Insert;
    TwwNavButton *wwDBNavigator4Delete;
    TwwDBNavigator *wwDBNavigator2;
    TwwNavButton *wwDBNavigator2First;
    TwwNavButton *wwDBNavigator2PriorPage;
    TwwNavButton *wwDBNavigator2Prior;
    TwwNavButton *wwDBNavigator2Next;
    TwwNavButton *wwDBNavigator2NextPage;
    TwwNavButton *wwDBNavigator2Last;
    TwwNavButton *wwDBNavigator2Insert;
    TwwNavButton *wwDBNavigator2Delete;
    TwwNavButton *wwDBNavigator2Edit;
    TwwNavButton *wwDBNavigator2Post;
    TwwNavButton *wwDBNavigator2Cancel;
    TwwNavButton *wwDBNavigator2Refresh;
    TwwNavButton *wwDBNavigator2SaveBookmark;
    TwwNavButton *wwDBNavigator2RestoreBookmark;
    TwwDBGrid *wwDBGrid2;
	TDataSource *wwDataSource1;
    TImageList *ImageList1;
	TClientDataSet *ClientDataSet1;
private:	// User declarations
public:		// User declarations
    __fastcall TNavigatorForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TNavigatorForm1 *NavigatorForm1;
//---------------------------------------------------------------------------
#endif
