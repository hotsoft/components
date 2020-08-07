// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdTrivialFTPServer.pas' rev: 25.00 (Windows)

#ifndef IdtrivialftpserverHPP
#define IdtrivialftpserverHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdThreadSafe.hpp>	// Pascal unit
#include <IdTrivialFTPBase.hpp>	// Pascal unit
#include <IdSocketHandle.hpp>	// Pascal unit
#include <IdUDPServer.hpp>	// Pascal unit
#include <IdUDPBase.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idtrivialftpserver
{
//-- type declarations -------------------------------------------------------
struct DECLSPEC_DRECORD TPeerInfo
{
public:
	System::UnicodeString PeerIP;
	int PeerPort;
};


typedef void __fastcall (__closure *TAccessFileEvent)(System::TObject* Sender, System::UnicodeString &FileName, const TPeerInfo &PeerInfo, bool &GrantAccess, System::Classes::TStream* &AStream, bool &FreeStreamOnComplete);

typedef void __fastcall (__closure *TTransferCompleteEvent)(System::TObject* Sender, const bool Success, const TPeerInfo &PeerInfo, System::Classes::TStream* &AStream, const bool WriteOperation);

typedef Idthreadsafe::TIdThreadSafeObjectList TIdTFTPThreadList;

class DELPHICLASS TIdTrivialFTPServer;
class PASCALIMPLEMENTATION TIdTrivialFTPServer : public Idudpserver::TIdUDPServer
{
	typedef Idudpserver::TIdUDPServer inherited;
	
protected:
	Idthreadsafe::TIdThreadSafeObjectList* FThreadList;
	TTransferCompleteEvent FOnTransferComplete;
	TAccessFileEvent FOnReadFile;
	TAccessFileEvent FOnWriteFile;
	Idtrivialftpbase::TIdTFTPMode __fastcall StrToMode(System::UnicodeString mode);
	virtual void __fastcall DoReadFile(System::UnicodeString FileName, const Idtrivialftpbase::TIdTFTPMode Mode, const TPeerInfo &PeerInfo, int RequestedBlockSize, bool IncludeTransferSize);
	virtual void __fastcall DoWriteFile(System::UnicodeString FileName, const Idtrivialftpbase::TIdTFTPMode Mode, const TPeerInfo &PeerInfo, int RequestedBlockSize, __int64 RequestedTransferSize);
	virtual void __fastcall DoTransferComplete(const bool Success, const TPeerInfo &PeerInfo, System::Classes::TStream* &SourceStream, const bool WriteOperation);
	virtual void __fastcall DoUDPRead(Idudpserver::TIdUDPListenerThread* AThread, const Idglobal::TIdBytes AData, Idsockethandle::TIdSocketHandle* ABinding);
	virtual void __fastcall InitComponent(void);
	
public:
	int __fastcall ActiveThreads(void);
	__fastcall virtual ~TIdTrivialFTPServer(void);
	
__published:
	__property TAccessFileEvent OnReadFile = {read=FOnReadFile, write=FOnReadFile};
	__property TAccessFileEvent OnWriteFile = {read=FOnWriteFile, write=FOnWriteFile};
	__property TTransferCompleteEvent OnTransferComplete = {read=FOnTransferComplete, write=FOnTransferComplete};
	__property DefaultPort = {default=69};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdTrivialFTPServer(System::Classes::TComponent* AOwner)/* overload */ : Idudpserver::TIdUDPServer(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdTrivialFTPServer(void)/* overload */ : Idudpserver::TIdUDPServer() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idtrivialftpserver */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDTRIVIALFTPSERVER)
using namespace Idtrivialftpserver;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdtrivialftpserverHPP
