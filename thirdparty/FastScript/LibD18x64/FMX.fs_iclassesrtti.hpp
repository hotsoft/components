// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'FMX.fs_iclassesrtti.pas' rev: 25.00 (Windows)

#ifndef Fmx_Fs_iclassesrttiHPP
#define Fmx_Fs_iclassesrttiHPP

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
#include <FMX.fs_xml.hpp>	// Pascal unit
#include <System.Types.hpp>	// Pascal unit
#include <FMX.Types.hpp>	// Pascal unit
#include <System.UITypes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Fmx
{
namespace Fs_iclassesrtti
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TfsClassesRTTI;
class PASCALIMPLEMENTATION TfsClassesRTTI : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
public:
	/* TComponent.Create */ inline __fastcall virtual TfsClassesRTTI(System::Classes::TComponent* AOwner) : System::Classes::TComponent(AOwner) { }
	/* TComponent.Destroy */ inline __fastcall virtual ~TfsClassesRTTI(void) { }
	
};


class DELPHICLASS TfsRectF;
class PASCALIMPLEMENTATION TfsRectF : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::Types::TRectF FRectF;
	float __fastcall GetBottom(void);
	float __fastcall GetLeft(void);
	float __fastcall GetRight(void);
	float __fastcall GetTop(void);
	void __fastcall SetBottom(const float Value);
	void __fastcall SetLeft(const float Value);
	void __fastcall SetRight(const float Value);
	void __fastcall SetTop(const float Value);
	
public:
	System::Types::TRectF __fastcall GetRect(void);
	System::Types::PRectF __fastcall GetRectP(void);
	__fastcall TfsRectF(const System::Types::TRectF &aRectF);
	
__published:
	__property float Left = {read=GetLeft, write=SetLeft};
	__property float Top = {read=GetTop, write=SetTop};
	__property float Right = {read=GetRight, write=SetRight};
	__property float Bottom = {read=GetBottom, write=SetBottom};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TfsRectF(void) { }
	
};


class DELPHICLASS TfsMatrix;
class PASCALIMPLEMENTATION TfsMatrix : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::Types::TMatrix FMatrix;
	float __fastcall Getm11(void);
	float __fastcall Getm12(void);
	float __fastcall Getm13(void);
	float __fastcall Getm21(void);
	float __fastcall Getm22(void);
	float __fastcall Getm23(void);
	float __fastcall Getm31(void);
	float __fastcall Getm32(void);
	float __fastcall Getm33(void);
	void __fastcall Setm11(const float Value);
	void __fastcall Setm12(const float Value);
	void __fastcall Setm13(const float Value);
	void __fastcall Setm21(const float Value);
	void __fastcall Setm22(const float Value);
	void __fastcall Setm23(const float Value);
	void __fastcall Setm31(const float Value);
	void __fastcall Setm32(const float Value);
	void __fastcall Setm33(const float Value);
	
public:
	void __fastcall AssignToRect(System::Types::TMatrix &Rect);
	void __fastcall AssignFromRect(const System::Types::TMatrix &Rect);
	System::Types::TMatrix __fastcall GetRect(void);
	__fastcall TfsMatrix(const System::Types::TMatrix &aMatrix);
	
__published:
	__property float m11 = {read=Getm11, write=Setm11};
	__property float m12 = {read=Getm12, write=Setm12};
	__property float m13 = {read=Getm13, write=Setm13};
	__property float m21 = {read=Getm21, write=Setm21};
	__property float m22 = {read=Getm22, write=Setm22};
	__property float m23 = {read=Getm23, write=Setm23};
	__property float m31 = {read=Getm31, write=Setm31};
	__property float m32 = {read=Getm32, write=Setm32};
	__property float m33 = {read=Getm33, write=Setm33};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TfsMatrix(void) { }
	
};


class DELPHICLASS TfsPointF;
class PASCALIMPLEMENTATION TfsPointF : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::Types::TPointF FPointF;
	float __fastcall GetX(void);
	float __fastcall GetY(void);
	void __fastcall SetX(const float Value);
	void __fastcall SetY(const float Value);
	
public:
	System::Types::TPointF __fastcall GetRect(void);
	System::Types::PPointF __fastcall GetRectP(void);
	__fastcall TfsPointF(System::Types::TPointF aPointF);
	
__published:
	__property float pX = {read=GetX, write=SetX};
	__property float pY = {read=GetY, write=SetY};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TfsPointF(void) { }
	
};


typedef System::Types::TVector *PVector;

class DELPHICLASS TfsVector;
class PASCALIMPLEMENTATION TfsVector : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::Types::TVector FVector;
	float __fastcall GetW(void);
	float __fastcall GetX(void);
	float __fastcall GetY(void);
	void __fastcall SetW(const float Value);
	void __fastcall SetX(const float Value);
	void __fastcall SetY(const float Value);
	
public:
	System::Types::TVector __fastcall GetRect(void);
	PVector __fastcall GetRectP(void);
	__fastcall TfsVector(const System::Types::TVector &aVector);
	
__published:
	__property float pX = {read=GetX, write=SetX};
	__property float pY = {read=GetY, write=SetY};
	__property float pW = {read=GetW, write=SetW};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TfsVector(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Fs_iclassesrtti */
}	/* namespace Fmx */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FMX_FS_ICLASSESRTTI)
using namespace Fmx::Fs_iclassesrtti;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FMX)
using namespace Fmx;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Fmx_Fs_iclassesrttiHPP
