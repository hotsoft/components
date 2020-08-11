// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdCustomTCPServer.pas' rev: 25.00 (Windows)

#ifndef IdcustomtcpserverHPP
#define IdcustomtcpserverHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdContext.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdIntercept.hpp>	// Pascal unit
#include <IdIOHandler.hpp>	// Pascal unit
#include <IdIOHandlerStack.hpp>	// Pascal unit
#include <IdReply.hpp>	// Pascal unit
#include <IdScheduler.hpp>	// Pascal unit
#include <IdSchedulerOfThread.hpp>	// Pascal unit
#include <IdServerIOHandler.hpp>	// Pascal unit
#include <IdServerIOHandlerStack.hpp>	// Pascal unit
#include <IdSocketHandle.hpp>	// Pascal unit
#include <IdStackConsts.hpp>	// Pascal unit
#include <IdTCPConnection.hpp>	// Pascal unit
#include <IdThread.hpp>	// Pascal unit
#include <IdYarn.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <IdTask.hpp>	// Pascal unit
#include <IdThreadSafe.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idcustomtcpserver
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdListenerThread;
class DELPHICLASS TIdCustomTCPServer;
class PASCALIMPLEMENTATION TIdListenerThread : public Idthread::TIdThread
{
	typedef Idthread::TIdThread inherited;
	
protected:
	Idsockethandle::TIdSocketHandle* FBinding;
	TIdCustomTCPServer* FServer;
	Idthread::TIdNotifyThreadEvent FOnBeforeRun;
	virtual void __fastcall AfterRun(void);
	virtual void __fastcall BeforeRun(void);
	virtual void __fastcall Run(void);
	
public:
	__fastcall TIdListenerThread(TIdCustomTCPServer* AServer, Idsockethandle::TIdSocketHandle* ABinding);
	__property Idsockethandle::TIdSocketHandle* Binding = {read=FBinding};
	__property TIdCustomTCPServer* Server = {read=FServer};
	__property Idthread::TIdNotifyThreadEvent OnBeforeRun = {read=FOnBeforeRun, write=FOnBeforeRun};
public:
	/* TIdThread.Destroy */ inline __fastcall virtual ~TIdListenerThread(void) { }
	
};


typedef System::Classes::TThreadList TIdListenerThreadList;

typedef System::Classes::TList TIdListenerList;

typedef void __fastcall (__closure *TIdListenExceptionEvent)(TIdListenerThread* AThread, System::Sysutils::Exception* AException);

typedef void __fastcall (__closure *TIdServerThreadExceptionEvent)(Idcontext::TIdContext* AContext, System::Sysutils::Exception* AException);

typedef void __fastcall (__closure *TIdServerThreadEvent)(Idcontext::TIdContext* AContext);

class DELPHICLASS TIdServerContext;
class PASCALIMPLEMENTATION TIdServerContext : public Idcontext::TIdContext
{
	typedef Idcontext::TIdContext inherited;
	
protected:
	TIdCustomTCPServer* FServer;
	
public:
	__property TIdCustomTCPServer* Server = {read=FServer};
public:
	/* TIdContext.Create */ inline __fastcall virtual TIdServerContext(Idtcpconnection::TIdTCPConnection* AConnection, Idyarn::TIdYarn* AYarn, Idthreadsafe::TIdThreadSafeObjectList* AList) : Idcontext::TIdContext(AConnection, AYarn, AList) { }
	/* TIdContext.Destroy */ inline __fastcall virtual ~TIdServerContext(void) { }
	
};


typedef System::TMetaClass* TIdServerContextClass;

class PASCALIMPLEMENTATION TIdCustomTCPServer : public Idcomponent::TIdComponent
{
	typedef Idcomponent::TIdComponent inherited;
	
protected:
	bool FActive;
	Idscheduler::TIdScheduler* FScheduler;
	Idsockethandle::TIdSocketHandles* FBindings;
	TIdServerContextClass FContextClass;
	bool FImplicitScheduler;
	bool FImplicitIOHandler;
	Idintercept::TIdServerIntercept* FIntercept;
	Idserveriohandler::TIdServerIOHandler* FIOHandler;
	System::Classes::TThreadList* FListenerThreads;
	int FListenQueue;
	int FMaxConnections;
	Idglobal::TIdReuseSocket FReuseSocket;
	int FTerminateWaitTime;
	Idthreadsafe::TIdThreadSafeObjectList* FContexts;
	TIdServerThreadEvent FOnContextCreated;
	TIdServerThreadEvent FOnConnect;
	TIdServerThreadEvent FOnDisconnect;
	TIdServerThreadExceptionEvent FOnException;
	TIdServerThreadEvent FOnExecute;
	TIdListenExceptionEvent FOnListenException;
	Idsockethandle::TIdSocketHandleEvent FOnBeforeBind;
	System::Classes::TNotifyEvent FOnAfterBind;
	Idthread::TIdNotifyThreadEvent FOnBeforeListenerRun;
	bool FUseNagle;
	void __fastcall CheckActive(void);
	virtual void __fastcall CheckOkToBeActive(void);
	virtual void __fastcall ContextCreated(Idcontext::TIdContext* AContext);
	virtual void __fastcall ContextConnected(Idcontext::TIdContext* AContext);
	virtual void __fastcall ContextDisconnected(Idcontext::TIdContext* AContext);
	virtual Idtcpconnection::TIdTCPConnection* __fastcall CreateConnection(void);
	virtual void __fastcall DoBeforeBind(Idsockethandle::TIdSocketHandle* AHandle);
	virtual void __fastcall DoAfterBind(void);
	virtual void __fastcall DoBeforeListenerRun(Idthread::TIdThread* AThread);
	virtual void __fastcall DoConnect(Idcontext::TIdContext* AContext);
	virtual void __fastcall DoDisconnect(Idcontext::TIdContext* AContext);
	virtual void __fastcall DoException(Idcontext::TIdContext* AContext, System::Sysutils::Exception* AException);
	virtual bool __fastcall DoExecute(Idcontext::TIdContext* AContext);
	virtual void __fastcall DoListenException(TIdListenerThread* AThread, System::Sysutils::Exception* AException);
	virtual void __fastcall DoMaxConnectionsExceeded(Idiohandler::TIdIOHandler* AIOHandler);
	virtual void __fastcall DoTerminateContext(Idcontext::TIdContext* AContext);
	System::Word __fastcall GetDefaultPort(void);
	virtual void __fastcall InitComponent(void);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall SendGreeting(Idcontext::TIdContext* AContext, Idreply::TIdReply* AGreeting);
	virtual void __fastcall SetActive(bool AValue);
	virtual void __fastcall SetBindings(Idsockethandle::TIdSocketHandles* const AValue);
	virtual void __fastcall SetDefaultPort(const System::Word AValue);
	virtual void __fastcall SetIntercept(Idintercept::TIdServerIntercept* const AValue);
	virtual void __fastcall SetIOHandler(Idserveriohandler::TIdServerIOHandler* const AValue);
	virtual void __fastcall SetScheduler(Idscheduler::TIdScheduler* const AValue);
	virtual void __fastcall Startup(void);
	virtual void __fastcall Shutdown(void);
	void __fastcall TerminateAllThreads(void);
	__property TIdServerThreadEvent OnExecute = {read=FOnExecute, write=FOnExecute};
	
public:
	__fastcall virtual ~TIdCustomTCPServer(void);
	void __fastcall StartListening(void);
	void __fastcall StopListening(void);
	__property Idthreadsafe::TIdThreadSafeObjectList* Contexts = {read=FContexts};
	__property TIdServerContextClass ContextClass = {read=FContextClass, write=FContextClass};
	__property bool ImplicitIOHandler = {read=FImplicitIOHandler, nodefault};
	__property bool ImplicitScheduler = {read=FImplicitScheduler, nodefault};
	
__published:
	__property bool Active = {read=FActive, write=SetActive, default=0};
	__property Idsockethandle::TIdSocketHandles* Bindings = {read=FBindings, write=SetBindings};
	__property System::Word DefaultPort = {read=GetDefaultPort, write=SetDefaultPort, nodefault};
	__property Idintercept::TIdServerIntercept* Intercept = {read=FIntercept, write=SetIntercept};
	__property Idserveriohandler::TIdServerIOHandler* IOHandler = {read=FIOHandler, write=SetIOHandler};
	__property int ListenQueue = {read=FListenQueue, write=FListenQueue, default=15};
	__property int MaxConnections = {read=FMaxConnections, write=FMaxConnections, default=0};
	__property Idsockethandle::TIdSocketHandleEvent OnBeforeBind = {read=FOnBeforeBind, write=FOnBeforeBind};
	__property System::Classes::TNotifyEvent OnAfterBind = {read=FOnAfterBind, write=FOnAfterBind};
	__property Idthread::TIdNotifyThreadEvent OnBeforeListenerRun = {read=FOnBeforeListenerRun, write=FOnBeforeListenerRun};
	__property TIdServerThreadEvent OnContextCreated = {read=FOnContextCreated, write=FOnContextCreated};
	__property TIdServerThreadEvent OnConnect = {read=FOnConnect, write=FOnConnect};
	__property TIdServerThreadEvent OnDisconnect = {read=FOnDisconnect, write=FOnDisconnect};
	__property TIdServerThreadExceptionEvent OnException = {read=FOnException, write=FOnException};
	__property TIdListenExceptionEvent OnListenException = {read=FOnListenException, write=FOnListenException};
	__property Idglobal::TIdReuseSocket ReuseSocket = {read=FReuseSocket, write=FReuseSocket, default=0};
	__property bool UseNagle = {read=FUseNagle, write=FUseNagle, default=1};
	__property int TerminateWaitTime = {read=FTerminateWaitTime, write=FTerminateWaitTime, default=5000};
	__property Idscheduler::TIdScheduler* Scheduler = {read=FScheduler, write=SetScheduler};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdCustomTCPServer(System::Classes::TComponent* AOwner)/* overload */ : Idcomponent::TIdComponent(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdCustomTCPServer(void)/* overload */ : Idcomponent::TIdComponent() { }
	
};


class DELPHICLASS EIdTCPServerError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdTCPServerError : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdTCPServerError(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdTCPServerError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdTCPServerError(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdTCPServerError(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTCPServerError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTCPServerError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdTCPServerError(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdTCPServerError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTCPServerError(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTCPServerError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTCPServerError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTCPServerError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdTCPServerError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdNoExecuteSpecified;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdNoExecuteSpecified : public EIdTCPServerError
{
	typedef EIdTCPServerError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdNoExecuteSpecified(const System::UnicodeString AMsg)/* overload */ : EIdTCPServerError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdNoExecuteSpecified(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdTCPServerError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdNoExecuteSpecified(NativeUInt Ident)/* overload */ : EIdTCPServerError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdNoExecuteSpecified(System::PResStringRec ResStringRec)/* overload */ : EIdTCPServerError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNoExecuteSpecified(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTCPServerError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNoExecuteSpecified(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTCPServerError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdNoExecuteSpecified(const System::UnicodeString Msg, int AHelpContext) : EIdTCPServerError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdNoExecuteSpecified(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdTCPServerError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNoExecuteSpecified(NativeUInt Ident, int AHelpContext)/* overload */ : EIdTCPServerError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNoExecuteSpecified(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdTCPServerError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNoExecuteSpecified(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTCPServerError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNoExecuteSpecified(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTCPServerError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdNoExecuteSpecified(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdTerminateThreadTimeout;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdTerminateThreadTimeout : public EIdTCPServerError
{
	typedef EIdTCPServerError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdTerminateThreadTimeout(const System::UnicodeString AMsg)/* overload */ : EIdTCPServerError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdTerminateThreadTimeout(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdTCPServerError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdTerminateThreadTimeout(NativeUInt Ident)/* overload */ : EIdTCPServerError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdTerminateThreadTimeout(System::PResStringRec ResStringRec)/* overload */ : EIdTCPServerError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTerminateThreadTimeout(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTCPServerError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTerminateThreadTimeout(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTCPServerError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdTerminateThreadTimeout(const System::UnicodeString Msg, int AHelpContext) : EIdTCPServerError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdTerminateThreadTimeout(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdTCPServerError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTerminateThreadTimeout(NativeUInt Ident, int AHelpContext)/* overload */ : EIdTCPServerError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTerminateThreadTimeout(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdTCPServerError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTerminateThreadTimeout(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTCPServerError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTerminateThreadTimeout(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTCPServerError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdTerminateThreadTimeout(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const System::Int8 IdListenQueueDefault = System::Int8(0xf);
}	/* namespace Idcustomtcpserver */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDCUSTOMTCPSERVER)
using namespace Idcustomtcpserver;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdcustomtcpserverHPP
