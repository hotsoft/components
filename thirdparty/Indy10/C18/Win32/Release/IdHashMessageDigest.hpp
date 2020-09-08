// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdHashMessageDigest.pas' rev: 25.00 (Windows)

#ifndef IdhashmessagedigestHPP
#define IdhashmessagedigestHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdFIPS.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdHash.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idhashmessagedigest
{
//-- type declarations -------------------------------------------------------
typedef System::StaticArray<unsigned, 4> T4x4LongWordRecord;

typedef System::StaticArray<unsigned, 16> T16x4LongWordRecord;

typedef System::StaticArray<System::StaticArray<unsigned, 4>, 4> T4x4x4LongWordRecord;

typedef System::StaticArray<System::Byte, 64> T512BitRecord;

typedef System::StaticArray<System::Byte, 48> T384BitRecord;

typedef System::StaticArray<System::Byte, 16> T128BitRecord;

class DELPHICLASS TIdHashMessageDigest;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdHashMessageDigest : public Idhash::TIdHashNativeAndIntF
{
	typedef Idhash::TIdHashNativeAndIntF inherited;
	
protected:
	Idglobal::TIdBytes FCBuffer;
	virtual void __fastcall MDCoder(void) = 0 ;
	virtual void __fastcall Reset(void);
public:
	/* TIdHash.Create */ inline __fastcall virtual TIdHashMessageDigest(void) : Idhash::TIdHashNativeAndIntF() { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdHashMessageDigest(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdHashMessageDigest2;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdHashMessageDigest2 : public TIdHashMessageDigest
{
	typedef TIdHashMessageDigest inherited;
	
protected:
	T384BitRecord FX;
	T128BitRecord FCheckSum;
	virtual void __fastcall MDCoder(void);
	virtual void __fastcall Reset(void);
	virtual void * __fastcall InitHash(void);
	virtual Idglobal::TIdBytes __fastcall NativeGetHashBytes(System::Classes::TStream* AStream, __int64 ASize);
	virtual System::UnicodeString __fastcall HashToHex(const Idglobal::TIdBytes AHash);
	
public:
	__fastcall virtual TIdHashMessageDigest2(void);
	__classmethod virtual bool __fastcall IsIntfAvailable();
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdHashMessageDigest2(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdHashMessageDigest4;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdHashMessageDigest4 : public TIdHashMessageDigest
{
	typedef TIdHashMessageDigest inherited;
	
protected:
	T4x4LongWordRecord FState;
	virtual Idglobal::TIdBytes __fastcall NativeGetHashBytes(System::Classes::TStream* AStream, __int64 ASize);
	virtual System::UnicodeString __fastcall HashToHex(const Idglobal::TIdBytes AHash);
	virtual void __fastcall MDCoder(void);
	virtual void * __fastcall InitHash(void);
	
public:
	__fastcall virtual TIdHashMessageDigest4(void);
	__classmethod virtual bool __fastcall IsIntfAvailable();
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdHashMessageDigest4(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdHashMessageDigest5;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdHashMessageDigest5 : public TIdHashMessageDigest4
{
	typedef TIdHashMessageDigest4 inherited;
	
protected:
	virtual void __fastcall MDCoder(void);
	virtual void * __fastcall InitHash(void);
	
public:
	__classmethod virtual bool __fastcall IsIntfAvailable();
public:
	/* TIdHashMessageDigest4.Create */ inline __fastcall virtual TIdHashMessageDigest5(void) : TIdHashMessageDigest4() { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdHashMessageDigest5(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idhashmessagedigest */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDHASHMESSAGEDIGEST)
using namespace Idhashmessagedigest;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdhashmessagedigestHPP
