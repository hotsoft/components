// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdReplySMTP.pas' rev: 25.00 (Windows)

#ifndef IdreplysmtpHPP
#define IdreplysmtpHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdReply.hpp>	// Pascal unit
#include <IdReplyRFC.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idreplysmtp
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdSMTPEnhancedCode;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdSMTPEnhancedCode : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	unsigned FStatusClass;
	unsigned FSubject;
	unsigned FDetails;
	bool FAvailable;
	virtual void __fastcall AssignTo(System::Classes::TPersistent* ADest);
	bool __fastcall IsValidReplyCode(const System::UnicodeString AText);
	System::UnicodeString __fastcall GetReplyAsStr(void);
	void __fastcall SetReplyAsStr(const System::UnicodeString AText);
	void __fastcall SetStatusClass(const unsigned AValue);
	void __fastcall SetAvailable(const bool AValue);
	
public:
	__fastcall TIdSMTPEnhancedCode(void);
	
__published:
	__property unsigned StatusClass = {read=FStatusClass, write=SetStatusClass, default=2};
	__property unsigned Subject = {read=FSubject, write=FSubject, default=0};
	__property unsigned Details = {read=FDetails, write=FDetails, default=0};
	__property bool Available = {read=FAvailable, write=SetAvailable, default=0};
	__property System::UnicodeString ReplyAsStr = {read=GetReplyAsStr, write=SetReplyAsStr};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TIdSMTPEnhancedCode(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdReplySMTP;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdReplySMTP : public Idreplyrfc::TIdReplyRFC
{
	typedef Idreplyrfc::TIdReplyRFC inherited;
	
protected:
	TIdSMTPEnhancedCode* FEnhancedCode;
	virtual void __fastcall AssignTo(System::Classes::TPersistent* ADest);
	void __fastcall SetEnhancedCode(TIdSMTPEnhancedCode* AValue);
	virtual System::Classes::TStrings* __fastcall GetFormattedReply(void);
	virtual void __fastcall SetFormattedReply(System::Classes::TStrings* const AValue);
	
public:
	__fastcall virtual TIdReplySMTP(System::Classes::TCollection* ACollection)/* overload */;
	__fastcall virtual TIdReplySMTP(System::Classes::TCollection* ACollection, Idreply::TIdReplies* AReplyTexts)/* overload */;
	__fastcall virtual ~TIdReplySMTP(void);
	virtual void __fastcall RaiseReplyError(void);
	void __fastcall SetEnhReply(const int ANumericCode, const System::UnicodeString AEnhReply, const System::UnicodeString AText);
	
__published:
	__property TIdSMTPEnhancedCode* EnhancedCode = {read=FEnhancedCode, write=SetEnhancedCode};
};

#pragma pack(pop)

class DELPHICLASS TIdRepliesSMTP;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdRepliesSMTP : public Idreplyrfc::TIdRepliesRFC
{
	typedef Idreplyrfc::TIdRepliesRFC inherited;
	
public:
	__fastcall virtual TIdRepliesSMTP(System::Classes::TPersistent* AOwner)/* overload */;
public:
	/* TIdRepliesRFC.Create */ inline __fastcall virtual TIdRepliesSMTP(System::Classes::TPersistent* AOwner, const Idreply::TIdReplyClass AReplyClass)/* overload */ : Idreplyrfc::TIdRepliesRFC(AOwner, AReplyClass) { }
	
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TIdRepliesSMTP(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSMTPReplyError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSMTPReplyError : public Idreplyrfc::EIdReplyRFCError
{
	typedef Idreplyrfc::EIdReplyRFCError inherited;
	
protected:
	TIdSMTPEnhancedCode* FEnhancedCode;
	
public:
	__fastcall EIdSMTPReplyError(const int AErrCode, TIdSMTPEnhancedCode* AEnhanced, const System::UnicodeString AReplyMessage);
	__fastcall virtual ~EIdSMTPReplyError(void);
	__property TIdSMTPEnhancedCode* EnhancedCode = {read=FEnhancedCode};
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSMTPReplyError(const System::UnicodeString AMsg)/* overload */ : Idreplyrfc::EIdReplyRFCError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSMTPReplyError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idreplyrfc::EIdReplyRFCError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSMTPReplyError(NativeUInt Ident)/* overload */ : Idreplyrfc::EIdReplyRFCError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSMTPReplyError(System::PResStringRec ResStringRec)/* overload */ : Idreplyrfc::EIdReplyRFCError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSMTPReplyError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idreplyrfc::EIdReplyRFCError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSMTPReplyError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idreplyrfc::EIdReplyRFCError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSMTPReplyError(const System::UnicodeString Msg, int AHelpContext) : Idreplyrfc::EIdReplyRFCError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSMTPReplyError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idreplyrfc::EIdReplyRFCError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSMTPReplyError(NativeUInt Ident, int AHelpContext)/* overload */ : Idreplyrfc::EIdReplyRFCError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSMTPReplyError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idreplyrfc::EIdReplyRFCError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSMTPReplyError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idreplyrfc::EIdReplyRFCError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSMTPReplyError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idreplyrfc::EIdReplyRFCError(Ident, Args, Args_Size, AHelpContext) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSMTPReply;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSMTPReply : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSMTPReply(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSMTPReply(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSMTPReply(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSMTPReply(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSMTPReply(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSMTPReply(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSMTPReply(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSMTPReply(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSMTPReply(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSMTPReply(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSMTPReply(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSMTPReply(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSMTPReply(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSMTPReplyInvalidReplyString;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSMTPReplyInvalidReplyString : public EIdSMTPReply
{
	typedef EIdSMTPReply inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSMTPReplyInvalidReplyString(const System::UnicodeString AMsg)/* overload */ : EIdSMTPReply(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSMTPReplyInvalidReplyString(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSMTPReply(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSMTPReplyInvalidReplyString(NativeUInt Ident)/* overload */ : EIdSMTPReply(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSMTPReplyInvalidReplyString(System::PResStringRec ResStringRec)/* overload */ : EIdSMTPReply(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSMTPReplyInvalidReplyString(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSMTPReply(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSMTPReplyInvalidReplyString(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSMTPReply(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSMTPReplyInvalidReplyString(const System::UnicodeString Msg, int AHelpContext) : EIdSMTPReply(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSMTPReplyInvalidReplyString(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSMTPReply(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSMTPReplyInvalidReplyString(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSMTPReply(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSMTPReplyInvalidReplyString(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSMTPReply(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSMTPReplyInvalidReplyString(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSMTPReply(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSMTPReplyInvalidReplyString(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSMTPReply(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSMTPReplyInvalidReplyString(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSMTPReplyInvalidClass;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSMTPReplyInvalidClass : public EIdSMTPReply
{
	typedef EIdSMTPReply inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSMTPReplyInvalidClass(const System::UnicodeString AMsg)/* overload */ : EIdSMTPReply(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSMTPReplyInvalidClass(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSMTPReply(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSMTPReplyInvalidClass(NativeUInt Ident)/* overload */ : EIdSMTPReply(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSMTPReplyInvalidClass(System::PResStringRec ResStringRec)/* overload */ : EIdSMTPReply(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSMTPReplyInvalidClass(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSMTPReply(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSMTPReplyInvalidClass(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSMTPReply(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSMTPReplyInvalidClass(const System::UnicodeString Msg, int AHelpContext) : EIdSMTPReply(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSMTPReplyInvalidClass(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSMTPReply(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSMTPReplyInvalidClass(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSMTPReply(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSMTPReplyInvalidClass(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSMTPReply(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSMTPReplyInvalidClass(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSMTPReply(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSMTPReplyInvalidClass(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSMTPReply(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSMTPReplyInvalidClass(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
#define ValidClassChars L"245"
#define ValidClassVals (System::Set<System::Byte, 0, 255> () << 0x2 << 0x4 << 0x5 )
static const System::Int8 CLASS_DEF = System::Int8(0x2);
static const bool AVAIL_DEF = false;
static const System::Int8 NODETAILS = System::Int8(0x0);
static const System::WideChar PARTSEP = (System::WideChar)(0x2e);
#define Id_EHR_USE_STARTTLS L"5.7.0"
#define Id_EHR_GENERIC_OK L"2.0.0"
#define Id_EHR_GENERIC_TRANS L"4.0.0"
#define Id_EHR_GENERIC_PERM L"5.0.0"
#define Id_EHR_MSG_OTH_OK L"2.1.0"
#define Id_EHR_MSG_OTH_TRANS L"4.1.0"
#define Id_EHR_MSG_OTH_PERM L"5.1.0"
#define Id_EHR_MSG_BAD_DEST L"5.1.1"
#define Id_EHR_MSG_BAD_DEST_SYST L"5.1.2"
#define Id_EHR_MSG_BAD_DEST_SYNTAX L"5.1.3"
#define Id_EHR_MSG_AMBIG_DEST L"5.1.4"
#define Id_EHR_MSG_VALID_DEST L"2.1.5"
#define Id_EHR_MSG_DEST_MOVED_NOFORWARD L"2.1.6"
#define Id_EHR_MSG_SENDER_BOX_SYNTAX L"5.1.7"
#define Id_EHR_MSG_BAD_SENDER_ADDR L"5.1.8"
#define Id_EHR_MB_OTHER_STATUS_OK L"2.2.0"
#define Id_EHR_MB_OTHER_STATUS_TRANS L"4.2.0"
#define Id_EHR_MB_OTHER_STATUS_PERM L"5.2.0"
#define Id_EHR_MB_DISABLED_TEMP L"4.2.1"
#define Id_EHR_MB_DISABLED_PERM L"5.2.1"
#define Id_EHR_MB_FULL L"4.2.2"
#define Id_EHR_MB_MSG_LEN_LIMIT L"5.2.3"
#define Id_EHR_MB_ML_EXPAN_TEMP L"4.2.4"
#define Id_EHR_MB_ML_EXPAN_PERM L"5.2.4"
#define Id_EHR_MD_OTHER_OK L"2.3.0"
#define Id_EHR_MD_OTHER_TRANS L"4.3.0"
#define Id_EHR_MD_OTHER_PERM L"5.3.0"
#define Id_EHR_MD_MAIL_SYSTEM_FULL L"4.3.1"
#define Id_EHR_MD_NOT_EXCEPTING_TRANS L"4.3.2"
#define Id_EHR_MD_NOT_EXCEPTING_PERM L"5.3.2"
#define Id_EHR_MD_NOT_CAPABLE_FEAT_TRANS L"4.3.3"
#define Id_EHR_MD_NOT_CAPABLE_FEAT_PERM L"5.3.3"
#define Id_EHR_MD_TOO_BIG L"5.3.4"
#define Id_EHR_MD_INCORRECT_CONFIG_TRANS L"4.3.5"
#define Id_EHR_MD_INCORRECT_CONFIG_PERM L"5.3.5"
#define Id_EHR_NR_OTHER_OK L"2.4.0"
#define Id_EHR_NR_OTHER_TRANS L"4.4.0"
#define Id_EHR_NR_OTHER_PERM L"5.4.0"
#define Id_EHR_NR_NO_ANSWER L"4.4.1"
#define Id_EHR_NR_BAD_CONNECTION L"4.4.2"
#define Id_EHR_NR_DIR_SVR_FAILURE L"4.4.3"
#define Id_EHR_NR_UNABLE_TO_ROUTE_TRANS L"4.4.4"
#define Id_EHR_NR_UNABLE_TO_ROUTE_PERM L"5.4.4"
#define Id_EHR_NR_SYSTEM_CONGESTION L"4.4.5"
#define Id_EHR_NR_LOOP_DETECTED L"4.4.6"
#define Id_EHR_NR_DELIVERY_EXPIRED_TEMP L"4.4.7"
#define Id_EHR_NR_DELIVERY_EXPIRED_PERM L"5.4.7"
#define Id_EHR_PR_OTHER_OK L"2.5.0"
#define Id_EHR_PR_OTHER_TEMP L"4.5.0"
#define Id_EHR_PR_OTHER_PERM L"5.5.0"
#define Id_EHR_PR_INVALID_CMD L"5.5.1"
#define Id_EHR_PR_SYNTAX_ERR L"5.5.2"
#define Id_EHR_PR_TOO_MANY_RECIPIENTS_TEMP L"4.5.3"
#define Id_EHR_PR_TOO_MANY_RECIPIENTS_PERM L"5.5.3"
#define Id_EHR_PR_INVALID_CMD_ARGS L"5.5.4"
#define Id_EHR_PR_WRONG_VER_TRANS L"4.5.5"
#define Id_EHR_PR_WRONG_VER_PERM L"5.5.5"
#define Id_EHR_MED_OTHER_OK L"2.6.0"
#define Id_EHR_MED_OTHER_TRANS L"4.6.0"
#define Id_EHR_MED_OTHER_PERM L"5.6.0"
#define Id_EHR_MED_NOT_SUPPORTED L"5.6.1"
#define Id_EHR_MED_CONV_REQUIRED_PROHIB_TRANS L"4.6.2"
#define Id_EHR_MED_CONV_REQUIRED_PROHIB_PERM L"5.6.2"
#define Id_EHR_MED_CONV_REQUIRED_NOT_SUP_TRANS L"4.6.3"
#define Id_EHR_MED_CONV_REQUIRED_NOT_SUP_PERM L"5.6.3"
#define Id_EHR_MED_CONV_LOSS_WARNING L"2.6.4"
#define Id_EHR_MED_CONV_LOSS_ERROR L"5.6.4"
#define Id_EHR_MED_CONV_FAILED_TRANS L"4.6.5"
#define Id_EHR_MED_CONV_FAILED_PERM L"5.6.5"
#define Id_EHR_SEC_OTHER_OK L"2.7.0"
#define Id_EHR_SEC_OTHER_TRANS L"4.7.0"
#define Id_EHR_SEC_OTHER_PERM L"5.7.0"
#define Id_EHR_SEC_DEL_NOT_AUTH L"5.7.1"
#define Id_EHR_SEC_EXP_NOT_AUTH L"5.7.2"
#define Id_EHR_SEC_CONV_REQ_NOT_POSSIBLE L"5.7.3"
#define Id_EHR_SEC_NOT_SUPPORTED L"5.7.4"
#define Id_EHR_SEC_CRYPT_FAILURE_TRANS L"4.7.5"
#define Id_EHR_SEC_CRYPT_FAILURE_PERM L"5.7.5"
#define Id_EHR_SEC_CRYPT_ALG_NOT_SUP_TRANS L"4.7.6"
#define Id_EHR_SEC_CRYPT_ALG_NOT_SUP_PERM L"5.7.6"
#define Id_EHR_SEC_INTEGRETIY_FAILED_WARN L"2.7.7"
#define Id_EHR_SEC_INTEGRETIY_FAILED_TRANS L"4.7.7"
}	/* namespace Idreplysmtp */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDREPLYSMTP)
using namespace Idreplysmtp;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdreplysmtpHPP
