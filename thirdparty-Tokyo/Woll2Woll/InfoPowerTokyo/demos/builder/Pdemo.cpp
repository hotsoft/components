//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
#include <tchar.h>
//---------------------------------------------------------------------------
#include <Vcl.Styles.hpp>
#include <Vcl.Themes.hpp>
USEFORM("navigatorcomb.cpp", CombinedForm);
USEFORM("navmany.cpp", NavigatorForm1);
USEFORM("multi.cpp", MultiSelectForm);
USEFORM("Lkdtl.cpp", DetailComboForm);
USEFORM("mnthyear.cpp", YearCalendar);
USEFORM("monthcalu.cpp", MonthCalendarForm);
USEFORM("SearchDemo.cpp", IncrSearch);
USEFORM("Selfilt.cpp", SelectSaveFilter);
USEFORM("savefilt.cpp", SaveFilterDemo);
USEFORM("Pictures.cpp", PictureForm);
USEFORM("rcdpnldemo2.cpp", RecordViewDemoForm2);
USEFORM("rcdvw.cpp", RecordViewDemoForm);
USEFORM("DemoLoc.cpp", Locate);
USEFORM("dtpicker.cpp", DateTimePickerForm);
USEFORM("Filtdlg.cpp", FilterDialogForm);
USEFORM("Demo.cpp", MainDemo);
USEFORM("Combos.cpp", LookupForm);
USEFORM("DataInspectorU.cpp", DataInspectorDemo);
USEFORM("dbchecku.cpp", CustomFramingForm);
USEFORM("Grdbitmp.cpp", BitmapForm);
USEFORM("GridExpand.cpp", GridExpandForm);
USEFORM("GridMasterDetail.cpp", MasterDetailGridForm);
USEFORM("isearch.cpp", SearchForm);
USEFORM("gridctrl.cpp", GridControlsForm);
USEFORM("Grdbttn.cpp", BtnGridForm);
USEFORM("Grdlook.cpp", GridDemo);
USEFORM("Grdmemo.cpp", GridMemoApp);
//---------------------------------------------------------------------------
int WINAPI _tWinMain(HINSTANCE, HINSTANCE, LPTSTR, int)
{
	try
	{
		Application->Initialize();
		Application->MainFormOnTaskBar = true;
		TStyleManager::TrySetStyle("Onyx Blue");
		Application->CreateForm(__classid(TMainDemo), &MainDemo);
		Application->CreateForm(__classid(TDetailComboForm), &DetailComboForm);
		Application->Run();
	}
	catch (Exception &exception)
	{
		Application->ShowException(&exception);
	}
	catch (...)
	{
		try
		{
			throw Exception("");
		}
		catch (Exception &exception)
		{
			Application->ShowException(&exception);
		}
	}
	return 0;
}
//---------------------------------------------------------------------------
