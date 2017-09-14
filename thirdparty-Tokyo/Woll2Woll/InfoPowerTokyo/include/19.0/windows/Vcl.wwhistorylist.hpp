// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwhistorylist.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwhistorylistHPP
#define Vcl_WwhistorylistHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <System.SysUtils.hpp>
#include <System.Win.Registry.hpp>
#include <System.IniFiles.hpp>
#include <vcl.Wwcommon.hpp>
#include <vcl.wwintl.hpp>
#include <Vcl.Forms.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwhistorylist
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwHistoryList;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TwwStorageType : unsigned char { stRegistry, stIniFile };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwHistoryList : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	bool FEnabled;
	System::UnicodeString FSection;
	System::UnicodeString FFileName;
	int FMaxSize;
	TwwStorageType FStorageType;
	bool FMRUEnabled;
	int FMRUMaxSize;
	System::Classes::TStrings* FList;
	bool FLoaded;
	void __fastcall SetEnabled(bool Enabled);
	void __fastcall SetSection(System::UnicodeString Section);
	System::UnicodeString __fastcall GetFileName(void);
	void __fastcall SetFileName(System::UnicodeString FileName);
	void __fastcall SetMaxSize(int MaxSize);
	void __fastcall SetStorageType(TwwStorageType StorageType);
	void __fastcall SetList(System::Classes::TStrings* List);
	
protected:
	void __fastcall SynchWithList(System::Classes::TStrings* SynchList);
	
public:
	System::Classes::TComponent* Owner;
	__property System::Classes::TStrings* List = {read=FList, write=SetList};
	void __fastcall Load(System::Classes::TStrings* SyncList);
	__fastcall TwwHistoryList(void);
	__fastcall virtual ~TwwHistoryList(void);
	void __fastcall Save(void);
	void __fastcall SaveToStream(System::Classes::TStream* Stream);
	void __fastcall LoadFromStream(System::Classes::TStream* Stream);
	void __fastcall SaveToRegistry(System::UnicodeString Value, System::UnicodeString Key, HKEY RootKey);
	void __fastcall LoadFromRegistry(System::Classes::TStrings* SynchList, System::UnicodeString Value, System::UnicodeString Key, HKEY RootKey);
	void __fastcall SaveToIniFile(System::UnicodeString Section, System::UnicodeString IniFile);
	void __fastcall LoadFromIniFile(System::Classes::TStrings* SynchList, System::UnicodeString Section, System::UnicodeString IniFile);
	int __fastcall EffectiveMRUCount(void);
	
__published:
	__property System::UnicodeString Section = {read=FSection, write=SetSection};
	__property System::UnicodeString FileName = {read=GetFileName, write=SetFileName};
	__property int MaxSize = {read=FMaxSize, write=SetMaxSize, default=-1};
	__property TwwStorageType StorageType = {read=FStorageType, write=SetStorageType, default=1};
	__property bool Enabled = {read=FEnabled, write=SetEnabled, default=0};
	__property bool MRUEnabled = {read=FMRUEnabled, write=FMRUEnabled, default=0};
	__property int MRUMaxSize = {read=FMRUMaxSize, write=FMRUMaxSize, default=2};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Wwhistorylist */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWHISTORYLIST)
using namespace Vcl::Wwhistorylist;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwhistorylistHPP
