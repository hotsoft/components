// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdSysLogMessage.pas' rev: 25.00 (Windows)

#ifndef IdsyslogmessageHPP
#define IdsyslogmessageHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdGlobalProtocols.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idsyslogmessage
{
//-- type declarations -------------------------------------------------------
typedef System::Byte TIdSyslogPRI;

enum DECLSPEC_DENUM TIdSyslogFacility : unsigned char { sfKernel, sfUserLevel, sfMailSystem, sfSystemDaemon, sfSecurityOne, sfSysLogInternal, sfLPR, sfNNTP, sfUUCP, sfClockDaemonOne, sfSecurityTwo, sfFTPDaemon, sfNTP, sfLogAudit, sfLogAlert, sfClockDaemonTwo, sfLocalUseZero, sfLocalUseOne, sfLocalUseTwo, sfLocalUseThree, sfLocalUseFour, sfLocalUseFive, sfLocalUseSix, sfLocalUseSeven };

enum DECLSPEC_DENUM TIdSyslogSeverity : unsigned char { slEmergency, slAlert, slCritical, slError, slWarning, slNotice, slInformational, slDebug };

class DELPHICLASS TIdSysLogMsgPart;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdSysLogMsgPart : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	bool FPIDAvailable;
	System::UnicodeString FProcess;
	int FPID;
	System::UnicodeString FContent;
	void __fastcall SetPID(int AValue);
	void __fastcall SetProcess(const System::UnicodeString AValue);
	System::UnicodeString __fastcall GetText(void);
	void __fastcall SetText(const System::UnicodeString AValue);
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	
__published:
	__property System::UnicodeString Text = {read=GetText, write=SetText};
	__property bool PIDAvailable = {read=FPIDAvailable, write=FPIDAvailable, stored=false, nodefault};
	__property System::UnicodeString Process = {read=FProcess, write=SetProcess, stored=false};
	__property int PID = {read=FPID, write=SetPID, stored=false, nodefault};
	__property System::UnicodeString Content = {read=FContent, write=FContent, stored=false};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TIdSysLogMsgPart(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TIdSysLogMsgPart(void) : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdSysLogMessage;
class PASCALIMPLEMENTATION TIdSysLogMessage : public Idbasecomponent::TIdBaseComponent
{
	typedef Idbasecomponent::TIdBaseComponent inherited;
	
protected:
	TIdSysLogMsgPart* FMsg;
	TIdSyslogFacility FFacility;
	TIdSyslogSeverity FSeverity;
	System::UnicodeString FHostname;
	System::UnicodeString FMessage;
	System::TDateTime FTimeStamp;
	System::UnicodeString FRawMessage;
	System::UnicodeString FPeer;
	TIdSyslogPRI FPri;
	Idbasecomponent::TIdBaseComponent* FUDPCliComp;
	void __fastcall SetFacility(const TIdSyslogFacility AValue);
	void __fastcall SetSeverity(const TIdSyslogSeverity AValue);
	void __fastcall SetHostname(const System::UnicodeString AValue);
	void __fastcall SetRawMessage(const System::UnicodeString Value);
	void __fastcall SetTimeStamp(const System::TDateTime AValue);
	void __fastcall SetMsg(TIdSysLogMsgPart* const AValue);
	void __fastcall SetPri(const TIdSyslogPRI Value);
	System::UnicodeString __fastcall GetHeader(void);
	virtual void __fastcall CheckASCIIRange(System::UnicodeString &Data);
	virtual void __fastcall ReadPRI(int &StartPos);
	virtual void __fastcall ReadHeader(int &StartPos);
	virtual void __fastcall ReadMSG(int &StartPos);
	virtual void __fastcall Parse(void);
	virtual void __fastcall UpdatePRI(void);
	virtual System::TDateTime __fastcall DecodeTimeStamp(System::UnicodeString TimeStampString);
	virtual void __fastcall InitComponent(void);
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__fastcall virtual ~TIdSysLogMessage(void);
	virtual System::UnicodeString __fastcall EncodeMessage(void);
	virtual void __fastcall ReadFromBytes(const Idglobal::TIdBytes ASrc, const System::UnicodeString APeer);
	__property System::UnicodeString RawMessage = {read=FRawMessage, write=SetRawMessage};
	void __fastcall SendToHost(const System::UnicodeString Dest);
	__property System::UnicodeString Peer = {read=FPeer, write=FPeer};
	__property System::TDateTime TimeStamp = {read=FTimeStamp, write=SetTimeStamp};
	
__published:
	__property TIdSyslogPRI Pri = {read=FPri, write=SetPri, default=13};
	__property TIdSyslogFacility Facility = {read=FFacility, write=SetFacility, stored=false, nodefault};
	__property TIdSyslogSeverity Severity = {read=FSeverity, write=SetSeverity, stored=false, nodefault};
	__property System::UnicodeString Hostname = {read=FHostname, write=SetHostname, stored=false};
	__property TIdSysLogMsgPart* Msg = {read=FMsg, write=SetMsg};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdSysLogMessage(System::Classes::TComponent* AOwner)/* overload */ : Idbasecomponent::TIdBaseComponent(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdSysLogMessage(void)/* overload */ : Idbasecomponent::TIdBaseComponent() { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::Word __fastcall logFacilityToNo(TIdSyslogFacility AFac);
extern DELPHI_PACKAGE TIdSyslogFacility __fastcall NoToFacility(System::Word AFac);
extern DELPHI_PACKAGE System::Word __fastcall logSeverityToNo(TIdSyslogSeverity ASev);
extern DELPHI_PACKAGE TIdSyslogSeverity __fastcall NoToSeverity(System::Word ASev);
extern DELPHI_PACKAGE System::UnicodeString __fastcall SeverityToString(TIdSyslogSeverity ASec);
extern DELPHI_PACKAGE System::UnicodeString __fastcall FacilityToString(TIdSyslogFacility AFac);
}	/* namespace Idsyslogmessage */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDSYSLOGMESSAGE)
using namespace Idsyslogmessage;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdsyslogmessageHPP
