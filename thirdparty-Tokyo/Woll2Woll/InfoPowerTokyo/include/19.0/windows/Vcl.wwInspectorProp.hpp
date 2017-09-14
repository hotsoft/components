// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwinspectorprop.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwinspectorpropHPP
#define Vcl_WwinspectorpropHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <DesignIntf.hpp>
#include <DesignEditors.hpp>
#include <Vcl.CheckLst.hpp>
#include <Vcl.Mask.hpp>
#include <vcl.Wwdbedit.hpp>
#include <vcl.Wwdotdot.hpp>
#include <vcl.Wwdbcomb.hpp>
#include <vcl.Wwdatainspector.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwinspectorprop
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TInspectorPropEdit;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TInspectorPropEdit : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Extctrls::TPanel* Panel2;
	Vcl::Buttons::TSpeedButton* NewItemButton;
	Vcl::Buttons::TSpeedButton* NewSubItemButton;
	Vcl::Buttons::TSpeedButton* DeleteButton;
	Vcl::Buttons::TSpeedButton* MoveUpButton;
	Vcl::Buttons::TSpeedButton* MoveDownButton;
	Vcl::Stdctrls::TButton* Button5;
	void __fastcall NewItemButtonClick(System::TObject* Sender);
	void __fastcall NewSubitemButtonClick(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall MoveButtonClick(System::TObject* Sender);
	void __fastcall TreeViewDragDrop(System::TObject* Sender, System::TObject* Source, int X, int Y);
	void __fastcall TreeViewDragOver(System::TObject* Sender, System::TObject* Source, int X, int Y, System::Uitypes::TDragState State, bool &Accept);
	void __fastcall TreeViewMouseDown(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall DeleteButtonClick(System::TObject* Sender);
	void __fastcall TreeViewChange(System::TObject* Sender, Vcl::Comctrls::TTreeNode* Node);
	void __fastcall TreeViewExpanded(System::TObject* Sender, Vcl::Comctrls::TTreeNode* Node);
	void __fastcall TreeViewCollapsed(System::TObject* Sender, Vcl::Comctrls::TTreeNode* Node);
	void __fastcall TreeViewCustomDrawItem(Vcl::Comctrls::TCustomTreeView* Sender, Vcl::Comctrls::TTreeNode* Node, Vcl::Comctrls::TCustomDrawState State, bool &DefaultDraw);
	void __fastcall Button5Click(System::TObject* Sender);
	
private:
	Vcl::Comctrls::TTreeView* TreeView;
	Designintf::_di_IDesigner Designer;
	Vcl::Wwdatainspector::TwwDataInspector* Inspector;
	bool SkipUpdate;
	bool SkipChange;
	void __fastcall AddChildrenToTree(Vcl::Comctrls::TTreeNode* ParentNode, Vcl::Wwdatainspector::TwwInspectorCollection* Items);
	void __fastcall AddChildrenToInspector(Vcl::Comctrls::TTreeNode* ParentNode, Vcl::Wwdatainspector::TwwInspectorItem* ParentItem);
	void __fastcall RefreshNodeText(Vcl::Comctrls::TTreeNode* ParentNode);
	
public:
	__fastcall virtual ~TInspectorPropEdit(void);
	virtual void __fastcall Update(void);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TInspectorPropEdit(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TInspectorPropEdit(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TInspectorPropEdit(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TInspectorPropEdit* InspectorPropEdit;
extern DELPHI_PACKAGE bool __fastcall ExecuteInspectorEditor(Designintf::_di_IDesigner ADesigner, Vcl::Wwdatainspector::TwwDataInspector* AEdit);
}	/* namespace Wwinspectorprop */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWINSPECTORPROP)
using namespace Vcl::Wwinspectorprop;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwinspectorpropHPP
