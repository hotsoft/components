// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdIPAddrMon.pas' rev: 25.00 (Windows)

#ifndef IdipaddrmonHPP
#define IdipaddrmonHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdThread.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idipaddrmon
{
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TIdIPAddrMonEvent)(System::TObject* ASender, int AAdapter, System::UnicodeString AOldIP, System::UnicodeString ANewIP);

class DELPHICLASS TIdIPAddrMonThread;
class PASCALIMPLEMENTATION TIdIPAddrMonThread : public Idthread::TIdThread
{
	typedef Idthread::TIdThread inherited;
	
protected:
	unsigned FInterval;
	System::Classes::TNotifyEvent FOnTimerEvent;
	virtual void __fastcall Run(void);
	void __fastcall DoTimerEvent(void);
public:
	/* TIdThread.Create */ inline __fastcall virtual TIdIPAddrMonThread(bool ACreateSuspended, bool ALoop, const System::UnicodeString AName) : Idthread::TIdThread(ACreateSuspended, ALoop, AName) { }
	/* TIdThread.Destroy */ inline __fastcall virtual ~TIdIPAddrMonThread(void) { }
	
};


class DELPHICLASS TIdIPAddrMon;
class PASCALIMPLEMENTATION TIdIPAddrMon : public Idcomponent::TIdComponent
{
	typedef Idcomponent::TIdComponent inherited;
	
private:
	bool FActive;
	bool FBusy;
	unsigned FInterval;
	int FAdapterCount;
	TIdIPAddrMonThread* FThread;
	System::Classes::TStrings* FIPAddresses;
	System::Classes::TStrings* FPreviousIPAddresses;
	TIdIPAddrMonEvent FOnStatusChanged;
	void __fastcall SetActive(bool Value);
	void __fastcall SetInterval(unsigned Value);
	void __fastcall GetAdapterAddresses(void);
	void __fastcall DoStatusChanged(void);
	
protected:
	virtual void __fastcall InitComponent(void);
	virtual void __fastcall Loaded(void);
	
public:
	__fastcall virtual ~TIdIPAddrMon(void);
	void __fastcall CheckAdapters(System::TObject* Sender);
	void __fastcall ForceCheck(void);
	__property int AdapterCount = {read=FAdapterCount, nodefault};
	__property bool Busy = {read=FBusy, nodefault};
	__property System::Classes::TStrings* IPAddresses = {read=FIPAddresses};
	__property TIdIPAddrMonThread* Thread = {read=FThread};
	
__published:
	__property bool Active = {read=FActive, write=SetActive, nodefault};
	__property unsigned Interval = {read=FInterval, write=SetInterval, default=500};
	__property TIdIPAddrMonEvent OnStatusChanged = {read=FOnStatusChanged, write=FOnStatusChanged};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdIPAddrMon(System::Classes::TComponent* AOwner)/* overload */ : Idcomponent::TIdComponent(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdIPAddrMon(void)/* overload */ : Idcomponent::TIdComponent() { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Word IdIPAddrMonInterval = System::Word(0x1f4);
}	/* namespace Idipaddrmon */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDIPADDRMON)
using namespace Idipaddrmon;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdipaddrmonHPP
