// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdFTPListParseXecomMicroRTOS.pas' rev: 25.00 (Windows)

#ifndef IdftplistparsexecommicrortosHPP
#define IdftplistparsexecommicrortosHPP

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

//-- user supplied -----------------------------------------------------------
#pragma link "IdFTPListParseXecomMicroRTOS"

namespace Idftplistparsexecommicrortos
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdXecomMicroRTOSTPListItem;
class PASCALIMPLEMENTATION TIdXecomMicroRTOSTPListItem : public Idftplist::TIdFTPListItem
{
	typedef Idftplist::TIdFTPListItem inherited;
	
protected:
	unsigned FMemStart;
	unsigned FMemEnd;
	
public:
	__fastcall virtual TIdXecomMicroRTOSTPListItem(System::Classes::TCollection* AOwner);
	__property unsigned MemStart = {read=FMemStart, write=FMemStart, nodefault};
	__property unsigned MemEnd = {read=FMemEnd, write=FMemEnd, nodefault};
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdXecomMicroRTOSTPListItem(void) { }
	
};


class DELPHICLASS TIdFTPLPXecomMicroRTOS;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPXecomMicroRTOS : public Idftplistparsebase::TIdFTPListBaseHeader
{
	typedef Idftplistparsebase::TIdFTPListBaseHeader inherited;
	
protected:
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	__classmethod virtual bool __fastcall IsHeader(const System::UnicodeString AData);
	__classmethod virtual bool __fastcall IsFooter(const System::UnicodeString AData);
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPXecomMicroRTOS(void) : Idftplistparsebase::TIdFTPListBaseHeader() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPXecomMicroRTOS(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idftplistparsexecommicrortos */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDFTPLISTPARSEXECOMMICRORTOS)
using namespace Idftplistparsexecommicrortos;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdftplistparsexecommicrortosHPP
