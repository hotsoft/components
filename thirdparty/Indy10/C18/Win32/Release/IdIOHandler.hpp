// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdIOHandler.pas' rev: 25.00 (Windows)

#ifndef IdiohandlerHPP
#define IdiohandlerHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdAntiFreezeBase.hpp>	// Pascal unit
#include <IdBuffer.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdExceptionCore.hpp>	// Pascal unit
#include <IdIntercept.hpp>	// Pascal unit
#include <IdResourceStringsCore.hpp>	// Pascal unit
#include <IdStream.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------
#if defined(_VCL_ALIAS_RECORDS)
#if !defined(UNICODE)
#pragma alias "@Idiohandler@TIdIOHandler@SetPortA$qqri"="@Idiohandler@TIdIOHandler@SetPort$qqri"
#else
#pragma alias "@Idiohandler@TIdIOHandler@SetPortW$qqri"="@Idiohandler@TIdIOHandler@SetPort$qqri"
#endif
#endif

namespace Idiohandler
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS EIdIOHandler;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdIOHandler : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdIOHandler(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdIOHandler(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdIOHandler(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdIOHandler(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIOHandler(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIOHandler(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdIOHandler(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdIOHandler(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIOHandler(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIOHandler(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIOHandler(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIOHandler(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdIOHandler(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdIOHandlerRequiresLargeStream;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdIOHandlerRequiresLargeStream : public EIdIOHandler
{
	typedef EIdIOHandler inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdIOHandlerRequiresLargeStream(const System::UnicodeString AMsg)/* overload */ : EIdIOHandler(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdIOHandlerRequiresLargeStream(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdIOHandler(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdIOHandlerRequiresLargeStream(NativeUInt Ident)/* overload */ : EIdIOHandler(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdIOHandlerRequiresLargeStream(System::PResStringRec ResStringRec)/* overload */ : EIdIOHandler(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIOHandlerRequiresLargeStream(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdIOHandler(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIOHandlerRequiresLargeStream(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdIOHandler(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdIOHandlerRequiresLargeStream(const System::UnicodeString Msg, int AHelpContext) : EIdIOHandler(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdIOHandlerRequiresLargeStream(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdIOHandler(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIOHandlerRequiresLargeStream(NativeUInt Ident, int AHelpContext)/* overload */ : EIdIOHandler(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIOHandlerRequiresLargeStream(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdIOHandler(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIOHandlerRequiresLargeStream(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdIOHandler(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIOHandlerRequiresLargeStream(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdIOHandler(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdIOHandlerRequiresLargeStream(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdIOHandlerStreamDataTooLarge;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdIOHandlerStreamDataTooLarge : public EIdIOHandler
{
	typedef EIdIOHandler inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdIOHandlerStreamDataTooLarge(const System::UnicodeString AMsg)/* overload */ : EIdIOHandler(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdIOHandlerStreamDataTooLarge(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdIOHandler(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdIOHandlerStreamDataTooLarge(NativeUInt Ident)/* overload */ : EIdIOHandler(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdIOHandlerStreamDataTooLarge(System::PResStringRec ResStringRec)/* overload */ : EIdIOHandler(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIOHandlerStreamDataTooLarge(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdIOHandler(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIOHandlerStreamDataTooLarge(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdIOHandler(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdIOHandlerStreamDataTooLarge(const System::UnicodeString Msg, int AHelpContext) : EIdIOHandler(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdIOHandlerStreamDataTooLarge(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdIOHandler(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIOHandlerStreamDataTooLarge(NativeUInt Ident, int AHelpContext)/* overload */ : EIdIOHandler(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIOHandlerStreamDataTooLarge(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdIOHandler(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIOHandlerStreamDataTooLarge(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdIOHandler(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIOHandlerStreamDataTooLarge(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdIOHandler(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdIOHandlerStreamDataTooLarge(void) { }
	
};

#pragma pack(pop)

typedef System::TMetaClass* TIdIOHandlerClass;

class DELPHICLASS TIdIOHandler;
class PASCALIMPLEMENTATION TIdIOHandler : public Idcomponent::TIdComponent
{
	typedef Idcomponent::TIdComponent inherited;
	
private:
	bool FLargeStream;
	
protected:
	bool FClosedGracefully;
	int FConnectTimeout;
	System::UnicodeString FDestination;
	System::UnicodeString FHost;
	Idbuffer::TIdBuffer* FInputBuffer;
	Idintercept::TIdConnectionIntercept* FIntercept;
	int FMaxCapturedLines;
	Idglobal::TIdMaxLineAction FMaxLineAction;
	int FMaxLineLength;
	bool FOpened;
	int FPort;
	bool FReadLnSplit;
	bool FReadLnTimedOut;
	int FReadTimeOut;
	int FRecvBufferSize;
	int FSendBufferSize;
	Idbuffer::TIdBuffer* FWriteBuffer;
	int FWriteBufferThreshold;
	Idglobal::_di_IIdTextEncoding FDefStringEncoding;
	void __fastcall SetDefStringEncoding(const Idglobal::_di_IIdTextEncoding AEncoding);
	void __fastcall BufferRemoveNotify(System::TObject* ASender, int ABytes);
	virtual System::UnicodeString __fastcall GetDestination(void);
	virtual void __fastcall InitComponent(void);
	void __fastcall InterceptReceive(Idglobal::TIdBytes &VBuffer);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall PerformCapture(System::TObject* const ADest, /* out */ int &VLineCount, const System::UnicodeString ADelim, bool AUsesDotTransparency, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding());
	void __fastcall RaiseConnClosedGracefully(void);
	virtual void __fastcall SetDestination(const System::UnicodeString AValue);
	virtual void __fastcall SetHost(const System::UnicodeString AValue);
	virtual void __fastcall SetPort(int AValue);
	virtual void __fastcall SetIntercept(Idintercept::TIdConnectionIntercept* AValue);
	int __fastcall ReadFromSource(bool ARaiseExceptionIfDisconnected = true, int ATimeout = 0xffffffff, bool ARaiseExceptionOnTimeout = true);
	virtual int __fastcall ReadDataFromSource(Idglobal::TIdBytes &VBuffer) = 0 ;
	virtual int __fastcall WriteDataToTarget(const Idglobal::TIdBytes ABuffer, const int AOffset, const int ALength) = 0 ;
	virtual bool __fastcall SourceIsAvailable(void) = 0 ;
	virtual int __fastcall CheckForError(int ALastResult) = 0 ;
	virtual void __fastcall RaiseError(int AError) = 0 ;
	
public:
	__fastcall TIdIOHandler(System::Classes::TComponent* AOwner)/* overload */;
	virtual void __fastcall AfterAccept(void);
	virtual bool __fastcall Connected(void);
	__fastcall virtual ~TIdIOHandler(void);
	virtual void __fastcall CheckForDisconnect(bool ARaiseExceptionIfDisconnected = true, bool AIgnoreBuffer = false) = 0 ;
	virtual bool __fastcall CheckForDataOnSource(int ATimeout = 0x0);
	virtual void __fastcall Close(void);
	virtual void __fastcall CloseGracefully(void);
	__classmethod TIdIOHandler* __fastcall MakeDefaultIOHandler(System::Classes::TComponent* AOwner = (System::Classes::TComponent*)(0x0));
	__classmethod TIdIOHandler* __fastcall MakeIOHandler(TIdIOHandlerClass ABaseType, System::Classes::TComponent* AOwner = (System::Classes::TComponent*)(0x0));
	__classmethod TIdIOHandler* __fastcall TryMakeIOHandler(TIdIOHandlerClass ABaseType, System::Classes::TComponent* AOwner = (System::Classes::TComponent*)(0x0));
	__classmethod void __fastcall RegisterIOHandler();
	__classmethod void __fastcall SetDefaultClass();
	System::UnicodeString __fastcall WaitFor(const System::UnicodeString AString, bool ARemoveFromBuffer = true, bool AInclusive = false, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding(), int ATimeout = 0xffffffff);
	virtual void __fastcall Write(const Idglobal::TIdBytes ABuffer, const int ALength = 0xffffffff, const int AOffset = 0x0)/* overload */;
	void __fastcall WriteDirect(const Idglobal::TIdBytes ABuffer, const int ALength = 0xffffffff, const int AOffset = 0x0);
	virtual void __fastcall Open(void);
	virtual bool __fastcall Readable(int AMSec = 0xffffffff);
	virtual void __fastcall Write(const System::UnicodeString AOut, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	void __fastcall WriteLn(Idglobal::_di_IIdTextEncoding AEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	virtual void __fastcall WriteLn(const System::UnicodeString AOut, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	virtual void __fastcall WriteLnRFC(const System::UnicodeString AOut = System::UnicodeString(), Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding());
	virtual void __fastcall Write(System::Classes::TStrings* AValue, bool AWriteLinesCount = false, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	void __fastcall Write(System::Byte AValue)/* overload */;
	void __fastcall Write(System::WideChar AValue, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	void __fastcall Write(short AValue, bool AConvert = true)/* overload */;
	void __fastcall Write(System::Word AValue, bool AConvert = true)/* overload */;
	void __fastcall Write(int AValue, bool AConvert = true)/* overload */;
	void __fastcall Write(unsigned AValue, bool AConvert = true)/* overload */;
	void __fastcall Write(__int64 AValue, bool AConvert = true)/* overload */;
	void __fastcall Write(unsigned __int64 AValue, bool AConvert = true)/* overload */;
	virtual void __fastcall Write(System::Classes::TStream* AStream, __int64 ASize = 0LL, bool AWriteByteCount = false)/* overload */;
	void __fastcall WriteRFCStrings(System::Classes::TStrings* AStrings, bool AWriteTerminator = true, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding());
	virtual __int64 __fastcall WriteFile(const System::UnicodeString AFile, bool AEnableTransferFile = false);
	virtual System::UnicodeString __fastcall AllData(Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding());
	virtual System::UnicodeString __fastcall InputLn(const System::UnicodeString AMask = System::UnicodeString(), bool AEcho = true, int ATabWidth = 0x8, int AMaxLineLength = 0xffffffff, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding());
	void __fastcall Capture(System::Classes::TStream* ADest, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	void __fastcall Capture(System::Classes::TStream* ADest, System::UnicodeString ADelim, bool AUsesDotTransparency = true, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	void __fastcall Capture(System::Classes::TStream* ADest, /* out */ int &VLineCount, const System::UnicodeString ADelim = L".", bool AUsesDotTransparency = true, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	void __fastcall Capture(System::Classes::TStrings* ADest, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	void __fastcall Capture(System::Classes::TStrings* ADest, const System::UnicodeString ADelim, bool AUsesDotTransparency = true, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	void __fastcall Capture(System::Classes::TStrings* ADest, /* out */ int &VLineCount, const System::UnicodeString ADelim = L".", bool AUsesDotTransparency = true, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	virtual void __fastcall ReadBytes(Idglobal::TIdBytes &VBuffer, int AByteCount, bool AAppend = true);
	System::UnicodeString __fastcall ReadLn(Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	System::UnicodeString __fastcall ReadLn(System::UnicodeString ATerminator, Idglobal::_di_IIdTextEncoding AByteEncoding)/* overload */;
	virtual System::UnicodeString __fastcall ReadLn(System::UnicodeString ATerminator, int ATimeout = 0xffffffff, int AMaxLineLength = 0xffffffff, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	System::UnicodeString __fastcall ReadLnRFC(bool &VMsgEnd, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	System::UnicodeString __fastcall ReadLnRFC(bool &VMsgEnd, const System::UnicodeString ALineTerminator, const System::UnicodeString ADelim = L".", Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	virtual System::UnicodeString __fastcall ReadLnWait(int AFailCount = 0x7fffffff, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding());
	System::UnicodeString __fastcall ReadLnSplit(bool &AWasSplit, System::UnicodeString ATerminator = L"\n", int ATimeout = 0xffffffff, int AMaxLineLength = 0xffffffff, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding());
	System::WideChar __fastcall ReadChar(Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding());
	System::Byte __fastcall ReadByte(void);
	System::UnicodeString __fastcall ReadString(int ABytes, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding());
	short __fastcall ReadInt16(bool AConvert = true);
	System::Word __fastcall ReadUInt16(bool AConvert = true);
	int __fastcall ReadInt32(bool AConvert = true);
	unsigned __fastcall ReadUInt32(bool AConvert = true);
	__int64 __fastcall ReadInt64(bool AConvert = true);
	unsigned __int64 __fastcall ReadUInt64(bool AConvert = true);
	short __fastcall ReadSmallInt _DEPRECATED_ATTRIBUTE1("Use ReadInt16()") (bool AConvert = true);
	System::Word __fastcall ReadWord _DEPRECATED_ATTRIBUTE1("Use ReadUInt16()") (bool AConvert = true);
	int __fastcall ReadLongInt _DEPRECATED_ATTRIBUTE1("Use ReadInt32()") (bool AConvert = true);
	unsigned __fastcall ReadLongWord _DEPRECATED_ATTRIBUTE1("Use ReadUInt32()") (bool AConvert = true);
	virtual void __fastcall ReadStream(System::Classes::TStream* AStream, __int64 AByteCount = -1LL, bool AReadUntilDisconnect = false);
	void __fastcall ReadStrings(System::Classes::TStrings* ADest, int AReadLinesCount = 0xffffffff, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding());
	void __fastcall Discard(__int64 AByteCount);
	void __fastcall DiscardAll(void);
	virtual void __fastcall WriteBufferCancel(void);
	virtual void __fastcall WriteBufferClear(void);
	virtual void __fastcall WriteBufferClose(void);
	void __fastcall WriteBufferFlush(void)/* overload */;
	virtual void __fastcall WriteBufferFlush(int AByteCount)/* overload */;
	void __fastcall WriteBufferOpen(void)/* overload */;
	virtual void __fastcall WriteBufferOpen(int AThreshold)/* overload */;
	bool __fastcall WriteBufferingActive(void);
	bool __fastcall InputBufferIsEmpty(void);
	void __fastcall InputBufferToStream(System::Classes::TStream* AStream, int AByteCount = 0xffffffff);
	System::UnicodeString __fastcall InputBufferAsString(Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding());
	__property int ConnectTimeout = {read=FConnectTimeout, write=FConnectTimeout, default=0};
	__property bool ClosedGracefully = {read=FClosedGracefully, nodefault};
	__property Idbuffer::TIdBuffer* InputBuffer = {read=FInputBuffer};
	__property bool LargeStream = {read=FLargeStream, write=FLargeStream, nodefault};
	__property int MaxCapturedLines = {read=FMaxCapturedLines, write=FMaxCapturedLines, default=-1};
	__property bool Opened = {read=FOpened, nodefault};
	__property int ReadTimeout = {read=FReadTimeOut, write=FReadTimeOut, default=-1};
	__property bool ReadLnTimedout = {read=FReadLnTimedOut, nodefault};
	__property int WriteBufferThreshold = {read=FWriteBufferThreshold, nodefault};
	__property Idglobal::_di_IIdTextEncoding DefStringEncoding = {read=FDefStringEncoding, write=SetDefStringEncoding};
	__property OnWork;
	__property OnWorkBegin;
	__property OnWorkEnd;
	
__published:
	__property System::UnicodeString Destination = {read=GetDestination, write=SetDestination};
	__property System::UnicodeString Host = {read=FHost, write=SetHost};
	__property Idintercept::TIdConnectionIntercept* Intercept = {read=FIntercept, write=SetIntercept};
	__property int MaxLineLength = {read=FMaxLineLength, write=FMaxLineLength, default=16384};
	__property Idglobal::TIdMaxLineAction MaxLineAction = {read=FMaxLineAction, write=FMaxLineAction, nodefault};
	__property int Port = {read=FPort, write=SetPort, nodefault};
	__property int RecvBufferSize = {read=FRecvBufferSize, write=FRecvBufferSize, default=32768};
	__property int SendBufferSize = {read=FSendBufferSize, write=FSendBufferSize, default=32768};
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdIOHandler(void)/* overload */ : Idcomponent::TIdComponent() { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Word GRecvBufferSizeDefault = System::Word(0x8000);
static const System::Word GSendBufferSizeDefault = System::Word(0x8000);
static const System::Word IdMaxLineLengthDefault = System::Word(0x4000);
static const System::Int8 Id_IOHandler_MaxCapturedLines = System::Int8(-1);
}	/* namespace Idiohandler */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDIOHANDLER)
using namespace Idiohandler;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdiohandlerHPP
