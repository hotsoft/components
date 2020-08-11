// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdFSP.pas' rev: 25.00 (Windows)

#ifndef IdfspHPP
#define IdfspHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdFTPList.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdThreadSafe.hpp>	// Pascal unit
#include <IdUDPClient.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <IdUDPBase.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idfsp
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS EIdFSPException;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdFSPException : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdFSPException(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdFSPException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdFSPException(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdFSPException(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdFSPException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdFSPException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdFSPException(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdFSPException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdFSPException(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdFSPException(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdFSPException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdFSPException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdFSPException(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdFSPFileAlreadyExists;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdFSPFileAlreadyExists : public EIdFSPException
{
	typedef EIdFSPException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdFSPFileAlreadyExists(const System::UnicodeString AMsg)/* overload */ : EIdFSPException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdFSPFileAlreadyExists(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdFSPException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdFSPFileAlreadyExists(NativeUInt Ident)/* overload */ : EIdFSPException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdFSPFileAlreadyExists(System::PResStringRec ResStringRec)/* overload */ : EIdFSPException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdFSPFileAlreadyExists(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdFSPException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdFSPFileAlreadyExists(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdFSPException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdFSPFileAlreadyExists(const System::UnicodeString Msg, int AHelpContext) : EIdFSPException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdFSPFileAlreadyExists(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdFSPException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdFSPFileAlreadyExists(NativeUInt Ident, int AHelpContext)/* overload */ : EIdFSPException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdFSPFileAlreadyExists(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdFSPException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdFSPFileAlreadyExists(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdFSPException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdFSPFileAlreadyExists(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdFSPException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdFSPFileAlreadyExists(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdFSPFileNotFound;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdFSPFileNotFound : public EIdFSPException
{
	typedef EIdFSPException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdFSPFileNotFound(const System::UnicodeString AMsg)/* overload */ : EIdFSPException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdFSPFileNotFound(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdFSPException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdFSPFileNotFound(NativeUInt Ident)/* overload */ : EIdFSPException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdFSPFileNotFound(System::PResStringRec ResStringRec)/* overload */ : EIdFSPException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdFSPFileNotFound(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdFSPException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdFSPFileNotFound(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdFSPException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdFSPFileNotFound(const System::UnicodeString Msg, int AHelpContext) : EIdFSPException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdFSPFileNotFound(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdFSPException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdFSPFileNotFound(NativeUInt Ident, int AHelpContext)/* overload */ : EIdFSPException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdFSPFileNotFound(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdFSPException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdFSPFileNotFound(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdFSPException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdFSPFileNotFound(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdFSPException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdFSPFileNotFound(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdFSPProtException;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdFSPProtException : public EIdFSPException
{
	typedef EIdFSPException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdFSPProtException(const System::UnicodeString AMsg)/* overload */ : EIdFSPException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdFSPProtException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdFSPException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdFSPProtException(NativeUInt Ident)/* overload */ : EIdFSPException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdFSPProtException(System::PResStringRec ResStringRec)/* overload */ : EIdFSPException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdFSPProtException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdFSPException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdFSPProtException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdFSPException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdFSPProtException(const System::UnicodeString Msg, int AHelpContext) : EIdFSPException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdFSPProtException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdFSPException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdFSPProtException(NativeUInt Ident, int AHelpContext)/* overload */ : EIdFSPException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdFSPProtException(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdFSPException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdFSPProtException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdFSPException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdFSPProtException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdFSPException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdFSPProtException(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdFSPPacketTooSmall;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdFSPPacketTooSmall : public EIdFSPException
{
	typedef EIdFSPException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdFSPPacketTooSmall(const System::UnicodeString AMsg)/* overload */ : EIdFSPException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdFSPPacketTooSmall(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdFSPException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdFSPPacketTooSmall(NativeUInt Ident)/* overload */ : EIdFSPException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdFSPPacketTooSmall(System::PResStringRec ResStringRec)/* overload */ : EIdFSPException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdFSPPacketTooSmall(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdFSPException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdFSPPacketTooSmall(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdFSPException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdFSPPacketTooSmall(const System::UnicodeString Msg, int AHelpContext) : EIdFSPException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdFSPPacketTooSmall(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdFSPException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdFSPPacketTooSmall(NativeUInt Ident, int AHelpContext)/* overload */ : EIdFSPException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdFSPPacketTooSmall(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdFSPException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdFSPPacketTooSmall(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdFSPException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdFSPPacketTooSmall(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdFSPException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdFSPPacketTooSmall(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdFSPStatInfo;
class PASCALIMPLEMENTATION TIdFSPStatInfo : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
protected:
	System::TDateTime FModifiedDateGMT;
	System::TDateTime FModifiedDate;
	__int64 FSize;
	Idftplist::TIdDirItemType FItemType;
	
__published:
	__property Idftplist::TIdDirItemType ItemType = {read=FItemType, write=FItemType, nodefault};
	__property __int64 Size = {read=FSize, write=FSize};
	__property System::TDateTime ModifiedDate = {read=FModifiedDate, write=FModifiedDate};
	__property System::TDateTime ModifiedDateGMT = {read=FModifiedDateGMT, write=FModifiedDateGMT};
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TIdFSPStatInfo(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdFSPStatInfo(void) { }
	
};


class DELPHICLASS TIdFSPListItem;
class PASCALIMPLEMENTATION TIdFSPListItem : public TIdFSPStatInfo
{
	typedef TIdFSPStatInfo inherited;
	
protected:
	System::UnicodeString FFileName;
	
__published:
	__property System::UnicodeString FileName = {read=FFileName, write=FFileName};
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TIdFSPListItem(System::Classes::TCollection* Collection) : TIdFSPStatInfo(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdFSPListItem(void) { }
	
};


class DELPHICLASS TIdFSPListItems;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFSPListItems : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TIdFSPListItem* operator[](int AIndex) { return Items[AIndex]; }
	
protected:
	TIdFSPListItem* __fastcall GetItems(int AIndex);
	void __fastcall SetItems(int AIndex, TIdFSPListItem* const Value);
	
public:
	HIDESBASE TIdFSPListItem* __fastcall Add(void);
	__fastcall TIdFSPListItems(void);
	bool __fastcall ParseEntries(const Idglobal::TIdBytes AData, const unsigned ADataLen);
	int __fastcall IndexOf(TIdFSPListItem* AItem);
	__property TIdFSPListItem* Items[int AIndex] = {read=GetItems, write=SetItems/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TIdFSPListItems(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdFSPDirInfo;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFSPDirInfo : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	bool FOwnsDir;
	bool FCanDeleteFiles;
	bool FCanAddFiles;
	bool FCanMakeDir;
	bool FOnlyOwnerCanReadFiles;
	bool FHasReadMe;
	bool FCanBeListed;
	bool FCanRenameFiles;
	System::UnicodeString FReadMe;
	
public:
	__property bool OwnsDir = {read=FOwnsDir, write=FOwnsDir, nodefault};
	__property bool CanDeleteFiles = {read=FCanDeleteFiles, write=FCanDeleteFiles, nodefault};
	__property bool CanAddFiles = {read=FCanAddFiles, write=FCanAddFiles, nodefault};
	__property bool CanMakeDir = {read=FCanMakeDir, write=FCanMakeDir, nodefault};
	__property bool OnlyOwnerCanReadFiles = {read=FOnlyOwnerCanReadFiles, write=FOnlyOwnerCanReadFiles, nodefault};
	__property bool HasReadMe = {read=FHasReadMe, write=FHasReadMe, nodefault};
	__property bool CanBeListed = {read=FCanBeListed, write=FCanBeListed, nodefault};
	__property bool CanRenameFiles = {read=FCanRenameFiles, write=FCanRenameFiles, nodefault};
	__property System::UnicodeString ReadMe = {read=FReadMe, write=FReadMe};
public:
	/* TObject.Create */ inline __fastcall TIdFSPDirInfo(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFSPDirInfo(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdFSPPacket;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFSPPacket : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	System::Byte FCmd;
	unsigned FFilePosition;
	Idglobal::TIdBytes FData;
	System::Word FDataLen;
	Idglobal::TIdBytes FExtraData;
	System::Word FSequence;
	System::Word FKey;
	bool FValid;
	
public:
	__fastcall TIdFSPPacket(void);
	Idglobal::TIdBytes __fastcall WritePacket(void);
	void __fastcall ReadPacket(const Idglobal::TIdBytes AData, const unsigned ALen);
	__property bool Valid = {read=FValid, nodefault};
	__property System::Byte Cmd = {read=FCmd, write=FCmd, nodefault};
	__property System::Word Key = {read=FKey, write=FKey, nodefault};
	__property System::Word Sequence = {read=FSequence, write=FSequence, nodefault};
	__property unsigned FilePosition = {read=FFilePosition, write=FFilePosition, nodefault};
	__property Idglobal::TIdBytes Data = {read=FData, write=FData};
	__property System::Word DataLen = {read=FDataLen, write=FDataLen, nodefault};
	__property Idglobal::TIdBytes ExtraData = {read=FExtraData, write=FExtraData};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFSPPacket(void) { }
	
};

#pragma pack(pop)

typedef void __fastcall (__closure *TIdFSPLogEvent)(System::TObject* Sender, TIdFSPPacket* APacket);

class DELPHICLASS TIdFSP;
class PASCALIMPLEMENTATION TIdFSP : public Idudpclient::TIdUDPClient
{
	typedef Idudpclient::TIdUDPClient inherited;
	
protected:
	bool FConEstablished;
	System::Word FSequence;
	System::Word FKey;
	System::UnicodeString FSystemDesc;
	bool FSystemServerLogs;
	bool FSystemReadOnly;
	bool FSystemReverseLookupRequired;
	bool FSystemPrivateMode;
	bool FSystemAcceptsExtraData;
	bool FThruputControl;
	unsigned FServerMaxThruPut;
	System::Word FServerMaxPacketSize;
	System::Word FClientMaxPacketSize;
	TIdFSPListItems* FDirectoryListing;
	TIdFSPDirInfo* FDirInfo;
	TIdFSPStatInfo* FStatInfo;
	TIdFSPLogEvent FOnRecv;
	TIdFSPLogEvent FOnSend;
	Idthreadsafe::TIdThreadSafeBoolean* FAbortFlag;
	Idthreadsafe::TIdThreadSafeBoolean* FInCmd;
	void __fastcall SendCmdOnce(TIdFSPPacket* ACmdPacket, TIdFSPPacket* ARecvPacket, Idglobal::TIdBytes &VTempBuf, const bool ARaiseException = true)/* overload */;
	void __fastcall SendCmdOnce(const System::Byte ACmd, const Idglobal::TIdBytes AData, const Idglobal::TIdBytes AExtraData, const __int64 AFilePosition, Idglobal::TIdBytes &VData, Idglobal::TIdBytes &VExtraData, const bool ARaiseException = true)/* overload */;
	void __fastcall SendCmd(TIdFSPPacket* ACmdPacket, TIdFSPPacket* ARecvPacket, Idglobal::TIdBytes &VTempBuf, const bool ARaiseException = true)/* overload */;
	void __fastcall SendCmd(const System::Byte ACmd, const Idglobal::TIdBytes AData, const Idglobal::TIdBytes AExtraData, const __int64 AFilePosition, Idglobal::TIdBytes &VData, Idglobal::TIdBytes &VExtraData, const bool ARaiseException = true)/* overload */;
	void __fastcall SendCmd(const System::Byte ACmd, const Idglobal::TIdBytes AData, const __int64 AFilePosition, Idglobal::TIdBytes &VData, Idglobal::TIdBytes &VExtraData, const bool ARaiseException = true)/* overload */;
	void __fastcall ParseDirInfo(const Idglobal::TIdBytes ABuf, const Idglobal::TIdBytes AExtraBuf, TIdFSPDirInfo* ADir);
	virtual void __fastcall InitComponent(void);
	System::Word __fastcall MaxBufferSize(void);
	System::Word __fastcall PrefPayloadSize(void);
	void __fastcall SetClientMaxPacketSize(const System::Word AValue);
	
public:
	__fastcall virtual ~TIdFSP(void);
	virtual void __fastcall Connect(void);
	virtual void __fastcall Disconnect(void);
	HIDESBASE void __fastcall Version(void);
	void __fastcall AbortCmd(void);
	void __fastcall Delete(const System::UnicodeString AFilename);
	void __fastcall RemoveDir(const System::UnicodeString ADirName);
	void __fastcall Rename(const System::UnicodeString ASourceFile, const System::UnicodeString ADestFile);
	void __fastcall MakeDir(const System::UnicodeString ADirName);
	void __fastcall List(void)/* overload */;
	void __fastcall List(const System::UnicodeString ASpecifier)/* overload */;
	void __fastcall GetDirInfo(const System::UnicodeString ADIR)/* overload */;
	void __fastcall GetDirInfo(const System::UnicodeString ADIR, TIdFSPDirInfo* ADirInfo)/* overload */;
	void __fastcall GetStatInfo(const System::UnicodeString APath);
	void __fastcall Get(const System::UnicodeString ASourceFile, const System::UnicodeString ADestFile, const bool ACanOverwrite = false, bool AResume = false)/* overload */;
	void __fastcall Get(const System::UnicodeString ASourceFile, System::Classes::TStream* ADest, bool AResume = false)/* overload */;
	void __fastcall Put(System::Classes::TStream* const ASource, const System::UnicodeString ADestFile, const System::TDateTime AGMTTime = 0.000000E+00)/* overload */;
	void __fastcall Put(const System::UnicodeString ASourceFile, const System::UnicodeString ADestFile = System::UnicodeString())/* overload */;
	__property System::UnicodeString SystemDesc = {read=FSystemDesc};
	__property bool SystemServerLogs = {read=FSystemServerLogs, nodefault};
	__property bool SystemReadOnly = {read=FSystemReadOnly, nodefault};
	__property bool SystemReverseLookupRequired = {read=FSystemReverseLookupRequired, nodefault};
	__property bool SystemPrivateMode = {read=FSystemPrivateMode, nodefault};
	__property bool SystemAcceptsExtraData = {read=FSystemAcceptsExtraData, nodefault};
	__property bool ThruputControl = {read=FThruputControl, nodefault};
	__property unsigned ServerMaxThruPut = {read=FServerMaxThruPut, nodefault};
	__property System::Word ServerMaxPacketSize = {read=FServerMaxPacketSize, nodefault};
	__property System::Word ClientMaxPacketSize = {read=FClientMaxPacketSize, write=SetClientMaxPacketSize, nodefault};
	__property TIdFSPListItems* DirectoryListing = {read=FDirectoryListing};
	__property TIdFSPDirInfo* DirInfo = {read=FDirInfo};
	__property TIdFSPStatInfo* StatInfo = {read=FStatInfo};
	
__published:
	__property Port = {default=21};
	__property OnWork;
	__property OnWorkBegin;
	__property OnWorkEnd;
	__property TIdFSPLogEvent OnRecv = {read=FOnRecv, write=FOnRecv};
	__property TIdFSPLogEvent OnSend = {read=FOnSend, write=FOnSend};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdFSP(System::Classes::TComponent* AOwner)/* overload */ : Idudpclient::TIdUDPClient(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdFSP(void)/* overload */ : Idudpclient::TIdUDPClient() { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 IdPORT_FSP = System::Int8(0x15);
static const System::Int8 HSIZE = System::Int8(0xc);
static const System::Word DEF_MAXSPACE = System::Word(0x3f4);
static const System::Word DEF_MAXSIZE = System::Word(0x400);
static const System::Int8 CC_VERSION = System::Int8(0x10);
static const System::Int8 CC_INFO = System::Int8(0x11);
static const System::Int8 CC_ERR = System::Int8(0x40);
static const System::Int8 CC_GET_DIR = System::Int8(0x41);
static const System::Int8 CC_GET_FILE = System::Int8(0x42);
static const System::Int8 CC_UP_LOAD = System::Int8(0x43);
static const System::Int8 CC_INSTALL = System::Int8(0x44);
static const System::Int8 CC_DEL_FILE = System::Int8(0x45);
static const System::Int8 CC_DEL_DIR = System::Int8(0x46);
static const System::Int8 CC_GET_PRO = System::Int8(0x47);
static const System::Int8 CC_SET_PRO = System::Int8(0x48);
static const System::Int8 CC_MAKE_DIR = System::Int8(0x49);
static const System::Int8 CC_BYE = System::Int8(0x4a);
static const System::Int8 CC_GRAB_FILE = System::Int8(0x4b);
static const System::Int8 CC_GRAB_DONE = System::Int8(0x4c);
static const System::Int8 CC_STAT = System::Int8(0x4d);
static const System::Int8 CC_RENAME = System::Int8(0x4e);
static const System::Int8 CC_CH_PASSW = System::Int8(0x4f);
static const System::Byte CC_LIMIT = System::Byte(0x80);
static const System::Byte CC_TEST = System::Byte(0x81);
static const System::Int8 RDTYPE_END = System::Int8(0x0);
static const System::Int8 RDTYPE_FILE = System::Int8(0x1);
static const System::Int8 RDTYPE_DIR = System::Int8(0x2);
static const System::Int8 RDTYPE_SKIP = System::Int8(0x2a);
static const System::Word MINTIMEOUT = System::Word(0x53c);
static const int MAXTIMEOUT = int(0x493e0);
}	/* namespace Idfsp */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDFSP)
using namespace Idfsp;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdfspHPP
