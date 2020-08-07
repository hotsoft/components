// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdContainers.pas' rev: 25.00 (Windows)

#ifndef IdcontainersHPP
#define IdcontainersHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <System.Contnrs.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idcontainers
{
//-- type declarations -------------------------------------------------------
typedef int __fastcall (*TIdSortCompare)(System::TObject* AItem1, System::TObject* AItem2);

class DELPHICLASS TIdObjectList;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdObjectList : public System::Contnrs::TObjectList
{
	typedef System::Contnrs::TObjectList inherited;
	
public:
	void __fastcall BubbleSort(TIdSortCompare ACompare);
	HIDESBASE void __fastcall Assign(TIdObjectList* Source);
public:
	/* TObjectList.Create */ inline __fastcall TIdObjectList(void)/* overload */ : System::Contnrs::TObjectList() { }
	/* TObjectList.Create */ inline __fastcall TIdObjectList(bool AOwnsObjects)/* overload */ : System::Contnrs::TObjectList(AOwnsObjects) { }
	
public:
	/* TList.Destroy */ inline __fastcall virtual ~TIdObjectList(void) { }
	
};

#pragma pack(pop)

typedef int __fastcall (*TIdStringListSortCompare)(System::Classes::TStringList* List, int Index1, int Index2);

class DELPHICLASS TIdBubbleSortStringList;
class PASCALIMPLEMENTATION TIdBubbleSortStringList : public System::Classes::TStringList
{
	typedef System::Classes::TStringList inherited;
	
public:
	virtual void __fastcall BubbleSort(TIdStringListSortCompare ACompare);
public:
	/* TStringList.Create */ inline __fastcall TIdBubbleSortStringList(void)/* overload */ : System::Classes::TStringList() { }
	/* TStringList.Create */ inline __fastcall TIdBubbleSortStringList(bool OwnsObjects)/* overload */ : System::Classes::TStringList(OwnsObjects) { }
	/* TStringList.Destroy */ inline __fastcall virtual ~TIdBubbleSortStringList(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idcontainers */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDCONTAINERS)
using namespace Idcontainers;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdcontainersHPP
