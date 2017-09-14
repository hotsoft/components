// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwclient.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwclientHPP
#define Vcl_WwclientHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Data.DB.hpp>
#include <Vcl.Dialogs.hpp>
#include <vcl.Wwstr.hpp>
#include <vcl.Wwsystem.hpp>
#include <vcl.wwtypes.hpp>
#include <Datasnap.DBClient.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwclient
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwClientDataSet;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TwwClientDataSetFilterEvent)(TwwClientDataSet* ClientDataSet, bool &Accept);

class PASCALIMPLEMENTATION TwwClientDataSet : public Datasnap::Dbclient::TClientDataSet
{
	typedef Datasnap::Dbclient::TClientDataSet inherited;
	
private:
	System::Classes::TStrings* FControlType;
	System::Classes::TStrings* FPictureMasks;
	bool FUsePictureMask;
	Vcl::Wwtypes::TwwInvalidValueEvent FOnInvalidValue;
	Data::Db::TFilterRecordEvent FOnFilter;
	char *FFilterFieldBuffer;
	Data::Db::TParam* FFilterParam;
	System::Classes::TStrings* FRemoteSQL;
	System::Classes::TStrings* FFieldList;
	void __fastcall SetOnFilter(Data::Db::TFilterRecordEvent val);
	System::Classes::TStrings* __fastcall GetControlType(void);
	void __fastcall SetControlType(System::Classes::TStrings* sel);
	System::Classes::TStrings* __fastcall GetPictureMasks(void);
	void __fastcall SetPictureMasks(System::Classes::TStrings* sel);
	System::Classes::TStrings* __fastcall GetFieldInfo(void);
	
protected:
	virtual void __fastcall DoBeforePost(void);
	
public:
	bool InFilterEvent;
	__fastcall virtual TwwClientDataSet(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwClientDataSet(void);
	Data::Db::TParam* __fastcall wwFilterField(System::UnicodeString AFieldName);
	virtual bool __fastcall IsSequenced(void);
	
__published:
	__property System::Classes::TStrings* ControlType = {read=GetControlType, write=SetControlType};
	__property System::Classes::TStrings* PictureMasks = {read=GetPictureMasks, write=SetPictureMasks};
	__property bool ValidateWithMask = {read=FUsePictureMask, write=FUsePictureMask, nodefault};
	__property Data::Db::TFilterRecordEvent OnFilter = {read=FOnFilter, write=SetOnFilter};
	__property Vcl::Wwtypes::TwwInvalidValueEvent OnInvalidValue = {read=FOnInvalidValue, write=FOnInvalidValue};
	__property System::Classes::TStrings* FieldInfo = {read=GetFieldInfo, stored=false};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Wwclient */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWCLIENT)
using namespace Vcl::Wwclient;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwclientHPP
