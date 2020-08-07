// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdIdent.pas' rev: 25.00 (Windows)

#ifndef IdidentHPP
#define IdidentHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdTCPClient.hpp>	// Pascal unit
#include <IdTCPConnection.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idident
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdIdent;
class PASCALIMPLEMENTATION TIdIdent : public Idtcpclient::TIdTCPClientCustom
{
	typedef Idtcpclient::TIdTCPClientCustom inherited;
	
protected:
	int FQueryTimeOut;
	System::UnicodeString FReplyString;
	System::UnicodeString __fastcall GetReplyCharset(void);
	System::UnicodeString __fastcall GetReplyOS(void);
	System::UnicodeString __fastcall GetReplyOther(void);
	System::UnicodeString __fastcall GetReplyUserName(void);
	System::UnicodeString __fastcall FetchUserReply(void);
	System::UnicodeString __fastcall FetchOS(void);
	void __fastcall ParseError(void);
	virtual void __fastcall InitComponent(void);
	
public:
	void __fastcall Query(System::Word APortOnServer, System::Word APortOnClient);
	__property System::UnicodeString Reply = {read=FReplyString};
	__property System::UnicodeString ReplyCharset = {read=GetReplyCharset};
	__property System::UnicodeString ReplyOS = {read=GetReplyOS};
	__property System::UnicodeString ReplyOther = {read=GetReplyOther};
	__property System::UnicodeString ReplyUserName = {read=GetReplyUserName};
	
__published:
	__property int QueryTimeOut = {read=FQueryTimeOut, write=FQueryTimeOut, default=60000};
	__property Port = {default=113};
	__property Host = {default=0};
public:
	/* TIdTCPConnection.Destroy */ inline __fastcall virtual ~TIdIdent(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdIdent(System::Classes::TComponent* AOwner)/* overload */ : Idtcpclient::TIdTCPClientCustom(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdIdent(void)/* overload */ : Idtcpclient::TIdTCPClientCustom() { }
	
};


class DELPHICLASS EIdIdentException;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdIdentException : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdIdentException(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdIdentException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdIdentException(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdIdentException(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIdentException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIdentException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdIdentException(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdIdentException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIdentException(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIdentException(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIdentException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIdentException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdIdentException(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdIdentReply;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdIdentReply : public EIdIdentException
{
	typedef EIdIdentException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdIdentReply(const System::UnicodeString AMsg)/* overload */ : EIdIdentException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdIdentReply(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdIdentException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdIdentReply(NativeUInt Ident)/* overload */ : EIdIdentException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdIdentReply(System::PResStringRec ResStringRec)/* overload */ : EIdIdentException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIdentReply(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdIdentException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIdentReply(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdIdentException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdIdentReply(const System::UnicodeString Msg, int AHelpContext) : EIdIdentException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdIdentReply(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdIdentException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIdentReply(NativeUInt Ident, int AHelpContext)/* overload */ : EIdIdentException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIdentReply(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdIdentException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIdentReply(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdIdentException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIdentReply(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdIdentException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdIdentReply(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdIdentInvalidPort;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdIdentInvalidPort : public EIdIdentReply
{
	typedef EIdIdentReply inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdIdentInvalidPort(const System::UnicodeString AMsg)/* overload */ : EIdIdentReply(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdIdentInvalidPort(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdIdentReply(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdIdentInvalidPort(NativeUInt Ident)/* overload */ : EIdIdentReply(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdIdentInvalidPort(System::PResStringRec ResStringRec)/* overload */ : EIdIdentReply(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIdentInvalidPort(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdIdentReply(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIdentInvalidPort(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdIdentReply(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdIdentInvalidPort(const System::UnicodeString Msg, int AHelpContext) : EIdIdentReply(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdIdentInvalidPort(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdIdentReply(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIdentInvalidPort(NativeUInt Ident, int AHelpContext)/* overload */ : EIdIdentReply(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIdentInvalidPort(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdIdentReply(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIdentInvalidPort(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdIdentReply(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIdentInvalidPort(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdIdentReply(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdIdentInvalidPort(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdIdentNoUser;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdIdentNoUser : public EIdIdentReply
{
	typedef EIdIdentReply inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdIdentNoUser(const System::UnicodeString AMsg)/* overload */ : EIdIdentReply(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdIdentNoUser(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdIdentReply(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdIdentNoUser(NativeUInt Ident)/* overload */ : EIdIdentReply(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdIdentNoUser(System::PResStringRec ResStringRec)/* overload */ : EIdIdentReply(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIdentNoUser(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdIdentReply(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIdentNoUser(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdIdentReply(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdIdentNoUser(const System::UnicodeString Msg, int AHelpContext) : EIdIdentReply(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdIdentNoUser(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdIdentReply(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIdentNoUser(NativeUInt Ident, int AHelpContext)/* overload */ : EIdIdentReply(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIdentNoUser(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdIdentReply(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIdentNoUser(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdIdentReply(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIdentNoUser(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdIdentReply(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdIdentNoUser(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdIdentHiddenUser;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdIdentHiddenUser : public EIdIdentReply
{
	typedef EIdIdentReply inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdIdentHiddenUser(const System::UnicodeString AMsg)/* overload */ : EIdIdentReply(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdIdentHiddenUser(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdIdentReply(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdIdentHiddenUser(NativeUInt Ident)/* overload */ : EIdIdentReply(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdIdentHiddenUser(System::PResStringRec ResStringRec)/* overload */ : EIdIdentReply(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIdentHiddenUser(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdIdentReply(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIdentHiddenUser(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdIdentReply(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdIdentHiddenUser(const System::UnicodeString Msg, int AHelpContext) : EIdIdentReply(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdIdentHiddenUser(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdIdentReply(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIdentHiddenUser(NativeUInt Ident, int AHelpContext)/* overload */ : EIdIdentReply(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIdentHiddenUser(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdIdentReply(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIdentHiddenUser(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdIdentReply(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIdentHiddenUser(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdIdentReply(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdIdentHiddenUser(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdIdentUnknownError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdIdentUnknownError : public EIdIdentReply
{
	typedef EIdIdentReply inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdIdentUnknownError(const System::UnicodeString AMsg)/* overload */ : EIdIdentReply(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdIdentUnknownError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdIdentReply(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdIdentUnknownError(NativeUInt Ident)/* overload */ : EIdIdentReply(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdIdentUnknownError(System::PResStringRec ResStringRec)/* overload */ : EIdIdentReply(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIdentUnknownError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdIdentReply(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIdentUnknownError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdIdentReply(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdIdentUnknownError(const System::UnicodeString Msg, int AHelpContext) : EIdIdentReply(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdIdentUnknownError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdIdentReply(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIdentUnknownError(NativeUInt Ident, int AHelpContext)/* overload */ : EIdIdentReply(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIdentUnknownError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdIdentReply(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIdentUnknownError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdIdentReply(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIdentUnknownError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdIdentReply(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdIdentUnknownError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdIdentQueryTimeOut;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdIdentQueryTimeOut : public EIdIdentReply
{
	typedef EIdIdentReply inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdIdentQueryTimeOut(const System::UnicodeString AMsg)/* overload */ : EIdIdentReply(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdIdentQueryTimeOut(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdIdentReply(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdIdentQueryTimeOut(NativeUInt Ident)/* overload */ : EIdIdentReply(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdIdentQueryTimeOut(System::PResStringRec ResStringRec)/* overload */ : EIdIdentReply(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIdentQueryTimeOut(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdIdentReply(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIdentQueryTimeOut(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdIdentReply(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdIdentQueryTimeOut(const System::UnicodeString Msg, int AHelpContext) : EIdIdentReply(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdIdentQueryTimeOut(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdIdentReply(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIdentQueryTimeOut(NativeUInt Ident, int AHelpContext)/* overload */ : EIdIdentReply(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIdentQueryTimeOut(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdIdentReply(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIdentQueryTimeOut(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdIdentReply(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIdentQueryTimeOut(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdIdentReply(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdIdentQueryTimeOut(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const System::Word IdIdentQryTimeout = System::Word(0xea60);
}	/* namespace Idident */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDIDENT)
using namespace Idident;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdidentHPP
