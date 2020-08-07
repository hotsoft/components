// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdFTPListParseStercomUnixEnt.pas' rev: 25.00 (Windows)

#ifndef IdftplistparsestercomunixentHPP
#define IdftplistparsestercomunixentHPP

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
#pragma link "IdFTPListParseStercomUnixEnt"

namespace Idftplistparsestercomunixent
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdSterCommEntUxFTPListItem;
class PASCALIMPLEMENTATION TIdSterCommEntUxFTPListItem : public Idftplisttypes::TIdOwnerFTPListItem
{
	typedef Idftplisttypes::TIdOwnerFTPListItem inherited;
	
protected:
	System::UnicodeString FFlagsProt;
	System::UnicodeString FProtIndicator;
	
public:
	__property System::UnicodeString FlagsProt = {read=FFlagsProt, write=FFlagsProt};
	__property System::UnicodeString ProtIndicator = {read=FProtIndicator, write=FProtIndicator};
public:
	/* TIdFTPListItem.Create */ inline __fastcall virtual TIdSterCommEntUxFTPListItem(System::Classes::TCollection* AOwner) : Idftplisttypes::TIdOwnerFTPListItem(AOwner) { }
	
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdSterCommEntUxFTPListItem(void) { }
	
};


class DELPHICLASS TIdFTPLPSterComEntBase;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPSterComEntBase : public Idftplistparsebase::TIdFTPListBaseHeader
{
	typedef Idftplistparsebase::TIdFTPListBaseHeader inherited;
	
protected:
	__classmethod virtual bool __fastcall IsFooter(const System::UnicodeString AData);
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPSterComEntBase(void) : Idftplistparsebase::TIdFTPListBaseHeader() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPSterComEntBase(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdFTPLPSterCommEntUx;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPSterCommEntUx : public TIdFTPLPSterComEntBase
{
	typedef TIdFTPLPSterComEntBase inherited;
	
protected:
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
	__classmethod virtual bool __fastcall CheckListing(System::Classes::TStrings* AListing, const System::UnicodeString ASysDescript = System::UnicodeString(), const bool ADetails = true);
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPSterCommEntUx(void) : TIdFTPLPSterComEntBase() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPSterCommEntUx(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdSterCommEntUxNSFTPListItem;
class PASCALIMPLEMENTATION TIdSterCommEntUxNSFTPListItem : public Idftplisttypes::TIdOwnerFTPListItem
{
	typedef Idftplisttypes::TIdOwnerFTPListItem inherited;
	
public:
	/* TIdFTPListItem.Create */ inline __fastcall virtual TIdSterCommEntUxNSFTPListItem(System::Classes::TCollection* AOwner) : Idftplisttypes::TIdOwnerFTPListItem(AOwner) { }
	
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdSterCommEntUxNSFTPListItem(void) { }
	
};


class DELPHICLASS TIdFTPLPSterCommEntUxNS;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPSterCommEntUxNS : public TIdFTPLPSterComEntBase
{
	typedef TIdFTPLPSterComEntBase inherited;
	
protected:
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	__classmethod void __fastcall StripPlus(System::UnicodeString &VString);
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
	__classmethod virtual bool __fastcall CheckListing(System::Classes::TStrings* AListing, const System::UnicodeString ASysDescript = System::UnicodeString(), const bool ADetails = true);
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPSterCommEntUxNS(void) : TIdFTPLPSterComEntBase() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPSterCommEntUxNS(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdSterCommEntUxRootFTPListItem;
class PASCALIMPLEMENTATION TIdSterCommEntUxRootFTPListItem : public Idftplisttypes::TIdMinimalFTPListItem
{
	typedef Idftplisttypes::TIdMinimalFTPListItem inherited;
	
public:
	/* TIdMinimalFTPListItem.Create */ inline __fastcall virtual TIdSterCommEntUxRootFTPListItem(System::Classes::TCollection* AOwner) : Idftplisttypes::TIdMinimalFTPListItem(AOwner) { }
	
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdSterCommEntUxRootFTPListItem(void) { }
	
};


class DELPHICLASS TIdFTPLPSterCommEntUxRoot;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPSterCommEntUxRoot : public TIdFTPLPSterComEntBase
{
	typedef TIdFTPLPSterComEntBase inherited;
	
protected:
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	__classmethod virtual bool __fastcall IsFooter(const System::UnicodeString AData);
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
	__classmethod virtual bool __fastcall CheckListing(System::Classes::TStrings* AListing, const System::UnicodeString ASysDescript = System::UnicodeString(), const bool ADetails = true);
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPSterCommEntUxRoot(void) : TIdFTPLPSterComEntBase() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPSterCommEntUxRoot(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
#define STIRCOMUNIX L"CONNECT:Enterprise for UNIX"
#define STIRCOMUNIXNS L"CONNECT:Enterprise for UNIX$$"
#define STIRCOMUNIXROOT L"CONNECT:Enterprise for UNIX ROOT"
}	/* namespace Idftplistparsestercomunixent */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDFTPLISTPARSESTERCOMUNIXENT)
using namespace Idftplistparsestercomunixent;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdftplistparsestercomunixentHPP
