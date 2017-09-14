// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwprovider.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwproviderHPP
#define Vcl_WwproviderHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Datasnap.Provider.hpp>
#include <System.Variants.hpp>
#include <vcl.Wwcommon.hpp>
#include <Data.DB.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwprovider
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwProvider;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TwwProvider : public Datasnap::Provider::TProvider
{
	typedef Datasnap::Provider::TProvider inherited;
	
public:
	/* TDataSetProvider.Create */ inline __fastcall virtual TwwProvider(System::Classes::TComponent* AOwner) : Datasnap::Provider::TProvider(AOwner) { }
	/* TDataSetProvider.Destroy */ inline __fastcall virtual ~TwwProvider(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Wwprovider */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWPROVIDER)
using namespace Vcl::Wwprovider;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwproviderHPP
