// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdFTPListParseMusic.pas' rev: 25.00 (Windows)

#ifndef IdftplistparsemusicHPP
#define IdftplistparsemusicHPP

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
#pragma link "IdFTPListParseMusic"

namespace Idftplistparsemusic
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdMusicFTPListItem;
class PASCALIMPLEMENTATION TIdMusicFTPListItem : public Idftplisttypes::TIdRecFTPListItem
{
	typedef Idftplisttypes::TIdRecFTPListItem inherited;
	
protected:
	System::UnicodeString FOwnerName;
	
public:
	__property System::UnicodeString OwnerName = {read=FOwnerName, write=FOwnerName};
	__property RecLength;
	__property RecFormat = {default=0};
	__property NumberRecs;
public:
	/* TIdFTPListItem.Create */ inline __fastcall virtual TIdMusicFTPListItem(System::Classes::TCollection* AOwner) : Idftplisttypes::TIdRecFTPListItem(AOwner) { }
	
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdMusicFTPListItem(void) { }
	
};


class DELPHICLASS TIdFTPLPMusic;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFTPLPMusic : public Idftplistparsebase::TIdFTPListBaseHeader
{
	typedef Idftplistparsebase::TIdFTPListBaseHeader inherited;
	
protected:
	__classmethod virtual Idftplist::TIdFTPListItem* __fastcall MakeNewItem(Idftplist::TIdFTPListItems* AOwner);
	__classmethod virtual bool __fastcall IsHeader(const System::UnicodeString AData);
	__classmethod virtual bool __fastcall ParseLine(Idftplist::TIdFTPListItem* const AItem, const System::UnicodeString APath = System::UnicodeString());
	
public:
	__classmethod virtual System::UnicodeString __fastcall GetIdent();
public:
	/* TObject.Create */ inline __fastcall TIdFTPLPMusic(void) : Idftplistparsebase::TIdFTPListBaseHeader() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdFTPLPMusic(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idftplistparsemusic */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDFTPLISTPARSEMUSIC)
using namespace Idftplistparsemusic;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdftplistparsemusicHPP
