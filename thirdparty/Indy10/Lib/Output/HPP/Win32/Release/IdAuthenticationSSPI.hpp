// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdAuthenticationSSPI.pas' rev: 25.00 (Windows)

#ifndef IdauthenticationsspiHPP
#define IdauthenticationsspiHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdAuthentication.hpp>	// Pascal unit
#include <IdCoder.hpp>	// Pascal unit
#include <Winapi.Windows.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <IdSSPI.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------
#pragma link "IdAuthenticationSSPI"

namespace Idauthenticationsspi
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS ESSPIException;
#pragma pack(push,4)
class PASCALIMPLEMENTATION ESSPIException : public System::Sysutils::Exception
{
	typedef System::Sysutils::Exception inherited;
	
public:
	__fastcall ESSPIException(const int AErrorNo, const System::UnicodeString AFailedFuncName);
	__classmethod System::UnicodeString __fastcall GetErrorMessageByNo(unsigned AErrorNo);
public:
	/* Exception.Create */ inline __fastcall ESSPIException(const System::UnicodeString Msg) : System::Sysutils::Exception(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall ESSPIException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : System::Sysutils::Exception(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall ESSPIException(NativeUInt Ident)/* overload */ : System::Sysutils::Exception(Ident) { }
	/* Exception.CreateRes */ inline __fastcall ESSPIException(System::PResStringRec ResStringRec)/* overload */ : System::Sysutils::Exception(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall ESSPIException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall ESSPIException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall ESSPIException(const System::UnicodeString Msg, int AHelpContext) : System::Sysutils::Exception(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall ESSPIException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : System::Sysutils::Exception(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall ESSPIException(NativeUInt Ident, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall ESSPIException(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall ESSPIException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall ESSPIException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~ESSPIException(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS ESSPIInterfaceInitFailed;
#pragma pack(push,4)
class PASCALIMPLEMENTATION ESSPIInterfaceInitFailed : public ESSPIException
{
	typedef ESSPIException inherited;
	
public:
	/* ESSPIException.CreateError */ inline __fastcall ESSPIInterfaceInitFailed(const int AErrorNo, const System::UnicodeString AFailedFuncName) : ESSPIException(AErrorNo, AFailedFuncName) { }
	
public:
	/* Exception.Create */ inline __fastcall ESSPIInterfaceInitFailed(const System::UnicodeString Msg) : ESSPIException(Msg) { }
	/* Exception.CreateFmt */ inline __fastcall ESSPIInterfaceInitFailed(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : ESSPIException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall ESSPIInterfaceInitFailed(NativeUInt Ident)/* overload */ : ESSPIException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall ESSPIInterfaceInitFailed(System::PResStringRec ResStringRec)/* overload */ : ESSPIException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall ESSPIInterfaceInitFailed(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : ESSPIException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall ESSPIInterfaceInitFailed(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : ESSPIException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall ESSPIInterfaceInitFailed(const System::UnicodeString Msg, int AHelpContext) : ESSPIException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall ESSPIInterfaceInitFailed(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : ESSPIException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall ESSPIInterfaceInitFailed(NativeUInt Ident, int AHelpContext)/* overload */ : ESSPIException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall ESSPIInterfaceInitFailed(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : ESSPIException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall ESSPIInterfaceInitFailed(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : ESSPIException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall ESSPIInterfaceInitFailed(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : ESSPIException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~ESSPIInterfaceInitFailed(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TSSPIInterface;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TSSPIInterface : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	bool fLoadPending;
	bool fIsAvailable;
	SecurityFunctionTableW *fPFunctionTable;
	NativeUInt fDLLHandle;
	void __fastcall ReleaseFunctionTable(void);
	void __fastcall CheckAvailable(void);
	SecurityFunctionTableW __fastcall GetFunctionTable(void);
	
public:
	__classmethod void __fastcall RaiseIfError(int aStatus, const System::UnicodeString aFunctionName);
	bool __fastcall IsAvailable(void);
	__property SecurityFunctionTableW FunctionTable = {read=GetFunctionTable};
	__fastcall TSSPIInterface(void);
	__fastcall virtual ~TSSPIInterface(void);
};

#pragma pack(pop)

class DELPHICLASS TSSPIPackage;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TSSPIPackage : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	SecPkgInfoW *fPSecPkginfo;
	PSecPkgInfoW __fastcall GetPSecPkgInfo(void);
	unsigned __fastcall GetMaxToken(void);
	System::UnicodeString __fastcall GetName(void);
	
public:
	__property unsigned MaxToken = {read=GetMaxToken, nodefault};
	__property System::UnicodeString Name = {read=GetName};
	__fastcall TSSPIPackage(PSecPkgInfoW aPSecPkginfo);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TSSPIPackage(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TCustomSSPIPackage;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TCustomSSPIPackage : public TSSPIPackage
{
	typedef TSSPIPackage inherited;
	
private:
	SecPkgInfoW *fInfo;
	
public:
	__fastcall TCustomSSPIPackage(const System::UnicodeString aPkgName);
	__fastcall virtual ~TCustomSSPIPackage(void);
};

#pragma pack(pop)

class DELPHICLASS TSSPINTLMPackage;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TSSPINTLMPackage : public TCustomSSPIPackage
{
	typedef TCustomSSPIPackage inherited;
	
public:
	__fastcall TSSPINTLMPackage(void);
public:
	/* TCustomSSPIPackage.Destroy */ inline __fastcall virtual ~TSSPINTLMPackage(void) { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TSSPICredentialsUse : unsigned char { scuInBound, scuOutBound, scuBoth };

class DELPHICLASS TSSPICredentials;
class PASCALIMPLEMENTATION TSSPICredentials : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	TSSPIPackage* fPackage;
	SecHandle fHandle;
	TSSPICredentialsUse fUse;
	bool fAcquired;
	_LARGE_INTEGER fExpiry;
	PSecHandle __fastcall GetHandle(void);
	void __fastcall SetUse(TSSPICredentialsUse aValue);
	
protected:
	void __fastcall CheckAcquired(void);
	void __fastcall CheckNotAcquired(void);
	void __fastcall DoAcquire(System::WideChar * pszPrincipal, void * pvLogonId, void * pAuthData);
	virtual void __fastcall DoRelease(void);
	
public:
	void __fastcall Release(void);
	__property TSSPIPackage* Package = {read=fPackage};
	__property PSecHandle Handle = {read=GetHandle};
	__property TSSPICredentialsUse Use = {read=fUse, write=SetUse, nodefault};
	__property bool Acquired = {read=fAcquired, nodefault};
	__fastcall TSSPICredentials(TSSPIPackage* aPackage);
	__fastcall virtual ~TSSPICredentials(void);
};


class DELPHICLASS TSSPIWinNTCredentials;
class PASCALIMPLEMENTATION TSSPIWinNTCredentials : public TSSPICredentials
{
	typedef TSSPICredentials inherited;
	
public:
	void __fastcall Acquire(TSSPICredentialsUse aUse)/* overload */;
	void __fastcall Acquire(TSSPICredentialsUse aUse, const System::UnicodeString aDomain, const System::UnicodeString aUserName, const System::UnicodeString aPassword)/* overload */;
public:
	/* TSSPICredentials.Create */ inline __fastcall TSSPIWinNTCredentials(TSSPIPackage* aPackage) : TSSPICredentials(aPackage) { }
	/* TSSPICredentials.Destroy */ inline __fastcall virtual ~TSSPIWinNTCredentials(void) { }
	
};


class DELPHICLASS TSSPIContext;
class PASCALIMPLEMENTATION TSSPIContext : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	TSSPICredentials* fCredentials;
	SecHandle fHandle;
	bool fHasHandle;
	_LARGE_INTEGER fExpiry;
	PSecHandle __fastcall GetHandle(void);
	_LARGE_INTEGER __fastcall GetExpiry(void);
	void __fastcall UpdateHasContextAndCheckForError(const int aFuncResult, const System::UnicodeString aFuncName, int const *aErrorsToIgnore, const int aErrorsToIgnore_Size);
	
protected:
	void __fastcall CheckHasHandle(void);
	void __fastcall CheckCredentials(void);
	int __fastcall DoInitialize(const System::UnicodeString aTokenSourceName, SecBufferDesc &aIn, SecBufferDesc &aOut, int const *errorsToIgnore, const int errorsToIgnore_Size);
	virtual void __fastcall DoRelease(void);
	virtual unsigned __fastcall GetRequestedFlags(void) = 0 ;
	virtual void __fastcall SetEstablishedFlags(unsigned aFlags) = 0 ;
	virtual bool __fastcall GetAuthenticated(void) = 0 ;
	__property bool HasHandle = {read=fHasHandle, nodefault};
	
public:
	void __fastcall Release(void);
	__property TSSPICredentials* Credentials = {read=fCredentials};
	__property PSecHandle Handle = {read=GetHandle};
	__property bool Authenticated = {read=GetAuthenticated, nodefault};
	__property _LARGE_INTEGER Expiry = {read=GetExpiry};
	__fastcall TSSPIContext(TSSPICredentials* aCredentials);
	__fastcall virtual ~TSSPIContext(void);
};


class DELPHICLASS TCustomSSPIConnectionContext;
class PASCALIMPLEMENTATION TCustomSSPIConnectionContext : public TSSPIContext
{
	typedef TSSPIContext inherited;
	
private:
	int fStatus;
	SecBufferDesc fOutBuffDesc;
	SecBufferDesc fInBuffDesc;
	SecBuffer fInBuff;
	
protected:
	virtual void __fastcall DoRelease(void);
	virtual bool __fastcall GetAuthenticated(void);
	virtual int __fastcall DoUpdateAndGenerateReply(SecBufferDesc &aIn, SecBufferDesc &aOut, int const *aErrorsToIgnore, const int aErrorsToIgnore_Size) = 0 ;
	
public:
	__fastcall TCustomSSPIConnectionContext(TSSPICredentials* ACredentials);
	bool __fastcall UpdateAndGenerateReply(const Idglobal::TIdBytes aFromPeerToken, Idglobal::TIdBytes &aToPeerToken);
public:
	/* TSSPIContext.Destroy */ inline __fastcall virtual ~TCustomSSPIConnectionContext(void) { }
	
};


class DELPHICLASS TSSPIClientConnectionContext;
class PASCALIMPLEMENTATION TSSPIClientConnectionContext : public TCustomSSPIConnectionContext
{
	typedef TCustomSSPIConnectionContext inherited;
	
private:
	System::UnicodeString fTargetName;
	unsigned fReqReguested;
	unsigned fReqEstablished;
	
protected:
	virtual unsigned __fastcall GetRequestedFlags(void);
	virtual void __fastcall SetEstablishedFlags(unsigned aFlags);
	virtual int __fastcall DoUpdateAndGenerateReply(SecBufferDesc &aIn, SecBufferDesc &aOut, int const *aErrorsToIgnore, const int aErrorsToIgnore_Size);
	
public:
	bool __fastcall GenerateInitialChallenge(const System::UnicodeString aTargetName, Idglobal::TIdBytes &aToPeerToken);
	__fastcall TSSPIClientConnectionContext(TSSPICredentials* aCredentials);
public:
	/* TSSPIContext.Destroy */ inline __fastcall virtual ~TSSPIClientConnectionContext(void) { }
	
};


class DELPHICLASS TIndySSPINTLMClient;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIndySSPINTLMClient : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	TSSPINTLMPackage* fNTLMPackage;
	TSSPIWinNTCredentials* fCredentials;
	TSSPIClientConnectionContext* fContext;
	
public:
	void __fastcall SetCredentials(const System::UnicodeString aDomain, const System::UnicodeString aUserName, const System::UnicodeString aPassword);
	void __fastcall SetCredentialsAsCurrentUser(void);
	Idglobal::TIdBytes __fastcall InitAndBuildType1Message(void);
	Idglobal::TIdBytes __fastcall UpdateAndBuildType3Message(const Idglobal::TIdBytes aServerType2Message);
	__fastcall TIndySSPINTLMClient(void);
	__fastcall virtual ~TIndySSPINTLMClient(void);
};

#pragma pack(pop)

class DELPHICLASS TIdSSPINTLMAuthentication;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdSSPINTLMAuthentication : public Idauthentication::TIdAuthentication
{
	typedef Idauthentication::TIdAuthentication inherited;
	
protected:
	System::UnicodeString FNTLMInfo;
	TIndySSPINTLMClient* FSSPIClient;
	void __fastcall SetDomain(const System::UnicodeString Value);
	System::UnicodeString __fastcall GetDomain(void);
	virtual void __fastcall SetUserName(const System::UnicodeString Value);
	virtual int __fastcall GetSteps(void);
	virtual Idauthentication::TIdAuthWhatsNext __fastcall DoNext(void);
	
public:
	__fastcall virtual TIdSSPINTLMAuthentication(void);
	__fastcall virtual ~TIdSSPINTLMAuthentication(void);
	virtual System::UnicodeString __fastcall Authentication(void);
	virtual bool __fastcall KeepAlive(void);
	__property System::UnicodeString Domain = {read=GetDomain, write=SetDomain};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idauthenticationsspi */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDAUTHENTICATIONSSPI)
using namespace Idauthenticationsspi;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdauthenticationsspiHPP
