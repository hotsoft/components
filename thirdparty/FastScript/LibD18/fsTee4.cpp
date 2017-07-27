//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("FS4.res");
USEPACKAGE("vcl40.bpi");
USEPACKAGE("vclx40.bpi");
USEPACKAGE("tee40.bpi");
USEPACKAGE("fs4.bpi");
USEUNIT("fs_iteeReg.pas");
USEUNIT("fs_ichartrtti.pas");
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
