// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdCoderHeader.pas' rev: 25.00 (Windows)

#ifndef IdcoderheaderHPP
#define IdcoderheaderHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdEMailAddress.hpp>	// Pascal unit
#include <IdHeaderCoderBase.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idcoderheader
{
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::UnicodeString __fastcall EncodeAddressItem(Idemailaddress::TIdEMailAddressItem* EmailAddr, const System::WideChar HeaderEncoding, const System::UnicodeString MimeCharSet, bool AUseAddressForNameIfNameMissing = false);
extern DELPHI_PACKAGE System::UnicodeString __fastcall DecodeHeader(const System::UnicodeString Header);
extern DELPHI_PACKAGE void __fastcall DecodeAddress(Idemailaddress::TIdEMailAddressItem* EMailAddr);
extern DELPHI_PACKAGE void __fastcall DecodeAddresses(System::UnicodeString AEMails, Idemailaddress::TIdEMailAddressList* EMailAddr);
extern DELPHI_PACKAGE System::UnicodeString __fastcall EncodeAddress(Idemailaddress::TIdEMailAddressList* EmailAddr, const System::WideChar HeaderEncoding, const System::UnicodeString MimeCharSet, bool AUseAddressForNameIfNameMissing = false);
extern DELPHI_PACKAGE System::UnicodeString __fastcall EncodeHeader(const System::UnicodeString Header, System::UnicodeString Specials, const System::WideChar HeaderEncoding, const System::UnicodeString MimeCharSet);
}	/* namespace Idcoderheader */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDCODERHEADER)
using namespace Idcoderheader;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdcoderheaderHPP
