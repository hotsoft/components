// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdHashElf.pas' rev: 25.00 (Windows)

#ifndef IdhashelfHPP
#define IdhashelfHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdHash.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idhashelf
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdHashElf;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdHashElf : public Idhash::TIdHash32
{
	typedef Idhash::TIdHash32 inherited;
	
public:
	virtual void __fastcall HashStart(unsigned &VRunningHash);
	virtual void __fastcall HashByte(unsigned &VRunningHash, const System::Byte AByte);
public:
	/* TIdHash.Create */ inline __fastcall virtual TIdHashElf(void) : Idhash::TIdHash32() { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdHashElf(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idhashelf */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDHASHELF)
using namespace Idhashelf;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdhashelfHPP
