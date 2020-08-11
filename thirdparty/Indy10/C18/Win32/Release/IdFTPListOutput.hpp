// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdFTPListOutput.pas' rev: 25.00 (Windows)

#ifndef IdftplistoutputHPP
#define IdftplistoutputHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdFTPList.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idftplistoutput
{
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TIdFTPFactOutput : unsigned char { ItemType, Modify, Size, Perm, Unique, UnixMODE, UnixOwner, UnixGroup, CreateTime, LastAccessTime, WinAttribs, WinDriveType, WinDriveLabel };

typedef System::Set<TIdFTPFactOutput, TIdFTPFactOutput::ItemType, TIdFTPFactOutput::WinDriveLabel>  TIdFTPFactOutputs;

enum DECLSPEC_DENUM TIdDirOutputFormat : unsigned char { doUnix, doWin32, doEPLF };

class DELPHICLASS TIdFTPListOutputItem;
class PASCALIMPLEMENTATION TIdFTPListOutputItem : public Idftplist::TIdFTPListItem
{
	typedef Idftplist::TIdFTPListItem inherited;
	
protected:
	int FLinkCount;
	System::UnicodeString FGroupName;
	System::UnicodeString FOwnerName;
	System::UnicodeString FLinkedItemName;
	int FNumberBlocks;
	int FInode;
	System::TDateTime FLastAccessDate;
	System::TDateTime FLastAccessDateGMT;
	System::TDateTime FCreationDate;
	System::TDateTime FCreationDateGMT;
	System::UnicodeString FUniqueID;
	System::UnicodeString FMLISTPermissions;
	System::UnicodeString FUnixGroupPermissions;
	System::UnicodeString FUnixOwnerPermissions;
	System::UnicodeString FUnixOtherPermissions;
	int FUnixinode;
	unsigned FWinAttribs;
	bool FDirError;
	int FWinDriveType;
	System::UnicodeString FWinDriveLabel;
	
public:
	__fastcall virtual TIdFTPListOutputItem(System::Classes::TCollection* AOwner);
	__property int NumberBlocks = {read=FNumberBlocks, write=FNumberBlocks, nodefault};
	__property int Inode = {read=FInode, write=FInode, nodefault};
	__property System::TDateTime LastAccessDate = {read=FLastAccessDate, write=FLastAccessDate};
	__property System::TDateTime LastAccessDateGMT = {read=FLastAccessDateGMT, write=FLastAccessDateGMT};
	__property System::TDateTime CreationDate = {read=FCreationDate, write=FCreationDate};
	__property System::TDateTime CreationDateGMT = {read=FCreationDateGMT, write=FCreationDateGMT};
	__property System::UnicodeString UniqueID = {read=FUniqueID, write=FUniqueID};
	__property ModifiedDateGMT = {default=0};
	__property unsigned WinAttribs = {read=FWinAttribs, write=FWinAttribs, nodefault};
	__property int WinDriveType = {read=FWinDriveType, write=FWinDriveType, nodefault};
	__property System::UnicodeString WinDriveLabel = {read=FWinDriveLabel, write=FWinDriveLabel};
	__property System::UnicodeString MLISTPermissions = {read=FMLISTPermissions, write=FMLISTPermissions};
	__property System::UnicodeString UnixOwnerPermissions = {read=FUnixOwnerPermissions, write=FUnixOwnerPermissions};
	__property System::UnicodeString UnixGroupPermissions = {read=FUnixGroupPermissions, write=FUnixGroupPermissions};
	__property System::UnicodeString UnixOtherPermissions = {read=FUnixOtherPermissions, write=FUnixOtherPermissions};
	__property int LinkCount = {read=FLinkCount, write=FLinkCount, nodefault};
	__property System::UnicodeString OwnerName = {read=FOwnerName, write=FOwnerName};
	__property System::UnicodeString GroupName = {read=FGroupName, write=FGroupName};
	__property System::UnicodeString LinkedItemName = {read=FLinkedItemName, write=FLinkedItemName};
	__property bool DirError = {read=FDirError, write=FDirError, nodefault};
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdFTPListOutputItem(void) { }
	
};


class DELPHICLASS TIdFTPListOutput;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPListOutput : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TIdFTPListOutputItem* operator[](int AIndex) { return Items[AIndex]; }
	
protected:
	System::UnicodeString FSwitches;
	System::UnicodeString FOutput;
	TIdDirOutputFormat FDirFormat;
	bool FExportTotalLine;
	virtual System::TDateTime __fastcall GetLocalModTime(TIdFTPListOutputItem* AItem);
	bool __fastcall HasSwitch(const System::UnicodeString ASwitch);
	virtual System::UnicodeString __fastcall UnixItem(TIdFTPListOutputItem* AItem);
	virtual System::UnicodeString __fastcall Win32Item(TIdFTPListOutputItem* AItem);
	virtual System::UnicodeString __fastcall EPLFItem(TIdFTPListOutputItem* AItem);
	virtual System::UnicodeString __fastcall NListItem(TIdFTPListOutputItem* AItem);
	virtual System::UnicodeString __fastcall MListItem(TIdFTPListOutputItem* AItem, TIdFTPFactOutputs AMLstOpts);
	virtual void __fastcall InternelOutputDir(System::Classes::TStrings* AOutput, bool ADetails = true);
	System::UnicodeString __fastcall UnixINodeOutput(TIdFTPListOutputItem* AItem);
	System::UnicodeString __fastcall UnixBlocksOutput(TIdFTPListOutputItem* AItem);
	System::UnicodeString __fastcall UnixGetOutputOwner(TIdFTPListOutputItem* AItem);
	System::UnicodeString __fastcall UnixGetOutputGroup(TIdFTPListOutputItem* AItem);
	System::UnicodeString __fastcall UnixGetOutputOwnerPerms(TIdFTPListOutputItem* AItem);
	System::UnicodeString __fastcall UnixGetOutputGroupPerms(TIdFTPListOutputItem* AItem);
	System::UnicodeString __fastcall UnixGetOutputOtherPerms(TIdFTPListOutputItem* AItem);
	TIdFTPListOutputItem* __fastcall GetItems(int AIndex);
	void __fastcall SetItems(int AIndex, TIdFTPListOutputItem* const AValue);
	
public:
	HIDESBASE TIdFTPListOutputItem* __fastcall Add(void);
	__fastcall TIdFTPListOutput(void);
	int __fastcall IndexOf(TIdFTPListOutputItem* AItem);
	__property TIdFTPListOutputItem* Items[int AIndex] = {read=GetItems, write=SetItems/*, default*/};
	virtual void __fastcall LISTOutputDir(System::Classes::TStrings* AOutput);
	virtual void __fastcall MLISTOutputDir(System::Classes::TStrings* AOutput, TIdFTPFactOutputs AMLstOpts);
	virtual void __fastcall NLISTOutputDir(System::Classes::TStrings* AOutput);
	__property TIdDirOutputFormat DirFormat = {read=FDirFormat, write=FDirFormat, nodefault};
	__property System::UnicodeString Switches = {read=FSwitches, write=FSwitches};
	__property System::UnicodeString Output = {read=FOutput, write=FOutput};
	__property bool ExportTotalLine = {read=FExportTotalLine, write=FExportTotalLine, nodefault};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TIdFTPListOutput(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
#define DEF_FILE_OWN_PERM L"rw-"
#define DEF_FILE_GRP_PERM L"rw-"
#define DEF_FILE_OTHER_PERM L"r--"
#define DEF_DIR_OWN_PERM L"rwx"
#define DEF_DIR_GRP_PERM L"rwx"
#define DEF_DIR_OTHER_PERM L"r-x"
#define DEF_OWNER L"root"
static const System::WideChar SWITCH_COLS_ACCROSS = (System::WideChar)(0x78);
static const System::WideChar SWITCH_COLS_DOWN = (System::WideChar)(0x43);
static const System::WideChar SWITCH_ONE_COL = (System::WideChar)(0x31);
static const System::WideChar SWITCH_ONE_DIR = (System::WideChar)(0x66);
static const System::WideChar SWITCH_COMMA_STREAM = (System::WideChar)(0x6d);
static const System::WideChar SWITCH_LONG_FORM = (System::WideChar)(0x6c);
static const System::WideChar SWITCH_RECURSIVE = (System::WideChar)(0x52);
static const System::WideChar SWITCH_SORT_REVERSE = (System::WideChar)(0x72);
static const System::WideChar SWITCH_SORTBY_MTIME = (System::WideChar)(0x74);
static const System::WideChar SWITCH_SORTBY_CTIME = (System::WideChar)(0x75);
static const System::WideChar SWITCH_SORTBY_EXT = (System::WideChar)(0x58);
static const System::WideChar SWITCH_SORTBY_SIZE = (System::WideChar)(0x53);
static const System::WideChar SWITCH_CLASSIFY = (System::WideChar)(0x46);
static const System::WideChar SWITCH_SLASHDIR = (System::WideChar)(0x70);
static const System::WideChar SWITCH_QUOTEDNAME = (System::WideChar)(0x51);
static const System::WideChar SWITCH_PRINT_BLOCKS = (System::WideChar)(0x73);
static const System::WideChar SWITCH_PRINT_INODE = (System::WideChar)(0x69);
static const System::WideChar SWITCH_SHOW_ALLPERIOD = (System::WideChar)(0x61);
static const System::WideChar SWITCH_HIDE_DIRPOINT = (System::WideChar)(0x41);
static const System::WideChar SWITCH_BOTH_TIME_YEAR = (System::WideChar)(0x54);
}	/* namespace Idftplistoutput */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDFTPLISTOUTPUT)
using namespace Idftplistoutput;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdftplistoutputHPP
