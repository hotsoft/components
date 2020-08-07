// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdTCPConnection.pas' rev: 25.00 (Windows)

#ifndef IdtcpconnectionHPP
#define IdtcpconnectionHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdExceptionCore.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdIntercept.hpp>	// Pascal unit
#include <IdIOHandler.hpp>	// Pascal unit
#include <IdIOHandlerSocket.hpp>	// Pascal unit
#include <IdIOHandlerStack.hpp>	// Pascal unit
#include <IdReply.hpp>	// Pascal unit
#include <IdSocketHandle.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idtcpconnection
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdTCPConnection;
class PASCALIMPLEMENTATION TIdTCPConnection : public Idcomponent::TIdComponent
{
	typedef Idcomponent::TIdComponent inherited;
	
protected:
	Idreply::TIdReply* FGreeting;
	Idintercept::TIdConnectionIntercept* FIntercept;
	Idiohandler::TIdIOHandler* FIOHandler;
	Idreply::TIdReply* FLastCmdResult;
	bool FManagedIOHandler;
	System::Classes::TNotifyEvent FOnDisconnected;
	Idiohandlersocket::TIdIOHandlerSocket* FSocket;
	Idreply::TIdReplyClass FReplyClass;
	void __fastcall CheckConnected(void);
	virtual void __fastcall DoOnDisconnected(void);
	virtual void __fastcall InitComponent(void);
	virtual Idintercept::TIdConnectionIntercept* __fastcall GetIntercept(void);
	virtual Idreply::TIdReplyClass __fastcall GetReplyClass(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall SetIntercept(Idintercept::TIdConnectionIntercept* AValue);
	virtual void __fastcall SetIOHandler(Idiohandler::TIdIOHandler* AValue);
	void __fastcall SetGreeting(Idreply::TIdReply* AValue);
	void __fastcall WorkBeginEvent(System::TObject* ASender, Idcomponent::TWorkMode AWorkMode, __int64 AWorkCountMax);
	void __fastcall WorkEndEvent(System::TObject* ASender, Idcomponent::TWorkMode AWorkMode);
	void __fastcall WorkEvent(System::TObject* ASender, Idcomponent::TWorkMode AWorkMode, __int64 AWorkCount);
	virtual void __fastcall PrepareCmd(System::UnicodeString &aCmd);
	
public:
	void __fastcall CreateIOHandler(Idiohandler::TIdIOHandlerClass ABaseType = 0x0);
	virtual void __fastcall CheckForGracefulDisconnect(bool ARaiseExceptionIfDisconnected = true);
	virtual short __fastcall CheckResponse(const short AResponse, short const *AAllowedResponses, const int AAllowedResponses_Size)/* overload */;
	virtual System::UnicodeString __fastcall CheckResponse(const System::UnicodeString AResponse, const System::UnicodeString AAllowedResponse)/* overload */;
	virtual bool __fastcall Connected(void);
	__fastcall virtual ~TIdTCPConnection(void);
	void __fastcall Disconnect(void)/* overload */;
	virtual void __fastcall Disconnect(bool ANotifyPeer)/* overload */;
	virtual void __fastcall DisconnectNotifyPeer(void);
	virtual void __fastcall GetInternalResponse(Idglobal::_di_IIdTextEncoding AEncoding = Idglobal::_di_IIdTextEncoding());
	short __fastcall GetResponse(const short AAllowedResponse = (short)(0xffffffff), Idglobal::_di_IIdTextEncoding AEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	virtual short __fastcall GetResponse(short const *AAllowedResponses, const int AAllowedResponses_Size, Idglobal::_di_IIdTextEncoding AEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	virtual System::UnicodeString __fastcall GetResponse(const System::UnicodeString AAllowedResponse, Idglobal::_di_IIdTextEncoding AEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	__property Idreply::TIdReply* Greeting = {read=FGreeting, write=SetGreeting};
	virtual void __fastcall RaiseExceptionForLastCmdResult(void)/* overload */;
	virtual void __fastcall RaiseExceptionForLastCmdResult(Idexception::TClassIdException AException)/* overload */;
	short __fastcall SendCmd(System::UnicodeString AOut, const short AResponse = (short)(0xffffffff), Idglobal::_di_IIdTextEncoding AEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	virtual short __fastcall SendCmd(System::UnicodeString AOut, short const *AResponse, const int AResponse_Size, Idglobal::_di_IIdTextEncoding AEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	System::UnicodeString __fastcall SendCmd(System::UnicodeString AOut, const System::UnicodeString AResponse, Idglobal::_di_IIdTextEncoding AEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	void __fastcall WriteHeader(System::Classes::TStrings* AHeader);
	void __fastcall WriteRFCStrings(System::Classes::TStrings* AStrings);
	__property Idreply::TIdReply* LastCmdResult = {read=FLastCmdResult};
	__property bool ManagedIOHandler = {read=FManagedIOHandler, write=FManagedIOHandler, nodefault};
	__property Idiohandlersocket::TIdIOHandlerSocket* Socket = {read=FSocket};
	
__published:
	__property Idintercept::TIdConnectionIntercept* Intercept = {read=GetIntercept, write=SetIntercept};
	__property Idiohandler::TIdIOHandler* IOHandler = {read=FIOHandler, write=SetIOHandler};
	__property System::Classes::TNotifyEvent OnDisconnected = {read=FOnDisconnected, write=FOnDisconnected};
	__property OnWork;
	__property OnWorkBegin;
	__property OnWorkEnd;
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdTCPConnection(System::Classes::TComponent* AOwner)/* overload */ : Idcomponent::TIdComponent(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdTCPConnection(void)/* overload */ : Idcomponent::TIdComponent() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idtcpconnection */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDTCPCONNECTION)
using namespace Idtcpconnection;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdtcpconnectionHPP
