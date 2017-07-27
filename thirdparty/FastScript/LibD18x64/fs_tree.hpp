// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'fs_tree.pas' rev: 25.00 (Windows)

#ifndef Fs_treeHPP
#define Fs_treeHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <Winapi.Windows.hpp>	// Pascal unit
#include <Winapi.Messages.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <Vcl.Graphics.hpp>	// Pascal unit
#include <Vcl.Controls.hpp>	// Pascal unit
#include <Vcl.Forms.hpp>	// Pascal unit
#include <Vcl.Dialogs.hpp>	// Pascal unit
#include <Vcl.StdCtrls.hpp>	// Pascal unit
#include <Vcl.ExtCtrls.hpp>	// Pascal unit
#include <Vcl.ComCtrls.hpp>	// Pascal unit
#include <fs_synmemo.hpp>	// Pascal unit
#include <fs_xml.hpp>	// Pascal unit
#include <fs_iinterpreter.hpp>	// Pascal unit
#include <System.UITypes.hpp>	// Pascal unit
#include <Vcl.Menus.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Fs_tree
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TfsTree;
class PASCALIMPLEMENTATION TfsTree : public Vcl::Extctrls::TPanel
{
	typedef Vcl::Extctrls::TPanel inherited;
	
private:
	Vcl::Comctrls::TTreeView* Tree;
	Fs_xml::TfsXMLDocument* FXML;
	Vcl::Controls::TImageList* FImages;
	Fs_iinterpreter::TfsScript* FScript;
	bool FShowFunctions;
	bool FShowClasses;
	bool FShowTypes;
	bool FShowVariables;
	bool FExpanded;
	int FExpandLevel;
	Fs_synmemo::TfsSyntaxMemo* FMemo;
	bool FUpdating;
	void __fastcall FillTree(void);
	void __fastcall SetMemo(Fs_synmemo::TfsSyntaxMemo* Value);
	void __fastcall SetImageIndex(Vcl::Comctrls::TTreeNode* Node, int Index);
	void __fastcall SetScript(Fs_iinterpreter::TfsScript* const Value);
	void __fastcall TreeCollapsed(System::TObject* Sender, Vcl::Comctrls::TTreeNode* Node);
	void __fastcall TreeExpanded(System::TObject* Sender, Vcl::Comctrls::TTreeNode* Node);
	
protected:
	void __fastcall TreeChange(System::TObject* Sender, Vcl::Comctrls::TTreeNode* Node);
	void __fastcall TreeDblClick(System::TObject* Sender);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	
public:
	__fastcall virtual TfsTree(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfsTree(void);
	HIDESBASE void __fastcall SetColor(System::Uitypes::TColor Color);
	void __fastcall UpdateItems(void);
	System::UnicodeString __fastcall GetFieldName(void);
	
__published:
	__property Align = {default=0};
	__property Anchors = {default=3};
	__property ParentCtl3D = {default=1};
	__property DragCursor = {default=-12};
	__property DragKind = {default=0};
	__property DragMode = {default=0};
	__property BiDiMode;
	__property ParentBiDiMode = {default=1};
	__property Color = {default=-16777201};
	__property Constraints;
	__property Enabled = {default=1};
	__property Font;
	__property ParentColor = {default=0};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property Fs_iinterpreter::TfsScript* Script = {read=FScript, write=SetScript};
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=0};
	__property Visible = {default=1};
	__property Fs_synmemo::TfsSyntaxMemo* SyntaxMemo = {read=FMemo, write=SetMemo};
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
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnStartDrag;
public:
	/* TWinControl.CreateParented */ inline __fastcall TfsTree(HWND ParentWindow) : Vcl::Extctrls::TPanel(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Fs_tree */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FS_TREE)
using namespace Fs_tree;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Fs_treeHPP
