// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdMailBox.pas' rev: 25.00 (Windows)

#ifndef IdmailboxHPP
#define IdmailboxHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <IdMessage.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdMessageCollection.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idmailbox
{
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TIdMailBoxState : unsigned char { msReadWrite, msReadOnly };

enum DECLSPEC_DENUM TIdMailBoxAttributes : unsigned char { maNoinferiors, maNoselect, maMarked, maUnmarked };

typedef System::Set<TIdMailBoxAttributes, TIdMailBoxAttributes::maNoinferiors, TIdMailBoxAttributes::maUnmarked>  TIdMailBoxAttributesSet;

typedef System::DynamicArray<unsigned> TUInt32Array;

class DELPHICLASS TIdMailBox;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdMailBox : public Idbasecomponent::TIdBaseComponent
{
	typedef Idbasecomponent::TIdBaseComponent inherited;
	
protected:
	TIdMailBoxAttributes FAttributes;
	Idmessage::TIdMessageFlagsSet FChangeableFlags;
	unsigned FFirstUnseenMsg;
	Idmessage::TIdMessageFlagsSet FFlags;
	System::UnicodeString FName;
	Idmessagecollection::TIdMessageCollection* FMessageList;
	int FRecentMsgs;
	TIdMailBoxState FState;
	int FTotalMsgs;
	System::UnicodeString FUIDNext;
	System::UnicodeString FUIDValidity;
	int FUnseenMsgs;
	void __fastcall SetMessageList(Idmessagecollection::TIdMessageCollection* const Value);
	virtual void __fastcall InitComponent(void);
	
public:
	TUInt32Array DeletedMsgs;
	TUInt32Array SearchResult;
	__property TIdMailBoxAttributes Attributes = {read=FAttributes, write=FAttributes, nodefault};
	__property Idmessage::TIdMessageFlagsSet ChangeableFlags = {read=FChangeableFlags, write=FChangeableFlags, nodefault};
	__property unsigned FirstUnseenMsg = {read=FFirstUnseenMsg, write=FFirstUnseenMsg, nodefault};
	__property Idmessage::TIdMessageFlagsSet Flags = {read=FFlags, write=FFlags, nodefault};
	__property System::UnicodeString Name = {read=FName, write=FName};
	__property Idmessagecollection::TIdMessageCollection* MessageList = {read=FMessageList, write=SetMessageList};
	__property int RecentMsgs = {read=FRecentMsgs, write=FRecentMsgs, nodefault};
	__property TIdMailBoxState State = {read=FState, write=FState, nodefault};
	__property int TotalMsgs = {read=FTotalMsgs, write=FTotalMsgs, nodefault};
	__property System::UnicodeString UIDNext = {read=FUIDNext, write=FUIDNext};
	__property System::UnicodeString UIDValidity = {read=FUIDValidity, write=FUIDValidity};
	__property int UnseenMsgs = {read=FUnseenMsgs, write=FUnseenMsgs, nodefault};
	virtual void __fastcall Clear(void);
	__fastcall virtual ~TIdMailBox(void);
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdMailBox(System::Classes::TComponent* AOwner)/* overload */ : Idbasecomponent::TIdBaseComponent(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdMailBox(void)/* overload */ : Idbasecomponent::TIdBaseComponent() { }
	
};

#pragma pack(pop)

typedef System::StaticArray<System::UnicodeString, 4> Idmailbox__2;

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE Idmailbox__2 MailBoxAttributes;
}	/* namespace Idmailbox */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDMAILBOX)
using namespace Idmailbox;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdmailboxHPP
