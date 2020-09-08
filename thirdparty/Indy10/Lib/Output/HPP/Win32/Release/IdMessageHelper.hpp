// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdMessageHelper.pas' rev: 25.00 (Windows)

#ifndef IdmessagehelperHPP
#define IdmessagehelperHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdMessage.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idmessagehelper
{
//-- type declarations -------------------------------------------------------
typedef void *TIdMessageHelper;

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall TIdMessageHelper_LoadFromStream _DEPRECATED_ATTRIBUTE1("Use TIdMessageHelper.LoadFromStream()") (Idmessage::TIdMessage* AMsg, System::Classes::TStream* AStream, const bool AHeadersOnly, const bool AUsesDotTransparency);
extern DELPHI_PACKAGE void __fastcall TIdMessageHelper_LoadFromFile _DEPRECATED_ATTRIBUTE1("Use TIdMessageHelper.LoadFromFile()") (Idmessage::TIdMessage* AMsg, const System::UnicodeString AFileName, const bool AHeadersOnly, const bool AUsesDotTransparency);
extern DELPHI_PACKAGE void __fastcall TIdMessageHelper_SaveToStream _DEPRECATED_ATTRIBUTE1("Use TIdMessageHelper.SaveToStream()") (Idmessage::TIdMessage* AMsg, System::Classes::TStream* AStream, const bool AHeadersOnly, const bool AUseDotTransparency);
extern DELPHI_PACKAGE void __fastcall TIdMessageHelper_SaveToFile _DEPRECATED_ATTRIBUTE1("Use TIdMessageHelper.SaveToFile()") (Idmessage::TIdMessage* AMsg, const System::UnicodeString AFileName, const bool AHeadersOnly, const bool AUseDotTransparency);
}	/* namespace Idmessagehelper */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDMESSAGEHELPER)
using namespace Idmessagehelper;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdmessagehelperHPP
