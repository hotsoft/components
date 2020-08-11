// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdIPMCastClient.pas' rev: 25.00 (Windows)

#ifndef IdipmcastclientHPP
#define IdipmcastclientHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdIPMCastBase.hpp>	// Pascal unit
#include <IdUDPBase.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdSocketHandle.hpp>	// Pascal unit
#include <IdThread.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idipmcastclient
{
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TIPMCastReadEvent)(System::TObject* Sender, const Idglobal::TIdBytes AData, Idsockethandle::TIdSocketHandle* ABinding);

class DELPHICLASS TIdIPMCastListenerThread;
class DELPHICLASS TIdIPMCastClient;
class PASCALIMPLEMENTATION TIdIPMCastListenerThread : public Idthread::TIdThread
{
	typedef Idthread::TIdThread inherited;
	
protected:
	Idsockethandle::TIdSocketHandle* IncomingData;
	int FAcceptWait;
	Idglobal::TIdBytes FBuffer;
	int FBufferSize;
	virtual void __fastcall Run(void);
	
public:
	TIdIPMCastClient* FServer;
	__fastcall TIdIPMCastListenerThread(TIdIPMCastClient* AOwner);
	__fastcall virtual ~TIdIPMCastListenerThread(void);
	void __fastcall IPMCastRead(void);
	__property int AcceptWait = {read=FAcceptWait, write=FAcceptWait, nodefault};
};


class PASCALIMPLEMENTATION TIdIPMCastClient : public Idipmcastbase::TIdIPMCastBase
{
	typedef Idipmcastbase::TIdIPMCastBase inherited;
	
protected:
	Idsockethandle::TIdSocketHandles* FBindings;
	int FBufferSize;
	Idsockethandle::TIdSocketHandle* FCurrentBinding;
	TIdIPMCastListenerThread* FListenerThread;
	Idsockethandle::TIdSocketHandleEvent FOnBeforeBind;
	System::Classes::TNotifyEvent FOnAfterBind;
	TIPMCastReadEvent FOnIPMCastRead;
	bool FThreadedEvent;
	virtual void __fastcall CloseBinding(void);
	virtual void __fastcall DoBeforeBind(Idsockethandle::TIdSocketHandle* AHandle);
	virtual void __fastcall DoAfterBind(void);
	virtual void __fastcall DoIPMCastRead(const Idglobal::TIdBytes AData, Idsockethandle::TIdSocketHandle* ABinding);
	virtual bool __fastcall GetActive(void);
	virtual Idsockethandle::TIdSocketHandle* __fastcall GetBinding(void);
	int __fastcall GetDefaultPort(void);
	void __fastcall PacketReceived(const Idglobal::TIdBytes AData, Idsockethandle::TIdSocketHandle* ABinding);
	void __fastcall SetBindings(Idsockethandle::TIdSocketHandles* const Value);
	void __fastcall SetDefaultPort(const int AValue);
	virtual void __fastcall InitComponent(void);
	
public:
	__fastcall virtual ~TIdIPMCastClient(void);
	
__published:
	__property IPVersion = {default=0};
	__property Active = {default=0};
	__property Idsockethandle::TIdSocketHandles* Bindings = {read=FBindings, write=SetBindings};
	__property int BufferSize = {read=FBufferSize, write=FBufferSize, default=8192};
	__property int DefaultPort = {read=GetDefaultPort, write=SetDefaultPort, nodefault};
	__property MulticastGroup = {default=0};
	__property ReuseSocket = {default=0};
	__property bool ThreadedEvent = {read=FThreadedEvent, write=FThreadedEvent, default=0};
	__property Idsockethandle::TIdSocketHandleEvent OnBeforeBind = {read=FOnBeforeBind, write=FOnBeforeBind};
	__property System::Classes::TNotifyEvent OnAfterBind = {read=FOnAfterBind, write=FOnAfterBind};
	__property TIPMCastReadEvent OnIPMCastRead = {read=FOnIPMCastRead, write=FOnIPMCastRead};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdIPMCastClient(System::Classes::TComponent* AOwner)/* overload */ : Idipmcastbase::TIdIPMCastBase(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdIPMCastClient(void)/* overload */ : Idipmcastbase::TIdIPMCastBase() { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const bool DEF_IMP_THREADEDEVENT = false;
}	/* namespace Idipmcastclient */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDIPMCASTCLIENT)
using namespace Idipmcastclient;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdipmcastclientHPP
