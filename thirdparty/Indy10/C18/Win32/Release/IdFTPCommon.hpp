// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdFTPCommon.pas' rev: 25.00 (Windows)

#ifndef IdftpcommonHPP
#define IdftpcommonHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdGlobalProtocols.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idftpcommon
{
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TIdFTPTransferType : unsigned char { ftASCII, ftBinary };

enum DECLSPEC_DENUM TIdFTPDataStructure : unsigned char { dsFile, dsRecord, dsPage };

enum DECLSPEC_DENUM TIdFTPTransferMode : unsigned char { dmStream, dmDeflate };

enum DECLSPEC_DENUM TIdFTPDataPortSecurity : unsigned char { ftpdpsClear, ftpdpsPrivate };

typedef System::StaticArray<System::UnicodeString, 4> Idftpcommon__1;

enum DECLSPEC_DENUM TIdVSEPQDisposition : unsigned char { IdPQAppendable, IdPQProcessAndDelete, IdPQHoldUntilReleased, IdPQProcessAndKeep, IdPQLeaveUntilReleased, IdPQErrorHoldUntilDK, IdPQGetOrErrorHoldUntilDK, IdPQJobProcessing, IdPQSpoolOutputToInputD, IdPQSurpressOutputSpooling, IdPQSpoolOutputToTape };

typedef System::StaticArray<System::UnicodeString, 6> Idftpcommon__2;

typedef System::StaticArray<System::UnicodeString, 4> Idftpcommon__3;

typedef System::StaticArray<System::UnicodeString, 2> Idftpcommon__4;

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE Idftpcommon__1 TLS_AUTH_NAMES;
#define SCCN_FEAT L"SSCN"
#define SSCN_ON L"SSCN ON"
#define SSCN_OFF L"SSCN OFF"
static const System::Byte SSCN_OK_REPLY = System::Byte(0xc8);
static const System::Word SSCN_ERR_NEGOTIATION_REPLY = System::Word(0x1a5);
static const System::WideChar PATH_FILENAME_SEP_UNIX = (System::WideChar)(0x2f);
static const System::WideChar PATH_FILENAME_SEP_DOS = (System::WideChar)(0x5c);
static const System::WideChar PATH_FILENAME_SEP_VMS = (System::WideChar)(0x5d);
static const System::WideChar PATH_SUBDIR_SEP_UNIX = (System::WideChar)(0x2f);
static const System::WideChar PATH_SUBDIR_SEP_DOS = (System::WideChar)(0x5c);
static const System::WideChar PATH_SUBDIR_SEP_VMS = (System::WideChar)(0x2e);
#define PATH_DEVICE_SEP_UNIX L""
static const System::WideChar PATH_DEVICE_SEP_DOS = (System::WideChar)(0x3a);
#define PATH_DEVICE_SEP_VMS L":["
static const System::WideChar UNIX_ALL_FILES = (System::WideChar)(0x2a);
#define MS_DOS_ALL_FILES L"*.*"
#define VMS_ALL_FILES L"*.*;*"
static const System::WideChar CUR_DIR = (System::WideChar)(0x2e);
#define PARENT_DIR L".."
#define VMS_RELPATH_PREFIX L"[."
#define MS_DOS_CURDIR L".\\"
#define UNIX_CURDIR L"./"
static const System::Word UNIX_DIR_SIZE = System::Word(0x200);
static const System::Word VMS_BLOCK_SIZE = System::Word(0x200);
static const System::Word EPLF_BASE_DATE = System::Word(0x63e1);
static const System::Int8 DEF_ZLIB_COMP_LEVEL = System::Int8(0x7);
static const System::Int8 DEF_ZLIB_WINDOW_BITS = System::Int8(0xf);
static const System::Int8 DEF_ZLIB_MEM_LEVEL = System::Int8(0x8);
static const System::Int8 DEF_ZLIB_STRATAGY = System::Int8(0x0);
static const System::Int8 DEF_ZLIB_METHOD = System::Int8(0x8);
extern DELPHI_PACKAGE Idftpcommon__2 VSERootDirItemTypes;
extern DELPHI_PACKAGE Idftpcommon__3 MVS_JES_Status;
extern DELPHI_PACKAGE System::StaticArray<System::WideChar, 11> VSE_PowerQueue_Dispositions;
extern DELPHI_PACKAGE Idftpcommon__4 UnitreeStoreTypes;
#define UNIX_LINKTO_SYM L" -> "
#define CDATE_PART_SEP L"/-"
static const System::Word Id__S_ISUID = System::Word(0x800);
static const System::Word Id__S_ISGID = System::Word(0x400);
static const System::Word Id__S_ISVTX = System::Word(0x200);
static const System::Word Id__S_IREAD = System::Word(0x100);
static const System::Byte Id__S_IWRITE = System::Byte(0x80);
static const System::Int8 Id__S_IEXEC = System::Int8(0x40);
static const System::Word IdS_ISUID = System::Word(0x800);
static const System::Word IdS_ISGID = System::Word(0x400);
static const System::Word IdS_ISVTX = System::Word(0x200);
static const System::Word IdS_IRUSR = System::Word(0x100);
static const System::Byte IdS_IWUSR = System::Byte(0x80);
static const System::Int8 IdS_IXUSR = System::Int8(0x40);
static const System::Word IdS_IRWXU = System::Word(0x1c0);
static const System::Word IdS_IREAD = System::Word(0x100);
static const System::Byte IdS_IWRITE = System::Byte(0x80);
static const System::Int8 IdS_IEXEC = System::Int8(0x40);
static const System::Int8 IdS_IRGRP = System::Int8(0x20);
static const System::Int8 IdS_IWGRP = System::Int8(0x10);
static const System::Int8 IdS_IXGRP = System::Int8(0x8);
static const System::Int8 IdS_IRWXG = System::Int8(0x38);
static const System::Int8 IdS_IROTH = System::Int8(0x4);
static const System::Int8 IdS_IWOTH = System::Int8(0x2);
static const System::Int8 IdS_IXOTH = System::Int8(0x1);
static const System::Int8 IdS_IRWXO = System::Int8(0x7);
static const System::WideChar KoreanTotal = (System::WideChar)(0xcd1d);
static const System::WideChar KoreanMonth = (System::WideChar)(0xc6d4);
static const System::WideChar KoreanDay = (System::WideChar)(0xc77c);
static const System::WideChar KoreanEUCMonth = (System::WideChar)(0xbff9);
static const System::WideChar KoreanYear = (System::WideChar)(0xb144);
#define ChineseTotal L"\u603b\u6570"
static const System::WideChar ChineseMonth = (System::WideChar)(0x6708);
static const System::WideChar ChineseDay = (System::WideChar)(0x65e5);
static const System::WideChar ChineseYear = (System::WideChar)(0x5e74);
#define JapaneseTotal L"\u5408\u8a08"
static const System::WideChar JapaneseMonth = (System::WideChar)(0x8c8e);
static const System::WideChar JapaneseDay = (System::WideChar)(0x93fa);
static const System::WideChar JapaneseYear = (System::WideChar)(0x944e);
static const int XAUT_2_KEY = int(0x49327576);
extern DELPHI_PACKAGE bool __fastcall ExtractWSFTPServerKey(const System::UnicodeString AGreeting, unsigned &VKey);
extern DELPHI_PACKAGE void __fastcall xaut_encrypt(Idglobal::TIdBytes &VDest, const Idglobal::TIdBytes ASrc, const unsigned AKey);
extern DELPHI_PACKAGE void __fastcall xaut_unpack(System::UnicodeString &VDest, const Idglobal::TIdBytes ASrc);
extern DELPHI_PACKAGE void __fastcall xaut_pack(Idglobal::TIdBytes &VDst, const System::UnicodeString ASrc);
extern DELPHI_PACKAGE System::UnicodeString __fastcall MakeXAUTCmd(const System::UnicodeString AGreeting, const System::UnicodeString AUsername, const System::UnicodeString APassword, const unsigned Ad = (unsigned)(0x2));
extern DELPHI_PACKAGE System::UnicodeString __fastcall ExtractAutInfoFromXAUT(const System::UnicodeString AXAutStr, const unsigned AKey);
extern DELPHI_PACKAGE unsigned __fastcall MakeXAUTKey(void);
extern DELPHI_PACKAGE void __fastcall DeleteSuffix(System::UnicodeString &VStr, const System::UnicodeString ASuffix);
extern DELPHI_PACKAGE System::UnicodeString __fastcall StripSpaces(const System::UnicodeString AString, const unsigned ASpaces);
extern DELPHI_PACKAGE System::UnicodeString __fastcall StripPath(const System::UnicodeString AFileName, const System::UnicodeString APathDelim = L"/");
extern DELPHI_PACKAGE int __fastcall CharsInStr(const System::WideChar ASearchChar, const System::UnicodeString AString);
extern DELPHI_PACKAGE int __fastcall PatternsInStr(const System::UnicodeString ASearchPattern, const System::UnicodeString AString);
extern DELPHI_PACKAGE System::UnicodeString __fastcall UnfoldLines(const System::UnicodeString AData, int ALine, System::Classes::TStrings* AStrings);
extern DELPHI_PACKAGE System::UnicodeString __fastcall StrPart(System::UnicodeString &AInput, const int AMaxLength, const bool ADelete = true);
extern DELPHI_PACKAGE System::UnicodeString __fastcall FetchLength(System::UnicodeString &AInput, const int AMaxLength, const System::UnicodeString ADelim = L" ", const bool ADelete = true, const bool ACaseSensitive = true);
extern DELPHI_PACKAGE bool __fastcall IsLineStr(const System::UnicodeString AData);
extern DELPHI_PACKAGE System::UnicodeString __fastcall FindDelimInNumbers(const System::UnicodeString AData);
extern DELPHI_PACKAGE int __fastcall ExtractNumber(const System::UnicodeString AData, const bool ARetZero = true);
extern DELPHI_PACKAGE System::UnicodeString __fastcall StripNo(const System::UnicodeString AData);
extern DELPHI_PACKAGE System::UnicodeString __fastcall IndyGetFilePath(const System::UnicodeString AFileName);
extern DELPHI_PACKAGE System::UnicodeString __fastcall IndyGetFileName(const System::UnicodeString AFileName);
extern DELPHI_PACKAGE bool __fastcall IndyIsRelativePath(const System::UnicodeString APathName);
extern DELPHI_PACKAGE System::UnicodeString __fastcall IndyGetFileExt(const System::UnicodeString AFileName);
extern DELPHI_PACKAGE System::UnicodeString __fastcall StripInitPathDelim(const System::UnicodeString AStr);
extern DELPHI_PACKAGE bool __fastcall IsNavPath(const System::UnicodeString APath);
extern DELPHI_PACKAGE System::UnicodeString __fastcall RemoveDuplicatePathSyms(System::UnicodeString APath);
extern DELPHI_PACKAGE System::UnicodeString __fastcall UnixPathToDOSPath(const System::UnicodeString APath);
extern DELPHI_PACKAGE System::UnicodeString __fastcall DOSPathToUnixPath(const System::UnicodeString APath);
extern DELPHI_PACKAGE bool __fastcall IsSubDirContentsBanner(const System::UnicodeString AData);
extern DELPHI_PACKAGE bool __fastcall IsTotalLine(const System::UnicodeString AData);
extern DELPHI_PACKAGE void __fastcall ParseQuotedArgs(const System::UnicodeString AParams, System::Classes::TStrings* AStrings);
extern DELPHI_PACKAGE System::TDateTime __fastcall EPLFDateToLocalDateTime(const System::UnicodeString AData);
extern DELPHI_PACKAGE System::TDateTime __fastcall EPLFDateToGMTDateTime(const System::UnicodeString AData);
extern DELPHI_PACKAGE System::UnicodeString __fastcall GMTDateTimeToEPLFDate(const System::TDateTime ADateTime);
extern DELPHI_PACKAGE System::UnicodeString __fastcall LocalDateTimeToEPLFDate(const System::TDateTime ADateTime);
extern DELPHI_PACKAGE bool __fastcall IsValidTimeStamp(const System::UnicodeString AString);
extern DELPHI_PACKAGE bool __fastcall IsMDTMDate(const System::UnicodeString ADate);
extern DELPHI_PACKAGE System::TDateTime __fastcall MDTMOffset(const System::UnicodeString AOffs);
extern DELPHI_PACKAGE int __fastcall MinutesFromGMT(void);
extern DELPHI_PACKAGE System::UnicodeString __fastcall FTPDateTimeToMDTMD(const System::TDateTime ATimeStamp, const bool AIncludeMSecs = true, const bool AIncludeGMTOffset = true);
extern DELPHI_PACKAGE System::TDateTime __fastcall FTPMDTMToGMTDateTime(const System::UnicodeString ATimeStamp);
extern DELPHI_PACKAGE bool __fastcall IsYYYYMMDD(const System::UnicodeString AData);
extern DELPHI_PACKAGE bool __fastcall IsDDMonthYY(const System::UnicodeString AData, const System::UnicodeString ADelim);
extern DELPHI_PACKAGE bool __fastcall IsMMDDYY(const System::UnicodeString AData, const System::UnicodeString ADelim);
extern DELPHI_PACKAGE int __fastcall Y2Year(const int AYear);
extern DELPHI_PACKAGE System::TDateTime __fastcall DateYYMMDD(const System::UnicodeString AData);
extern DELPHI_PACKAGE System::TDateTime __fastcall DateYYStrMonthDD(const System::UnicodeString AData, const System::UnicodeString ADelim = L"-");
extern DELPHI_PACKAGE System::TDateTime __fastcall DateStrMonthDDYY(const System::UnicodeString AData, const System::UnicodeString ADelim = L"-", const bool AAddMissingYear = false);
extern DELPHI_PACKAGE System::TDateTime __fastcall DateDDStrMonthYY(const System::UnicodeString AData, const System::UnicodeString ADelim = L"-");
extern DELPHI_PACKAGE System::TDateTime __fastcall DateMMDDYY(const System::UnicodeString AData);
extern DELPHI_PACKAGE System::TDateTime __fastcall TimeHHMMSS(const System::UnicodeString AData);
extern DELPHI_PACKAGE bool __fastcall IsIn6MonthWindow(const System::TDateTime AMDate);
extern DELPHI_PACKAGE unsigned __fastcall AddMissingYear(const unsigned ADay, const unsigned AMonth);
extern DELPHI_PACKAGE bool __fastcall IsHHMMSS(const System::UnicodeString AData, const System::UnicodeString ADelim);
extern DELPHI_PACKAGE System::TDateTime __fastcall MVSDate(const System::UnicodeString AData);
extern DELPHI_PACKAGE System::TDateTime __fastcall AS400Date(const System::UnicodeString AData);
extern DELPHI_PACKAGE bool __fastcall IsValidUnixPerms(System::UnicodeString AData, const bool AStrict = false);
extern DELPHI_PACKAGE bool __fastcall IsUnixLsErr(const System::UnicodeString AData);
extern DELPHI_PACKAGE bool __fastcall IsUnixHiddenFile(const System::UnicodeString AFileName);
extern DELPHI_PACKAGE bool __fastcall IsUnixExec(const System::UnicodeString LUPer, const System::UnicodeString LGPer, const System::UnicodeString LOPer);
extern DELPHI_PACKAGE unsigned __fastcall PermStringToModeBits(const System::UnicodeString APerms);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ModeBitsToPermString(const unsigned AMode);
extern DELPHI_PACKAGE int __fastcall ModeBitsToChmodNo(const unsigned AMode);
extern DELPHI_PACKAGE unsigned __fastcall ChmodNoToModeBits(const unsigned AModVal);
extern DELPHI_PACKAGE void __fastcall ChmodNoToPerms(const int AChmodNo, System::UnicodeString &VPermissions)/* overload */;
extern DELPHI_PACKAGE void __fastcall ChmodNoToPerms(const int AChmodNo, System::UnicodeString &VUser, System::UnicodeString &VGroup, System::UnicodeString &VOther)/* overload */;
extern DELPHI_PACKAGE int __fastcall PermsToChmodNo(const System::UnicodeString AUser, const System::UnicodeString AGroup, const System::UnicodeString AOther);
extern DELPHI_PACKAGE bool __fastcall IsNovelPSPattern(const System::UnicodeString AStr);
extern DELPHI_PACKAGE bool __fastcall IsValidNovellPermissionStr(const System::UnicodeString AStr);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ExtractNovellPerms(const System::UnicodeString AData);
extern DELPHI_PACKAGE bool __fastcall ExcludeQVNET(const System::UnicodeString AData);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ExtractQVNETFileName(const System::UnicodeString AData);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ExtractRecFormat(const System::UnicodeString ARecFM);
extern DELPHI_PACKAGE TIdVSEPQDisposition __fastcall DispositionCodeToTIdVSEPQDisposition(const System::WideChar ADisp);
extern DELPHI_PACKAGE System::WideChar __fastcall TIdVSEPQDispositionDispositionCode(const TIdVSEPQDisposition ADisp);
extern DELPHI_PACKAGE bool __fastcall IsVMBFS(System::UnicodeString AData);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ParseFacts(System::UnicodeString AData, System::Classes::TStrings* AResults, const System::UnicodeString AFactDelim = L";", const System::UnicodeString ANameDelim = L" ");
extern DELPHI_PACKAGE System::UnicodeString __fastcall ParseFactsMLS(System::UnicodeString AData, System::Classes::TStrings* AResults, const System::UnicodeString AFactDelim = L";", const System::UnicodeString ANameDelim = L" ");
extern DELPHI_PACKAGE bool __fastcall IsValidSterCommFlags(const System::UnicodeString AString);
extern DELPHI_PACKAGE bool __fastcall IsValidSterCommProt(const System::UnicodeString AString);
extern DELPHI_PACKAGE bool __fastcall IsValidSterCommData(const System::UnicodeString AString);
}	/* namespace Idftpcommon */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDFTPCOMMON)
using namespace Idftpcommon;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdftpcommonHPP
