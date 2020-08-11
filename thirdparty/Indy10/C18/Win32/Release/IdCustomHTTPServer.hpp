// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdCustomHTTPServer.pas' rev: 25.00 (Windows)

#ifndef IdcustomhttpserverHPP
#define IdcustomhttpserverHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdContext.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdStack.hpp>	// Pascal unit
#include <IdExceptionCore.hpp>	// Pascal unit
#include <IdGlobalProtocols.hpp>	// Pascal unit
#include <IdHeaderList.hpp>	// Pascal unit
#include <IdCustomTCPServer.hpp>	// Pascal unit
#include <IdTCPConnection.hpp>	// Pascal unit
#include <IdThread.hpp>	// Pascal unit
#include <IdCookie.hpp>	// Pascal unit
#include <IdHTTPHeaderInfo.hpp>	// Pascal unit
#include <IdStackConsts.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <IdThreadSafe.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idcustomhttpserver
{
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM THTTPCommandType : unsigned char { hcUnknown, hcHEAD, hcGET, hcPOST, hcDELETE, hcPUT, hcTRACE, hcOPTION };

typedef System::StaticArray<System::UnicodeString, 8> Idcustomhttpserver__1;

class DELPHICLASS TIdHTTPSession;
typedef void __fastcall (__closure *TIdHTTPSessionEndEvent)(TIdHTTPSession* Sender);

typedef void __fastcall (__closure *TIdHTTPSessionStartEvent)(TIdHTTPSession* Sender);

typedef void __fastcall (__closure *TIdHTTPCreateSession)(Idcontext::TIdContext* ASender, TIdHTTPSession* &VHTTPSession);

typedef void __fastcall (__closure *TIdHTTPCreatePostStream)(Idcontext::TIdContext* AContext, Idheaderlist::TIdHeaderList* AHeaders, System::Classes::TStream* &VPostStream);

class DELPHICLASS TIdHTTPRequestInfo;
typedef void __fastcall (__closure *TIdHTTPDoneWithPostStream)(Idcontext::TIdContext* AContext, TIdHTTPRequestInfo* ARequestInfo, bool &VCanFree);

typedef void __fastcall (__closure *TIdHTTPParseAuthenticationEvent)(Idcontext::TIdContext* AContext, const System::UnicodeString AAuthType, const System::UnicodeString AAuthData, System::UnicodeString &VUsername, System::UnicodeString &VPassword, bool &VHandled);

class DELPHICLASS TIdHTTPResponseInfo;
typedef void __fastcall (__closure *TIdHTTPCommandEvent)(Idcontext::TIdContext* AContext, TIdHTTPRequestInfo* ARequestInfo, TIdHTTPResponseInfo* AResponseInfo);

typedef void __fastcall (__closure *TIdHTTPCommandError)(Idcontext::TIdContext* AContext, TIdHTTPRequestInfo* ARequestInfo, TIdHTTPResponseInfo* AResponseInfo, System::Sysutils::Exception* AException);

typedef void __fastcall (__closure *TIdHTTPInvalidSessionEvent)(Idcontext::TIdContext* AContext, TIdHTTPRequestInfo* ARequestInfo, TIdHTTPResponseInfo* AResponseInfo, bool &VContinueProcessing, const System::UnicodeString AInvalidSessionID);

typedef void __fastcall (__closure *TIdHTTPHeadersAvailableEvent)(Idcontext::TIdContext* AContext, const System::UnicodeString AUri, Idheaderlist::TIdHeaderList* AHeaders, bool &VContinueProcessing);

typedef void __fastcall (__closure *TIdHTTPHeadersBlockedEvent)(Idcontext::TIdContext* AContext, Idheaderlist::TIdHeaderList* AHeaders, int &VResponseNo, System::UnicodeString &VResponseText, System::UnicodeString &VContentText);

typedef void __fastcall (__closure *TIdHTTPHeaderExpectationsEvent)(Idcontext::TIdContext* AContext, const System::UnicodeString AExpectations, bool &VContinueProcessing);

typedef void __fastcall (__closure *TIdHTTPQuerySSLPortEvent)(System::Word APort, bool &VUseSSL);

class DELPHICLASS EIdHTTPServerError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdHTTPServerError : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdHTTPServerError(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdHTTPServerError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdHTTPServerError(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdHTTPServerError(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdHTTPServerError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdHTTPServerError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdHTTPServerError(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdHTTPServerError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdHTTPServerError(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdHTTPServerError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdHTTPServerError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdHTTPServerError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdHTTPServerError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdHTTPHeaderAlreadyWritten;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdHTTPHeaderAlreadyWritten : public EIdHTTPServerError
{
	typedef EIdHTTPServerError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdHTTPHeaderAlreadyWritten(const System::UnicodeString AMsg)/* overload */ : EIdHTTPServerError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdHTTPHeaderAlreadyWritten(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdHTTPServerError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdHTTPHeaderAlreadyWritten(NativeUInt Ident)/* overload */ : EIdHTTPServerError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdHTTPHeaderAlreadyWritten(System::PResStringRec ResStringRec)/* overload */ : EIdHTTPServerError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdHTTPHeaderAlreadyWritten(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdHTTPServerError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdHTTPHeaderAlreadyWritten(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdHTTPServerError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdHTTPHeaderAlreadyWritten(const System::UnicodeString Msg, int AHelpContext) : EIdHTTPServerError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdHTTPHeaderAlreadyWritten(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdHTTPServerError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdHTTPHeaderAlreadyWritten(NativeUInt Ident, int AHelpContext)/* overload */ : EIdHTTPServerError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdHTTPHeaderAlreadyWritten(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdHTTPServerError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdHTTPHeaderAlreadyWritten(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdHTTPServerError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdHTTPHeaderAlreadyWritten(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdHTTPServerError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdHTTPHeaderAlreadyWritten(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdHTTPErrorParsingCommand;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdHTTPErrorParsingCommand : public EIdHTTPServerError
{
	typedef EIdHTTPServerError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdHTTPErrorParsingCommand(const System::UnicodeString AMsg)/* overload */ : EIdHTTPServerError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdHTTPErrorParsingCommand(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdHTTPServerError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdHTTPErrorParsingCommand(NativeUInt Ident)/* overload */ : EIdHTTPServerError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdHTTPErrorParsingCommand(System::PResStringRec ResStringRec)/* overload */ : EIdHTTPServerError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdHTTPErrorParsingCommand(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdHTTPServerError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdHTTPErrorParsingCommand(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdHTTPServerError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdHTTPErrorParsingCommand(const System::UnicodeString Msg, int AHelpContext) : EIdHTTPServerError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdHTTPErrorParsingCommand(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdHTTPServerError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdHTTPErrorParsingCommand(NativeUInt Ident, int AHelpContext)/* overload */ : EIdHTTPServerError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdHTTPErrorParsingCommand(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdHTTPServerError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdHTTPErrorParsingCommand(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdHTTPServerError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdHTTPErrorParsingCommand(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdHTTPServerError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdHTTPErrorParsingCommand(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdHTTPUnsupportedAuthorisationScheme;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdHTTPUnsupportedAuthorisationScheme : public EIdHTTPServerError
{
	typedef EIdHTTPServerError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdHTTPUnsupportedAuthorisationScheme(const System::UnicodeString AMsg)/* overload */ : EIdHTTPServerError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdHTTPUnsupportedAuthorisationScheme(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdHTTPServerError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdHTTPUnsupportedAuthorisationScheme(NativeUInt Ident)/* overload */ : EIdHTTPServerError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdHTTPUnsupportedAuthorisationScheme(System::PResStringRec ResStringRec)/* overload */ : EIdHTTPServerError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdHTTPUnsupportedAuthorisationScheme(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdHTTPServerError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdHTTPUnsupportedAuthorisationScheme(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdHTTPServerError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdHTTPUnsupportedAuthorisationScheme(const System::UnicodeString Msg, int AHelpContext) : EIdHTTPServerError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdHTTPUnsupportedAuthorisationScheme(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdHTTPServerError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdHTTPUnsupportedAuthorisationScheme(NativeUInt Ident, int AHelpContext)/* overload */ : EIdHTTPServerError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdHTTPUnsupportedAuthorisationScheme(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdHTTPServerError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdHTTPUnsupportedAuthorisationScheme(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdHTTPServerError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdHTTPUnsupportedAuthorisationScheme(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdHTTPServerError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdHTTPUnsupportedAuthorisationScheme(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdHTTPCannotSwitchSessionStateWhenActive;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdHTTPCannotSwitchSessionStateWhenActive : public EIdHTTPServerError
{
	typedef EIdHTTPServerError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdHTTPCannotSwitchSessionStateWhenActive(const System::UnicodeString AMsg)/* overload */ : EIdHTTPServerError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdHTTPCannotSwitchSessionStateWhenActive(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdHTTPServerError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdHTTPCannotSwitchSessionStateWhenActive(NativeUInt Ident)/* overload */ : EIdHTTPServerError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdHTTPCannotSwitchSessionStateWhenActive(System::PResStringRec ResStringRec)/* overload */ : EIdHTTPServerError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdHTTPCannotSwitchSessionStateWhenActive(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdHTTPServerError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdHTTPCannotSwitchSessionStateWhenActive(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdHTTPServerError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdHTTPCannotSwitchSessionStateWhenActive(const System::UnicodeString Msg, int AHelpContext) : EIdHTTPServerError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdHTTPCannotSwitchSessionStateWhenActive(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdHTTPServerError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdHTTPCannotSwitchSessionStateWhenActive(NativeUInt Ident, int AHelpContext)/* overload */ : EIdHTTPServerError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdHTTPCannotSwitchSessionStateWhenActive(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdHTTPServerError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdHTTPCannotSwitchSessionStateWhenActive(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdHTTPServerError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdHTTPCannotSwitchSessionStateWhenActive(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdHTTPServerError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdHTTPCannotSwitchSessionStateWhenActive(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdHTTPCannotSwitchSessionIDCookieNameWhenActive;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdHTTPCannotSwitchSessionIDCookieNameWhenActive : public EIdHTTPServerError
{
	typedef EIdHTTPServerError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdHTTPCannotSwitchSessionIDCookieNameWhenActive(const System::UnicodeString AMsg)/* overload */ : EIdHTTPServerError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdHTTPCannotSwitchSessionIDCookieNameWhenActive(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdHTTPServerError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdHTTPCannotSwitchSessionIDCookieNameWhenActive(NativeUInt Ident)/* overload */ : EIdHTTPServerError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdHTTPCannotSwitchSessionIDCookieNameWhenActive(System::PResStringRec ResStringRec)/* overload */ : EIdHTTPServerError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdHTTPCannotSwitchSessionIDCookieNameWhenActive(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdHTTPServerError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdHTTPCannotSwitchSessionIDCookieNameWhenActive(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdHTTPServerError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdHTTPCannotSwitchSessionIDCookieNameWhenActive(const System::UnicodeString Msg, int AHelpContext) : EIdHTTPServerError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdHTTPCannotSwitchSessionIDCookieNameWhenActive(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdHTTPServerError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdHTTPCannotSwitchSessionIDCookieNameWhenActive(NativeUInt Ident, int AHelpContext)/* overload */ : EIdHTTPServerError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdHTTPCannotSwitchSessionIDCookieNameWhenActive(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdHTTPServerError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdHTTPCannotSwitchSessionIDCookieNameWhenActive(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdHTTPServerError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdHTTPCannotSwitchSessionIDCookieNameWhenActive(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdHTTPServerError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdHTTPCannotSwitchSessionIDCookieNameWhenActive(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TIdHTTPRequestInfo : public Idhttpheaderinfo::TIdRequestHeaderInfo
{
	typedef Idhttpheaderinfo::TIdRequestHeaderInfo inherited;
	
protected:
	bool FAuthExists;
	Idcookie::TIdCookies* FCookies;
	System::Classes::TStrings* FParams;
	System::Classes::TStream* FPostStream;
	System::UnicodeString FRawHTTPCommand;
	System::UnicodeString FRemoteIP;
	TIdHTTPSession* FSession;
	System::UnicodeString FDocument;
	System::UnicodeString FURI;
	System::UnicodeString FCommand;
	System::UnicodeString FVersion;
	int FVersionMajor;
	int FVersionMinor;
	System::UnicodeString FAuthUsername;
	System::UnicodeString FAuthPassword;
	System::UnicodeString FUnparsedParams;
	System::UnicodeString FQueryParams;
	System::UnicodeString FFormParams;
	THTTPCommandType FCommandType;
	virtual void __fastcall DecodeAndSetParams(const System::UnicodeString AValue);
	
public:
	__fastcall virtual TIdHTTPRequestInfo(System::Classes::TPersistent* AOwner);
	__fastcall virtual ~TIdHTTPRequestInfo(void);
	bool __fastcall IsVersionAtLeast(const int AMajor, const int AMinor);
	__property TIdHTTPSession* Session = {read=FSession};
	__property bool AuthExists = {read=FAuthExists, nodefault};
	__property System::UnicodeString AuthPassword = {read=FAuthPassword};
	__property System::UnicodeString AuthUsername = {read=FAuthUsername};
	__property System::UnicodeString Command = {read=FCommand};
	__property THTTPCommandType CommandType = {read=FCommandType, nodefault};
	__property Idcookie::TIdCookies* Cookies = {read=FCookies};
	__property System::UnicodeString Document = {read=FDocument, write=FDocument};
	__property System::UnicodeString URI = {read=FURI};
	__property System::Classes::TStrings* Params = {read=FParams};
	__property System::Classes::TStream* PostStream = {read=FPostStream, write=FPostStream};
	__property System::UnicodeString RawHTTPCommand = {read=FRawHTTPCommand};
	__property System::UnicodeString RemoteIP = {read=FRemoteIP};
	__property System::UnicodeString UnparsedParams = {read=FUnparsedParams, write=FUnparsedParams};
	__property System::UnicodeString FormParams = {read=FFormParams, write=FFormParams};
	__property System::UnicodeString QueryParams = {read=FQueryParams, write=FQueryParams};
	__property System::UnicodeString Version = {read=FVersion};
	__property int VersionMajor = {read=FVersionMajor, nodefault};
	__property int VersionMinor = {read=FVersionMinor, nodefault};
};


class DELPHICLASS TIdCustomHTTPServer;
class PASCALIMPLEMENTATION TIdHTTPResponseInfo : public Idhttpheaderinfo::TIdResponseHeaderInfo
{
	typedef Idhttpheaderinfo::TIdResponseHeaderInfo inherited;
	
protected:
	System::UnicodeString FAuthRealm;
	Idtcpconnection::TIdTCPConnection* FConnection;
	int FResponseNo;
	Idcookie::TIdCookies* FCookies;
	System::Classes::TStream* FContentStream;
	System::UnicodeString FContentText;
	bool FCloseConnection;
	bool FFreeContentStream;
	bool FHeaderHasBeenWritten;
	System::UnicodeString FResponseText;
	TIdCustomHTTPServer* FHTTPServer;
	TIdHTTPSession* FSession;
	TIdHTTPRequestInfo* FRequestInfo;
	void __fastcall ReleaseContentStream(void);
	void __fastcall SetCookies(Idcookie::TIdCookies* const AValue);
	virtual void __fastcall SetHeaders(void);
	void __fastcall SetResponseNo(const int AValue);
	void __fastcall SetCloseConnection(const bool Value);
	
public:
	System::UnicodeString __fastcall GetServer(void);
	void __fastcall SetServer(const System::UnicodeString Value);
	void __fastcall CloseSession(void);
	__fastcall TIdHTTPResponseInfo(TIdCustomHTTPServer* AServer, TIdHTTPRequestInfo* ARequestInfo, Idtcpconnection::TIdTCPConnection* AConnection);
	__fastcall virtual ~TIdHTTPResponseInfo(void);
	void __fastcall Redirect(const System::UnicodeString AURL);
	void __fastcall WriteHeader(void);
	void __fastcall WriteContent(void);
	virtual __int64 __fastcall ServeFile(Idcontext::TIdContext* AContext, const System::UnicodeString AFile);
	__int64 __fastcall SmartServeFile(Idcontext::TIdContext* AContext, TIdHTTPRequestInfo* ARequestInfo, const System::UnicodeString AFile);
	__property System::UnicodeString AuthRealm = {read=FAuthRealm, write=FAuthRealm};
	__property bool CloseConnection = {read=FCloseConnection, write=SetCloseConnection, nodefault};
	__property System::Classes::TStream* ContentStream = {read=FContentStream, write=FContentStream};
	__property System::UnicodeString ContentText = {read=FContentText, write=FContentText};
	__property Idcookie::TIdCookies* Cookies = {read=FCookies, write=SetCookies};
	__property bool FreeContentStream = {read=FFreeContentStream, write=FFreeContentStream, nodefault};
	__property bool HeaderHasBeenWritten = {read=FHeaderHasBeenWritten, write=FHeaderHasBeenWritten, nodefault};
	__property int ResponseNo = {read=FResponseNo, write=SetResponseNo, nodefault};
	__property System::UnicodeString ResponseText = {read=FResponseText, write=FResponseText};
	__property TIdCustomHTTPServer* HTTPServer = {read=FHTTPServer};
	__property System::UnicodeString ServerSoftware = {read=GetServer, write=SetServer};
	__property TIdHTTPSession* Session = {read=FSession};
};


class DELPHICLASS TIdHTTPCustomSessionList;
class PASCALIMPLEMENTATION TIdHTTPSession : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	System::Classes::TStrings* FContent;
	System::TDateTime FLastTimeStamp;
	Idglobal::TIdCriticalSection* FLock;
	TIdHTTPCustomSessionList* FOwner;
	System::UnicodeString FSessionID;
	System::UnicodeString FRemoteHost;
	void __fastcall SetContent(System::Classes::TStrings* const Value);
	virtual bool __fastcall IsSessionStale(void);
	virtual void __fastcall DoSessionEnd(void);
	
public:
	__fastcall virtual TIdHTTPSession(TIdHTTPCustomSessionList* AOwner);
	__fastcall virtual TIdHTTPSession(TIdHTTPCustomSessionList* AOwner, const System::UnicodeString SessionID, const System::UnicodeString RemoteIP);
	__fastcall virtual ~TIdHTTPSession(void);
	void __fastcall Lock(void);
	void __fastcall Unlock(void);
	__property System::Classes::TStrings* Content = {read=FContent, write=SetContent};
	__property System::TDateTime LastTimeStamp = {read=FLastTimeStamp};
	__property System::UnicodeString RemoteHost = {read=FRemoteHost};
	__property System::UnicodeString SessionID = {read=FSessionID};
};


typedef System::Classes::TThreadList TIdHTTPSessionThreadList;

typedef System::Classes::TList TIdHTTPSessionList;

class PASCALIMPLEMENTATION TIdHTTPCustomSessionList : public Idbasecomponent::TIdBaseComponent
{
	typedef Idbasecomponent::TIdBaseComponent inherited;
	
private:
	int FSessionTimeout;
	TIdHTTPSessionEndEvent FOnSessionEnd;
	TIdHTTPSessionStartEvent FOnSessionStart;
	
protected:
	virtual void __fastcall RemoveSession(TIdHTTPSession* Session) = 0 ;
	
public:
	virtual void __fastcall Clear(void) = 0 ;
	virtual void __fastcall PurgeStaleSessions(bool PurgeAll = false) = 0 ;
	virtual TIdHTTPSession* __fastcall CreateUniqueSession(const System::UnicodeString RemoteIP) = 0 ;
	virtual TIdHTTPSession* __fastcall CreateSession(const System::UnicodeString RemoteIP, const System::UnicodeString SessionID) = 0 ;
	virtual TIdHTTPSession* __fastcall GetSession(const System::UnicodeString SessionID, const System::UnicodeString RemoteIP) = 0 ;
	virtual void __fastcall Add(TIdHTTPSession* ASession) = 0 ;
	
__published:
	__property int SessionTimeout = {read=FSessionTimeout, write=FSessionTimeout, nodefault};
	__property TIdHTTPSessionEndEvent OnSessionEnd = {read=FOnSessionEnd, write=FOnSessionEnd};
	__property TIdHTTPSessionStartEvent OnSessionStart = {read=FOnSessionStart, write=FOnSessionStart};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdHTTPCustomSessionList(System::Classes::TComponent* AOwner)/* overload */ : Idbasecomponent::TIdBaseComponent(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdHTTPCustomSessionList(void)/* overload */ : Idbasecomponent::TIdBaseComponent() { }
	
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TIdHTTPCustomSessionList(void) { }
	
};


class DELPHICLASS TIdThreadSafeMimeTable;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdThreadSafeMimeTable : public Idthreadsafe::TIdThreadSafe
{
	typedef Idthreadsafe::TIdThreadSafe inherited;
	
protected:
	Idglobalprotocols::TIdMimeTable* FTable;
	bool __fastcall GetLoadTypesFromOS(void);
	void __fastcall SetLoadTypesFromOS(bool AValue);
	System::Classes::TNotifyEvent __fastcall GetOnBuildCache(void);
	void __fastcall SetOnBuildCache(System::Classes::TNotifyEvent AValue);
	
public:
	__fastcall TIdThreadSafeMimeTable(const bool AutoFill);
	__fastcall virtual ~TIdThreadSafeMimeTable(void);
	void __fastcall BuildCache(void);
	void __fastcall AddMimeType(const System::UnicodeString Ext, const System::UnicodeString MIMEType, const bool ARaiseOnError = true);
	System::UnicodeString __fastcall GetFileMIMEType(const System::UnicodeString AFileName);
	System::UnicodeString __fastcall GetDefaultFileExt(const System::UnicodeString MIMEType);
	void __fastcall LoadFromStrings(System::Classes::TStrings* const AStrings, const System::WideChar MimeSeparator = (System::WideChar)(0x3d));
	void __fastcall SaveToStrings(System::Classes::TStrings* const AStrings, const System::WideChar MimeSeparator = (System::WideChar)(0x3d));
	HIDESBASE Idglobalprotocols::TIdMimeTable* __fastcall Lock(void);
	HIDESBASE void __fastcall Unlock(void);
	__property bool LoadTypesFromOS = {read=GetLoadTypesFromOS, write=SetLoadTypesFromOS, nodefault};
	__property System::Classes::TNotifyEvent OnBuildCache = {read=GetOnBuildCache, write=SetOnBuildCache};
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TIdCustomHTTPServer : public Idcustomtcpserver::TIdCustomTCPServer
{
	typedef Idcustomtcpserver::TIdCustomTCPServer inherited;
	
protected:
	bool FAutoStartSession;
	bool FKeepAlive;
	bool FParseParams;
	System::UnicodeString FServerSoftware;
	TIdThreadSafeMimeTable* FMIMETable;
	TIdHTTPCustomSessionList* FSessionList;
	bool FImplicitSessionList;
	bool FSessionState;
	int FSessionTimeOut;
	TIdHTTPCreatePostStream FOnCreatePostStream;
	TIdHTTPDoneWithPostStream FOnDoneWithPostStream;
	TIdHTTPCreateSession FOnCreateSession;
	TIdHTTPInvalidSessionEvent FOnInvalidSession;
	TIdHTTPParseAuthenticationEvent FOnParseAuthentication;
	TIdHTTPSessionEndEvent FOnSessionEnd;
	TIdHTTPSessionStartEvent FOnSessionStart;
	TIdHTTPCommandEvent FOnCommandGet;
	TIdHTTPCommandEvent FOnCommandOther;
	TIdHTTPCommandError FOnCommandError;
	TIdHTTPHeadersAvailableEvent FOnHeadersAvailable;
	TIdHTTPHeadersBlockedEvent FOnHeadersBlocked;
	TIdHTTPHeaderExpectationsEvent FOnHeaderExpectations;
	TIdHTTPQuerySSLPortEvent FOnQuerySSLPort;
	Idthread::TIdThread* FSessionCleanupThread;
	int FMaximumHeaderLineCount;
	System::UnicodeString FSessionIDCookieName;
	virtual void __fastcall CreatePostStream(Idcontext::TIdContext* ASender, Idheaderlist::TIdHeaderList* AHeaders, System::Classes::TStream* &VPostStream);
	virtual void __fastcall DoneWithPostStream(Idcontext::TIdContext* ASender, TIdHTTPRequestInfo* ARequestInfo);
	virtual void __fastcall DoOnCreateSession(Idcontext::TIdContext* AContext, TIdHTTPSession* &VNewSession);
	virtual void __fastcall DoInvalidSession(Idcontext::TIdContext* AContext, TIdHTTPRequestInfo* ARequestInfo, TIdHTTPResponseInfo* AResponseInfo, bool &VContinueProcessing, const System::UnicodeString AInvalidSessionID);
	virtual void __fastcall DoCommandGet(Idcontext::TIdContext* AContext, TIdHTTPRequestInfo* ARequestInfo, TIdHTTPResponseInfo* AResponseInfo);
	virtual void __fastcall DoCommandOther(Idcontext::TIdContext* AContext, TIdHTTPRequestInfo* ARequestInfo, TIdHTTPResponseInfo* AResponseInfo);
	virtual void __fastcall DoCommandError(Idcontext::TIdContext* AContext, TIdHTTPRequestInfo* ARequestInfo, TIdHTTPResponseInfo* AResponseInfo, System::Sysutils::Exception* AException);
	virtual void __fastcall DoConnect(Idcontext::TIdContext* AContext);
	virtual bool __fastcall DoHeadersAvailable(Idcontext::TIdContext* ASender, const System::UnicodeString AUri, Idheaderlist::TIdHeaderList* AHeaders);
	virtual void __fastcall DoHeadersBlocked(Idcontext::TIdContext* ASender, Idheaderlist::TIdHeaderList* AHeaders, int &VResponseNo, System::UnicodeString &VResponseText, System::UnicodeString &VContentText);
	virtual bool __fastcall DoHeaderExpectations(Idcontext::TIdContext* ASender, const System::UnicodeString AExpectations);
	bool __fastcall DoParseAuthentication(Idcontext::TIdContext* ASender, const System::UnicodeString AAuthType, const System::UnicodeString AAuthData, System::UnicodeString &VUsername, System::UnicodeString &VPassword);
	virtual bool __fastcall DoQuerySSLPort(System::Word APort);
	virtual void __fastcall DoSessionEnd(TIdHTTPSession* Sender);
	virtual void __fastcall DoSessionStart(TIdHTTPSession* Sender);
	virtual bool __fastcall DoExecute(Idcontext::TIdContext* AContext);
	virtual void __fastcall Startup(void);
	virtual void __fastcall Shutdown(void);
	void __fastcall SetSessionList(TIdHTTPCustomSessionList* const AValue);
	void __fastcall SetSessionState(const bool Value);
	void __fastcall SetSessionIDCookieName(const System::UnicodeString AValue);
	bool __fastcall IsSessionIDCookieNameStored(void);
	TIdHTTPSession* __fastcall GetSessionFromCookie(Idcontext::TIdContext* AContext, TIdHTTPRequestInfo* AHTTPrequest, TIdHTTPResponseInfo* AHTTPResponse, bool &VContinueProcessing);
	virtual void __fastcall InitComponent(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	__property TIdHTTPCreatePostStream OnCreatePostStream = {read=FOnCreatePostStream, write=FOnCreatePostStream};
	__property TIdHTTPDoneWithPostStream OnDoneWithPostStream = {read=FOnDoneWithPostStream, write=FOnDoneWithPostStream};
	__property TIdHTTPCommandEvent OnCommandGet = {read=FOnCommandGet, write=FOnCommandGet};
	
public:
	__fastcall TIdCustomHTTPServer(System::Classes::TComponent* AOwner)/* overload */;
	TIdHTTPSession* __fastcall CreateSession(Idcontext::TIdContext* AContext, TIdHTTPResponseInfo* HTTPResponse, TIdHTTPRequestInfo* HTTPRequest);
	__fastcall virtual ~TIdCustomHTTPServer(void);
	bool __fastcall EndSession(const System::UnicodeString SessionName, const System::UnicodeString RemoteIP = System::UnicodeString());
	__property TIdThreadSafeMimeTable* MIMETable = {read=FMIMETable};
	__property TIdHTTPCustomSessionList* SessionList = {read=FSessionList, write=SetSessionList};
	
__published:
	__property bool AutoStartSession = {read=FAutoStartSession, write=FAutoStartSession, default=0};
	__property DefaultPort = {default=80};
	__property bool KeepAlive = {read=FKeepAlive, write=FKeepAlive, default=0};
	__property int MaximumHeaderLineCount = {read=FMaximumHeaderLineCount, write=FMaximumHeaderLineCount, default=1024};
	__property bool ParseParams = {read=FParseParams, write=FParseParams, default=1};
	__property System::UnicodeString ServerSoftware = {read=FServerSoftware, write=FServerSoftware};
	__property bool SessionState = {read=FSessionState, write=SetSessionState, default=0};
	__property int SessionTimeOut = {read=FSessionTimeOut, write=FSessionTimeOut, default=0};
	__property System::UnicodeString SessionIDCookieName = {read=FSessionIDCookieName, write=SetSessionIDCookieName, stored=IsSessionIDCookieNameStored};
	__property TIdHTTPCommandError OnCommandError = {read=FOnCommandError, write=FOnCommandError};
	__property TIdHTTPCommandEvent OnCommandOther = {read=FOnCommandOther, write=FOnCommandOther};
	__property TIdHTTPCreateSession OnCreateSession = {read=FOnCreateSession, write=FOnCreateSession};
	__property TIdHTTPInvalidSessionEvent OnInvalidSession = {read=FOnInvalidSession, write=FOnInvalidSession};
	__property TIdHTTPHeadersAvailableEvent OnHeadersAvailable = {read=FOnHeadersAvailable, write=FOnHeadersAvailable};
	__property TIdHTTPHeadersBlockedEvent OnHeadersBlocked = {read=FOnHeadersBlocked, write=FOnHeadersBlocked};
	__property TIdHTTPHeaderExpectationsEvent OnHeaderExpectations = {read=FOnHeaderExpectations, write=FOnHeaderExpectations};
	__property TIdHTTPParseAuthenticationEvent OnParseAuthentication = {read=FOnParseAuthentication, write=FOnParseAuthentication};
	__property TIdHTTPQuerySSLPortEvent OnQuerySSLPort = {read=FOnQuerySSLPort, write=FOnQuerySSLPort};
	__property TIdHTTPSessionStartEvent OnSessionStart = {read=FOnSessionStart, write=FOnSessionStart};
	__property TIdHTTPSessionEndEvent OnSessionEnd = {read=FOnSessionEnd, write=FOnSessionEnd};
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdCustomHTTPServer(void)/* overload */ : Idcustomtcpserver::TIdCustomTCPServer() { }
	
};


class DELPHICLASS TIdHTTPDefaultSessionList;
class PASCALIMPLEMENTATION TIdHTTPDefaultSessionList : public TIdHTTPCustomSessionList
{
	typedef TIdHTTPCustomSessionList inherited;
	
protected:
	System::Classes::TThreadList* FSessionList;
	virtual void __fastcall RemoveSession(TIdHTTPSession* Session);
	void __fastcall RemoveSessionFromLockedList(int AIndex, System::Classes::TList* ALockedSessionList);
	virtual void __fastcall InitComponent(void);
	
public:
	__fastcall virtual ~TIdHTTPDefaultSessionList(void);
	__property System::Classes::TThreadList* SessionList = {read=FSessionList};
	virtual void __fastcall Clear(void);
	virtual void __fastcall Add(TIdHTTPSession* ASession);
	virtual void __fastcall PurgeStaleSessions(bool PurgeAll = false);
	virtual TIdHTTPSession* __fastcall CreateUniqueSession(const System::UnicodeString RemoteIP);
	virtual TIdHTTPSession* __fastcall CreateSession(const System::UnicodeString RemoteIP, const System::UnicodeString SessionID);
	virtual TIdHTTPSession* __fastcall GetSession(const System::UnicodeString SessionID, const System::UnicodeString RemoteIP);
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdHTTPDefaultSessionList(System::Classes::TComponent* AOwner)/* overload */ : TIdHTTPCustomSessionList(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdHTTPDefaultSessionList(void)/* overload */ : TIdHTTPCustomSessionList() { }
	
};


class DELPHICLASS TIdHTTPRangeStream;
class PASCALIMPLEMENTATION TIdHTTPRangeStream : public Idglobal::TIdBaseStream
{
	typedef Idglobal::TIdBaseStream inherited;
	
private:
	System::Classes::TStream* FSourceStream;
	bool FOwnsSource;
	__int64 FRangeStart;
	__int64 FRangeEnd;
	int FResponseCode;
	
protected:
	virtual int __fastcall IdRead(Idglobal::TIdBytes &VBuffer, int AOffset, int ACount);
	virtual int __fastcall IdWrite(const Idglobal::TIdBytes ABuffer, int AOffset, int ACount);
	virtual __int64 __fastcall IdSeek(const __int64 AOffset, System::Classes::TSeekOrigin AOrigin);
	virtual void __fastcall IdSetSize(__int64 ASize);
	
public:
	__fastcall TIdHTTPRangeStream(System::Classes::TStream* ASource, __int64 ARangeStart, __int64 ARangeEnd, bool AOwnsSource);
	__fastcall virtual ~TIdHTTPRangeStream(void);
	__property int ResponseCode = {read=FResponseCode, nodefault};
	__property __int64 RangeStart = {read=FRangeStart};
	__property __int64 RangeEnd = {read=FRangeEnd};
	__property System::Classes::TStream* SourceStream = {read=FSourceStream};
};


//-- var, const, procedure ---------------------------------------------------
static const bool Id_TId_HTTPServer_KeepAlive = false;
static const bool Id_TId_HTTPServer_ParseParams = true;
static const bool Id_TId_HTTPServer_SessionState = false;
static const System::Int8 Id_TId_HTTPSessionTimeOut = System::Int8(0x0);
static const bool Id_TId_HTTPAutoStartSession = false;
static const System::Word Id_TId_HTTPMaximumHeaderLineCount = System::Word(0x400);
static const System::Byte GResponseNo = System::Byte(0xc8);
static const System::Int8 GFContentLength = System::Int8(-1);
#define GServerSoftware L"Indy/10.6.2.0"
#define GContentType L"text/html"
#define GSessionIDCookie L"IDHTTPSESSIONID"
extern DELPHI_PACKAGE Idcustomhttpserver__1 HTTPRequestStrings;
}	/* namespace Idcustomhttpserver */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDCUSTOMHTTPSERVER)
using namespace Idcustomhttpserver;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdcustomhttpserverHPP
