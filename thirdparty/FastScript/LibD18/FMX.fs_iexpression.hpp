// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'FMX.fs_iexpression.pas' rev: 25.00 (Windows)

#ifndef Fmx_Fs_iexpressionHPP
#define Fmx_Fs_iexpressionHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <FMX.fs_iinterpreter.hpp>	// Pascal unit
#include <System.Variants.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Fmx
{
namespace Fs_iexpression
{
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TfsOperatorType : unsigned char { opNone, opGreat, opLess, opLessEq, opGreatEq, opNonEq, opEq, opPlus, opMinus, opOr, opXor, opMul, opDivFloat, opDivInt, opMod, opAnd, opShl, opShr, opLeftBracket, opRightBracket, opNot, opUnMinus, opIn, opIs };

class DELPHICLASS TfsExpressionNode;
class PASCALIMPLEMENTATION TfsExpressionNode : public Fmx::Fs_iinterpreter::TfsCustomVariable
{
	typedef Fmx::Fs_iinterpreter::TfsCustomVariable inherited;
	
private:
	TfsExpressionNode* FLeft;
	TfsExpressionNode* FRight;
	TfsExpressionNode* FParent;
	void __fastcall AddNode(TfsExpressionNode* Node);
	void __fastcall RemoveNode(TfsExpressionNode* Node);
	
public:
	__fastcall virtual ~TfsExpressionNode(void);
	virtual int __fastcall Priority(void) = 0 ;
public:
	/* TfsCustomVariable.Create */ inline __fastcall TfsExpressionNode(const System::UnicodeString AName, Fmx::Fs_iinterpreter::TfsVarType ATyp, const System::UnicodeString ATypeName) : Fmx::Fs_iinterpreter::TfsCustomVariable(AName, ATyp, ATypeName) { }
	
};


class DELPHICLASS TfsOperandNode;
class PASCALIMPLEMENTATION TfsOperandNode : public TfsExpressionNode
{
	typedef TfsExpressionNode inherited;
	
public:
	__fastcall TfsOperandNode(const System::Variant &AValue);
	virtual int __fastcall Priority(void);
public:
	/* TfsExpressionNode.Destroy */ inline __fastcall virtual ~TfsOperandNode(void) { }
	
};


class DELPHICLASS TfsOperatorNode;
class PASCALIMPLEMENTATION TfsOperatorNode : public TfsExpressionNode
{
	typedef TfsExpressionNode inherited;
	
private:
	TfsOperatorType FOp;
	bool FOptimizeInt;
	bool FOptimizeBool;
	
public:
	__fastcall TfsOperatorNode(TfsOperatorType Op);
	virtual int __fastcall Priority(void);
public:
	/* TfsExpressionNode.Destroy */ inline __fastcall virtual ~TfsOperatorNode(void) { }
	
};


class DELPHICLASS TfsDesignatorNode;
class PASCALIMPLEMENTATION TfsDesignatorNode : public TfsOperandNode
{
	typedef TfsOperandNode inherited;
	
private:
	Fmx::Fs_iinterpreter::TfsDesignator* FDesignator;
	Fmx::Fs_iinterpreter::TfsCustomVariable* FVar;
	
protected:
	virtual System::Variant __fastcall GetValue(void);
	
public:
	__fastcall TfsDesignatorNode(Fmx::Fs_iinterpreter::TfsDesignator* ADesignator);
	__fastcall virtual ~TfsDesignatorNode(void);
};


class DELPHICLASS TfsSetNode;
class PASCALIMPLEMENTATION TfsSetNode : public TfsOperandNode
{
	typedef TfsOperandNode inherited;
	
private:
	Fmx::Fs_iinterpreter::TfsSetExpression* FSetExpression;
	
protected:
	virtual System::Variant __fastcall GetValue(void);
	
public:
	__fastcall TfsSetNode(Fmx::Fs_iinterpreter::TfsSetExpression* ASet);
	__fastcall virtual ~TfsSetNode(void);
};


class DELPHICLASS TfsExpression;
class PASCALIMPLEMENTATION TfsExpression : public Fmx::Fs_iinterpreter::TfsCustomExpression
{
	typedef Fmx::Fs_iinterpreter::TfsCustomExpression inherited;
	
private:
	TfsExpressionNode* FCurNode;
	TfsExpressionNode* FNode;
	Fmx::Fs_iinterpreter::TfsScript* FScript;
	System::UnicodeString FSource;
	void __fastcall AddOperand(TfsExpressionNode* Node);
	
protected:
	virtual System::Variant __fastcall GetValue(void);
	virtual void __fastcall SetValue(const System::Variant &Value);
	
public:
	__fastcall TfsExpression(Fmx::Fs_iinterpreter::TfsScript* Script);
	__fastcall virtual ~TfsExpression(void);
	void __fastcall AddConst(const System::Variant &AValue);
	void __fastcall AddDesignator(Fmx::Fs_iinterpreter::TfsDesignator* ADesignator);
	void __fastcall AddOperator(const System::UnicodeString Op);
	void __fastcall AddSet(Fmx::Fs_iinterpreter::TfsSetExpression* ASet);
	System::UnicodeString __fastcall Finalize(void);
	System::UnicodeString __fastcall Optimize(Fmx::Fs_iinterpreter::TfsDesignator* Designator);
	Fmx::Fs_iinterpreter::TfsCustomVariable* __fastcall SingleItem(void);
	__property System::UnicodeString Source = {read=FSource, write=FSource};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Fs_iexpression */
}	/* namespace Fmx */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FMX_FS_IEXPRESSION)
using namespace Fmx::Fs_iexpression;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FMX)
using namespace Fmx;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Fmx_Fs_iexpressionHPP
