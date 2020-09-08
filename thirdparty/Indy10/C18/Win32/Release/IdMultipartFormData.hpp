// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdMultipartFormData.pas' rev: 25.00 (Windows)

#ifndef IdmultipartformdataHPP
#define IdmultipartformdataHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdCharsets.hpp>	// Pascal unit
#include <IdCoderHeader.hpp>	// Pascal unit
#include <IdResourceStringsProtocols.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idmultipartformdata
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdFormDataField;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFormDataField : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
protected:
	System::UnicodeString FFileName;
	System::UnicodeString FCharset;
	System::UnicodeString FContentType;
	System::UnicodeString FContentTransfer;
	System::UnicodeString FFieldName;
	System::Classes::TStream* FFieldStream;
	System::UnicodeString FFieldValue;
	bool FCanFreeFieldStream;
	System::UnicodeString FHeaderCharSet;
	System::WideChar FHeaderEncoding;
	System::UnicodeString __fastcall FormatHeader(void);
	System::Classes::TStream* __fastcall PrepareDataStream(bool &VCanFree);
	__int64 __fastcall GetFieldSize(void);
	System::Classes::TStream* __fastcall GetFieldStream(void);
	System::UnicodeString __fastcall GetFieldValue(void);
	void __fastcall SetCharset(const System::UnicodeString Value);
	void __fastcall SetContentType(const System::UnicodeString Value);
	void __fastcall SetContentTransfer(const System::UnicodeString Value);
	void __fastcall SetFieldName(const System::UnicodeString Value);
	void __fastcall SetFieldStream(System::Classes::TStream* const Value);
	void __fastcall SetFieldValue(const System::UnicodeString Value);
	void __fastcall SetFileName(const System::UnicodeString Value);
	void __fastcall SetHeaderCharSet(const System::UnicodeString Value);
	void __fastcall SetHeaderEncoding(const System::WideChar Value);
	
public:
	__fastcall virtual TIdFormDataField(System::Classes::TCollection* Collection);
	__fastcall virtual ~TIdFormDataField(void);
	__property System::UnicodeString ContentTransfer = {read=FContentTransfer, write=SetContentTransfer};
	__property System::UnicodeString ContentType = {read=FContentType, write=SetContentType};
	__property System::UnicodeString Charset = {read=FCharset, write=SetCharset};
	__property System::UnicodeString FieldName = {read=FFieldName, write=SetFieldName};
	__property System::Classes::TStream* FieldStream = {read=GetFieldStream, write=SetFieldStream};
	__property System::UnicodeString FileName = {read=FFileName, write=SetFileName};
	__property System::UnicodeString FieldValue = {read=GetFieldValue, write=SetFieldValue};
	__property __int64 FieldSize = {read=GetFieldSize};
	__property System::UnicodeString HeaderCharSet = {read=FHeaderCharSet, write=SetHeaderCharSet};
	__property System::WideChar HeaderEncoding = {read=FHeaderEncoding, write=SetHeaderEncoding, nodefault};
};

#pragma pack(pop)

class DELPHICLASS TIdFormDataFields;
class DELPHICLASS TIdMultiPartFormDataStream;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFormDataFields : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
protected:
	TIdMultiPartFormDataStream* FParentStream;
	TIdFormDataField* __fastcall GetFormDataField(int AIndex);
	
