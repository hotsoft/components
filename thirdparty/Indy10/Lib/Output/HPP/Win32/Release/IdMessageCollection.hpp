// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdMessageCollection.pas' rev: 25.00 (Windows)

#ifndef IdmessagecollectionHPP
#define IdmessagecollectionHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdMessage.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idmessagecollection
{
//-- type declarations -------------------------------------------------------
typedef System::TMetaClass* TIdMessageItems;

class DELPHICLASS TIdMessageItem;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdMessageItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
protected:
	int FAttempt;
	Idmessage::TIdMessage* FMsg;
	bool FQueued;
	
public:
	__fastcall virtual TIdMessageItem(System::Classes::TCollection* Collection);
	__fastcall virtual ~TIdMessageItem(void);
	__property int Attempt = {read=FAttempt, write=FAttempt, nodefault};
	__property Idmessage::TIdMessage* Msg = {read=FMsg};
	__property bool Queued = {read=FQueued, write=FQueued, nodefault};
};

#pragma pack(pop)

class DELPHICLASS TIdMessageCollection;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdMessageCollection : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	Idmessage::TIdMessage* operator[](int index) { return Messages[index]; }
	
private:
	Idmessage::TIdMessage* __fastcall GetIdMessage(int index);
	void __fastcall SetIdMessage(int index, Idmessage::TIdMessage* const Value);
	
public:
	__fastcall TIdMessageCollection(void);
	HIDESBASE TIdMessageItem* __fastcall Add(void);
	__property Idmessage::TIdMessage* Messages[int index] = {read=GetIdMessage, write=SetIdMessage/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TIdMessageCollection(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idmessagecollection */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDMESSAGECOLLECTION)
using namespace Idmessagecollection;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdmessagecollectionHPP
