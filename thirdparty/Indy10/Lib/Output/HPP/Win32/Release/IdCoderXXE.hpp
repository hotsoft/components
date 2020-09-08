// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdCoderXXE.pas' rev: 25.00 (Windows)

#ifndef IdcoderxxeHPP
#define IdcoderxxeHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdCoder00E.hpp>	// Pascal unit
#include <IdCoder3to4.hpp>	// Pascal unit
#include <IdCoder.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idcoderxxe
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdDecoderXXE;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdDecoderXXE : public Idcoder00e::TIdDecoder00E
{
	typedef Idcoder00e::TIdDecoder00E inherited;
	
protected:
	virtual void __fastcall InitComponent(void);
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdDecoderXXE(System::Classes::TComponent* AOwner)/* overload */ : Idcoder00e::TIdDecoder00E(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdDecoderXXE(void)/* overload */ : Idcoder00e::TIdDecoder00E() { }
	
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TIdDecoderXXE(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdEncoderXXE;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdEncoderXXE : public Idcoder00e::TIdEncoder00E
{
	typedef Idcoder00e::TIdEncoder00E inherited;
	
protected:
	virtual void __fastcall InitComponent(void);
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdEncoderXXE(System::Classes::TComponent* AOwner)/* overload */ : Idcoder00e::TIdEncoder00E(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdEncoderXXE(void)/* overload */ : Idcoder00e::TIdEncoder00E() { }
	
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TIdEncoderXXE(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::UnicodeString GXXECodeTable;
extern DELPHI_PACKAGE Idcoder3to4::TIdDecodeTable GXXEDecodeTable;
}	/* namespace Idcoderxxe */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDCODERXXE)
using namespace Idcoderxxe;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdcoderxxeHPP
