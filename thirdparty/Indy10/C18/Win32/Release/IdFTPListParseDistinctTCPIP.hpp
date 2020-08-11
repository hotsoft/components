// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdFTPListParseDistinctTCPIP.pas' rev: 25.00 (Windows)

#ifndef IdftplistparsedistincttcpipHPP
#define IdftplistparsedistincttcpipHPP

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
#pragma link "IdFTPListParseDistinctTCPIP"

namespace Idftplistparsedistincttcpip
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdDistinctTCPIPFTPListItem;
class PASCALIMPLEMENTATION TIdDistinctTCPIPFTPListItem : public Idftplisttypes::TIdDOSBaseFTPListItem
{
	typedef Idftplisttypes::TIdDOSBaseFTPListItem inherited;
	
protected:
	System::UnicodeString FDist32FileAttributes;
	
public:
	__property ModifiedDateGMT = {default=0};
	__property System::UnicodeString Dist32FileAttributes = {read=FDist32FileAttributes, write=FDist32FileAttributes};
public:
	/* TIdDOSBaseFTPListItem.Create */ inline __fastcall virtual TIdDistinctTCPIPFTPListItem(System::Classes::TCollection* AOwner) : Idftplisttypes::TIdDOSBaseFTPListItem(AOwner) { }
	/* TIdDOSBaseFTPListItem.Destroy */ inline __fastcall virtual ~TIdDistinctTCPIPFTPListItem(void) { }
	
};


class DELPHICLASS TIdFTPLPDistinctTCPIP;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPDistinctTCPIP : public Idftplistparsebase::TIdFTPLPBaseDOS
{
	typedef Idftplistparsebase::TIdFTPLPBaseDOS inherited;
	
protected:
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
	__classmethod virtual bool __fastcall CheckListing(System::Classes::TStrings* AListing, const System::UnicodeString ASysDescript = System::UnicodeString(), const bool ADetails = true);
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPDistinctTCPIP(void) : Idftplistparsebase::TIdFTPLPBaseDOS() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPDistinctTCPIP(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idftplistparsedistincttcpip */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDFTPLISTPARSEDISTINCTTCPIP)
using namespace Idftplistparsedistincttcpip;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdftplistparsedistincttcpipHPP
