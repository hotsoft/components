// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdSSL.pas' rev: 25.00 (Windows)

#ifndef IdsslHPP
#define IdsslHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdIOHandler.hpp>	// Pascal unit
#include <IdIOHandlerSocket.hpp>	// Pascal unit
#include <IdIOHandlerStack.hpp>	// Pascal unit
#include <IdScheduler.hpp>	// Pascal unit
#include <IdServerIOHandler.hpp>	// Pascal unit
#include <IdYarn.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idssl
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdSSLIOHandlerSocketBase;
class PASCALIMPLEMENTATION TIdSSLIOHandlerSocketBase : public Idiohandlerstack::TIdIOHandlerStack
{
	typedef Idiohandlerstack::TIdIOHandlerStack inherited;
	
protected:
	bool fPassThrough;
	bool fIsPeer;
	System::UnicodeString FURIToCheck;
	virtual void __fastcall InitComponent(void);
	virtual int __fastcall RecvEnc(Idglobal::TIdBytes &ABuffer) = 0 ;
	virtual int __fastcall SendEnc(const Idglobal::TIdBytes ABuffer, const int AOffset, const int ALength) = 0 ;
	virtual int __fastcall ReadDataFromSource(Idglobal::TIdBytes &VBuffer);
	virtual int __fastcall WriteDataToTarget(const Idglobal::TIdBytes ABuffer, const int AOffset, const int ALength);
	virtual void __fastcall SetPassThrough(const bool AValue);
	virtual void __fastcall SetURIToCheck(const System::UnicodeString AValue);
	
public:
	virtual TIdSSLIOHandlerSocketBase* __fastcall Clone(void) = 0 ;
	virtual void __fastcall StartSSL(void) = 0 ;
	__property bool PassThrough = {read=fPassThrough, write=SetPassThrough, nodefault};
	__property bool IsPeer = {read=fIsPeer, write=fIsPeer, nodefault};
	__property System::UnicodeString URIToCheck = {read=FURIToCheck, write=SetURIToCheck};
public:
	/* TIdIOHandlerSocket.Destroy */ inline __fastcall virtual ~TIdSSLIOHandlerSocketBase(void) { }
	
public:
	/* TIdIOHandler.Create */ inline __fastcall TIdSSLIOHandlerSocketBase(System::Classes::TComponent* AOwner)/* overload */ : Idiohandlerstack::TIdIOHandlerStack(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdSSLIOHandlerSocketBase(void)/* overload */ : Idiohandlerstack::TIdIOHandlerStack() { }
	
};


class DELPHICLASS TIdServerIOHandlerSSLBase;
class PASCALIMPLEMENTATION TIdServerIOHandlerSSLBase : public Idserveriohandler::TIdServerIOHandler
{
	typedef Idserveriohandler::TIdServerIOHandler inherited;
	
public:
	virtual Idiohandler::TIdIOHandler* __fastcall MakeClientIOHandler(Idyarn::TIdYarn* ATheThread)/* overload */;
	HIDESBASE virtual TIdSSLIOHandlerSocketBase* __fastcall MakeClientIOHandler(void) = 0 /* overload */;
	virtual TIdSSLIOHandlerSocketBase* __fastcall MakeFTPSvrPort(void) = 0 ;
	virtual TIdSSLIOHandlerSocketBase* __fastcall MakeFTPSvrPasv(void) = 0 ;
public:
	/* TIdComponent.Destroy */ inline __fastcall virtual ~TIdServerIOHandlerSSLBase(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdServerIOHandlerSSLBase(System::Classes::TComponent* AOwner)/* overload */ : Idserveriohandler::TIdServerIOHandler(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdServerIOHandlerSSLBase(void)/* overload */ : Idserveriohandler::TIdServerIOHandler() { }
	
};


typedef System::TMetaClass* TIdClientSSLClass;

typedef System::TMetaClass* TIdServerSSLClass;

class DELPHICLASS TIdSSLRegEntry;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdSSLRegEntry : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
protected:
	System::UnicodeString FProductName;
	System::UnicodeString FVendor;
	System::UnicodeString FCopyright;
	System::UnicodeString FDescription;
	System::UnicodeString FURL;
	TIdClientSSLClass FClientClass;
	TIdServerSSLClass FServerClass;
	
public:
	__property System::UnicodeString ProductName = {read=FProductName, write=FProductName};
	__property System::UnicodeString Vendor = {read=FVendor, write=FVendor};
	__property System::UnicodeString Copyright = {read=FCopyright, write=FCopyright};
	__property System::UnicodeString Description = {read=FDescription, write=FDescription};
	__property System::UnicodeString URL = {read=FURL, write=FURL};
	__property TIdClientSSLClass ClientClass = {read=FClientClass, write=FClientClass};
	__property TIdServerSSLClass ServerClass = {read=FServerClass, write=FServerClass};
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TIdSSLRegEntry(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdSSLRegEntry(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdSSLRegistry;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdSSLRegistry : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TIdSSLRegEntry* operator[](int Index) { return Items[Index]; }
	
protected:
	HIDESBASE TIdSSLRegEntry* __fastcall GetItem(int Index);
	HIDESBASE void __fastcall SetItem(int Index, TIdSSLRegEntry* const Value);
	
public:
	__fastcall TIdSSLRegistry(void);
	HIDESBASE TIdSSLRegEntry* __fastcall Add(void);
	__property TIdSSLRegEntry* Items[int Index] = {read=GetItem, write=SetItem/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TIdSSLRegistry(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TIdSSLRegistry* GSSLRegistry;
extern DELPHI_PACKAGE void __fastcall RegisterSSL(const System::UnicodeString AProduct, const System::UnicodeString AVendor, const System::UnicodeString ACopyright, const System::UnicodeString ADescription, const System::UnicodeString AURL, const TIdClientSSLClass AClientClass, const TIdServerSSLClass AServerClass);
}	/* namespace Idssl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDSSL)
using namespace Idssl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdsslHPP
