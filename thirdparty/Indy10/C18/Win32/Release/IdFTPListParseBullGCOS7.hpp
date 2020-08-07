// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdFTPListParseBullGCOS7.pas' rev: 25.00 (Windows)

#ifndef Idftplistparsebullgcos7HPP
#define Idftplistparsebullgcos7HPP

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

//-- user supplied -----------------------------------------------------------
#pragma link "IdFTPListParseBullGCOS7"

namespace Idftplistparsebullgcos7
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdFTPLPGOS7;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPGOS7 : public Idftplistparsebase::TIdFTPLineOwnedList
{
	typedef Idftplistparsebase::TIdFTPLineOwnedList inherited;
	
protected:
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
	__classmethod virtual bool __fastcall CheckListing(System::Classes::TStrings* AListing, const System::UnicodeString ASysDescript = System::UnicodeString(), const bool ADetails = true);
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPGOS7(void) : Idftplistparsebase::TIdFTPLineOwnedList() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPGOS7(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idftplistparsebullgcos7 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDFTPLISTPARSEBULLGCOS7)
using namespace Idftplistparsebullgcos7;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Idftplistparsebullgcos7HPP
