// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdComponent.pas' rev: 25.00 (Windows)

#ifndef IdcomponentHPP
#define IdcomponentHPP

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
#include <IdResourceStrings.hpp>	// Pascal unit
#include <IdStack.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idcomponent
{
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TIdStatus : unsigned char { hsResolving, hsConnecting, hsConnected, hsDisconnecting, hsDisconnected, hsStatusText, ftpTransfer, ftpReady, ftpAborted };

typedef System::StaticArray<System::UnicodeString, 9> Idcomponent__1;

typedef void __fastcall (__closure *TIdStatusEvent)(System::TObject* ASender, const TIdStatus AStatus, const System::UnicodeString AStatusText);

enum DECLSPEC_DENUM TWorkMode : unsigned char { wmRead, wmWrite };

struct DECLSPEC_DRECORD TWorkInfo
{
public:
	__int64 Current;
	__int64 Max;
	int Level;
};


typedef void __fastcall (__closure *TWorkBeginEvent)(System::TObject* ASender, TWorkMode AWorkMode, __int64 AWorkCountMax);

typedef void __fastcall (__closure *TWorkEndEvent)(System::TObject* ASender, TWorkMode AWorkMode);

typedef void __fastcall (__closure *TWorkEvent)(System::TObject* ASender, TWorkMode AWorkMode, __int64 AWorkCount);

class DELPHICLASS TIdComponent;
class PASCALIMPLEMENTATION TIdComponent : public Idbasecomponent::TIdBaseComponent
{
	typedef Idbasecomponent::TIdBaseComponent inherited;
	
protected:
	TIdStatusEvent FOnStatus;
	TWorkEvent FOnWork;
	TWorkBeginEvent FOnWorkBegin;
	TWorkEndEvent FOnWorkEnd;
	System::StaticArray<TWorkInfo, 2> FWorkInfos;
	TIdComponent* FWorkTarget;
	void __fastcall DoStatus(TIdStatus AStatus)/* overload */;
	void __fastcall DoStatus(TIdStatus AStatus, System::TVarRec const *AArgs, const int AArgs_Size)/* overload */;
	virtual void __fastcall InitComponent(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	void __fastcall SetWorkTarget(TIdComponent* AValue);
	__property TWorkEvent OnWork = {read=FOnWork, write=FOnWork};
	__property TWorkBeginEvent OnWorkBegin = {read=FOnWorkBegin, write=FOnWorkBegin};
	__property TWorkEndEvent OnWorkEnd = {read=FOnWorkEnd, write=FOnWorkEnd};
	
public:
	virtual void __fastcall BeginWork(TWorkMode AWorkMode, const __int64 ASize = 0LL);
	__fastcall virtual ~TIdComponent(void);
	virtual void __fastcall DoWork(TWorkMode AWorkMode, const __int64 ACount);
	virtual void __fastcall EndWork(TWorkMode AWorkMode);
	__property TIdComponent* WorkTarget = {read=FWorkTarget, write=SetWorkTarget};
	
__published:
	__property TIdStatusEvent OnStatus = {read=FOnStatus, write=FOnStatus};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdComponent(System::Classes::TComponent* AOwner)/* overload */ : Idbasecomponent::TIdBaseComponent(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdComponent(void)/* overload */ : Idbasecomponent::TIdBaseComponent() { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE Idcomponent__1 IdStati;
}	/* namespace Idcomponent */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDCOMPONENT)
using namespace Idcomponent;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdcomponentHPP
