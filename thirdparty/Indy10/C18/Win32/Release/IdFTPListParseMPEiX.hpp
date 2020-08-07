// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdFTPListParseMPEiX.pas' rev: 25.00 (Windows)

#ifndef IdftplistparsempeixHPP
#define IdftplistparsempeixHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdFTPList.hpp>	// Pascal unit
#include <IdFTPListParseBase.hpp>	// Pascal unit
#include <IdFTPListTypes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------
#pragma link "IdFTPListParseMPEiX"

namespace Idftplistparsempeix
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdMPiXFTPListItem;
class PASCALIMPLEMENTATION TIdMPiXFTPListItem : public Idftplisttypes::TIdRecFTPListItem
{
	typedef Idftplisttypes::TIdRecFTPListItem inherited;
	
protected:
	unsigned FLimit;
	
public:
	__fastcall virtual TIdMPiXFTPListItem(System::Classes::TCollection* AOwner);
	__property RecLength;
	__property RecFormat = {default=0};
	__property NumberRecs;
	__property unsigned Limit = {read=FLimit, write=FLimit, nodefault};
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdMPiXFTPListItem(void) { }
	
};


class DELPHICLASS TIdFTPLPMPiXBase;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPMPiXBase : public Idftplistparsebase::TIdFTPListBaseHeader
{
	typedef Idftplistparsebase::TIdFTPListBaseHeader inherited;
	
protected:
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	__classmethod virtual bool __fastcall IsSecondHeader(System::Classes::TStrings* ACols);
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPMPiXBase(void) : Idftplistparsebase::TIdFTPListBaseHeader() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPMPiXBase(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdFTPLPMPiX;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPMPiX : public TIdFTPLPMPiXBase
{
	typedef TIdFTPLPMPiXBase inherited;
	
protected:
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	__classmethod virtual bool __fastcall IsHeader(const System::UnicodeString AData);
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPMPiX(void) : TIdFTPLPMPiXBase() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPMPiX(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdFTPLPMPiXWithPOSIX;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPMPiXWithPOSIX : public TIdFTPLPMPiXBase
{
	typedef TIdFTPLPMPiXBase inherited;
	
protected:
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	__classmethod virtual bool __fastcall IsHeader(const System::UnicodeString AData);
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPMPiXWithPOSIX(void) : TIdFTPLPMPiXBase() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPMPiXWithPOSIX(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idftplistparsempeix */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDFTPLISTPARSEMPEIX)
using namespace Idftplistparsempeix;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdftplistparsempeixHPP
