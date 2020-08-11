// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdVCard.pas' rev: 25.00 (Windows)

#ifndef IdvcardHPP
#define IdvcardHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idvcard
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdVCardEmbeddedObject;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdVCardEmbeddedObject : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	System::UnicodeString FObjectType;
	System::UnicodeString FObjectURL;
	bool FBase64Encoded;
	System::Classes::TStrings* FEmbeddedData;
	void __fastcall SetEmbeddedData(System::Classes::TStrings* const Value);
	
public:
	__fastcall TIdVCardEmbeddedObject(void);
	__fastcall virtual ~TIdVCardEmbeddedObject(void);
	
__published:
	__property System::UnicodeString ObjectType = {read=FObjectType, write=FObjectType};
	__property System::UnicodeString ObjectURL = {read=FObjectURL, write=FObjectURL};
	__property bool Base64Encoded = {read=FBase64Encoded, write=FBase64Encoded, nodefault};
	__property System::Classes::TStrings* EmbeddedData = {read=FEmbeddedData, write=SetEmbeddedData};
};

#pragma pack(pop)

class DELPHICLASS TIdVCardBusinessInfo;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdVCardBusinessInfo : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	System::UnicodeString FTitle;
	System::UnicodeString FRole;
	System::UnicodeString FOrganization;
	System::Classes::TStrings* FDivisions;
	void __fastcall SetDivisions(System::Classes::TStrings* Value);
	
public:
	__fastcall TIdVCardBusinessInfo(void);
	__fastcall virtual ~TIdVCardBusinessInfo(void);
	
__published:
	__property System::UnicodeString Organization = {read=FOrganization, write=FOrganization};
	__property System::Classes::TStrings* Divisions = {read=FDivisions, write=SetDivisions};
	__property System::UnicodeString Title = {read=FTitle, write=FTitle};
	__property System::UnicodeString Role = {read=FRole, write=FRole};
};

#pragma pack(pop)

class DELPHICLASS TIdVCardGeog;
class PASCALIMPLEMENTATION TIdVCardGeog : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	double FLatitude;
	double FLongitude;
	System::UnicodeString FTimeZoneStr;
	
__published:
	__property double Latitude = {read=FLatitude, write=FLatitude};
	__property double Longitude = {read=FLongitude, write=FLongitude};
	__property System::UnicodeString TimeZoneStr = {read=FTimeZoneStr, write=FTimeZoneStr};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TIdVCardGeog(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TIdVCardGeog(void) : System::Classes::TPersistent() { }
	
};


enum DECLSPEC_DENUM TIdPhoneAttribute : unsigned char { tpaHome, tpaVoiceMessaging, tpaWork, tpaPreferred, tpaVoice, tpaFax, tpaCellular, tpaVideo, tpaBBS, tpaModem, tpaCar, tpaISDN, tpaPCS, tpaPager };

typedef System::Set<TIdPhoneAttribute, TIdPhoneAttribute::tpaHome, TIdPhoneAttribute::tpaPager>  TIdPhoneAttributes;

class DELPHICLASS TIdCardPhoneNumber;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdCardPhoneNumber : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
protected:
	TIdPhoneAttributes FPhoneAttributes;
	System::UnicodeString FNumber;
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	
__published:
	__property TIdPhoneAttributes PhoneAttributes = {read=FPhoneAttributes, write=FPhoneAttributes, nodefault};
	__property System::UnicodeString Number = {read=FNumber, write=FNumber};
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TIdCardPhoneNumber(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdCardPhoneNumber(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdVCardTelephones;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdVCardTelephones : public System::Classes::TOwnedCollection
{
	typedef System::Classes::TOwnedCollection inherited;
	
public:
	TIdCardPhoneNumber* operator[](int Index) { return Items[Index]; }
	
protected:
	HIDESBASE TIdCardPhoneNumber* __fastcall GetItem(int Index);
	HIDESBASE void __fastcall SetItem(int Index, TIdCardPhoneNumber* const Value);
	
public:
	__fastcall TIdVCardTelephones(System::Classes::TPersistent* AOwner);
	HIDESBASE TIdCardPhoneNumber* __fastcall Add(void);
	__property TIdCardPhoneNumber* Items[int Index] = {read=GetItem, write=SetItem/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TIdVCardTelephones(void) { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TIdCardAddressAttribute : unsigned char { tatHome, tatDomestic, tatInternational, tatPostal, tatParcel, tatWork, tatPreferred };

typedef System::Set<TIdCardAddressAttribute, TIdCardAddressAttribute::tatHome, TIdCardAddressAttribute::tatPreferred>  TIdCardAddressAttributes;

class DELPHICLASS TIdCardAddressItem;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdCardAddressItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
protected:
	TIdCardAddressAttributes FAddressAttributes;
	System::UnicodeString FPOBox;
	System::UnicodeString FExtendedAddress;
	System::UnicodeString FStreetAddress;
	System::UnicodeString FLocality;
	System::UnicodeString FRegion;
	System::UnicodeString FPostalCode;
	System::UnicodeString FNation;
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	
__published:
	__property TIdCardAddressAttributes AddressAttributes = {read=FAddressAttributes, write=FAddressAttributes, nodefault};
	__property System::UnicodeString POBox = {read=FPOBox, write=FPOBox};
	__property System::UnicodeString ExtendedAddress = {read=FExtendedAddress, write=FExtendedAddress};
	__property System::UnicodeString StreetAddress = {read=FStreetAddress, write=FStreetAddress};
	__property System::UnicodeString Locality = {read=FLocality, write=FLocality};
	__property System::UnicodeString Region = {read=FRegion, write=FRegion};
	__property System::UnicodeString PostalCode = {read=FPostalCode, write=FPostalCode};
	__property System::UnicodeString Nation = {read=FNation, write=FNation};
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TIdCardAddressItem(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdCardAddressItem(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdVCardAddresses;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdVCardAddresses : public System::Classes::TOwnedCollection
{
	typedef System::Classes::TOwnedCollection inherited;
	
public:
	TIdCardAddressItem* operator[](int Index) { return Items[Index]; }
	
protected:
	HIDESBASE TIdCardAddressItem* __fastcall GetItem(int Index);
	HIDESBASE void __fastcall SetItem(int Index, TIdCardAddressItem* const Value);
	
public:
	__fastcall TIdVCardAddresses(System::Classes::TPersistent* AOwner);
	HIDESBASE TIdCardAddressItem* __fastcall Add(void);
	__property TIdCardAddressItem* Items[int Index] = {read=GetItem, write=SetItem/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TIdVCardAddresses(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdVCardMailingLabelItem;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdVCardMailingLabelItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
private:
	TIdCardAddressAttributes FAddressAttributes;
	System::Classes::TStrings* FMailingLabel;
	void __fastcall SetMailingLabel(System::Classes::TStrings* Value);
	
public:
	__fastcall virtual TIdVCardMailingLabelItem(System::Classes::TCollection* Collection);
	__fastcall virtual ~TIdVCardMailingLabelItem(void);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	
__published:
	__property TIdCardAddressAttributes AddressAttributes = {read=FAddressAttributes, write=FAddressAttributes, nodefault};
	__property System::Classes::TStrings* MailingLabel = {read=FMailingLabel, write=SetMailingLabel};
};

#pragma pack(pop)

class DELPHICLASS TIdVCardMailingLabels;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdVCardMailingLabels : public System::Classes::TOwnedCollection
{
	typedef System::Classes::TOwnedCollection inherited;
	
public:
	TIdVCardMailingLabelItem* operator[](int Index) { return Items[Index]; }
	
protected:
	HIDESBASE TIdVCardMailingLabelItem* __fastcall GetItem(int Index);
	HIDESBASE void __fastcall SetItem(int Index, TIdVCardMailingLabelItem* const Value);
	
public:
	__fastcall TIdVCardMailingLabels(System::Classes::TPersistent* AOwner);
	HIDESBASE TIdVCardMailingLabelItem* __fastcall Add(void);
	__property TIdVCardMailingLabelItem* Items[int Index] = {read=GetItem, write=SetItem/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TIdVCardMailingLabels(void) { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TIdVCardEMailType : unsigned char { ematAOL, ematAppleLink, ematATT, ematCIS, emateWorld, ematInternet, ematIBMMail, ematMCIMail, ematPowerShare, ematProdigy, ematTelex, ematX400 };

class DELPHICLASS TIdVCardEMailItem;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdVCardEMailItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
protected:
	TIdVCardEMailType FEMailType;
	bool FPreferred;
	System::UnicodeString FAddress;
	
public:
	__fastcall virtual TIdVCardEMailItem(System::Classes::TCollection* Collection);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	
__published:
	__property TIdVCardEMailType EMailType = {read=FEMailType, write=FEMailType, nodefault};
	__property bool Preferred = {read=FPreferred, write=FPreferred, nodefault};
	__property System::UnicodeString Address = {read=FAddress, write=FAddress};
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdVCardEMailItem(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdVCardEMailAddresses;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdVCardEMailAddresses : public System::Classes::TOwnedCollection
{
	typedef System::Classes::TOwnedCollection inherited;
	
public:
	TIdVCardEMailItem* operator[](int Index) { return Items[Index]; }
	
protected:
	HIDESBASE TIdVCardEMailItem* __fastcall GetItem(int Index);
	HIDESBASE void __fastcall SetItem(int Index, TIdVCardEMailItem* const Value);
	
public:
	__fastcall TIdVCardEMailAddresses(System::Classes::TPersistent* AOwner);
	HIDESBASE TIdVCardEMailItem* __fastcall Add(void);
	__property TIdVCardEMailItem* Items[int Index] = {read=GetItem, write=SetItem/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TIdVCardEMailAddresses(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdVCardName;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdVCardName : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	System::UnicodeString FFirstName;
	System::UnicodeString FSurName;
	System::Classes::TStrings* FOtherNames;
	System::UnicodeString FPrefix;
	System::UnicodeString FSuffix;
	System::UnicodeString FFormattedName;
	System::UnicodeString FSortName;
	System::Classes::TStrings* FNickNames;
	void __fastcall SetOtherNames(System::Classes::TStrings* Value);
	void __fastcall SetNickNames(System::Classes::TStrings* Value);
	
public:
	__fastcall TIdVCardName(void);
	__fastcall virtual ~TIdVCardName(void);
	
__published:
	__property System::UnicodeString FirstName = {read=FFirstName, write=FFirstName};
	__property System::UnicodeString SurName = {read=FSurName, write=FSurName};
	__property System::Classes::TStrings* OtherNames = {read=FOtherNames, write=SetOtherNames};
	__property System::UnicodeString FormattedName = {read=FFormattedName, write=FFormattedName};
	__property System::UnicodeString Prefix = {read=FPrefix, write=FPrefix};
	__property System::UnicodeString Suffix = {read=FSuffix, write=FSuffix};
	__property System::UnicodeString SortName = {read=FSortName, write=FSortName};
	__property System::Classes::TStrings* NickNames = {read=FNickNames, write=SetNickNames};
};

#pragma pack(pop)

class DELPHICLASS TIdVCard;
class PASCALIMPLEMENTATION TIdVCard : public Idbasecomponent::TIdBaseComponent
{
	typedef Idbasecomponent::TIdBaseComponent inherited;
	
protected:
	System::Classes::TStrings* FComments;
	System::Classes::TStrings* FCategories;
	TIdVCardBusinessInfo* FBusinessInfo;
	TIdVCardGeog* FGeography;
	TIdVCardName* FFullName;
	System::Classes::TStrings* FRawForm;
	System::Classes::TStrings* FURLs;
	System::UnicodeString FEMailProgram;
	TIdVCardEMailAddresses* FEMailAddresses;
	TIdVCardAddresses* FAddresses;
	TIdVCardMailingLabels* FMailingLabels;
	TIdVCardTelephones* FTelephones;
	double FVCardVersion;
	System::UnicodeString FProductID;
	System::UnicodeString FUniqueID;
	System::UnicodeString FClassification;
	System::TDateTime FLastRevised;
	System::TDateTime FBirthDay;
	TIdVCardEmbeddedObject* FPhoto;
	TIdVCardEmbeddedObject* FLogo;
	TIdVCardEmbeddedObject* FSound;
	TIdVCardEmbeddedObject* FKey;
	void __fastcall SetComments(System::Classes::TStrings* Value);
	void __fastcall SetCategories(System::Classes::TStrings* Value);
	void __fastcall SetURLs(System::Classes::TStrings* Value);
	void __fastcall SetVariablesAfterRead(void);
	virtual void __fastcall InitComponent(void);
	
public:
	__fastcall virtual ~TIdVCard(void);
	void __fastcall ReadFromStrings(System::Classes::TStrings* s);
	__property System::Classes::TStrings* RawForm = {read=FRawForm};
	
__published:
	__property double VCardVersion = {read=FVCardVersion};
	__property System::Classes::TStrings* URLs = {read=FURLs, write=SetURLs};
	__property System::UnicodeString ProductID = {read=FProductID, write=FProductID};
	__property System::UnicodeString UniqueID = {read=FUniqueID, write=FUniqueID};
	__property System::UnicodeString Classification = {read=FClassification, write=FClassification};
	__property System::TDateTime BirthDay = {read=FBirthDay, write=FBirthDay};
	__property TIdVCardName* FullName = {read=FFullName, write=FFullName};
	__property System::UnicodeString EMailProgram = {read=FEMailProgram, write=FEMailProgram};
	__property TIdVCardEMailAddresses* EMailAddresses = {read=FEMailAddresses};
	__property TIdVCardTelephones* Telephones = {read=FTelephones};
	__property TIdVCardBusinessInfo* BusinessInfo = {read=FBusinessInfo};
	__property System::Classes::TStrings* Categories = {read=FCategories, write=SetCategories};
	__property TIdVCardAddresses* Addresses = {read=FAddresses};
	__property TIdVCardMailingLabels* MailingLabels = {read=FMailingLabels};
	__property System::Classes::TStrings* Comments = {read=FComments, write=SetComments};
	__property TIdVCardEmbeddedObject* Photo = {read=FPhoto};
	__property TIdVCardEmbeddedObject* Logo = {read=FLogo};
	__property TIdVCardEmbeddedObject* Sound = {read=FSound};
	__property TIdVCardEmbeddedObject* Key = {read=FKey};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdVCard(System::Classes::TComponent* AOwner)/* overload */ : Idbasecomponent::TIdBaseComponent(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdVCard(void)/* overload */ : Idbasecomponent::TIdBaseComponent() { }
	
};


struct DECLSPEC_DRECORD TIdISO8601DateComps
{
public:
	System::Word Year;
	System::Word Month;
	System::Word Day;
};


struct DECLSPEC_DRECORD TIdISO8601TimeComps
{
public:
	System::Word Hour;
	System::Word Min;
	System::Word Sec;
	System::Word MSec;
	System::UnicodeString UTCOffset;
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE bool __fastcall ParseISO8601Date(const System::UnicodeString DateString, TIdISO8601DateComps &VDate);
extern DELPHI_PACKAGE bool __fastcall ParseISO8601Time(const System::UnicodeString DateString, TIdISO8601TimeComps &VTime);
extern DELPHI_PACKAGE bool __fastcall ParseISO8601DateTime(const System::UnicodeString DateString, TIdISO8601DateComps &VDate, TIdISO8601TimeComps &VTime);
extern DELPHI_PACKAGE bool __fastcall ParseISO8601DateAndOrTime(const System::UnicodeString DateString, TIdISO8601DateComps &VDate, TIdISO8601TimeComps &VTime);
extern DELPHI_PACKAGE bool __fastcall ParseISO8601DateTimeStamp(const System::UnicodeString DateString, TIdISO8601DateComps &VDate, TIdISO8601TimeComps &VTime);
extern DELPHI_PACKAGE System::TDateTime __fastcall ParseDateTimeStamp _DEPRECATED_ATTRIBUTE1("Use ParseISO8601DateTimeStamp()") (const System::UnicodeString DateString);
}	/* namespace Idvcard */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDVCARD)
using namespace Idvcard;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdvcardHPP
