// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdNTLM.pas' rev: 25.00 (Windows)

#ifndef IdntlmHPP
#define IdntlmHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdStruct.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idntlm
{
//-- type declarations -------------------------------------------------------
#pragma pack(push,1)
struct DECLSPEC_DRECORD type_1_message_header
{
public:
	System::StaticArray<System::Byte, 8> protocol;
	System::Byte _type;
	System::StaticArray<System::Byte, 3> pad;
	System::Word flags;
	System::StaticArray<System::Byte, 2> pad2;
	System::Word dom_len1;
	System::Word dom_len2;
	unsigned dom_off;
	System::Word host_len1;
	System::Word host_len2;
	unsigned host_off;
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD type_2_message_header
{
public:
	System::StaticArray<System::Byte, 8> protocol;
	System::Byte _type;
	System::StaticArray<System::Byte, 3> Pad;
	System::Word host_len1;
	System::Word host_len2;
	unsigned host_off;
	System::Word flags;
	System::StaticArray<System::Byte, 2> Pad2;
	System::StaticArray<System::Byte, 8> nonce;
	System::StaticArray<System::Byte, 8> reserved;
	System::Word info_len1;
	System::Word info_len2;
	unsigned info_off;
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD type_3_message_header
{
public:
	System::StaticArray<System::Byte, 8> protocol;
	unsigned _type;
	System::Word lm_resp_len1;
	System::Word lm_resp_len2;
	unsigned lm_resp_off;
	System::Word nt_resp_len1;
	System::Word nt_resp_len2;
	unsigned nt_resp_off;
	System::Word dom_len1;
	System::Word dom_len2;
	unsigned dom_off;
	System::Word user_len1;
	System::Word user_len2;
	unsigned user_off;
	System::Word host_len1;
	System::Word host_len2;
	unsigned host_off;
	System::Word key_len1;
	System::Word key_len2;
	unsigned key_off;
	unsigned flags;
};
#pragma pack(pop)


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::Word MSG1_FLAGS;
extern DELPHI_PACKAGE unsigned MSG3_FLAGS;
extern DELPHI_PACKAGE void __fastcall GetDomain(const System::UnicodeString AUserName, System::UnicodeString &VUserName, System::UnicodeString &VDomain);
extern DELPHI_PACKAGE bool __fastcall NTLMFunctionsLoaded(void);
extern DELPHI_PACKAGE System::UnicodeString __fastcall BuildType1Message(const System::UnicodeString ADomain, const System::UnicodeString AHost);
extern DELPHI_PACKAGE System::UnicodeString __fastcall BuildType3Message(const System::UnicodeString ADomain, const System::UnicodeString AHost, const System::UnicodeString AUsername, const System::UnicodeString APassword, const Idglobal::TIdBytes ANonce);
}	/* namespace Idntlm */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDNTLM)
using namespace Idntlm;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdntlmHPP
