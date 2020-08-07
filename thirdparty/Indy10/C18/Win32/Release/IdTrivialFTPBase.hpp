// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdTrivialFTPBase.pas' rev: 25.00 (Windows)

#ifndef IdtrivialftpbaseHPP
#define IdtrivialftpbaseHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdUDPBase.hpp>	// Pascal unit
#include <IdUDPClient.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idtrivialftpbase
{
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TIdTFTPMode : unsigned char { tfNetAscii, tfOctet };

//-- var, const, procedure ---------------------------------------------------
static const System::Int8 TFTP_RRQ = System::Int8(0x1);
static const System::Int8 TFTP_WRQ = System::Int8(0x2);
static const System::Int8 TFTP_DATA = System::Int8(0x3);
static const System::Int8 TFTP_ACK = System::Int8(0x4);
static const System::Int8 TFTP_ERROR = System::Int8(0x5);
static const System::Int8 TFTP_OACK = System::Int8(0x6);
static const System::Int8 ErrUndefined = System::Int8(0x0);
static const System::Int8 ErrFileNotFound = System::Int8(0x1);
static const System::Int8 ErrAccessViolation = System::Int8(0x2);
static const System::Int8 ErrAllocationExceeded = System::Int8(0x3);
static const System::Int8 ErrIllegalOperation = System::Int8(0x4);
static const System::Int8 ErrUnknownTransferID = System::Int8(0x5);
static const System::Int8 ErrFileAlreadyExists = System::Int8(0x6);
static const System::Int8 ErrNoSuchUser = System::Int8(0x7);
static const System::Int8 ErrOptionNegotiationFailed = System::Int8(0x8);
#define sBlockSize L"blksize"
#define sTransferSize L"tsize"
extern DELPHI_PACKAGE Idglobal::TIdBytes __fastcall MakeActPkt(const System::Word BlockNumber);
extern DELPHI_PACKAGE void __fastcall SendError(Idudpbase::TIdUDPBase* UDPBase, System::UnicodeString APeerIP, const System::Word APort, const System::Word ErrNumber, const System::UnicodeString ErrString)/* overload */;
extern DELPHI_PACKAGE void __fastcall SendError(Idudpclient::TIdUDPClient* UDPClient, const System::Word ErrNumber, const System::UnicodeString ErrString)/* overload */;
extern DELPHI_PACKAGE void __fastcall SendError(Idudpbase::TIdUDPBase* UDPBase, System::UnicodeString APeerIP, const System::Word APort, System::Sysutils::Exception* E)/* overload */;
extern DELPHI_PACKAGE void __fastcall SendError(Idudpclient::TIdUDPClient* UDPClient, System::Sysutils::Exception* E)/* overload */;
}	/* namespace Idtrivialftpbase */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDTRIVIALFTPBASE)
using namespace Idtrivialftpbase;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdtrivialftpbaseHPP
