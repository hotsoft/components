//
// Components : TwwSaveFilter
//
// Copyright (c) 1997 by Woll2Woll Software
//
//---------------------------------------------------------------------------
#ifndef wwtestH
#define wwtestH
//---------------------------------------------------------------------------
#include <sysutils.hpp>
#include <controls.hpp>
#include <classes.hpp>
#include <forms.hpp>
#include <vcl.wwfltdlg.hpp>
//---------------------------------------------------------------------------
class TwwSaveFilter : public TComponent
{
private:
   System::String FDelimiter;
   System::String FFilePath;
protected:
   bool FOverwriteMessage;
   bool FCalledBySave;
   TwwFilterDialog *FFilterDialog;

   void __fastcall SetFilterDialog(TwwFilterDialog * val);
   virtual void _fastcall Notification(TComponent * AComponent,
			   TOperation Operation);

public:
   virtual __fastcall TwwSaveFilter(TComponent* Owner);
   virtual __fastcall ~TwwSaveFilter();
   virtual void __fastcall SaveFilter(System::String FilterName);
   virtual bool __fastcall DeleteFilter(System::String FilterName);
   virtual int __fastcall LoadFilter(System::String FilterName);
   virtual bool __fastcall GetFilterNames(TStrings *AFilterNames);
   virtual bool __fastcall FilterExists(System::String FilterName);

__published:
   __property System::String Delimiter = {read=FDelimiter,write=FDelimiter,nodefault};
   __property System::String FilePath = {read=FFilePath,write=FFilePath,nodefault};
   __property bool OverwriteMessage = {read=FOverwriteMessage,write=FOverwriteMessage,nodefault};
   __property TwwFilterDialog *wwFilterDialog = {read=FFilterDialog,write=SetFilterDialog,nodefault};
};
//---------------------------------------------------------------------------
#endif
