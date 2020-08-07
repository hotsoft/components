// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdUserPassProvider.pas' rev: 25.00 (Windows)

#ifndef IduserpassproviderHPP
#define IduserpassproviderHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Iduserpassprovider
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdUserPassProvider;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdUserPassProvider : public Idbasecomponent::TIdBaseComponent
{
	typedef Idbasecomponent::TIdBaseComponent inherited;
	
protected:
	System::UnicodeString FUsername;
	System::UnicodeString FPassword;
	
__published:
	__property System::UnicodeString Username = {read=FUsername, write=FUsername};
	__property System::UnicodeString Password = {read=FPassword, write=FPassword};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdUserPassProvider(System::Classes::TComponent* AOwner)/* overload */ : Idbasecomponent::TIdBaseComponent(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdUserPassProvider(void)/* overload */ : Idbasecomponent::TIdBaseComponent() { }
	
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TIdUserPassProvider(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Iduserpassprovider */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDUSERPASSPROVIDER)
using namespace Iduserpassprovider;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IduserpassproviderHPP
