// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdRawFunctions.pas' rev: 25.00 (Windows)

#ifndef IdrawfunctionsHPP
#define IdrawfunctionsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdRawHeaders.hpp>	// Pascal unit
#include <IdStack.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idrawfunctions
{
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall IdRawBuildArp(const System::Word AHwAddressFormat, const System::Word AProtocolFormat, const System::Byte AHwAddressLen, const System::Byte AProtocolLen, const System::Word AnOpType, Idrawheaders::TIdEtherAddr* ASenderHw, Idrawheaders::TIdInAddr* ASenderPr, Idrawheaders::TIdEtherAddr* ATargetHw, Idrawheaders::TIdInAddr* ATargetPr, const Idglobal::TIdBytes APayload, Idglobal::TIdBytes &VBuffer);
extern DELPHI_PACKAGE void __fastcall IdRawBuildDns(const System::Word AnId, const System::Word AFlags, const System::Word ANumQuestions, const System::Word ANumAnswerRecs, const System::Word ANumAuthRecs, const System::Word ANumAddRecs, const Idglobal::TIdBytes APayload, Idglobal::TIdBytes &VBuffer);
extern DELPHI_PACKAGE void __fastcall IdRawBuildEthernet(Idrawheaders::TIdEtherAddr* ADest, Idrawheaders::TIdEtherAddr* ASource, System::Word AType, const Idglobal::TIdBytes APayload, Idglobal::TIdBytes &VBuffer);
extern DELPHI_PACKAGE void __fastcall IdRawBuildIp(System::Word ALen, System::Byte ATos, System::Word AnId, System::Word AFrag, System::Byte ATtl, System::Byte AProtocol, Idrawheaders::TIdInAddr* ASource, Idrawheaders::TIdInAddr* ADest, const Idglobal::TIdBytes APayload, Idglobal::TIdBytes &VBuffer, const int AIdx = 0x0);
extern DELPHI_PACKAGE void __fastcall IdRawBuildIcmpEcho(System::Byte AType, System::Byte ACode, System::Word AnId, System::Word ASeq, const Idglobal::TIdBytes APayload, Idglobal::TIdBytes &VBuffer);
extern DELPHI_PACKAGE void __fastcall IdRawBuildIcmpMask(System::Byte AType, System::Byte ACode, System::Word AnId, System::Word ASeq, unsigned AMask, const Idglobal::TIdBytes APayload, Idglobal::TIdBytes &VBuffer);
extern DELPHI_PACKAGE void __fastcall IdRawBuildIcmpUnreach(System::Byte AType, System::Byte ACode, System::Word AnOrigLen, System::Byte AnOrigTos, System::Word AnOrigId, System::Word AnOrigFrag, System::Byte AnOrigTtl, System::Byte AnOrigProtocol, Idrawheaders::TIdInAddr* AnOrigSource, Idrawheaders::TIdInAddr* AnOrigDest, const int AnOrigPayload, const int APayloadSize, Idglobal::TIdBytes &VBuffer);
extern DELPHI_PACKAGE void __fastcall IdRawBuildIcmpTimeExceed(const System::Byte AType, const System::Byte ACode, const System::Word AnOrigLen, const System::Byte AnOrigTos, const System::Word AnOrigId, const System::Word AnOrigFrag, const System::Byte AnOrigTtl, const System::Byte AnOrigProtocol, Idrawheaders::TIdInAddr* const AnOrigSource, Idrawheaders::TIdInAddr* const AnOrigDest, const Idglobal::TIdBytes AnOrigPayload, Idglobal::TIdBytes &VBuffer);
extern DELPHI_PACKAGE void __fastcall IdRawBuildIcmpTimestamp(const System::Byte AType, const System::Byte ACode, const System::Word AnId, const System::Word ASeq, const unsigned AnOtime, const unsigned AnRtime, const unsigned ATtime, const Idglobal::TIdBytes APayload, Idglobal::TIdBytes &VBuffer);
extern DELPHI_PACKAGE void __fastcall IdRawBuildIcmpRedirect(const System::Byte AType, const System::Byte ACode, Idrawheaders::TIdInAddr* AGateway, const System::Word AnOrigLen, const System::Byte AnOrigTos, const System::Word AnOrigId, const System::Word AnOrigFrag, const System::Byte AnOrigTtl, const System::Byte AnOrigProtocol, Idrawheaders::TIdInAddr* AnOrigSource, Idrawheaders::TIdInAddr* AnOrigDest, const Idglobal::TIdBytes AnOrigPayload, Idglobal::TIdBytes &VBuffer);
extern DELPHI_PACKAGE void __fastcall IdRawBuildIgmp(System::Byte AType, System::Byte ACode, Idrawheaders::TIdInAddr* AnIp, const System::Word APayload, Idglobal::TIdBytes &VBuffer);
extern DELPHI_PACKAGE void __fastcall IdRawBuildRip(const System::Byte ACommand, const System::Byte AVersion, const System::Word ARoutingDomain, const System::Word AnAddressFamily, const System::Word ARoutingTag, const unsigned AnAddr, const unsigned AMask, const unsigned ANextHop, const unsigned AMetric, const Idglobal::TIdBytes APayload, Idglobal::TIdBytes &VBuffer);
extern DELPHI_PACKAGE void __fastcall IdRawBuildTcp(const System::Word ASourcePort, const System::Word ADestPort, const unsigned ASeq, const unsigned AnAck, const System::Byte AControl, const System::Word AWindowSize, const System::Word AnUrgent, const Idglobal::TIdBytes APayload, Idglobal::TIdBytes &VBuffer);
extern DELPHI_PACKAGE void __fastcall IdRawBuildUdp(const System::Word ASourcePort, const System::Word ADestPort, const Idglobal::TIdBytes APayload, Idglobal::TIdBytes &VBuffer);
}	/* namespace Idrawfunctions */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDRAWFUNCTIONS)
using namespace Idrawfunctions;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdrawfunctionsHPP
