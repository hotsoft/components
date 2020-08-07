// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdFTPListParseStratusVOS.pas' rev: 25.00 (Windows)

#ifndef IdftplistparsestratusvosHPP
#define IdftplistparsestratusvosHPP

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
#pragma link "IdFTPListParseStratusVOS"

namespace Idftplistparsestratusvos
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdStratusVOSFTPListItem;
class PASCALIMPLEMENTATION TIdStratusVOSFTPListItem : public Idftplist::TIdFTPListItem
{
	typedef Idftplist::TIdFTPListItem inherited;
	
protected:
	System::UnicodeString FAccess;
	int FNumberBlocks;
	int FBlockSize;
	System::UnicodeString FFileFormat;
	System::UnicodeString FLinkedItemName;
	
public:
	__property System::UnicodeString Access = {read=FAccess, write=FAccess};
	__property int NumberBlocks = {read=FNumberBlocks, write=FNumberBlocks, nodefault};
	__property int BlockSize = {read=FBlockSize, write=FBlockSize, nodefault};
	__property System::UnicodeString FileFormat = {read=FFileFormat, write=FFileFormat};
	__property System::UnicodeString LinkedItemName = {read=FLinkedItemName, write=FLinkedItemName};
public:
	/* TIdFTPListItem.Create */ inline __fastcall virtual TIdStratusVOSFTPListItem(System::Classes::TCollection* AOwner) : Idftplist::TIdFTPListItem(AOwner) { }
	
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdStratusVOSFTPListItem(void) { }
	
};


class DELPHICLASS TIdFTPLPStratusVOS;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPStratusVOS : public Idftplistparsebase::TIdFTPListBase
{
	typedef Idftplistparsebase::TIdFTPListBase inherited;
	
protected:
	__classmethod bool __fastcall IsValidFileEntry(const System::UnicodeString ALine);
	__classmethod bool __fastcall IsValidDirEntry(const System::UnicodeString ALine);
	__classmethod bool __fastcall IsFilesHeader(const System::UnicodeString ALine);
	__classmethod bool __fastcall IsDirsHeader(const System::UnicodeString ALine);
	__classmethod bool __fastcall IsLinksHeader(const System::UnicodeString ALine);
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	__classmethod bool __fastcall ParseDirEntry(Idftplist::TIdFTPListItem* const AItem);
	__classmethod bool __fastcall ParseFileEntry(Idftplist::TIdFTPListItem* const AItem);
	__classmethod bool __fastcall ParseLinkEntry(Idftplist::TIdFTPListItem* const AItem);
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
	__classmethod virtual bool __fastcall CheckListing(System::Classes::TStrings* AListing, const System::UnicodeString ASysDescript = System::UnicodeString(), const bool ADetails = true);
	__classmethod virtual bool __fastcall ParseListing(System::Classes::TStrings* AListing, Idftplist::TIdFTPListItems* ADir);
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPStratusVOS(void) : Idftplistparsebase::TIdFTPListBase() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPStratusVOS(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idftplistparsestratusvos */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDFTPLISTPARSESTRATUSVOS)
using namespace Idftplistparsestratusvos;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdftplistparsestratusvosHPP
