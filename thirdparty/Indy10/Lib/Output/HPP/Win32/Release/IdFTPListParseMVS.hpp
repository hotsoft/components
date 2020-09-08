// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdFTPListParseMVS.pas' rev: 25.00 (Windows)

#ifndef IdftplistparsemvsHPP
#define IdftplistparsemvsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdFTPList.hpp>	// Pascal unit
#include <IdFTPListParseBase.hpp>	// Pascal unit
#include <IdFTPListTypes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------
#pragma link "IdFTPListParseMVS"

namespace Idftplistparsemvs
{
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TIdJESJobStatus : unsigned char { IdJESNotApplicable, IdJESReceived, IdJESHold, IdJESRunning, IdJESOuptutAvailable };

class DELPHICLASS TIdMVSFTPListItem;
class PASCALIMPLEMENTATION TIdMVSFTPListItem : public Idftplisttypes::TIdRecFTPListItem
{
	typedef Idftplisttypes::TIdRecFTPListItem inherited;
	
protected:
	int FBlockSize;
	bool FMigrated;
	System::UnicodeString FVolume;
	System::UnicodeString FUnit;
	System::UnicodeString FOrg;
	int FMVSNumberExtents;
	int FMVSNumberTracks;
	
public:
	__fastcall virtual TIdMVSFTPListItem(System::Classes::TCollection* AOwner);
	__property bool Migrated = {read=FMigrated, write=FMigrated, nodefault};
	__property int BlockSize = {read=FBlockSize, write=FBlockSize, nodefault};
	__property RecLength;
	__property RecFormat = {default=0};
	__property NumberRecs;
	__property System::UnicodeString Volume = {read=FVolume, write=FVolume};
	__property System::UnicodeString Units = {read=FUnit, write=FUnit};
	__property System::UnicodeString Org = {read=FOrg, write=FOrg};
	__property int NumberExtents = {read=FMVSNumberExtents, write=FMVSNumberExtents, nodefault};
	__property int NumberTracks = {read=FMVSNumberTracks, write=FMVSNumberTracks, nodefault};
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdMVSFTPListItem(void) { }
	
};


class DELPHICLASS TIdMVSJESFTPListItem;
class PASCALIMPLEMENTATION TIdMVSJESFTPListItem : public Idftplisttypes::TIdOwnerFTPListItem
{
	typedef Idftplisttypes::TIdOwnerFTPListItem inherited;
	
protected:
	TIdJESJobStatus FMVSJobStatus;
	int FMVSJobSpoolFiles;
	
public:
	__fastcall virtual TIdMVSJESFTPListItem(System::Classes::TCollection* AOwner);
	__property TIdJESJobStatus JobStatus = {read=FMVSJobStatus, write=FMVSJobStatus, nodefault};
	__property int JobSpoolFiles = {read=FMVSJobSpoolFiles, write=FMVSJobSpoolFiles, nodefault};
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdMVSJESFTPListItem(void) { }
	
};


class DELPHICLASS TIdMVSJESIntF2FTPListItem;
class PASCALIMPLEMENTATION TIdMVSJESIntF2FTPListItem : public Idftplisttypes::TIdOwnerFTPListItem
{
	typedef Idftplisttypes::TIdOwnerFTPListItem inherited;
	
protected:
	TIdJESJobStatus FJobStatus;
	int FJobSpoolFiles;
	System::Classes::TStrings* FDetails;
	void __fastcall SetDetails(System::Classes::TStrings* AValue);
	
public:
	__fastcall virtual TIdMVSJESIntF2FTPListItem(System::Classes::TCollection* AOwner);
	__fastcall virtual ~TIdMVSJESIntF2FTPListItem(void);
	__property System::Classes::TStrings* Details = {read=FDetails, write=SetDetails};
	__property TIdJESJobStatus JobStatus = {read=FJobStatus, write=FJobStatus, nodefault};
	__property int JobSpoolFiles = {read=FJobSpoolFiles, write=FJobSpoolFiles, nodefault};
};


class DELPHICLASS TIdFTPLPMVS;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPMVS : public Idftplistparsebase::TIdFTPListBaseHeader
{
	typedef Idftplistparsebase::TIdFTPListBaseHeader inherited;
	
protected:
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	__classmethod virtual bool __fastcall IsHeader(const System::UnicodeString AData);
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPMVS(void) : Idftplistparsebase::TIdFTPListBaseHeader() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPMVS(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdFTPLPMVSPartitionedDataSet;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPMVSPartitionedDataSet : public Idftplistparsebase::TIdFTPListBaseHeader
{
	typedef Idftplistparsebase::TIdFTPListBaseHeader inherited;
	
protected:
	__classmethod virtual bool __fastcall IsHeader(const System::UnicodeString AData);
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPMVSPartitionedDataSet(void) : Idftplistparsebase::TIdFTPListBaseHeader() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPMVSPartitionedDataSet(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdFTPLPMVSJESInterface1;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPMVSJESInterface1 : public Idftplistparsebase::TIdFTPListBase
{
	typedef Idftplistparsebase::TIdFTPListBase inherited;
	
protected:
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	__classmethod virtual bool __fastcall IsMVS_JESNoJobsMsg(const System::UnicodeString AData);
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
	__classmethod virtual bool __fastcall CheckListing(System::Classes::TStrings* AListing, const System::UnicodeString ASysDescript = System::UnicodeString(), const bool ADetails = true);
	__classmethod virtual bool __fastcall ParseListing(System::Classes::TStrings* AListing, Idftplist::TIdFTPListItems* ADir);
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPMVSJESInterface1(void) : Idftplistparsebase::TIdFTPListBase() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPMVSJESInterface1(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdFTPLPMVSJESInterface2;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPMVSJESInterface2 : public Idftplistparsebase::TIdFTPListBase
{
	typedef Idftplistparsebase::TIdFTPListBase inherited;
	
protected:
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	__classmethod bool __fastcall IsMVS_JESIntF2Header(const System::UnicodeString AData);
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
	__classmethod virtual bool __fastcall CheckListing(System::Classes::TStrings* AListing, const System::UnicodeString ASysDescript = System::UnicodeString(), const bool ADetails = true);
	__classmethod virtual bool __fastcall ParseListing(System::Classes::TStrings* AListing, Idftplist::TIdFTPListItems* ADir);
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPMVSJESInterface2(void) : Idftplistparsebase::TIdFTPListBase() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPMVSJESInterface2(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idftplistparsemvs */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDFTPLISTPARSEMVS)
using namespace Idftplistparsemvs;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdftplistparsemvsHPP
