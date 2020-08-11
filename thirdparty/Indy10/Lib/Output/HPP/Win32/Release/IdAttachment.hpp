// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdAttachment.pas' rev: 25.00 (Windows)

#ifndef IdattachmentHPP
#define IdattachmentHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdMessageParts.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idattachment
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdAttachment;
class PASCALIMPLEMENTATION TIdAttachment : public Idmessageparts::TIdMessagePart
{
	typedef Idmessageparts::TIdMessagePart inherited;
	
public:
	virtual System::Classes::TStream* __fastcall OpenLoadStream(void) = 0 ;
	virtual void __fastcall CloseLoadStream(void) = 0 ;
	virtual System::Classes::TStream* __fastcall PrepareTempStream(void) = 0 ;
	virtual void __fastcall FinishTempStream(void) = 0 ;
	virtual void __fastcall LoadFromFile(const System::UnicodeString FileName);
	virtual void __fastcall LoadFromStream(System::Classes::TStream* AStream);
	virtual void __fastcall SaveToFile(const System::UnicodeString FileName);
	virtual void __fastcall SaveToStream(System::Classes::TStream* AStream);
	__classmethod virtual Idmessageparts::TIdMessagePartType __fastcall PartType();
public:
	/* TIdMessagePart.Create */ inline __fastcall virtual TIdAttachment(System::Classes::TCollection* Collection) : Idmessageparts::TIdMessagePart(Collection) { }
	/* TIdMessagePart.Destroy */ inline __fastcall virtual ~TIdAttachment(void) { }
	
};


typedef System::TMetaClass* TIdAttachmentClass;

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idattachment */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDATTACHMENT)
using namespace Idattachment;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdattachmentHPP
