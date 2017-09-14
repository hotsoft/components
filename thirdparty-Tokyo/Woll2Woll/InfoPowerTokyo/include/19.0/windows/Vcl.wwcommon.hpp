// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.Wwcommon.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwcommonHPP
#define Vcl_WwcommonHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <Data.DB.hpp>
#include <System.SysUtils.hpp>
#include <Vcl.Dialogs.hpp>
#include <vcl.Wwstr.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Controls.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Buttons.hpp>
#include <vcl.wwtypes.hpp>
#include <vcl.wwlocate.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.Themes.hpp>
#include <System.RegularExpressions.hpp>
#include <Vcl.ImgList.hpp>
#include <Winapi.CommCtrl.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>
#include <vcl.Wwbitmap.hpp>
#include <System.Win.Registry.hpp>
#include <System.DateUtils.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwcommon
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
typedef System::UnicodeString wwSmallString;

enum DECLSPEC_DENUM TwwPointSet : unsigned char { psGlyph, psText, psOffset };

typedef System::Set<TwwPointSet, TwwPointSet::psGlyph, TwwPointSet::psOffset> TwwPointSets;

//-- var, const, procedure ---------------------------------------------------
#define WW_DB_COMBO L"Combo"
#define WW_DB_LOOKUP_COMBO L"LookupCombo"
#define WW_DB_EDIT L"CustomEdit"
#define WW_DB_RICHEDIT L"RichEdit"
#define ProductRegistryName L"InfoPowerTokyo"
extern DELPHI_PACKAGE bool IPUseOldGetIndexDefs;
extern DELPHI_PACKAGE Vcl::Wwtypes::TwwInvalidValueEvent __fastcall wwGetOnInvalidValue(Data::Db::TDataSet* DataSet);
extern DELPHI_PACKAGE Vcl::Wwtypes::TwwPerformSearchEvent __fastcall wwGetOnPerformCustomSearch(System::Classes::TComponent* Component);
extern DELPHI_PACKAGE System::TMethod __fastcall wwGetCalcCellColorsEvent(Vcl::Controls::TWinControl* Grid);
extern DELPHI_PACKAGE System::Classes::TComponent* __fastcall wwGetPictureControl(System::Classes::TComponent* Control, Data::Db::TDataSet* DataSet = (Data::Db::TDataSet*)(0x0));
extern DELPHI_PACKAGE System::Classes::TComponent* __fastcall wwGetControlTypeControl(System::Classes::TComponent* Control, Data::Db::TDataSet* DataSet = (Data::Db::TDataSet*)(0x0));
extern DELPHI_PACKAGE System::Classes::TStrings* __fastcall wwGetStrings(System::Classes::TComponent* Component, System::UnicodeString PropertyName);
extern DELPHI_PACKAGE System::Classes::TStrings* __fastcall wwGetPictureMasks(System::Classes::TComponent* DataSet);
extern DELPHI_PACKAGE System::Classes::TStrings* __fastcall wwGetRegexMasks(System::Classes::TComponent* DataSet);
extern DELPHI_PACKAGE System::Classes::TStrings* __fastcall wwGetControlType(System::Classes::TComponent* dataSet);
extern DELPHI_PACKAGE int __fastcall wwGetCommandType(Data::Db::TDataSet* DataSet);
extern DELPHI_PACKAGE int __fastcall wwGetDatabaseCursorType(Data::Db::TDataSet* DataSet);
extern DELPHI_PACKAGE bool __fastcall wwSetDatabaseCursorType(Data::Db::TDataSet* DataSet, int val);
extern DELPHI_PACKAGE bool __fastcall wwSetDatabaseMaxRecords(Data::Db::TDataSet* DataSet, int val);
extern DELPHI_PACKAGE bool __fastcall wwGetValidateWithMask(Data::Db::TDataSet* dataSet);
extern DELPHI_PACKAGE bool __fastcall wwGetControlInfoInDataSet(System::Classes::TComponent* component);
extern DELPHI_PACKAGE bool __fastcall wwGetPictureMaskFromDataSet(System::Classes::TComponent* Component);
extern DELPHI_PACKAGE System::Classes::TStrings* __fastcall wwGetLookupFields(Data::Db::TDataSet* dataSet);
extern DELPHI_PACKAGE System::Classes::TStrings* __fastcall wwGetLookupLinks(Data::Db::TDataSet* dataSet);
extern DELPHI_PACKAGE System::Classes::TList* __fastcall wwGetLookupTables(Data::Db::TDataSet* dataSet);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwDataSetGetLinks(Data::Db::TDataSet* dataSet, System::UnicodeString lookupFieldName);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwDataSetGetDisplayField(Data::Db::TDataSet* dataSet, System::UnicodeString lookupFieldName);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwGetDatabaseName(Data::Db::TDataSet* dataSet);
extern DELPHI_PACKAGE System::Classes::TComponent* __fastcall wwGetConnection(Data::Db::TDataSet* dataSet);
extern DELPHI_PACKAGE bool __fastcall wwHaveDatabase(Data::Db::TDataSet* dataSet);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwGetConnectionString(Data::Db::TDataSet* dataSet);
extern DELPHI_PACKAGE System::Classes::TComponent* __fastcall wwGetIBDatabase(Data::Db::TDataSet* dataSet);
extern DELPHI_PACKAGE bool __fastcall wwSetIBDatabase(Data::Db::TDataSet* Dataset, System::Classes::TComponent* db);
extern DELPHI_PACKAGE bool __fastcall wwGetAlwaysTransparent(Vcl::Controls::TControl* ctrl);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwGetTableName(Data::Db::TDataSet* dataSet);
extern DELPHI_PACKAGE bool __fastcall wwDataSetIsValidField(System::Classes::TComponent* dataset, System::UnicodeString fieldName);
extern DELPHI_PACKAGE void __fastcall wwDataSetUpdateFieldProperties(Data::Db::TDataSet* dataSet, System::Classes::TStrings* selected);
extern DELPHI_PACKAGE bool __fastcall wwDataSet(Data::Db::TDataSet* dataSet);
extern DELPHI_PACKAGE void __fastcall wwDebug(System::UnicodeString s);
extern DELPHI_PACKAGE bool __fastcall wwDataSetLookupDisplayField(Data::Db::TField* curField, System::UnicodeString &LookupValue, Data::Db::TField* &DisplayField);
extern DELPHI_PACKAGE bool __fastcall wwTableFindRecord(Data::Db::TDataSet* LookupTable, System::UnicodeString KeyValue, System::UnicodeString LookupField, Vcl::Wwlocate::TwwLocateMatchType MatchType, bool caseSensitive);
extern DELPHI_PACKAGE bool __fastcall wwDoLookupTable(Data::Db::TDataSet* ALookupTable, Data::Db::TDataSet* DataSet, System::Classes::TStrings* links);
extern DELPHI_PACKAGE bool __fastcall wwisNonBDEField(Data::Db::TField* thisField);
extern DELPHI_PACKAGE bool __fastcall wwisNonPhysicalField(Data::Db::TField* thisField);
extern DELPHI_PACKAGE Data::Db::TField* __fastcall wwDataSet_GetFilterLookupField(Data::Db::TDataSet* dataSet, Data::Db::TField* curfield, const System::TMethod &AMethod);
extern DELPHI_PACKAGE void __fastcall wwDataSetDoOnCalcFields(Data::Db::TDataSet* dataSet, System::Classes::TStrings* FLookupFields, System::Classes::TStrings* FLookupLinks, System::Classes::TList* lookupTables);
extern DELPHI_PACKAGE bool __fastcall wwDataSetSyncLookupTable(Data::Db::TDataSet* dataSet, Data::Db::TDataSet* AlookupTable, System::UnicodeString lookupFieldName, System::UnicodeString &fromField);
extern DELPHI_PACKAGE void __fastcall wwDataSet_GetControl(System::Classes::TComponent* dataSet, System::UnicodeString AFieldName, System::UnicodeString &AControlType, System::UnicodeString &AParameters);
extern DELPHI_PACKAGE void __fastcall wwDataSetRemoveObsolete(System::Classes::TComponent* dataSet, System::Classes::TStrings* FLookupFields, System::Classes::TStrings* FLookupLinks, System::Classes::TStrings* FControlType);
extern DELPHI_PACKAGE void __fastcall wwDataSet_SetControl(System::Classes::TComponent* dataSet, System::UnicodeString AFieldName, System::UnicodeString AComponentType, System::UnicodeString AParameters);
extern DELPHI_PACKAGE bool __fastcall wwFieldIsValidValue(Data::Db::TField* fld, System::UnicodeString key);
extern DELPHI_PACKAGE bool __fastcall wwFieldIsValidLocateValue(Data::Db::TField* fld, System::UnicodeString key);
extern DELPHI_PACKAGE bool __fastcall wwIsValidValue(Data::Db::TFieldType FldType, System::UnicodeString key);
extern DELPHI_PACKAGE void __fastcall wwIsValidValue2(Data::Db::TFieldType FldType, System::UnicodeString key);
extern DELPHI_PACKAGE bool __fastcall wwTableFindNearest(Data::Db::TDataSet* dataSet, System::UnicodeString key, int FieldNo);
extern DELPHI_PACKAGE void __fastcall wwTableChangeIndex(Data::Db::TDataSet* dataSet, Data::Db::TIndexDef* a_indexItem);
extern DELPHI_PACKAGE bool __fastcall wwInPaintCopyState(Vcl::Controls::TControlState ControlState);
extern DELPHI_PACKAGE void __fastcall wwPlayKeystroke(HWND Handle, System::Word VKChar, System::Word VKShift);
extern DELPHI_PACKAGE void __fastcall wwClearAltChar(void);
extern DELPHI_PACKAGE bool __fastcall wwMemAvail(int memSize);
extern DELPHI_PACKAGE void __fastcall wwPictureByField(System::Classes::TComponent* DataSet, System::UnicodeString FieldName, bool FromTable, System::UnicodeString &Mask, bool &AutoFill, bool &UsePictureMask);
extern DELPHI_PACKAGE void __fastcall wwRegexByField(System::Classes::TComponent* DataSet, System::UnicodeString FieldName, System::UnicodeString &Mask, bool &CaseSensitive, System::UnicodeString &ErrorMsg);
extern DELPHI_PACKAGE void __fastcall wwDataModuleChanged(System::Classes::TComponent* temp);
extern DELPHI_PACKAGE void __fastcall wwSetPictureMask(System::Classes::TComponent* dataSet, System::UnicodeString AFieldName, System::UnicodeString AMask, bool AutoFill, bool UsePictureMask, bool SetMask, bool SetAutoFill, bool SetUsePictureMask);
extern DELPHI_PACKAGE void __fastcall wwSetRegexMasks(System::Classes::TComponent* dataSet, System::UnicodeString AFieldName, System::UnicodeString AMask, bool CaseSensitive, System::UnicodeString ErrorMsg);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwGetFieldNameFromTitle(Data::Db::TDataSet* DataSet, System::UnicodeString fieldTitle);
extern DELPHI_PACKAGE int __fastcall wwGetListIndex(System::Classes::TStrings* list, System::UnicodeString itemName);
extern DELPHI_PACKAGE Vcl::Forms::TCustomForm* __fastcall wwGetOwnerForm(System::Classes::TComponent* component);
extern DELPHI_PACKAGE System::Classes::TComponent* __fastcall wwGetOwnerFrameOrForm(System::Classes::TComponent* component);
extern DELPHI_PACKAGE bool __fastcall isWWEditControl(System::UnicodeString pname);
extern DELPHI_PACKAGE void __fastcall wwDrawGlyph(Vcl::Graphics::TBitmap* Bitmap, Vcl::Graphics::TCanvas* Canvas, const System::Types::TRect &R, Vcl::Buttons::TButtonState State, bool Enabled, bool Transparent, bool FlatButtonTransparent, Vcl::Controls::TControlState ControlState);
extern DELPHI_PACKAGE void __fastcall wwDrawEllipsis(Vcl::Graphics::TCanvas* Canvas, const System::Types::TRect &R, Vcl::Buttons::TButtonState State, bool Enabled, bool Transparent, bool FlatButtonTransparent, Vcl::Controls::TControlState ControlState);
extern DELPHI_PACKAGE void __fastcall wwDrawDropDownArrow(Vcl::Graphics::TCanvas* Canvas, const System::Types::TRect &R, Vcl::Buttons::TButtonState State, bool Enabled, Vcl::Controls::TControlState ControlState);
extern DELPHI_PACKAGE bool __fastcall wwHasIndex(Data::Db::TDataSet* ADataSet);
extern DELPHI_PACKAGE bool __fastcall wwIsTableQuery(Data::Db::TDataSet* ADataSet);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwPdxPictureMask(Data::Db::TDataSet* ADataSet, System::UnicodeString AFieldName);
extern DELPHI_PACKAGE void __fastcall wwFixMouseDown(void);
extern DELPHI_PACKAGE void __fastcall wwValidatePictureFields(Data::Db::TDataSet* ADataSet, Vcl::Wwtypes::TwwInvalidValueEvent FOnInvalidValue);
extern DELPHI_PACKAGE bool __fastcall wwDataSetFindRecord(Data::Db::TDataSet* DataSet, System::UnicodeString KeyValue, System::UnicodeString LookupField, Vcl::Wwlocate::TwwLocateMatchType MatchType, bool caseSensitive);
extern DELPHI_PACKAGE bool __fastcall wwValidFilterableFieldType(Data::Db::TFieldType ADataType);
extern DELPHI_PACKAGE void __fastcall wwALinkHelp(HWND Handle, System::UnicodeString ALink);
extern DELPHI_PACKAGE void __fastcall wwHelp(HWND Handle, System::WideChar * HelpTopic);
extern DELPHI_PACKAGE bool __fastcall wwIsValidChar(System::Word key);
extern DELPHI_PACKAGE void __fastcall wwDataSet_SetLookupLink(Data::Db::TDataSet* dataSet, System::UnicodeString FldName, System::UnicodeString DatabaseName, System::UnicodeString TableName, System::UnicodeString DisplayFld, System::UnicodeString IndexFieldNames, System::UnicodeString Links, System::WideChar useExtension);
extern DELPHI_PACKAGE void __fastcall wwDataSetUpdateSelected(Data::Db::TDataSet* dataSet, System::Classes::TStrings* selected);
extern DELPHI_PACKAGE bool __fastcall wwFindSelected(System::Classes::TStrings* selected, System::UnicodeString FieldName, int &index);
extern DELPHI_PACKAGE int __fastcall wwAdjustPixels(int PixelSize, int PixelsPerInch);
extern DELPHI_PACKAGE void __fastcall wwSetOnFilterEnabled(Data::Db::TDataSet* dataset, bool val);
extern DELPHI_PACKAGE Vcl::Wwtypes::TwwOnFilterOptions __fastcall wwGetOnFilterOptions(Data::Db::TDataSet* dataset);
extern DELPHI_PACKAGE bool __fastcall wwProcessEscapeFilterEvent(Data::Db::TDataSet* dataset);
extern DELPHI_PACKAGE int __fastcall wwmax(int x, int y);
extern DELPHI_PACKAGE int __fastcall wwmin(int x, int y);
extern DELPHI_PACKAGE int __fastcall wwDataSetCompareBookmarks(Data::Db::TDataSet* DataSet, System::DynamicArray<System::Byte> Bookmark1, System::DynamicArray<System::Byte> Bookmark2);
extern DELPHI_PACKAGE bool __fastcall wwIsClass(System::TClass ClassType, const System::UnicodeString Name)/* overload */;
extern DELPHI_PACKAGE bool __fastcall wwIsClass(System::Classes::TComponent* component, const System::UnicodeString Name)/* overload */;
extern DELPHI_PACKAGE System::Types::TRect __fastcall wwGetWorkingRect(void);
extern DELPHI_PACKAGE bool __fastcall wwApplyPictureMask(Vcl::Stdctrls::TCustomEdit* Control, System::UnicodeString PictureMask, bool AutoFill, System::WideChar &Key);
extern DELPHI_PACKAGE bool __fastcall wwValidPictureValue(Vcl::Stdctrls::TCustomEdit* Control, System::UnicodeString PictureMask);
extern DELPHI_PACKAGE bool __fastcall wwSetControlDataSet(System::Classes::TComponent* ctrl, Data::Db::TDataSet* DataSet, System::UnicodeString PropertyName);
extern DELPHI_PACKAGE bool __fastcall wwSetControlDataSource(Vcl::Controls::TControl* ctrl, Data::Db::TDataSource* ds);
extern DELPHI_PACKAGE bool __fastcall wwSetControlDataField(Vcl::Controls::TControl* ctrl, System::UnicodeString df);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwGetControlDataField(Vcl::Controls::TControl* ctrl);
extern DELPHI_PACKAGE Data::Db::TDataSource* __fastcall wwGetControlDataSource(System::Classes::TComponent* ctrl);
extern DELPHI_PACKAGE Data::Db::TDataSource* __fastcall wwGetControlMasterSource(System::Classes::TComponent* ctrl);
extern DELPHI_PACKAGE bool __fastcall wwSetBoolean(System::Classes::TComponent* ctrl, System::UnicodeString PropertyName, bool val);
extern DELPHI_PACKAGE bool __fastcall wwSetRequestLive(Data::Db::TDataSet* ctrl, bool val);
extern DELPHI_PACKAGE bool __fastcall wwSetReadOnly(System::Classes::TComponent* ctrl, bool val);
extern DELPHI_PACKAGE bool __fastcall wwGetReadOnly(System::Classes::TComponent* ctrl);
extern DELPHI_PACKAGE bool __fastcall wwSetBorder(Vcl::Controls::TControl* ctrl, bool val);
extern DELPHI_PACKAGE bool __fastcall wwGetBorder(Vcl::Controls::TControl* ctrl);
extern DELPHI_PACKAGE bool __fastcall wwSetParamCheck(Data::Db::TDataSet* ctrl, bool val);
extern DELPHI_PACKAGE bool __fastcall wwGetWantReturns(Vcl::Controls::TControl* ctrl);
extern DELPHI_PACKAGE bool __fastcall wwGetParamCheck(Data::Db::TDataSet* ctrl);
extern DELPHI_PACKAGE bool __fastcall wwSetConnection(Data::Db::TDataSet* ctrl, System::Classes::TComponent* Connection);
extern DELPHI_PACKAGE bool __fastcall wwSetConnectionString(Data::Db::TDataSet* ctrl, System::UnicodeString df);
extern DELPHI_PACKAGE bool __fastcall wwSetDatabaseName(Data::Db::TDataSet* ctrl, System::UnicodeString df);
extern DELPHI_PACKAGE bool __fastcall wwSetIndexFieldNames(Data::Db::TDataSet* ctrl, System::UnicodeString df);
extern DELPHI_PACKAGE bool __fastcall wwSetTableName(Data::Db::TDataSet* ctrl, System::UnicodeString df);
extern DELPHI_PACKAGE bool __fastcall wwSetString(System::Classes::TComponent* ctrl, System::UnicodeString PropertyName, System::UnicodeString s);
extern DELPHI_PACKAGE bool __fastcall wwSetSessionName(Data::Db::TDataSet* ctrl, System::UnicodeString df);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwGetSessionName(Data::Db::TDataSet* dataSet);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwGetControlPictureMask(Vcl::Stdctrls::TCustomEdit* ctrl);
extern DELPHI_PACKAGE void __fastcall wwSetControlPictureMask(Vcl::Stdctrls::TCustomEdit* ctrl, System::UnicodeString PictureMask);
extern DELPHI_PACKAGE bool __fastcall wwGetControlAutoFill(Vcl::Stdctrls::TCustomEdit* ctrl);
extern DELPHI_PACKAGE void __fastcall wwSetControlAutoFill(Vcl::Stdctrls::TCustomEdit* ctrl, bool AutoFill);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwGetSQLWord(System::UnicodeString s, int &APos);
extern DELPHI_PACKAGE Data::Db::TDataSet* __fastcall wwGetDataSet(System::Classes::TComponent* DataSet);
extern DELPHI_PACKAGE Data::Db::TDataSource* __fastcall wwGetDataSource(System::Classes::TComponent* DataSet);
extern DELPHI_PACKAGE bool __fastcall wwGetIndexDefs(Data::Db::TDataSet* Dataset, Data::Db::TIndexDefs* &IndexDefs);
extern DELPHI_PACKAGE System::Variant __fastcall wwGetVariable(System::Classes::TComponent* Component, System::UnicodeString VariableName)/* overload */;
extern DELPHI_PACKAGE System::Variant __fastcall wwGetVariableWithParams(System::Classes::TComponent* Component, System::UnicodeString VariableName, const System::Variant &Params);
extern DELPHI_PACKAGE System::Variant __fastcall wwGetVariableWithParams2(System::Classes::TComponent* Component, System::UnicodeString VariableName, const System::TVarRec *StartValues, const int StartValues_High, const System::TVarRec *EndValues, const int EndValues_High);
extern DELPHI_PACKAGE System::TObject* __fastcall wwGetVariableObject(System::Classes::TComponent* Component, System::UnicodeString VariableName, const System::Variant &Param);
extern DELPHI_PACKAGE void __fastcall wwSetVariable(System::Classes::TComponent* Component, System::UnicodeString VariableName, const System::Variant &Value);
extern DELPHI_PACKAGE void __fastcall wwSetVariableObject(System::Classes::TComponent* Component, System::UnicodeString VariableName, System::TObject* Value);
extern DELPHI_PACKAGE bool __fastcall wwSetSQLProp(Data::Db::TDataSet* ctrl, System::Classes::TStrings* sql, System::UnicodeString PropName);
extern DELPHI_PACKAGE bool __fastcall wwSetParamsProp(Data::Db::TDataSet* ctrl, Data::Db::TParams* Params);
extern DELPHI_PACKAGE Data::Db::TParams* __fastcall wwGetParamsProp(Data::Db::TDataSet* ctrl);
extern DELPHI_PACKAGE bool __fastcall wwIsSingleLineEdit(HDC AHandle, const System::Types::TRect &Rect, int Flags);
extern DELPHI_PACKAGE bool __fastcall wwIsRichEditField(Data::Db::TField* Field, bool ExamineData);
extern DELPHI_PACKAGE System::UnicodeString __fastcall RichEditTextToPlainText(Vcl::Controls::TWinControl* Owner, System::UnicodeString MemoString, Vcl::Comctrls::TCustomRichEdit* &RichEditControl, System::Classes::TStringStream* &MemoryStream)/* overload */;
extern DELPHI_PACKAGE void __fastcall RichEditTextToPlainText(Vcl::Controls::TWinControl* Owner, System::WideChar * MemoBuffer, unsigned &numRead, Vcl::Comctrls::TCustomRichEdit* &RichEditControl, System::Classes::TStringStream* &MemoryStream)/* overload */;
extern DELPHI_PACKAGE void __fastcall wwDrawFocusRect(Vcl::Graphics::TCanvas* ACanvas, const System::Types::TRect &ARect);
extern DELPHI_PACKAGE bool __fastcall IsVista(void);
extern DELPHI_PACKAGE int __fastcall wwGetComCtlVersion(void);
extern DELPHI_PACKAGE bool __fastcall IsVistaComCtrlVersion(void);
extern DELPHI_PACKAGE bool __fastcall UpdatedVCL4Version(void);
extern DELPHI_PACKAGE bool __fastcall wwIsCustomEditCell(System::Classes::TComponent* Component, System::Classes::TComponent* ownerForm, Data::Db::TField* curField, Vcl::Controls::TWinControl* &customEdit);
extern DELPHI_PACKAGE bool __fastcall IsInGrid(Vcl::Controls::TWinControl* dtp);
extern DELPHI_PACKAGE bool __fastcall IsInGridPaint(Vcl::Controls::TWinControl* dtp);
extern DELPHI_PACKAGE bool __fastcall IsInwwObjectViewPaint(Vcl::Controls::TWinControl* control);
extern DELPHI_PACKAGE bool __fastcall IsInwwGridPaint(Vcl::Controls::TWinControl* control);
extern DELPHI_PACKAGE bool __fastcall IsInwwObjectView(Vcl::Controls::TWinControl* control);
extern DELPHI_PACKAGE void __fastcall wwDottedLine(Vcl::Graphics::TCanvas* Canvas, const System::Types::TPoint &p1, const System::Types::TPoint &p2);
extern DELPHI_PACKAGE void __fastcall wwSetTableIndex(Data::Db::TDataSet* DataSet, System::UnicodeString FieldName);
extern DELPHI_PACKAGE Data::Db::TIndexDef* __fastcall wwGetIndexForFields(Data::Db::TDataSet* dataset, const System::UnicodeString Fields, bool CaseInsensitive, bool ascending = true);
extern DELPHI_PACKAGE bool __fastcall wwGetThemedTextColor(System::Uitypes::TColor &ThemeTextColor);
extern DELPHI_PACKAGE void __fastcall wwDrawThemedText(Vcl::Graphics::TCanvas* ACanvas, System::UnicodeString s, const System::Types::TRect &R, unsigned Flags, Vcl::Themes::TThemedEdit Theme = (Vcl::Themes::TThemedEdit)(0x2));
extern DELPHI_PACKAGE void __fastcall wwDrawThemedTitleText(Vcl::Graphics::TCanvas* ACanvas, System::UnicodeString s, const System::Types::TRect &R, unsigned Flags);
extern DELPHI_PACKAGE void __fastcall wwWriteTextLinesT(Vcl::Graphics::TCanvas* ACanvas, const System::Types::TRect &ARect, int DX, int DY, System::WideChar * S, System::Classes::TAlignment Alignment, Vcl::Wwtypes::TwwWriteTextOptions WriteOptions);
extern DELPHI_PACKAGE int __fastcall wwRectWidth(const System::Types::TRect &Rect);
extern DELPHI_PACKAGE int __fastcall wwRectHeight(const System::Types::TRect &Rect);
extern DELPHI_PACKAGE void __fastcall wwDisableParentClipping(Vcl::Controls::TWinControl* Parent);
extern DELPHI_PACKAGE bool __fastcall wwIsDesigning(Vcl::Controls::TControl* control);
extern DELPHI_PACKAGE bool __fastcall wwHaveVisibleChild(Vcl::Controls::TWinControl* ac);
extern DELPHI_PACKAGE int __fastcall wwGetEventShift(System::Classes::TShiftState Shift);
extern DELPHI_PACKAGE int __fastcall wwlimit(int val, int x, int y);
extern DELPHI_PACKAGE void __fastcall wwClearControls(System::Classes::TComponent* Component);
extern DELPHI_PACKAGE void __fastcall wwcopyToClipBoard(const System::UnicodeString str, const System::UnicodeString htmlStr = System::UnicodeString());
extern DELPHI_PACKAGE int __fastcall wwGetOrdProp(System::Classes::TPersistent* Component, System::UnicodeString PropName);
extern DELPHI_PACKAGE bool __fastcall wwGetEditCalculated(Vcl::Controls::TControl* ctrl);
extern DELPHI_PACKAGE bool __fastcall wwUseThemes(Vcl::Controls::TControl* Control);
extern DELPHI_PACKAGE System::Classes::TList* __fastcall wwGetControlList(System::Classes::TComponent* Controller);
extern DELPHI_PACKAGE void __fastcall wwUpdateController(System::Classes::TComponent* &FController, System::Classes::TComponent* Value, System::Classes::TComponent* Control);
extern DELPHI_PACKAGE bool __fastcall RegexMatch(System::UnicodeString pattern, bool icasePattern, System::UnicodeString input);
extern DELPHI_PACKAGE bool __fastcall RegexSyntaxValid(System::UnicodeString pattern);
extern DELPHI_PACKAGE void __fastcall wwFillEditThemeBackground(bool IsDroppedDown, bool MouseInControl, const System::Types::TRect &ARect, Vcl::Graphics::TCanvas* FCanvas);
extern DELPHI_PACKAGE void __fastcall wwFillEditThemeBackgroundDefault(const System::Types::TRect &ARect, Vcl::Graphics::TCanvas* FCanvas);
extern DELPHI_PACKAGE void __fastcall wwSetToIndexContainingField(Data::Db::TDataSet* LookupTable, System::UnicodeString fieldName);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwGetIndexName(Data::Db::TDataSet* DataSet);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwGetIndexFieldName(Data::Db::TDataSet* table);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwGetIndexFieldNames(Data::Db::TDataSet* DataSet);
extern DELPHI_PACKAGE bool __fastcall wwDataSetIsCaseSensitiveIndex(Data::Db::TDataSet* Dataset);
extern DELPHI_PACKAGE bool __fastcall wwDataSetIsValidIndexField(Data::Db::TDataSet* Dataset, System::UnicodeString FieldName, bool CaseSensitive)/* overload */;
extern DELPHI_PACKAGE bool __fastcall wwDataSetIsValidIndexField(Data::Db::TDataSet* Dataset, System::UnicodeString FieldName, bool CaseSensitive, System::UnicodeString &IndexName)/* overload */;
extern DELPHI_PACKAGE bool __fastcall wwDataSetActiveIndexDef(Data::Db::TDataSet* Dataset, Data::Db::TIndexDef* &ActiveIndexDef);
extern DELPHI_PACKAGE int __fastcall wwGetIndexFieldCount(Data::Db::TDataSet* dataset);
extern DELPHI_PACKAGE int __fastcall wwGetSearchIndex(Data::Db::TDataSet* DataSet, System::UnicodeString SearchField);
extern DELPHI_PACKAGE Data::Db::TField* __fastcall wwGetIndexFields(Data::Db::TDataSet* DataSet, int Index);
extern DELPHI_PACKAGE void __fastcall wwSetIndexName(Data::Db::TDataSet* DataSet, System::UnicodeString val);
extern DELPHI_PACKAGE bool __fastcall wwDataSetIsDescendingIndex(Data::Db::TDataSet* Dataset);
extern DELPHI_PACKAGE void __fastcall wwDataSetSort(Data::Db::TDataSet* DataSet, System::UnicodeString FieldName, bool descending, bool createIndexes);
extern DELPHI_PACKAGE bool __fastcall wwIsCustomStyle(Vcl::Controls::TControl* control);
extern DELPHI_PACKAGE void __fastcall wwPaintActiveGridCellBackgroundColor(Vcl::Controls::TControl* Control, Vcl::Graphics::TCanvas* Canvas)/* overload */;
extern DELPHI_PACKAGE void __fastcall wwPaintActiveGridCellBackgroundColor(Vcl::Controls::TControl* Control, Vcl::Graphics::TCanvas* Canvas, const System::Types::TRect &PaintRect)/* overload */;
extern DELPHI_PACKAGE void __fastcall wwPaintGridCellBackgroundColor(Vcl::Controls::TControl* Control, Vcl::Graphics::TCanvas* Canvas, const System::Types::TRect &PaintRect);
extern DELPHI_PACKAGE void __fastcall wwPaintFixedGridCellBackgroundColor(Vcl::Controls::TControl* Control, Vcl::Graphics::TCanvas* Canvas, const System::Types::TRect &PaintRect);
extern DELPHI_PACKAGE System::Types::TSize __fastcall wwSize(int cx, int cy);
extern DELPHI_PACKAGE void __fastcall wwAdjustFlag(bool Condition, unsigned &Flag, unsigned FlagVal);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwStripAmpersands(System::UnicodeString Value);
extern DELPHI_PACKAGE int __fastcall wwCountTokens(System::UnicodeString s, System::UnicodeString Delimiter);
extern DELPHI_PACKAGE System::Types::TSize __fastcall wwMultiLineTextSize(Vcl::Graphics::TCanvas* Canvas, System::UnicodeString Text, int LineSpacing, int MaxWidth, int DrawFlags);
extern DELPHI_PACKAGE int __fastcall wwThisThat(const bool Clause, int TrueVal, int FalseVal);
extern DELPHI_PACKAGE int __fastcall wwLineHeight(Vcl::Graphics::TCanvas* Canvas, int Flags, int MaxWidth, System::UnicodeString Line);
extern DELPHI_PACKAGE void __fastcall wwColorToByteValues(System::Uitypes::TColor AColor, System::Byte &Reserved, System::Byte &Blue, System::Byte &Green, System::Byte &Red);
extern DELPHI_PACKAGE void __fastcall wwCalcButtonLayout(const System::Types::TPoint &TopLeft, System::Types::PRect TextRect, System::Types::PRect GlyphRect, const System::Types::TSize &TextSize, const System::Types::TSize &GlyphSize, Vcl::Buttons::TButtonLayout Layout, int Spacing);
extern DELPHI_PACKAGE void __fastcall wwCreateDisabledBitmap(Vcl::Graphics::TBitmap* SrcBm, Vcl::Graphics::TBitmap* DstBm);
extern DELPHI_PACKAGE void __fastcall wwImageListDraw(Vcl::Imglist::TCustomImageList* ImageList, int Index, Vcl::Graphics::TCanvas* Canvas, int X, int Y, unsigned Style, bool Enabled);
extern DELPHI_PACKAGE void __fastcall wwImageListDrawFixBug(Vcl::Imglist::TCustomImageList* ImageList, int Index, Vcl::Graphics::TCanvas* Canvas, int X, int Y, unsigned Style, bool Enabled);
extern DELPHI_PACKAGE System::Uitypes::TColor __fastcall wwModifyColor(System::Uitypes::TColor Color, int Amount, bool Percent);
extern DELPHI_PACKAGE System::Types::TPoint __fastcall wwGetCursorPos(void);
extern DELPHI_PACKAGE HBRUSH __fastcall wwGetDitherBrush(void);
extern DELPHI_PACKAGE void __fastcall wwParentInvalidate(Vcl::Controls::TControl* Control, bool Erase);
extern DELPHI_PACKAGE void __fastcall wwInvalidateChildren(HWND Control);
extern DELPHI_PACKAGE void __fastcall wwInvalidateOverlappedWindows(HWND ParentHwnd, HWND FirstChild);
extern DELPHI_PACKAGE HRGN __fastcall wwRegionFromBitmap(Vcl::Wwbitmap::TwwBitmap* ABitmap, System::Uitypes::TColor TransColor);
extern DELPHI_PACKAGE bool __fastcall wwIsClientCursor(Data::Db::TDataSet* DataSet);
extern DELPHI_PACKAGE bool __fastcall wwGridEssentials(void);
extern DELPHI_PACKAGE bool __fastcall wwIsDelphiApp(void);
extern DELPHI_PACKAGE void __fastcall DisplayProfessionalMessage(System::Classes::TComponent* Component, System::UnicodeString msg);
extern DELPHI_PACKAGE void __fastcall DisplayProfessionalVersionOnlyMessage(System::Classes::TComponent* Component, System::UnicodeString msg);
extern DELPHI_PACKAGE bool __fastcall TrialExpired(void);
extern DELPHI_PACKAGE bool __fastcall wwAllowChangeParent(Vcl::Controls::TControl* Control, Vcl::Controls::TControl* NewParent);
extern DELPHI_PACKAGE void __fastcall ShowEmbarcaderoGridParentMessage(void);
extern DELPHI_PACKAGE Vcl::Controls::TControl* __fastcall wwParentGrid(Vcl::Controls::TControl* Control);
}	/* namespace Wwcommon */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWCOMMON)
using namespace Vcl::Wwcommon;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwcommonHPP
