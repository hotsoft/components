// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdIOHandlerSocket.pas' rev: 25.00 (Windows)

#ifndef IdiohandlersocketHPP
#define IdiohandlersocketHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdCustomTransparentProxy.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdIOHandler.hpp>	// Pascal unit
#include <IdSocketHandle.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idiohandlersocket
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdIOHandlerSocket;
class PASCALIMPLEMENTATION TIdIOHandlerSocket : public Idiohandler::TIdIOHandler
{
	typedef Idiohandler::TIdIOHandler inherited;
	
protected:
	Idsockethandle::TIdSocketHandle* FBinding;
	System::UnicodeString FBoundIP;
	System::Word FBoundPort;
	System::Word FBoundPortMax;
	System::Word FBoundPortMin;
	System::Word FDefaultPort;
	System::Classes::TNotifyEvent FOnBeforeBind;
	System::Classes::TNotifyEvent FOnAfterBind;
	System::Classes::TNotifyEvent FOnSocketAllocated;
	Idcustomtransparentproxy::TIdCustomTransparentProxy* FTransparentProxy;
	bool FImplicitTransparentProxy;
	bool FUseNagle;
	Idglobal::TIdReuseSocket FReuseSocket;
	Idglobal::TIdIPVersion FIPVersion;
	virtual void __fastcall ConnectClient(void);
	virtual void __fastcall DoBeforeBind(void);
	virtual void __fastcall DoAfterBind(void);
	virtual void __fastcall DoSocketAllocated(void);
	virtual void __fastcall InitComponent(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual System::UnicodeString __fastcall GetDestination(void);
	virtual void __fastcall SetDestination(const System::UnicodeString AValue);
	Idglobal::TIdReuseSocket __fastcall GetReuseSocket(void);
	void __fastcall SetReuseSocket(Idglobal::TIdReuseSocket AValue);
	virtual Idcustomtransparentproxy::TIdCustomTransparentProxy* __fastcall GetTransparentProxy(void);
	virtual void __fastcall SetTransparentProxy(Idcustomtransparentproxy::TIdCustomTransparentProxy* AProxy);
	bool __fastcall GetUseNagle(void);
	void __fastcall SetUseNagle(bool AValue);
	virtual bool __fastcall SourceIsAvailable(void);
	virtual int __fastcall CheckForError(int ALastResult);
	virtual void __fastcall RaiseError(int AError);
	
public:
	virtual void __fastcall AfterAccept(void);
	__fastcall virtual ~TIdIOHandlerSocket(void);
	bool __fastcall BindingAllocated(void);
	virtual void __fastcall Close(void);
	virtual bool __fastcall Connected(void);
	virtual void __fastcall Open(void);
	virtual __int64 __fastcall WriteFile(const System::UnicodeString AFile, bool AEnableTransferFile = false);
	__property Idsockethandle::TIdSocketHandle* Binding = {read=FBinding};
	__property System::Word BoundPortMax = {read=FBoundPortMax, write=FBoundPortMax, nodefault};
	__property System::Word BoundPortMin = {read=FBoundPortMin, write=FBoundPortMin, nodefault};
	__property System::Classes::TNotifyEvent OnBeforeBind = {read=FOnBeforeBind, write=FOnBeforeBind};
	__property System::Classes::TNotifyEvent OnAfterBind = {read=FOnAfterBind, write=FOnAfterBind};
	__property System::Classes::TNotifyEvent OnSocketAllocated = {read=FOnSocketAllocated, write=FOnSocketAllocated};
	
__published:
	__property System::UnicodeString BoundIP = {read=FBoundIP, write=FBoundIP};
	__property System::Word BoundPort = {read=FBoundPort, write=FBoundPort, default=0};
	__property System::Word DefaultPort = {read=FDefaultPort, write=FDefaultPort, nodefault};
	__property Idglobal::TIdIPVersion IPVersion = {read=FIPVersion, write=FIPVersion, default=0};
	__property Idglobal::TIdReuseSocket ReuseSocket = {read=GetReuseSocket, write=SetReuseSocket, default=0};
	__property Idcustomtransparentproxy::TIdCustomTransparentProxy* TransparentProxy = {read=GetTransparentProxy, write=SetTransparentProxy};
	__property bool UseNagle = {read=GetUseNagle, write=SetUseNagle, default=1};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdIOHandlerSocket(System::Classes::TComponent* AOwner)/* overload */ : Idiohandler::TIdIOHandler(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdIOHandlerSocket(void)/* overload */ : Idiohandler::TIdIOHandler() { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 IdDefTimeout = System::Int8(0x0);
static const System::Int8 IdBoundPortDefault = System::Int8(0x0);
}	/* namespace Idiohandlersocket */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDIOHANDLERSOCKET)
using namespace Idiohandlersocket;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdiohandlersocketHPP
