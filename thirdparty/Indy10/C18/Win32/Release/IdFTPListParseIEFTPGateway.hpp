// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdFTPListParseIEFTPGateway.pas' rev: 25.00 (Windows)

#ifndef IdftplistparseieftpgatewayHPP
#define IdftplistparseieftpgatewayHPP

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
#pragma link "IdFTPListParseIEFTPGateway"

namespace Idftplistparseieftpgateway
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdIEFTPGatewayLsLongListItem;
class PASCALIMPLEMENTATION TIdIEFTPGatewayLsLongListItem : public Idftplist::TIdFTPListItem
{
	typedef Idftplist::TIdFTPListItem inherited;
	
protected:
	System::UnicodeString FSenderAcct;
	System::UnicodeString FSenderUserID;
	System::UnicodeString FMClass;
	
public:
	__property System::UnicodeString SenderAcct = {read=FSenderAcct, write=FSenderAcct};
	__property System::UnicodeString SenderUserID = {read=FSenderUserID, write=FSenderUserID};
	__property System::UnicodeString MClass = {read=FMClass, write=FMClass};
public:
	/* TIdFTPListItem.Create */ inline __fastcall virtual TIdIEFTPGatewayLsLongListItem(System::Classes::TCollection* AOwner) : Idftplist::TIdFTPListItem(AOwner) { }
	
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdIEFTPGatewayLsLongListItem(void) { }
	
};


class DELPHICLASS TIdIEFTPGatewayLsShortListItem;
class PASCALIMPLEMENTATION TIdIEFTPGatewayLsShortListItem : public Idftplisttypes::TIdMinimalFTPListItem
{
	typedef Idftplisttypes::TIdMinimalFTPListItem inherited;
	
public:
	/* TIdMinimalFTPListItem.Create */ inline __fastcall virtual TIdIEFTPGatewayLsShortListItem(System::Classes::TCollection* AOwner) : Idftplisttypes::TIdMinimalFTPListItem(AOwner) { }
	
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdIEFTPGatewayLsShortListItem(void) { }
	
};


class DELPHICLASS TIdIEFTPGatewayLsFileNameListItem;
class PASCALIMPLEMENTATION TIdIEFTPGatewayLsFileNameListItem : public Idftplisttypes::TIdMinimalFTPListItem
{
	typedef Idftplisttypes::TIdMinimalFTPListItem inherited;
	
protected:
	System::UnicodeString FOrigFileName;
	
public:
	__property System::UnicodeString OrigFileName = {read=FOrigFileName, write=FOrigFileName};
public:
	/* TIdMinimalFTPListItem.Create */ inline __fastcall virtual TIdIEFTPGatewayLsFileNameListItem(System::Classes::TCollection* AOwner) : Idftplisttypes::TIdMinimalFTPListItem(AOwner) { }
	
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdIEFTPGatewayLsFileNameListItem(void) { }
	
};


class DELPHICLASS TIdIEFTPGatewayLSLibraryListItem;
class PASCALIMPLEMENTATION TIdIEFTPGatewayLSLibraryListItem : public Idftplisttypes::TIdUnixPermFTPListItem
{
	typedef Idftplisttypes::TIdUnixPermFTPListItem inherited;
	
protected:
	System::UnicodeString FAccount;
	
public:
	__property System::UnicodeString Account = {read=FAccount, write=FAccount};
public:
	/* TIdFTPListItem.Create */ inline __fastcall virtual TIdIEFTPGatewayLSLibraryListItem(System::Classes::TCollection* AOwner) : Idftplisttypes::TIdUnixPermFTPListItem(AOwner) { }
	
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdIEFTPGatewayLSLibraryListItem(void) { }
	
};


class DELPHICLASS TIdFTPLPIEFTPGatewayLSLong;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPIEFTPGatewayLSLong : public Idftplistparsebase::TIdFTPListBaseHeader
{
	typedef Idftplistparsebase::TIdFTPListBaseHeader inherited;
	
protected:
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	__classmethod virtual bool __fastcall IsHeader(const System::UnicodeString AData);
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPIEFTPGatewayLSLong(void) : Idftplistparsebase::TIdFTPListBaseHeader() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPIEFTPGatewayLSLong(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdFTPLPIEFTPGatewayLSShort;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPIEFTPGatewayLSShort : public Idftplistparsebase::TIdFTPLPNList
{
	typedef Idftplistparsebase::TIdFTPLPNList inherited;
	
protected:
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
	__classmethod virtual bool __fastcall CheckListing(System::Classes::TStrings* AListing, const System::UnicodeString ASysDescript = System::UnicodeString(), const bool ADetails = true);
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPIEFTPGatewayLSShort(void) : Idftplistparsebase::TIdFTPLPNList() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPIEFTPGatewayLSShort(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdFTPLPIEFTPGatewayLSFileName;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPIEFTPGatewayLSFileName : public Idftplistparsebase::TIdFTPListBase
{
	typedef Idftplistparsebase::TIdFTPListBase inherited;
	
protected:
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
	__classmethod virtual bool __fastcall CheckListing(System::Classes::TStrings* AListing, const System::UnicodeString ASysDescript = System::UnicodeString(), const bool ADetails = true);
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPIEFTPGatewayLSFileName(void) : Idftplistparsebase::TIdFTPListBase() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPIEFTPGatewayLSFileName(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdFTPLPIEFTPGatewayLSLibrary;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPIEFTPGatewayLSLibrary : public Idftplistparsebase::TIdFTPListBaseHeader
{
	typedef Idftplistparsebase::TIdFTPListBaseHeader inherited;
	
protected:
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	__classmethod virtual bool __fastcall IsHeader(const System::UnicodeString AData);
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPIEFTPGatewayLSLibrary(void) : Idftplistparsebase::TIdFTPListBaseHeader() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPIEFTPGatewayLSLibrary(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idftplistparseieftpgateway */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDFTPLISTPARSEIEFTPGATEWAY)
using namespace Idftplistparseieftpgateway;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdftplistparseieftpgatewayHPP
