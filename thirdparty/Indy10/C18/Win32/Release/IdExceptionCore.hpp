// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdExceptionCore.pas' rev: 25.00 (Windows)

#ifndef IdexceptioncoreHPP
#define IdexceptioncoreHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdStack.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idexceptioncore
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS EIdFiber;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdFiber : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdFiber(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdFiber(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdFiber(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdFiber(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdFiber(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdFiber(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdFiber(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdFiber(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdFiber(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdFiber(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdFiber(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdFiber(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdFiber(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdFiberFinished;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdFiberFinished : public EIdFiber
{
	typedef EIdFiber inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdFiberFinished(const System::UnicodeString AMsg)/* overload */ : EIdFiber(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdFiberFinished(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdFiber(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdFiberFinished(NativeUInt Ident)/* overload */ : EIdFiber(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdFiberFinished(System::PResStringRec ResStringRec)/* overload */ : EIdFiber(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdFiberFinished(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdFiber(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdFiberFinished(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdFiber(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdFiberFinished(const System::UnicodeString Msg, int AHelpContext) : EIdFiber(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdFiberFinished(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdFiber(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdFiberFinished(NativeUInt Ident, int AHelpContext)/* overload */ : EIdFiber(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdFiberFinished(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdFiber(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdFiberFinished(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdFiber(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdFiberFinished(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdFiber(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdFiberFinished(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdFibersNotSupported;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdFibersNotSupported : public EIdFiber
{
	typedef EIdFiber inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdFibersNotSupported(const System::UnicodeString AMsg)/* overload */ : EIdFiber(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdFibersNotSupported(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdFiber(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdFibersNotSupported(NativeUInt Ident)/* overload */ : EIdFiber(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdFibersNotSupported(System::PResStringRec ResStringRec)/* overload */ : EIdFiber(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdFibersNotSupported(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdFiber(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdFibersNotSupported(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdFiber(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdFibersNotSupported(const System::UnicodeString Msg, int AHelpContext) : EIdFiber(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdFibersNotSupported(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdFiber(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdFibersNotSupported(NativeUInt Ident, int AHelpContext)/* overload */ : EIdFiber(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdFibersNotSupported(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdFiber(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdFibersNotSupported(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdFiber(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdFibersNotSupported(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdFiber(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdFibersNotSupported(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdAlreadyConnected;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdAlreadyConnected : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdAlreadyConnected(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdAlreadyConnected(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdAlreadyConnected(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdAlreadyConnected(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdAlreadyConnected(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdAlreadyConnected(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdAlreadyConnected(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdAlreadyConnected(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdAlreadyConnected(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdAlreadyConnected(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdAlreadyConnected(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdAlreadyConnected(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdAlreadyConnected(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdClosedSocket;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdClosedSocket : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdClosedSocket(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdClosedSocket(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdClosedSocket(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdClosedSocket(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdClosedSocket(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdClosedSocket(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdClosedSocket(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdClosedSocket(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdClosedSocket(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdClosedSocket(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdClosedSocket(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdClosedSocket(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdClosedSocket(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdResponseError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdResponseError : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdResponseError(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdResponseError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdResponseError(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdResponseError(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdResponseError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdResponseError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdResponseError(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdResponseError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdResponseError(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdResponseError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdResponseError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdResponseError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdResponseError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdReadTimeout;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdReadTimeout : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdReadTimeout(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdReadTimeout(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdReadTimeout(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdReadTimeout(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdReadTimeout(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdReadTimeout(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdReadTimeout(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdReadTimeout(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdReadTimeout(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdReadTimeout(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdReadTimeout(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdReadTimeout(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdReadTimeout(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdAcceptTimeout;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdAcceptTimeout : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdAcceptTimeout(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdAcceptTimeout(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdAcceptTimeout(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdAcceptTimeout(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdAcceptTimeout(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdAcceptTimeout(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdAcceptTimeout(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdAcceptTimeout(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdAcceptTimeout(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdAcceptTimeout(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdAcceptTimeout(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdAcceptTimeout(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdAcceptTimeout(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdReadLnMaxLineLengthExceeded;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdReadLnMaxLineLengthExceeded : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdReadLnMaxLineLengthExceeded(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdReadLnMaxLineLengthExceeded(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdReadLnMaxLineLengthExceeded(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdReadLnMaxLineLengthExceeded(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdReadLnMaxLineLengthExceeded(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdReadLnMaxLineLengthExceeded(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdReadLnMaxLineLengthExceeded(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdReadLnMaxLineLengthExceeded(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdReadLnMaxLineLengthExceeded(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdReadLnMaxLineLengthExceeded(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdReadLnMaxLineLengthExceeded(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdReadLnMaxLineLengthExceeded(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdReadLnMaxLineLengthExceeded(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdReadLnWaitMaxAttemptsExceeded;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdReadLnWaitMaxAttemptsExceeded : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdReadLnWaitMaxAttemptsExceeded(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdReadLnWaitMaxAttemptsExceeded(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdReadLnWaitMaxAttemptsExceeded(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdReadLnWaitMaxAttemptsExceeded(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdReadLnWaitMaxAttemptsExceeded(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdReadLnWaitMaxAttemptsExceeded(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdReadLnWaitMaxAttemptsExceeded(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdReadLnWaitMaxAttemptsExceeded(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdReadLnWaitMaxAttemptsExceeded(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdReadLnWaitMaxAttemptsExceeded(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdReadLnWaitMaxAttemptsExceeded(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdReadLnWaitMaxAttemptsExceeded(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdReadLnWaitMaxAttemptsExceeded(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdPortRequired;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdPortRequired : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdPortRequired(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdPortRequired(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdPortRequired(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdPortRequired(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdPortRequired(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdPortRequired(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdPortRequired(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdPortRequired(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdPortRequired(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdPortRequired(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdPortRequired(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdPortRequired(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdPortRequired(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdHostRequired;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdHostRequired : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdHostRequired(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdHostRequired(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdHostRequired(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdHostRequired(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdHostRequired(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdHostRequired(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdHostRequired(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdHostRequired(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdHostRequired(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdHostRequired(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdHostRequired(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdHostRequired(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdHostRequired(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdTCPConnectionError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdTCPConnectionError : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdTCPConnectionError(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdTCPConnectionError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdTCPConnectionError(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdTCPConnectionError(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTCPConnectionError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTCPConnectionError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdTCPConnectionError(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdTCPConnectionError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTCPConnectionError(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTCPConnectionError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTCPConnectionError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTCPConnectionError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdTCPConnectionError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdObjectTypeNotSupported;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdObjectTypeNotSupported : public EIdTCPConnectionError
{
	typedef EIdTCPConnectionError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdObjectTypeNotSupported(const System::UnicodeString AMsg)/* overload */ : EIdTCPConnectionError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdObjectTypeNotSupported(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdTCPConnectionError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdObjectTypeNotSupported(NativeUInt Ident)/* overload */ : EIdTCPConnectionError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdObjectTypeNotSupported(System::PResStringRec ResStringRec)/* overload */ : EIdTCPConnectionError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdObjectTypeNotSupported(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTCPConnectionError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdObjectTypeNotSupported(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTCPConnectionError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdObjectTypeNotSupported(const System::UnicodeString Msg, int AHelpContext) : EIdTCPConnectionError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdObjectTypeNotSupported(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdTCPConnectionError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdObjectTypeNotSupported(NativeUInt Ident, int AHelpContext)/* overload */ : EIdTCPConnectionError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdObjectTypeNotSupported(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdTCPConnectionError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdObjectTypeNotSupported(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTCPConnectionError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdObjectTypeNotSupported(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTCPConnectionError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdObjectTypeNotSupported(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdInterceptPropIsNil;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdInterceptPropIsNil : public EIdTCPConnectionError
{
	typedef EIdTCPConnectionError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdInterceptPropIsNil(const System::UnicodeString AMsg)/* overload */ : EIdTCPConnectionError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdInterceptPropIsNil(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdTCPConnectionError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdInterceptPropIsNil(NativeUInt Ident)/* overload */ : EIdTCPConnectionError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdInterceptPropIsNil(System::PResStringRec ResStringRec)/* overload */ : EIdTCPConnectionError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdInterceptPropIsNil(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTCPConnectionError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdInterceptPropIsNil(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTCPConnectionError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdInterceptPropIsNil(const System::UnicodeString Msg, int AHelpContext) : EIdTCPConnectionError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdInterceptPropIsNil(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdTCPConnectionError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdInterceptPropIsNil(NativeUInt Ident, int AHelpContext)/* overload */ : EIdTCPConnectionError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdInterceptPropIsNil(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdTCPConnectionError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdInterceptPropIsNil(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTCPConnectionError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdInterceptPropIsNil(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTCPConnectionError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdInterceptPropIsNil(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdInterceptPropInvalid;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdInterceptPropInvalid : public EIdTCPConnectionError
{
	typedef EIdTCPConnectionError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdInterceptPropInvalid(const System::UnicodeString AMsg)/* overload */ : EIdTCPConnectionError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdInterceptPropInvalid(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdTCPConnectionError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdInterceptPropInvalid(NativeUInt Ident)/* overload */ : EIdTCPConnectionError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdInterceptPropInvalid(System::PResStringRec ResStringRec)/* overload */ : EIdTCPConnectionError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdInterceptPropInvalid(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTCPConnectionError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdInterceptPropInvalid(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTCPConnectionError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdInterceptPropInvalid(const System::UnicodeString Msg, int AHelpContext) : EIdTCPConnectionError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdInterceptPropInvalid(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdTCPConnectionError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdInterceptPropInvalid(NativeUInt Ident, int AHelpContext)/* overload */ : EIdTCPConnectionError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdInterceptPropInvalid(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdTCPConnectionError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdInterceptPropInvalid(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTCPConnectionError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdInterceptPropInvalid(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTCPConnectionError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdInterceptPropInvalid(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdIOHandlerPropInvalid;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdIOHandlerPropInvalid : public EIdTCPConnectionError
{
	typedef EIdTCPConnectionError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdIOHandlerPropInvalid(const System::UnicodeString AMsg)/* overload */ : EIdTCPConnectionError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdIOHandlerPropInvalid(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdTCPConnectionError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdIOHandlerPropInvalid(NativeUInt Ident)/* overload */ : EIdTCPConnectionError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdIOHandlerPropInvalid(System::PResStringRec ResStringRec)/* overload */ : EIdTCPConnectionError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIOHandlerPropInvalid(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTCPConnectionError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIOHandlerPropInvalid(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTCPConnectionError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdIOHandlerPropInvalid(const System::UnicodeString Msg, int AHelpContext) : EIdTCPConnectionError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdIOHandlerPropInvalid(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdTCPConnectionError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIOHandlerPropInvalid(NativeUInt Ident, int AHelpContext)/* overload */ : EIdTCPConnectionError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIOHandlerPropInvalid(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdTCPConnectionError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIOHandlerPropInvalid(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTCPConnectionError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIOHandlerPropInvalid(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTCPConnectionError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdIOHandlerPropInvalid(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdNoDataToRead;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdNoDataToRead : public EIdTCPConnectionError
{
	typedef EIdTCPConnectionError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdNoDataToRead(const System::UnicodeString AMsg)/* overload */ : EIdTCPConnectionError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdNoDataToRead(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdTCPConnectionError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdNoDataToRead(NativeUInt Ident)/* overload */ : EIdTCPConnectionError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdNoDataToRead(System::PResStringRec ResStringRec)/* overload */ : EIdTCPConnectionError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNoDataToRead(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTCPConnectionError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNoDataToRead(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTCPConnectionError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdNoDataToRead(const System::UnicodeString Msg, int AHelpContext) : EIdTCPConnectionError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdNoDataToRead(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdTCPConnectionError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNoDataToRead(NativeUInt Ident, int AHelpContext)/* overload */ : EIdTCPConnectionError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNoDataToRead(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdTCPConnectionError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNoDataToRead(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTCPConnectionError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNoDataToRead(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTCPConnectionError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdNoDataToRead(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdFileNotFound;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdFileNotFound : public EIdTCPConnectionError
{
	typedef EIdTCPConnectionError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdFileNotFound(const System::UnicodeString AMsg)/* overload */ : EIdTCPConnectionError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdFileNotFound(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdTCPConnectionError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdFileNotFound(NativeUInt Ident)/* overload */ : EIdTCPConnectionError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdFileNotFound(System::PResStringRec ResStringRec)/* overload */ : EIdTCPConnectionError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdFileNotFound(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTCPConnectionError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdFileNotFound(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTCPConnectionError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdFileNotFound(const System::UnicodeString Msg, int AHelpContext) : EIdTCPConnectionError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdFileNotFound(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdTCPConnectionError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdFileNotFound(NativeUInt Ident, int AHelpContext)/* overload */ : EIdTCPConnectionError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdFileNotFound(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdTCPConnectionError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdFileNotFound(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTCPConnectionError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdFileNotFound(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTCPConnectionError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdFileNotFound(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdNotConnected;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdNotConnected : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdNotConnected(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdNotConnected(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdNotConnected(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdNotConnected(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNotConnected(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNotConnected(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdNotConnected(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdNotConnected(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNotConnected(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNotConnected(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNotConnected(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNotConnected(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdNotConnected(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EInvalidSyslogMessage;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EInvalidSyslogMessage : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EInvalidSyslogMessage(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EInvalidSyslogMessage(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EInvalidSyslogMessage(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EInvalidSyslogMessage(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EInvalidSyslogMessage(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EInvalidSyslogMessage(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EInvalidSyslogMessage(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EInvalidSyslogMessage(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EInvalidSyslogMessage(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EInvalidSyslogMessage(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EInvalidSyslogMessage(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EInvalidSyslogMessage(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EInvalidSyslogMessage(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSSLProtocolReplyError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSSLProtocolReplyError : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSSLProtocolReplyError(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSSLProtocolReplyError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSSLProtocolReplyError(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSSLProtocolReplyError(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSSLProtocolReplyError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSSLProtocolReplyError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSSLProtocolReplyError(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSSLProtocolReplyError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSSLProtocolReplyError(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSSLProtocolReplyError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSSLProtocolReplyError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSSLProtocolReplyError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSSLProtocolReplyError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdConnectTimeout;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdConnectTimeout : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdConnectTimeout(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdConnectTimeout(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdConnectTimeout(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdConnectTimeout(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdConnectTimeout(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdConnectTimeout(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdConnectTimeout(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdConnectTimeout(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdConnectTimeout(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdConnectTimeout(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdConnectTimeout(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdConnectTimeout(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdConnectTimeout(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdConnectException;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdConnectException : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdConnectException(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdConnectException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdConnectException(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdConnectException(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdConnectException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdConnectException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdConnectException(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdConnectException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdConnectException(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdConnectException(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdConnectException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdConnectException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdConnectException(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdTransparentProxyCantBind;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdTransparentProxyCantBind : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdTransparentProxyCantBind(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdTransparentProxyCantBind(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdTransparentProxyCantBind(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdTransparentProxyCantBind(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTransparentProxyCantBind(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTransparentProxyCantBind(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdTransparentProxyCantBind(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdTransparentProxyCantBind(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTransparentProxyCantBind(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTransparentProxyCantBind(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTransparentProxyCantBind(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTransparentProxyCantBind(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdTransparentProxyCantBind(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdHttpProxyError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdHttpProxyError : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdHttpProxyError(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdHttpProxyError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdHttpProxyError(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdHttpProxyError(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdHttpProxyError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdHttpProxyError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdHttpProxyError(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdHttpProxyError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdHttpProxyError(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdHttpProxyError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdHttpProxyError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdHttpProxyError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdHttpProxyError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSocksError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSocksError : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSocksError(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSocksError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksError(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksError(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSocksError(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSocksError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksError(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSocksError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSocksRequestFailed;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSocksRequestFailed : public EIdSocksError
{
	typedef EIdSocksError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSocksRequestFailed(const System::UnicodeString AMsg)/* overload */ : EIdSocksError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSocksRequestFailed(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSocksError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksRequestFailed(NativeUInt Ident)/* overload */ : EIdSocksError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksRequestFailed(System::PResStringRec ResStringRec)/* overload */ : EIdSocksError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksRequestFailed(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocksError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksRequestFailed(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocksError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSocksRequestFailed(const System::UnicodeString Msg, int AHelpContext) : EIdSocksError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSocksRequestFailed(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSocksError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksRequestFailed(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSocksError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksRequestFailed(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSocksError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksRequestFailed(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocksError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksRequestFailed(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocksError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSocksRequestFailed(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSocksRequestServerFailed;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSocksRequestServerFailed : public EIdSocksError
{
	typedef EIdSocksError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSocksRequestServerFailed(const System::UnicodeString AMsg)/* overload */ : EIdSocksError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSocksRequestServerFailed(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSocksError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksRequestServerFailed(NativeUInt Ident)/* overload */ : EIdSocksError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksRequestServerFailed(System::PResStringRec ResStringRec)/* overload */ : EIdSocksError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksRequestServerFailed(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocksError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksRequestServerFailed(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocksError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSocksRequestServerFailed(const System::UnicodeString Msg, int AHelpContext) : EIdSocksError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSocksRequestServerFailed(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSocksError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksRequestServerFailed(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSocksError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksRequestServerFailed(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSocksError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksRequestServerFailed(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocksError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksRequestServerFailed(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocksError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSocksRequestServerFailed(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSocksRequestIdentFailed;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSocksRequestIdentFailed : public EIdSocksError
{
	typedef EIdSocksError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSocksRequestIdentFailed(const System::UnicodeString AMsg)/* overload */ : EIdSocksError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSocksRequestIdentFailed(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSocksError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksRequestIdentFailed(NativeUInt Ident)/* overload */ : EIdSocksError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksRequestIdentFailed(System::PResStringRec ResStringRec)/* overload */ : EIdSocksError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksRequestIdentFailed(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocksError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksRequestIdentFailed(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocksError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSocksRequestIdentFailed(const System::UnicodeString Msg, int AHelpContext) : EIdSocksError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSocksRequestIdentFailed(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSocksError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksRequestIdentFailed(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSocksError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksRequestIdentFailed(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSocksError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksRequestIdentFailed(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocksError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksRequestIdentFailed(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocksError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSocksRequestIdentFailed(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSocksUnknownError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSocksUnknownError : public EIdSocksError
{
	typedef EIdSocksError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSocksUnknownError(const System::UnicodeString AMsg)/* overload */ : EIdSocksError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSocksUnknownError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSocksError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksUnknownError(NativeUInt Ident)/* overload */ : EIdSocksError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksUnknownError(System::PResStringRec ResStringRec)/* overload */ : EIdSocksError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksUnknownError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocksError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksUnknownError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocksError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSocksUnknownError(const System::UnicodeString Msg, int AHelpContext) : EIdSocksError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSocksUnknownError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSocksError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksUnknownError(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSocksError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksUnknownError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSocksError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksUnknownError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocksError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksUnknownError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocksError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSocksUnknownError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSocksServerRespondError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSocksServerRespondError : public EIdSocksError
{
	typedef EIdSocksError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSocksServerRespondError(const System::UnicodeString AMsg)/* overload */ : EIdSocksError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSocksServerRespondError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSocksError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksServerRespondError(NativeUInt Ident)/* overload */ : EIdSocksError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksServerRespondError(System::PResStringRec ResStringRec)/* overload */ : EIdSocksError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksServerRespondError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocksError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksServerRespondError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocksError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSocksServerRespondError(const System::UnicodeString Msg, int AHelpContext) : EIdSocksError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSocksServerRespondError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSocksError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksServerRespondError(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSocksError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksServerRespondError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSocksError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksServerRespondError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocksError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksServerRespondError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocksError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSocksServerRespondError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSocksAuthMethodError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSocksAuthMethodError : public EIdSocksError
{
	typedef EIdSocksError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSocksAuthMethodError(const System::UnicodeString AMsg)/* overload */ : EIdSocksError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSocksAuthMethodError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSocksError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksAuthMethodError(NativeUInt Ident)/* overload */ : EIdSocksError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksAuthMethodError(System::PResStringRec ResStringRec)/* overload */ : EIdSocksError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksAuthMethodError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocksError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksAuthMethodError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocksError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSocksAuthMethodError(const System::UnicodeString Msg, int AHelpContext) : EIdSocksError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSocksAuthMethodError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSocksError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksAuthMethodError(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSocksError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksAuthMethodError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSocksError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksAuthMethodError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocksError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksAuthMethodError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocksError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSocksAuthMethodError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSocksAuthError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSocksAuthError : public EIdSocksError
{
	typedef EIdSocksError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSocksAuthError(const System::UnicodeString AMsg)/* overload */ : EIdSocksError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSocksAuthError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSocksError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksAuthError(NativeUInt Ident)/* overload */ : EIdSocksError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksAuthError(System::PResStringRec ResStringRec)/* overload */ : EIdSocksError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksAuthError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocksError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksAuthError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocksError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSocksAuthError(const System::UnicodeString Msg, int AHelpContext) : EIdSocksError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSocksAuthError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSocksError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksAuthError(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSocksError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksAuthError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSocksError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksAuthError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocksError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksAuthError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocksError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSocksAuthError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSocksServerGeneralError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSocksServerGeneralError : public EIdSocksError
{
	typedef EIdSocksError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSocksServerGeneralError(const System::UnicodeString AMsg)/* overload */ : EIdSocksError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSocksServerGeneralError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSocksError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksServerGeneralError(NativeUInt Ident)/* overload */ : EIdSocksError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksServerGeneralError(System::PResStringRec ResStringRec)/* overload */ : EIdSocksError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksServerGeneralError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocksError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksServerGeneralError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocksError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSocksServerGeneralError(const System::UnicodeString Msg, int AHelpContext) : EIdSocksError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSocksServerGeneralError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSocksError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksServerGeneralError(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSocksError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksServerGeneralError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSocksError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksServerGeneralError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocksError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksServerGeneralError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocksError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSocksServerGeneralError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSocksServerPermissionError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSocksServerPermissionError : public EIdSocksError
{
	typedef EIdSocksError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSocksServerPermissionError(const System::UnicodeString AMsg)/* overload */ : EIdSocksError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSocksServerPermissionError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSocksError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksServerPermissionError(NativeUInt Ident)/* overload */ : EIdSocksError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksServerPermissionError(System::PResStringRec ResStringRec)/* overload */ : EIdSocksError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksServerPermissionError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocksError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksServerPermissionError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocksError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSocksServerPermissionError(const System::UnicodeString Msg, int AHelpContext) : EIdSocksError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSocksServerPermissionError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSocksError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksServerPermissionError(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSocksError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksServerPermissionError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSocksError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksServerPermissionError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocksError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksServerPermissionError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocksError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSocksServerPermissionError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSocksServerNetUnreachableError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSocksServerNetUnreachableError : public EIdSocksError
{
	typedef EIdSocksError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSocksServerNetUnreachableError(const System::UnicodeString AMsg)/* overload */ : EIdSocksError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSocksServerNetUnreachableError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSocksError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksServerNetUnreachableError(NativeUInt Ident)/* overload */ : EIdSocksError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksServerNetUnreachableError(System::PResStringRec ResStringRec)/* overload */ : EIdSocksError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksServerNetUnreachableError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocksError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksServerNetUnreachableError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocksError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSocksServerNetUnreachableError(const System::UnicodeString Msg, int AHelpContext) : EIdSocksError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSocksServerNetUnreachableError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSocksError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksServerNetUnreachableError(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSocksError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksServerNetUnreachableError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSocksError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksServerNetUnreachableError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocksError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksServerNetUnreachableError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocksError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSocksServerNetUnreachableError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSocksServerHostUnreachableError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSocksServerHostUnreachableError : public EIdSocksError
{
	typedef EIdSocksError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSocksServerHostUnreachableError(const System::UnicodeString AMsg)/* overload */ : EIdSocksError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSocksServerHostUnreachableError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSocksError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksServerHostUnreachableError(NativeUInt Ident)/* overload */ : EIdSocksError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksServerHostUnreachableError(System::PResStringRec ResStringRec)/* overload */ : EIdSocksError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksServerHostUnreachableError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocksError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksServerHostUnreachableError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocksError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSocksServerHostUnreachableError(const System::UnicodeString Msg, int AHelpContext) : EIdSocksError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSocksServerHostUnreachableError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSocksError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksServerHostUnreachableError(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSocksError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksServerHostUnreachableError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSocksError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksServerHostUnreachableError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocksError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksServerHostUnreachableError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocksError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSocksServerHostUnreachableError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSocksServerConnectionRefusedError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSocksServerConnectionRefusedError : public EIdSocksError
{
	typedef EIdSocksError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSocksServerConnectionRefusedError(const System::UnicodeString AMsg)/* overload */ : EIdSocksError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSocksServerConnectionRefusedError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSocksError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksServerConnectionRefusedError(NativeUInt Ident)/* overload */ : EIdSocksError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksServerConnectionRefusedError(System::PResStringRec ResStringRec)/* overload */ : EIdSocksError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksServerConnectionRefusedError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocksError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksServerConnectionRefusedError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocksError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSocksServerConnectionRefusedError(const System::UnicodeString Msg, int AHelpContext) : EIdSocksError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSocksServerConnectionRefusedError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSocksError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksServerConnectionRefusedError(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSocksError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksServerConnectionRefusedError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSocksError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksServerConnectionRefusedError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocksError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksServerConnectionRefusedError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocksError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSocksServerConnectionRefusedError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSocksServerTTLExpiredError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSocksServerTTLExpiredError : public EIdSocksError
{
	typedef EIdSocksError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSocksServerTTLExpiredError(const System::UnicodeString AMsg)/* overload */ : EIdSocksError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSocksServerTTLExpiredError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSocksError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksServerTTLExpiredError(NativeUInt Ident)/* overload */ : EIdSocksError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksServerTTLExpiredError(System::PResStringRec ResStringRec)/* overload */ : EIdSocksError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksServerTTLExpiredError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocksError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksServerTTLExpiredError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocksError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSocksServerTTLExpiredError(const System::UnicodeString Msg, int AHelpContext) : EIdSocksError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSocksServerTTLExpiredError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSocksError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksServerTTLExpiredError(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSocksError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksServerTTLExpiredError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSocksError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksServerTTLExpiredError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocksError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksServerTTLExpiredError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocksError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSocksServerTTLExpiredError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSocksServerCommandError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSocksServerCommandError : public EIdSocksError
{
	typedef EIdSocksError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSocksServerCommandError(const System::UnicodeString AMsg)/* overload */ : EIdSocksError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSocksServerCommandError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSocksError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksServerCommandError(NativeUInt Ident)/* overload */ : EIdSocksError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksServerCommandError(System::PResStringRec ResStringRec)/* overload */ : EIdSocksError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksServerCommandError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocksError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksServerCommandError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocksError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSocksServerCommandError(const System::UnicodeString Msg, int AHelpContext) : EIdSocksError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSocksServerCommandError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSocksError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksServerCommandError(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSocksError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksServerCommandError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSocksError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksServerCommandError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocksError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksServerCommandError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocksError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSocksServerCommandError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSocksServerAddressError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSocksServerAddressError : public EIdSocksError
{
	typedef EIdSocksError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSocksServerAddressError(const System::UnicodeString AMsg)/* overload */ : EIdSocksError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSocksServerAddressError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSocksError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksServerAddressError(NativeUInt Ident)/* overload */ : EIdSocksError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksServerAddressError(System::PResStringRec ResStringRec)/* overload */ : EIdSocksError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksServerAddressError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocksError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksServerAddressError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocksError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSocksServerAddressError(const System::UnicodeString Msg, int AHelpContext) : EIdSocksError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSocksServerAddressError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSocksError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksServerAddressError(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSocksError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksServerAddressError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSocksError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksServerAddressError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocksError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksServerAddressError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocksError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSocksServerAddressError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdConnectionStateError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdConnectionStateError : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdConnectionStateError(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdConnectionStateError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdConnectionStateError(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdConnectionStateError(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdConnectionStateError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdConnectionStateError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdConnectionStateError(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdConnectionStateError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdConnectionStateError(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdConnectionStateError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdConnectionStateError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdConnectionStateError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdConnectionStateError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdDnsResolverError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdDnsResolverError : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdDnsResolverError(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdDnsResolverError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdDnsResolverError(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdDnsResolverError(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdDnsResolverError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdDnsResolverError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdDnsResolverError(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdDnsResolverError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdDnsResolverError(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdDnsResolverError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdDnsResolverError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdDnsResolverError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdDnsResolverError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdInvalidSocket;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdInvalidSocket : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdInvalidSocket(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdInvalidSocket(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdInvalidSocket(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdInvalidSocket(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdInvalidSocket(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdInvalidSocket(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdInvalidSocket(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdInvalidSocket(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdInvalidSocket(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdInvalidSocket(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdInvalidSocket(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdInvalidSocket(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdInvalidSocket(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdThreadMgrError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdThreadMgrError : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdThreadMgrError(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdThreadMgrError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdThreadMgrError(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdThreadMgrError(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdThreadMgrError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdThreadMgrError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdThreadMgrError(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdThreadMgrError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdThreadMgrError(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdThreadMgrError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdThreadMgrError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdThreadMgrError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdThreadMgrError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdThreadClassNotSpecified;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdThreadClassNotSpecified : public EIdThreadMgrError
{
	typedef EIdThreadMgrError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdThreadClassNotSpecified(const System::UnicodeString AMsg)/* overload */ : EIdThreadMgrError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdThreadClassNotSpecified(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdThreadMgrError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdThreadClassNotSpecified(NativeUInt Ident)/* overload */ : EIdThreadMgrError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdThreadClassNotSpecified(System::PResStringRec ResStringRec)/* overload */ : EIdThreadMgrError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdThreadClassNotSpecified(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdThreadMgrError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdThreadClassNotSpecified(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdThreadMgrError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdThreadClassNotSpecified(const System::UnicodeString Msg, int AHelpContext) : EIdThreadMgrError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdThreadClassNotSpecified(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdThreadMgrError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdThreadClassNotSpecified(NativeUInt Ident, int AHelpContext)/* overload */ : EIdThreadMgrError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdThreadClassNotSpecified(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdThreadMgrError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdThreadClassNotSpecified(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdThreadMgrError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdThreadClassNotSpecified(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdThreadMgrError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdThreadClassNotSpecified(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdTFTPException;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdTFTPException : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdTFTPException(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdTFTPException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdTFTPException(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdTFTPException(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTFTPException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTFTPException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdTFTPException(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdTFTPException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTFTPException(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTFTPException(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTFTPException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTFTPException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdTFTPException(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdTFTPFileNotFound;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdTFTPFileNotFound : public EIdTFTPException
{
	typedef EIdTFTPException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdTFTPFileNotFound(const System::UnicodeString AMsg)/* overload */ : EIdTFTPException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdTFTPFileNotFound(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdTFTPException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdTFTPFileNotFound(NativeUInt Ident)/* overload */ : EIdTFTPException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdTFTPFileNotFound(System::PResStringRec ResStringRec)/* overload */ : EIdTFTPException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTFTPFileNotFound(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTFTPException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTFTPFileNotFound(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTFTPException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdTFTPFileNotFound(const System::UnicodeString Msg, int AHelpContext) : EIdTFTPException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdTFTPFileNotFound(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdTFTPException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTFTPFileNotFound(NativeUInt Ident, int AHelpContext)/* overload */ : EIdTFTPException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTFTPFileNotFound(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdTFTPException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTFTPFileNotFound(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTFTPException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTFTPFileNotFound(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTFTPException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdTFTPFileNotFound(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdTFTPAccessViolation;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdTFTPAccessViolation : public EIdTFTPException
{
	typedef EIdTFTPException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdTFTPAccessViolation(const System::UnicodeString AMsg)/* overload */ : EIdTFTPException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdTFTPAccessViolation(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdTFTPException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdTFTPAccessViolation(NativeUInt Ident)/* overload */ : EIdTFTPException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdTFTPAccessViolation(System::PResStringRec ResStringRec)/* overload */ : EIdTFTPException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTFTPAccessViolation(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTFTPException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTFTPAccessViolation(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTFTPException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdTFTPAccessViolation(const System::UnicodeString Msg, int AHelpContext) : EIdTFTPException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdTFTPAccessViolation(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdTFTPException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTFTPAccessViolation(NativeUInt Ident, int AHelpContext)/* overload */ : EIdTFTPException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTFTPAccessViolation(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdTFTPException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTFTPAccessViolation(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTFTPException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTFTPAccessViolation(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTFTPException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdTFTPAccessViolation(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdTFTPAllocationExceeded;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdTFTPAllocationExceeded : public EIdTFTPException
{
	typedef EIdTFTPException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdTFTPAllocationExceeded(const System::UnicodeString AMsg)/* overload */ : EIdTFTPException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdTFTPAllocationExceeded(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdTFTPException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdTFTPAllocationExceeded(NativeUInt Ident)/* overload */ : EIdTFTPException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdTFTPAllocationExceeded(System::PResStringRec ResStringRec)/* overload */ : EIdTFTPException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTFTPAllocationExceeded(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTFTPException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTFTPAllocationExceeded(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTFTPException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdTFTPAllocationExceeded(const System::UnicodeString Msg, int AHelpContext) : EIdTFTPException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdTFTPAllocationExceeded(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdTFTPException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTFTPAllocationExceeded(NativeUInt Ident, int AHelpContext)/* overload */ : EIdTFTPException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTFTPAllocationExceeded(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdTFTPException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTFTPAllocationExceeded(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTFTPException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTFTPAllocationExceeded(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTFTPException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdTFTPAllocationExceeded(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdTFTPIllegalOperation;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdTFTPIllegalOperation : public EIdTFTPException
{
	typedef EIdTFTPException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdTFTPIllegalOperation(const System::UnicodeString AMsg)/* overload */ : EIdTFTPException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdTFTPIllegalOperation(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdTFTPException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdTFTPIllegalOperation(NativeUInt Ident)/* overload */ : EIdTFTPException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdTFTPIllegalOperation(System::PResStringRec ResStringRec)/* overload */ : EIdTFTPException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTFTPIllegalOperation(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTFTPException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTFTPIllegalOperation(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTFTPException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdTFTPIllegalOperation(const System::UnicodeString Msg, int AHelpContext) : EIdTFTPException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdTFTPIllegalOperation(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdTFTPException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTFTPIllegalOperation(NativeUInt Ident, int AHelpContext)/* overload */ : EIdTFTPException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTFTPIllegalOperation(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdTFTPException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTFTPIllegalOperation(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTFTPException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTFTPIllegalOperation(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTFTPException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdTFTPIllegalOperation(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdTFTPUnknownTransferID;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdTFTPUnknownTransferID : public EIdTFTPException
{
	typedef EIdTFTPException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdTFTPUnknownTransferID(const System::UnicodeString AMsg)/* overload */ : EIdTFTPException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdTFTPUnknownTransferID(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdTFTPException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdTFTPUnknownTransferID(NativeUInt Ident)/* overload */ : EIdTFTPException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdTFTPUnknownTransferID(System::PResStringRec ResStringRec)/* overload */ : EIdTFTPException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTFTPUnknownTransferID(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTFTPException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTFTPUnknownTransferID(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTFTPException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdTFTPUnknownTransferID(const System::UnicodeString Msg, int AHelpContext) : EIdTFTPException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdTFTPUnknownTransferID(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdTFTPException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTFTPUnknownTransferID(NativeUInt Ident, int AHelpContext)/* overload */ : EIdTFTPException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTFTPUnknownTransferID(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdTFTPException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTFTPUnknownTransferID(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTFTPException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTFTPUnknownTransferID(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTFTPException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdTFTPUnknownTransferID(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdTFTPFileAlreadyExists;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdTFTPFileAlreadyExists : public EIdTFTPException
{
	typedef EIdTFTPException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdTFTPFileAlreadyExists(const System::UnicodeString AMsg)/* overload */ : EIdTFTPException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdTFTPFileAlreadyExists(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdTFTPException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdTFTPFileAlreadyExists(NativeUInt Ident)/* overload */ : EIdTFTPException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdTFTPFileAlreadyExists(System::PResStringRec ResStringRec)/* overload */ : EIdTFTPException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTFTPFileAlreadyExists(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTFTPException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTFTPFileAlreadyExists(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTFTPException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdTFTPFileAlreadyExists(const System::UnicodeString Msg, int AHelpContext) : EIdTFTPException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdTFTPFileAlreadyExists(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdTFTPException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTFTPFileAlreadyExists(NativeUInt Ident, int AHelpContext)/* overload */ : EIdTFTPException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTFTPFileAlreadyExists(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdTFTPException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTFTPFileAlreadyExists(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTFTPException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTFTPFileAlreadyExists(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTFTPException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdTFTPFileAlreadyExists(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdTFTPNoSuchUser;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdTFTPNoSuchUser : public EIdTFTPException
{
	typedef EIdTFTPException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdTFTPNoSuchUser(const System::UnicodeString AMsg)/* overload */ : EIdTFTPException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdTFTPNoSuchUser(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdTFTPException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdTFTPNoSuchUser(NativeUInt Ident)/* overload */ : EIdTFTPException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdTFTPNoSuchUser(System::PResStringRec ResStringRec)/* overload */ : EIdTFTPException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTFTPNoSuchUser(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTFTPException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTFTPNoSuchUser(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTFTPException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdTFTPNoSuchUser(const System::UnicodeString Msg, int AHelpContext) : EIdTFTPException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdTFTPNoSuchUser(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdTFTPException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTFTPNoSuchUser(NativeUInt Ident, int AHelpContext)/* overload */ : EIdTFTPException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTFTPNoSuchUser(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdTFTPException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTFTPNoSuchUser(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTFTPException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTFTPNoSuchUser(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTFTPException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdTFTPNoSuchUser(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdTFTPOptionNegotiationFailed;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdTFTPOptionNegotiationFailed : public EIdTFTPException
{
	typedef EIdTFTPException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdTFTPOptionNegotiationFailed(const System::UnicodeString AMsg)/* overload */ : EIdTFTPException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdTFTPOptionNegotiationFailed(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdTFTPException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdTFTPOptionNegotiationFailed(NativeUInt Ident)/* overload */ : EIdTFTPException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdTFTPOptionNegotiationFailed(System::PResStringRec ResStringRec)/* overload */ : EIdTFTPException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTFTPOptionNegotiationFailed(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTFTPException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTFTPOptionNegotiationFailed(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTFTPException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdTFTPOptionNegotiationFailed(const System::UnicodeString Msg, int AHelpContext) : EIdTFTPException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdTFTPOptionNegotiationFailed(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdTFTPException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTFTPOptionNegotiationFailed(NativeUInt Ident, int AHelpContext)/* overload */ : EIdTFTPException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTFTPOptionNegotiationFailed(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdTFTPException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTFTPOptionNegotiationFailed(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTFTPException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTFTPOptionNegotiationFailed(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTFTPException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdTFTPOptionNegotiationFailed(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdIcmpException;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdIcmpException : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdIcmpException(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdIcmpException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdIcmpException(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdIcmpException(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIcmpException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIcmpException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdIcmpException(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdIcmpException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIcmpException(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIcmpException(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIcmpException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIcmpException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdIcmpException(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSetSizeExceeded;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSetSizeExceeded : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSetSizeExceeded(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSetSizeExceeded(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSetSizeExceeded(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSetSizeExceeded(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSetSizeExceeded(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSetSizeExceeded(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSetSizeExceeded(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSetSizeExceeded(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSetSizeExceeded(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSetSizeExceeded(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSetSizeExceeded(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSetSizeExceeded(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSetSizeExceeded(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdMessageException;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdMessageException : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdMessageException(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdMessageException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdMessageException(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdMessageException(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdMessageException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdMessageException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdMessageException(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdMessageException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdMessageException(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdMessageException(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdMessageException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdMessageException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdMessageException(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSchedulerException;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSchedulerException : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSchedulerException(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSchedulerException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSchedulerException(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSchedulerException(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSchedulerException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSchedulerException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSchedulerException(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSchedulerException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSchedulerException(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSchedulerException(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSchedulerException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSchedulerException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSchedulerException(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSchedulerMaxThreadsExceeded;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSchedulerMaxThreadsExceeded : public EIdSchedulerException
{
	typedef EIdSchedulerException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSchedulerMaxThreadsExceeded(const System::UnicodeString AMsg)/* overload */ : EIdSchedulerException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSchedulerMaxThreadsExceeded(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSchedulerException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSchedulerMaxThreadsExceeded(NativeUInt Ident)/* overload */ : EIdSchedulerException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSchedulerMaxThreadsExceeded(System::PResStringRec ResStringRec)/* overload */ : EIdSchedulerException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSchedulerMaxThreadsExceeded(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSchedulerException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSchedulerMaxThreadsExceeded(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSchedulerException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSchedulerMaxThreadsExceeded(const System::UnicodeString Msg, int AHelpContext) : EIdSchedulerException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSchedulerMaxThreadsExceeded(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSchedulerException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSchedulerMaxThreadsExceeded(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSchedulerException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSchedulerMaxThreadsExceeded(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSchedulerException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSchedulerMaxThreadsExceeded(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSchedulerException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSchedulerMaxThreadsExceeded(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSchedulerException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSchedulerMaxThreadsExceeded(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdMaxCaptureLineExceeded;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdMaxCaptureLineExceeded : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdMaxCaptureLineExceeded(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdMaxCaptureLineExceeded(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdMaxCaptureLineExceeded(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdMaxCaptureLineExceeded(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdMaxCaptureLineExceeded(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdMaxCaptureLineExceeded(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdMaxCaptureLineExceeded(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdMaxCaptureLineExceeded(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdMaxCaptureLineExceeded(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdMaxCaptureLineExceeded(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdMaxCaptureLineExceeded(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdMaxCaptureLineExceeded(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdMaxCaptureLineExceeded(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idexceptioncore */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDEXCEPTIONCORE)
using namespace Idexceptioncore;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdexceptioncoreHPP
