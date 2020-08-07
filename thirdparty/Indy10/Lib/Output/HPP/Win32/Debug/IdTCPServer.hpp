// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdTCPServer.pas' rev: 25.00 (Windows)

#ifndef IdtcpserverHPP
#define IdtcpserverHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdCustomTCPServer.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idtcpserver
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS EIdTCPNoOnExecute;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdTCPNoOnExecute : public Idcustomtcpserver::EIdTCPServerError
{
	typedef Idcustomtcpserver::EIdTCPServerError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdTCPNoOnExecute(const System::UnicodeString AMsg)/* overload */ : Idcustomtcpserver::EIdTCPServerError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdTCPNoOnExecute(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idcustomtcpserver::EIdTCPServerError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdTCPNoOnExecute(NativeUInt Ident)/* overload */ : Idcustomtcpserver::EIdTCPServerError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdTCPNoOnExecute(System::PResStringRec ResStringRec)/* overload */ : Idcustomtcpserver::EIdTCPServerError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTCPNoOnExecute(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idcustomtcpserver::EIdTCPServerError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTCPNoOnExecute(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idcustomtcpserver::EIdTCPServerError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdTCPNoOnExecute(const System::UnicodeString Msg, int AHelpContext) : Idcustomtcpserver::EIdTCPServerError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdTCPNoOnExecute(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idcustomtcpserver::EIdTCPServerError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTCPNoOnExecute(NativeUInt Ident, int AHelpContext)/* overload */ : Idcustomtcpserver::EIdTCPServerError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTCPNoOnExecute(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idcustomtcpserver::EIdTCPServerError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTCPNoOnExecute(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idcustomtcpserver::EIdTCPServerError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTCPNoOnExecute(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idcustomtcpserver::EIdTCPServerError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdTCPNoOnExecute(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdTCPServer;
class PASCALIMPLEMENTATION TIdTCPServer : public Idcustomtcpserver::TIdCustomTCPServer
{
	typedef Idcustomtcpserver::TIdCustomTCPServer inherited;
	
protected:
	virtual void __fastcall CheckOkToBeActive(void);
	
__published:
	__property OnExecute;
public:
	/* TIdCustomTCPServer.Destroy */ inline __fastcall virtual ~TIdTCPServer(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdTCPServer(System::Classes::TComponent* AOwner)/* overload */ : Idcustomtcpserver::TIdCustomTCPServer(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdTCPServer(void)/* overload */ : Idcustomtcpserver::TIdCustomTCPServer() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idtcpserver */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDTCPSERVER)
using namespace Idtcpserver;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdtcpserverHPP
