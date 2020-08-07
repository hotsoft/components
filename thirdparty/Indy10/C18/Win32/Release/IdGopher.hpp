// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdGopher.pas' rev: 25.00 (Windows)

#ifndef IdgopherHPP
#define IdgopherHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdEMailAddress.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdHeaderList.hpp>	// Pascal unit
#include <IdTCPClient.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <IdTCPConnection.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idgopher
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdGopherMenuItem;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdGopherMenuItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
protected:
	System::UnicodeString FTitle;
	System::WideChar FItemType;
	System::UnicodeString FSelector;
	System::UnicodeString FServer;
	System::Word FPort;
	bool FGopherPlusItem;
	Idheaderlist::TIdHeaderList* FGopherBlock;
	System::Classes::TStrings* FViews;
	System::UnicodeString FURL;
	System::Classes::TStrings* FAbstract;
	Idheaderlist::TIdHeaderList* FAsk;
	Idemailaddress::TIdEMailAddressItem* fAdminEmail;
	System::UnicodeString __fastcall GetLastModified(void);
	System::UnicodeString __fastcall GetOrganization(void);
	System::UnicodeString __fastcall GetLocation(void);
	System::UnicodeString __fastcall GetGeog(void);
	
public:
	__fastcall virtual TIdGopherMenuItem(System::Classes::TCollection* ACollection);
	__fastcall virtual ~TIdGopherMenuItem(void);
	virtual void __fastcall DoneSettingInfoBlock(void);
	__property System::UnicodeString Title = {read=FTitle, write=FTitle};
	__property System::WideChar ItemType = {read=FItemType, write=FItemType, nodefault};
	__property System::UnicodeString Selector = {read=FSelector, write=FSelector};
	__property System::UnicodeString Server = {read=FServer, write=FServer};
	__property System::Word Port = {read=FPort, write=FPort, nodefault};
	__property bool GopherPlusItem = {read=FGopherPlusItem, write=FGopherPlusItem, nodefault};
	__property Idheaderlist::TIdHeaderList* GopherBlock = {read=FGopherBlock};
	__property System::UnicodeString URL = {read=FURL};
	__property System::Classes::TStrings* Views = {read=FViews};
	__property System::Classes::TStrings* AAbstract = {read=FAbstract};
	__property System::UnicodeString LastModified = {read=GetLastModified};
	__property Idemailaddress::TIdEMailAddressItem* AdminEMail = {read=fAdminEmail};
	__property System::UnicodeString Organization = {read=GetOrganization};
	__property System::UnicodeString Location = {read=GetLocation};
	__property System::UnicodeString Geog = {read=GetGeog};
	__property Idheaderlist::TIdHeaderList* Ask = {read=FAsk};
};

#pragma pack(pop)

class DELPHICLASS TIdGopherMenu;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdGopherMenu : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TIdGopherMenuItem* operator[](int Index) { return Items[Index]; }
	
protected:
	HIDESBASE TIdGopherMenuItem* __fastcall GetItem(int Index);
	HIDESBASE void __fastcall SetItem(int Index, TIdGopherMenuItem* const Value);
	
public:
	__fastcall TIdGopherMenu(void);
	HIDESBASE TIdGopherMenuItem* __fastcall Add(void);
	__property TIdGopherMenuItem* Items[int Index] = {read=GetItem, write=SetItem/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TIdGopherMenu(void) { }
	
};

#pragma pack(pop)

typedef void __fastcall (__closure *TIdGopherMenuEvent)(System::TObject* Sender, TIdGopherMenuItem* MenuItem);

class DELPHICLASS TIdGopher;
class PASCALIMPLEMENTATION TIdGopher : public Idtcpclient::TIdTCPClientCustom
{
	typedef Idtcpclient::TIdTCPClientCustom inherited;
	
protected:
	TIdGopherMenuEvent FOnMenuItem;
	void __fastcall DoMenu(TIdGopherMenuItem* MenuItem);
	void __fastcall ProcessGopherError(void);
	TIdGopherMenuItem* __fastcall MenuItemFromString(System::UnicodeString stLine, TIdGopherMenu* Menu);
	TIdGopherMenu* __fastcall ProcessDirectory(System::UnicodeString PreviousData = System::UnicodeString(), const int ExpectedLength = 0x0);
	TIdGopherMenu* __fastcall LoadExtendedDirectory(System::UnicodeString PreviousData = System::UnicodeString(), const int ExpectedLength = 0x0);
	void __fastcall ProcessFile(System::Classes::TStream* ADestStream, System::UnicodeString APreviousData = System::UnicodeString(), const int ExpectedLength = 0x0);
	void __fastcall ProcessTextFile(System::Classes::TStream* ADestStream, System::UnicodeString APreviousData = System::UnicodeString(), const int ExpectedLength = 0x0);
	virtual void __fastcall InitComponent(void);
	
public:
	TIdGopherMenu* __fastcall GetMenu(System::UnicodeString ASelector, bool IsGopherPlus = false, System::UnicodeString AView = System::UnicodeString());
	TIdGopherMenu* __fastcall Search(System::UnicodeString ASelector, System::UnicodeString AQuery);
	void __fastcall GetFile(System::UnicodeString ASelector, System::Classes::TStream* ADestStream, bool IsGopherPlus = false, System::UnicodeString AView = System::UnicodeString());
	void __fastcall GetTextFile(System::UnicodeString ASelector, System::Classes::TStream* ADestStream, bool IsGopherPlus = false, System::UnicodeString AView = System::UnicodeString());
	TIdGopherMenu* __fastcall GetExtendedMenu(System::UnicodeString ASelector, System::UnicodeString AView = System::UnicodeString());
	
__published:
	__property TIdGopherMenuEvent OnMenuItem = {read=FOnMenuItem, write=FOnMenuItem};
	__property Port = {default=70};
	__property Host = {default=0};
public:
	/* TIdTCPConnection.Destroy */ inline __fastcall virtual ~TIdGopher(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdGopher(System::Classes::TComponent* AOwner)/* overload */ : Idtcpclient::TIdTCPClientCustom(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdGopher(void)/* overload */ : Idtcpclient::TIdTCPClientCustom() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idgopher */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDGOPHER)
using namespace Idgopher;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdgopherHPP
