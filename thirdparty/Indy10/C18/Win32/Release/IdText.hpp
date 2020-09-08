// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdText.pas' rev: 25.00 (Windows)

#ifndef IdtextHPP
#define IdtextHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdMessageParts.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idtext
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdText;
class PASCALIMPLEMENTATION TIdText : public Idmessageparts::TIdMessagePart
{
	typedef Idmessageparts::TIdMessagePart inherited;
	
protected:
	System::Classes::TStrings* FBody;
	virtual void __fastcall SetBody(System::Classes::TStrings* const AStrs);
	
public:
	__fastcall TIdText(Idmessageparts::TIdMessageParts* Collection, System::Classes::TStrings* ABody);
	__fastcall virtual ~TIdText(void);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	bool __fastcall IsBodyEncodingRequired(void);
	__classmethod virtual Idmessageparts::TIdMessagePartType __fastcall PartType();
	__property System::Classes::TStrings* Body = {read=FBody, write=SetBody};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idtext */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDTEXT)
using namespace Idtext;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdtextHPP
