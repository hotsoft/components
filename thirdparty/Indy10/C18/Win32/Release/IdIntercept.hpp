// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdIntercept.pas' rev: 25.00 (Windows)

#ifndef IdinterceptHPP
#define IdinterceptHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <IdBuffer.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idintercept
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS EIdInterceptCircularLink;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdInterceptCircularLink : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdInterceptCircularLink(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdInterceptCircularLink(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdInterceptCircularLink(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdInterceptCircularLink(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdInterceptCircularLink(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdInterceptCircularLink(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdInterceptCircularLink(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdInterceptCircularLink(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdInterceptCircularLink(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdInterceptCircularLink(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdInterceptCircularLink(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdInterceptCircularLink(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdInterceptCircularLink(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdConnectionIntercept;
typedef void __fastcall (__closure *TIdInterceptNotifyEvent)(TIdConnectionIntercept* ASender);

typedef void __fastcall (__closure *TIdInterceptStreamEvent)(TIdConnectionIntercept* ASender, Idglobal::TIdBytes &ABuffer);

class PASCALIMPLEMENTATION TIdConnectionIntercept : public Idbasecomponent::TIdBaseComponent
{
	typedef Idbasecomponent::TIdBaseComponent inherited;
	
protected:
	System::Classes::TComponent* FConnection;
	TIdConnectionIntercept* FIntercept;
	bool FIsClient;
	System::TObject* FData;
	TIdInterceptNotifyEvent FOnConnect;
	TIdInterceptNotifyEvent FOnDisconnect;
	TIdInterceptStreamEvent FOnReceive;
	TIdInterceptStreamEvent FOnSend;
	virtual void __fastcall InitComponent(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	void __fastcall SetIntercept(TIdConnectionIntercept* AValue);
	
public:
	virtual void __fastcall Connect(System::Classes::TComponent* AConnection);
	virtual void __fastcall Disconnect(void);
	virtual void __fastcall Receive(Idglobal::TIdBytes &VBuffer);
	virtual void __fastcall Send(Idglobal::TIdBytes &VBuffer);
	__property System::Classes::TComponent* Connection = {read=FConnection};
	__property bool IsClient = {read=FIsClient, nodefault};
	__property System::TObject* Data = {read=FData, write=FData};
	
__published:
	__property TIdConnectionIntercept* Intercept = {read=FIntercept, write=SetIntercept};
	__property TIdInterceptNotifyEvent OnConnect = {read=FOnConnect, write=FOnConnect};
	__property TIdInterceptNotifyEvent OnDisconnect = {read=FOnDisconnect, write=FOnDisconnect};
	__property TIdInterceptStreamEvent OnReceive = {read=FOnReceive, write=FOnReceive};
	__property TIdInterceptStreamEvent OnSend = {read=FOnSend, write=FOnSend};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdConnectionIntercept(System::Classes::TComponent* AOwner)/* overload */ : Idbasecomponent::TIdBaseComponent(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdConnectionIntercept(void)/* overload */ : Idbasecomponent::TIdBaseComponent() { }
	
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TIdConnectionIntercept(void) { }
	
};


class DELPHICLASS TIdServerIntercept;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdServerIntercept : public Idbasecomponent::TIdBaseComponent
{
	typedef Idbasecomponent::TIdBaseComponent inherited;
	
public:
	virtual void __fastcall Init(void) = 0 ;
	virtual TIdConnectionIntercept* __fastcall Accept(System::Classes::TComponent* AConnection) = 0 ;
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdServerIntercept(System::Classes::TComponent* AOwner)/* overload */ : Idbasecomponent::TIdBaseComponent(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdServerIntercept(void)/* overload */ : Idbasecomponent::TIdBaseComponent() { }
	
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TIdServerIntercept(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idintercept */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDINTERCEPT)
using namespace Idintercept;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdinterceptHPP
