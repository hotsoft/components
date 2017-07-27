//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "Unit1.h"
#include "Unit2.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma link "fs_iclassesrtti"
#pragma link "fs_iformsrtti"
#pragma link "fs_igraphicsrtti"
#pragma link "fs_iinterpreter"
#pragma link "fs_synmemo"
#pragma link "fs_tree"
#pragma link "fs_icpp"
#pragma link "fs_ipascal"
#pragma resource "*.dfm"
TForm1 *Form1;
//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
        : TForm(Owner)
{
}
//---------------------------------------------------------------------------

void __fastcall TForm1::FormCreate(TObject *Sender)
{
  fsGlobalUnit()->AddClass(__classid(TForm1), "TForm");
  fsGetLanguageList(LangCB->Items);
  LangCB->ItemIndex = 0;
}
//---------------------------------------------------------------------------

void __fastcall TForm1::LoadBtnClick(TObject *Sender)
{
  OpenDialog1->InitialDir = ExtractFilePath(Application->ExeName) + "Samples";
  OpenDialog1->FilterIndex = LangCB->ItemIndex + 1;
  if (OpenDialog1->Execute())
    Memo->Lines->LoadFromFile(OpenDialog1->FileName);
}
//---------------------------------------------------------------------------
void __fastcall TForm1::LangCBClick(TObject *Sender)
{
  AnsiString s;
  s = LangCB->Items->Strings[LangCB->ItemIndex];
  if (s == "PascalScript")
    Memo->SyntaxType = stPascal;
  else
    Memo->SyntaxType = stCpp;
  Memo->SetFocus();
}
//---------------------------------------------------------------------------
void __fastcall TForm1::fsScript1RunLine(TfsScript *Sender,
      const AnsiString UnitName, const AnsiString SourcePos)
{
  TPoint p;
  p = fsPosToPoint(SourcePos);
  Memo->SetPos(p.x, p.y);
  FStopped = True;
  while (FStopped)
    Application->ProcessMessages();
}

void __fastcall TForm1::RunBtnClick(TObject *Sender)
{
  int t;
  TPoint p;

  if (FRunning)
  {
    if (Sender == RunBtn)
      fsScript1->OnRunLine = NULL;
    FStopped = False;
    return;
  }

  fsScript1->Clear();
  fsScript1->AddObject("Form1", this);
  fsScript1->Lines = Memo->Lines;
  fsScript1->SyntaxType = LangCB->Items->Strings[LangCB->ItemIndex];
  fsScript1->Parent = fsGlobalUnit();

  if (!fsScript1->Compile())
  {
    Memo->SetFocus();
    p = fsPosToPoint(fsScript1->ErrorPos);
    Memo->SetPos(p.x, p.y);
    Status->Text = fsScript1->ErrorMsg;
    return;
  }
  else
    Status->Text = "Compiled OK, Running...";

  Application->ProcessMessages();
  t = GetTickCount();

  if (Sender == RunBtn)
    fsScript1->OnRunLine = NULL;
  else
    fsScript1->OnRunLine = fsScript1RunLine;

  FRunning = True;
  fsScript1->Execute();
  FRunning = False;
  Status->Text = "Exception in the program";
  Status->Text = "Executed in " + IntToStr(GetTickCount() - t) + " ms";
}
//---------------------------------------------------------------------------
void __fastcall TForm1::EvaluateBClick(TObject *Sender)
{
  Form2->ShowModal();
}
//---------------------------------------------------------------------------

