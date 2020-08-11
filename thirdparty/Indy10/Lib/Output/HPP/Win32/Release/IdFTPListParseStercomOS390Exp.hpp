// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdFTPListParseStercomOS390Exp.pas' rev: 25.00 (Windows)

#ifndef Idftplistparsestercomos390expHPP
#define Idftplistparsestercomos390expHPP

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
#pragma link "IdFTPListParseStercomOS390Exp"

namespace Idftplistparsestercomos390exp
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdSterCommExpOS390FTPListItem;
class PASCALIMPLEMENTATION TIdSterCommExpOS390FTPListItem : public Idftplist::TIdFTPListItem
{
	typedef Idftplist::TIdFTPListItem inherited;
	
protected:
	System::UnicodeString FRecFormat;
	int FRecLength;
	int FBlockSize;
	
public:
	__property System::UnicodeString RecFormat = {read=FRecFormat, write=FRecFormat};
	__property int RecLength = {read=FRecLength, write=FRecLength, nodefault};
	__property int BlockSize = {read=FBlockSize, write=FBlockSize, nodefault};
public:
	/* TIdFTPListItem.Create */ inline __fastcall virtual TIdSterCommExpOS390FTPListItem(System::Classes::TCollection* AOwner) : Idftplist::TIdFTPListItem(AOwner) { }
	
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdSterCommExpOS390FTPListItem(void) { }
	
};


class DELPHICLASS TIdFTPLPSterCommExpOS390;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPSterCommExpOS390 : public Idftplistparsebase::TIdFTPListBase
{
	typedef Idftplistparsebase::TIdFTPListBase inherited;
	
protected:
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
	__classmethod virtual bool __fastcall CheckListing(System::Classes::TStrings* AListing, const System::UnicodeString ASysDescript = System::UnicodeString(), const bool ADetails = true);
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPSterCommExpOS390(void) : Idftplistparsebase::TIdFTPListBase() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPSterCommExpOS390(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
#define STIRCOMEXPOS390 L"Connect:Express for OS/390"
}	/* namespace Idftplistparsestercomos390exp */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDFTPLISTPARSESTERCOMOS390EXP)
using namespace Idftplistparsestercomos390exp;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Idftplistparsestercomos390expHPP
