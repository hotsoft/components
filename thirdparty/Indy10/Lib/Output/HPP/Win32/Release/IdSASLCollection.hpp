// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdSASLCollection.pas' rev: 25.00 (Windows)

#ifndef IdsaslcollectionHPP
#define IdsaslcollectionHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <IdCoder.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdSASL.hpp>	// Pascal unit
#include <IdTCPConnection.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idsaslcollection
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdSASLListEntry;
class DELPHICLASS TIdSASLEntries;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdSASLListEntry : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
protected:
	Idsasl::TIdSASL* FSASL;
	virtual System::UnicodeString __fastcall GetDisplayName(void);
	System::Classes::TComponent* __fastcall GetOwnerComponent(void);
	TIdSASLEntries* __fastcall GetSASLEntries(void);
	void __fastcall SetSASL(Idsasl::TIdSASL* AValue);
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__property System::Classes::TComponent* OwnerComponent = {read=GetOwnerComponent};
	__property TIdSASLEntries* SASLEntries = {read=GetSASLEntries};
	
__published:
	__property Idsasl::TIdSASL* SASL = {read=FSASL, write=SetSASL};
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TIdSASLListEntry(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdSASLListEntry(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdSASLEntries : public System::Classes::TOwnedCollection
{
	typedef System::Classes::TOwnedCollection inherited;
	
public:
	TIdSASLListEntry* operator[](int Index) { return Items[Index]; }
	
protected:
	void __fastcall CheckIfEmpty(void);
	HIDESBASE TIdSASLListEntry* __fastcall GetItem(int Index);
	System::Classes::TComponent* __fastcall GetOwnerComponent(void);
	HIDESBASE void __fastcall SetItem(int Index, TIdSASLListEntry* const Value);
	
public:
	__fastcall TIdSASLEntries(System::Classes::TPersistent* AOwner);
	HIDESBASE TIdSASLListEntry* __fastcall Add(void);
	void __fastcall LoginSASL(const System::UnicodeString ACmd, const System::UnicodeString AHost, const System::UnicodeString AProtocolName, System::UnicodeString const *AOkReplies, const int AOkReplies_Size, System::UnicodeString const *AContinueReplies, const int AContinueReplies_Size, Idtcpconnection::TIdTCPConnection* AClient, System::Classes::TStrings* ACapaReply, const System::UnicodeString AAuthString = L"AUTH", bool ACanAttemptIR = true)/* overload */;
	void __fastcall LoginSASL(const System::UnicodeString ACmd, const System::UnicodeString AHost, const System::UnicodeString AProtocolName, const System::UnicodeString AServiceName, System::UnicodeString const *AOkReplies, const int AOkReplies_Size, System::UnicodeString const *AContinueReplies, const int AContinueReplies_Size, Idtcpconnection::TIdTCPConnection* AClient, System::Classes::TStrings* ACapaReply, const System::UnicodeString AAuthString = L"AUTH", bool ACanAttemptIR = true)/* overload */;
	System::Classes::TStrings* __fastcall ParseCapaReply _DEPRECATED_ATTRIBUTE1("Use ParseCapaReplyToList()") (System::Classes::TStrings* ACapaReply, const System::UnicodeString AAuthString = L"AUTH");
	void __fastcall ParseCapaReplyToList(System::Classes::TStrings* ACapaReply, System::Classes::TStrings* ADestList, const System::UnicodeString AAuthString = L"AUTH");
	Idsasl::TIdSASL* __fastcall FindSASL(const System::UnicodeString AServiceName);
	HIDESBASE TIdSASLListEntry* __fastcall Insert(int Index);
	void __fastcall RemoveByComp(System::Classes::TComponent* AComponent);
	int __fastcall IndexOfComp(Idsasl::TIdSASL* AItem);
	__property TIdSASLListEntry* Items[int Index] = {read=GetItem, write=SetItem/*, default*/};
	__property System::Classes::TComponent* OwnerComponent = {read=GetOwnerComponent};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TIdSASLEntries(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSASLException;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSASLException : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSASLException(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSASLException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSASLException(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSASLException(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSASLException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSASLException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSASLException(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSASLException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSASLException(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSASLException(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSASLException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSASLException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSASLException(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSASLNotSupported;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSASLNotSupported : public EIdSASLException
{
	typedef EIdSASLException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSASLNotSupported(const System::UnicodeString AMsg)/* overload */ : EIdSASLException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSASLNotSupported(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSASLException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSASLNotSupported(NativeUInt Ident)/* overload */ : EIdSASLException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSASLNotSupported(System::PResStringRec ResStringRec)/* overload */ : EIdSASLException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSASLNotSupported(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSASLException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSASLNotSupported(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSASLException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSASLNotSupported(const System::UnicodeString Msg, int AHelpContext) : EIdSASLException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSASLNotSupported(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSASLException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSASLNotSupported(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSASLException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSASLNotSupported(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSASLException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSASLNotSupported(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSASLException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSASLNotSupported(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSASLException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSASLNotSupported(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSASLNotReady;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSASLNotReady : public EIdSASLException
{
	typedef EIdSASLException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSASLNotReady(const System::UnicodeString AMsg)/* overload */ : EIdSASLException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSASLNotReady(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSASLException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSASLNotReady(NativeUInt Ident)/* overload */ : EIdSASLException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSASLNotReady(System::PResStringRec ResStringRec)/* overload */ : EIdSASLException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSASLNotReady(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSASLException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSASLNotReady(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSASLException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSASLNotReady(const System::UnicodeString Msg, int AHelpContext) : EIdSASLException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSASLNotReady(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSASLException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSASLNotReady(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSASLException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSASLNotReady(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSASLException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSASLNotReady(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSASLException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSASLNotReady(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSASLException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSASLNotReady(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSASLMechNeeded;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSASLMechNeeded : public EIdSASLException
{
	typedef EIdSASLException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSASLMechNeeded(const System::UnicodeString AMsg)/* overload */ : EIdSASLException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSASLMechNeeded(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSASLException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSASLMechNeeded(NativeUInt Ident)/* overload */ : EIdSASLException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSASLMechNeeded(System::PResStringRec ResStringRec)/* overload */ : EIdSASLException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSASLMechNeeded(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSASLException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSASLMechNeeded(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSASLException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSASLMechNeeded(const System::UnicodeString Msg, int AHelpContext) : EIdSASLException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSASLMechNeeded(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSASLException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSASLMechNeeded(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSASLException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSASLMechNeeded(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSASLException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSASLMechNeeded(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSASLException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSASLMechNeeded(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSASLException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSASLMechNeeded(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idsaslcollection */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDSASLCOLLECTION)
using namespace Idsaslcollection;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdsaslcollectionHPP
