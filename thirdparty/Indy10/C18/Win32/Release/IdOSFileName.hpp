// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdOSFileName.pas' rev: 25.00 (Windows)

#ifndef IdosfilenameHPP
#define IdosfilenameHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <IdFTPCommon.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idosfilename
{
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::UnicodeString __fastcall FileNameUnixToVMS(const System::UnicodeString AUnixFileName);
extern DELPHI_PACKAGE System::UnicodeString __fastcall FileNameVMSToUnix(const System::UnicodeString AVMSFileName);
extern DELPHI_PACKAGE System::UnicodeString __fastcall FileNameMSDOSToUnix(const System::UnicodeString AMSDOSFileName);
extern DELPHI_PACKAGE System::UnicodeString __fastcall FileNameUnixToMSDOS(const System::UnicodeString AUnixFileName);
extern DELPHI_PACKAGE System::UnicodeString __fastcall FileNameUnixToWin32(const System::UnicodeString AUnixFileName);
extern DELPHI_PACKAGE System::UnicodeString __fastcall FileNameWin32ToUnix(const System::UnicodeString AWin32FileName);
extern DELPHI_PACKAGE System::UnicodeString __fastcall FileNameUnixToVMCMS(const System::UnicodeString AUnixFileName);
extern DELPHI_PACKAGE System::UnicodeString __fastcall FileNameVMCMSToUnix(const System::UnicodeString AVMCMSFileName);
extern DELPHI_PACKAGE System::UnicodeString __fastcall FileNameUnixToMUSICSP(const System::UnicodeString AUnixFileName);
extern DELPHI_PACKAGE System::UnicodeString __fastcall FileNameMUSICSPToUnix(const System::UnicodeString AMUSICSPFileName);
extern DELPHI_PACKAGE System::UnicodeString __fastcall FileNameUnixToMVS(const System::UnicodeString AUnixFileName, const System::UnicodeString AUserID, const bool AUseAnotherID = false);
extern DELPHI_PACKAGE System::UnicodeString __fastcall FileNameMVSToUnix(const System::UnicodeString AMVSFileName);
extern DELPHI_PACKAGE System::UnicodeString __fastcall FileNameUnixToMPEiXTraditional(const System::UnicodeString AUnixFileName, const System::UnicodeString AGroupName = System::UnicodeString(), const System::UnicodeString AAcountName = System::UnicodeString());
extern DELPHI_PACKAGE System::UnicodeString __fastcall FileNameUnixToMPEiXHFS(const System::UnicodeString AUnixFileName, const bool IsRoot = false);
extern DELPHI_PACKAGE System::UnicodeString __fastcall FileNameUnixToOS9(const System::UnicodeString AUnixFileName);
}	/* namespace Idosfilename */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDOSFILENAME)
using namespace Idosfilename;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdosfilenameHPP
