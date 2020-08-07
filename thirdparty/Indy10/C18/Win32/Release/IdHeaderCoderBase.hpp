// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdHeaderCoderBase.pas' rev: 25.00 (Windows)

#ifndef IdheadercoderbaseHPP
#define IdheadercoderbaseHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idheadercoderbase
{
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TIdHeaderDecodingNeededEvent)(const System::UnicodeString ACharSet, const Idglobal::TIdBytes AData, System::UnicodeString &VResult, bool &VHandled);

typedef void __fastcall (__closure *TIdHeaderEncodingNeededEvent)(const System::UnicodeString ACharSet, const System::UnicodeString AData, Idglobal::TIdBytes &VResult, bool &VHandled);

class DELPHICLASS TIdHeaderCoder;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdHeaderCoder : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	__classmethod virtual System::UnicodeString __fastcall Decode(const System::UnicodeString ACharSet, const Idglobal::TIdBytes AData);
	__classmethod virtual Idglobal::TIdBytes __fastcall Encode(const System::UnicodeString ACharSet, const System::UnicodeString AData);
	__classmethod virtual bool __fastcall CanHandle(const System::UnicodeString ACharSet);
public:
	/* TObject.Create */ inline __fastcall TIdHeaderCoder(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdHeaderCoder(void) { }
	
};

#pragma pack(pop)

typedef System::TMetaClass* TIdHeaderCoderClass;

class DELPHICLASS EIdHeaderEncodeError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdHeaderEncodeError : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdHeaderEncodeError(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdHeaderEncodeError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdHeaderEncodeError(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdHeaderEncodeError(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdHeaderEncodeError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdHeaderEncodeError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdHeaderEncodeError(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdHeaderEncodeError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdHeaderEncodeError(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdHeaderEncodeError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdHeaderEncodeError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdHeaderEncodeError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdHeaderEncodeError(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TIdHeaderEncodingNeededEvent GHeaderEncodingNeeded;
extern DELPHI_PACKAGE TIdHeaderDecodingNeededEvent GHeaderDecodingNeeded;
extern DELPHI_PACKAGE TIdHeaderCoderClass __fastcall HeaderCoderByCharSet(const System::UnicodeString ACharSet);
extern DELPHI_PACKAGE bool __fastcall DecodeHeaderData(const System::UnicodeString ACharSet, const Idglobal::TIdBytes AData, System::UnicodeString &VResult);
extern DELPHI_PACKAGE Idglobal::TIdBytes __fastcall EncodeHeaderData(const System::UnicodeString ACharSet, const System::UnicodeString AData);
extern DELPHI_PACKAGE void __fastcall RegisterHeaderCoder(const TIdHeaderCoderClass ACoder);
extern DELPHI_PACKAGE void __fastcall UnregisterHeaderCoder(const TIdHeaderCoderClass ACoder);
}	/* namespace Idheadercoderbase */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDHEADERCODERBASE)
using namespace Idheadercoderbase;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdheadercoderbaseHPP
