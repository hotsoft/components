//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("FS4.res");
USEPACKAGE("vcl40.bpi");
USEPACKAGE("vcldb40.bpi");
USEPACKAGE("fs4.bpi");
USEPACKAGE("fsDB4.bpi");
USEUNIT("fs_ibdereg.pas");
USERES("fs_ireg.dcr");
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
