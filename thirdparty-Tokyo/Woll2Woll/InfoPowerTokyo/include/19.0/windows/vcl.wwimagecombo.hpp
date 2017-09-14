// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwimagecombo.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwimagecomboHPP
#define Vcl_WwimagecomboHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Messages.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.CommCtrl.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ImgList.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Data.DB.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.DBCtrls.hpp>
#include <vcl.Wwdbcomb.hpp>
#include <Vcl.ListActns.hpp>
#include <vcl.wwtypes.hpp>
#include <vcl.Wwcommon.hpp>
#include <vcl.wwframe.hpp>
#include <System.UITypes.hpp>
#include <vcl.Wwdbedit.hpp>
#include <vcl.Wwdotdot.hpp>
#include <Vcl.Mask.hpp>
#include <vcl.wwintl.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwimagecombo
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwPopupImageListBox;
class DELPHICLASS TwwComboExItem;
class DELPHICLASS TwwComboExItems;
class DELPHICLASS TwwCustomImageCombo;
class DELPHICLASS TwwImageCombo;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TwwComboItemsSortType : unsigned char { icstNone, icstDisplayedText, icstStoredText };

typedef int __fastcall (__closure *TwwComboItemsCompareEvent)(TwwComboExItems* List, TwwComboExItem* Item1, TwwComboExItem* Item2);

typedef int __fastcall (*TwwComboItemsCompare)(TwwComboExItems* List, int Index1, int Index2);

class PASCALIMPLEMENTATION TwwPopupImageListBox : public Vcl::Wwdbcomb::TwwPopupListbox
{
	typedef Vcl::Wwdbcomb::TwwPopupListbox inherited;
	
protected:
	virtual void __fastcall DrawItem(int Index, const System::Types::TRect &ARect, Winapi::Windows::TOwnerDrawState State);
	
public:
	__property Style = {default=0};
public:
	/* TwwPopupListbox.Create */ inline __fastcall virtual TwwPopupImageListBox(System::Classes::TComponent* AOwner) : Vcl::Wwdbcomb::TwwPopupListbox(AOwner) { }
	
public:
	/* TCustomListBox.Destroy */ inline __fastcall virtual ~TwwPopupImageListBox(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwPopupImageListBox(HWND ParentWindow) : Vcl::Wwdbcomb::TwwPopupListbox(ParentWindow) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwComboExItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
private:
	System::UnicodeString FDisplayedText;
	System::UnicodeString FStoredText;
	System::Uitypes::TImageIndex FImageIndex;
	System::Uitypes::TImageIndex FSelectedImageIndex;
	int FIndent;
	
protected:
	virtual void __fastcall SetSelectedImageIndex(const System::Uitypes::TImageIndex Value);
	virtual void __fastcall SetDisplayedText(const System::UnicodeString Value);
	virtual void __fastcall SetStoredText(const System::UnicodeString Value);
	virtual void __fastcall SetImageIndex(const System::Uitypes::TImageIndex Value);
	virtual void __fastcall SetIndex(int Value);
	virtual System::UnicodeString __fastcall GetDisplayName(void);
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	
__published:
	__property System::UnicodeString DisplayedText = {read=FDisplayedText, write=FDisplayedText};
	__property System::UnicodeString StoredText = {read=FStoredText, write=FStoredText};
	__property System::Uitypes::TImageIndex ImageIndex = {read=FImageIndex, write=SetImageIndex, default=-1};
	__property int Indent = {read=FIndent, write=FIndent, default=-1};
	__property System::Uitypes::TImageIndex SelectedImageIndex = {read=FSelectedImageIndex, write=SetSelectedImageIndex, default=-1};
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TwwComboExItem(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TwwComboExItem(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TwwComboExItems : public System::Classes::TOwnedCollection
{
	typedef System::Classes::TOwnedCollection inherited;
	
public:
	TwwComboExItem* operator[](const int Index) { return this->Items[Index]; }
	
private:
	TwwComboItemsSortType FSortType;
	TwwComboItemsCompareEvent FOnCompare;
	bool FCaseSensitive;
	TwwComboExItem* __fastcall GetComboItem(const int Index);
	void __fastcall SetSortType(const TwwComboItemsSortType Value);
	void __fastcall ExchangeItems(int Index1, int Index2);
	void __fastcall QuickSort(int L, int R, TwwComboItemsCompare SCompare);
	void __fastcall CustomSort(TwwComboItemsCompare Compare);
	
protected:
	virtual void __fastcall Notify(System::Classes::TCollectionItem* Item, System::Classes::TCollectionNotification Action);
	virtual int __fastcall CompareItems(TwwComboExItem* I1, TwwComboExItem* I2);
	
public:
	HIDESBASE TwwComboExItem* __fastcall Add(void);
	virtual void __fastcall Sort(void);
	__fastcall TwwComboExItems(System::Classes::TPersistent* AOwner, System::Classes::TCollectionItemClass ItemClass);
	HIDESBASE TwwComboExItem* __fastcall Insert(int Index);
	__property TwwComboExItem* Items[const int Index] = {read=GetComboItem/*, default*/};
	
__published:
	__property TwwComboItemsSortType SortType = {read=FSortType, write=SetSortType, default=0};
	__property TwwComboItemsCompareEvent OnCompare = {read=FOnCompare, write=FOnCompare};
	__property bool CaseSensitive = {read=FCaseSensitive, write=FCaseSensitive, default=0};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TwwComboExItems(void) { }
	
};


class PASCALIMPLEMENTATION TwwCustomImageCombo : public Vcl::Wwdbcomb::TwwDBCustomComboBox
{
	typedef Vcl::Wwdbcomb::TwwDBCustomComboBox inherited;
	
private:
	TwwComboExItems* FItemsEx;
	Vcl::Imglist::TCustomImageList* FImages;
	System::UnicodeString FValue;
	System::UnicodeString FNullTextDisplay;
	void __fastcall SetImages(Vcl::Imglist::TCustomImageList* Value);
	void __fastcall SetItemsEx(TwwComboExItems* const Value);
	HIDESBASE virtual System::UnicodeString __fastcall GetValue(void);
	
protected:
	virtual void __fastcall SetValue(System::UnicodeString value);
	virtual bool __fastcall CustomDraw(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual Vcl::Wwdbcomb::TwwPopupListbox* __fastcall CreateListBox(void);
	virtual void __fastcall ShowText(Vcl::Graphics::TCanvas* ACanvas, const System::Types::TRect &ARect, int indentLeft, int indentTop, System::UnicodeString AText, bool transparent = false);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall DataChange(System::TObject* Sender);
	virtual void __fastcall CloseUp(bool Accept);
	virtual void __fastcall SetItemIndex(int val);
	virtual int __fastcall GetItemIndexFromText(System::UnicodeString DisplayedText);
	virtual void __fastcall SetEditRect(void);
	virtual void __fastcall Paint(void);
	virtual System::Types::TRect __fastcall GetImageRect(void);
	virtual void __fastcall UpdateData(System::TObject* Sender);
	virtual void __fastcall DrawFocusRect(Vcl::Graphics::TCanvas* ACanvas, const System::Types::TRect &ARect);
	virtual int __fastcall CalcItemHeight(void);
	
public:
	__fastcall virtual TwwCustomImageCombo(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwCustomImageCombo(void);
	virtual void __fastcall DropDown(void);
	virtual void __fastcall ApplyList(void);
	void __fastcall RefreshDisplay(void);
	virtual System::UnicodeString __fastcall GetComboValue(System::UnicodeString DisplayText);
	virtual System::UnicodeString __fastcall GetComboDisplay(System::UnicodeString Value);
	__property Controller;
	__property BevelEdges = {default=15};
	__property BevelInner = {index=0, default=2};
	__property BevelKind = {default=0};
	__property BevelOuter = {index=1, default=1};
	__property DisableThemes = {default=0};
	__property Anchors = {default=3};
	__property BiDiMode;
	__property Constraints;
	__property ParentBiDiMode = {default=1};
	__property ShowButton;
	__property Style;
	__property MapList;
	__property AllowClearKey;
	__property AutoDropDown = {default=0};
	__property ShowMatchText = {default=0};
	__property AutoFillDate = {default=1};
	__property AutoSelect = {default=1};
	__property AutoSize = {default=1};
	__property BorderStyle = {default=1};
	__property ButtonStyle = {default=1};
	__property CharCase = {default=0};
	__property Color = {default=-16777211};
	__property Ctl3D;
	__property DataField = {default=0};
	__property DataSource;
	__property DisableDropDownList = {default=0};
	__property DragMode = {default=0};
	__property DragCursor = {default=-12};
	__property DropDownCount;
	__property DropDownWidth = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property ButtonEffects;
	__property Frame;
	__property ButtonWidth = {default=0};
	__property ButtonGlyph;
	__property ImeMode = {default=3};
	__property ImeName = {default=0};
	__property MaxLength = {default=0};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property Picture;
	__property PopupMenu;
	__property ReadOnly = {default=0};
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property UnboundDataType;
	__property UsePictureMask = {default=1};
	__property Visible = {default=1};
	__property UnboundAlignment = {default=0};
	__property Vcl::Imglist::TCustomImageList* Images = {read=FImages, write=SetImages};
	__property TwwComboExItems* ItemsEx = {read=FItemsEx, write=SetItemsEx};
	__property ItemHeight;
	__property System::UnicodeString Value = {read=GetValue, write=SetValue};
	__property System::UnicodeString NullTextDisplay = {read=FNullTextDisplay, write=FNullTextDisplay};
	__property OnAddHistoryItem;
	__property OnChange;
	__property OnCheckValue;
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnDropDown;
	__property OnCloseUp;
	__property OnDrawItem;
	__property OnMeasureItem;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwCustomImageCombo(HWND ParentWindow) : Vcl::Wwdbcomb::TwwDBCustomComboBox(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TwwImageCombo : public TwwCustomImageCombo
{
	typedef TwwCustomImageCombo inherited;
	
__published:
	__property Controller;
	__property BevelEdges = {default=15};
	__property BevelInner = {index=0, default=2};
	__property BevelKind = {default=0};
	__property BevelOuter = {index=1, default=1};
	__property DisableThemes = {default=0};
	__property Anchors = {default=3};
	__property BiDiMode;
	__property Constraints;
	__property ParentBiDiMode = {default=1};
	__property ShowButton;
	__property Style;
	__property MapList;
	__property AllowClearKey;
	__property AutoDropDown = {default=0};
	__property ShowMatchText = {default=0};
	__property AutoFillDate = {default=1};
	__property AutoSelect = {default=1};
	__property AutoSize = {default=1};
	__property BorderStyle = {default=1};
	__property ButtonStyle = {default=1};
	__property CharCase = {default=0};
	__property Color = {default=-16777211};
	__property Ctl3D;
	__property DataField = {default=0};
	__property DataSource;
	__property DisableDropDownList = {default=0};
	__property DragMode = {default=0};
	__property DragCursor = {default=-12};
	__property DropDownCount;
	__property DropDownWidth = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property ButtonEffects;
	__property Frame;
	__property ButtonWidth = {default=0};
	__property ButtonGlyph;
	__property ImeMode = {default=3};
	__property ImeName = {default=0};
	__property MaxLength = {default=0};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property Picture;
	__property PopupMenu;
	__property ReadOnly = {default=0};
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property UnboundDataType;
	__property UsePictureMask = {default=1};
	__property Visible = {default=1};
	__property UnboundAlignment = {default=0};
	__property Images;
	__property ItemsEx;
	__property ItemHeight;
	__property Value;
	__property NullTextDisplay = {default=0};
	__property OnAddHistoryItem;
	__property OnChange;
	__property OnCheckValue;
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnDropDown;
	__property OnCloseUp;
	__property OnDrawItem;
	__property OnMeasureItem;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
public:
	/* TwwCustomImageCombo.Create */ inline __fastcall virtual TwwImageCombo(System::Classes::TComponent* AOwner) : TwwCustomImageCombo(AOwner) { }
	/* TwwCustomImageCombo.Destroy */ inline __fastcall virtual ~TwwImageCombo(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwImageCombo(HWND ParentWindow) : TwwCustomImageCombo(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Wwimagecombo */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWIMAGECOMBO)
using namespace Vcl::Wwimagecombo;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwimagecomboHPP
