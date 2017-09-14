// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwdatsrc.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwdatsrcHPP
#define Vcl_WwdatsrcHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Data.DB.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwdatsrc
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwDataSource;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TwwDataSource : public Data::Db::TDataSource
{
	typedef Data::Db::TDataSource inherited;
	
public:
	/* TDataSource.Create */ inline __fastcall virtual TwwDataSource(System::Classes::TComponent* AOwner) : Data::Db::TDataSource(AOwner) { }
	/* TDataSource.Destroy */ inline __fastcall virtual ~TwwDataSource(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall Register(void);
}	/* namespace Wwdatsrc */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWDATSRC)
using namespace Vcl::Wwdatsrc;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwdatsrcHPP
