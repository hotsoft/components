// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdHMAC.pas' rev: 25.00 (Windows)

#ifndef IdhmacHPP
#define IdhmacHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdFIPS.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdHash.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idhmac
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdHMACKeyBuilder;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdHMACKeyBuilder : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	__classmethod Idglobal::TIdBytes __fastcall Key(const int ASize);
	__classmethod Idglobal::TIdBytes __fastcall IV(const int ASize);
public:
	/* TObject.Create */ inline __fastcall TIdHMACKeyBuilder(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdHMACKeyBuilder(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdHMAC;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdHMAC : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	int FHashSize;
	int FBlockSize;
	Idglobal::TIdBytes FKey;
	Idhash::TIdHash* FHash;
	System::UnicodeString FHashName;
	virtual void __fastcall InitHash(void) = 0 ;
	void __fastcall InitKey(void);
	virtual void __fastcall SetHashVars(void) = 0 ;
	Idglobal::TIdBytes __fastcall HashValueNative(const Idglobal::TIdBytes ABuffer, const int ATruncateTo = 0xffffffff);
	Idglobal::TIdBytes __fastcall HashValueIntF(const Idglobal::TIdBytes ABuffer, const int ATruncateTo = 0xffffffff);
	virtual bool __fastcall IsIntFAvail(void);
	virtual void * __fastcall InitIntFInst(const Idglobal::TIdBytes AKey) = 0 ;
	
public:
	__fastcall virtual TIdHMAC(void);
	__fastcall virtual ~TIdHMAC(void);
	Idglobal::TIdBytes __fastcall HashValue(const Idglobal::TIdBytes ABuffer, const int ATruncateTo = 0xffffffff);
	__property int HashSize = {read=FHashSize, nodefault};
	__property int BlockSize = {read=FBlockSize, nodefault};
	__property System::UnicodeString HashName = {read=FHashName};
	__property Idglobal::TIdBytes Key = {read=FKey, write=FKey};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idhmac */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDHMAC)
using namespace Idhmac;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdhmacHPP
