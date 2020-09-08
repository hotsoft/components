// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdLogStream.pas' rev: 25.00 (Windows)

#ifndef IdlogstreamHPP
#define IdlogstreamHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdLogBase.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdIntercept.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idlogstream
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdLogStream;
class PASCALIMPLEMENTATION TIdLogStream : public Idlogbase::TIdLogBase
{
	typedef Idlogbase::TIdLogBase inherited;
	
protected:
	bool FFreeStreams;
	System::Classes::TStream* FReceiveStream;
	System::Classes::TStream* FSendStream;
	virtual void __fastcall InitComponent(void);
	virtual void __fastcall LogStatus(const System::UnicodeString AText);
	virtual void __fastcall LogReceivedData(const System::UnicodeString AText, const System::UnicodeString AData);
	virtual void __fastcall LogSentData(const System::UnicodeString AText, const System::UnicodeString AData);
	
public:
	virtual void __fastcall Disconnect(void);
	__property bool FreeStreams = {read=FFreeStreams, write=FFreeStreams, nodefault};
	__property System::Classes::TStream* ReceiveStream = {read=FReceiveStream, write=FReceiveStream};
	__property System::Classes::TStream* SendStream = {read=FSendStream, write=FSendStream};
public:
	/* TIdLogBase.Destroy */ inline __fastcall virtual ~TIdLogStream(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdLogStream(System::Classes::TComponent* AOwner)/* overload */ : Idlogbase::TIdLogBase(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdLogStream(void)/* overload */ : Idlogbase::TIdLogBase() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idlogstream */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDLOGSTREAM)
using namespace Idlogstream;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdlogstreamHPP
