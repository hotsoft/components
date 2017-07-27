// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'FMX.fs_ievents.pas' rev: 25.00 (Windows)

#ifndef Fmx_Fs_ieventsHPP
#define Fmx_Fs_ieventsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <FMX.Controls.hpp>	// Pascal unit
#include <FMX.Forms.hpp>	// Pascal unit
#include <System.UITypes.hpp>	// Pascal unit
#include <FMX.Types.hpp>	// Pascal unit
#include <System.Types.hpp>	// Pascal unit
#include <System.Rtti.hpp>	// Pascal unit
#include <FMX.fs_iinterpreter.hpp>	// Pascal unit
#include <FMX.fs_iclassesrtti.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Fmx
{
namespace Fs_ievents
{
//-- type declarations -------------------------------------------------------
typedef Fmx::Types::TDragObject *PDragObject;

class DELPHICLASS TfsDragObject;
class PASCALIMPLEMENTATION TfsDragObject : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	Fmx::Types::TDragObject FDragObject;
	System::Classes::TStringList* FFiles;
	System::Classes::TStringList* __fastcall GetStringList(void);
	
public:
	Fmx::Types::TDragObject __fastcall GetRect(void);
	PDragObject __fastcall GetRectP(void);
	__fastcall TfsDragObject(const Fmx::Types::TDragObject &aDragObj);
	__fastcall virtual ~TfsDragObject(void);
	
__published:
	__property System::TObject* Source = {read=FDragObject.Source, write=FDragObject.Source};
	
public:
	__property System::Rtti::TValue Data = {read=FDragObject.Data, write=FDragObject.Data};
	
__published:
	__property System::Classes::TStringList* Files = {read=GetStringList};
};


class DELPHICLASS TfsNotifyEvent;
class PASCALIMPLEMENTATION TfsNotifyEvent : public Fmx::Fs_iinterpreter::TfsCustomEvent
{
	typedef Fmx::Fs_iinterpreter::TfsCustomEvent inherited;
	
public:
	void __fastcall DoEvent(System::TObject* Sender);
	virtual void * __fastcall GetMethod(void);
public:
	/* TfsCustomEvent.Create */ inline __fastcall virtual TfsNotifyEvent(System::TObject* AObject, Fmx::Fs_iinterpreter::TfsProcVariable* AHandler) : Fmx::Fs_iinterpreter::TfsCustomEvent(AObject, AHandler) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsNotifyEvent(void) { }
	
};


class DELPHICLASS TfsMouseEvent;
class PASCALIMPLEMENTATION TfsMouseEvent : public Fmx::Fs_iinterpreter::TfsCustomEvent
{
	typedef Fmx::Fs_iinterpreter::TfsCustomEvent inherited;
	
public:
	void __fastcall DoEvent(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, float X, float Y);
	virtual void * __fastcall GetMethod(void);
public:
	/* TfsCustomEvent.Create */ inline __fastcall virtual TfsMouseEvent(System::TObject* AObject, Fmx::Fs_iinterpreter::TfsProcVariable* AHandler) : Fmx::Fs_iinterpreter::TfsCustomEvent(AObject, AHandler) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsMouseEvent(void) { }
	
};


class DELPHICLASS TfsMouseMoveEvent;
class PASCALIMPLEMENTATION TfsMouseMoveEvent : public Fmx::Fs_iinterpreter::TfsCustomEvent
{
	typedef Fmx::Fs_iinterpreter::TfsCustomEvent inherited;
	
public:
	void __fastcall DoEvent(System::TObject* Sender, System::Classes::TShiftState Shift, float X, float Y);
	virtual void * __fastcall GetMethod(void);
public:
	/* TfsCustomEvent.Create */ inline __fastcall virtual TfsMouseMoveEvent(System::TObject* AObject, Fmx::Fs_iinterpreter::TfsProcVariable* AHandler) : Fmx::Fs_iinterpreter::TfsCustomEvent(AObject, AHandler) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsMouseMoveEvent(void) { }
	
};


class DELPHICLASS TfsMouseWheelEvent;
class PASCALIMPLEMENTATION TfsMouseWheelEvent : public Fmx::Fs_iinterpreter::TfsCustomEvent
{
	typedef Fmx::Fs_iinterpreter::TfsCustomEvent inherited;
	
public:
	void __fastcall DoEvent(System::TObject* Sender, System::Classes::TShiftState Shift, int WheelDelta, bool &Handled);
	virtual void * __fastcall GetMethod(void);
public:
	/* TfsCustomEvent.Create */ inline __fastcall virtual TfsMouseWheelEvent(System::TObject* AObject, Fmx::Fs_iinterpreter::TfsProcVariable* AHandler) : Fmx::Fs_iinterpreter::TfsCustomEvent(AObject, AHandler) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsMouseWheelEvent(void) { }
	
};


class DELPHICLASS TfsOnPaintEvent;
class PASCALIMPLEMENTATION TfsOnPaintEvent : public Fmx::Fs_iinterpreter::TfsCustomEvent
{
	typedef Fmx::Fs_iinterpreter::TfsCustomEvent inherited;
	
public:
	void __fastcall DoEvent(System::TObject* Sender, Fmx::Types::TCanvas* Canvas, const System::Types::TRectF &ARect);
	virtual void * __fastcall GetMethod(void);
public:
	/* TfsCustomEvent.Create */ inline __fastcall virtual TfsOnPaintEvent(System::TObject* AObject, Fmx::Fs_iinterpreter::TfsProcVariable* AHandler) : Fmx::Fs_iinterpreter::TfsCustomEvent(AObject, AHandler) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsOnPaintEvent(void) { }
	
};


class DELPHICLASS TfsCanFocusEvent;
class PASCALIMPLEMENTATION TfsCanFocusEvent : public Fmx::Fs_iinterpreter::TfsCustomEvent
{
	typedef Fmx::Fs_iinterpreter::TfsCustomEvent inherited;
	
public:
	void __fastcall DoEvent(System::TObject* Sender, bool &ACanFocus);
	virtual void * __fastcall GetMethod(void);
public:
	/* TfsCustomEvent.Create */ inline __fastcall virtual TfsCanFocusEvent(System::TObject* AObject, Fmx::Fs_iinterpreter::TfsProcVariable* AHandler) : Fmx::Fs_iinterpreter::TfsCustomEvent(AObject, AHandler) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsCanFocusEvent(void) { }
	
};


class DELPHICLASS TfsDragOverEvent;
class PASCALIMPLEMENTATION TfsDragOverEvent : public Fmx::Fs_iinterpreter::TfsCustomEvent
{
	typedef Fmx::Fs_iinterpreter::TfsCustomEvent inherited;
	
public:
	void __fastcall DoEvent(System::TObject* Sender, const Fmx::Types::TDragObject &Data, const System::Types::TPointF Point, bool &Accept);
	virtual void * __fastcall GetMethod(void);
public:
	/* TfsCustomEvent.Create */ inline __fastcall virtual TfsDragOverEvent(System::TObject* AObject, Fmx::Fs_iinterpreter::TfsProcVariable* AHandler) : Fmx::Fs_iinterpreter::TfsCustomEvent(AObject, AHandler) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsDragOverEvent(void) { }
	
};


class DELPHICLASS TfsDragDropEvent;
class PASCALIMPLEMENTATION TfsDragDropEvent : public Fmx::Fs_iinterpreter::TfsCustomEvent
{
	typedef Fmx::Fs_iinterpreter::TfsCustomEvent inherited;
	
public:
	void __fastcall DoEvent(System::TObject* Sender, const Fmx::Types::TDragObject &Data, const System::Types::TPointF Point);
	virtual void * __fastcall GetMethod(void);
public:
	/* TfsCustomEvent.Create */ inline __fastcall virtual TfsDragDropEvent(System::TObject* AObject, Fmx::Fs_iinterpreter::TfsProcVariable* AHandler) : Fmx::Fs_iinterpreter::TfsCustomEvent(AObject, AHandler) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsDragDropEvent(void) { }
	
};


class DELPHICLASS TfsKeyEvent;
class PASCALIMPLEMENTATION TfsKeyEvent : public Fmx::Fs_iinterpreter::TfsCustomEvent
{
	typedef Fmx::Fs_iinterpreter::TfsCustomEvent inherited;
	
public:
	void __fastcall DoEvent(System::TObject* Sender, System::Word &Key, System::WideChar &KeyChar, System::Classes::TShiftState Shift);
	virtual void * __fastcall GetMethod(void);
public:
	/* TfsCustomEvent.Create */ inline __fastcall virtual TfsKeyEvent(System::TObject* AObject, Fmx::Fs_iinterpreter::TfsProcVariable* AHandler) : Fmx::Fs_iinterpreter::TfsCustomEvent(AObject, AHandler) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsKeyEvent(void) { }
	
};


class DELPHICLASS TfsKeyPressEvent;
class PASCALIMPLEMENTATION TfsKeyPressEvent : public Fmx::Fs_iinterpreter::TfsCustomEvent
{
	typedef Fmx::Fs_iinterpreter::TfsCustomEvent inherited;
	
public:
	void __fastcall DoEvent(System::TObject* Sender, System::WideChar &Key);
	virtual void * __fastcall GetMethod(void);
public:
	/* TfsCustomEvent.Create */ inline __fastcall virtual TfsKeyPressEvent(System::TObject* AObject, Fmx::Fs_iinterpreter::TfsProcVariable* AHandler) : Fmx::Fs_iinterpreter::TfsCustomEvent(AObject, AHandler) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsKeyPressEvent(void) { }
	
};


class DELPHICLASS TfsCloseEvent;
class PASCALIMPLEMENTATION TfsCloseEvent : public Fmx::Fs_iinterpreter::TfsCustomEvent
{
	typedef Fmx::Fs_iinterpreter::TfsCustomEvent inherited;
	
public:
	void __fastcall DoEvent(System::TObject* Sender, System::Uitypes::TCloseAction &Action);
	virtual void * __fastcall GetMethod(void);
public:
	/* TfsCustomEvent.Create */ inline __fastcall virtual TfsCloseEvent(System::TObject* AObject, Fmx::Fs_iinterpreter::TfsProcVariable* AHandler) : Fmx::Fs_iinterpreter::TfsCustomEvent(AObject, AHandler) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsCloseEvent(void) { }
	
};


class DELPHICLASS TfsCloseQueryEvent;
class PASCALIMPLEMENTATION TfsCloseQueryEvent : public Fmx::Fs_iinterpreter::TfsCustomEvent
{
	typedef Fmx::Fs_iinterpreter::TfsCustomEvent inherited;
	
public:
	void __fastcall DoEvent(System::TObject* Sender, bool &CanClose);
	virtual void * __fastcall GetMethod(void);
public:
	/* TfsCustomEvent.Create */ inline __fastcall virtual TfsCloseQueryEvent(System::TObject* AObject, Fmx::Fs_iinterpreter::TfsProcVariable* AHandler) : Fmx::Fs_iinterpreter::TfsCustomEvent(AObject, AHandler) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsCloseQueryEvent(void) { }
	
};


class DELPHICLASS TfsCanResizeEvent;
class PASCALIMPLEMENTATION TfsCanResizeEvent : public Fmx::Fs_iinterpreter::TfsCustomEvent
{
	typedef Fmx::Fs_iinterpreter::TfsCustomEvent inherited;
	
public:
	void __fastcall DoEvent(System::TObject* Sender, int &NewWidth, int &NewHeight, bool &Resize);
	virtual void * __fastcall GetMethod(void);
public:
	/* TfsCustomEvent.Create */ inline __fastcall virtual TfsCanResizeEvent(System::TObject* AObject, Fmx::Fs_iinterpreter::TfsProcVariable* AHandler) : Fmx::Fs_iinterpreter::TfsCustomEvent(AObject, AHandler) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsCanResizeEvent(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Fs_ievents */
}	/* namespace Fmx */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FMX_FS_IEVENTS)
using namespace Fmx::Fs_ievents;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FMX)
using namespace Fmx;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Fmx_Fs_ieventsHPP
