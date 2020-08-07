// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdHash.pas' rev: 25.00 (Windows)

#ifndef IdhashHPP
#define IdhashHPP

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

//-- user supplied -----------------------------------------------------------

namespace Idhash
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdHash;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdHash : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	virtual Idglobal::TIdBytes __fastcall GetHashBytes(System::Classes::TStream* AStream, __int64 ASize) = 0 ;
	virtual System::UnicodeString __fastcall HashToHex(const Idglobal::TIdBytes AHash) = 0 ;
	System::UnicodeString __fastcall WordHashToHex(const Idglobal::TIdBytes AHash, const int ACount);
	System::UnicodeString __fastcall LongWordHashToHex(const Idglobal::TIdBytes AHash, const int ACount);
	
public:
	__fastcall virtual TIdHash(void);
	__classmethod virtual bool __fastcall IsAvailable();
	Idglobal::TIdBytes __fastcall HashString(const System::UnicodeString ASrc, Idglobal::_di_IIdTextEncoding ADestEncoding = Idglobal::_di_IIdTextEncoding());
	System::UnicodeString __fastcall HashStringAsHex(const System::UnicodeString AStr, Idglobal::_di_IIdTextEncoding ADestEncoding = Idglobal::_di_IIdTextEncoding());
	Idglobal::TIdBytes __fastcall HashBytes(const Idglobal::TIdBytes ASrc);
	System::UnicodeString __fastcall HashBytesAsHex(const Idglobal::TIdBytes ASrc);
	Idglobal::TIdBytes __fastcall HashStream(System::Classes::TStream* AStream)/* overload */;
	System::UnicodeString __fastcall HashStreamAsHex(System::Classes::TStream* AStream)/* overload */;
	Idglobal::TIdBytes __fastcall HashStream(System::Classes::TStream* AStream, const __int64 AStartPos, const __int64 ASize)/* overload */;
	System::UnicodeString __fastcall HashStreamAsHex(System::Classes::TStream* AStream, const __int64 AStartPos, const __int64 ASize)/* overload */;
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdHash(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdHash16;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdHash16 : public TIdHash
{
	typedef TIdHash inherited;
	
protected:
	virtual Idglobal::TIdBytes __fastcall GetHashBytes(System::Classes::TStream* AStream, __int64 ASize);
	virtual System::UnicodeString __fastcall HashToHex(const Idglobal::TIdBytes AHash);
	
public:
	System::Word __fastcall HashValue(const System::UnicodeString ASrc, Idglobal::_di_IIdTextEncoding ADestEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	System::Word __fastcall HashValue(const Idglobal::TIdBytes ASrc)/* overload */;
	System::Word __fastcall HashValue(System::Classes::TStream* AStream)/* overload */;
	System::Word __fastcall HashValue(System::Classes::TStream* AStream, const __int64 AStartPos, const __int64 ASize)/* overload */;
	virtual void __fastcall HashStart(System::Word &VRunningHash) = 0 ;
	virtual void __fastcall HashEnd(System::Word &VRunningHash);
	virtual void __fastcall HashByte(System::Word &VRunningHash, const System::Byte AByte) = 0 ;
public:
	/* TIdHash.Create */ inline __fastcall virtual TIdHash16(void) : TIdHash() { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdHash16(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdHash32;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdHash32 : public TIdHash
{
	typedef TIdHash inherited;
	
protected:
	virtual Idglobal::TIdBytes __fastcall GetHashBytes(System::Classes::TStream* AStream, __int64 ASize);
	virtual System::UnicodeString __fastcall HashToHex(const Idglobal::TIdBytes AHash);
	
public:
	unsigned __fastcall HashValue(const System::UnicodeString ASrc, Idglobal::_di_IIdTextEncoding ADestEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	unsigned __fastcall HashValue(const Idglobal::TIdBytes ASrc)/* overload */;
	unsigned __fastcall HashValue(System::Classes::TStream* AStream)/* overload */;
	unsigned __fastcall HashValue(System::Classes::TStream* AStream, const __int64 AStartPos, const __int64 ASize)/* overload */;
	virtual void __fastcall HashStart(unsigned &VRunningHash) = 0 ;
	virtual void __fastcall HashEnd(unsigned &VRunningHash);
	virtual void __fastcall HashByte(unsigned &VRunningHash, const System::Byte AByte) = 0 ;
public:
	/* TIdHash.Create */ inline __fastcall virtual TIdHash32(void) : TIdHash() { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdHash32(void) { }
	
};

#pragma pack(pop)

typedef System::TMetaClass* TIdHashClass;

class DELPHICLASS TIdHashIntF;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdHashIntF : public TIdHash
{
	typedef TIdHash inherited;
	
protected:
	virtual System::UnicodeString __fastcall HashToHex(const Idglobal::TIdBytes AHash);
	virtual void * __fastcall InitHash(void) = 0 ;
	void __fastcall UpdateHash(void * ACtx, const Idglobal::TIdBytes AIn);
	Idglobal::TIdBytes __fastcall FinalHash(void * ACtx);
	virtual Idglobal::TIdBytes __fastcall GetHashBytes(System::Classes::TStream* AStream, __int64 ASize);
	
public:
	__classmethod virtual bool __fastcall IsAvailable();
	__classmethod virtual bool __fastcall IsIntfAvailable();
public:
	/* TIdHash.Create */ inline __fastcall virtual TIdHashIntF(void) : TIdHash() { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdHashIntF(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdHashNativeAndIntF;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdHashNativeAndIntF : public TIdHashIntF
{
	typedef TIdHashIntF inherited;
	
protected:
	virtual Idglobal::TIdBytes __fastcall NativeGetHashBytes(System::Classes::TStream* AStream, __int64 ASize);
	virtual Idglobal::TIdBytes __fastcall GetHashBytes(System::Classes::TStream* AStream, __int64 ASize);
public:
	/* TIdHash.Create */ inline __fastcall virtual TIdHashNativeAndIntF(void) : TIdHashIntF() { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdHashNativeAndIntF(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idhash */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDHASH)
using namespace Idhash;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdhashHPP
