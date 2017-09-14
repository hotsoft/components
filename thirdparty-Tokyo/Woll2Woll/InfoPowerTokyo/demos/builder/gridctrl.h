//---------------------------------------------------------------------------

#ifndef gridctrlH
#define gridctrlH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "vcl.wwclearbuttongroup.hpp"
#include "vcl.wwDataInspector.hpp"
#include "vcl.wwdbgrid.hpp"
#include "vcl.wwdbigrd.hpp"
#include "vcl.wwradiogroup.hpp"
#include "vcl.wwriched.hpp"
#include <Buttons.hpp>
#include <ComCtrls.hpp>
#include <Db.hpp>
#include <DBCtrls.hpp>
#include <Grids.hpp>
#include <ImgList.hpp>
#include <DB.hpp>
#include <Datasnap.DBClient.hpp>
//---------------------------------------------------------------------------
class TGridControlsForm : public TForm
{
__published:	// IDE-managed Components
        TwwDBGrid *wwDBGrid1;
        TwwIButton *wwDBGrid1IButton;
        TDBImage *DBImage2;
        TwwDBRichEdit *wwDBRichEdit2;
        TwwRadioGroup *wwRadioGroup2;
        TwwDataInspector *wwDataInspector1;
        TDataSource *DataSource1;
        TImageList *ImageList6;
	TClientDataSet *ClientDataSet1;
private:	// User declarations
public:		// User declarations
        __fastcall TGridControlsForm(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TGridControlsForm *GridControlsForm;
//---------------------------------------------------------------------------
#endif
