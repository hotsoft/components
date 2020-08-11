// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdThread.pas' rev: 25.00 (Windows)

#ifndef IdthreadHPP
#define IdthreadHPP

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
#include <IdYarn.hpp>	// Pascal unit
#include <IdTask.hpp>	// Pascal unit
#include <IdThreadSafe.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idthread
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS EIdThreadException;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdThreadException : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdThreadException(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdThreadException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdThreadException(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdThreadException(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdThreadException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdThreadException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdThreadException(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdThreadException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdThreadException(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdThreadException(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdThreadException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdThreadException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdThreadException(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdThreadTerminateAndWaitFor;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdThreadTerminateAndWaitFor : public EIdThreadException
{
	typedef EIdThreadException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdThreadTerminateAndWaitFor(const System::UnicodeString AMsg)/* overload */ : EIdThreadException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdThreadTerminateAndWaitFor(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdThreadException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdThreadTerminateAndWaitFor(NativeUInt Ident)/* overload */ : EIdThreadException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdThreadTerminateAndWaitFor(System::PResStringRec ResStringRec)/* overload */ : EIdThreadException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdThreadTerminateAndWaitFor(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdThreadException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdThreadTerminateAndWaitFor(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdThreadException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdThreadTerminateAndWaitFor(const System::UnicodeString Msg, int AHelpContext) : EIdThreadException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdThreadTerminateAndWaitFor(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdThreadException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdThreadTerminateAndWaitFor(NativeUInt Ident, int AHelpContext)/* overload */ : EIdThreadException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdThreadTerminateAndWaitFor(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdThreadException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdThreadTerminateAndWaitFor(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdThreadException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdThreadTerminateAndWaitFor(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdThreadException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdThreadTerminateAndWaitFor(void) { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TIdThreadStopMode : unsigned char { smTerminate, smSuspend };

class DELPHICLASS TIdThread;
typedef void __fastcall (__closure *TIdExceptionThreadEvent)(TIdThread* AThread, System::Sysutils::Exception* AException);

typedef void __fastcall (__closure *TIdNotifyThreadEvent)(TIdThread* AThread);

typedef void __fastcall (__closure *TIdSynchronizeThreadEvent)(TIdThread* AThread, void * AData);

enum DECLSPEC_DENUM Idthread__3 : unsigned char { itoStopped, itoReqCleanup, itoDataOwner, itoTag };

typedef System::Set<Idthread__3, Idthread__3::itoStopped, Idthread__3::itoTag>  TIdThreadOptions;

class PASCALIMPLEMENTATION TIdThread : public System::Classes::TThread
{
	typedef System::Classes::TThread inherited;
	
protected:
	System::TObject* FData;
	Idglobal::TIdCriticalSection* FLock;
	bool FLoop;
	System::UnicodeString FName;
	TIdThreadStopMode FStopMode;
	TIdThreadOptions FOptions;
	System::UnicodeString FTerminatingException;
	System::TClass FTerminatingExceptionClass;
	Idyarn::TIdYarn* FYarn;
	TIdExceptionThreadEvent FOnException;
	TIdNotifyThreadEvent FOnStopped;
	virtual void __fastcall AfterRun(void);
	virtual void __fastcall AfterExecute(void);
	virtual void __fastcall BeforeExecute(void);
	virtual void __fastcall BeforeRun(void);
	virtual void __fastcall Cleanup(void);
	virtual void __fastcall DoException(System::Sysutils::Exception* AException);
	virtual void __fastcall DoStopped(void);
	virtual void __fastcall Execute(void);
	bool __fastcall GetStopped(void);
	virtual bool __fastcall HandleRunException(System::Sysutils::Exception* AException);
	virtual void __fastcall Run(void) = 0 ;
	__classmethod void __fastcall WaitAllThreadsTerminated _DEPRECATED_ATTRIBUTE0 (int AMSec = 0xea60);
	
public:
	__fastcall virtual TIdThread(bool ACreateSuspended, bool ALoop, const System::UnicodeString AName);
	__fastcall virtual ~TIdThread(void);
	HIDESBASE virtual void __fastcall Start(void);
	virtual void __fastcall Stop(void);
	HIDESBASE void __fastcall Synchronize(System::Classes::TThreadMethod Method)/* overload */;
	HIDESBASE virtual void __fastcall Terminate(void);
	virtual void __fastcall TerminateAndWaitFor(void);
	__property System::TObject* Data = {read=FData, write=FData};
	__property bool Loop = {read=FLoop, write=FLoop, nodefault};
	__property System::UnicodeString Name = {read=FName, write=FName};
	__property ReturnValue;
	__property TIdThreadStopMode StopMode = {read=FStopMode, write=FStopMode, nodefault};
	__property bool Stopped = {read=GetStopped, nodefault};
	__property Terminated;
	__property System::UnicodeString TerminatingException = {read=FTerminatingException};
	__property System::TClass TerminatingExceptionClass = {read=FTerminatingExceptionClass};
	__property Idyarn::TIdYarn* Yarn = {read=FYarn, write=FYarn};
	__property TIdExceptionThreadEvent OnException = {read=FOnException, write=FOnException};
	__property TIdNotifyThreadEvent OnStopped = {read=FOnStopped, write=FOnStopped};
/* Hoisted overloads: */
	
protected:
	inline void __fastcall  Synchronize(System::Classes::_di_TThreadProcedure AThreadProc){ System::Classes::TThread::Synchronize(AThreadProc); }
	
public:
	inline void __fastcall  Synchronize(System::Classes::TThread* const AThread, System::Classes::TThreadMethod AMethod){ System::Classes::TThread::Synchronize(AThread, AMethod); }
	inline void __fastcall  Synchronize(System::Classes::TThread* const AThread, System::Classes::_di_TThreadProcedure AThreadProc){ System::Classes::TThread::Synchronize(AThread, AThreadProc); }
	
};


class DELPHICLASS TIdThreadWithTask;
class PASCALIMPLEMENTATION TIdThreadWithTask : public TIdThread
{
	typedef TIdThread inherited;
	
protected:
	Idtask::TIdTask* FTask;
	virtual void __fastcall AfterRun(void);
	virtual void __fastcall BeforeRun(void);
	virtual void __fastcall Run(void);
	virtual void __fastcall DoException(System::Sysutils::Exception* AException);
	void __fastcall SetTask(Idtask::TIdTask* AValue);
	
public:
	__fastcall virtual TIdThreadWithTask(Idtask::TIdTask* ATask, const System::UnicodeString AName);
	__fastcall virtual ~TIdThreadWithTask(void);
	__property Idtask::TIdTask* Task = {read=FTask, write=SetTask};
};


typedef System::TMetaClass* TIdThreadClass;

typedef System::TMetaClass* TIdThreadWithTaskClass;

//-- var, const, procedure ---------------------------------------------------
static const System::Word IdWaitAllThreadsTerminatedCount = System::Word(0xea60);
static const System::Byte IdWaitAllThreadsTerminatedStep = System::Byte(0xfa);
extern DELPHI_PACKAGE Idthreadsafe::TIdThreadSafeInteger* GThreadCount _DEPRECATED_ATTRIBUTE0 ;
}	/* namespace Idthread */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDTHREAD)
using namespace Idthread;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdthreadHPP
