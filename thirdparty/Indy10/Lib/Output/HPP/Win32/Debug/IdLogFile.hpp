// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdLogFile.pas' rev: 25.00 (Windows)

#ifndef IdlogfileHPP
#define IdlogfileHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdLogBase.hpp>	// Pascal unit
#include <IdIntercept.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idlogfile
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdLogFile;
class PASCALIMPLEMENTATION TIdLogFile : public Idlogbase::TIdLogBase
{
	typedef Idlogbase::TIdLogBase inherited;
	
protected:
	System::UnicodeString FFilename;
	System::Classes::TStream* FFileStream;
	virtual void __fastcall LogFormat(const System::UnicodeString AFormat, System::TVarRec const *AArgs, const int AArgs_Size);
	virtual void __fastcall LogReceivedData(const System::UnicodeString AText, const System::UnicodeString AData);
	virtual void __fastcall LogSentData(const System::UnicodeString AText, const System::UnicodeString AData);
	virtual void __fastcall LogStatus(const System::UnicodeString AText);
	virtual void __fastcall LogWriteString(const System::UnicodeString AText);
	void __fastcall SetFilename(const System::UnicodeString AFilename);
	
public:
	virtual void __fastcall Open(void);
	virtual void __fastcall Close(void);
	
__published:
	__property System::UnicodeString Filename = {read=FFilename, write=SetFilename};
public:
	/* TIdLogBase.Destroy */ inline __fastcall virtual ~TIdLogFile(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdLogFile(System::Classes::TComponent* AOwner)/* overload */ : Idlogbase::TIdLogBase(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdLogFile(void)/* overload */ : Idlogbase::TIdLogBase() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idlogfile */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDLOGFILE)
using namespace Idlogfile;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdlogfileHPP
