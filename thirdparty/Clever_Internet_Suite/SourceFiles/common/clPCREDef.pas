// ============================================================================
// Delphi-interface for Philip Hazel's PCRE Vr. 3.1
// Copyright (c) 1999, Juergen Haible. All Rights Reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
// ============================================================================

{$ALIGN ON}           // suggested
{$BOOLEVAL OFF}       // mandatory
{$LONGSTRINGS ON}     // mandatory
{$IOCHECKS ON}        // mandatory
{$EXTENDEDSYNTAX ON}  // mandatory
{$WRITEABLECONST OFF} // suggested
{$DEBUGINFO ON}       // suggested
{$LOCALSYMBOLS ON}    // suggested
{$REFERENCEINFO ON}   // suggested

unit clPCREDef; // Delphi-interface for Philip Hazel's PCRE Vr. 3.1

// ----------------------------------------------------------------------------
// Contains a Delphi-interface for:
//    Perl-Compatible Regular Expressions (PCRE) Vr. 3.1
//    Written by Philip Hazel (<ph10@cam.ac.uk>).
//    Copyright (c) 1997-2000 University of Cambridge
//    ftp://ftp.cus.cam.ac.uk/pub/software/programs/pcre/
// When using PCRE for own programs, be aware of its license (see below).
// ----------------------------------------------------------------------------


// ============================================================================
{
   PCRE LICENCE
   ------------

   PCRE is a library of functions to support regular expressions whose syntax
   and semantics are as close as possible to those of the Perl 5 language.

   Written by: Philip Hazel <ph10@cam.ac.uk>

   University of Cambridge Computing Service,
   Cambridge, England. Phone: +44 1223 334714.

   Copyright (c) 1997-2000 University of Cambridge

   Permission is granted to anyone to use this software for any purpose on any
   computer system, and to redistribute it freely, subject to the following
   restrictions:

   1. This software is distributed in the hope that it will be useful,
      but WITHOUT ANY WARRANTY; without even the implied warranty of
      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

   2. The origin of this software must not be misrepresented, either by
      explicit claim or by omission.

   3. Altered versions must be plainly marked as such, and must not be
      misrepresented as being the original software.

   4. If PCRE is embedded in any software that is released under the GNU
      General Purpose Licence (GPL), then the terms of that licence shall
      supersede any condition above with which it is incompatible.
}
// ============================================================================


{------------------------------------------------------------------------------

   Steps to create the needed object-files with Borland C++ Builder 3:

   1. Load and unzip PCRE-sources from:
      ftp://ftp.cus.cam.ac.uk/pub/software/programs/pcre/pcre-3.1.tar.gz

   2. Create config.h:
      rename config.in config.h
      change: #define HAVE_STRERROR 1
      change: #define HAVE_MEMMOVE  1

   3. Create pcre.h:
      rename pcre.in pcre.h
      change: #define PCRE_MAJOR 3
      change: #define PCRE_MINOR 1
      change: #define PCRE_DATE  09-Feb-2000
      (note: values taken from configure.in)

   4. Create chartables.c:
      bcc32 dftables.c
      dftables >chartables.c

   5. Create object-files:
      bcc32 -c -DSTATIC maketables.c
      bcc32 -c -DSTATIC get.c
      bcc32 -c -DSTATIC study.c
      bcc32 -c -DSTATIC pcre.c
      bcc32 -c -DSTATIC pcreposix.c

   6. Create pcretest and test object-files:
      bcc32 -DSTATIC pcretest.c pcre.obj get.obj study.obj maketables.obj pcreposix.obj
      pcretest testdata\testinput1 testtry
      fc testtry testdata\testoutput1
      pcretest -i testdata\testinput2 testtry
      fc testtry testdata\testoutput2
      pcretest testdata\testinput3 testtry
      fc testtry testdata\testoutput3

   The three object-files covered by this interface (pcre.obj, study.obj and
   [optionally] get.obj) are included with this distribution. They are built
   from the original sources with the steps and modifications noted above.

------------------------------------------------------------------------------}

interface

{$I clVer.inc}

{$IFNDEF DELPHIXE}
uses clWUtils;

{.$DEFINE PCRE_INCLUDE_GET} // remove dot to additionally link "get.obj"

const
   // Options
   PCRE_CASELESS       = $0001;
   PCRE_MULTILINE      = $0002;
   PCRE_DOTALL         = $0004;
   PCRE_EXTENDED       = $0008;
   PCRE_ANCHORED       = $0010;
   PCRE_DOLLAR_ENDONLY = $0020;
   PCRE_EXTRA          = $0040;
   PCRE_NOTBOL         = $0080;
   PCRE_NOTEOL         = $0100;
   PCRE_UNGREEDY       = $0200;
   PCRE_NOTEMPTY       = $0400;

   // Exec-time and get-time error codes
   PCRE_ERROR_NOMATCH      = (-1);
   PCRE_ERROR_NULL         = (-2);
   PCRE_ERROR_BADOPTION    = (-3);
   PCRE_ERROR_BADMAGIC     = (-4);
   PCRE_ERROR_UNKNOWN_NODE = (-5);
   PCRE_ERROR_NOMEMORY     = (-6);
   PCRE_ERROR_NOSUBSTRING  = (-7);

   // Request types for pcre_fullinfo()
   PCRE_INFO_OPTIONS      = 0;
   PCRE_INFO_SIZE         = 1;
   PCRE_INFO_CAPTURECOUNT = 2;
   PCRE_INFO_BACKREFMAX   = 3;
   PCRE_INFO_FIRSTCHAR    = 4;
   PCRE_INFO_FIRSTTABLE   = 5;
   PCRE_INFO_LASTLITERAL  = 6;

type
   // Types
   _pcre       = Pointer;
   _pcre_extra = Pointer;

   Int     = LongInt;
   PInt    = ^Int;
   PPChar  = ^PclChar;
   PPPChar = ^PPChar;

// Functions

// const char * pcre_version(void)
function _pcre_version: PclChar; cdecl; external;

// pcre * pcre_compile(const char *pattern, int options, const char **errorptr,
//   int *erroroffset, const unsigned char *tables)
function _pcre_compile( const pattern : PclChar;
                        options       : Int;
                        const errorptr: PPChar;
                        erroroffset   : PInt;
                        const tables  : PclChar ): _pcre; cdecl; external;

// int pcre_exec(const pcre *external_re, const pcre_extra *external_extra,
//   const char *subject, int length, int start_offset, int options,
//   int *offsets, int offsetcount)
function _pcre_exec( const external_re   : _pcre;
                     const external_extra: _pcre_extra;
                     const subject       : PclChar;
                     length              : Int;
                     startoffset         : Int;
                     options             : Int;
                     offsets             : PInt;
                     offsetcount         : Int ): Int; cdecl; external;

// int pcre_info(const pcre *external_re, int *optptr, int *first_char)
function _pcre_info( const external_re: _pcre;
                     optptr           : PInt;
                     first_char       : PInt ): Int; cdecl; external;

// int pcre_fullinfo(const pcre *external_re, const pcre_extra *study_data,
//       int what, void *where)
function _pcre_fullinfo( const external_re: _pcre;
                         const study_data : _pcre_extra;
                         what             : Int;
                         where            : Pointer ): Int; cdecl; external;

// pcre_extra * pcre_study(const pcre *external_re, int options,
//       const char **errorptr)
function _pcre_study( const external_re: _pcre;
                      options          : Int;
                      const errorptr   : PPChar ): _pcre_extra; cdecl; external;

{$IFDEF PCRE_INCLUDE_GET}
// int pcre_copy_substring(const char *subject, int *ovector, int stringcount,
//     int stringnumber, char *buffer, int size)
function _pcre_copy_substring( const subject: PclChar;
                               ovector      : PInt;
                               stringcount  : Int;
                               stringnumber : Int;
                               buffer       : PclChar;
                               size         : Int ): Int; cdecl; external;

// int pcre_get_substring(const char *subject, int *ovector, int stringcount,
//   int stringnumber, const char **stringptr)
function _pcre_get_substring( const subject  : PclChar;
                              ovector        : PInt;
                              stringcount    : Int;
                              stringnumber   : Int;
                              const stringptr: PPChar ): Int; cdecl; external;

// int pcre_get_substring_list(const char *subject, int *ovector,
//   int stringcount, const char ***listptr)
function _pcre_get_substring_list( const subject: PclChar;
                                   ovector      : PInt;
                                   stringcount  : Int;
                                   const listptr: PPPChar ): Int; cdecl; external;
{$ENDIF}

// ----------------------------------------------------------------------------

{$ENDIF}

implementation

{$IFNDEF DELPHIXE}
uses SysUtils;

// Link PCRE-objectfiles:

{$LINK pcre.obj}
{$LINK study.obj}
{$IFDEF PCRE_INCLUDE_GET}
{$LINK get.obj}
{$ENDIF}

// Declarations needed just to make compiler happy:

function _pcre_malloc( size: Cardinal ): Pointer; cdecl; external;
// procedure _pcre_free( block: Pointer ); cdecl; external;

// ----------------------------------------------------------------------------

// Replacements for functions of C-runtime-library used in PCRE:

type
   size_t = Cardinal;

// void *malloc(size_t size);
function _malloc( size: size_t ): Pointer; cdecl;
begin
   Result := AllocMem( size );
end;

// void free(void *block);
procedure _free( block: Pointer ); cdecl;
begin
   FreeMem( block );
end;

// void *memset(void *s, int c, size_t n);
function _memset( s: Pointer; c: Integer; n: size_t ): Pointer; cdecl;
begin
   FillChar( s^, n, c );
   Result := s;
end;

// void *memmove(void *dest, const void *src, size_t n);
function _memmove( dest: Pointer; src: Pointer; n: size_t ): Pointer; cdecl;
begin
   Move( src^, dest^, n );
   Result := dest;
end;

// void *memcpy(void *dest, const void *src, size_t n);
function _memcpy( dest: Pointer; src: Pointer; n: size_t ): Pointer; cdecl;
begin
   Move( src^, dest^, n );
   Result := dest;
end;

// char *strchr(const char *s, int c);
function _strchr( const s: PclChar; c: Integer ): PclChar; cdecl;
begin
   Result := StrScan( s, TclChar(c) );
end;

// int strncmp(const char *s1, const char *s2, size_t  maxlen);
function _strncmp( const s1, s2: PclChar; maxlen: size_t ): Integer; cdecl;
begin
   Result := StrLComp( s1, s2, maxlen );
end;

// ----------------------------------------------------------------------------

{$ENDIF}

end.



