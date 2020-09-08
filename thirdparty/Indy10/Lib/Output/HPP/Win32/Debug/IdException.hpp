// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdException.pas' rev: 25.00 (Windows)

#ifndef IdexceptionHPP
#define IdexceptionHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idexception
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS EIdException;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdException : public System::Sysutils::Exception
{
	typedef System::Sysutils::Exception inherited;
	
public:
	__fastcall virtual EIdException(const System::UnicodeString AMsg)/* overload */;
	__classmethod void __fastcall Toss _DEPRECATED_ATTRIBUTE1("Use raise instead") (const System::UnicodeString AMsg);
public:
	/* Exception.CreateFmt */ inline __fastcall EIdException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : System::Sysutils::Exception(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdException(NativeUInt Ident)/* overload */ : System::Sysutils::Exception(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdException(System::PResStringRec ResStringRec)/* overload */ : System::Sysutils::Exception(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdException(const System::UnicodeString Msg, int AHelpContext) : System::Sysutils::Exception(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : System::Sysutils::Exception(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdException(NativeUInt Ident, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdException(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdException(void) { }
	
};

#pragma pack(pop)

typedef System::TMetaClass* TClassIdException;

class DELPHICLASS EIdSilentException;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSilentException : public EIdException
{
	typedef EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSilentException(const System::UnicodeString AMsg)/* overload */ : EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSilentException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSilentException(NativeUInt Ident)/* overload */ : EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSilentException(System::PResStringRec ResStringRec)/* overload */ : EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSilentException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSilentException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSilentException(const System::UnicodeString Msg, int AHelpContext) : EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSilentException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSilentException(NativeUInt Ident, int AHelpContext)/* overload */ : EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSilentException(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSilentException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSilentException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSilentException(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdConnClosedGracefully;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdConnClosedGracefully : public EIdSilentException
{
	typedef EIdSilentException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdConnClosedGracefully(const System::UnicodeString AMsg)/* overload */ : EIdSilentException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdConnClosedGracefully(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSilentException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdConnClosedGracefully(NativeUInt Ident)/* overload */ : EIdSilentException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdConnClosedGracefully(System::PResStringRec ResStringRec)/* overload */ : EIdSilentException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdConnClosedGracefully(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSilentException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdConnClosedGracefully(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSilentException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdConnClosedGracefully(const System::UnicodeString Msg, int AHelpContext) : EIdSilentException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdConnClosedGracefully(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSilentException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdConnClosedGracefully(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSilentException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdConnClosedGracefully(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSilentException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdConnClosedGracefully(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSilentException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdConnClosedGracefully(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSilentException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdConnClosedGracefully(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSocketHandleError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSocketHandleError : public EIdException
{
	typedef EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSocketHandleError(const System::UnicodeString AMsg)/* overload */ : EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSocketHandleError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocketHandleError(NativeUInt Ident)/* overload */ : EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocketHandleError(System::PResStringRec ResStringRec)/* overload */ : EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocketHandleError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocketHandleError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSocketHandleError(const System::UnicodeString Msg, int AHelpContext) : EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSocketHandleError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocketHandleError(NativeUInt Ident, int AHelpContext)/* overload */ : EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocketHandleError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocketHandleError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocketHandleError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSocketHandleError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdPackageSizeTooBig;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdPackageSizeTooBig : public EIdSocketHandleError
{
	typedef EIdSocketHandleError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdPackageSizeTooBig(const System::UnicodeString AMsg)/* overload */ : EIdSocketHandleError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdPackageSizeTooBig(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSocketHandleError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdPackageSizeTooBig(NativeUInt Ident)/* overload */ : EIdSocketHandleError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdPackageSizeTooBig(System::PResStringRec ResStringRec)/* overload */ : EIdSocketHandleError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdPackageSizeTooBig(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocketHandleError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdPackageSizeTooBig(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocketHandleError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdPackageSizeTooBig(const System::UnicodeString Msg, int AHelpContext) : EIdSocketHandleError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdPackageSizeTooBig(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSocketHandleError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdPackageSizeTooBig(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSocketHandleError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdPackageSizeTooBig(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSocketHandleError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdPackageSizeTooBig(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocketHandleError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdPackageSizeTooBig(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocketHandleError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdPackageSizeTooBig(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdNotAllBytesSent;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdNotAllBytesSent : public EIdSocketHandleError
{
	typedef EIdSocketHandleError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdNotAllBytesSent(const System::UnicodeString AMsg)/* overload */ : EIdSocketHandleError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdNotAllBytesSent(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSocketHandleError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdNotAllBytesSent(NativeUInt Ident)/* overload */ : EIdSocketHandleError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdNotAllBytesSent(System::PResStringRec ResStringRec)/* overload */ : EIdSocketHandleError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNotAllBytesSent(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocketHandleError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNotAllBytesSent(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocketHandleError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdNotAllBytesSent(const System::UnicodeString Msg, int AHelpContext) : EIdSocketHandleError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdNotAllBytesSent(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSocketHandleError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNotAllBytesSent(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSocketHandleError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNotAllBytesSent(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSocketHandleError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNotAllBytesSent(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocketHandleError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNotAllBytesSent(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocketHandleError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdNotAllBytesSent(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdCouldNotBindSocket;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdCouldNotBindSocket : public EIdSocketHandleError
{
	typedef EIdSocketHandleError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdCouldNotBindSocket(const System::UnicodeString AMsg)/* overload */ : EIdSocketHandleError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdCouldNotBindSocket(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSocketHandleError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdCouldNotBindSocket(NativeUInt Ident)/* overload */ : EIdSocketHandleError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdCouldNotBindSocket(System::PResStringRec ResStringRec)/* overload */ : EIdSocketHandleError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdCouldNotBindSocket(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocketHandleError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdCouldNotBindSocket(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocketHandleError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdCouldNotBindSocket(const System::UnicodeString Msg, int AHelpContext) : EIdSocketHandleError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdCouldNotBindSocket(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSocketHandleError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdCouldNotBindSocket(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSocketHandleError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdCouldNotBindSocket(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSocketHandleError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdCouldNotBindSocket(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocketHandleError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdCouldNotBindSocket(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocketHandleError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdCouldNotBindSocket(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdCanNotBindPortInRange;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdCanNotBindPortInRange : public EIdSocketHandleError
{
	typedef EIdSocketHandleError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdCanNotBindPortInRange(const System::UnicodeString AMsg)/* overload */ : EIdSocketHandleError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdCanNotBindPortInRange(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSocketHandleError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdCanNotBindPortInRange(NativeUInt Ident)/* overload */ : EIdSocketHandleError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdCanNotBindPortInRange(System::PResStringRec ResStringRec)/* overload */ : EIdSocketHandleError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdCanNotBindPortInRange(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocketHandleError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdCanNotBindPortInRange(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocketHandleError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdCanNotBindPortInRange(const System::UnicodeString Msg, int AHelpContext) : EIdSocketHandleError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdCanNotBindPortInRange(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSocketHandleError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdCanNotBindPortInRange(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSocketHandleError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdCanNotBindPortInRange(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSocketHandleError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdCanNotBindPortInRange(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocketHandleError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdCanNotBindPortInRange(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocketHandleError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdCanNotBindPortInRange(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdInvalidPortRange;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdInvalidPortRange : public EIdSocketHandleError
{
	typedef EIdSocketHandleError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdInvalidPortRange(const System::UnicodeString AMsg)/* overload */ : EIdSocketHandleError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdInvalidPortRange(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSocketHandleError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdInvalidPortRange(NativeUInt Ident)/* overload */ : EIdSocketHandleError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdInvalidPortRange(System::PResStringRec ResStringRec)/* overload */ : EIdSocketHandleError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdInvalidPortRange(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocketHandleError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdInvalidPortRange(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocketHandleError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdInvalidPortRange(const System::UnicodeString Msg, int AHelpContext) : EIdSocketHandleError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdInvalidPortRange(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSocketHandleError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdInvalidPortRange(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSocketHandleError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdInvalidPortRange(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSocketHandleError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdInvalidPortRange(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocketHandleError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdInvalidPortRange(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocketHandleError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdInvalidPortRange(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdCannotSetIPVersionWhenConnected;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdCannotSetIPVersionWhenConnected : public EIdSocketHandleError
{
	typedef EIdSocketHandleError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdCannotSetIPVersionWhenConnected(const System::UnicodeString AMsg)/* overload */ : EIdSocketHandleError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdCannotSetIPVersionWhenConnected(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSocketHandleError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdCannotSetIPVersionWhenConnected(NativeUInt Ident)/* overload */ : EIdSocketHandleError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdCannotSetIPVersionWhenConnected(System::PResStringRec ResStringRec)/* overload */ : EIdSocketHandleError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdCannotSetIPVersionWhenConnected(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocketHandleError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdCannotSetIPVersionWhenConnected(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocketHandleError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdCannotSetIPVersionWhenConnected(const System::UnicodeString Msg, int AHelpContext) : EIdSocketHandleError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdCannotSetIPVersionWhenConnected(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSocketHandleError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdCannotSetIPVersionWhenConnected(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSocketHandleError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdCannotSetIPVersionWhenConnected(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSocketHandleError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdCannotSetIPVersionWhenConnected(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocketHandleError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdCannotSetIPVersionWhenConnected(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocketHandleError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdCannotSetIPVersionWhenConnected(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idexception */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDEXCEPTION)
using namespace Idexception;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdexceptionHPP
