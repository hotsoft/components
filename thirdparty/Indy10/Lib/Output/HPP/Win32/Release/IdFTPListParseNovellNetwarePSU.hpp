// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdFTPListParseNovellNetwarePSU.pas' rev: 25.00 (Windows)

#ifndef IdftplistparsenovellnetwarepsuHPP
#define IdftplistparsenovellnetwarepsuHPP

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
#pragma link "IdFTPListParseNovellNetwarePSU"

namespace Idftplistparsenovellnetwarepsu
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdNovellPSU_DOSFTPListItem;
class PASCALIMPLEMENTATION TIdNovellPSU_DOSFTPListItem : public Idftplisttypes::TIdNovellBaseFTPListItem
{
	typedef Idftplisttypes::TIdNovellBaseFTPListItem inherited;
	
public:
	/* TIdFTPListItem.Create */ inline __fastcall virtual TIdNovellPSU_DOSFTPListItem(System::Classes::TCollection* AOwner) : Idftplisttypes::TIdNovellBaseFTPListItem(AOwner) { }
	
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdNovellPSU_DOSFTPListItem(void) { }
	
};


class DELPHICLASS TIdFTPLPNetwarePSUDos;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPNetwarePSUDos : public Idftplistparsebase::TIdFTPListBase
{
	typedef Idftplistparsebase::TIdFTPListBase inherited;
	
protected:
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
	__classmethod virtual bool __fastcall CheckListing(System::Classes::TStrings* AListing, const System::UnicodeString ASysDescript = System::UnicodeString(), const bool ADetails = true);
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPNetwarePSUDos(void) : Idftplistparsebase::TIdFTPListBase() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPNetwarePSUDos(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdNovellPSU_NFSFTPListItem;
class PASCALIMPLEMENTATION TIdNovellPSU_NFSFTPListItem : public Idftplisttypes::TIdUnixBaseFTPListItem
{
	typedef Idftplisttypes::TIdUnixBaseFTPListItem inherited;
	
public:
	/* TIdFTPListItem.Create */ inline __fastcall virtual TIdNovellPSU_NFSFTPListItem(System::Classes::TCollection* AOwner) : Idftplisttypes::TIdUnixBaseFTPListItem(AOwner) { }
	
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdNovellPSU_NFSFTPListItem(void) { }
	
};


class DELPHICLASS TIdFTPLPNetwarePSUNFS;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPNetwarePSUNFS : public Idftplistparsebase::TIdFTPListBase
{
	typedef Idftplistparsebase::TIdFTPListBase inherited;
	
protected:
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
	__classmethod virtual bool __fastcall CheckListing(System::Classes::TStrings* AListing, const System::UnicodeString ASysDescript = System::UnicodeString(), const bool ADetails = true);
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPNetwarePSUNFS(void) : Idftplistparsebase::TIdFTPListBase() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPNetwarePSUNFS(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
#define NOVELLNETWAREPSU L"Novell Netware Print Services for Unix:  "
}	/* namespace Idftplistparsenovellnetwarepsu */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDFTPLISTPARSENOVELLNETWAREPSU)
using namespace Idftplistparsenovellnetwarepsu;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdftplistparsenovellnetwarepsuHPP
