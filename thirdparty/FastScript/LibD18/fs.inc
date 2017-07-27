
{******************************************}
{                                          }
{             FastScript v1.9              }
{               Include file               }
{                                          }
{ (c) 2003, 2004 by Alexander Tzyganenko,  }
{             Fast Reports, Inc            }
{                                          }
{******************************************}


{$R-} {- Range-Checking }
{$H+} {- Use long strings by default }
{$B-} {- Complete Boolean Evaluation }
{$T-} {- Typed @ operator }
{$P+} {- Open string params }

{$IFNDEF FPC}
  {$V-} {- Var-String Checking }
  {$X+} {- Extended syntax }
  {$J+} {- Writeable structured consts }
{$ENDIF}

{$IFDEF VER120}      // Delphi 4.0
  {$DEFINE Delphi4}
{$ENDIF}

{$IFDEF VER130}      // Delphi 5.0
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}         
{$ENDIF}

{$IFDEF VER140}      // Delphi 6.0
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
{$ENDIF}

{$IFDEF VER150}      // Delphi 7.0
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
{$ENDIF}

{$IFDEF VER170}      // Delphi 9.0
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER180}      // Delphi 10.0
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER185}      // Delphi 11.0 (Spacely)
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER190}      // Delphi 11.0 (Highlander)
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
{$ENDIF}

{$IFDEF VER200}      // Delphi 12.0 (Tiburon)
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN EXPLICIT_STRING_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST_LOSS OFF}
//  {$WARNINGS OFF}
{$ENDIF}

{$IFDEF VER210}      // Delphi 14.0
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi14}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN EXPLICIT_STRING_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$ENDIF}

{$IFDEF VER220}      // Delphi XE
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN EXPLICIT_STRING_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$ENDIF}

{$IFDEF VER230}      // Delphi XE 2
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN EXPLICIT_STRING_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$ENDIF}

{$IFDEF VER240}      // Delphi XE 3
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE Delphi17}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN EXPLICIT_STRING_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$ENDIF}

{$IFDEF VER250}      // Delphi XE 4
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE Delphi17}
  {$DEFINE Delphi18}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN EXPLICIT_STRING_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$ENDIF}

{$IFDEF VER260}      // Delphi XE 4
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE Delphi17}
  {$DEFINE Delphi18}
  {$DEFINE Delphi19}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN EXPLICIT_STRING_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$ENDIF}

{$IFDEF VER270}      // Delphi XE 6
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE Delphi17}
  {$DEFINE Delphi18}
  {$DEFINE Delphi19}
  {$DEFINE Delphi20}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN EXPLICIT_STRING_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$ENDIF}

{$IFDEF VER280}      // Delphi XE 7
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE Delphi17}
  {$DEFINE Delphi18}
  {$DEFINE Delphi19}
  {$DEFINE Delphi20}
  {$DEFINE Delphi21}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN EXPLICIT_STRING_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$ENDIF}

{$IFDEF VER290}      // Delphi XE 8
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE Delphi17}
  {$DEFINE Delphi18}
  {$DEFINE Delphi19}
  {$DEFINE Delphi20}
  {$DEFINE Delphi21}
  {$DEFINE Delphi22}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN EXPLICIT_STRING_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$ENDIF}

{$IFDEF VER300}      // Delphi 10 Seattle
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE Delphi17}
  {$DEFINE Delphi18}
  {$DEFINE Delphi19}
  {$DEFINE Delphi20}
  {$DEFINE Delphi21}
  {$DEFINE Delphi22}
  {$DEFINE Delphi23}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN EXPLICIT_STRING_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$ENDIF}

{$IFDEF VER310}
  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
  {$DEFINE Delphi7}
  {$DEFINE Delphi9}
  {$DEFINE Delphi10}
  {$DEFINE Delphi11}
  {$DEFINE Delphi12}
  {$DEFINE Delphi14}
  {$DEFINE Delphi15}
  {$DEFINE Delphi16}
  {$DEFINE Delphi17}
  {$DEFINE Delphi18}
  {$DEFINE Delphi19}
  {$DEFINE Delphi20}
  {$DEFINE Delphi21}
  {$DEFINE Delphi22}
  {$DEFINE Delphi23}
  {$DEFINE Delphi24}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
  {$WARN SYMBOL_DEPRECATED OFF}
  {$WARN EXPLICIT_STRING_CAST OFF}
  {$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$ENDIF}

{$IFDEF VER125}      // Borland C++ Builder 4.0
  {$DEFINE Delphi4}
  {$ObjExportAll on}
{$ENDIF}

{$IFDEF VER130}      // Borland C++ Builder 5.0
 {$IFDEF BCB}
  {$ObjExportAll on}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER140}      // Borland C++ Builder 6.0
 {$IFDEF BCB}
  {$ObjExportAll on}
 {$ENDIF}
{$ENDIF}

{$IFDEF VER150}      // Borland C++ Builder 7.0
 {$IFDEF BCB}
  {$ObjExportAll on}
 {$ENDIF}
{$ENDIF}

{$IFDEF FPC} // Free pascal compiler
  {$MODE DELPHI}
  {$PACKSET 1}

  {$DEFINE Delphi4}
  {$DEFINE Delphi5}
  {$DEFINE Delphi6}
{$ELSE}
  {$IFDEF LINUX}      // KYLIX
    {$DEFINE Delphi4}
    {$DEFINE Delphi5}
    {$DEFINE Delphi6}
    {$DEFINE CLX}
    {$IFDEF BCB}
      {$DEFINE CLXCPP}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}

{$IFNDEF LINUX}
  {$DEFINE WINDOWS} 
{$ENDIF}

{$IFDEF FPC}
  {$DEFINE CROSS_COMPILE}
{$ENDIF}

{$IFDEF CLX}
  {$DEFINE CROSS_COMPILE}
{$ENDIF}

// Uncomment below line for CLX compilation
//{$DEFINE CLX}

// include ole dispatch module
{$IFNDEF CROSS_COMPILE}
{$IFNDEF FMX}
{$DEFINE OLE}
{$ENDIF}
{$ENDIF}
//{$DEFINE NOFORMS}
