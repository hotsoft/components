// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdReplyFTP.pas' rev: 25.00 (Windows)

#ifndef IdreplyftpHPP
#define IdreplyftpHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdReply.hpp>	// Pascal unit
#include <IdReplyRFC.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idreplyftp
{
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TIdReplyRFCFormat : unsigned char { rfNormal, rfIndentMidLines };

class DELPHICLASS TIdReplyFTP;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdReplyFTP : public Idreplyrfc::TIdReplyRFC
{
	typedef Idreplyrfc::TIdReplyRFC inherited;
	
protected:
	TIdReplyRFCFormat FReplyFormat;
	virtual System::Classes::TStrings* __fastcall GetFormattedReply(void);
	virtual void __fastcall SetFormattedReply(System::Classes::TStrings* const AValue);
	virtual void __fastcall AssignTo(System::Classes::TPersistent* ADest);
	
public:
	__fastcall virtual TIdReplyFTP(System::Classes::TCollection* ACollection, Idreply::TIdReplies* AReplyTexts);
	virtual void __fastcall Clear(void);
	virtual void __fastcall RaiseReplyError(void);
	__classmethod virtual bool __fastcall IsEndMarker(const System::UnicodeString ALine);
	__classmethod bool __fastcall IsEndReply(const System::UnicodeString AReplyCode, const System::UnicodeString ALine);
	
__published:
	__property TIdReplyRFCFormat ReplyFormat = {read=FReplyFormat, write=FReplyFormat, default=0};
public:
	/* TIdReply.Create */ inline __fastcall virtual TIdReplyFTP(System::Classes::TCollection* ACollection) : Idreplyrfc::TIdReplyRFC(ACollection) { }
	/* TIdReply.Destroy */ inline __fastcall virtual ~TIdReplyFTP(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdRepliesFTP;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdRepliesFTP : public Idreplyrfc::TIdRepliesRFC
{
	typedef Idreplyrfc::TIdRepliesRFC inherited;
	
public:
	__fastcall virtual TIdRepliesFTP(System::Classes::TPersistent* AOwner)/* overload */;
public:
	/* TIdRepliesRFC.Create */ inline __fastcall virtual TIdRepliesFTP(System::Classes::TPersistent* AOwner, const Idreply::TIdReplyClass AReplyClass)/* overload */ : Idreplyrfc::TIdRepliesRFC(AOwner, AReplyClass) { }
	
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TIdRepliesFTP(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdFTPServiceNotAvailable;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdFTPServiceNotAvailable : public Idreplyrfc::EIdReplyRFCError
{
	typedef Idreplyrfc::EIdReplyRFCError inherited;
	
public:
	/* EIdReplyRFCError.CreateError */ inline __fastcall virtual EIdFTPServiceNotAvailable(const int AErrorCode, const System::UnicodeString AReplyMessage) : Idreplyrfc::EIdReplyRFCError(AErrorCode, AReplyMessage) { }
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdFTPServiceNotAvailable(const System::UnicodeString AMsg)/* overload */ : Idreplyrfc::EIdReplyRFCError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdFTPServiceNotAvailable(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idreplyrfc::EIdReplyRFCError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdFTPServiceNotAvailable(NativeUInt Ident)/* overload */ : Idreplyrfc::EIdReplyRFCError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdFTPServiceNotAvailable(System::PResStringRec ResStringRec)/* overload */ : Idreplyrfc::EIdReplyRFCError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdFTPServiceNotAvailable(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idreplyrfc::EIdReplyRFCError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdFTPServiceNotAvailable(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idreplyrfc::EIdReplyRFCError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdFTPServiceNotAvailable(const System::UnicodeString Msg, int AHelpContext) : Idreplyrfc::EIdReplyRFCError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdFTPServiceNotAvailable(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idreplyrfc::EIdReplyRFCError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdFTPServiceNotAvailable(NativeUInt Ident, int AHelpContext)/* overload */ : Idreplyrfc::EIdReplyRFCError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdFTPServiceNotAvailable(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idreplyrfc::EIdReplyRFCError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdFTPServiceNotAvailable(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idreplyrfc::EIdReplyRFCError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdFTPServiceNotAvailable(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idreplyrfc::EIdReplyRFCError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdFTPServiceNotAvailable(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const TIdReplyRFCFormat DEF_ReplyFormat = (TIdReplyRFCFormat)(0);
}	/* namespace Idreplyftp */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDREPLYFTP)
using namespace Idreplyftp;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdreplyftpHPP
