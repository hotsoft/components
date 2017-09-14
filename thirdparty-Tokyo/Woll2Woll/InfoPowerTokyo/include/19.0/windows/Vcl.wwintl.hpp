// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwintl.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwintlHPP
#define Vcl_WwintlHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Vcl.Consts.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <vcl.Wwstr.hpp>
#include <Data.DB.hpp>
#include <vcl.wwframe.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>
#include <System.Generics.Collections.hpp>
#include <System.Win.Registry.hpp>
#include <Vcl.Buttons.hpp>
#include <System.Generics.Defaults.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwintl
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwCompatibilityIntl;
class DELPHICLASS TwwUserMessagesIntl;
class DELPHICLASS TwwValidationFeedback;
class DELPHICLASS TwwFilterDialogIntl;
class DELPHICLASS TwwRichEditMenuLabels;
class DELPHICLASS TwwRichEditPopupMenuLabels;
class DELPHICLASS TwwRichEditParagraphDlg;
class DELPHICLASS TwwRichEditTabDlg;
class DELPHICLASS TwwDBRichEditIntl;
class DELPHICLASS TwwSearchDialogIntl;
class DELPHICLASS TwwMonthCalendarIntl;
class DELPHICLASS TwwGridTitleMenuIntl;
class DELPHICLASS TwwLocateDialogIntl;
class DELPHICLASS TwwDBNavigatorIntlHints;
class DELPHICLASS TwwADOIntl;
class DELPHICLASS TwwDBNavigatorIntl;
class DELPHICLASS TwwIntl;
class DELPHICLASS TwwController;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TwwPictureValidationError)(System::TObject* Sender, Data::Db::TField* Field, System::UnicodeString &Msg, bool &DoDefault);

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwCompatibilityIntl : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	bool FRichEditEnableZoom;
	bool FPaintNonEditableComboAsButton;
	bool FGridLinePaintingAsIP10;
	
__published:
	__property bool PaintNonEditableComboAsButton = {read=FPaintNonEditableComboAsButton, write=FPaintNonEditableComboAsButton, nodefault};
	__property bool RichEditEnableZoom = {read=FRichEditEnableZoom, write=FRichEditEnableZoom, nodefault};
	__property bool GridLinePaintingAsIP10 = {read=FGridLinePaintingAsIP10, write=FGridLinePaintingAsIP10, default=0};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwCompatibilityIntl(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TwwCompatibilityIntl(void) : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwUserMessagesIntl : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::UnicodeString FwwDBGridDiscardChanges;
	System::UnicodeString FPictureValidateError;
	System::UnicodeString FLocateNoMatches;
	System::UnicodeString FLocateNoMoreMatches;
	System::UnicodeString FMemoChangesWarning;
	System::UnicodeString FRichEditExitWarning;
	System::UnicodeString FRichEditClearWarning;
	System::UnicodeString FRichEditSpellCheckComplete;
	System::UnicodeString FRichEditMSWordNotFound;
	System::UnicodeString FFilterDlgNoCriteria;
	System::UnicodeString FRecordViewExitWarning;
	
__published:
	__property System::UnicodeString wwDBGridDiscardChanges = {read=FwwDBGridDiscardChanges, write=FwwDBGridDiscardChanges};
	__property System::UnicodeString PictureValidateError = {read=FPictureValidateError, write=FPictureValidateError};
	__property System::UnicodeString LocateNoMatches = {read=FLocateNoMatches, write=FLocateNoMatches};
	__property System::UnicodeString LocateNoMoreMatches = {read=FLocateNoMoreMatches, write=FLocateNoMoreMatches};
	__property System::UnicodeString MemoChangesWarning = {read=FMemoChangesWarning, write=FMemoChangesWarning};
	__property System::UnicodeString RichEditExitWarning = {read=FRichEditExitWarning, write=FRichEditExitWarning};
	__property System::UnicodeString RichEditClearWarning = {read=FRichEditClearWarning, write=FRichEditClearWarning};
	__property System::UnicodeString RichEditSpellCheckComplete = {read=FRichEditSpellCheckComplete, write=FRichEditSpellCheckComplete};
	__property System::UnicodeString RichEditMSWordNotFound = {read=FRichEditMSWordNotFound, write=FRichEditMSWordNotFound};
	__property System::UnicodeString FilterDlgNoCriteria = {read=FFilterDlgNoCriteria, write=FFilterDlgNoCriteria};
	__property System::UnicodeString RecordViewExitWarning = {read=FRecordViewExitWarning, write=FRecordViewExitWarning};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwUserMessagesIntl(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TwwUserMessagesIntl(void) : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwValidationFeedback : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::Uitypes::TColor FErrorForeColor;
	System::Uitypes::TColor FErrorBackColor;
	
__published:
	__property System::Uitypes::TColor ErrorForeColor = {read=FErrorForeColor, write=FErrorForeColor, default=536870911};
	__property System::Uitypes::TColor ErrorBackColor = {read=FErrorBackColor, write=FErrorBackColor, default=536870911};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwValidationFeedback(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TwwValidationFeedback(void) : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwFilterDialogIntl : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::UnicodeString FBtnViewSummary;
	System::UnicodeString FBtnViewSummaryHint;
	System::UnicodeString FViewSummaryNotText;
	System::UnicodeString FBtnNewSearch;
	System::UnicodeString FBtnNewSearchHint;
	System::UnicodeString FFieldOrderLabel;
	System::UnicodeString FFieldOrderHint;
	System::UnicodeString FAlphabeticLabel;
	System::UnicodeString FLogicalLabel;
	System::UnicodeString FAllFieldsLabel;
	System::UnicodeString FSearchedFieldsLabel;
	System::UnicodeString FStartingRangeLabel;
	System::UnicodeString FEndingRangeLabel;
	System::UnicodeString FStartingRangeHint;
	System::UnicodeString FEndingRangeHint;
	System::UnicodeString FBtnClearMin;
	System::UnicodeString FBtnClearMax;
	System::UnicodeString FBtnClearFiltervalue;
	System::UnicodeString FBtnClearMinHint;
	System::UnicodeString FBtnClearMaxHint;
	System::UnicodeString FBtnClearFilterValueHint;
	System::UnicodeString FByValueLabel;
	System::UnicodeString FByRangeLabel;
	System::UnicodeString FFieldValueLabel;
	System::UnicodeString FFieldValueHint;
	System::UnicodeString FSearchTypeLabel;
	System::UnicodeString FSearchTypeHint;
	System::UnicodeString FMatchExactLabel;
	System::UnicodeString FMatchStartLabel;
	System::UnicodeString FMatchAnyLabel;
	System::UnicodeString FCaseSensitiveLabel;
	System::UnicodeString FCaseSensitiveHint;
	System::UnicodeString FNonMatchingLabel;
	System::UnicodeString FNonMatchingHint;
	System::UnicodeString FSummaryFieldLabel;
	System::UnicodeString FSummarySearchLabel;
	System::UnicodeString FSummaryValueLabel;
	System::UnicodeString FSummaryCaption;
	System::UnicodeString FFieldsLabel;
	System::UnicodeString FValueRangeTabHint;
	System::UnicodeString FAllSearchedTabHint;
	
__published:
	__property System::UnicodeString BtnViewSummary = {read=FBtnViewSummary, write=FBtnViewSummary};
	__property System::UnicodeString BtnViewSummaryHint = {read=FBtnViewSummaryHint, write=FBtnViewSummaryHint};
	__property System::UnicodeString BtnNewSearch = {read=FBtnNewSearch, write=FBtnNewSearch};
	__property System::UnicodeString BtnNewSearchHint = {read=FBtnNewSearchHint, write=FBtnNewSearchHint};
	__property System::UnicodeString FieldOrderLabel = {read=FFieldOrderLabel, write=FFieldOrderLabel};
	__property System::UnicodeString FieldOrderHint = {read=FFieldOrderHint, write=FFieldOrderHint};
	__property System::UnicodeString AlphabeticLabel = {read=FAlphabeticLabel, write=FAlphabeticLabel};
	__property System::UnicodeString LogicalLabel = {read=FLogicalLabel, write=FLogicalLabel};
	__property System::UnicodeString AllFieldsLabel = {read=FAllFieldsLabel, write=FAllFieldsLabel};
	__property System::UnicodeString SearchedFieldsLabel = {read=FSearchedFieldsLabel, write=FSearchedFieldsLabel};
	__property System::UnicodeString StartingRangeLabel = {read=FStartingRangeLabel, write=FStartingRangeLabel};
	__property System::UnicodeString EndingRangeLabel = {read=FEndingRangeLabel, write=FEndingRangeLabel};
	__property System::UnicodeString StartingRangeHint = {read=FStartingRangeHint, write=FStartingRangeHint};
	__property System::UnicodeString EndingRangeHint = {read=FEndingRangeHint, write=FEndingRangeHint};
	__property System::UnicodeString BtnClearMin = {read=FBtnClearMin, write=FBtnClearMin};
	__property System::UnicodeString BtnClearMax = {read=FBtnClearMax, write=FBtnClearMax};
	__property System::UnicodeString BtnClearFilterValue = {read=FBtnClearFiltervalue, write=FBtnClearFiltervalue};
	__property System::UnicodeString BtnClearMinHint = {read=FBtnClearMinHint, write=FBtnClearMinHint};
	__property System::UnicodeString BtnClearMaxHint = {read=FBtnClearMaxHint, write=FBtnClearMaxHint};
	__property System::UnicodeString BtnClearFilterValueHint = {read=FBtnClearFilterValueHint, write=FBtnClearFilterValueHint};
	__property System::UnicodeString ByValueLabel = {read=FByValueLabel, write=FByValueLabel};
	__property System::UnicodeString ByRangeLabel = {read=FByRangeLabel, write=FByRangeLabel};
	__property System::UnicodeString FieldValueLabel = {read=FFieldValueLabel, write=FFieldValueLabel};
	__property System::UnicodeString FieldValueHint = {read=FFieldValueHint, write=FFieldValueHint};
	__property System::UnicodeString SearchTypeLabel = {read=FSearchTypeLabel, write=FSearchTypeLabel};
	__property System::UnicodeString SearchTypeHint = {read=FSearchTypeHint, write=FSearchTypeHint};
	__property System::UnicodeString MatchExactLabel = {read=FMatchExactLabel, write=FMatchExactLabel};
	__property System::UnicodeString MatchStartLabel = {read=FMatchStartLabel, write=FMatchStartLabel};
	__property System::UnicodeString MatchAnyLabel = {read=FMatchAnyLabel, write=FMatchAnyLabel};
	__property System::UnicodeString CaseSensitiveLabel = {read=FCaseSensitiveLabel, write=FCaseSensitiveLabel};
	__property System::UnicodeString CaseSensitiveHint = {read=FCaseSensitiveHint, write=FCaseSensitiveHint};
	__property System::UnicodeString NonMatchingLabel = {read=FNonMatchingLabel, write=FNonMatchingLabel};
	__property System::UnicodeString NonMatchingHint = {read=FNonMatchingHint, write=FNonMatchingHint};
	__property System::UnicodeString SummaryFieldLabel = {read=FSummaryFieldLabel, write=FSummaryFieldLabel};
	__property System::UnicodeString SummarySearchLabel = {read=FSummarySearchLabel, write=FSummarySearchLabel};
	__property System::UnicodeString SummaryValueLabel = {read=FSummaryValueLabel, write=FSummaryValueLabel};
	__property System::UnicodeString SummaryCaption = {read=FSummaryCaption, write=FSummaryCaption};
	__property System::UnicodeString FieldsLabel = {read=FFieldsLabel, write=FFieldsLabel};
	__property System::UnicodeString ValueRangeTabHint = {read=FValueRangeTabHint, write=FValueRangeTabHint};
	__property System::UnicodeString AllSearchedTabHint = {read=FAllSearchedTabHint, write=FAllSearchedTabHint};
	__property System::UnicodeString ViewSummaryNotText = {read=FViewSummaryNotText, write=FViewSummaryNotText};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwFilterDialogIntl(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TwwFilterDialogIntl(void) : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwRichEditMenuLabels : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::UnicodeString FFileCaption;
	System::UnicodeString FLoadCaption;
	System::UnicodeString FSaveAsCaption;
	System::UnicodeString FSaveExitCaption;
	System::UnicodeString FPrintCaption;
	System::UnicodeString FPrintPreviewCaption;
	System::UnicodeString FPageSetupCaption;
	System::UnicodeString FExitCaption;
	System::UnicodeString FEditCaption;
	System::UnicodeString FUndoCaption;
	System::UnicodeString FCutCaption;
	System::UnicodeString FCopyCaption;
	System::UnicodeString FPasteCaption;
	System::UnicodeString FClearCaption;
	System::UnicodeString FSelectallCaption;
	System::UnicodeString FFindCaption;
	System::UnicodeString FFindNextCaption;
	System::UnicodeString FReplaceCaption;
	System::UnicodeString FInsertObjectCaption;
	System::UnicodeString FSpellCheckCaption;
	System::UnicodeString FInsertCaption;
	System::UnicodeString FRulerCaption;
	System::UnicodeString FRedoCaption;
	System::UnicodeString FViewCaption;
	System::UnicodeString FToolbarCaption;
	System::UnicodeString FFormatBarCaption;
	System::UnicodeString FViewStatusBarCaption;
	System::UnicodeString FOptionsCaption;
	System::UnicodeString FFormatCaption;
	System::UnicodeString FToolCaption;
	System::UnicodeString FFontCaption;
	System::UnicodeString FBulletStyleCaption;
	System::UnicodeString FParagraphCaption;
	System::UnicodeString FTabsCaption;
	System::UnicodeString FHelpCaption;
	
__published:
	__property System::UnicodeString FileCaption = {read=FFileCaption, write=FFileCaption};
	__property System::UnicodeString LoadCaption = {read=FLoadCaption, write=FLoadCaption};
	__property System::UnicodeString SaveAsCaption = {read=FSaveAsCaption, write=FSaveAsCaption};
	__property System::UnicodeString SaveExitCaption = {read=FSaveExitCaption, write=FSaveExitCaption};
	__property System::UnicodeString PrintCaption = {read=FPrintCaption, write=FPrintCaption};
	__property System::UnicodeString PrintPreviewCaption = {read=FPrintPreviewCaption, write=FPrintPreviewCaption};
	__property System::UnicodeString PageSetupCaption = {read=FPageSetupCaption, write=FPageSetupCaption};
	__property System::UnicodeString ExitCaption = {read=FExitCaption, write=FExitCaption};
	__property System::UnicodeString EditCaption = {read=FEditCaption, write=FEditCaption};
	__property System::UnicodeString UndoCaption = {read=FUndoCaption, write=FUndoCaption};
	__property System::UnicodeString CutCaption = {read=FCutCaption, write=FCutCaption};
	__property System::UnicodeString CopyCaption = {read=FCopyCaption, write=FCopyCaption};
	__property System::UnicodeString PasteCaption = {read=FPasteCaption, write=FPasteCaption};
	__property System::UnicodeString ClearCaption = {read=FClearCaption, write=FClearCaption};
	__property System::UnicodeString SelectallCaption = {read=FSelectallCaption, write=FSelectallCaption};
	__property System::UnicodeString FindCaption = {read=FFindCaption, write=FFindCaption};
	__property System::UnicodeString FindNextCaption = {read=FFindNextCaption, write=FFindNextCaption};
	__property System::UnicodeString ReplaceCaption = {read=FReplaceCaption, write=FReplaceCaption};
	__property System::UnicodeString InsertObjectCaption = {read=FInsertObjectCaption, write=FInsertObjectCaption};
	__property System::UnicodeString ToolCaption = {read=FToolCaption, write=FToolCaption};
	__property System::UnicodeString SpellCheckCaption = {read=FSpellCheckCaption, write=FSpellCheckCaption};
	__property System::UnicodeString InsertCaption = {read=FInsertCaption, write=FInsertCaption};
	__property System::UnicodeString RulerCaption = {read=FRulerCaption, write=FRulerCaption};
	__property System::UnicodeString RedoCaption = {read=FRedoCaption, write=FRedoCaption};
	__property System::UnicodeString ViewCaption = {read=FViewCaption, write=FViewCaption};
	__property System::UnicodeString ToolbarCaption = {read=FToolbarCaption, write=FToolbarCaption};
	__property System::UnicodeString FormatBarCaption = {read=FFormatBarCaption, write=FFormatBarCaption};
	__property System::UnicodeString ViewStatusBarCaption = {read=FViewStatusBarCaption, write=FViewStatusBarCaption};
	__property System::UnicodeString OptionsCaption = {read=FOptionsCaption, write=FOptionsCaption};
	__property System::UnicodeString FormatCaption = {read=FFormatCaption, write=FFormatCaption};
	__property System::UnicodeString FontCaption = {read=FFontCaption, write=FFontCaption};
	__property System::UnicodeString BulletStyleCaption = {read=FBulletStyleCaption, write=FBulletStyleCaption};
	__property System::UnicodeString ParagraphCaption = {read=FParagraphCaption, write=FParagraphCaption};
	__property System::UnicodeString TabsCaption = {read=FTabsCaption, write=FTabsCaption};
	__property System::UnicodeString HelpCaption = {read=FHelpCaption, write=FHelpCaption};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwRichEditMenuLabels(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TwwRichEditMenuLabels(void) : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwRichEditPopupMenuLabels : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::UnicodeString FEditCaption;
	System::UnicodeString FViewCaption;
	System::UnicodeString FCutCaption;
	System::UnicodeString FCopyCaption;
	System::UnicodeString FPasteCaption;
	System::UnicodeString FFontCaption;
	System::UnicodeString FBulletStyleCaption;
	System::UnicodeString FBoldCaption;
	System::UnicodeString FItalicCaption;
	System::UnicodeString FUnderlineCaption;
	System::UnicodeString FParagraphCaption;
	System::UnicodeString FTabsCaption;
	System::UnicodeString FFindCaption;
	System::UnicodeString FReplaceCaption;
	System::UnicodeString FInsertObjectCaption;
	System::UnicodeString FSpellCheckCaption;
	System::UnicodeString FObjectPropertiesCaption;
	
__published:
	__property System::UnicodeString EditCaption = {read=FEditCaption, write=FEditCaption};
	__property System::UnicodeString ViewCaption = {read=FViewCaption, write=FViewCaption};
	__property System::UnicodeString CutCaption = {read=FCutCaption, write=FCutCaption};
	__property System::UnicodeString CopyCaption = {read=FCopyCaption, write=FCopyCaption};
	__property System::UnicodeString PasteCaption = {read=FPasteCaption, write=FPasteCaption};
	__property System::UnicodeString FontCaption = {read=FFontCaption, write=FFontCaption};
	__property System::UnicodeString BulletStyleCaption = {read=FBulletStyleCaption, write=FBulletStyleCaption};
	__property System::UnicodeString BoldCaption = {read=FBoldCaption, write=FBoldCaption};
	__property System::UnicodeString ItalicCaption = {read=FItalicCaption, write=FItalicCaption};
	__property System::UnicodeString UnderlineCaption = {read=FUnderlineCaption, write=FUnderlineCaption};
	__property System::UnicodeString ParagraphCaption = {read=FParagraphCaption, write=FParagraphCaption};
	__property System::UnicodeString TabsCaption = {read=FTabsCaption, write=FTabsCaption};
	__property System::UnicodeString FindCaption = {read=FFindCaption, write=FFindCaption};
	__property System::UnicodeString ReplaceCaption = {read=FReplaceCaption, write=FReplaceCaption};
	__property System::UnicodeString InsertObjectCaption = {read=FInsertObjectCaption, write=FInsertObjectCaption};
	__property System::UnicodeString ObjectPropertiesCaption = {read=FObjectPropertiesCaption, write=FObjectPropertiesCaption};
	__property System::UnicodeString SpellCheckCaption = {read=FSpellCheckCaption, write=FSpellCheckCaption};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwRichEditPopupMenuLabels(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TwwRichEditPopupMenuLabels(void) : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwRichEditParagraphDlg : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::UnicodeString FParagraphDlgCaption;
	System::UnicodeString FIndentationGroupBoxCaption;
	System::UnicodeString FLeftEditCaption;
	System::UnicodeString FRightEditCaption;
	System::UnicodeString FFirstLineEditCaption;
	System::UnicodeString FAlignmentCaption;
	System::UnicodeString FLeftEditHint;
	System::UnicodeString FRightEditHint;
	System::UnicodeString FFirstLineEditHint;
	System::UnicodeString FSpacingGroupCaption;
	System::UnicodeString FBeforeParagraphCaption;
	System::UnicodeString FAfterParagraphCaption;
	System::UnicodeString FWithinParagraphCaption;
	System::UnicodeString FWithinParagraphAtCaption;
	System::UnicodeString FAlignmentHint;
	System::UnicodeString FAlignLeft;
	System::UnicodeString FAlignRight;
	System::UnicodeString FAlignCenter;
	System::UnicodeString FAlignJustify;
	System::UnicodeString FSpacingSingle;
	System::UnicodeString FSpacing1_5;
	System::UnicodeString FSpacingDouble;
	System::UnicodeString FSpacingAtLeast;
	System::UnicodeString FSpacingExactly;
	System::UnicodeString FSpacingMultiple;
	int FHelpContext;
	
__published:
	__property System::UnicodeString ParagraphDlgCaption = {read=FParagraphDlgCaption, write=FParagraphDlgCaption};
	__property System::UnicodeString IndentationGroupBoxCaption = {read=FIndentationGroupBoxCaption, write=FIndentationGroupBoxCaption};
	__property System::UnicodeString LeftEditHint = {read=FLeftEditHint, write=FLeftEditHint};
	__property System::UnicodeString RightEditHint = {read=FRightEditHint, write=FRightEditHint};
	__property System::UnicodeString FirstLineEditHint = {read=FFirstLineEditHint, write=FFirstLineEditHint};
	__property System::UnicodeString AlignmentHint = {read=FAlignmentHint, write=FAlignmentHint};
	__property System::UnicodeString LeftEditCaption = {read=FLeftEditCaption, write=FLeftEditCaption};
	__property System::UnicodeString RightEditCaption = {read=FRightEditCaption, write=FRightEditCaption};
	__property System::UnicodeString FirstLineEditCaption = {read=FFirstLineEditCaption, write=FFirstLineEditCaption};
	__property System::UnicodeString SpacingGroupCaption = {read=FSpacingGroupCaption, write=FSpacingGroupCaption};
	__property System::UnicodeString BeforeParagraphCaption = {read=FBeforeParagraphCaption, write=FBeforeParagraphCaption};
	__property System::UnicodeString AfterParagraphCaption = {read=FAfterParagraphCaption, write=FAfterParagraphCaption};
	__property System::UnicodeString WithinParagraphCaption = {read=FWithinParagraphCaption, write=FWithinParagraphCaption};
	__property System::UnicodeString WithinParagraphAtCaption = {read=FWithinParagraphAtCaption, write=FWithinParagraphAtCaption};
	__property System::UnicodeString AlignmentCaption = {read=FAlignmentCaption, write=FAlignmentCaption};
	__property System::UnicodeString AlignLeft = {read=FAlignLeft, write=FAlignLeft};
	__property System::UnicodeString AlignRight = {read=FAlignRight, write=FAlignRight};
	__property System::UnicodeString AlignCenter = {read=FAlignCenter, write=FAlignCenter};
	__property System::UnicodeString AlignJustify = {read=FAlignJustify, write=FAlignJustify};
	__property System::UnicodeString SpacingSingle = {read=FSpacingSingle, write=FSpacingSingle};
	__property System::UnicodeString Spacing1_5 = {read=FSpacing1_5, write=FSpacing1_5};
	__property System::UnicodeString SpacingDouble = {read=FSpacingDouble, write=FSpacingDouble};
	__property System::UnicodeString SpacingAtLeast = {read=FSpacingAtLeast, write=FSpacingAtLeast};
	__property System::UnicodeString SpacingExactly = {read=FSpacingExactly, write=FSpacingExactly};
	__property System::UnicodeString SpacingMultiple = {read=FSpacingMultiple, write=FSpacingMultiple};
	__property int HelpContext = {read=FHelpContext, write=FHelpContext, default=0};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwRichEditParagraphDlg(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TwwRichEditParagraphDlg(void) : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwRichEditTabDlg : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::UnicodeString FTabDlgCaption;
	System::UnicodeString FTabGroupBoxCaption;
	System::UnicodeString FSetTabButtonCaption;
	System::UnicodeString FClearTabButtonCaption;
	System::UnicodeString FClearAllButtonCaption;
	System::UnicodeString FTabPositionEditHint;
	System::UnicodeString FListBoxHint;
	System::UnicodeString FSetButtonHint;
	System::UnicodeString FClearButtonHint;
	System::UnicodeString FClearAllButtonHint;
	int FHelpContext;
	
__published:
	__property System::UnicodeString TabDlgCaption = {read=FTabDlgCaption, write=FTabDlgCaption};
	__property int HelpContext = {read=FHelpContext, write=FHelpContext, default=0};
	__property System::UnicodeString TabGroupBoxCaption = {read=FTabGroupBoxCaption, write=FTabGroupBoxCaption};
	__property System::UnicodeString SetTabButtonCaption = {read=FSetTabButtonCaption, write=FSetTabButtonCaption};
	__property System::UnicodeString ClearTabButtonCaption = {read=FClearTabButtonCaption, write=FClearTabButtonCaption};
	__property System::UnicodeString ClearAllButtonCaption = {read=FClearAllButtonCaption, write=FClearAllButtonCaption};
	__property System::UnicodeString TabPositionEditHint = {read=FTabPositionEditHint, write=FTabPositionEditHint};
	__property System::UnicodeString ListBoxHint = {read=FListBoxHint, write=FListBoxHint};
	__property System::UnicodeString SetButtonHint = {read=FSetButtonHint, write=FSetButtonHint};
	__property System::UnicodeString ClearButtonHint = {read=FClearButtonHint, write=FClearButtonHint};
	__property System::UnicodeString ClearAllButtonHint = {read=FClearAllButtonHint, write=FClearAllButtonHint};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwRichEditTabDlg(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TwwRichEditTabDlg(void) : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwDBRichEditIntl : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::UnicodeString FFontNameComboHint;
	System::UnicodeString FFontSizeComboHint;
	System::UnicodeString FNewButtonHint;
	System::UnicodeString FLoadButtonHint;
	System::UnicodeString FSaveAsButtonHint;
	System::UnicodeString FPrintButtonHint;
	System::UnicodeString FPrintPreviewButtonHint;
	System::UnicodeString FFindButtonHint;
	System::UnicodeString FCutButtonHint;
	System::UnicodeString FCopyButtonHint;
	System::UnicodeString FUndoButtonHint;
	System::UnicodeString FRedoButtonHint;
	System::UnicodeString FZoomComboHint;
	System::UnicodeString FPasteButtonHint;
	System::UnicodeString FBoldButtonHint;
	System::UnicodeString FColorButtonHint;
	System::UnicodeString FUnderlineButtonHint;
	System::UnicodeString FItalicButtonHint;
	System::UnicodeString FLeftButtonHint;
	System::UnicodeString FCenterButtonHint;
	System::UnicodeString FRightButtonHint;
	System::UnicodeString FJustifyButtonHint;
	System::UnicodeString FBulletButtonHint;
	System::UnicodeString FNumberingButtonHint;
	System::UnicodeString FHighlightButtonHint;
	System::UnicodeString FFormatCaptionHint;
	System::UnicodeString FSaveExitHint;
	System::UnicodeString FPageSetupHint;
	System::UnicodeString FExitHint;
	System::UnicodeString FClearHint;
	System::UnicodeString FSelectAllHint;
	System::UnicodeString FFindNextHint;
	System::UnicodeString FReplaceHint;
	System::UnicodeString FInsertObjectHint;
	System::UnicodeString FSpellCheckHint;
	System::UnicodeString FToolbarHint;
	System::UnicodeString FFormatBarHint;
	System::UnicodeString FViewStatusBarHint;
	System::UnicodeString FOptionsHint;
	System::UnicodeString FFontHint;
	System::UnicodeString FParagraphHint;
	System::UnicodeString FTabsHint;
	TwwRichEditMenuLabels* FMenuLabels;
	TwwRichEditPopupMenuLabels* FPopupMenuLabels;
	TwwRichEditParagraphDlg* FParagraphDialog;
	TwwRichEditTabDlg* FTabDialog;
	System::UnicodeString FCAPLockCaption;
	System::UnicodeString FNUMLockCaption;
	
public:
	__fastcall virtual ~TwwDBRichEditIntl(void);
	
__published:
	__property System::UnicodeString FontNameComboHint = {read=FFontNameComboHint, write=FFontNameComboHint};
	__property System::UnicodeString FontSizeComboHint = {read=FFontSizeComboHint, write=FFontSizeComboHint};
	__property System::UnicodeString NewButtonHint = {read=FNewButtonHint, write=FNewButtonHint};
	__property System::UnicodeString LoadButtonHint = {read=FLoadButtonHint, write=FLoadButtonHint};
	__property System::UnicodeString SaveAsButtonHint = {read=FSaveAsButtonHint, write=FSaveAsButtonHint};
	__property System::UnicodeString PrintButtonHint = {read=FPrintButtonHint, write=FPrintButtonHint};
	__property System::UnicodeString PrintPreviewButtonHint = {read=FPrintPreviewButtonHint, write=FPrintPreviewButtonHint};
	__property System::UnicodeString FindButtonHint = {read=FFindButtonHint, write=FFindButtonHint};
	__property System::UnicodeString CutButtonHint = {read=FCutButtonHint, write=FCutButtonHint};
	__property System::UnicodeString CopyButtonHint = {read=FCopyButtonHint, write=FCopyButtonHint};
	__property System::UnicodeString UndoButtonHint = {read=FUndoButtonHint, write=FUndoButtonHint};
	__property System::UnicodeString RedoButtonHint = {read=FRedoButtonHint, write=FRedoButtonHint};
	__property System::UnicodeString ZoomComboHint = {read=FZoomComboHint, write=FZoomComboHint};
	__property System::UnicodeString PasteButtonHint = {read=FPasteButtonHint, write=FPasteButtonHint};
	__property System::UnicodeString BoldButtonHint = {read=FBoldButtonHint, write=FBoldButtonHint};
	__property System::UnicodeString ColorButtonHint = {read=FColorButtonHint, write=FColorButtonHint};
	__property System::UnicodeString UnderlineButtonHint = {read=FUnderlineButtonHint, write=FUnderlineButtonHint};
	__property System::UnicodeString ItalicButtonHint = {read=FItalicButtonHint, write=FItalicButtonHint};
	__property System::UnicodeString LeftButtonHint = {read=FLeftButtonHint, write=FLeftButtonHint};
	__property System::UnicodeString CenterButtonHint = {read=FCenterButtonHint, write=FCenterButtonHint};
	__property System::UnicodeString RightButtonHint = {read=FRightButtonHint, write=FRightButtonHint};
	__property System::UnicodeString JustifyButtonHint = {read=FJustifyButtonHint, write=FJustifyButtonHint};
	__property System::UnicodeString BulletButtonHint = {read=FBulletButtonHint, write=FBulletButtonHint};
	__property System::UnicodeString NumberingButtonHint = {read=FNumberingButtonHint, write=FNumberingButtonHint};
	__property System::UnicodeString HighlightButtonHint = {read=FHighlightButtonHint, write=FHighlightButtonHint};
	__property System::UnicodeString FormatCaptionHint = {read=FFormatCaptionHint, write=FFormatCaptionHint};
	__property System::UnicodeString SaveExitHint = {read=FSaveExitHint, write=FSaveExitHint};
	__property System::UnicodeString PageSetupHint = {read=FPageSetupHint, write=FPageSetupHint};
	__property System::UnicodeString ExitHint = {read=FExitHint, write=FExitHint};
	__property System::UnicodeString ClearHint = {read=FClearHint, write=FClearHint};
	__property System::UnicodeString SelectAllHint = {read=FSelectAllHint, write=FSelectAllHint};
	__property System::UnicodeString FindNextHint = {read=FFindNextHint, write=FFindNextHint};
	__property System::UnicodeString ReplaceHint = {read=FReplaceHint, write=FReplaceHint};
	__property System::UnicodeString InsertObjectHint = {read=FInsertObjectHint, write=FInsertObjectHint};
	__property System::UnicodeString SpellCheckHint = {read=FSpellCheckHint, write=FSpellCheckHint};
	__property System::UnicodeString ToolbarHint = {read=FToolbarHint, write=FToolbarHint};
	__property System::UnicodeString FormatBarHint = {read=FFormatBarHint, write=FFormatBarHint};
	__property System::UnicodeString ViewStatusBarHint = {read=FViewStatusBarHint, write=FViewStatusBarHint};
	__property System::UnicodeString OptionsHint = {read=FOptionsHint, write=FOptionsHint};
	__property System::UnicodeString FontHint = {read=FFontHint, write=FFontHint};
	__property System::UnicodeString ParagraphHint = {read=FParagraphHint, write=FParagraphHint};
	__property System::UnicodeString TabsHint = {read=FTabsHint, write=FTabsHint};
	__property System::UnicodeString CAPLockCaption = {read=FCAPLockCaption, write=FCAPLockCaption};
	__property System::UnicodeString NUMLockCaption = {read=FNUMLockCaption, write=FNUMLockCaption};
	__property TwwRichEditMenuLabels* MenuLabels = {read=FMenuLabels, write=FMenuLabels};
	__property TwwRichEditPopupMenuLabels* PopupMenuLabels = {read=FPopupMenuLabels, write=FPopupMenuLabels};
	__property TwwRichEditParagraphDlg* ParagraphDialog = {read=FParagraphDialog, write=FParagraphDialog};
	__property TwwRichEditTabDlg* TabDialog = {read=FTabDialog, write=FTabDialog};
public:
	/* TObject.Create */ inline __fastcall TwwDBRichEditIntl(void) : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwSearchDialogIntl : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::UnicodeString FSearchCharLabel;
	System::UnicodeString FSearchCharShortLabel;
	System::UnicodeString FSearchByLabel;
	System::UnicodeString FStatusRecLabel;
	System::UnicodeString FStatusOfLabel;
	System::UnicodeString FSearchCharHint;
	System::UnicodeString FSearchByHint;
	
__published:
	__property System::UnicodeString SearchCharLabel = {read=FSearchCharLabel, write=FSearchCharLabel};
	__property System::UnicodeString SearchCharShortLabel = {read=FSearchCharShortLabel, write=FSearchCharShortLabel};
	__property System::UnicodeString SearchByLabel = {read=FSearchByLabel, write=FSearchByLabel};
	__property System::UnicodeString StatusRecLabel = {read=FStatusRecLabel, write=FStatusRecLabel};
	__property System::UnicodeString StatusOfLabel = {read=FStatusOfLabel, write=FStatusOfLabel};
	__property System::UnicodeString SearchCharHint = {read=FSearchCharHint, write=FSearchCharHint};
	__property System::UnicodeString SearchByHint = {read=FSearchByHint, write=FSearchByHint};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwSearchDialogIntl(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TwwSearchDialogIntl(void) : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwMonthCalendarIntl : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::UnicodeString FPopupYearLabel;
	System::UnicodeString FEnterYearPrompt;
	int FPopupYearStart;
	
__published:
	__property System::UnicodeString PopupYearLabel = {read=FPopupYearLabel, write=FPopupYearLabel};
	__property System::UnicodeString EnterYearPrompt = {read=FEnterYearPrompt, write=FEnterYearPrompt};
	__property int PopupYearStart = {read=FPopupYearStart, write=FPopupYearStart, default=2000};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwMonthCalendarIntl(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TwwMonthCalendarIntl(void) : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwGridTitleMenuIntl : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::UnicodeString FSortSmallesttoLargestCaption;
	System::UnicodeString FSortLargesttoSmallestCaption;
	System::UnicodeString FClearFilterCaption;
	System::UnicodeString FNumberFiltersCaption;
	System::UnicodeString FNumberFiltersCaptionEquals;
	System::UnicodeString FNumberFiltersCaptionDoesNotEqual;
	System::UnicodeString FNumberFiltersCaptionLessThan;
	System::UnicodeString FNumberFiltersCaptionGreaterThan;
	System::UnicodeString FNumberFiltersCaptionBetween;
	System::UnicodeString FDateFiltersCaption;
	System::UnicodeString FDateFiltersCaptionEquals;
	System::UnicodeString FDateFiltersCaptionBefore;
	System::UnicodeString FDateFiltersCaptionAfter;
	System::UnicodeString FDateFiltersCaptionBetween;
	System::UnicodeString FDateFiltersCaptionTomorrow;
	System::UnicodeString FDateFiltersCaptionToday;
	System::UnicodeString FDateFiltersCaptionYesterday;
	System::UnicodeString FDateFiltersCaptionNextWeek;
	System::UnicodeString FDateFiltersCaptionThisWeek;
	System::UnicodeString FDateFiltersCaptionLastWeek;
	System::UnicodeString FDateFiltersCaptionNextMonth;
	System::UnicodeString FDateFiltersCaptionThisMonth;
	System::UnicodeString FDateFiltersCaptionLastMonth;
	System::UnicodeString FDateFiltersCaptionNextQuarter;
	System::UnicodeString FDateFiltersCaptionThisQuarter;
	System::UnicodeString FDateFiltersCaptionLastQuarter;
	System::UnicodeString FDateFiltersCaptionNextYear;
	System::UnicodeString FDateFiltersCaptionThisYear;
	System::UnicodeString FDateFiltersCaptionLastYear;
	System::UnicodeString FTextFiltersCaption;
	System::UnicodeString FTextFiltersCaptionEquals;
	System::UnicodeString FTextFiltersCaptionDoesNotEqual;
	System::UnicodeString FTextFiltersCaptionStartsWith;
	System::UnicodeString FTextFiltersCaptionDoesNotStartWith;
	System::UnicodeString FTextFiltersCaptionContains;
	System::UnicodeString FTextFiltersCaptionDoesNotContain;
	System::UnicodeString FTextFiltersCaptionEndsWith;
	System::UnicodeString FTextFiltersCaptionDoesNotEndWith;
	System::UnicodeString FClearGroupByCaption;
	System::UnicodeString FGroupByCaption;
	System::UnicodeString FColumnsCaption;
	System::UnicodeString FColumnsCaptionRemove;
	System::UnicodeString FColumnsCaptionAddAfter;
	System::UnicodeString FColumnsCaptionAddBefore;
	System::UnicodeString FBetweenDialogLargestCaption;
	System::UnicodeString FBetweenDialogSmallestCaption;
	System::UnicodeString FBetweenDialogOldestCaption;
	System::UnicodeString FBetweenDialogNewestCaption;
	System::UnicodeString FBetweenDialogCaption;
	System::UnicodeString FSelectColumnsDialogCaption;
	
__published:
	__property System::UnicodeString SortSmallesttoLargestCaption = {read=FSortSmallesttoLargestCaption, write=FSortSmallesttoLargestCaption};
	__property System::UnicodeString SortLargesttoSmallestCaption = {read=FSortLargesttoSmallestCaption, write=FSortLargesttoSmallestCaption};
	__property System::UnicodeString ClearFilterCaption = {read=FClearFilterCaption, write=FClearFilterCaption};
	__property System::UnicodeString NumberFiltersCaption = {read=FNumberFiltersCaption, write=FNumberFiltersCaption};
	__property System::UnicodeString NumberFiltersCaptionEquals = {read=FNumberFiltersCaptionEquals, write=FNumberFiltersCaptionEquals};
	__property System::UnicodeString NumberFiltersCaptionDoesNotEqual = {read=FNumberFiltersCaptionDoesNotEqual, write=FNumberFiltersCaptionDoesNotEqual};
	__property System::UnicodeString NumberFiltersCaptionLessThan = {read=FNumberFiltersCaptionLessThan, write=FNumberFiltersCaptionLessThan};
	__property System::UnicodeString NumberFiltersCaptionGreaterThan = {read=FNumberFiltersCaptionGreaterThan, write=FNumberFiltersCaptionGreaterThan};
	__property System::UnicodeString NumberFiltersCaptionBetween = {read=FNumberFiltersCaptionBetween, write=FNumberFiltersCaptionBetween};
	__property System::UnicodeString DateFiltersCaption = {read=FDateFiltersCaption, write=FDateFiltersCaption};
	__property System::UnicodeString DateFiltersCaptionEquals = {read=FDateFiltersCaptionEquals, write=FDateFiltersCaptionEquals};
	__property System::UnicodeString DateFiltersCaptionBefore = {read=FDateFiltersCaptionBefore, write=FDateFiltersCaptionBefore};
	__property System::UnicodeString DateFiltersCaptionAfter = {read=FDateFiltersCaptionAfter, write=FDateFiltersCaptionAfter};
	__property System::UnicodeString DateFiltersCaptionBetween = {read=FDateFiltersCaptionBetween, write=FDateFiltersCaptionBetween};
	__property System::UnicodeString DateFiltersCaptionTomorrow = {read=FDateFiltersCaptionTomorrow, write=FDateFiltersCaptionTomorrow};
	__property System::UnicodeString DateFiltersCaptionToday = {read=FDateFiltersCaptionToday, write=FDateFiltersCaptionToday};
	__property System::UnicodeString DateFiltersCaptionYesterday = {read=FDateFiltersCaptionYesterday, write=FDateFiltersCaptionYesterday};
	__property System::UnicodeString DateFiltersCaptionNextWeek = {read=FDateFiltersCaptionNextWeek, write=FDateFiltersCaptionNextWeek};
	__property System::UnicodeString DateFiltersCaptionThisWeek = {read=FDateFiltersCaptionThisWeek, write=FDateFiltersCaptionThisWeek};
	__property System::UnicodeString DateFiltersCaptionLastWeek = {read=FDateFiltersCaptionLastWeek, write=FDateFiltersCaptionLastWeek};
	__property System::UnicodeString DateFiltersCaptionNextMonth = {read=FDateFiltersCaptionNextMonth, write=FDateFiltersCaptionNextMonth};
	__property System::UnicodeString DateFiltersCaptionThisMonth = {read=FDateFiltersCaptionThisMonth, write=FDateFiltersCaptionThisMonth};
	__property System::UnicodeString DateFiltersCaptionLastMonth = {read=FDateFiltersCaptionLastMonth, write=FDateFiltersCaptionLastMonth};
	__property System::UnicodeString DateFiltersCaptionNextQuarter = {read=FDateFiltersCaptionNextQuarter, write=FDateFiltersCaptionNextQuarter};
	__property System::UnicodeString DateFiltersCaptionThisQuarter = {read=FDateFiltersCaptionThisQuarter, write=FDateFiltersCaptionThisQuarter};
	__property System::UnicodeString DateFiltersCaptionLastQuarter = {read=FDateFiltersCaptionLastQuarter, write=FDateFiltersCaptionLastQuarter};
	__property System::UnicodeString DateFiltersCaptionNextYear = {read=FDateFiltersCaptionNextYear, write=FDateFiltersCaptionNextYear};
	__property System::UnicodeString DateFiltersCaptionThisYear = {read=FDateFiltersCaptionThisYear, write=FDateFiltersCaptionThisYear};
	__property System::UnicodeString DateFiltersCaptionLastYear = {read=FDateFiltersCaptionLastYear, write=FDateFiltersCaptionLastYear};
	__property System::UnicodeString TextFiltersCaption = {read=FTextFiltersCaption, write=FTextFiltersCaption};
	__property System::UnicodeString TextFiltersCaptionEquals = {read=FTextFiltersCaptionEquals, write=FTextFiltersCaptionEquals};
	__property System::UnicodeString TextFiltersCaptionDoesNotEqual = {read=FTextFiltersCaptionDoesNotEqual, write=FTextFiltersCaptionDoesNotEqual};
	__property System::UnicodeString TextFiltersCaptionStartsWith = {read=FTextFiltersCaptionStartsWith, write=FTextFiltersCaptionStartsWith};
	__property System::UnicodeString TextFiltersCaptionDoesNotStartWith = {read=FTextFiltersCaptionDoesNotStartWith, write=FTextFiltersCaptionDoesNotStartWith};
	__property System::UnicodeString TextFiltersCaptionContains = {read=FTextFiltersCaptionContains, write=FTextFiltersCaptionContains};
	__property System::UnicodeString TextFiltersCaptionDoesNotContain = {read=FTextFiltersCaptionDoesNotContain, write=FTextFiltersCaptionDoesNotContain};
	__property System::UnicodeString TextFiltersCaptionEndsWith = {read=FTextFiltersCaptionEndsWith, write=FTextFiltersCaptionEndsWith};
	__property System::UnicodeString TextFiltersCaptionDoesNotendWith = {read=FTextFiltersCaptionDoesNotEndWith, write=FTextFiltersCaptionDoesNotEndWith};
	__property System::UnicodeString ClearGroupByCaption = {read=FClearGroupByCaption, write=FClearGroupByCaption};
	__property System::UnicodeString GroupByCaption = {read=FGroupByCaption, write=FGroupByCaption};
	__property System::UnicodeString ColumnsCaption = {read=FColumnsCaption, write=FColumnsCaption};
	__property System::UnicodeString ColumnsCaptionRemove = {read=FColumnsCaptionRemove, write=FColumnsCaptionRemove};
	__property System::UnicodeString ColumnsCaptionAddAfter = {read=FColumnsCaptionAddAfter, write=FColumnsCaptionAddAfter};
	__property System::UnicodeString ColumnsCaptionAddBefore = {read=FColumnsCaptionAddBefore, write=FColumnsCaptionAddBefore};
	__property System::UnicodeString BetweenDialogLargestCaption = {read=FBetweenDialogLargestCaption, write=FBetweenDialogLargestCaption};
	__property System::UnicodeString BetweenDialogSmallestCaption = {read=FBetweenDialogSmallestCaption, write=FBetweenDialogSmallestCaption};
	__property System::UnicodeString BetweenDialogOldestCaption = {read=FBetweenDialogOldestCaption, write=FBetweenDialogOldestCaption};
	__property System::UnicodeString BetweenDialogNewestCaption = {read=FBetweenDialogNewestCaption, write=FBetweenDialogNewestCaption};
	__property System::UnicodeString BetweenDialogCaption = {read=FBetweenDialogCaption, write=FBetweenDialogCaption};
	__property System::UnicodeString SelectColumnsDialogCaption = {read=FSelectColumnsDialogCaption, write=FSelectColumnsDialogCaption};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwGridTitleMenuIntl(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TwwGridTitleMenuIntl(void) : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwLocateDialogIntl : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::UnicodeString FFieldValueLabel;
	System::UnicodeString FSearchTypeLabel;
	System::UnicodeString FCaseSensitiveLabel;
	System::UnicodeString FMatchExactLabel;
	System::UnicodeString FMatchStartLabel;
	System::UnicodeString FMatchAnyLabel;
	System::UnicodeString FFieldsLabel;
	System::UnicodeString FButtonFirst;
	System::UnicodeString FButtonNext;
	System::UnicodeString FButtonCancel;
	System::UnicodeString FButtonClose;
	System::UnicodeString FFieldValueHint;
	System::UnicodeString FCaseSensitiveHint;
	System::UnicodeString FMatchExactHint;
	System::UnicodeString FMatchStartHint;
	System::UnicodeString FMatchAnyHint;
	System::UnicodeString FButtonFirstHint;
	System::UnicodeString FButtonNextHint;
	System::UnicodeString FFieldNameHint;
	
__published:
	__property System::UnicodeString FieldValueLabel = {read=FFieldValueLabel, write=FFieldValueLabel};
	__property System::UnicodeString SearchTypeLabel = {read=FSearchTypeLabel, write=FSearchTypeLabel};
	__property System::UnicodeString CaseSensitiveLabel = {read=FCaseSensitiveLabel, write=FCaseSensitiveLabel};
	__property System::UnicodeString MatchExactLabel = {read=FMatchExactLabel, write=FMatchExactLabel};
	__property System::UnicodeString MatchStartLabel = {read=FMatchStartLabel, write=FMatchStartLabel};
	__property System::UnicodeString MatchAnyLabel = {read=FMatchAnyLabel, write=FMatchAnyLabel};
	__property System::UnicodeString FieldsLabel = {read=FFieldsLabel, write=FFieldsLabel};
	__property System::UnicodeString BtnFirst = {read=FButtonFirst, write=FButtonFirst};
	__property System::UnicodeString BtnNext = {read=FButtonNext, write=FButtonNext};
	__property System::UnicodeString BtnCancel = {read=FButtonCancel, write=FButtonCancel};
	__property System::UnicodeString BtnClose = {read=FButtonClose, write=FButtonClose};
	__property System::UnicodeString FieldValueHint = {read=FFieldValueHint, write=FFieldValueHint};
	__property System::UnicodeString CaseSensitiveHint = {read=FCaseSensitiveHint, write=FCaseSensitiveHint};
	__property System::UnicodeString MatchExactHint = {read=FMatchExactHint, write=FMatchExactHint};
	__property System::UnicodeString MatchStartHint = {read=FMatchStartHint, write=FMatchStartHint};
	__property System::UnicodeString MatchAnyHint = {read=FMatchAnyHint, write=FMatchAnyHint};
	__property System::UnicodeString BtnFirstHint = {read=FButtonFirstHint, write=FButtonFirstHint};
	__property System::UnicodeString BtnNextHint = {read=FButtonNextHint, write=FButtonNextHint};
	__property System::UnicodeString FieldNameHint = {read=FFieldNameHint, write=FFieldNameHint};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwLocateDialogIntl(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TwwLocateDialogIntl(void) : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwDBNavigatorIntlHints : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::UnicodeString FFirstHint;
	System::UnicodeString FPriorHint;
	System::UnicodeString FNextHint;
	System::UnicodeString FLastHint;
	System::UnicodeString FInsertHint;
	System::UnicodeString FDeleteHint;
	System::UnicodeString FEditHint;
	System::UnicodeString FPostHint;
	System::UnicodeString FCancelHint;
	System::UnicodeString FRefreshHint;
	System::UnicodeString FPriorPageHint;
	System::UnicodeString FNextPageHint;
	System::UnicodeString FSaveBookmarkHint;
	System::UnicodeString FRestoreBookmarkHint;
	System::UnicodeString FRecordViewDialogHint;
	System::UnicodeString FLocateDialogHint;
	System::UnicodeString FFilterDialogHint;
	System::UnicodeString FSearchDialogHint;
	
public:
	__fastcall TwwDBNavigatorIntlHints(void);
	
__published:
	__property System::UnicodeString FirstHint = {read=FFirstHint, write=FFirstHint};
	__property System::UnicodeString PriorHint = {read=FPriorHint, write=FPriorHint};
	__property System::UnicodeString NextHint = {read=FNextHint, write=FNextHint};
	__property System::UnicodeString LastHint = {read=FLastHint, write=FLastHint};
	__property System::UnicodeString InsertHint = {read=FInsertHint, write=FInsertHint};
	__property System::UnicodeString DeleteHint = {read=FDeleteHint, write=FDeleteHint};
	__property System::UnicodeString EditHint = {read=FEditHint, write=FEditHint};
	__property System::UnicodeString PostHint = {read=FPostHint, write=FPostHint};
	__property System::UnicodeString CancelHint = {read=FCancelHint, write=FCancelHint};
	__property System::UnicodeString RefreshHint = {read=FRefreshHint, write=FRefreshHint};
	__property System::UnicodeString PriorPageHint = {read=FPriorPageHint, write=FPriorPageHint};
	__property System::UnicodeString NextPageHint = {read=FNextPageHint, write=FNextPageHint};
	__property System::UnicodeString SaveBookmarkHint = {read=FSaveBookmarkHint, write=FSaveBookmarkHint};
	__property System::UnicodeString RestoreBookmarkHint = {read=FRestoreBookmarkHint, write=FRestoreBookmarkHint};
	__property System::UnicodeString RecordViewDialogHint = {read=FRecordViewDialogHint, write=FRecordViewDialogHint};
	__property System::UnicodeString LocateDialogHint = {read=FLocateDialogHint, write=FLocateDialogHint};
	__property System::UnicodeString FilterDialogHint = {read=FFilterDialogHint, write=FFilterDialogHint};
	__property System::UnicodeString SearchDialogHint = {read=FSearchDialogHint, write=FSearchDialogHint};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwDBNavigatorIntlHints(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwADOIntl : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	bool FUseLocateWhenFindingValue;
	
__published:
	__property bool UseLocateWhenFindingValue = {read=FUseLocateWhenFindingValue, write=FUseLocateWhenFindingValue, default=1};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwADOIntl(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TwwADOIntl(void) : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwDBNavigatorIntl : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::UnicodeString FConfirmDeleteMessage;
	TwwDBNavigatorIntlHints* FHints;
	
public:
	__fastcall TwwDBNavigatorIntl(void);
	__fastcall virtual ~TwwDBNavigatorIntl(void);
	
__published:
	__property System::UnicodeString ConfirmDeleteMessage = {read=FConfirmDeleteMessage, write=FConfirmDeleteMessage};
	__property TwwDBNavigatorIntlHints* Hints = {read=FHints, write=FHints};
};

#pragma pack(pop)

enum DECLSPEC_DENUM TwwCheckBoxInGridStyle : unsigned char { cbStyleAuto, cbStyleCheckmark, cbStyleXmark, cbStyleCheckmarkFlat };

enum DECLSPEC_DENUM TwwGridPaintStyle : unsigned char { gpsBitmapCanvas, gpsDynamicDeviceContext };

typedef void __fastcall (__closure *TwwOnInitInfoPowerDialogEvent)(System::TObject* InfoPowerComponent, Vcl::Forms::TCustomForm* Dialog);

class PASCALIMPLEMENTATION TwwIntl : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	TwwADOIntl* FADO;
	TwwDBNavigatorIntl* FNavigator;
	TwwSearchDialogIntl* FSearchDialog;
	TwwLocateDialogIntl* FLocateDialog;
	TwwMonthCalendarIntl* FMonthCalendar;
	TwwGridTitleMenuIntl* FGridTitleMenu;
	bool FGridTitlesAlwaysUseStyle;
	bool FOKCancelBitmapped;
	System::Uitypes::TFontStyles FDialogFontStyle;
	System::UnicodeString FBtnOKCaption;
	System::UnicodeString FBtnCancelCaption;
	bool FConnected;
	TwwUserMessagesIntl* FUserMessages;
	TwwCompatibilityIntl* FCompatibility;
	TwwFilterDialogIntl* FFilterDialog;
	TwwValidationFeedback* FValidationFeedback;
	TwwDBRichEditIntl* FRichEdit;
	System::UnicodeString FIPVersion;
	System::UnicodeString FIniFileName;
	System::UnicodeString FRegistrationNo;
	bool FFastSQLCancelRange;
	TwwCheckBoxInGridStyle FCheckBoxInGridStyle;
	TwwGridPaintStyle FGridPaintStyle;
	bool FUseLocateMethodForSearch;
	int FDefaultEpochYear;
	int FFilterMemoSize;
	TwwPictureValidationError FOnValidationErrorUsingMask;
	TwwOnInitInfoPowerDialogEvent FOnInitInfoPowerDialog;
	void __fastcall SetConnected(bool val);
	void __fastcall SetIPVersion(System::UnicodeString val);
	void __fastcall SetRegistrationNo(System::UnicodeString val);
	void __fastcall SetCheckboxInGridStyle(TwwCheckBoxInGridStyle val);
	void __fastcall SetGridPaintStyle(TwwGridPaintStyle val);
	
protected:
	virtual void __fastcall Loaded(void);
	void __fastcall Connect(void);
	
public:
	bool EssentialsWarningDisplayed;
	__fastcall virtual TwwIntl(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwIntl(void);
	virtual void __fastcall ValidationErrorUsingMask(System::Classes::TComponent* Component, Data::Db::TField* Field, System::UnicodeString Msg = System::UnicodeString());
	__property bool FastSQLCancelRange = {read=FFastSQLCancelRange, write=FFastSQLCancelRange, nodefault};
	static System::Generics::Collections::TObjectList__1<Vcl::Controls::TControl*>* GridCheckControls;
	
__published:
	__property TwwADOIntl* ADO = {read=FADO, write=FADO};
	__property TwwDBNavigatorIntl* Navigator = {read=FNavigator, write=FNavigator};
	__property TwwSearchDialogIntl* SearchDialog = {read=FSearchDialog, write=FSearchDialog};
	__property TwwLocateDialogIntl* LocateDialog = {read=FLocateDialog, write=FLocateDialog};
	__property TwwMonthCalendarIntl* MonthCalendar = {read=FMonthCalendar, write=FMonthCalendar};
	__property TwwGridTitleMenuIntl* GridTitleMenu = {read=FGridTitleMenu, write=FGridTitleMenu};
	__property bool GridTitlesAlwaysUseStyle = {read=FGridTitlesAlwaysUseStyle, write=FGridTitlesAlwaysUseStyle, nodefault};
	__property TwwFilterDialogIntl* FilterDialog = {read=FFilterDialog, write=FFilterDialog};
	__property TwwValidationFeedback* ValidationFeedback = {read=FValidationFeedback, write=FValidationFeedback};
	__property TwwDBRichEditIntl* RichEdit = {read=FRichEdit, write=FRichEdit};
	__property TwwUserMessagesIntl* UserMessages = {read=FUserMessages, write=FUserMessages};
	__property TwwCompatibilityIntl* Compatibilty = {read=FCompatibility, write=FCompatibility};
	__property bool OKCancelBitmapped = {read=FOKCancelBitmapped, write=FOKCancelBitmapped, nodefault};
	__property System::UnicodeString BtnOKCaption = {read=FBtnOKCaption, write=FBtnOKCaption};
	__property System::UnicodeString BtnCancelCaption = {read=FBtnCancelCaption, write=FBtnCancelCaption};
	__property TwwCheckBoxInGridStyle CheckBoxInGridStyle = {read=FCheckBoxInGridStyle, write=SetCheckboxInGridStyle, nodefault};
	__property TwwGridPaintStyle GridPaintStyle = {read=FGridPaintStyle, write=SetGridPaintStyle, default=1};
	__property System::UnicodeString VersionInfoPower = {read=FIPVersion, write=SetIPVersion};
	__property int FilterMemoSize = {read=FFilterMemoSize, write=FFilterMemoSize, nodefault};
	__property System::UnicodeString IniFileName = {read=FIniFileName, write=FIniFileName};
	__property bool UseLocateMethodForSearch = {read=FUseLocateMethodForSearch, write=FUseLocateMethodForSearch, default=1};
	__property System::Uitypes::TFontStyles DialogFontStyle = {read=FDialogFontStyle, write=FDialogFontStyle, nodefault};
	__property int DefaultEpochYear = {read=FDefaultEpochYear, write=FDefaultEpochYear, default=1950};
	__property System::UnicodeString RegistrationNo = {read=FRegistrationNo, write=SetRegistrationNo, stored=false};
	__property TwwPictureValidationError OnValidationErrorUsingMask = {read=FOnValidationErrorUsingMask, write=FOnValidationErrorUsingMask};
	__property TwwOnInitInfoPowerDialogEvent OnInitInfoPowerDialog = {read=FOnInitInfoPowerDialog, write=FOnInitInfoPowerDialog};
	__property bool Connected = {read=FConnected, write=SetConnected, nodefault};
};


class PASCALIMPLEMENTATION TwwController : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	Vcl::Wwframe::TwwEditFrame* FFrame;
	Vcl::Wwframe::TwwButtonEffects* FButtonEffects;
	System::Classes::TList* FControlList;
	
protected:
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	
public:
	__fastcall virtual TwwController(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwController(void);
	void __fastcall ApplyFrame(void);
	void __fastcall AddControl(Vcl::Controls::TControl* Control);
	void __fastcall RemoveControl(Vcl::Controls::TControl* Control);
	
__published:
	__property Vcl::Wwframe::TwwEditFrame* Frame = {read=FFrame, write=FFrame};
	__property Vcl::Wwframe::TwwButtonEffects* ButtonEffects = {read=FButtonEffects, write=FButtonEffects};
	__property System::Classes::TList* ControlList = {read=FControlList};
};


//-- var, const, procedure ---------------------------------------------------
static const System::Word wwMonthCalendarPopupStartYearDefault = System::Word(0x7d0);
extern DELPHI_PACKAGE TwwIntl* wwInternational;
extern DELPHI_PACKAGE void __fastcall Register(void);
extern DELPHI_PACKAGE System::Classes::TComponent* __fastcall wwCreateCommonButton(Vcl::Forms::TForm* AOwner, Vcl::Buttons::TBitBtnKind ButtonKind);
}	/* namespace Wwintl */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWINTL)
using namespace Vcl::Wwintl;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwintlHPP
