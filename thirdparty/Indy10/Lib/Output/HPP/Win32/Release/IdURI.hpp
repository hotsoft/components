// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdURI.pas' rev: 25.00 (Windows)

#ifndef IduriHPP
#define IduriHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Iduri
{
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TIdURIOptionalFields : unsigned char { ofAuthInfo, ofBookmark };

typedef System::Set<TIdURIOptionalFields, TIdURIOptionalFields::ofAuthInfo, TIdURIOptionalFields::ofBookmark>  TIdURIOptionalFieldsSet;

class DELPHICLASS TIdURI;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdURI : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	System::UnicodeString FDocument;
	System::UnicodeString FProtocol;
	System::UnicodeString FURI;
	System::UnicodeString FPort;
	System::UnicodeString Fpath;
	System::UnicodeString FHost;
	System::UnicodeString FBookmark;
	System::UnicodeString FUserName;
	System::UnicodeString FPassword;
	System::UnicodeString FParams;
	Idglobal::TIdIPVersion FIPVersion;
	void __fastcall SetURI(const System::UnicodeString Value);
	System::UnicodeString __fastcall GetURI(void);
	
public:
	__fastcall virtual TIdURI(const System::UnicodeString AURI);
	System::UnicodeString __fastcall GetFullURI(const TIdURIOptionalFieldsSet AOptionalFields = (TIdURIOptionalFieldsSet() << TIdURIOptionalFields::ofAuthInfo << TIdURIOptionalFields::ofBookmark ));
	System::UnicodeString __fastcall GetPathAndParams(void);
	__classmethod void __fastcall NormalizePath(System::UnicodeString &APath);
	__classmethod System::UnicodeString __fastcall URLDecode(System::UnicodeString ASrc, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding());
	__classmethod System::UnicodeString __fastcall URLEncode(const System::UnicodeString ASrc, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding());
	__classmethod System::UnicodeString __fastcall ParamsEncode(const System::UnicodeString ASrc, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding());
	__classmethod System::UnicodeString __fastcall PathEncode(const System::UnicodeString ASrc, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding());
	__property System::UnicodeString Bookmark = {read=FBookmark, write=FBookmark};
	__property System::UnicodeString Document = {read=FDocument, write=FDocument};
	__property System::UnicodeString Host = {read=FHost, write=FHost};
	__property System::UnicodeString Password = {read=FPassword, write=FPassword};
	__property System::UnicodeString Path = {read=Fpath, write=Fpath};
	__property System::UnicodeString Params = {read=FParams, write=FParams};
	__property System::UnicodeString Port = {read=FPort, write=FPort};
	__property System::UnicodeString Protocol = {read=FProtocol, write=FProtocol};
	__property System::UnicodeString URI = {read=GetURI, write=SetURI};
	__property System::UnicodeString Username = {read=FUserName, write=FUserName};
	__property Idglobal::TIdIPVersion IPVersion = {read=FIPVersion, write=FIPVersion, nodefault};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdURI(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdURIException;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdURIException : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdURIException(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdURIException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdURIException(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdURIException(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdURIException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdURIException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdURIException(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdURIException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdURIException(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdURIException(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdURIException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdURIException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdURIException(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Iduri */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDURI)
using namespace Iduri;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IduriHPP
