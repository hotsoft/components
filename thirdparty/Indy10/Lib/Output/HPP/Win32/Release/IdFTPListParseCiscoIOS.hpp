// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdFTPListParseCiscoIOS.pas' rev: 25.00 (Windows)

#ifndef IdftplistparseciscoiosHPP
#define IdftplistparseciscoiosHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdFTPList.hpp>	// Pascal unit
#include <IdFTPListParseBase.hpp>	// Pascal unit
#include <IdFTPListTypes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------
#pragma link "IdFTPListParseCiscoIOS"

namespace Idftplistparseciscoios
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdCiscoIOSFTPListItem;
class PASCALIMPLEMENTATION TIdCiscoIOSFTPListItem : public Idftplisttypes::TIdMinimalFTPListItem
{
	typedef Idftplisttypes::TIdMinimalFTPListItem inherited;
	
public:
	/* TIdMinimalFTPListItem.Create */ inline __fastcall virtual TIdCiscoIOSFTPListItem(System::Classes::TCollection* AOwner) : Idftplisttypes::TIdMinimalFTPListItem(AOwner) { }
	
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdCiscoIOSFTPListItem(void) { }
	
};


class DELPHICLASS TIdFTPLPCiscoIOS;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPCiscoIOS : public Idftplistparsebase::TIdFTPLPNList
{
	typedef Idftplistparsebase::TIdFTPLPNList inherited;
	
protected:
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
	__classmethod virtual bool __fastcall CheckListing(System::Classes::TStrings* AListing, const System::UnicodeString ASysDescript = System::UnicodeString(), const bool ADetails = true);
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPCiscoIOS(void) : Idftplistparsebase::TIdFTPLPNList() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPCiscoIOS(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idftplistparseciscoios */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDFTPLISTPARSECISCOIOS)
using namespace Idftplistparseciscoios;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdftplistparseciscoiosHPP
