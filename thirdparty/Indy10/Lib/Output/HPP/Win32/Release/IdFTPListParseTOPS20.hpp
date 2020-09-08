// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdFTPListParseTOPS20.pas' rev: 25.00 (Windows)

#ifndef Idftplistparsetops20HPP
#define Idftplistparsetops20HPP

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
#pragma link "IdFTPListParseTOPS20"

namespace Idftplistparsetops20
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdTOPS20FTPListItem;
class PASCALIMPLEMENTATION TIdTOPS20FTPListItem : public Idftplisttypes::TIdCreationDateFTPListItem
{
	typedef Idftplisttypes::TIdCreationDateFTPListItem inherited;
	
public:
	/* TIdCreationDateFTPListItem.Create */ inline __fastcall virtual TIdTOPS20FTPListItem(System::Classes::TCollection* AOwner) : Idftplisttypes::TIdCreationDateFTPListItem(AOwner) { }
	
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdTOPS20FTPListItem(void) { }
	
};


class DELPHICLASS TIdFTPLPTOPS20;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPTOPS20 : public Idftplistparsebase::TIdFTPListBase
{
	typedef Idftplistparsebase::TIdFTPListBase inherited;
	
protected:
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
	__classmethod virtual bool __fastcall CheckListing(System::Classes::TStrings* AListing, const System::UnicodeString ASysDescript = System::UnicodeString(), const bool ADetails = true);
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPTOPS20(void) : Idftplistparsebase::TIdFTPListBase() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPTOPS20(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
#define TOPS20_VOLPATH_SEP L":<"
static const System::WideChar TOPS20_DIRFILE_SEP = (System::WideChar)(0x3e);
}	/* namespace Idftplistparsetops20 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDFTPLISTPARSETOPS20)
using namespace Idftplistparsetops20;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Idftplistparsetops20HPP