public:
	__fastcall TIdFormDataFields(TIdMultiPartFormDataStream* AMPStream);
	HIDESBASE TIdFormDataField* __fastcall Add(void);
	__property TIdMultiPartFormDataStream* MultipartFormDataStream = {read=FParentStream};
	__property TIdFormDataField* Items[int AIndex] = {read=GetFormDataField};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TIdFormDataFields(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TIdMultiPartFormDataStream : public Idglobal::TIdBaseStream
{
	typedef Idglobal::TIdBaseStream inherited;
	
protected:
	System::Classes::TStream* FInputStream;
	bool FFreeInputStream;
	System::UnicodeString FBoundary;
	System::UnicodeString FRequestContentType;
	int FCurrentItem;
	bool FInitialized;
	Idglobal::TIdBytes FInternalBuffer;
	__int64 FPosition;
	__int64 FSize;
	TIdFormDataFields* FFields;
	System::UnicodeString __fastcall GenerateUniqueBoundary(void);
	void __fastcall CalculateSize(void);
	virtual int __fastcall IdRead(Idglobal::TIdBytes &VBuffer, int AOffset, int ACount);
	virtual int __fastcall IdWrite(const Idglobal::TIdBytes ABuffer, int AOffset, int ACount);
	virtual __int64 __fastcall IdSeek(const __int64 AOffset, System::Classes::TSeekOrigin AOrigin);
	virtual void __fastcall IdSetSize(__int64 ASize);
	
public:
	__fastcall TIdMultiPartFormDataStream(void);
	__fastcall virtual ~TIdMultiPartFormDataStream(void);
	TIdFormDataField* __fastcall AddFormField(const System::UnicodeString AFieldName, const System::UnicodeString AFieldValue, const System::UnicodeString ACharset = System::UnicodeString(), const System::UnicodeString AContentType = System::UnicodeString(), const System::UnicodeString AFileName = System::UnicodeString())/* overload */;
	TIdFormDataField* __fastcall AddFormField(const System::UnicodeString AFieldName, const System::UnicodeString AContentType, const System::UnicodeString ACharset, System::Classes::TStream* AFieldValue, const System::UnicodeString AFileName = System::UnicodeString())/* overload */;
	TIdFormDataField* __fastcall AddObject _DEPRECATED_ATTRIBUTE1("Use overloaded version of AddFormField()") (const System::UnicodeString AFieldName, const System::UnicodeString AContentType, const System::UnicodeString ACharset, System::TObject* AFileData, const System::UnicodeString AFileName = System::UnicodeString());
	TIdFormDataField* __fastcall AddFile(const System::UnicodeString AFieldName, const System::UnicodeString AFileName, const System::UnicodeString AContentType = System::UnicodeString());
	void __fastcall Clear(void);
	__property System::UnicodeString Boundary = {read=FBoundary};
	__property System::UnicodeString RequestContentType = {read=FRequestContentType};
};


class DELPHICLASS EIdInvalidObjectType;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdInvalidObjectType : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdInvalidObjectType(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdInvalidObjectType(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdInvalidObjectType(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdInvalidObjectType(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdInvalidObjectType(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdInvalidObjectType(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdInvalidObjectType(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdInvalidObjectType(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdInvalidObjectType(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdInvalidObjectType(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdInvalidObjectType(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdInvalidObjectType(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdInvalidObjectType(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdUnsupportedOperation;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdUnsupportedOperation : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdUnsupportedOperation(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdUnsupportedOperation(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdUnsupportedOperation(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdUnsupportedOperation(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdUnsupportedOperation(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdUnsupportedOperation(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdUnsupportedOperation(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdUnsupportedOperation(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdUnsupportedOperation(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdUnsupportedOperation(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdUnsupportedOperation(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdUnsupportedOperation(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdUnsupportedOperation(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdUnsupportedTransfer;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdUnsupportedTransfer : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdUnsupportedTransfer(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdUnsupportedTransfer(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdUnsupportedTransfer(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdUnsupportedTransfer(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdUnsupportedTransfer(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdUnsupportedTransfer(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdUnsupportedTransfer(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdUnsupportedTransfer(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdUnsupportedTransfer(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdUnsupportedTransfer(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdUnsupportedTransfer(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdUnsupportedTransfer(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdUnsupportedTransfer(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdUnsupportedEncoding;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdUnsupportedEncoding : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdUnsupportedEncoding(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdUnsupportedEncoding(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdUnsupportedEncoding(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdUnsupportedEncoding(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdUnsupportedEncoding(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdUnsupportedEncoding(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdUnsupportedEncoding(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdUnsupportedEncoding(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdUnsupportedEncoding(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdUnsupportedEncoding(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdUnsupportedEncoding(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdUnsupportedEncoding(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdUnsupportedEncoding(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
#define sContentTypeFormData L"multipart/form-data; boundary="
#define sContentTypeOctetStream L"application/octet-stream"
#define sContentTypeTextPlain L"text/plain"
#define CRLF L"\r\n"
#define sContentDispositionPlaceHolder L"Content-Disposition: form-data; name=\"%s\""
#define sFileNamePlaceHolder L"; filename=\"%s\""
#define sContentTypePlaceHolder L"Content-Type: %s"
#define sCharsetPlaceHolder L"; charset=\"%s\""
#define sContentTransferPlaceHolder L"Content-Transfer-Encoding: %s"
#define sContentTransferQuotedPrintable L"quoted-printable"
#define sContentTransferBinary L"binary"
}	/* namespace Idmultipartformdata */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDMULTIPARTFORMDATA)
using namespace Idmultipartformdata;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdmultipartformdataHPP
