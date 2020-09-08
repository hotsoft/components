// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdFTPListParseOS2.pas' rev: 25.00 (Windows)

#ifndef Idftplistparseos2HPP
#define Idftplistparseos2HPP

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
#pragma link "IdFTPListParseOS2"

namespace Idftplistparseos2
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdOS2FTPListItem;
class PASCALIMPLEMENTATION TIdOS2FTPListItem : public Idftplisttypes::TIdDOSBaseFTPListItem
{
	typedef Idftplisttypes::TIdDOSBaseFTPListItem inherited;
	
public:
	/* TIdDOSBaseFTPListItem.Create */ inline __fastcall virtual TIdOS2FTPListItem(System::Classes::TCollection* AOwner) : Idftplisttypes::TIdDOSBaseFTPListItem(AOwner) { }
	/* TIdDOSBaseFTPListItem.Destroy */ inline __fastcall virtual ~TIdOS2FTPListItem(void) { }
	
};


class DELPHICLASS TIdFTPLPOS2;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPOS2 : public Idftplistparsebase::TIdFTPLPBaseDOS
{
	typedef Idftplistparsebase::TIdFTPLPBaseDOS inherited;
	
protected:
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
	__classmethod virtual bool __fastcall CheckListing(System::Classes::TStrings* AListing, const System::UnicodeString ASysDescript = System::UnicodeString(), const bool ADetails = true);
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPOS2(void) : Idftplistparsebase::TIdFTPLPBaseDOS() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPOS2(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
#define OS2PARSER L"OS/2"
}	/* namespace Idftplistparseos2 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDFTPLISTPARSEOS2)
using namespace Idftplistparseos2;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Idftplistparseos2HPP
