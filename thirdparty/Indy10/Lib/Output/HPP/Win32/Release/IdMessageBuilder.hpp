// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdMessageBuilder.pas' rev: 25.00 (Windows)

#ifndef IdmessagebuilderHPP
#define IdmessagebuilderHPP

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

namespace Idmessagebuilder
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdMessageBuilderAttachment;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdMessageBuilderAttachment : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
private:
	System::UnicodeString FContentID;
	System::UnicodeString FContentTransfer;
	System::UnicodeString FContentType;
	System::Classes::TStream* FData;
	System::UnicodeString FFileName;
	System::UnicodeString FName;
	System::UnicodeString FWantedFileName;
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__property System::UnicodeString ContentID = {read=FContentID, write=FContentID};
	__property System::UnicodeString ContentTransfer = {read=FContentTransfer};
	__property System::UnicodeString ContentType = {read=FContentType, write=FContentType};
	__property System::Classes::TStream* Data = {read=FData, write=FData};
	__property System::UnicodeString FileName = {read=FFileName, write=FFileName};
	__property System::UnicodeString Name = {read=FName, write=FName};
	__property System::UnicodeString WantedFileName = {read=FWantedFileName, write=FWantedFileName};
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TIdMessageBuilderAttachment(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdMessageBuilderAttachment(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdMessageBuilderAttachments;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdMessageBuilderAttachments : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TIdMessageBuilderAttachment* operator[](int Index) { return Attachment[Index]; }
	
private:
	TIdMessageBuilderAttachment* __fastcall GetAttachment(int Index);
	void __fastcall SetAttachment(int Index, TIdMessageBuilderAttachment* Value);
	
public:
	__fastcall TIdMessageBuilderAttachments(void);
	HIDESBASE TIdMessageBuilderAttachment* __fastcall Add(void)/* overload */;
	HIDESBASE TIdMessageBuilderAttachment* __fastcall Add(const System::UnicodeString AFileName, const System::UnicodeString AContentID = System::UnicodeString())/* overload */;
	HIDESBASE TIdMessageBuilderAttachment* __fastcall Add(System::Classes::TStream* AData, const System::UnicodeString AContentType, const System::UnicodeString AContentID = System::UnicodeString())/* overload */;
	void __fastcall AddToMessage(Idmessage::TIdMessage* AMsg, int ParentPart);
	__property TIdMessageBuilderAttachment* Attachment[int Index] = {read=GetAttachment, write=SetAttachment/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TIdMessageBuilderAttachments(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdCustomMessageBuilder;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdCustomMessageBuilder : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	TIdMessageBuilderAttachments* FAttachments;
	System::Classes::TStrings* FPlainText;
	System::UnicodeString FPlainTextCharSet;
	System::UnicodeString FPlainTextContentTransfer;
	void __fastcall AddAttachments(Idmessage::TIdMessage* AMsg);
	virtual void __fastcall FillBody(Idmessage::TIdMessage* AMsg) = 0 ;
	virtual void __fastcall FillHeaders(Idmessage::TIdMessage* AMsg);
	void __fastcall SetPlainText(System::Classes::TStrings* AValue);
	void __fastcall SetAttachments(TIdMessageBuilderAttachments* AValue);
	
public:
	__fastcall virtual TIdCustomMessageBuilder(void);
	__fastcall virtual ~TIdCustomMessageBuilder(void);
	virtual void __fastcall Clear(void);
	void __fastcall FillMessage(Idmessage::TIdMessage* AMsg);
	Idmessage::TIdMessage* __fastcall NewMessage(System::Classes::TComponent* AOwner = (System::Classes::TComponent*)(0x0));
	__property TIdMessageBuilderAttachments* Attachments = {read=FAttachments, write=SetAttachments};
	__property System::Classes::TStrings* PlainText = {read=FPlainText, write=SetPlainText};
	__property System::UnicodeString PlainTextCharSet = {read=FPlainTextCharSet, write=FPlainTextCharSet};
	__property System::UnicodeString PlainTextContentTransfer = {read=FPlainTextContentTransfer, write=FPlainTextContentTransfer};
};

#pragma pack(pop)

class DELPHICLASS TIdMessageBuilderPlain;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdMessageBuilderPlain : public TIdCustomMessageBuilder
{
	typedef TIdCustomMessageBuilder inherited;
	
protected:
	virtual void __fastcall FillBody(Idmessage::TIdMessage* AMsg);
	virtual void __fastcall FillHeaders(Idmessage::TIdMessage* AMsg);
public:
	/* TIdCustomMessageBuilder.Create */ inline __fastcall virtual TIdMessageBuilderPlain(void) : TIdCustomMessageBuilder() { }
	/* TIdCustomMessageBuilder.Destroy */ inline __fastcall virtual ~TIdMessageBuilderPlain(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdMessageBuilderHtml;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdMessageBuilderHtml : public TIdCustomMessageBuilder
{
	typedef TIdCustomMessageBuilder inherited;
	
protected:
	System::Classes::TStrings* FHtml;
	System::UnicodeString FHtmlCharSet;
	System::UnicodeString FHtmlContentTransfer;
	TIdMessageBuilderAttachments* FHtmlFiles;
	System::UnicodeString FHtmlViewerNeededMsg;
	virtual void __fastcall FillBody(Idmessage::TIdMessage* AMsg);
	virtual void __fastcall FillHeaders(Idmessage::TIdMessage* AMsg);
	void __fastcall SetHtml(System::Classes::TStrings* AValue);
	void __fastcall SetHtmlFiles(TIdMessageBuilderAttachments* AValue);
	
public:
	__fastcall virtual TIdMessageBuilderHtml(void);
	__fastcall virtual ~TIdMessageBuilderHtml(void);
	virtual void __fastcall Clear(void);
	__property System::Classes::TStrings* Html = {read=FHtml, write=SetHtml};
	__property System::UnicodeString HtmlCharSet = {read=FHtmlCharSet, write=FHtmlCharSet};
	__property System::UnicodeString HtmlContentTransfer = {read=FHtmlContentTransfer, write=FHtmlContentTransfer};
	__property TIdMessageBuilderAttachments* HtmlFiles = {read=FHtmlFiles, write=SetHtmlFiles};
	__property System::UnicodeString HtmlViewerNeededMsg = {read=FHtmlViewerNeededMsg, write=FHtmlViewerNeededMsg};
};

#pragma pack(pop)

enum DECLSPEC_DENUM TIdMessageBuilderRtfType : unsigned char { idMsgBldrRtfMS, idMsgBldrRtfEnriched, idMsgBldrRtfRichtext };

class DELPHICLASS TIdMessageBuilderRtf;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdMessageBuilderRtf : public TIdCustomMessageBuilder
{
	typedef TIdCustomMessageBuilder inherited;
	
protected:
	System::Classes::TStrings* FRtf;
	TIdMessageBuilderRtfType FRtfType;
	System::UnicodeString FRtfViewerNeededMsg;
	virtual void __fastcall FillBody(Idmessage::TIdMessage* AMsg);
	virtual void __fastcall FillHeaders(Idmessage::TIdMessage* AMsg);
	void __fastcall SetRtf(System::Classes::TStrings* AValue);
	
public:
	__fastcall virtual TIdMessageBuilderRtf(void);
	__fastcall virtual ~TIdMessageBuilderRtf(void);
	virtual void __fastcall Clear(void);
	__property System::Classes::TStrings* Rtf = {read=FRtf, write=SetRtf};
	__property TIdMessageBuilderRtfType RtfType = {read=FRtfType, write=FRtfType, nodefault};
	__property System::UnicodeString RtfViewerNeededMsg = {read=FRtfViewerNeededMsg, write=FRtfViewerNeededMsg};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idmessagebuilder */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDMESSAGEBUILDER)
using namespace Idmessagebuilder;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdmessagebuilderHPP
