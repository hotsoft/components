// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdFTPListParseUnisysClearPath.pas' rev: 25.00 (Windows)

#ifndef IdftplistparseunisysclearpathHPP
#define IdftplistparseunisysclearpathHPP

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
#pragma link "IdFTPListParseUnisysClearPath"

namespace Idftplistparseunisysclearpath
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdUnisysClearPathFTPListItem;
class PASCALIMPLEMENTATION TIdUnisysClearPathFTPListItem : public Idftplisttypes::TIdCreationDateFTPListItem
{
	typedef Idftplisttypes::TIdCreationDateFTPListItem inherited;
	
protected:
	System::UnicodeString FFileKind;
	
public:
	__property System::UnicodeString FileKind = {read=FFileKind, write=FFileKind};
public:
	/* TIdCreationDateFTPListItem.Create */ inline __fastcall virtual TIdUnisysClearPathFTPListItem(System::Classes::TCollection* AOwner) : Idftplisttypes::TIdCreationDateFTPListItem(AOwner) { }
	
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdUnisysClearPathFTPListItem(void) { }
	
};


class DELPHICLASS TIdFTPLPUnisysClearPath;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPUnisysClearPath : public Idftplistparsebase::TIdFTPListBaseHeader
{
	typedef Idftplistparsebase::TIdFTPListBaseHeader inherited;
	
protected:
	__classmethod bool __fastcall IsContinuedLine(const System::UnicodeString AData);
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	__classmethod virtual bool __fastcall IsHeader(const System::UnicodeString AData);
	__classmethod virtual bool __fastcall IsFooter(const System::UnicodeString AData);
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	
public:
	__classmethod virtual bool __fastcall ParseListing(System::Classes::TStrings* AListing, Idftplist::TIdFTPListItems* ADir);
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPUnisysClearPath(void) : Idftplistparsebase::TIdFTPListBaseHeader() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPUnisysClearPath(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idftplistparseunisysclearpath */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDFTPLISTPARSEUNISYSCLEARPATH)
using namespace Idftplistparseunisysclearpath;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdftplistparseunisysclearpathHPP
