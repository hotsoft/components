// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdRemoteCMDClient.pas' rev: 25.00 (Windows)

#ifndef IdremotecmdclientHPP
#define IdremotecmdclientHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdTCPClient.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <IdTCPConnection.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idremotecmdclient
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS EIdCanNotBindRang;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdCanNotBindRang : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdCanNotBindRang(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdCanNotBindRang(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdCanNotBindRang(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdCanNotBindRang(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdCanNotBindRang(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdCanNotBindRang(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdCanNotBindRang(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdCanNotBindRang(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdCanNotBindRang(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdCanNotBindRang(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdCanNotBindRang(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdCanNotBindRang(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdCanNotBindRang(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdRemoteCMDClient;
class PASCALIMPLEMENTATION TIdRemoteCMDClient : public Idtcpclient::TIdTCPClientCustom
{
	typedef Idtcpclient::TIdTCPClientCustom inherited;
	
protected:
	bool FUseReservedPorts;
	bool FUseStdError;
	System::UnicodeString FErrorMessage;
	bool FErrorReply;
	virtual System::UnicodeString __fastcall InternalExec(System::UnicodeString AParam1, System::UnicodeString AParam2, System::UnicodeString ACommand);
	virtual void __fastcall InitComponent(void);
	
public:
	__fastcall virtual ~TIdRemoteCMDClient(void);
	virtual System::UnicodeString __fastcall Execute(System::UnicodeString ACommand);
	__property bool ErrorReply = {read=FErrorReply, nodefault};
	__property System::UnicodeString ErrorMessage = {read=FErrorMessage};
	
__published:
	__property bool UseStdError = {read=FUseStdError, write=FUseStdError, default=1};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdRemoteCMDClient(System::Classes::TComponent* AOwner)/* overload */ : Idtcpclient::TIdTCPClientCustom(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdRemoteCMDClient(void)/* overload */ : Idtcpclient::TIdTCPClientCustom() { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const bool IDRemoteUseStdErr = true;
static const bool IDRemoteFixPort = true;
}	/* namespace Idremotecmdclient */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDREMOTECMDCLIENT)
using namespace Idremotecmdclient;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdremotecmdclientHPP
