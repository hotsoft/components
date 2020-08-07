// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdAttachmentMemory.pas' rev: 25.00 (Windows)

#ifndef IdattachmentmemoryHPP
#define IdattachmentmemoryHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdAttachment.hpp>	// Pascal unit
#include <IdMessageParts.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idattachmentmemory
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdAttachmentMemory;
class PASCALIMPLEMENTATION TIdAttachmentMemory : public Idattachment::TIdAttachment
{
	typedef Idattachment::TIdAttachment inherited;
	
protected:
	System::Classes::TStream* FDataStream;
	__int64 FDataStreamBeforeLoadPosition;
	System::UnicodeString __fastcall GetDataString(void);
	void __fastcall SetDataStream(System::Classes::TStream* const Value);
	void __fastcall SetDataString(const System::UnicodeString Value);
	
public:
	__fastcall virtual TIdAttachmentMemory(System::Classes::TCollection* Collection)/* overload */;
	__fastcall TIdAttachmentMemory(Idmessageparts::TIdMessageParts* Collection, System::Classes::TStream* const CopyFrom)/* overload */;
	__fastcall TIdAttachmentMemory(Idmessageparts::TIdMessageParts* Collection, const System::UnicodeString CopyFrom)/* overload */;
	__fastcall virtual ~TIdAttachmentMemory(void);
	__property System::Classes::TStream* DataStream = {read=FDataStream, write=SetDataStream};
	__property System::UnicodeString DataString = {read=GetDataString, write=SetDataString};
	virtual System::Classes::TStream* __fastcall OpenLoadStream(void);
	virtual void __fastcall CloseLoadStream(void);
	virtual void __fastcall FinishTempStream(void);
	virtual System::Classes::TStream* __fastcall PrepareTempStream(void);
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idattachmentmemory */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDATTACHMENTMEMORY)
using namespace Idattachmentmemory;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdattachmentmemoryHPP
