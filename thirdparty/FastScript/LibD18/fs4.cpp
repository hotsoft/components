//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("FS4.res");
USEPACKAGE("vcl40.bpi");
USEPACKAGE("vclx40.bpi");
USEUNIT("fs_iReg.pas");
USEUNIT("fs_iconst.pas");
USERES("fs_iReg.dcr");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------
//   Package source.
//---------------------------------------------------------------------------
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
        return 1;
}
//---------------------------------------------------------------------------
