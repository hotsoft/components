// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdHMACMD5.pas' rev: 25.00 (Windows)

#ifndef Idhmacmd5HPP
#define Idhmacmd5HPP

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
#include <IdHashMessageDigest.hpp>	// Pascal unit
#include <IdHMAC.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idhmacmd5
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdHMACMD5;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdHMACMD5 : public Idhmac::TIdHMAC
{
	typedef Idhmac::TIdHMAC inherited;
	
protected:
	virtual void __fastcall SetHashVars(void);
	virtual bool __fastcall IsIntFAvail(void);
	virtual void * __fastcall InitIntFInst(const Idglobal::TIdBytes AKey);
	virtual void __fastcall InitHash(void);
public:
	/* TIdHMAC.Create */ inline __fastcall virtual TIdHMACMD5(void) : Idhmac::TIdHMAC() { }
	/* TIdHMAC.Destroy */ inline __fastcall virtual ~TIdHMACMD5(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idhmacmd5 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDHMACMD5)
using namespace Idhmacmd5;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Idhmacmd5HPP
