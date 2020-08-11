// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdThreadComponent.pas' rev: 25.00 (Windows)

#ifndef IdthreadcomponentHPP
#define IdthreadcomponentHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdThread.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idthreadcomponent
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdThreadComponent;
typedef void __fastcall (__closure *TIdExceptionThreadComponentEvent)(TIdThreadComponent* Sender, System::Sysutils::Exception* AException);

typedef void __fastcall (__closure *TIdExceptionThreadComponentEventEx)(TIdThreadComponent* Sender, System::Sysutils::Exception* AException, bool &VHandled);

typedef void __fastcall (__closure *TIdNotifyThreadComponentEvent)(TIdThreadComponent* Sender);

class PASCALIMPLEMENTATION TIdThreadComponent : public Idbasecomponent::TIdBaseComponent
{
	typedef Idbasecomponent::TIdBaseComponent inherited;
	
protected:
	bool FActive;
	bool FLoop;
	System::Classes::TThreadPriority FPriority;
	Idthread::TIdThreadStopMode FStopMode;
	Idthread::TIdThread* FThread;
	System::UnicodeString FThreadName;
	TIdNotifyThreadComponentEvent FOnAfterExecute;
	TIdNotifyThreadComponentEvent FOnAfterRun;
	TIdNotifyThreadComponentEvent FOnBeforeExecute;
	TIdNotifyThreadComponentEvent FOnBeforeRun;
	TIdNotifyThreadComponentEvent FOnCleanup;
	TIdExceptionThreadComponentEvent FOnException;
	TIdNotifyThreadComponentEvent FOnRun;
	TIdNotifyThreadComponentEvent FOnStopped;
	TIdNotifyThreadComponentEvent FOnTerminate;
	TIdExceptionThreadComponentEventEx FOnHandleRunException;
	virtual void __fastcall DoAfterExecute(void);
	virtual void __fastcall DoAfterRun(void);
	virtual void __fastcall DoBeforeExecute(void);
	virtual void __fastcall DoBeforeRun(void);
	virtual void __fastcall DoCleanup(void);
	virtual void __fastcall DoException(Idthread::TIdThread* AThread, System::Sysutils::Exception* AException);
	virtual bool __fastcall DoHandleRunException(System::Sysutils::Exception* AException);
	virtual void __fastcall DoRun(void);
	virtual void __fastcall DoStopped(Idthread::TIdThread* AThread);
	virtual void __fastcall DoTerminate(System::TObject* Sender);
	bool __fastcall GetActive(void);
	System::TObject* __fastcall GetData(void);
	NativeUInt __fastcall GetHandle(void);
	System::Classes::TThreadPriority __fastcall GetPriority(void);
	int __fastcall GetReturnValue(void);
	Idthread::TIdThreadStopMode __fastcall GetStopMode(void);
	bool __fastcall GetStopped(void);
	bool __fastcall GetSuspended(void);
	System::UnicodeString __fastcall GetTerminatingException(void);
	System::TClass __fastcall GetTerminatingExceptionClass(void);
	bool __fastcall GetTerminated(void);
	virtual void __fastcall InitComponent(void);
	bool __fastcall IsRunning(void);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall SetActive(const bool AValue);
	void __fastcall SetData(System::TObject* const AValue);
	void __fastcall SetLoop(const bool AValue);
	void __fastcall SetThreadName(const System::UnicodeString AValue);
	void __fastcall SetOnTerminate(const TIdNotifyThreadComponentEvent AValue);
	void __fastcall SetPriority(const System::Classes::TThreadPriority AValue);
	void __fastcall SetReturnValue(const int AValue);
	void __fastcall SetStopMode(const Idthread::TIdThreadStopMode AValue);
	
public:
	__fastcall virtual ~TIdThreadComponent(void);
	virtual void __fastcall Start(void);
	virtual void __fastcall Stop(void);
	void __fastcall Synchronize(System::Classes::TThreadMethod AMethod);
	virtual void __fastcall Terminate(void);
	virtual void __fastcall TerminateAndWaitFor(void);
	unsigned __fastcall WaitFor(void);
	__property System::TObject* Data = {read=GetData, write=SetData};
	__property NativeUInt Handle = {read=GetHandle, nodefault};
	__property int ReturnValue = {read=GetReturnValue, write=SetReturnValue, nodefault};
	__property bool Stopped = {read=GetStopped, nodefault};
	__property bool Suspended = {read=GetSuspended, nodefault};
	__property System::UnicodeString TerminatingException = {read=GetTerminatingException};
	__property System::TClass TerminatingExceptionClass = {read=GetTerminatingExceptionClass};
	__property bool Terminated = {read=GetTerminated, nodefault};
	
__published:
	__property bool Active = {read=GetActive, write=SetActive, nodefault};
	__property bool Loop = {read=FLoop, write=SetLoop, nodefault};
	__property System::Classes::TThreadPriority Priority = {read=GetPriority, write=SetPriority, nodefault};
	__property Idthread::TIdThreadStopMode StopMode = {read=GetStopMode, write=SetStopMode, nodefault};
	__property System::UnicodeString ThreadName = {read=FThreadName, write=SetThreadName};
	__property TIdNotifyThreadComponentEvent OnAfterExecute = {read=FOnAfterExecute, write=FOnAfterExecute};
	__property TIdNotifyThreadComponentEvent OnAfterRun = {read=FOnAfterRun, write=FOnAfterRun};
	__property TIdNotifyThreadComponentEvent OnBeforeExecute = {read=FOnBeforeExecute, write=FOnBeforeExecute};
	__property TIdNotifyThreadComponentEvent OnBeforeRun = {read=FOnBeforeRun, write=FOnBeforeRun};
	__property TIdNotifyThreadComponentEvent OnCleanup = {read=FOnCleanup, write=FOnCleanup};
	__property TIdExceptionThreadComponentEvent OnException = {read=FOnException, write=FOnException};
	__property TIdExceptionThreadComponentEventEx OnHandleRunException = {read=FOnHandleRunException, write=FOnHandleRunException};
	__property TIdNotifyThreadComponentEvent OnRun = {read=FOnRun, write=FOnRun};
	__property TIdNotifyThreadComponentEvent OnStopped = {read=FOnStopped, write=FOnStopped};
	__property TIdNotifyThreadComponentEvent OnTerminate = {read=FOnTerminate, write=SetOnTerminate};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdThreadComponent(System::Classes::TComponent* AOwner)/* overload */ : Idbasecomponent::TIdBaseComponent(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdThreadComponent(void)/* overload */ : Idbasecomponent::TIdBaseComponent() { }
	
};


class DELPHICLASS TIdThreadEx;
class PASCALIMPLEMENTATION TIdThreadEx : public Idthread::TIdThread
{
	typedef Idthread::TIdThread inherited;
	
protected:
	TIdThreadComponent* FThreadComponent;
	virtual void __fastcall AfterRun(void);
	virtual void __fastcall AfterExecute(void);
	virtual void __fastcall BeforeExecute(void);
	virtual void __fastcall BeforeRun(void);
	virtual void __fastcall Cleanup(void);
	virtual bool __fastcall HandleRunException(System::Sysutils::Exception* AException);
	virtual void __fastcall Run(void);
	
public:
	__fastcall TIdThreadEx(TIdThreadComponent* AThreadComponent);
public:
	/* TIdThread.Destroy */ inline __fastcall virtual ~TIdThreadEx(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Classes::TThreadPriority IdThreadComponentDefaultPriority = (System::Classes::TThreadPriority)(3);
static const Idthread::TIdThreadStopMode IdThreadComponentDefaultStopMode = (Idthread::TIdThreadStopMode)(0);
}	/* namespace Idthreadcomponent */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDTHREADCOMPONENT)
using namespace Idthreadcomponent;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdthreadcomponentHPP
