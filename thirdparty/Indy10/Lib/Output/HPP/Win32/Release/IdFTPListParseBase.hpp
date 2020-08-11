// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdFTPListParseBase.pas' rev: 25.00 (Windows)

#ifndef IdftplistparsebaseHPP
#define IdftplistparsebaseHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdFTPList.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idftplistparsebase
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdFTPListBase;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPListBase : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
	__classmethod virtual bool __fastcall CheckListing(System::Classes::TStrings* AListing, const System::UnicodeString ASysDescript = System::UnicodeString(), const bool ADetails = true);
	__classmethod virtual bool __fastcall ParseListing(System::Classes::TStrings* AListing, Idftplist::TIdFTPListItems* ADir);
public:
	/* TObject.Create */ inline __fastcall TIdFTPListBase(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPListBase(void) { }
	
};

#pragma pack(pop)

typedef System::TMetaClass* TIdFTPListParseClass;

class DELPHICLASS TIdFTPListBaseHeader;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPListBaseHeader : public TIdFTPListBase
{
	typedef TIdFTPListBase inherited;
	
protected:
	__classmethod virtual bool __fastcall IsHeader(const System::UnicodeString AData);
	__classmethod virtual bool __fastcall IsFooter(const System::UnicodeString AData);
	
public:
	__classmethod virtual bool __fastcall CheckListing(System::Classes::TStrings* AListing, const System::UnicodeString ASysDescript = System::UnicodeString(), const bool ADetails = true);
	__classmethod virtual bool __fastcall ParseListing(System::Classes::TStrings* AListing, Idftplist::TIdFTPListItems* ADir);
public:
	/* TObject.Create */ inline __fastcall TIdFTPListBaseHeader(void) : TIdFTPListBase() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPListBaseHeader(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdFTPListBaseHeaderOpt;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPListBaseHeaderOpt : public TIdFTPListBaseHeader
{
	typedef TIdFTPListBaseHeader inherited;
	
protected:
	__classmethod virtual bool __fastcall CheckListingAlt(System::Classes::TStrings* AListing, const System::UnicodeString ASysDescript = System::UnicodeString(), const bool ADetails = true);
	
public:
	__classmethod virtual bool __fastcall CheckListing(System::Classes::TStrings* AListing, const System::UnicodeString ASysDescript = System::UnicodeString(), const bool ADetails = true);
public:
	/* TObject.Create */ inline __fastcall TIdFTPListBaseHeaderOpt(void) : TIdFTPListBaseHeader() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPListBaseHeaderOpt(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdFTPLineOwnedList;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLineOwnedList : public TIdFTPListBase
{
	typedef TIdFTPListBase inherited;
	
protected:
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
public:
	/* TObject.Create */ inline __fastcall TIdFTPLineOwnedList(void) : TIdFTPListBase() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLineOwnedList(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdFTPLPNList;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPNList : public TIdFTPListBase
{
	typedef TIdFTPListBase inherited;
	
protected:
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
	__classmethod virtual bool __fastcall CheckListing(System::Classes::TStrings* AListing, const System::UnicodeString ASysDescript = System::UnicodeString(), const bool ADetails = true);
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPNList(void) : TIdFTPListBase() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPNList(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdFTPLPMList;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPMList : public TIdFTPListBase
{
	typedef TIdFTPListBase inherited;
	
protected:
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
	__classmethod virtual bool __fastcall CheckListing(System::Classes::TStrings* AListing, const System::UnicodeString ASysDescript = System::UnicodeString(), const bool ADetails = true);
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPMList(void) : TIdFTPListBase() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPMList(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdFTPLPBaseDOS;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPBaseDOS : public TIdFTPListBase
{
	typedef TIdFTPListBase inherited;
	
protected:
	__classmethod virtual bool __fastcall IsValidAttr(const System::UnicodeString AAttr);
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPBaseDOS(void) : TIdFTPListBase() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPBaseDOS(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdFTPListParseError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdFTPListParseError : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdFTPListParseError(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdFTPListParseError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdFTPListParseError(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdFTPListParseError(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdFTPListParseError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdFTPListParseError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdFTPListParseError(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdFTPListParseError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdFTPListParseError(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdFTPListParseError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdFTPListParseError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdFTPListParseError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdFTPListParseError(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
#define NLST L"NLST"
#define MLST L"MLST"
extern DELPHI_PACKAGE void __fastcall RegisterFTPListParser(const TIdFTPListParseClass AParser);
extern DELPHI_PACKAGE void __fastcall UnregisterFTPListParser(const TIdFTPListParseClass AParser);
extern DELPHI_PACKAGE bool __fastcall ParseListing(System::Classes::TStrings* AListing, Idftplist::TIdFTPListItems* ADir, const System::UnicodeString AFormatID);
extern DELPHI_PACKAGE bool __fastcall CheckListParse(System::Classes::TStrings* AListing, Idftplist::TIdFTPListItems* ADir, System::UnicodeString &AFormat, const System::UnicodeString ASysDescript = System::UnicodeString(), const bool ADetails = true);
extern DELPHI_PACKAGE System::UnicodeString __fastcall CheckListing(System::Classes::TStrings* AListing, const System::UnicodeString ASysDescript = System::UnicodeString(), const bool ADetails = true);
extern DELPHI_PACKAGE bool __fastcall CheckListParseCapa(System::Classes::TStrings* AListing, Idftplist::TIdFTPListItems* ADir, System::UnicodeString &VFormat, TIdFTPListParseClass &VClass, const System::UnicodeString ASysDescript, const bool ADetails = true);
extern DELPHI_PACKAGE void __fastcall EnumFTPListParsers(System::Classes::TStrings* AData);
}	/* namespace Idftplistparsebase */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDFTPLISTPARSEBASE)
using namespace Idftplistparsebase;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdftplistparsebaseHPP
