// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdFTPList.pas' rev: 25.00 (Windows)

#ifndef IdftplistHPP
#define IdftplistHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdFTPCommon.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idftplist
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS EIdInvalidFTPListingFormat;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdInvalidFTPListingFormat : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdInvalidFTPListingFormat(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdInvalidFTPListingFormat(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdInvalidFTPListingFormat(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdInvalidFTPListingFormat(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdInvalidFTPListingFormat(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdInvalidFTPListingFormat(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdInvalidFTPListingFormat(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdInvalidFTPListingFormat(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdInvalidFTPListingFormat(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdInvalidFTPListingFormat(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdInvalidFTPListingFormat(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdInvalidFTPListingFormat(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdInvalidFTPListingFormat(void) { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TIdDirItemType : unsigned char { ditDirectory, ditFile, ditSymbolicLink, ditSymbolicLinkDir, ditBlockDev, ditCharDev, ditFIFO, ditSocket };

typedef System::UnicodeString TIdFTPFileName;

class DELPHICLASS TIdFTPListItem;
class PASCALIMPLEMENTATION TIdFTPListItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
protected:
	__int64 FSize;
	System::UnicodeString FData;
	System::UnicodeString FFileName;
	System::UnicodeString FLocalFileName;
	bool FSizeAvail;
	bool FModifiedAvail;
	System::TDateTime FModifiedDate;
	System::TDateTime FModifiedDateGMT;
	TIdDirItemType FItemType;
	bool FDirError;
	System::UnicodeString FPermissionDisplay;
	void __fastcall SetFileName(const System::UnicodeString AValue);
	__property System::TDateTime ModifiedDateGMT = {read=FModifiedDateGMT, write=FModifiedDateGMT};
	
public:
	__fastcall virtual TIdFTPListItem(System::Classes::TCollection* AOwner);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__property System::UnicodeString Data = {read=FData, write=FData};
	__property __int64 Size = {read=FSize, write=FSize};
	__property System::TDateTime ModifiedDate = {read=FModifiedDate, write=FModifiedDate};
	__property System::UnicodeString FileName = {read=FFileName, write=SetFileName};
	__property System::UnicodeString LocalFileName = {read=FLocalFileName, write=FLocalFileName};
	__property TIdDirItemType ItemType = {read=FItemType, write=FItemType, nodefault};
	__property bool SizeAvail = {read=FSizeAvail, write=FSizeAvail, nodefault};
	__property bool ModifiedAvail = {read=FModifiedAvail, write=FModifiedAvail, nodefault};
	__property System::UnicodeString PermissionDisplay = {read=FPermissionDisplay, write=FPermissionDisplay};
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdFTPListItem(void) { }
	
};


typedef void __fastcall (__closure *TIdFTPListOnGetCustomListFormat)(TIdFTPListItem* AItem, System::UnicodeString &VText);

typedef void __fastcall (__closure *TIdOnParseCustomListFormat)(TIdFTPListItem* AItem);

class DELPHICLASS TIdFTPListItems;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPListItems : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TIdFTPListItem* operator[](int AIndex) { return Items[AIndex]; }
	
protected:
	System::UnicodeString FDirectoryName;
	void __fastcall SetDirectoryName(const System::UnicodeString AValue);
	TIdFTPListItem* __fastcall GetItems(int AIndex);
	void __fastcall SetItems(int AIndex, TIdFTPListItem* const Value);
	
public:
	HIDESBASE TIdFTPListItem* __fastcall Add(void);
	__fastcall TIdFTPListItems(void);
	int __fastcall IndexOf(TIdFTPListItem* AItem);
	__property System::UnicodeString DirectoryName = {read=FDirectoryName, write=SetDirectoryName};
	__property TIdFTPListItem* Items[int AIndex] = {read=GetItems, write=SetItems/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TIdFTPListItems(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idftplist */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDFTPLIST)
using namespace Idftplist;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdftplistHPP
