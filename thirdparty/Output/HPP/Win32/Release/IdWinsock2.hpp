// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdWinsock2.pas' rev: 25.00 (Windows)

#ifndef Idwinsock2HPP
#define Idwinsock2HPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <Winapi.Windows.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------
#include <winsock2.h>
#include <ws2tcpip.h>
#include <wsipx.h>
// workaround for a bug in wsnwlink.h where a couple of commented lines are not terminated property
#pragma option push -C-
#include <wsnwlink.h>
#pragma option pop
#include <wsnetbs.h>
#include <ws2atm.h>
#include <mswsock.h>

namespace Idwinsock2
{
    typedef fd_set *PFDSet;
    typedef fd_set TFDSet;
}


namespace Idwinsock2
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS EIdWinsockStubError;
#pragma pack(push,1)
class PASCALIMPLEMENTATION EIdWinsockStubError : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
protected:
	unsigned FWin32Error;
	System::UnicodeString FWin32ErrorMessage;
	System::UnicodeString FTitle;
	
public:
	__fastcall EIdWinsockStubError(unsigned AWin32Error, const System::UnicodeString ATitle, System::TVarRec *AArgs, const int AArgs_Size);
	__property unsigned Win32Error = {read=FWin32Error, nodefault};
	__property System::UnicodeString Win32ErrorMessage = {read=FWin32ErrorMessage};
	__property System::UnicodeString Title = {read=FTitle};
public:
	/* EIdException.Create */ inline __fastcall virtual EIdWinsockStubError(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdWinsockStubError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdWinsockStubError(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdWinsockStubError(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdWinsockStubError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdWinsockStubError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdWinsockStubError(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdWinsockStubError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdWinsockStubError(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdWinsockStubError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdWinsockStubError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdWinsockStubError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdWinsockStubError(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
#define WINSOCK2_DLL L"WS2_32.DLL"
#define MSWSOCK_DLL L"MSWSOCK.DLL"
extern DELPHI_PACKAGE NativeUInt __fastcall WinsockHandle(void);
extern DELPHI_PACKAGE bool __fastcall Winsock2Loaded(void);
}	/* namespace Idwinsock2 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDWINSOCK2)
using namespace Idwinsock2;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Idwinsock2HPP
