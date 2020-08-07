// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdDICTCommon.pas' rev: 25.00 (Windows)

#ifndef IddictcommonHPP
#define IddictcommonHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Iddictcommon
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdMatchItem;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdMatchItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
protected:
	System::UnicodeString FDB;
	System::UnicodeString FWord;
	
__published:
	__property System::UnicodeString DB = {read=FDB, write=FDB};
	__property System::UnicodeString Word = {read=FWord, write=FWord};
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TIdMatchItem(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdMatchItem(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdMatchList;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdMatchList : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TIdMatchItem* operator[](int AIndex) { return Items[AIndex]; }
	
protected:
	TIdMatchItem* __fastcall GetItems(int AIndex);
	void __fastcall SetItems(int AIndex, TIdMatchItem* const AValue);
	
public:
	__fastcall virtual TIdMatchList(void);
	int __fastcall IndexOf(TIdMatchItem* AItem);
	HIDESBASE TIdMatchItem* __fastcall Add(void);
	__property TIdMatchItem* Items[int AIndex] = {read=GetItems, write=SetItems/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TIdMatchList(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdGeneric;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdGeneric : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
protected:
	System::UnicodeString FName;
	System::UnicodeString FDesc;
	
__published:
	__property System::UnicodeString Name = {read=FName, write=FName};
	__property System::UnicodeString Desc = {read=FDesc, write=FDesc};
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TIdGeneric(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdGeneric(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdStrategy;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdStrategy : public TIdGeneric
{
	typedef TIdGeneric inherited;
	
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TIdStrategy(System::Classes::TCollection* Collection) : TIdGeneric(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdStrategy(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdStrategyList;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdStrategyList : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TIdStrategy* operator[](int AIndex) { return Items[AIndex]; }
	
protected:
	TIdStrategy* __fastcall GetItems(int AIndex);
	void __fastcall SetItems(int AIndex, TIdStrategy* const AValue);
	
public:
	__fastcall virtual TIdStrategyList(void);
	int __fastcall IndexOf(TIdStrategy* AItem);
	HIDESBASE TIdStrategy* __fastcall Add(void);
	__property TIdStrategy* Items[int AIndex] = {read=GetItems, write=SetItems/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TIdStrategyList(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdDBInfo;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdDBInfo : public TIdGeneric
{
	typedef TIdGeneric inherited;
	
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TIdDBInfo(System::Classes::TCollection* Collection) : TIdGeneric(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdDBInfo(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdDBList;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdDBList : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TIdDBInfo* operator[](int AIndex) { return Items[AIndex]; }
	
protected:
	TIdDBInfo* __fastcall GetItems(int AIndex);
	void __fastcall SetItems(int AIndex, TIdDBInfo* const AValue);
	
public:
	__fastcall virtual TIdDBList(void);
	int __fastcall IndexOf(TIdDBInfo* AItem);
	HIDESBASE TIdDBInfo* __fastcall Add(void);
	__property TIdDBInfo* Items[int AIndex] = {read=GetItems, write=SetItems/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TIdDBList(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdDefinition;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdDefinition : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
protected:
	System::UnicodeString FWord;
	System::Classes::TStrings* FDefinition;
	TIdDBInfo* FDB;
	void __fastcall SetDefinition(System::Classes::TStrings* AValue);
	
public:
	__fastcall virtual TIdDefinition(System::Classes::TCollection* AOwner);
	__fastcall virtual ~TIdDefinition(void);
	
__published:
	__property System::UnicodeString Word = {read=FWord, write=FWord};
	__property TIdDBInfo* DB = {read=FDB, write=FDB};
	__property System::Classes::TStrings* Definition = {read=FDefinition, write=SetDefinition};
};

#pragma pack(pop)

class DELPHICLASS TIdDefinitions;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdDefinitions : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TIdDefinition* operator[](int AIndex) { return Items[AIndex]; }
	
protected:
	TIdDefinition* __fastcall GetItems(int AIndex);
	void __fastcall SetItems(int AIndex, TIdDefinition* const AValue);
	
public:
	__fastcall virtual TIdDefinitions(void);
	int __fastcall IndexOf(TIdDefinition* AItem);
	HIDESBASE TIdDefinition* __fastcall Add(void);
	__property TIdDefinition* Items[int AIndex] = {read=GetItems, write=SetItems/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TIdDefinitions(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Iddictcommon */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDDICTCOMMON)
using namespace Iddictcommon;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IddictcommonHPP
