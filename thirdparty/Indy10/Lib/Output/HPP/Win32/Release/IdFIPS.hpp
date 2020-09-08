// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdFIPS.pas' rev: 25.00 (Windows)

#ifndef IdfipsHPP
#define IdfipsHPP

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

namespace Idfips
{
//-- type declarations -------------------------------------------------------
typedef void * TIdHashIntCtx;

typedef void * TIdHMACIntCtx;

class DELPHICLASS EIdFIPSAlgorithmNotAllowed;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdFIPSAlgorithmNotAllowed : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdFIPSAlgorithmNotAllowed(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdFIPSAlgorithmNotAllowed(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdFIPSAlgorithmNotAllowed(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdFIPSAlgorithmNotAllowed(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdFIPSAlgorithmNotAllowed(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdFIPSAlgorithmNotAllowed(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdFIPSAlgorithmNotAllowed(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdFIPSAlgorithmNotAllowed(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdFIPSAlgorithmNotAllowed(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdFIPSAlgorithmNotAllowed(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdFIPSAlgorithmNotAllowed(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdFIPSAlgorithmNotAllowed(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdFIPSAlgorithmNotAllowed(void) { }
	
};

#pragma pack(pop)

typedef bool __fastcall (*TGetFIPSMode)(void);

typedef bool __fastcall (*TSetFIPSMode)(const bool AMode);

typedef bool __fastcall (*TIsHashingIntfAvail)(void);

typedef void * __fastcall (*TGetHashInst)(void);

typedef void __fastcall (*TUpdateHashInst)(void * ACtx, const Idglobal::TIdBytes AIn);

typedef Idglobal::TIdBytes __fastcall (*TFinalHashInst)(void * ACtx);

typedef bool __fastcall (*TIsHMACAvail)(void);

typedef bool __fastcall (*TIsHMACIntfAvail)(void);

typedef void * __fastcall (*TGetHMACInst)(const Idglobal::TIdBytes AKey);

typedef void __fastcall (*TUpdateHMACInst)(void * ACtx, const Idglobal::TIdBytes AIn);

typedef Idglobal::TIdBytes __fastcall (*TFinalHMACInst)(void * ACtx);

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TGetFIPSMode GetFIPSMode;
extern DELPHI_PACKAGE TSetFIPSMode SetFIPSMode;
extern DELPHI_PACKAGE TIsHashingIntfAvail IsHashingIntfAvail;
extern DELPHI_PACKAGE TGetHashInst GetMD2HashInst;
extern DELPHI_PACKAGE TIsHashingIntfAvail IsMD2HashIntfAvail;
extern DELPHI_PACKAGE TGetHashInst GetMD4HashInst;
extern DELPHI_PACKAGE TIsHashingIntfAvail IsMD4HashIntfAvail;
extern DELPHI_PACKAGE TGetHashInst GetMD5HashInst;
extern DELPHI_PACKAGE TIsHashingIntfAvail IsMD5HashIntfAvail;
extern DELPHI_PACKAGE TGetHashInst GetSHA1HashInst;
extern DELPHI_PACKAGE TIsHashingIntfAvail IsSHA1HashIntfAvail;
extern DELPHI_PACKAGE TGetHashInst GetSHA224HashInst;
extern DELPHI_PACKAGE TIsHashingIntfAvail IsSHA224HashIntfAvail;
extern DELPHI_PACKAGE TGetHashInst GetSHA256HashInst;
extern DELPHI_PACKAGE TIsHashingIntfAvail IsSHA256HashIntfAvail;
extern DELPHI_PACKAGE TGetHashInst GetSHA384HashInst;
extern DELPHI_PACKAGE TIsHashingIntfAvail IsSHA384HashIntfAvail;
extern DELPHI_PACKAGE TGetHashInst GetSHA512HashInst;
extern DELPHI_PACKAGE TIsHashingIntfAvail IsSHA512HashIntfAvail;
extern DELPHI_PACKAGE TUpdateHashInst UpdateHashInst;
extern DELPHI_PACKAGE TFinalHashInst FinalHashInst;
extern DELPHI_PACKAGE TIsHMACAvail IsHMACAvail;
extern DELPHI_PACKAGE TIsHMACIntfAvail IsHMACMD5Avail;
extern DELPHI_PACKAGE TGetHMACInst GetHMACMD5HashInst;
extern DELPHI_PACKAGE TIsHMACIntfAvail IsHMACSHA1Avail;
extern DELPHI_PACKAGE TGetHMACInst GetHMACSHA1HashInst;
extern DELPHI_PACKAGE TIsHMACIntfAvail IsHMACSHA224Avail;
extern DELPHI_PACKAGE TGetHMACInst GetHMACSHA224HashInst;
extern DELPHI_PACKAGE TIsHMACIntfAvail IsHMACSHA256Avail;
extern DELPHI_PACKAGE TGetHMACInst GetHMACSHA256HashInst;
extern DELPHI_PACKAGE TIsHMACIntfAvail IsHMACSHA384Avail;
extern DELPHI_PACKAGE TGetHMACInst GetHMACSHA384HashInst;
extern DELPHI_PACKAGE TIsHMACIntfAvail IsHMACSHA512Avail;
extern DELPHI_PACKAGE TGetHMACInst GetHMACSHA512HashInst;
extern DELPHI_PACKAGE TUpdateHMACInst UpdateHMACInst;
extern DELPHI_PACKAGE TFinalHMACInst FinalHMACInst;
extern DELPHI_PACKAGE void __fastcall CheckMD2Permitted(void);
extern DELPHI_PACKAGE void __fastcall CheckMD4Permitted(void);
extern DELPHI_PACKAGE void __fastcall CheckMD5Permitted(void);
extern DELPHI_PACKAGE void __fastcall FIPSAlgorithmNotAllowed(const System::UnicodeString AAlgorithm);
}	/* namespace Idfips */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDFIPS)
using namespace Idfips;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdfipsHPP
