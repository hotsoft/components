// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdUserAccounts.pas' rev: 25.00 (Windows)

#ifndef IduseraccountsHPP
#define IduseraccountsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdStrings.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Iduseraccounts
{
//-- type declarations -------------------------------------------------------
typedef unsigned TIdUserHandle;

typedef int TIdUserAccess;

enum DECLSPEC_DENUM TIdCustomUserManagerOption : unsigned char { umoCaseSensitiveUsername, umoCaseSensitivePassword };

typedef System::Set<TIdCustomUserManagerOption, TIdCustomUserManagerOption::umoCaseSensitiveUsername, TIdCustomUserManagerOption::umoCaseSensitivePassword>  TIdCustomUserManagerOptions;

typedef void __fastcall (__closure *TIdUserManagerAuthenticationEvent)(System::TObject* Sender, const System::UnicodeString AUsername, System::UnicodeString &VPassword, unsigned &VUserHandle, int &VUserAccess);

typedef void __fastcall (__closure *TIdUserManagerLogoffEvent)(System::TObject* Sender, unsigned &VUserHandle);

class DELPHICLASS TIdCustomUserManager;
class PASCALIMPLEMENTATION TIdCustomUserManager : public Idbasecomponent::TIdBaseComponent
{
	typedef Idbasecomponent::TIdBaseComponent inherited;
	
protected:
	System::UnicodeString FDomain;
	TIdUserManagerAuthenticationEvent FOnAfterAuthentication;
	TIdUserManagerAuthenticationEvent FOnBeforeAuthentication;
	TIdUserManagerLogoffEvent FOnLogoffUser;
	virtual void __fastcall DoBeforeAuthentication(const System::UnicodeString AUsername, System::UnicodeString &VPassword, unsigned &VUserHandle, int &VUserAccess);
	virtual void __fastcall DoAuthentication(const System::UnicodeString AUsername, System::UnicodeString &VPassword, unsigned &VUserHandle, int &VUserAccess) = 0 ;
	virtual void __fastcall DoAfterAuthentication(const System::UnicodeString AUsername, System::UnicodeString &VPassword, unsigned &VUserHandle, int &VUserAccess);
	virtual void __fastcall DoLogoffUser(unsigned &VUserHandle);
	virtual TIdCustomUserManagerOptions __fastcall GetOptions(void);
	virtual void __fastcall SetDomain(const System::UnicodeString AValue);
	virtual void __fastcall SetOptions(const TIdCustomUserManagerOptions AValue);
	__property System::UnicodeString Domain = {read=FDomain, write=SetDomain};
	__property TIdCustomUserManagerOptions Options = {read=GetOptions, write=SetOptions, nodefault};
	__property TIdUserManagerAuthenticationEvent OnBeforeAuthentication = {read=FOnBeforeAuthentication, write=FOnBeforeAuthentication};
	__property TIdUserManagerAuthenticationEvent OnAfterAuthentication = {read=FOnAfterAuthentication, write=FOnAfterAuthentication};
	__property TIdUserManagerLogoffEvent OnLogoffUser = {read=FOnLogoffUser, write=FOnLogoffUser};
	
public:
	virtual System::UnicodeString __fastcall ChallengeUser(bool &VIsSafe, const System::UnicodeString AUserName);
	bool __fastcall AuthenticateUser(const System::UnicodeString AUsername, const System::UnicodeString APassword)/* overload */;
	int __fastcall AuthenticateUser(const System::UnicodeString AUsername, const System::UnicodeString APassword, unsigned &VUserHandle)/* overload */;
	__classmethod bool __fastcall IsRegisteredUser(int AUserAccess);
	virtual void __fastcall LogoffUser(unsigned AUserHandle);
	virtual void __fastcall UserDisconnected(const System::UnicodeString AUser);
	virtual bool __fastcall SendsChallange(void);
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdCustomUserManager(System::Classes::TComponent* AOwner)/* overload */ : Idbasecomponent::TIdBaseComponent(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdCustomUserManager(void)/* overload */ : Idbasecomponent::TIdBaseComponent() { }
	
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TIdCustomUserManager(void) { }
	
};


class DELPHICLASS TIdSimpleUserManager;
class PASCALIMPLEMENTATION TIdSimpleUserManager : public TIdCustomUserManager
{
	typedef TIdCustomUserManager inherited;
	
protected:
	TIdCustomUserManagerOptions FOptions;
	TIdUserManagerAuthenticationEvent FOnAuthentication;
	virtual void __fastcall DoAuthentication(const System::UnicodeString AUsername, System::UnicodeString &VPassword, unsigned &VUserHandle, int &VUserAccess);
	virtual TIdCustomUserManagerOptions __fastcall GetOptions(void);
	virtual void __fastcall SetOptions(const TIdCustomUserManagerOptions AValue);
	
__published:
	__property Domain = {default=0};
	__property Options;
	__property OnBeforeAuthentication;
	__property TIdUserManagerAuthenticationEvent OnAuthentication = {read=FOnAuthentication, write=FOnAuthentication};
	__property OnAfterAuthentication;
	__property OnLogoffUser;
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdSimpleUserManager(System::Classes::TComponent* AOwner)/* overload */ : TIdCustomUserManager(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdSimpleUserManager(void)/* overload */ : TIdCustomUserManager() { }
	
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TIdSimpleUserManager(void) { }
	
};


class DELPHICLASS TIdUserAccount;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdUserAccount : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
protected:
	System::Classes::TStrings* FAttributes;
	System::TObject* FData;
	System::UnicodeString FUserName;
	System::UnicodeString FPassword;
	System::UnicodeString FRealName;
	int FAccess;
	void __fastcall SetAttributes(System::Classes::TStrings* const AValue);
	virtual void __fastcall SetPassword(const System::UnicodeString AValue);
	
public:
	__fastcall virtual TIdUserAccount(System::Classes::TCollection* ACollection);
	__fastcall virtual ~TIdUserAccount(void);
	virtual bool __fastcall CheckPassword(const System::UnicodeString APassword);
	__property System::TObject* Data = {read=FData, write=FData};
	
__published:
	__property int Access = {read=FAccess, write=FAccess, default=0};
	__property System::Classes::TStrings* Attributes = {read=FAttributes, write=SetAttributes};
	__property System::UnicodeString UserName = {read=FUserName, write=FUserName};
	__property System::UnicodeString Password = {read=FPassword, write=SetPassword};
	__property System::UnicodeString RealName = {read=FRealName, write=FRealName};
};

#pragma pack(pop)

class DELPHICLASS TIdUserAccounts;
class DELPHICLASS TIdUserManager;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdUserAccounts : public System::Classes::TOwnedCollection
{
	typedef System::Classes::TOwnedCollection inherited;
	
public:
	TIdUserAccount* operator[](const System::UnicodeString AUserName) { return UserNames[AUserName]; }
	
protected:
	bool FCaseSensitiveUsernames;
	bool FCaseSensitivePasswords;
	TIdUserAccount* __fastcall GetAccount(const int AIndex);
	TIdUserAccount* __fastcall GetByUsername(const System::UnicodeString AUsername);
	void __fastcall SetAccount(const int AIndex, TIdUserAccount* AAccountValue);
	
public:
	HIDESBASE TIdUserAccount* __fastcall Add(void);
	__fastcall TIdUserAccounts(TIdUserManager* AOwner);
	__property bool CaseSensitiveUsernames = {read=FCaseSensitiveUsernames, write=FCaseSensitiveUsernames, nodefault};
	__property bool CaseSensitivePasswords = {read=FCaseSensitivePasswords, write=FCaseSensitivePasswords, nodefault};
	__property TIdUserAccount* UserNames[const System::UnicodeString AUserName] = {read=GetByUsername/*, default*/};
	__property TIdUserAccount* Items[const int AIndex] = {read=GetAccount, write=SetAccount};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TIdUserAccounts(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TIdUserManager : public TIdCustomUserManager
{
	typedef TIdCustomUserManager inherited;
	
protected:
	TIdUserAccounts* FAccounts;
	virtual void __fastcall DoAuthentication(const System::UnicodeString AUsername, System::UnicodeString &VPassword, unsigned &VUserHandle, int &VUserAccess);
	virtual TIdCustomUserManagerOptions __fastcall GetOptions(void);
	void __fastcall SetAccounts(TIdUserAccounts* AValue);
	virtual void __fastcall SetOptions(const TIdCustomUserManagerOptions AValue);
	virtual void __fastcall InitComponent(void);
	
public:
	__fastcall virtual ~TIdUserManager(void);
	
__published:
	__property TIdUserAccounts* Accounts = {read=FAccounts, write=SetAccounts};
	__property Options;
	__property OnBeforeAuthentication;
	__property OnAfterAuthentication;
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdUserManager(System::Classes::TComponent* AOwner)/* overload */ : TIdCustomUserManager(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdUserManager(void)/* overload */ : TIdCustomUserManager() { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE unsigned IdUserHandleNone;
extern DELPHI_PACKAGE unsigned IdUserHandleBroadcast;
extern DELPHI_PACKAGE int IdUserAccessDenied;
static const System::Int8 IdUserAccountDefaultAccess = System::Int8(0x0);
}	/* namespace Iduseraccounts */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDUSERACCOUNTS)
using namespace Iduseraccounts;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IduseraccountsHPP
