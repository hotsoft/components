// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdZLibHeaders.pas' rev: 25.00 (Windows)

#ifndef IdzlibheadersHPP
#define IdzlibheadersHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdCTypes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------
// For Win32, we use some .obj files.  These .objs were compiled from the ZLib
// source-code folder with "make -f contrib\delphi\zlibd32.mak" using Borland
// "make" and "bcc32".  The .objs are compiled with the
// "-DZEXPORT=__fastcall -DZEXPORTVA=__cdecl"  parameter.  Do NOT change
// the function calling conventions unless you know what you are doing and
// the C++ objects are compiled appropriately.
//
// The only things that still are cdecl are the callback functions.

#define ZEXPORT __cdecl
#define ZEXPORTVA __cdecl
#if !defined(__MACTYPES__)
  // We are defining __MACTYPES__ in order to skip the declaration of "Byte" as it causes
  // ambiguity with System::Byte
  #define __MACTYPES__
  #define __REMOVE_MACTYPES__
#endif
#if defined(__USE_ZLIBH__)
  #include "ZLib\zlib.h"
#else
typedef void * __cdecl (*alloc_func)(void * opaque, unsigned items, unsigned size);

typedef void __cdecl (*free_func)(void * opaque, void * address);

#pragma pack(push,1)
struct DECLSPEC_DRECORD z_stream
{
	
public:
	char *next_in;
	unsigned avail_in;
	unsigned long total_in;
	char *next_out;
	unsigned avail_out;
	unsigned long total_out;
	char *msg;
	void *state;
	alloc_func zalloc;
	free_func zfree;
	void *opaque;
	int data_type;
	unsigned long adler;
	unsigned long reserved;
};
#pragma pack(pop)

#if !defined(__clang__) && !defined(__CPP__)
#if sizeof(z_stream) < 56
#pragma message "Pascal/C++ size mismatch: (C++) sizeof(z_stream) < (Pascal) [size: 56, align: 1] (WARNING)"
#pragma sizeof(z_stream)
#endif

#if sizeof(z_stream) > 56
#pragma message "Pascal/C++ size mismatch: (C++) sizeof(z_stream) > (Pascal) [size: 56, align: 1] (WARNING)"
#pragma sizeof(z_stream)
#endif

#if alignof(z_stream) < 1
#pragma message "Pascal/C++ alignment mismatch: (C++) alignof(z_stream) < (Pascal) [size: 56, align: 1] (WARNING)"
#endif

#if alignof(z_stream) > 1
#pragma message "Pascal/C++ alignment mismatch: (C++) alignof(z_stream) > (Pascal) [size: 56, align: 1] (WARNING)"
#endif
#endif


struct gz_header;
typedef gz_header *gz_headerp;

#pragma pack(push,1)
struct DECLSPEC_DRECORD gz_header
{
	
public:
	int text;
	unsigned long time;
	int xflags;
	int os;
	System::Byte *extra;
	unsigned extra_len;
	unsigned extra_max;
	char *name;
	unsigned name_max;
	char *comment;
	unsigned comm_max;
	int hcrc;
	int done;
};
#pragma pack(pop)

#if !defined(__clang__) && !defined(__CPP__)
#if sizeof(gz_header) < 52
#pragma message "Pascal/C++ size mismatch: (C++) sizeof(gz_header) < (Pascal) [size: 52, align: 1] (WARNING)"
#pragma sizeof(gz_header)
#endif

#if sizeof(gz_header) > 52
#pragma message "Pascal/C++ size mismatch: (C++) sizeof(gz_header) > (Pascal) [size: 52, align: 1] (WARNING)"
#pragma sizeof(gz_header)
#endif

#if alignof(gz_header) < 1
#pragma message "Pascal/C++ alignment mismatch: (C++) alignof(gz_header) < (Pascal) [size: 52, align: 1] (WARNING)"
#endif

#if alignof(gz_header) > 1
#pragma message "Pascal/C++ alignment mismatch: (C++) alignof(gz_header) > (Pascal) [size: 52, align: 1] (WARNING)"
#endif
#endif
#endif
#if defined(__REMOVE_MACTYPES__)
  // Cleanup workaround for "Byte" ambiguity
  #if defined(__MACTYPES__)
    #undef __MACTYPES__
  #endif
  #undef __REMOVE_MACTYPES__
#endif

namespace Idzlibheaders
{
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TZStreamType : unsigned char { zsZLib, zsGZip, zsRaw };

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idzlibheaders */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDZLIBHEADERS)
using namespace Idzlibheaders;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdzlibheadersHPP
