//---------------------------------------------------------------------------
// Component to save and restore filters to  text file. - This is
// an example component provided by Woll2Woll.
//
// Components : TwwSaveFilter
//
// Copyright (c) 1997 by Woll2Woll Software
//
//
#include <vcl.h>
#pragma hdrstop

#include "wwsavflt.h"
//---------------------------------------------------------------------------
__fastcall TwwSaveFilter::TwwSaveFilter(TComponent* Owner)
	: TComponent(Owner)
{
   Delimiter = "///";
   FCalledBySave = False;
   OverwriteMessage = True;
}

__fastcall TwwSaveFilter::~TwwSaveFilter()
{
   if (FFilterDialog!=NULL) FFilterDialog->RemoveDependent(this);
}

// Save filter information to the file
void __fastcall TwwSaveFilter::SaveFilter(System::String FilterName)
{
  bool DoOverwrite;

  if (FilterName=="") return;

  TStrings * TempStringList;
  if (!FileExists(FilePath)) {
     TempStringList = new TStringList();
     TempStringList->SaveToFile(FilePath);
     TempStringList->Free();
  }

  if (FilterExists(FilterName)){
     if (OverwriteMessage)
     {
        DoOverwrite =
            (MessageDlg("\"" + FilterName + "\" already exists.  Overwrite?",
            mtWarning, TMsgDlgButtons() << mbYes << mbNo, 0) == mrYes);
     }
     else DoOverwrite = true;

     if (DoOverwrite) DeleteFilter(FilterName);
     else return;
  }

  TempStringList = new TStringList();
  TempStringList->LoadFromFile(FilePath);
  TwwFieldInfo * curFieldInfo;

  String NewCaseSensitive;
  String NewNonMatching;
  TempStringList->Add(FilterName);
  for (int i=0;i< FFilterDialog->FieldInfo->Count;i++) {
    curFieldInfo = (TwwFieldInfo *)(FFilterDialog->FieldInfo->Items[i]);

    if (curFieldInfo->CaseSensitive)
       NewCaseSensitive = "True";
    else NewCaseSensitive = "False";

    if (curFieldInfo->NonMatching)
       NewNonMatching = "True";
    else NewNonMatching = "False";

    TempStringList->Add(curFieldInfo->FieldName + "\t" +
                     curFieldInfo->DisplayLabel + "\t" +
                     IntToStr(curFieldInfo->MatchType) + "\t" +
                     curFieldInfo->FilterValue + "\t" +
                     curFieldInfo->MinValue + "\t" +
                     curFieldInfo->MaxValue + "\t" +
                     NewCaseSensitive + "\t" + NewNonMatching);
  }

  TempStringList->Add(Delimiter);
  TempStringList->SaveToFile(FilePath);
  TempStringList->Free();
}

// Check if filter exists in file
bool __fastcall TwwSaveFilter::FilterExists(System::String FilterName)
{
  TStrings * TempStringList = new TStringList();
  TempStringList->LoadFromFile(FilePath);
  int lineNum=0;
  bool result = false;
  while(lineNum<TempStringList->Count) {
     if (TempStringList->Strings[lineNum] == FilterName)
     {
        result = true;
        break;
     }
     else lineNum++;
  }
  TempStringList->Free();

  return result;
}

// Delete filter from file
bool __fastcall TwwSaveFilter::DeleteFilter(System::String FilterName)
{
  TStrings * TempStringList = new TStringList();
  TempStringList->LoadFromFile(FilePath);
  int lineNum=0;
  bool result = false;
  while(lineNum<TempStringList->Count) {
     if (TempStringList->Strings[lineNum] == FilterName)
     {
        while (lineNum+1<TempStringList->Count)
        {
           TempStringList->Delete(lineNum);
           if (TempStringList->Strings[lineNum]== Delimiter) {
              TempStringList->Delete(lineNum);
              result = true;
              break;
           }
        }
        if (result) break;
     }
     else lineNum++;
  }
  TempStringList->SaveToFile(FilePath);
  TempStringList->Free();

  return result;
}

// Pass the name of the filter you want to load, the same name passed
// from the SaveFilterToFile procedure.
int __fastcall TwwSaveFilter::LoadFilter(System::String FilterName)
{
  TStrings * TempStringList = new TStringList();
  TempStringList->LoadFromFile(FilePath);
  int lineNum=0;
  bool result = false;

  while(lineNum<TempStringList->Count) {
     if (TempStringList->Strings[lineNum] == FilterName)
     {
        FFilterDialog->ClearFilter();
        TStrings * myFieldInfoStrings = new TStringList();
        TwwFieldInfo *curFieldInfo;
        while (lineNum+1<TempStringList->Count)
        {
           lineNum++;
           if (TempStringList->Strings[lineNum]== Delimiter) break;

           curFieldInfo = new TwwFieldInfo();
           strBreakApart(TempStringList->Strings[lineNum], "\t", myFieldInfoStrings);
           curFieldInfo->FieldName = myFieldInfoStrings->Strings[0];
           curFieldInfo->DisplayLabel = myFieldInfoStrings->Strings[1];
           curFieldInfo->MatchType = TwwFilterMatchType(StrToInt(myFieldInfoStrings->Strings[2]));
           curFieldInfo->FilterValue = myFieldInfoStrings->Strings[3];
           curFieldInfo->MinValue = myFieldInfoStrings->Strings[4];
           curFieldInfo->MaxValue = myFieldInfoStrings->Strings[5];

           if (myFieldInfoStrings->Strings[6] == "True")
              curFieldInfo->CaseSensitive = True;
           else curFieldInfo->CaseSensitive = False;

           if ((myFieldInfoStrings->Count-1 > 6) &&
              (myFieldInfoStrings->Strings[7] == "True"))
              curFieldInfo->NonMatching = True;
           else curFieldInfo->NonMatching = False;

           FFilterDialog->FieldInfo->Add(curFieldInfo);
        }
        myFieldInfoStrings->Free();
        FFilterDialog->ApplyFilter();
        result = true;
        break;
     }
     else lineNum++;
  }

  TempStringList->Free();
  return result;
}

// Get list of filter names
bool __fastcall TwwSaveFilter::GetFilterNames(TStrings *AFilterNames)
{
  AFilterNames->Clear();
  if (!FileExists(FilePath)) return 0;

  TStrings * TempStringList = new TStringList();
  TempStringList->LoadFromFile(FilePath);

  int lineNum=0;
  while(lineNum < TempStringList->Count) {
     if (TempStringList->Strings[lineNum].Length()==0) // Skip null lines
     {
        lineNum++;
        continue;
     }
     if (lineNum<TempStringList->Count)
        AFilterNames->Add(TempStringList->Strings[lineNum]);

     // Skip text until encounter delimeter, then add line following delimeter to list
     while ((TempStringList->Strings[lineNum] != Delimiter) &&
            (lineNum<TempStringList->Count-1)) lineNum++;
     lineNum++;
  }

  TempStringList->Free();

  return (AFilterNames->Count>0);
}

// Inform filterdialog to notify us when it is destroyed
void _fastcall TwwSaveFilter::SetFilterDialog(TwwFilterDialog * val)
{
   if (FFilterDialog!=NULL) FFilterDialog->RemoveDependent(this);
   FFilterDialog=val;
   if (val!=NULL) FFilterDialog->AddDependent(this);
}

void _fastcall TwwSaveFilter::Notification(TComponent * AComponent,
  TOperation Operation)
{
  TComponent::Notification(AComponent, Operation);
  if ((Operation == opRemove) && (AComponent == FFilterDialog))
    FFilterDialog=NULL;
}


namespace Wwsavflt
{
	void __fastcall Register()
	{
		TComponentClass classes[1] = {__classid(TwwSaveFilter)};
		RegisterComponents("Samples", classes, 0);
	}
}
//---------------------------------------------------------------------------
