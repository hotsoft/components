// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdMessageCoderXXE.pas' rev: 25.00 (Windows)

#ifndef IdmessagecoderxxeHPP
#define IdmessagecoderxxeHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdMessageCoderUUE.hpp>	// Pascal unit
#include <IdMessageCoder.hpp>	// Pascal unit
#include <IdMessage.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idmessagecoderxxe
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdMessageEncoderXXE;
class PASCALIMPLEMENTATION TIdMessageEncoderXXE : public Idmessagecoderuue::TIdMessageEncoderUUEBase
{
	typedef Idmessagecoderuue::TIdMessageEncoderUUEBase inherited;
	
protected:
	virtual void __fastcall InitComponent(void);
public:
	/* TIdComponent.Destroy */ inline __fastcall virtual ~TIdMessageEncoderXXE(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdMessageEncoderXXE(System::Classes::TComponent* AOwner)/* overload */ : Idmessagecoderuue::TIdMessageEncoderUUEBase(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdMessageEncoderXXE(void)/* overload */ : Idmessagecoderuue::TIdMessageEncoderUUEBase() { }
	
};


class DELPHICLASS TIdMessageEncoderInfoXXE;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdMessageEncoderInfoXXE : public Idmessagecoder::TIdMessageEncoderInfo
{
	typedef Idmessagecoder::TIdMessageEncoderInfo inherited;
	
public:
	__fastcall virtual TIdMessageEncoderInfoXXE(void);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdMessageEncoderInfoXXE(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idmessagecoderxxe */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDMESSAGECODERXXE)
using namespace Idmessagecoderxxe;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdmessagecoderxxeHPP
