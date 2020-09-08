// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdIPWatch.pas' rev: 25.00 (Windows)

#ifndef IdipwatchHPP
#define IdipwatchHPP

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

namespace Idipwatch
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdIPWatchThread;
class PASCALIMPLEMENTATION TIdIPWatchThread : public Idthread::TIdThread
{
	typedef Idthread::TIdThread inherited;
	
protected:
	int FInterval;
	System::Classes::TNotifyEvent FTimerEvent;
	virtual void __fastcall Run(void);
	void __fastcall TimerEvent(void);
public:
	/* TIdThread.Create */ inline __fastcall virtual TIdIPWatchThread(bool ACreateSuspended, bool ALoop, const System::UnicodeString AName) : Idthread::TIdThread(ACreateSuspended, ALoop, AName) { }
	/* TIdThread.Destroy */ inline __fastcall virtual ~TIdIPWatchThread(void) { }
	
};


class DELPHICLASS TIdIPWatch;
class PASCALIMPLEMENTATION TIdIPWatch : public Idcomponent::TIdComponent
{
	typedef Idcomponent::TIdComponent inherited;
	
protected:
	bool FActive;
	System::UnicodeString FCurrentIP;
	bool FHistoryEnabled;
	System::UnicodeString FHistoryFilename;
	System::Classes::TStringList* FIPHistoryList;
	bool FIsOnline;
	bool FLocalIPHuntBusy;
	int FMaxHistoryEntries;
	int FOnLineCount;
	System::Classes::TNotifyEvent FOnStatusChanged;
	System::UnicodeString FPreviousIP;
	TIdIPWatchThread* FThread;
	unsigned FWatchInterval;
	void __fastcall AddToIPHistoryList(System::UnicodeString Value);
	void __fastcall CheckStatus(System::TObject* Sender);
	virtual void __fastcall Loaded(void);
	void __fastcall SetActive(bool Value);
	void __fastcall SetMaxHistoryEntries(int Value);
	void __fastcall SetWatchInterval(unsigned Value);
	virtual void __fastcall InitComponent(void);
	
public:
	__fastcall virtual ~TIdIPWatch(void);
	bool __fastcall ForceCheck(void);
	void __fastcall LoadHistory(void);
	System::UnicodeString __fastcall LocalIP(void);
	void __fastcall SaveHistory(void);
	__property System::UnicodeString CurrentIP = {read=FCurrentIP};
	__property System::Classes::TStringList* IPHistoryList = {read=FIPHistoryList};
	__property bool IsOnline = {read=FIsOnline, nodefault};
	__property System::UnicodeString PreviousIP = {read=FPreviousIP};
	
__published:
	__property bool Active = {read=FActive, write=SetActive, nodefault};
	__property bool HistoryEnabled = {read=FHistoryEnabled, write=FHistoryEnabled, default=1};
	__property System::UnicodeString HistoryFilename = {read=FHistoryFilename, write=FHistoryFilename};
	__property int MaxHistoryEntries = {read=FMaxHistoryEntries, write=SetMaxHistoryEntries, default=25};
	__property System::Classes::TNotifyEvent OnStatusChanged = {read=FOnStatusChanged, write=FOnStatusChanged};
	__property unsigned WatchInterval = {read=FWatchInterval, write=SetWatchInterval, default=1000};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdIPWatch(System::Classes::TComponent* AOwner)/* overload */ : Idcomponent::TIdComponent(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdIPWatch(void)/* overload */ : Idcomponent::TIdComponent() { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 IP_WATCH_HIST_MAX = System::Int8(0x19);
#define IP_WATCH_HIST_FILENAME L"iphist.dat"
static const System::Word IP_WATCH_INTERVAL = System::Word(0x3e8);
}	/* namespace Idipwatch */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDIPWATCH)
using namespace Idipwatch;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdipwatchHPP
