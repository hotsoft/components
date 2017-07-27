// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'FMX.fs_tree.pas' rev: 25.00 (Windows)

#ifndef Fmx_Fs_treeHPP
#define Fmx_Fs_treeHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <FMX.Types.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <FMX.Controls.hpp>	// Pascal unit
#include <FMX.Forms.hpp>	// Pascal unit
#include <FMX.Dialogs.hpp>	// Pascal unit
#include <FMX.ExtCtrls.hpp>	// Pascal unit
#include <FMX.fs_synmemo.hpp>	// Pascal unit
#include <FMX.Objects.hpp>	// Pascal unit
#include <FMX.fs_xml.hpp>	// Pascal unit
#include <FMX.fs_iinterpreter.hpp>	// Pascal unit
#include <FMX.TreeView.hpp>	// Pascal unit
#include <FMX.Memo.hpp>	// Pascal unit
#include <System.UITypes.hpp>	// Pascal unit
#include <System.Types.hpp>	// Pascal unit
#include <FMX.StdCtrls.hpp>	// Pascal unit
#include <FMX.Layouts.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Fmx
{
namespace Fs_tree
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TfsTreeViewItem;
class PASCALIMPLEMENTATION TfsTreeViewItem : public Fmx::Treeview::TTreeViewItem
{
	typedef Fmx::Treeview::TTreeViewItem inherited;
	
private:
	Fmx::Stdctrls::TCustomButton* FButton;
	int FCloseImageIndex;
	int FOpenImageIndex;
	float FImgPos;
	Fmx::Types::TBitmap* __fastcall GetBitmap(void);
	
protected:
	virtual void __fastcall ApplyStyle(void);
	
public:
	__fastcall virtual TfsTreeViewItem(System::Classes::TComponent* AOwner);
	virtual void __fastcall Paint(void);
	__property int CloseImageIndex = {read=FCloseImageIndex, write=FCloseImageIndex, nodefault};
	__property int OpenImageIndex = {read=FOpenImageIndex, write=FOpenImageIndex, nodefault};
public:
	/* TTreeViewItem.Destroy */ inline __fastcall virtual ~TfsTreeViewItem(void) { }
	
};


class DELPHICLASS TfsTreeView;
class PASCALIMPLEMENTATION TfsTreeView : public Fmx::Treeview::TTreeView
{
	typedef Fmx::Treeview::TTreeView inherited;
	
private:
	Fmx::Types::TBitmap* FPicBitmap;
	int FIconWidth;
	int FIconHeight;
	
public:
	__fastcall virtual TfsTreeView(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfsTreeView(void);
	void __fastcall LoadResouces(System::Classes::TStream* Stream, int IconWidth, int IconHeight);
	__property Fmx::Types::TBitmap* PicPitmap = {read=FPicBitmap, write=FPicBitmap};
	__property int IconWidth = {read=FIconWidth, write=FIconWidth, nodefault};
	__property int IconHeight = {read=FIconHeight, write=FIconHeight, nodefault};
	System::Types::TRectF __fastcall GetBitmapRect(int Index);
	virtual void __fastcall DragOver(const Fmx::Types::TDragObject &Data, const System::Types::TPointF Point, bool &Accept);
	virtual void __fastcall DragDrop(const Fmx::Types::TDragObject &Data, const System::Types::TPointF Point);
	
__published:
	__property StyleLookup;
	__property CanFocus = {default=1};
	__property DisableFocusEffect = {default=1};
	__property TabOrder = {default=-1};
	__property AllowDrag = {default=0};
	__property AlternatingRowBackground = {default=0};
	__property ItemHeight = {default=0};
	__property MultiSelect = {default=0};
	__property ShowCheckboxes = {default=0};
	__property Sorted = {default=0};
	__property OnChange;
	__property OnChangeCheck;
	__property OnCompare;
	__property OnDragChange;
};


class DELPHICLASS TfsTree;
class PASCALIMPLEMENTATION TfsTree : public Fmx::Stdctrls::TPanel
{
	typedef Fmx::Stdctrls::TPanel inherited;
	
private:
	TfsTreeView* Tree;
	Fmx::Fs_xml::TfsXMLDocument* FXML;
	Fmx::Fs_iinterpreter::TfsScript* FScript;
	System::Classes::TList* FImages;
	bool FShowFunctions;
	bool FShowClasses;
	bool FShowTypes;
	bool FShowVariables;
	bool FExpanded;
	int FExpandLevel;
	Fmx::Fs_synmemo::TfsSyntaxMemo* FMemo;
	bool FUpdating;
	void __fastcall FillTree(void);
	void __fastcall SetMemo(Fmx::Fs_synmemo::TfsSyntaxMemo* Value);
	void __fastcall SetScript(Fmx::Fs_iinterpreter::TfsScript* const Value);
	
protected:
	void __fastcall CreateImageFromRes(Fmx::Objects::TImage* Image, Fmx::Types::TBitmap* Bmp, int Width, int Height, int Index);
	void __fastcall TreeChange(System::TObject* Sender, Fmx::Treeview::TTreeViewItem* Node);
	void __fastcall TreeDblClick(System::TObject* Sender);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall Loaded(void);
	
public:
	__fastcall virtual TfsTree(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfsTree(void);
	void __fastcall SetColor(System::Uitypes::TAlphaColor Color);
	void __fastcall UpdateItems(void);
	System::UnicodeString __fastcall GetFieldName(void);
	
__published:
	__property Align = {default=0};
	__property Anchors;
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property PopupMenu;
	__property Fmx::Fs_iinterpreter::TfsScript* Script = {read=FScript, write=SetScript};
	__property ShowHint = {default=0};
	__property TabOrder = {default=-1};
	__property Visible = {default=1};
	__property Fmx::Fs_synmemo::TfsSyntaxMemo* SyntaxMemo = {read=FMemo, write=SetMemo};
	__property bool ShowClasses = {read=FShowClasses, write=FShowClasses, nodefault};
	__property bool ShowFunctions = {read=FShowFunctions, write=FShowFunctions, nodefault};
	__property bool ShowTypes = {read=FShowTypes, write=FShowTypes, nodefault};
	__property bool ShowVariables = {read=FShowVariables, write=FShowVariables, nodefault};
	__property bool Expanded = {read=FExpanded, write=FExpanded, nodefault};
	__property int ExpandLevel = {read=FExpandLevel, write=FExpandLevel, nodefault};
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property Left = {default=0};
	__property Top = {default=0};
	__property Width;
	__property Height;
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Fs_tree */
}	/* namespace Fmx */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FMX_FS_TREE)
using namespace Fmx::Fs_tree;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FMX)
using namespace Fmx;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Fmx_Fs_treeHPP
