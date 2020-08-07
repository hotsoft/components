// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdHashSHA.pas' rev: 25.00 (Windows)

#ifndef IdhashshaHPP
#define IdhashshaHPP

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

namespace Idhashsha
{
//-- type declarations -------------------------------------------------------
typedef System::StaticArray<unsigned, 5> T5x4LongWordRecord;

typedef System::StaticArray<System::Byte, 64> T512BitRecord;

class DELPHICLASS TIdHashSHA1;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdHashSHA1 : public Idhash::TIdHashNativeAndIntF
{
	typedef Idhash::TIdHashNativeAndIntF inherited;
	
protected:
	T5x4LongWordRecord FCheckSum;
	Idglobal::TIdBytes FCBuffer;
	void __fastcall Coder(void);
	virtual Idglobal::TIdBytes __fastcall NativeGetHashBytes(System::Classes::TStream* AStream, __int64 ASize);
	virtual System::UnicodeString __fastcall HashToHex(const Idglobal::TIdBytes AHash);
	virtual void * __fastcall InitHash(void);
	
public:
	__fastcall virtual TIdHashSHA1(void);
	__classmethod virtual bool __fastcall IsAvailable();
	__classmethod virtual bool __fastcall IsIntfAvailable();
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdHashSHA1(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdHashSHA224;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdHashSHA224 : public Idhash::TIdHashIntF
{
	typedef Idhash::TIdHashIntF inherited;
	
protected:
	virtual void * __fastcall InitHash(void);
	
public:
	__classmethod virtual bool __fastcall IsAvailable();
public:
	/* TIdHash.Create */ inline __fastcall virtual TIdHashSHA224(void) : Idhash::TIdHashIntF() { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdHashSHA224(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdHashSHA256;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdHashSHA256 : public Idhash::TIdHashIntF
{
	typedef Idhash::TIdHashIntF inherited;
	
protected:
	virtual void * __fastcall InitHash(void);
	
public:
	__classmethod virtual bool __fastcall IsAvailable();
public:
	/* TIdHash.Create */ inline __fastcall virtual TIdHashSHA256(void) : Idhash::TIdHashIntF() { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdHashSHA256(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdHashSHA384;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdHashSHA384 : public Idhash::TIdHashIntF
{
	typedef Idhash::TIdHashIntF inherited;
	
protected:
	virtual void * __fastcall InitHash(void);
	
public:
	__classmethod virtual bool __fastcall IsAvailable();
public:
	/* TIdHash.Create */ inline __fastcall virtual TIdHashSHA384(void) : Idhash::TIdHashIntF() { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdHashSHA384(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdHashSHA512;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdHashSHA512 : public Idhash::TIdHashIntF
{
	typedef Idhash::TIdHashIntF inherited;
	
protected:
	virtual void * __fastcall InitHash(void);
	
public:
	__classmethod virtual bool __fastcall IsAvailable();
public:
	/* TIdHash.Create */ inline __fastcall virtual TIdHashSHA512(void) : Idhash::TIdHashIntF() { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdHashSHA512(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idhashsha */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDHASHSHA)
using namespace Idhashsha;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdhashshaHPP
