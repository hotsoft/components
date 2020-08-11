// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdCoderUUE.pas' rev: 25.00 (Windows)

#ifndef IdcoderuueHPP
#define IdcoderuueHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdCoder00E.hpp>	// Pascal unit
#include <IdCoder3to4.hpp>	// Pascal unit
#include <IdCoder.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idcoderuue
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdDecoderUUE;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdDecoderUUE : public Idcoder00e::TIdDecoder00E
{
	typedef Idcoder00e::TIdDecoder00E inherited;
	
protected:
	virtual void __fastcall InitComponent(void);
	
public:
	__fastcall TIdDecoderUUE(System::Classes::TComponent* AOwner)/* overload */;
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdDecoderUUE(void)/* overload */ : Idcoder00e::TIdDecoder00E() { }
	
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TIdDecoderUUE(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdEncoderUUE;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdEncoderUUE : public Idcoder00e::TIdEncoder00E
{
	typedef Idcoder00e::TIdEncoder00E inherited;
	
protected:
	virtual void __fastcall InitComponent(void);
	
public:
	__fastcall TIdEncoderUUE(System::Classes::TComponent* AOwner)/* overload */;
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdEncoderUUE(void)/* overload */ : Idcoder00e::TIdEncoder00E() { }
	
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TIdEncoderUUE(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::UnicodeString GUUECodeTable;
extern DELPHI_PACKAGE Idcoder3to4::TIdDecodeTable GUUEDecodeTable;
}	/* namespace Idcoderuue */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDCODERUUE)
using namespace Idcoderuue;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdcoderuueHPP
