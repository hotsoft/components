// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdFTPListParseUnix.pas' rev: 25.00 (Windows)

#ifndef IdftplistparseunixHPP
#define IdftplistparseunixHPP

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
#pragma link "IdFTPListParseUnix"

namespace Idftplistparseunix
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdUnixFTPListItem;
class PASCALIMPLEMENTATION TIdUnixFTPListItem : public Idftplisttypes::TIdUnixBaseFTPListItem
{
	typedef Idftplisttypes::TIdUnixBaseFTPListItem inherited;
	
protected:
	int FNumberBlocks;
	int FInode;
	
public:
	__property int NumberBlocks = {read=FNumberBlocks, write=FNumberBlocks, nodefault};
	__property int Inode = {read=FInode, write=FInode, nodefault};
public:
	/* TIdFTPListItem.Create */ inline __fastcall virtual TIdUnixFTPListItem(System::Classes::TCollection* AOwner) : Idftplisttypes::TIdUnixBaseFTPListItem(AOwner) { }
	
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdUnixFTPListItem(void) { }
	
};


class DELPHICLASS TIdUnitreeFTPListItem;
class PASCALIMPLEMENTATION TIdUnitreeFTPListItem : public TIdUnixFTPListItem
{
	typedef TIdUnixFTPListItem inherited;
	
protected:
	bool FMigrated;
	System::UnicodeString FFileFamily;
	
public:
	__property bool Migrated = {read=FMigrated, write=FMigrated, nodefault};
	__property System::UnicodeString FileFamily = {read=FFileFamily, write=FFileFamily};
public:
	/* TIdFTPListItem.Create */ inline __fastcall virtual TIdUnitreeFTPListItem(System::Classes::TCollection* AOwner) : TIdUnixFTPListItem(AOwner) { }
	
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdUnitreeFTPListItem(void) { }
	
};


class DELPHICLASS TIdFTPLPUnix;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPUnix : public Idftplistparsebase::TIdFTPListBase
{
	typedef Idftplistparsebase::TIdFTPListBase inherited;
	
protected:
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	__classmethod virtual bool __fastcall InternelChkUnix(const System::UnicodeString AData);
	__classmethod virtual bool __fastcall IsUnitree(const System::UnicodeString AData);
	__classmethod virtual bool __fastcall IsUnitreeBanner(const System::UnicodeString AData);
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
	__classmethod virtual bool __fastcall CheckListing(System::Classes::TStrings* AListing, const System::UnicodeString ASysDescript = System::UnicodeString(), const bool ADetails = true);
	__classmethod virtual bool __fastcall ParseListing(System::Classes::TStrings* AListing, Idftplist::TIdFTPListItems* ADir);
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPUnix(void) : Idftplistparsebase::TIdFTPListBase() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPUnix(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdFTPLPUnitree;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPUnitree : public TIdFTPLPUnix
{
	typedef TIdFTPLPUnix inherited;
	
protected:
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPUnitree(void) : TIdFTPLPUnix() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPUnitree(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
#define UNIX L"Unix"
#define UNITREE L"Unitree"
}	/* namespace Idftplistparseunix */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDFTPLISTPARSEUNIX)
using namespace Idftplistparseunix;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdftplistparseunixHPP
