//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "savefilt.h"
#include "selfilt.h"
//---------------------------------------------------------------------------
#pragma link "vcl.wwdbgrid"
#pragma link "vcl.wwdbigrd"
#pragma link "vcl.wwfltdlg"
#pragma link "vcl.wwdatsrc"
#pragma link "vcl.wwDialog"
#pragma resource "*.dfm"
TSaveFilterDemo *SaveFilterDemo;
//---------------------------------------------------------------------------
__fastcall TSaveFilterDemo::TSaveFilterDemo(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TSaveFilterDemo::LoadFilter1Click(TObject *Sender)
{
   LoadFilter();
}
//---------------------------------------------------------------------------
void __fastcall TSaveFilterDemo::Exit1Click(TObject *Sender)
{
  Close();
}
//---------------------------------------------------------------------------
void __fastcall TSaveFilterDemo::SaveFilter1Click(TObject *Sender)
{
   wwSaveFilter1->SaveFilter(InputBox("Filter Name", "Name of Filter?",""));
}
//---------------------------------------------------------------------------
void __fastcall TSaveFilterDemo::ClearFilter1Click(TObject *Sender)
{
   wwFilterDialog1->ClearFilter();
   wwFilterDialog1->ApplyFilter();
}
//---------------------------------------------------------------------------
void __fastcall TSaveFilterDemo::Filter2Click(TObject *Sender)
{
   wwFilterDialog1->Execute();
}
//---------------------------------------------------------------------------
void __fastcall TSaveFilterDemo::FormShow(TObject *Sender)
{
   wwSaveFilter1 = new TwwSaveFilter(Application);
   wwSaveFilter1->Delimiter = "///";
   wwSaveFilter1->FilePath = "SaveFilt.txt";
   wwSaveFilter1->wwFilterDialog = wwFilterDialog1;
   Width = (Width * PixelsPerInch) / 96;
   Height = (Height * PixelsPerInch) / 96;
}
//---------------------------------------------------------------------------
void __fastcall TSaveFilterDemo::LoadFilter()
{
    TSelectSaveFilter * FilterForm = new TSelectSaveFilter(Application);

    if (!wwSaveFilter1->GetFilterNames(FilterForm->FiltersBox->Items))
    {
       ShowMessage("You do not have any saved filters.");
       FilterForm->Free();
       return;
    }

    Screen->Cursor = crHourGlass;
    if (FilterForm->ShowModal()==mrOk){
       // Remove deleted filters from file
       TStrings * currentFilterNames = new TStringList;
       wwSaveFilter1->GetFilterNames(currentFilterNames);
       for (int i=0; i<currentFilterNames->Count; i++)
          if (FilterForm->FiltersBox->Items->IndexOf(currentFilterNames->Strings[i])<0)
              wwSaveFilter1->DeleteFilter(currentFilterNames->Strings[i]);
       currentFilterNames->Free();

       // Load selected filter
       if (FilterForm->FiltersBox->ItemIndex != -1)
          wwSaveFilter1->LoadFilter(FilterForm->FiltersBox->Items->
             Strings[FilterForm->FiltersBox->ItemIndex]);


    }
    FilterForm->Free();
    Screen->Cursor = crArrow;
}
