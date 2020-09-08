// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdBaseComponent.pas' rev: 25.00 (Windows)

#ifndef IdbasecomponentHPP
#define IdbasecomponentHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idbasecomponent
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdInitializerComponent;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdInitializerComponent : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
protected:
	bool __fastcall GetIsLoading(void);
	bool __fastcall GetIsDesignTime(void);
	virtual void __fastcall InitComponent(void);
	
public:
	__fastcall TIdInitializerComponent(void)/* overload */;
	__fastcall virtual TIdInitializerComponent(System::Classes::TComponent* AOwner)/* overload */;
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TIdInitializerComponent(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdBaseComponent;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdBaseComponent : public TIdInitializerComponent
{
	typedef TIdInitializerComponent inherited;
	
protected:
	System::UnicodeString __fastcall GetIndyVersion(void);
	__property bool IsLoading = {read=GetIsLoading, nodefault};
	__property bool IsDesignTime = {read=GetIsDesignTime, nodefault};
	
public:
	__fastcall TIdBaseComponent(System::Classes::TComponent* AOwner)/* overload */;
	__property System::UnicodeString Version = {read=GetIndyVersion};
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdBaseComponent(void)/* overload */ : TIdInitializerComponent() { }
	
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TIdBaseComponent(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idbasecomponent */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDBASECOMPONENT)
using namespace Idbasecomponent;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdbasecomponentHPP
