// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdTCPStream.pas' rev: 25.00 (Windows)

#ifndef IdtcpstreamHPP
#define IdtcpstreamHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdTCPConnection.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idtcpstream
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdTCPStream;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdTCPStream : public Idglobal::TIdBaseStream
{
	typedef Idglobal::TIdBaseStream inherited;
	
protected:
	Idtcpconnection::TIdTCPConnection* FConnection;
	int FWriteThreshold;
	bool FWriteBuffering;
	virtual int __fastcall IdRead(Idglobal::TIdBytes &VBuffer, int AOffset, int ACount);
	virtual int __fastcall IdWrite(const Idglobal::TIdBytes ABuffer, int AOffset, int ACount);
	virtual __int64 __fastcall IdSeek(const __int64 AOffset, System::Classes::TSeekOrigin AOrigin);
	virtual void __fastcall IdSetSize(__int64 ASize);
	
public:
	__fastcall TIdTCPStream(Idtcpconnection::TIdTCPConnection* AConnection, const int AWriteThreshold);
	__fastcall virtual ~TIdTCPStream(void);
	__property Idtcpconnection::TIdTCPConnection* Connection = {read=FConnection};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idtcpstream */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDTCPSTREAM)
using namespace Idtcpstream;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdtcpstreamHPP
