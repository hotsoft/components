// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdMappedFTP.pas' rev: 25.00 (Windows)

#ifndef IdmappedftpHPP
#define IdmappedftpHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdContext.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdMappedPortTCP.hpp>	// Pascal unit
#include <IdStack.hpp>	// Pascal unit
#include <IdYarn.hpp>	// Pascal unit
#include <IdTCPConnection.hpp>	// Pascal unit
#include <IdTCPServer.hpp>	// Pascal unit
#include <IdThread.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdTask.hpp>	// Pascal unit
#include <IdThreadSafe.hpp>	// Pascal unit
#include <IdCustomTCPServer.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idmappedftp
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdMappedFtpContext;
class DELPHICLASS TIdMappedFtpDataThread;
class PASCALIMPLEMENTATION TIdMappedFtpContext : public Idmappedporttcp::TIdMappedPortContext
{
	typedef Idmappedporttcp::TIdMappedPortContext inherited;
	
protected:
	System::UnicodeString FFtpCommand;
	System::UnicodeString FFtpParams;
	System::UnicodeString FHost;
	System::UnicodeString FoutboundHost;
	System::Word FPort;
	System::Word FoutboundPort;
	TIdMappedFtpDataThread* FDataChannelThread;
	virtual void __fastcall HandleLocalClientData(void);
	System::UnicodeString __fastcall GetFtpCmdLine(void);
	void __fastcall CreateDataChannelThread(void);
	virtual bool __fastcall ProcessFtpCommand(void);
	virtual void __fastcall ProcessOutboundDc(const bool APASV);
	virtual void __fastcall ProcessDataCommand(void);
	
public:
	__fastcall virtual TIdMappedFtpContext(Idtcpconnection::TIdTCPConnection* AConnection, Idyarn::TIdYarn* AYarn, Idthreadsafe::TIdThreadSafeObjectList* AList);
	__property System::UnicodeString FtpCommand = {read=FFtpCommand, write=FFtpCommand};
	__property System::UnicodeString FtpParams = {read=FFtpParams, write=FFtpParams};
	__property System::UnicodeString FtpCmdLine = {read=GetFtpCmdLine};
	__property System::UnicodeString Host = {read=FHost, write=FHost};
	__property System::UnicodeString OutboundHost = {read=FoutboundHost, write=FoutboundHost};
	__property System::Word Port = {read=FPort, write=FPort, nodefault};
	__property System::Word OutboundPort = {read=FoutboundPort, write=FoutboundPort, nodefault};
	__property TIdMappedFtpDataThread* DataChannelThread = {read=FDataChannelThread};
public:
	/* TIdMappedPortContext.Destroy */ inline __fastcall virtual ~TIdMappedFtpContext(void) { }
	
};


class PASCALIMPLEMENTATION TIdMappedFtpDataThread : public Idthread::TIdThread
{
	typedef Idthread::TIdThread inherited;
	
protected:
	TIdMappedFtpContext* FMappedFtpThread;
	Idtcpconnection::TIdTCPConnection* FConnection;
	Idtcpconnection::TIdTCPConnection* FOutboundClient;
	Idstack::TIdSocketList* FReadList;
	Idglobal::TIdBytes FNetData;
	virtual void __fastcall BeforeRun(void);
	virtual void __fastcall Run(void);
	
public:
	__fastcall TIdMappedFtpDataThread(TIdMappedFtpContext* AMappedFtpThread);
	__fastcall virtual ~TIdMappedFtpDataThread(void);
	__property TIdMappedFtpContext* MappedFtpThread = {read=FMappedFtpThread};
	__property Idtcpconnection::TIdTCPConnection* Connection = {read=FConnection};
	__property Idtcpconnection::TIdTCPConnection* OutboundClient = {read=FOutboundClient};
	__property Idglobal::TIdBytes NetData = {read=FNetData, write=FNetData};
};


enum DECLSPEC_DENUM TIdMappedFtpOutboundDcMode : unsigned char { fdcmClient, fdcmPort, fdcmPasv };

class DELPHICLASS TIdMappedFTP;
class PASCALIMPLEMENTATION TIdMappedFTP : public Idmappedporttcp::TIdMappedPortTCP
{
	typedef Idmappedporttcp::TIdMappedPortTCP inherited;
	
protected:
	TIdMappedFtpOutboundDcMode FOutboundDcMode;
	virtual void __fastcall InitComponent(void);
	
__published:
	__property DefaultPort = {default=21};
	__property MappedPort = {default=21};
	__property TIdMappedFtpOutboundDcMode OutboundDcMode = {read=FOutboundDcMode, write=FOutboundDcMode, default=0};
public:
	/* TIdCustomTCPServer.Destroy */ inline __fastcall virtual ~TIdMappedFTP(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdMappedFTP(System::Classes::TComponent* AOwner)/* overload */ : Idmappedporttcp::TIdMappedPortTCP(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdMappedFTP(void)/* overload */ : Idmappedporttcp::TIdMappedPortTCP() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idmappedftp */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDMAPPEDFTP)
using namespace Idmappedftp;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdmappedftpHPP
