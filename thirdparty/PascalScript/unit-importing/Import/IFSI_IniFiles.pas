unit IFSI_IniFiles;
{
This file has been generated by UnitParser v0.4b, written by M. Knight
and updated by NP. v/d Spek.
Source Code from Carlo Kok has been used to implement various sections of
UnitParser. Components of ifps3 are used in the construction of UnitParser,
code implementing the class wrapper is taken from Carlo Kok''s conv unility

}
{$I ifps3_def.inc}
interface
 
uses
   SysUtils
  ,Classes
  ,IFPS3CompExec
  ,ifpscomp
  ,ifps3
  ;
 
type 
(*----------------------------------------------------------------------------*)
  TIFPS3CE_IniFiles = class(TIFPS3Plugin)
  protected
    procedure CompOnUses(CompExec: TIFPS3CompExec); override;
    procedure ExecOnUses(CompExec: TIFPS3CompExec); override;
    procedure CompileImport1(CompExec: TIFPS3CompExec); override;
    procedure CompileImport2(CompExec: TIFPS3CompExec); override;
    procedure ExecImport1(CompExec: TIFPS3CompExec; const ri: TIFPSRuntimeClassImporter); override;
    procedure ExecImport2(CompExec: TIFPS3CompExec; const ri: TIFPSRuntimeClassImporter); override;
  end;
 
 
(*
{ compile-time registration functions }
procedure SIRegister_TMemIniFile(CL: TIFPSPascalCompiler);
procedure SIRegister_TIniFile(CL: TIFPSPascalCompiler);
procedure SIRegister_TCustomIniFile(CL: TIFPSPascalCompiler);
procedure SIRegister_IniFiles(CL: TIFPSPascalCompiler);
 
{ run-time registration functions }
procedure RIRegister_TMemIniFile(CL: TIFPSRuntimeClassImporter);
procedure RIRegister_TIniFile(CL: TIFPSRuntimeClassImporter);
procedure RIRegister_TCustomIniFile(CL: TIFPSRuntimeClassImporter);
procedure RIRegister_IniFiles(CL: TIFPSRuntimeClassImporter);
*)


implementation


uses
   Windows
  ,IniFiles
  ;
 
 
{ compile-time importer function }
(*----------------------------------------------------------------------------
 Sometimes the CL.AddClassN() fails to correctly register a class, 
 for unknown (at least to me) reasons
 So, you may use the below RegClassS() replacing the CL.AddClassN()
 of the various SIRegister_XXXX calls 
 ----------------------------------------------------------------------------*)
function RegClassS(CL: TIFPSPascalCompiler; const InheritsFrom, Classname: string): TIFPSCompileTimeClass;
begin
  Result := CL.FindClass(Classname);
  if Result = nil then
    Result := CL.AddClassN(CL.FindClass(InheritsFrom), Classname)
  else Result.ClassInheritsFrom := CL.FindClass(InheritsFrom);
end;
  
  
(* === compile-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure SIRegister_TMemIniFile(CL: TIFPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomIniFile', 'TMemIniFile') do
  with CL.AddClassN(CL.FindClass('TCustomIniFile'),'TMemIniFile') do
  begin
    RegisterMethod('Constructor Create( const FileName : string)');
    RegisterMethod('Procedure Clear');
    RegisterMethod('Procedure GetStrings( List : TStrings)');
    RegisterMethod('Procedure Rename( const FileName : string; Reload : Boolean)');
    RegisterMethod('Procedure SetStrings( List : TStrings)');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TIniFile(CL: TIFPSPascalCompiler);
begin
  //with RegClassS(CL,'TCustomIniFile', 'TIniFile') do
  with CL.AddClassN(CL.FindClass('TCustomIniFile'),'TIniFile') do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_TCustomIniFile(CL: TIFPSPascalCompiler);
begin
  //with RegClassS(CL,'TObject', 'TCustomIniFile') do
  with CL.AddClassN(CL.FindClass('TObject'),'TCustomIniFile') do
  begin
    RegisterMethod('Constructor Create( const FileName : string)');
    RegisterMethod('Function SectionExists( const Section : string) : Boolean');
    RegisterMethod('Function ReadString( const Section, Ident, Default : string) : string');
    RegisterMethod('Procedure WriteString( const Section, Ident, Value : String)');
    RegisterMethod('Function ReadInteger( const Section, Ident : string; Default : Longint) : Longint');
    RegisterMethod('Procedure WriteInteger( const Section, Ident : string; Value : Longint)');
    RegisterMethod('Function ReadBool( const Section, Ident : string; Default : Boolean) : Boolean');
    RegisterMethod('Procedure WriteBool( const Section, Ident : string; Value : Boolean)');
    RegisterMethod('Function ReadDate( const Section, Name : string; Default : TDateTime) : TDateTime');
    RegisterMethod('Function ReadDateTime( const Section, Name : string; Default : TDateTime) : TDateTime');
    RegisterMethod('Function ReadFloat( const Section, Name : string; Default : Double) : Double');
    RegisterMethod('Function ReadTime( const Section, Name : string; Default : TDateTime) : TDateTime');
    RegisterMethod('Procedure WriteDate( const Section, Name : string; Value : TDateTime)');
    RegisterMethod('Procedure WriteDateTime( const Section, Name : string; Value : TDateTime)');
    RegisterMethod('Procedure WriteFloat( const Section, Name : string; Value : Double)');
    RegisterMethod('Procedure WriteTime( const Section, Name : string; Value : TDateTime)');
    RegisterMethod('Procedure ReadSection( const Section : string; Strings : TStrings)');
    RegisterMethod('Procedure ReadSections( Strings : TStrings)');
    RegisterMethod('Procedure ReadSectionValues( const Section : string; Strings : TStrings)');
    RegisterMethod('Procedure EraseSection( const Section : string)');
    RegisterMethod('Procedure DeleteKey( const Section, Ident : String)');
    RegisterMethod('Procedure UpdateFile');
    RegisterMethod('Function ValueExists( const Section, Ident : string) : Boolean');
    RegisterProperty('FileName', 'string', iptr);
  end;
end;

(*----------------------------------------------------------------------------*)
procedure SIRegister_IniFiles(CL: TIFPSPascalCompiler);
begin
  SIRegister_TCustomIniFile(CL);
  SIRegister_TIniFile(CL);
  SIRegister_TMemIniFile(CL);
end;

(* === run-time registration functions === *)
(*----------------------------------------------------------------------------*)
procedure TCustomIniFileFileName_R(Self: TCustomIniFile; var T: string);
begin T := Self.FileName; end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TMemIniFile(CL: TIFPSRuntimeClassImporter);
begin
  with CL.Add(TMemIniFile) do
  begin
    RegisterConstructor(@TMemIniFile.Create, 'Create');
    RegisterMethod(@TMemIniFile.Clear, 'Clear');
    RegisterMethod(@TMemIniFile.GetStrings, 'GetStrings');
    RegisterMethod(@TMemIniFile.Rename, 'Rename');
    RegisterMethod(@TMemIniFile.SetStrings, 'SetStrings');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TIniFile(CL: TIFPSRuntimeClassImporter);
begin
  with CL.Add(TIniFile) do
  begin
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_TCustomIniFile(CL: TIFPSRuntimeClassImporter);
begin
  with CL.Add(TCustomIniFile) do
  begin
    RegisterConstructor(@TCustomIniFile.Create, 'Create');
    RegisterMethod(@TCustomIniFile.SectionExists, 'SectionExists');
    RegisterVirtualAbstractMethod(@TCustomIniFile, @!.ReadString, 'ReadString');
    RegisterVirtualAbstractMethod(@TCustomIniFile, @!.WriteString, 'WriteString');
    RegisterVirtualMethod(@TCustomIniFile.ReadInteger, 'ReadInteger');
    RegisterVirtualMethod(@TCustomIniFile.WriteInteger, 'WriteInteger');
    RegisterVirtualMethod(@TCustomIniFile.ReadBool, 'ReadBool');
    RegisterVirtualMethod(@TCustomIniFile.WriteBool, 'WriteBool');
    RegisterVirtualMethod(@TCustomIniFile.ReadDate, 'ReadDate');
    RegisterVirtualMethod(@TCustomIniFile.ReadDateTime, 'ReadDateTime');
    RegisterVirtualMethod(@TCustomIniFile.ReadFloat, 'ReadFloat');
    RegisterVirtualMethod(@TCustomIniFile.ReadTime, 'ReadTime');
    RegisterVirtualMethod(@TCustomIniFile.WriteDate, 'WriteDate');
    RegisterVirtualMethod(@TCustomIniFile.WriteDateTime, 'WriteDateTime');
    RegisterVirtualMethod(@TCustomIniFile.WriteFloat, 'WriteFloat');
    RegisterVirtualMethod(@TCustomIniFile.WriteTime, 'WriteTime');
    RegisterVirtualAbstractMethod(@TCustomIniFile, @!.ReadSection, 'ReadSection');
    RegisterVirtualAbstractMethod(@TCustomIniFile, @!.ReadSections, 'ReadSections');
    RegisterVirtualAbstractMethod(@TCustomIniFile, @!.ReadSectionValues, 'ReadSectionValues');
    RegisterVirtualAbstractMethod(@TCustomIniFile, @!.EraseSection, 'EraseSection');
    RegisterVirtualAbstractMethod(@TCustomIniFile, @!.DeleteKey, 'DeleteKey');
    RegisterVirtualAbstractMethod(@TCustomIniFile, @!.UpdateFile, 'UpdateFile');
    RegisterMethod(@TCustomIniFile.ValueExists, 'ValueExists');
    RegisterPropertyHelper(@TCustomIniFileFileName_R,nil,'FileName');
  end;
end;

(*----------------------------------------------------------------------------*)
procedure RIRegister_IniFiles(CL: TIFPSRuntimeClassImporter);
begin
  RIRegister_TCustomIniFile(CL);
  RIRegister_TIniFile(CL);
  RIRegister_TMemIniFile(CL);
end;

 
 
{ TIFPS3CE_IniFiles }
(*----------------------------------------------------------------------------*)
procedure TIFPS3CE_IniFiles.CompOnUses(CompExec: TIFPS3CompExec);
begin
  { nothing } 
end;
(*----------------------------------------------------------------------------*)
procedure TIFPS3CE_IniFiles.ExecOnUses(CompExec: TIFPS3CompExec);
begin
  { nothing } 
end;
(*----------------------------------------------------------------------------*)
procedure TIFPS3CE_IniFiles.CompileImport1(CompExec: TIFPS3CompExec);
begin
  SIRegister_IniFiles(CompExec.Comp);
end;
(*----------------------------------------------------------------------------*)
procedure TIFPS3CE_IniFiles.CompileImport2(CompExec: TIFPS3CompExec);
begin
  { nothing } 
end;
(*----------------------------------------------------------------------------*)
procedure TIFPS3CE_IniFiles.ExecImport1(CompExec: TIFPS3CompExec; const ri: TIFPSRuntimeClassImporter);
begin
  RIRegister_IniFiles(ri);
end;
(*----------------------------------------------------------------------------*)
procedure TIFPS3CE_IniFiles.ExecImport2(CompExec: TIFPS3CompExec; const ri: TIFPSRuntimeClassImporter);
begin
  { nothing } 
end;
 
 
initialization
 (**) 
{$IFDEF USEIMPORTER}
CIImporter.AddCallBack(@SIRegister_IniFiles,PT_ClassImport);
{$ENDIF}
finalization
 (**) 
 
end.
