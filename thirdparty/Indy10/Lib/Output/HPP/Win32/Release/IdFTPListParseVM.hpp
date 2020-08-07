// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdFTPListParseVM.pas' rev: 25.00 (Windows)

#ifndef IdftplistparsevmHPP
#define IdftplistparsevmHPP

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
#pragma link "IdFTPListParseVM"

namespace Idftplistparsevm
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdVMCMSFTPListItem;
class PASCALIMPLEMENTATION TIdVMCMSFTPListItem : public Idftplisttypes::TIdRecFTPListItem
{
	typedef Idftplisttypes::TIdRecFTPListItem inherited;
	
protected:
	System::UnicodeString FOwnerName;
	int FNumberBlocks;
	
public:
	__property int RecLength = {read=FRecLength, write=FRecLength, nodefault};
	__property System::UnicodeString RecFormat = {read=FRecFormat, write=FRecFormat};
	__property int NumberRecs = {read=FNumberRecs, write=FNumberRecs, nodefault};
	__property System::UnicodeString OwnerName = {read=FOwnerName, write=FOwnerName};
	__property int NumberBlocks = {read=FNumberBlocks, write=FNumberBlocks, nodefault};
public:
	/* TIdFTPListItem.Create */ inline __fastcall virtual TIdVMCMSFTPListItem(System::Classes::TCollection* AOwner) : Idftplisttypes::TIdRecFTPListItem(AOwner) { }
	
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdVMCMSFTPListItem(void) { }
	
};


class DELPHICLASS TIdVMVirtualReaderFTPListItem;
class PASCALIMPLEMENTATION TIdVMVirtualReaderFTPListItem : public Idftplist::TIdFTPListItem
{
	typedef Idftplist::TIdFTPListItem inherited;
	
protected:
	int FNumberRecs;
	
public:
	__fastcall virtual TIdVMVirtualReaderFTPListItem(System::Classes::TCollection* AOwner);
	__property int NumberRecs = {read=FNumberRecs, write=FNumberRecs, nodefault};
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdVMVirtualReaderFTPListItem(void) { }
	
};


class DELPHICLASS TIdVMBFSFTPListItem;
class PASCALIMPLEMENTATION TIdVMBFSFTPListItem : public Idftplist::TIdFTPListItem
{
	typedef Idftplist::TIdFTPListItem inherited;
	
public:
	/* TIdFTPListItem.Create */ inline __fastcall virtual TIdVMBFSFTPListItem(System::Classes::TCollection* AOwner) : Idftplist::TIdFTPListItem(AOwner) { }
	
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdVMBFSFTPListItem(void) { }
	
};


class DELPHICLASS TIdFTPLPVMCMS;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPVMCMS : public Idftplistparsebase::TIdFTPListBaseHeaderOpt
{
	typedef Idftplistparsebase::TIdFTPListBaseHeaderOpt inherited;
	
protected:
	__classmethod virtual bool __fastcall IsHeader(const System::UnicodeString AData);
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	__classmethod virtual bool __fastcall CheckListingAlt(System::Classes::TStrings* AListing, const System::UnicodeString ASysDescript = System::UnicodeString(), const bool ADetails = true);
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPVMCMS(void) : Idftplistparsebase::TIdFTPListBaseHeaderOpt() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPVMCMS(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdFTPLPVMBFS;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPVMBFS : public Idftplistparsebase::TIdFTPListBase
{
	typedef Idftplistparsebase::TIdFTPListBase inherited;
	
protected:
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
	__classmethod virtual bool __fastcall CheckListing(System::Classes::TStrings* AListing, const System::UnicodeString ASysDescript = System::UnicodeString(), const bool ADetails = true);
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPVMBFS(void) : Idftplistparsebase::TIdFTPListBase() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPVMBFS(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdFTPLVirtualReader;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLVirtualReader : public Idftplistparsebase::TIdFTPListBase
{
	typedef Idftplistparsebase::TIdFTPListBase inherited;
	
protected:
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
	__classmethod virtual bool __fastcall CheckListing(System::Classes::TStrings* AListing, const System::UnicodeString ASysDescript = System::UnicodeString(), const bool ADetails = true);
public:
	/* TObject.Create */ inline __fastcall TIdFTPLVirtualReader(void) : Idftplistparsebase::TIdFTPListBase() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLVirtualReader(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idftplistparsevm */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDFTPLISTPARSEVM)
using namespace Idftplistparsevm;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdftplistparsevmHPP
