// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdFTPListParseMicrowareOS9.pas' rev: 25.00 (Windows)

#ifndef Idftplistparsemicrowareos9HPP
#define Idftplistparsemicrowareos9HPP

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
#pragma link "IdFTPListParseMicrowareOS9"

namespace Idftplistparsemicrowareos9
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdMicrowareOS9FTPListItem;
class PASCALIMPLEMENTATION TIdMicrowareOS9FTPListItem : public Idftplisttypes::TIdOwnerFTPListItem
{
	typedef Idftplisttypes::TIdOwnerFTPListItem inherited;
	
protected:
	System::UnicodeString FOS9OwnerPermissions;
	System::UnicodeString FOS9PublicPermissions;
	System::UnicodeString FOS9MiscPermissions;
	unsigned FOS9Sector;
	
public:
	__property System::UnicodeString OS9OwnerPermissions = {read=FOS9OwnerPermissions, write=FOS9OwnerPermissions};
	__property System::UnicodeString OS9PublicPermissions = {read=FOS9PublicPermissions, write=FOS9PublicPermissions};
	__property System::UnicodeString OS9MiscPermissions = {read=FOS9MiscPermissions, write=FOS9MiscPermissions};
	__property unsigned OS9Sector = {read=FOS9Sector, write=FOS9Sector, nodefault};
public:
	/* TIdFTPListItem.Create */ inline __fastcall virtual TIdMicrowareOS9FTPListItem(System::Classes::TCollection* AOwner) : Idftplisttypes::TIdOwnerFTPListItem(AOwner) { }
	
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdMicrowareOS9FTPListItem(void) { }
	
};


class DELPHICLASS TIdFTPLPMicrowareOS9;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPMicrowareOS9 : public Idftplistparsebase::TIdFTPListBaseHeader
{
	typedef Idftplistparsebase::TIdFTPListBaseHeader inherited;
	
protected:
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	__classmethod virtual bool __fastcall IsHeader(const System::UnicodeString AData);
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPMicrowareOS9(void) : Idftplistparsebase::TIdFTPListBaseHeader() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPMicrowareOS9(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idftplistparsemicrowareos9 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDFTPLISTPARSEMICROWAREOS9)
using namespace Idftplistparsemicrowareos9;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Idftplistparsemicrowareos9HPP
