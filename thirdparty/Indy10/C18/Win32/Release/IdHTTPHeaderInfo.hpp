// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdHTTPHeaderInfo.pas' rev: 25.00 (Windows)

#ifndef IdhttpheaderinfoHPP
#define IdhttpheaderinfoHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdAuthentication.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdGlobalProtocols.hpp>	// Pascal unit
#include <IdHeaderList.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idhttpheaderinfo
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdEntityHeaderInfo;
class PASCALIMPLEMENTATION TIdEntityHeaderInfo : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	System::Classes::TPersistent* FOwner;
	System::UnicodeString FCacheControl;
	Idheaderlist::TIdHeaderList* FRawHeaders;
	System::UnicodeString FCharSet;
	System::UnicodeString FConnection;
	System::UnicodeString FContentDisposition;
	System::UnicodeString FContentEncoding;
	System::UnicodeString FContentLanguage;
	__int64 FContentLength;
	__int64 FContentRangeEnd;
	__int64 FContentRangeStart;
	__int64 FContentRangeInstanceLength;
	System::UnicodeString FContentRangeUnits;
	System::UnicodeString FContentType;
	System::UnicodeString FContentVersion;
	Idheaderlist::TIdHeaderList* FCustomHeaders;
	System::TDateTime FDate;
	System::TDateTime FExpires;
	System::UnicodeString FETag;
	System::TDateTime FLastModified;
	System::UnicodeString FPragma;
	bool FHasContentLength;
	System::UnicodeString FTransferEncoding;
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Destination);
	virtual void __fastcall ProcessHeaders(void);
	virtual void __fastcall SetHeaders(void);
	DYNAMIC System::Classes::TPersistent* __fastcall GetOwner(void);
	System::Classes::TComponent* __fastcall GetOwnerComponent(void);
	void __fastcall SetContentLength(const __int64 AValue);
	void __fastcall SetContentType(const System::UnicodeString AValue);
	void __fastcall SetCustomHeaders(Idheaderlist::TIdHeaderList* const AValue);
	bool __fastcall GetHasContentRange(void);
	bool __fastcall GetHasContentRangeInstance(void);
	
public:
	virtual void __fastcall AfterConstruction(void);
	virtual void __fastcall Clear(void);
	__fastcall virtual TIdEntityHeaderInfo(System::Classes::TPersistent* AOwner);
	__fastcall virtual ~TIdEntityHeaderInfo(void);
	__property System::Classes::TComponent* OwnerComponent = {read=GetOwnerComponent};
	__property bool HasContentLength = {read=FHasContentLength, nodefault};
	__property bool HasContentRange = {read=GetHasContentRange, nodefault};
	__property bool HasContentRangeInstance = {read=GetHasContentRangeInstance, nodefault};
	__property Idheaderlist::TIdHeaderList* RawHeaders = {read=FRawHeaders};
	
__published:
	__property System::UnicodeString CacheControl = {read=FCacheControl, write=FCacheControl};
	__property System::UnicodeString CharSet = {read=FCharSet, write=FCharSet};
	__property System::UnicodeString Connection = {read=FConnection, write=FConnection};
	__property System::UnicodeString ContentDisposition = {read=FContentDisposition, write=FContentDisposition};
	__property System::UnicodeString ContentEncoding = {read=FContentEncoding, write=FContentEncoding};
	__property System::UnicodeString ContentLanguage = {read=FContentLanguage, write=FContentLanguage};
	__property __int64 ContentLength = {read=FContentLength, write=SetContentLength};
	__property __int64 ContentRangeEnd = {read=FContentRangeEnd, write=FContentRangeEnd};
	__property __int64 ContentRangeStart = {read=FContentRangeStart, write=FContentRangeStart};
	__property __int64 ContentRangeInstanceLength = {read=FContentRangeInstanceLength, write=FContentRangeInstanceLength};
	__property System::UnicodeString ContentRangeUnits = {read=FContentRangeUnits, write=FContentRangeUnits};
	__property System::UnicodeString ContentType = {read=FContentType, write=SetContentType};
	__property System::UnicodeString ContentVersion = {read=FContentVersion, write=FContentVersion};
	__property Idheaderlist::TIdHeaderList* CustomHeaders = {read=FCustomHeaders, write=SetCustomHeaders};
	__property System::TDateTime Date = {read=FDate, write=FDate};
	__property System::UnicodeString ETag = {read=FETag, write=FETag};
	__property System::TDateTime Expires = {read=FExpires, write=FExpires};
	__property System::TDateTime LastModified = {read=FLastModified, write=FLastModified};
	__property System::UnicodeString Pragma = {read=FPragma, write=FPragma};
	__property System::UnicodeString TransferEncoding = {read=FTransferEncoding, write=FTransferEncoding};
};


class DELPHICLASS TIdProxyConnectionInfo;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdProxyConnectionInfo : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	Idauthentication::TIdAuthentication* FAuthentication;
	System::UnicodeString FPassword;
	int FPort;
	System::UnicodeString FServer;
	System::UnicodeString FUsername;
	bool FBasicByDefault;
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Destination);
	void __fastcall SetProxyPort(const int Value);
	void __fastcall SetProxyServer(const System::UnicodeString Value);
	
public:
	virtual void __fastcall AfterConstruction(void);
	__fastcall TIdProxyConnectionInfo(void);
	void __fastcall Clear(void);
	__fastcall virtual ~TIdProxyConnectionInfo(void);
	void __fastcall SetHeaders(Idheaderlist::TIdHeaderList* Headers);
	__property Idauthentication::TIdAuthentication* Authentication = {read=FAuthentication, write=FAuthentication};
	
__published:
	__property bool BasicAuthentication = {read=FBasicByDefault, write=FBasicByDefault, nodefault};
	__property System::UnicodeString ProxyPassword = {read=FPassword, write=FPassword};
	__property int ProxyPort = {read=FPort, write=SetProxyPort, nodefault};
	__property System::UnicodeString ProxyServer = {read=FServer, write=SetProxyServer};
	__property System::UnicodeString ProxyUsername = {read=FUsername, write=FUsername};
};

#pragma pack(pop)

class DELPHICLASS TIdEntityRange;
class PASCALIMPLEMENTATION TIdEntityRange : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
protected:
	__int64 FStartPos;
	__int64 FEndPos;
	__int64 FSuffixLength;
	System::UnicodeString __fastcall GetText(void);
	void __fastcall SetText(const System::UnicodeString AValue);
	
public:
	__fastcall virtual TIdEntityRange(System::Classes::TCollection* Collection);
	
__published:
	__property __int64 StartPos = {read=FStartPos, write=FStartPos};
	__property __int64 EndPos = {read=FEndPos, write=FEndPos};
	__property __int64 SuffixLength = {read=FSuffixLength, write=FSuffixLength};
	__property System::UnicodeString Text = {read=GetText, write=SetText};
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdEntityRange(void) { }
	
};


class DELPHICLASS TIdEntityRanges;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdEntityRanges : public System::Classes::TOwnedCollection
{
	typedef System::Classes::TOwnedCollection inherited;
	
public:
	TIdEntityRange* operator[](int Index) { return Ranges[Index]; }
	
protected:
	System::UnicodeString FUnits;
	TIdEntityRange* __fastcall GetRange(int Index);
	void __fastcall SetRange(int Index, TIdEntityRange* AValue);
	System::UnicodeString __fastcall GetText(void);
	void __fastcall SetText(const System::UnicodeString AValue);
	void __fastcall SetUnits(const System::UnicodeString AValue);
	
public:
	__fastcall TIdEntityRanges(System::Classes::TPersistent* AOwner);
	HIDESBASE TIdEntityRange* __fastcall Add(void);
	__property TIdEntityRange* Ranges[int Index] = {read=GetRange, write=SetRange/*, default*/};
	
__published:
	__property System::UnicodeString Text = {read=GetText, write=SetText};
	__property System::UnicodeString Units = {read=FUnits, write=SetUnits};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TIdEntityRanges(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdRequestHeaderInfo;
class PASCALIMPLEMENTATION TIdRequestHeaderInfo : public TIdEntityHeaderInfo
{
	typedef TIdEntityHeaderInfo inherited;
	
protected:
	System::UnicodeString FAccept;
	System::UnicodeString FAcceptCharSet;
	System::UnicodeString FAcceptEncoding;
	System::UnicodeString FAcceptLanguage;
	System::UnicodeString FExpect;
	System::UnicodeString FFrom;
	System::UnicodeString FPassword;
	System::UnicodeString FReferer;
	System::UnicodeString FUserAgent;
	System::UnicodeString FUserName;
	System::UnicodeString FHost;
	System::UnicodeString FProxyConnection;
	TIdEntityRanges* FRanges;
	bool FBasicByDefault;
	Idauthentication::TIdAuthentication* FAuthentication;
	System::UnicodeString FMethodOverride;
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Destination);
	virtual void __fastcall ProcessHeaders(void);
	virtual void __fastcall SetHeaders(void);
	System::UnicodeString __fastcall GetRange(void);
	void __fastcall SetRange(const System::UnicodeString AValue);
	void __fastcall SetRanges(TIdEntityRanges* AValue);
	
public:
	__fastcall virtual TIdRequestHeaderInfo(System::Classes::TPersistent* AOwner);
	__fastcall virtual ~TIdRequestHeaderInfo(void);
	virtual void __fastcall Clear(void);
	__property Idauthentication::TIdAuthentication* Authentication = {read=FAuthentication, write=FAuthentication};
	
__published:
	__property System::UnicodeString Accept = {read=FAccept, write=FAccept};
	__property System::UnicodeString AcceptCharSet = {read=FAcceptCharSet, write=FAcceptCharSet};
	__property System::UnicodeString AcceptEncoding = {read=FAcceptEncoding, write=FAcceptEncoding};
	__property System::UnicodeString AcceptLanguage = {read=FAcceptLanguage, write=FAcceptLanguage};
	__property bool BasicAuthentication = {read=FBasicByDefault, write=FBasicByDefault, nodefault};
	__property System::UnicodeString Host = {read=FHost, write=FHost};
	__property System::UnicodeString From = {read=FFrom, write=FFrom};
	__property System::UnicodeString Password = {read=FPassword, write=FPassword};
	__property System::UnicodeString Referer = {read=FReferer, write=FReferer};
	__property System::UnicodeString UserAgent = {read=FUserAgent, write=FUserAgent};
	__property System::UnicodeString Username = {read=FUserName, write=FUserName};
	__property System::UnicodeString ProxyConnection = {read=FProxyConnection, write=FProxyConnection};
	__property System::UnicodeString Range = {read=GetRange, write=SetRange};
	__property TIdEntityRanges* Ranges = {read=FRanges, write=SetRanges};
	__property System::UnicodeString MethodOverride = {read=FMethodOverride, write=FMethodOverride};
};


class DELPHICLASS TIdResponseHeaderInfo;
class PASCALIMPLEMENTATION TIdResponseHeaderInfo : public TIdEntityHeaderInfo
{
	typedef TIdEntityHeaderInfo inherited;
	
protected:
	System::UnicodeString FAcceptPatch;
	System::UnicodeString FAcceptRanges;
	System::UnicodeString FLocation;
	System::UnicodeString FServer;
	System::UnicodeString FProxyConnection;
	Idheaderlist::TIdHeaderList* FProxyAuthenticate;
	Idheaderlist::TIdHeaderList* FWWWAuthenticate;
	void __fastcall SetProxyAuthenticate(Idheaderlist::TIdHeaderList* const Value);
	void __fastcall SetWWWAuthenticate(Idheaderlist::TIdHeaderList* const Value);
	void __fastcall SetAcceptPatch(const System::UnicodeString Value);
	void __fastcall SetAcceptRanges(const System::UnicodeString Value);
	virtual void __fastcall ProcessHeaders(void);
	virtual void __fastcall SetHeaders(void);
	
public:
	virtual void __fastcall Clear(void);
	__fastcall virtual TIdResponseHeaderInfo(System::Classes::TPersistent* AOwner);
	__fastcall virtual ~TIdResponseHeaderInfo(void);
	
__published:
	__property System::UnicodeString AcceptPatch = {read=FAcceptPatch, write=SetAcceptPatch};
	__property System::UnicodeString AcceptRanges = {read=FAcceptRanges, write=SetAcceptRanges};
	__property System::UnicodeString Location = {read=FLocation, write=FLocation};
	__property System::UnicodeString ProxyConnection = {read=FProxyConnection, write=FProxyConnection};
	__property Idheaderlist::TIdHeaderList* ProxyAuthenticate = {read=FProxyAuthenticate, write=SetProxyAuthenticate};
	__property System::UnicodeString Server = {read=FServer, write=FServer};
	__property Idheaderlist::TIdHeaderList* WWWAuthenticate = {read=FWWWAuthenticate, write=SetWWWAuthenticate};
};


class DELPHICLASS TIdMetaHTTPEquiv;
class PASCALIMPLEMENTATION TIdMetaHTTPEquiv : public TIdEntityHeaderInfo
{
	typedef TIdEntityHeaderInfo inherited;
	
public:
	void __fastcall ProcessMetaHTTPEquiv(System::Classes::TStream* AStream);
public:
	/* TIdEntityHeaderInfo.Create */ inline __fastcall virtual TIdMetaHTTPEquiv(System::Classes::TPersistent* AOwner) : TIdEntityHeaderInfo(AOwner) { }
	/* TIdEntityHeaderInfo.Destroy */ inline __fastcall virtual ~TIdMetaHTTPEquiv(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::UnicodeString GIdDefaultUserAgent;
}	/* namespace Idhttpheaderinfo */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDHTTPHEADERINFO)
using namespace Idhttpheaderinfo;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdhttpheaderinfoHPP
