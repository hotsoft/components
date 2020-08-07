// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdIOHandlerStream.pas' rev: 25.00 (Windows)

#ifndef IdiohandlerstreamHPP
#define IdiohandlerstreamHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdIOHandler.hpp>	// Pascal unit
#include <IdStream.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idiohandlerstream
{
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TIdIOHandlerStreamType : unsigned char { stRead, stWrite, stReadWrite };

class DELPHICLASS TIdIOHandlerStream;
typedef void __fastcall (__closure *TIdOnGetStreams)(TIdIOHandlerStream* ASender, System::Classes::TStream* &VReceiveStream, System::Classes::TStream* &VSendStream);

class PASCALIMPLEMENTATION TIdIOHandlerStream : public Idiohandler::TIdIOHandler
{
	typedef Idiohandler::TIdIOHandler inherited;
	
protected:
	bool FFreeStreams;
	TIdOnGetStreams FOnGetStreams;
	System::Classes::TStream* FReceiveStream;
	System::Classes::TStream* FSendStream;
	TIdIOHandlerStreamType FStreamType;
	virtual void __fastcall InitComponent(void);
	virtual int __fastcall ReadDataFromSource(Idglobal::TIdBytes &VBuffer);
	virtual int __fastcall WriteDataToTarget(const Idglobal::TIdBytes ABuffer, const int AOffset, const int ALength);
	virtual bool __fastcall SourceIsAvailable(void);
	virtual int __fastcall CheckForError(int ALastResult);
	virtual void __fastcall RaiseError(int AError);
	
public:
	bool __fastcall StreamingAvailable(void);
	virtual void __fastcall CheckForDisconnect(bool ARaiseExceptionIfDisconnected = true, bool AIgnoreBuffer = false);
	__fastcall virtual TIdIOHandlerStream(System::Classes::TComponent* AOwner, System::Classes::TStream* AReceiveStream, System::Classes::TStream* ASendStream)/* overload */;
	__fastcall TIdIOHandlerStream(System::Classes::TComponent* AOwner)/* overload */;
	virtual bool __fastcall Connected(void);
	virtual void __fastcall Close(void);
	virtual void __fastcall Open(void);
	virtual bool __fastcall Readable(int AMSec = 0xffffffff);
	__property System::Classes::TStream* ReceiveStream = {read=FReceiveStream};
	__property System::Classes::TStream* SendStream = {read=FSendStream};
	__property TIdIOHandlerStreamType StreamType = {read=FStreamType, nodefault};
	
__published:
	__property bool FreeStreams = {read=FFreeStreams, write=FFreeStreams, default=1};
	__property TIdOnGetStreams OnGetStreams = {read=FOnGetStreams, write=FOnGetStreams};
public:
	/* TIdIOHandler.Destroy */ inline __fastcall virtual ~TIdIOHandlerStream(void) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdIOHandlerStream(void)/* overload */ : Idiohandler::TIdIOHandler() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idiohandlerstream */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDIOHANDLERSTREAM)
using namespace Idiohandlerstream;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdiohandlerstreamHPP
