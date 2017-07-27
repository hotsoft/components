// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'fs_iilparser.pas' rev: 25.00 (Windows)

#ifndef Fs_iilparserHPP
#define Fs_iilparserHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <fs_iinterpreter.hpp>	// Pascal unit
#include <fs_iparser.hpp>	// Pascal unit
#include <fs_iexpression.hpp>	// Pascal unit
#include <fs_xml.hpp>	// Pascal unit
#include <System.Variants.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Fs_iilparser
{
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TfsEmitOp : unsigned char { emNone, emCreate, emFree };

class DELPHICLASS TfsILParser;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsILParser : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::UnicodeString FErrorPos;
	Fs_xml::TfsXMLDocument* FGrammar;
	Fs_xml::TfsXMLDocument* FILScript;
	System::UnicodeString FLangName;
	bool FNeedDeclareVars;
	Fs_iparser::TfsParser* FParser;
	Fs_iinterpreter::TfsScript* FProgram;
	Fs_xml::TfsXMLItem* FProgRoot;
	Fs_xml::TfsXMLItem* FRoot;
	System::UnicodeString FUnitName;
	System::Classes::TStrings* FUsesList;
	System::Classes::TStringList* FWithList;
	System::UnicodeString __fastcall PropPos(Fs_xml::TfsXMLItem* xi);
	void __fastcall ErrorPos(Fs_xml::TfsXMLItem* xi);
	void __fastcall CheckIdent(Fs_iinterpreter::TfsScript* Prog, const System::UnicodeString Name);
	Fs_iinterpreter::TfsClassVariable* __fastcall FindClass(const System::UnicodeString TypeName);
	void __fastcall CheckTypeCompatibility(Fs_iinterpreter::TfsCustomVariable* Var1, Fs_iinterpreter::TfsCustomVariable* Var2);
	Fs_iinterpreter::TfsCustomVariable* __fastcall FindVar(Fs_iinterpreter::TfsScript* Prog, const System::UnicodeString Name);
	Fs_iinterpreter::TfsVarType __fastcall FindType(System::UnicodeString s);
	Fs_iinterpreter::TfsCustomVariable* __fastcall CreateVar(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsScript* Prog, const System::UnicodeString Name, Fs_iinterpreter::TfsStatement* Statement = (Fs_iinterpreter::TfsStatement*)(0x0), bool CreateParam = false, bool IsVarParam = false);
	Fs_iinterpreter::TfsSetExpression* __fastcall DoSet(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsScript* Prog);
	Fs_iexpression::TfsExpression* __fastcall DoExpression(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsScript* Prog);
	void __fastcall DoUses(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsScript* Prog);
	void __fastcall DoVar(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsScript* Prog, Fs_iinterpreter::TfsStatement* Statement);
	void __fastcall DoConst(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsScript* Prog);
	void __fastcall DoParameters(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsProcVariable* v);
	void __fastcall DoProc1(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsScript* Prog);
	void __fastcall DoProc2(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsScript* Prog);
	void __fastcall DoFunc1(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsScript* Prog);
	void __fastcall DoFunc2(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsScript* Prog);
	void __fastcall DoAssign(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsScript* Prog, Fs_iinterpreter::TfsStatement* Statement);
	void __fastcall DoCall(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsScript* Prog, Fs_iinterpreter::TfsStatement* Statement);
	void __fastcall DoIf(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsScript* Prog, Fs_iinterpreter::TfsStatement* Statement);
	void __fastcall DoFor(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsScript* Prog, Fs_iinterpreter::TfsStatement* Statement);
	void __fastcall DoVbFor(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsScript* Prog, Fs_iinterpreter::TfsStatement* Statement);
	void __fastcall DoCppFor(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsScript* Prog, Fs_iinterpreter::TfsStatement* Statement);
	void __fastcall DoWhile(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsScript* Prog, Fs_iinterpreter::TfsStatement* Statement);
	void __fastcall DoRepeat(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsScript* Prog, Fs_iinterpreter::TfsStatement* Statement);
	void __fastcall DoCase(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsScript* Prog, Fs_iinterpreter::TfsStatement* Statement);
	void __fastcall DoTry(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsScript* Prog, Fs_iinterpreter::TfsStatement* Statement);
	void __fastcall DoBreak(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsScript* Prog, Fs_iinterpreter::TfsStatement* Statement);
	void __fastcall DoContinue(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsScript* Prog, Fs_iinterpreter::TfsStatement* Statement);
	void __fastcall DoExit(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsScript* Prog, Fs_iinterpreter::TfsStatement* Statement);
	void __fastcall DoReturn(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsScript* Prog, Fs_iinterpreter::TfsStatement* Statement);
	void __fastcall DoWith(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsScript* Prog, Fs_iinterpreter::TfsStatement* Statement);
	void __fastcall DoDelete(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsScript* Prog, Fs_iinterpreter::TfsStatement* Statement);
	void __fastcall DoCompoundStmt(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsScript* Prog, Fs_iinterpreter::TfsStatement* Statement);
	void __fastcall DoStmt(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsScript* Prog, Fs_iinterpreter::TfsStatement* Statement);
	void __fastcall DoProgram(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsScript* Prog);
	
public:
	__fastcall TfsILParser(Fs_iinterpreter::TfsScript* AProgram);
	__fastcall virtual ~TfsILParser(void);
	void __fastcall SelectLanguage(const System::UnicodeString LangName);
	bool __fastcall MakeILScript(const System::UnicodeString Text);
	void __fastcall ParseILScript(void);
	Fs_iinterpreter::TfsDesignator* __fastcall DoDesignator(Fs_xml::TfsXMLItem* xi, Fs_iinterpreter::TfsScript* Prog, TfsEmitOp EmitOp = (TfsEmitOp)(0x0));
	__property Fs_xml::TfsXMLDocument* ILScript = {read=FILScript};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Fs_iilparser */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FS_IILPARSER)
using namespace Fs_iilparser;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Fs_iilparserHPP
