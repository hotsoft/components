// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdFTPListParseTandemGuardian.pas' rev: 25.00 (Windows)

#ifndef IdftplistparsetandemguardianHPP
#define IdftplistparsetandemguardianHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdFTPList.hpp>	// Pascal unit
#include <IdFTPListParseBase.hpp>	// Pascal unit
#include <IdFTPListTypes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------
#pragma link "IdFTPListParseTandemGuardian"

namespace Idftplistparsetandemguardian
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdTandemGuardianFTPListItem;
class PASCALIMPLEMENTATION TIdTandemGuardianFTPListItem : public Idftplisttypes::TIdOwnerFTPListItem
{
	typedef Idftplisttypes::TIdOwnerFTPListItem inherited;
	
protected:
	System::UnicodeString FGroupName;
	unsigned FCode;
	System::UnicodeString FPermissions;
	
public:
	__property System::UnicodeString GroupName = {read=FGroupName, write=FGroupName};
	__property unsigned Code = {read=FCode, write=FCode, nodefault};
	__property System::UnicodeString Permissions = {read=FPermissions, write=FPermissions};
public:
	/* TIdFTPListItem.Create */ inline __fastcall virtual TIdTandemGuardianFTPListItem(System::Classes::TCollection* AOwner) : Idftplisttypes::TIdOwnerFTPListItem(AOwner) { }
	
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdTandemGuardianFTPListItem(void) { }
	
};


class DELPHICLASS TIdFTPLPTandemGuardian;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPTandemGuardian : public Idftplistparsebase::TIdFTPListBaseHeader
{
	typedef Idftplistparsebase::TIdFTPListBaseHeader inherited;
	
protected:
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	__classmethod virtual bool __fastcall IsHeader(const System::UnicodeString AData);
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPTandemGuardian(void) : Idftplistparsebase::TIdFTPListBaseHeader() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPTandemGuardian(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
#define TANDEM_GUARDIAN_ID L"Tandem NonStop Guardian"
}	/* namespace Idftplistparsetandemguardian */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDFTPLISTPARSETANDEMGUARDIAN)
using namespace Idftplistparsetandemguardian;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdftplistparsetandemguardianHPP
