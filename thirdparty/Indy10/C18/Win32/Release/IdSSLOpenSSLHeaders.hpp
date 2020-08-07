// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdSSLOpenSSLHeaders.pas' rev: 25.00 (Windows)

#ifndef IdsslopensslheadersHPP
#define IdsslopensslheadersHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <Winapi.Windows.hpp>	// Pascal unit
#include <IdWinsock2.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <IdCTypes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------
#include <time.h>
#undef X509_NAME
#undef X509_EXTENSIONS
#undef X509_CERT_PAIR
#undef PKCS7_ISSUER_AND_SERIAL
#undef OCSP_RESPONSE
#undef OCSP_REQUEST
#undef PKCS7_SIGNER_INFO
#undef OCSP_REQUEST
#undef OCSP_RESPONSE
namespace Idsslopensslheaders
{
	struct SSL;
	typedef SSL* PSSL;
	struct SSL_CTX;
	typedef SSL_CTX* PSSL_CTX;
	struct SSL_METHOD;
	typedef SSL_METHOD* PSSL_METHOD;
	struct X509;
	typedef X509* PX509;
	struct X509_NAME;
	typedef X509_NAME* PX509_NAME;
}
struct RSA;
typedef RSA* PRSA;
struct DSA;
typedef DSA* PDSA;
struct DH;
typedef DH* PDH;
typedef void* PEC_KEY;

namespace Idsslopensslheaders
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS EIdOpenSSLError;
#pragma pack(push,1)
class PASCALIMPLEMENTATION EIdOpenSSLError : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdOpenSSLError(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdOpenSSLError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdOpenSSLError(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdOpenSSLError(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdOpenSSLError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdOpenSSLError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdOpenSSLError(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdOpenSSLError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdOpenSSLError(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdOpenSSLError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdOpenSSLError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdOpenSSLError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdOpenSSLError(void) { }
	
};

#pragma pack(pop)

typedef System::TMetaClass* TIdOpenSSLAPISSLError;

class DELPHICLASS EIdOpenSSLAPISSLError;
#pragma pack(push,1)
class PASCALIMPLEMENTATION EIdOpenSSLAPISSLError : public EIdOpenSSLError
{
	typedef EIdOpenSSLError inherited;
	
protected:
	int FErrorCode;
	int FRetCode;
	
public:
	__classmethod void __fastcall RaiseException(void * ASSL, const int ARetCode, const System::UnicodeString AMsg = System::UnicodeString());
	__classmethod void __fastcall RaiseExceptionCode(const int AErrCode, const int ARetCode, const System::UnicodeString AMsg = System::UnicodeString());
	__property int ErrorCode = {read=FErrorCode, nodefault};
	__property int RetCode = {read=FRetCode, nodefault};
public:
	/* EIdException.Create */ inline __fastcall virtual EIdOpenSSLAPISSLError(const System::UnicodeString AMsg)/* overload */ : EIdOpenSSLError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdOpenSSLAPISSLError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdOpenSSLError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdOpenSSLAPISSLError(NativeUInt Ident)/* overload */ : EIdOpenSSLError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdOpenSSLAPISSLError(System::PResStringRec ResStringRec)/* overload */ : EIdOpenSSLError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdOpenSSLAPISSLError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdOpenSSLError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdOpenSSLAPISSLError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdOpenSSLError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdOpenSSLAPISSLError(const System::UnicodeString Msg, int AHelpContext) : EIdOpenSSLError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdOpenSSLAPISSLError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdOpenSSLError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdOpenSSLAPISSLError(NativeUInt Ident, int AHelpContext)/* overload */ : EIdOpenSSLError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdOpenSSLAPISSLError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdOpenSSLError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdOpenSSLAPISSLError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdOpenSSLError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdOpenSSLAPISSLError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdOpenSSLError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdOpenSSLAPISSLError(void) { }
	
};

#pragma pack(pop)

typedef System::TMetaClass* TIdOpenSSLAPICryptoError;

class DELPHICLASS EIdOpenSSLAPICryptoError;
#pragma pack(push,1)
class PASCALIMPLEMENTATION EIdOpenSSLAPICryptoError : public EIdOpenSSLError
{
	typedef EIdOpenSSLError inherited;
	
protected:
	unsigned FErrorCode;
	
public:
	__classmethod void __fastcall RaiseExceptionCode(const unsigned AErrCode, const System::UnicodeString AMsg = System::UnicodeString());
	__classmethod void __fastcall RaiseException(const System::UnicodeString AMsg = System::UnicodeString());
	__property unsigned ErrorCode = {read=FErrorCode, nodefault};
public:
	/* EIdException.Create */ inline __fastcall virtual EIdOpenSSLAPICryptoError(const System::UnicodeString AMsg)/* overload */ : EIdOpenSSLError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdOpenSSLAPICryptoError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdOpenSSLError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdOpenSSLAPICryptoError(NativeUInt Ident)/* overload */ : EIdOpenSSLError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdOpenSSLAPICryptoError(System::PResStringRec ResStringRec)/* overload */ : EIdOpenSSLError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdOpenSSLAPICryptoError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdOpenSSLError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdOpenSSLAPICryptoError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdOpenSSLError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdOpenSSLAPICryptoError(const System::UnicodeString Msg, int AHelpContext) : EIdOpenSSLError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdOpenSSLAPICryptoError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdOpenSSLError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdOpenSSLAPICryptoError(NativeUInt Ident, int AHelpContext)/* overload */ : EIdOpenSSLError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdOpenSSLAPICryptoError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdOpenSSLError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdOpenSSLAPICryptoError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdOpenSSLError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdOpenSSLAPICryptoError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdOpenSSLError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdOpenSSLAPICryptoError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdOSSLUnderlyingCryptoError;
#pragma pack(push,1)
class PASCALIMPLEMENTATION EIdOSSLUnderlyingCryptoError : public EIdOpenSSLAPICryptoError
{
	typedef EIdOpenSSLAPICryptoError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdOSSLUnderlyingCryptoError(const System::UnicodeString AMsg)/* overload */ : EIdOpenSSLAPICryptoError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdOSSLUnderlyingCryptoError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdOpenSSLAPICryptoError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdOSSLUnderlyingCryptoError(NativeUInt Ident)/* overload */ : EIdOpenSSLAPICryptoError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdOSSLUnderlyingCryptoError(System::PResStringRec ResStringRec)/* overload */ : EIdOpenSSLAPICryptoError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdOSSLUnderlyingCryptoError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdOpenSSLAPICryptoError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdOSSLUnderlyingCryptoError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdOpenSSLAPICryptoError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdOSSLUnderlyingCryptoError(const System::UnicodeString Msg, int AHelpContext) : EIdOpenSSLAPICryptoError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdOSSLUnderlyingCryptoError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdOpenSSLAPICryptoError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdOSSLUnderlyingCryptoError(NativeUInt Ident, int AHelpContext)/* overload */ : EIdOpenSSLAPICryptoError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdOSSLUnderlyingCryptoError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdOpenSSLAPICryptoError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdOSSLUnderlyingCryptoError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdOpenSSLAPICryptoError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdOSSLUnderlyingCryptoError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdOpenSSLAPICryptoError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdOSSLUnderlyingCryptoError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdDigestError;
#pragma pack(push,1)
class PASCALIMPLEMENTATION EIdDigestError : public EIdOpenSSLAPICryptoError
{
	typedef EIdOpenSSLAPICryptoError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdDigestError(const System::UnicodeString AMsg)/* overload */ : EIdOpenSSLAPICryptoError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdDigestError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdOpenSSLAPICryptoError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdDigestError(NativeUInt Ident)/* overload */ : EIdOpenSSLAPICryptoError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdDigestError(System::PResStringRec ResStringRec)/* overload */ : EIdOpenSSLAPICryptoError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdDigestError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdOpenSSLAPICryptoError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdDigestError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdOpenSSLAPICryptoError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdDigestError(const System::UnicodeString Msg, int AHelpContext) : EIdOpenSSLAPICryptoError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdDigestError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdOpenSSLAPICryptoError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdDigestError(NativeUInt Ident, int AHelpContext)/* overload */ : EIdOpenSSLAPICryptoError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdDigestError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdOpenSSLAPICryptoError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdDigestError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdOpenSSLAPICryptoError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdDigestError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdOpenSSLAPICryptoError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdDigestError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdDigestFinalEx;
#pragma pack(push,1)
class PASCALIMPLEMENTATION EIdDigestFinalEx : public EIdDigestError
{
	typedef EIdDigestError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdDigestFinalEx(const System::UnicodeString AMsg)/* overload */ : EIdDigestError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdDigestFinalEx(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdDigestError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdDigestFinalEx(NativeUInt Ident)/* overload */ : EIdDigestError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdDigestFinalEx(System::PResStringRec ResStringRec)/* overload */ : EIdDigestError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdDigestFinalEx(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdDigestError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdDigestFinalEx(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdDigestError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdDigestFinalEx(const System::UnicodeString Msg, int AHelpContext) : EIdDigestError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdDigestFinalEx(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdDigestError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdDigestFinalEx(NativeUInt Ident, int AHelpContext)/* overload */ : EIdDigestError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdDigestFinalEx(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdDigestError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdDigestFinalEx(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdDigestError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdDigestFinalEx(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdDigestError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdDigestFinalEx(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdDigestInitEx;
#pragma pack(push,1)
class PASCALIMPLEMENTATION EIdDigestInitEx : public EIdDigestError
{
	typedef EIdDigestError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdDigestInitEx(const System::UnicodeString AMsg)/* overload */ : EIdDigestError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdDigestInitEx(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdDigestError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdDigestInitEx(NativeUInt Ident)/* overload */ : EIdDigestError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdDigestInitEx(System::PResStringRec ResStringRec)/* overload */ : EIdDigestError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdDigestInitEx(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdDigestError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdDigestInitEx(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdDigestError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdDigestInitEx(const System::UnicodeString Msg, int AHelpContext) : EIdDigestError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdDigestInitEx(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdDigestError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdDigestInitEx(NativeUInt Ident, int AHelpContext)/* overload */ : EIdDigestError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdDigestInitEx(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdDigestError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdDigestInitEx(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdDigestError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdDigestInitEx(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdDigestError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdDigestInitEx(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdDigestUpdate;
#pragma pack(push,1)
class PASCALIMPLEMENTATION EIdDigestUpdate : public EIdDigestError
{
	typedef EIdDigestError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdDigestUpdate(const System::UnicodeString AMsg)/* overload */ : EIdDigestError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdDigestUpdate(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdDigestError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdDigestUpdate(NativeUInt Ident)/* overload */ : EIdDigestError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdDigestUpdate(System::PResStringRec ResStringRec)/* overload */ : EIdDigestError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdDigestUpdate(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdDigestError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdDigestUpdate(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdDigestError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdDigestUpdate(const System::UnicodeString Msg, int AHelpContext) : EIdDigestError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdDigestUpdate(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdDigestError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdDigestUpdate(NativeUInt Ident, int AHelpContext)/* overload */ : EIdDigestError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdDigestUpdate(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdDigestError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdDigestUpdate(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdDigestError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdDigestUpdate(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdDigestError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdDigestUpdate(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE bool __fastcall IsOpenSSL_1x(void);
extern DELPHI_PACKAGE bool __fastcall IsOpenSSL_SSLv2_Available(void);
extern DELPHI_PACKAGE bool __fastcall IsOpenSSL_SSLv3_Available(void);
extern DELPHI_PACKAGE bool __fastcall IsOpenSSL_SSLv23_Available(void);
extern DELPHI_PACKAGE bool __fastcall IsOpenSSL_TLSv1_0_Available(void);
extern DELPHI_PACKAGE bool __fastcall IsOpenSSL_TLSv1_1_Available(void);
extern DELPHI_PACKAGE bool __fastcall IsOpenSSL_TLSv1_2_Available(void);
extern DELPHI_PACKAGE bool __fastcall IsOpenSSL_DTLSv1_Available(void);
extern DELPHI_PACKAGE NativeUInt __fastcall GetSSLLibHandle(void);
extern DELPHI_PACKAGE NativeUInt __fastcall GetCryptLibHandle(void);
extern DELPHI_PACKAGE void __fastcall IdOpenSSLSetLibPath(const System::UnicodeString APath);
extern DELPHI_PACKAGE bool __fastcall Load(void);
extern DELPHI_PACKAGE void __fastcall Unload(void);
extern DELPHI_PACKAGE System::UnicodeString __fastcall WhichFailedToLoad(void);
extern DELPHI_PACKAGE void __fastcall InitializeRandom(void);
extern DELPHI_PACKAGE void __fastcall CleanupRandom(void);
extern DELPHI_PACKAGE void __fastcall RAND_cleanup(void);
extern DELPHI_PACKAGE int __fastcall RAND_bytes(char * buf, int num);
extern DELPHI_PACKAGE int __fastcall RAND_pseudo_bytes(char * buf, int num);
extern DELPHI_PACKAGE void __fastcall RAND_seed(char * buf, int num);
extern DELPHI_PACKAGE void __fastcall RAND_add(char * buf, int num, int entropy);
extern DELPHI_PACKAGE int __fastcall RAND_status(void);
extern DELPHI_PACKAGE int __fastcall RAND_event(unsigned iMsg, NativeUInt wp, NativeInt lp);
extern DELPHI_PACKAGE void __fastcall RAND_screen(void);
}	/* namespace Idsslopensslheaders */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDSSLOPENSSLHEADERS)
using namespace Idsslopensslheaders;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdsslopensslheadersHPP
