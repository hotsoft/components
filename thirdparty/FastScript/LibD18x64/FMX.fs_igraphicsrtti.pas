
{******************************************}
{                                          }
{             FastScript v1.9              }
{    Graphics.pas classes and functions    }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit FMX.fs_igraphicsrtti;

interface

{$i fs.inc}

uses
  System.SysUtils, System.Classes, FMX.fs_iinterpreter, FMX.fs_iclassesrtti
, FMX.Types, FMX.Objects, System.UITypes, System.UIConsts, System.Types, System.Variants
{$IFDEF DELPHI19}
  , FMX.Graphics
{$ENDIF}
{$IFDEF DELPHI20}
  , System.Math.Vectors
{$ENDIF};

type
{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}

  TfsGraphicsRTTI = class(TComponent); // fake component


implementation

type

  TFunctions = class(TfsRTTIModule)
  private
    function CallMethod(Instance: TObject; ClassType: TClass;
      const MethodName: String; Caller: TfsMethodHelper): Variant;
    function GetProp(Instance: TObject; ClassType: TClass;
      const PropName: String): Variant;
    procedure SetProp(Instance: TObject; ClassType: TClass;
      const PropName: String; Value: Variant);
    procedure GetColorProc(const Name: String);
  public
    constructor Create(AScript: TfsScript); override;
  end;


{ TFunctions }

constructor TFunctions.Create(AScript: TfsScript);
begin
  inherited Create(AScript);
  with AScript do
  begin
    GetAlphaColorValues(GetColorProc);
    AddType('TAlignment', fvtInt);
    AddType('TLeftRight', fvtInt);
    AddConst('taLeftJustify', 'Integer', taLeftJustify);
    AddConst('taRightJustify', 'Integer', taRightJustify);
    AddConst('taCenter', 'Integer', taCenter);
    AddType('TVerticalAlignment', fvtInt);
    AddConst('taAlignTop', 'Integer', taAlignTop);
    AddConst('taAlignBottom', 'Integer', taAlignBottom);
    AddConst('taVerticalCenter', 'Integer', taVerticalCenter);
    //AddEnum('TAlignment', 'taLeftJustify, taRightJustify, taCenter');
    AddType('TCorners ', fvtInt);
    AddConst('crTopLeft', 'Integer', TCorner.crTopLeft);
    AddConst('crTopRight', 'Integer', TCorner.crTopRight);
    AddConst('crBottomLeft', 'Integer', TCorner.crBottomLeft);
    AddConst('crBottomRight', 'Integer', TCorner.crBottomRight);
    AddType('TCorners ', fvtInt);
    AddConst('crTopLeft', 'Integer', TCorner.crTopLeft);
    AddConst('crTopRight', 'Integer', TCorner.crTopRight);
    AddConst('crBottomLeft', 'Integer', TCorner.crBottomLeft);
    AddConst('crBottomRight', 'Integer', TCorner.crBottomRight);
    AddType('TSides ', fvtInt);
    AddConst('sdTop', 'Integer', TSide.sdTop);
    AddConst('sdLeft', 'Integer', TSide.sdLeft);
    AddConst('sdBottom', 'Integer', TSide.sdBottom);
    AddConst('sdRight', 'Integer', TSide.sdRight);
    AddType('TFillTextFlags ', fvtInt);
    AddConst('ftRightToLeft', 'Integer', TFillTextFlag.ftRightToLeft);



    AddEnumSet('TFontStyles', 'fsBold, fsItalic, fsUnderline, fsStrikeout');
    AddEnum('TFontPitch', 'fpDefault, fpVariable, fpFixed');
    AddEnum('TFontQuality', 'fqDefault, fqDraft, fqProof, fqNonAntialiased, fqAntialiased, fqClearType, fqClearTypeNatural');
    AddEnum('TGradientStyle', 'gsLinear, gsRadial');
    AddEnum('TWrapMode', 'wmTile, wmTileOriginal, wmTileStretch');
    AddEnum('TCornerType', 'ctRound, ctBevel, ctInnerRound, ctInnerLine');
    AddEnum('TAlignLayout', 'alNone, alTop, alLeft, alRight, alBottom, alMostTop, alMostBottom, alMostLeft, alMostRight, alClient, alContents, alCenter, alVertCenter, alHorzCenter, alHorizontal, alVertical, alScale, alFit, alFitLeft, alFitRight');
    AddEnum('TPathPointKind', 'ppMoveTo, ppLineTo, ppCurveTo, ppClose');
    AddEnum('TStrokeCap', 'scFlat, scRound');
    AddEnum('TStrokeJoin', 'sjMiter, sjRound, sjBevel');
    AddEnum('TStrokeDash', 'sdSolid, sdDash, sdDot, sdDashDot, sdDashDotDot, sdCustom');

    AddEnum('TBrushKind', 'bkNone, bkSolid, bkGradient, bkBitmap, bkResource, bkGrab');

    AddClass(TfsMatrix, 'TPersistent');
    with AddClass(TFont, 'TPersistent') do
      AddConstructor('constructor Create', CallMethod);
    AddClass(TGradientPoint, 'TCollectionItem');
    AddClass(TGradientPoints, 'TCollection');
    AddClass(TGradient, 'TPersistent');
    AddClass(TBrushBitmap, 'TPersistent');
    AddClass(TBrushResource, 'TPersistent');
{$IFNDEF Delphi18}
    AddClass(TBrushGrab, 'TPersistent');
{$ENDIF}
    AddClass(TLineMetricInfo, 'TObject');

    with AddClass(TBrush, 'TPersistent') do
    begin
      AddConstructor('Create(ADefaultKind: TBrushKind; ADefaultColor: TAlphaColor)', CallMethod);
      AddProperty('DefaultColor', 'TAlphaColor', GetProp);
      AddProperty('DefaultKind', 'TBrushKind', GetProp);
    end;
{$IFDEF Delphi17}
    AddClass(TStrokeBrush, 'TBrush');
{$ENDIF}

    AddClass(TCanvasSaveState, 'TPersistent');
    with AddClass(TCanvas, 'TPersistent') do
    begin
      AddMethod('function BeginScene: Boolean', CallMethod);
      AddMethod('procedure EndScene', CallMethod);
      AddMethod('procedure Clear(Color: TAlphaColor)', CallMethod);
      AddMethod('procedure ClearRect(ARect: TfsRectF; AColor: TAlphaColor = 0)', CallMethod);
      AddMethod('procedure SetMatrix(const M: TfsMatrix)', CallMethod);
{$IFDEF Delphi17}
      AddMethod('procedure MultiplyMatrix(const M: TfsMatrix)', CallMethod);
{$ELSE}
      AddMethod('procedure MultyMatrix(const M: TfsMatrix)', CallMethod);
{$ENDIF}
      AddMethod('function SaveState: TCanvasSaveState', CallMethod);
      AddMethod('procedure RestoreState(State: TCanvasSaveState)', CallMethod);
      AddMethod('procedure SetClipRects(ARects: array of TfsRectF)', CallMethod);
      AddMethod('procedure IntersectClipRect(ARect: TfsRectF)', CallMethod);
      AddMethod('procedure ExcludeClipRect(ARect: TfsRectF)', CallMethod);
      AddMethod('procedure ResetClipRect', CallMethod);
      AddMethod('procedure DrawLine(APt1: TfsPointF; APt2: TfsPointF; AOpacity: Single)', CallMethod);
      AddMethod('procedure FillRect(ARect: TfsRectF; XRadius: Single; YRadius: Single; ACorners: TCorners; AOpacity: Single; ACornerType: TCornerType)', CallMethod);
      AddMethod('procedure DrawRect(ARect: TfsRectF; XRadius: Single; YRadius: Single; ACorners: TCorners; AOpacity: Single; ACornerType: TCornerType)', CallMethod);
      AddMethod('procedure FillEllipse(ARect: TfsRectF; AOpacity: Single)', CallMethod);
      AddMethod('procedure DrawEllipse(ARect: TfsRectF; AOpacity: Single)', CallMethod);
      AddMethod('procedure FillArc(Center: TfsPointF; Radius: TfsPointF; StartAngle: Single; SweepAngle: Single; AOpacity: Single)', CallMethod);
      AddMethod('procedure DrawArc(Center: TfsPointF; Radius: TfsPointF; StartAngle: Single; SweepAngle: Single; AOpacity: Single)', CallMethod);
      AddMethod('function PtInPath(APoint: TfsPointF; APath: TPathData): Boolean', CallMethod);
      AddMethod('procedure FillPath(APath: TPathData; AOpacity: Single)', CallMethod);
      AddMethod('procedure DrawPath(APath: TPathData; AOpacity: Single)', CallMethod);
      AddMethod('procedure DrawBitmap(ABitmap: TBitmap; SrcRect: TfsRectF; DstRect: TfsRectF; AOpacity: Single; HighSpeed: Boolean)', CallMethod);
      AddMethod('procedure DrawRectSides(ARect: TfsRectF; XRadius: Single; YRadius: Single; ACorners: TCorners; AOpacity: Single; ASides: TSides; ACornerType: TCornerType)', CallMethod);
      AddMethod('procedure FillPolygon(Points: TPolygon; AOpacity: Single)', CallMethod);
      AddMethod('procedure DrawPolygon(Points: TPolygon; AOpacity: Single)', CallMethod);
      AddMethod('function LoadFontFromStream(AStream: TStream): Boolean', CallMethod);
      AddMethod('procedure FillText(ARect: TfsRectF; AText: string; WordWrap: Boolean; AOpacity: Single; Flags: TFillTextFlags; ATextAlign: TTextAlign; AVTextAlign: TTextAlign)', CallMethod);
      AddMethod('procedure MeasureText(var ARect: TfsRectF; AText: string; WordWrap: Boolean; Flags: TFillTextFlags; ATextAlign: TTextAlign; AVTextAlign: TTextAlign)', CallMethod);
      AddMethod('procedure MeasureLines(ALines: TLineMetricInfo; ARect: TfsRectF; AText: string; WordWrap: Boolean; Flags: TFillTextFlags; ATextAlign: TTextAlign; AVTextAlign: TTextAlign)', CallMethod);
      AddMethod('function TextToPath(Path: TPathData; ARect: TfsRectF; AText: string; WordWrap: Boolean; ATextAlign: TTextAlign; AVTextAlign: TTextAlign): Boolean', CallMethod);
      AddMethod('function TextWidth(AText: string): Single', CallMethod);
      AddMethod('function TextHeight(AText: string): Single', CallMethod);
      AddMethod('procedure SetCustomDash(Dash: array; Offset: Single)', CallMethod);
{$IFDEF Delphi17}
      AddProperty('Stroke', 'TStrokeBrush', GetProp);
      AddProperty('StrokeCap', 'TStrokeCap', nil, SetProp);
      AddProperty('StrokeDash', 'TStrokeDash', nil, SetProp);
      AddProperty('StrokeJoin', 'TStrokeJoin', nil, SetProp);
{$ELSE}
      AddProperty('Stroke', 'TBrush', GetProp);
      AddProperty('StrokeCap', 'TStrokeCap', GetProp, SetProp);
      AddProperty('StrokeDash', 'TStrokeDash', GetProp, SetProp);
      AddProperty('StrokeJoin', 'TStrokeJoin', GetProp, SetProp);
{$ENDIF}
      AddProperty('StrokeThickness', 'Single', GetProp, SetProp);
      AddProperty('Fill', 'TBrush', GetProp, SetProp);
      AddProperty('Font', 'TFont', GetProp);
      AddProperty('Matrix', 'TfsMatrix', GetProp);
      AddProperty('Width', 'Integer', GetProp);
      AddProperty('Height', 'Integer', GetProp);
    end;
    with AddClass(TBitmap, 'TPersistent') do
    begin
      AddConstructor('constructor Create(AWidth, AHeight: Integer)', CallMethod);
      AddConstructor('constructor CreateFromStream(AStream: TStream)', CallMethod);
      AddConstructor('constructor CreateFromFile(AFileName: string)', CallMethod);
      AddMethod('procedure SetSize(AWidth, AHeight: Integer)', CallMethod);
      AddMethod('procedure Clear(AColor: TAlphaColor)', CallMethod);
      AddMethod('procedure ClearRect(ARect: TfsRectF; AColor: TAlphaColor = 0)', CallMethod);
      AddMethod('function IsEmpty: Boolean', CallMethod);
      AddMethod('procedure Rotate(Angle: Single)', CallMethod);
      AddMethod('procedure FlipHorizontal', CallMethod);
      AddMethod('procedure FlipVertical', CallMethod);
      AddMethod('procedure InvertAlpha', CallMethod);
{$IFNDEF DELPHI20}
      AddMethod('procedure LoadFromFile(AFileName: string; Rotate: Single = 0)', CallMethod);
{$ELSE}
      AddMethod('procedure LoadFromFile(AFileName: string)', CallMethod);
{$ENDIF}
      AddMethod('procedure SaveToFile(AFileName: string)', CallMethod);
      AddMethod('procedure LoadFromStream(Stream: TStream)', CallMethod);
      AddMethod('procedure SaveToStream(Stream: TStream)', CallMethod);
{$IFNDEF Delphi17}
      AddMethod('procedure BitmapChanged', CallMethod);
      AddIndexProperty( 'Pixels', 'Integer, Integer', 'TAlphaColor', CallMethod);
{$ENDIF}
      AddProperty('Canvas', 'TCanvas', GetProp);
{$IFNDEF Delphi21}
      AddProperty('ResourceBitmap', 'TBitmap', GetProp);
{$ENDIF}
      AddProperty('Width', 'Integer', GetProp, SetProp);
      AddProperty('Height', 'Integer', GetProp, SetProp);
    end;
    AddClass(TSpline, 'TObject');
    AddClass(TBounds, 'TPersistent');
    AddClass(TTransform, 'TPersistent');



{$IFNDEF Delphi17}
    AddClass(TBitmapCodec, 'TPersistent');
{$ENDIF}
    AddClass(TPathData, 'TPersistent');
    AddClass(TCanvasSaveState, 'TPersistent');
  end;
end;

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;
var
  _Canvas: TCanvas;
  _Bitmap: TBitmap;
//  mRects: array of TRectF;
  mDashs: array of Single;
  mPoly: TPolygon;
  Idx, Cnt, nLo: Integer;
begin
  Result := 0;

  if ClassType = TFont then
  begin
    if MethodName = 'CREATE' then
      Result := frxInteger(TFont(Instance).Create);
  end
  else if ClassType = TBitmap then
  begin
    _Bitmap := TBitmap(Instance);
    if MethodName = 'CREATE' then
      Result := frxInteger(TBitmap(Instance).Create(Caller.Params[0], Caller.Params[1]))
    else if MethodName = 'CREATEFROMSTREAM' then
      Result := frxInteger(_Bitmap.CreateFromStream(TStream(frxInteger(Caller.Params[0]))))
    else if MethodName = 'CREATEFROMFILE' then
      Result := frxInteger(_Bitmap.CreateFromFile(String(Caller.Params[0])))
    else if MethodName = 'SETSIZE' then
      _Bitmap.SetSize(Integer(Caller.Params[0]), Integer(Caller.Params[1]))
    else if MethodName = 'CLEAR' then
      _Bitmap.Clear(TAlphaColor(Caller.Params[0]))
    else if MethodName = 'CLEARRECT' then
    begin
      _Bitmap.ClearRect(TfsRectF(frxInteger(Caller.Params[0])).GetRect, TAlphaColor(Caller.Params[1]));
    end
    else if MethodName = 'ISEMPTY' then
      Result := _Bitmap.IsEmpty
    else if MethodName = 'ROTATE' then
      _Bitmap.Rotate(Single(Caller.Params[1]))
    else if MethodName = 'FLIPHORIZONTAL' then
      _Bitmap.FlipHorizontal
    else if MethodName = 'FLIPVERTICAL' then
      _Bitmap.FlipVertical
    else if MethodName = 'INVERTALPHA' then
      _Bitmap.InvertAlpha
    else if MethodName = 'LOADFROMFILE' then
{$IFNDEF DELPHI20}
      _Bitmap.LoadFromFile(String(Caller.Params[0]), Single(Caller.Params[1]))
{$ELSE}
      _Bitmap.LoadFromFile(String(Caller.Params[0]))
{$ENDIF}
    else if MethodName = 'SAVETOFILE' then
      _Bitmap.SaveToFile(String(Caller.Params[0]))
    else if MethodName = 'LOADFROMSTREAM' then
      _Bitmap.LoadFromStream(TStream(frxInteger(Caller.Params[0])))
    else if MethodName = 'SAVETOSTREAM' then
      _Bitmap.SaveToStream(TStream(frxInteger(Caller.Params[0])))
{$IFNDEF Delphi17}
    else if MethodName = 'BITMAPCHANGED' then
      _Bitmap.BitmapChanged
    else if MethodName = 'PIXELS.GET' then
      Result := _Bitmap.Pixels[Caller.Params[0], Caller.Params[1]]
    else if MethodName = 'PIXELS.SET' then
      _Bitmap.Pixels[Caller.Params[0], Caller.Params[1]] := Caller.Params[2]
{$ENDIF}
  end
  else if ClassType = TBrush then
  begin
    if MethodName = 'CREATE' then
      Result := frxInteger(TBrush(Instance).Create(TBrushKind(frxInteger(Caller.Params[0])),
                            TAlphaColor(frxInteger(Caller.Params[0]))))
  end
  else if ClassType = TCanvas then
  begin
    _Canvas := TCanvas(Instance);

    if MethodName = 'BEGINSCENE' then
      Result := _Canvas.BeginScene
    else if MethodName = 'ENDSCENE' then
      _Canvas.EndScene
    else if MethodName = 'CLEAR' then
      _Canvas.Clear(TAlphaColor(Caller.Params[0]))
    else if MethodName = 'CLEARRECT' then
      _Canvas.ClearRect(TfsRectF(frxInteger(Caller.Params[0])).GetRect, TAlphaColor(Caller.Params[1]))
    else if MethodName = 'SETMATRIX' then
      _Canvas.SetMatrix(TfsMatrix(frxInteger(Caller.Params[0])).GetRect)
{$IFDEF Delphi17}
    else if MethodName = 'MULTIPLYMATRIX' then
      _Canvas.MultiplyMatrix(TfsMatrix(frxInteger(Caller.Params[0])).GetRect)
{$ELSE}
    else if MethodName = 'MULTYMATRIX' then
      _Canvas.MultyMatrix(TfsMatrix(frxInteger(Caller.Params[0])).GetRect)
{$ENDIF}
    else if MethodName = 'SAVESTATE' then
      Result := frxInteger(_Canvas.SaveState)
    else if MethodName = 'RESTORESTATE' then
      _Canvas.RestoreState(TCanvasSaveState(frxInteger(Caller.Params[0])))
   { else if MethodName = 'SETCLIPRECTS' then
    begin
       nLo := VarArrayLowBound(Caller.Params[0], 1);
       Cnt := VarArrayHighBound(Caller.Params[0], 1) - nLo;
       SetLength(mRects, Cnt);
       for Idx := 0 to Cnt - 1 do
          mRects[Idx] := TfsRectF(frxInteger(Caller.Params[0][Idx + nLo])).GetRectP^;
      _Canvas.SetClipRects(mRects);
      SetLength(mRects, 0);
    end   }
    else if MethodName = 'EXCLUDECLIPRECT' then
      _Canvas.ExcludeClipRect(TfsRectF(frxInteger(Caller.Params[0])).GetRect)
    else if MethodName = 'INTERSECTCLIPTRECT' then
      _Canvas.IntersectClipRect(TfsRectF(frxInteger(Caller.Params[0])).GetRect)
    {else if MethodName = 'RESETCLIPRECT' then
      _Canvas.ResetClipRect    }
    else if MethodName = 'DRAWLINE' then
      _Canvas.DrawLine(TfsPointF(frxInteger(Caller.Params[0])).GetRect, TfsPointF(frxInteger(Caller.Params[1])).GetRect, Single(Caller.Params[2]))
    else if MethodName = 'FILLRECT' then
      _Canvas.FillRect(TfsRectF(frxInteger(Caller.Params[0])).GetRect, Single(Caller.Params[1]), Single(Caller.Params[2]), TCorners(Byte(Caller.Params[3])), Single(Caller.Params[4]), TCornerType(Caller.Params[5]))
    else if MethodName = 'DRAWRECT' then
      _Canvas.DrawRect(TfsRectF(frxInteger(Caller.Params[0])).GetRect, Single(Caller.Params[1]), Single(Caller.Params[2]), TCorners(Byte(Caller.Params[3])), Single(Caller.Params[4]), TCornerType(Caller.Params[5]))
    else if MethodName = 'FILLELLIPSE' then
      _Canvas.FillEllipse(TfsRectF(frxInteger(Caller.Params[0])).GetRect, Single(Caller.Params[1]))
    else if MethodName = 'DRAWELLIPSE' then
      _Canvas.DrawEllipse(TfsRectF(frxInteger(Caller.Params[0])).GetRect, Single(Caller.Params[1]))
    else if MethodName = 'FILLARC' then
      _Canvas.FillArc(TfsPointF(frxInteger(Caller.Params[0])).GetRect, TfsPointF(frxInteger(Caller.Params[1])).GetRect, Single(Caller.Params[2]), Single(Caller.Params[3]), Single(Caller.Params[4]))
    else if MethodName = 'DRAWARC' then
      _Canvas.DrawArc(TfsPointF(frxInteger(Caller.Params[0])).GetRect, TfsPointF(frxInteger(Caller.Params[1])).GetRect, Single(Caller.Params[2]), Single(Caller.Params[3]), Single(Caller.Params[4]))
    else if MethodName = 'PTINPATH' then
      Result := Boolean(_Canvas.PtInPath(TfsPointF(frxInteger(Caller.Params[0])).GetRect, TPathData(frxInteger(Caller.Params[1]))))
    else if MethodName = 'FILLPATH' then
      _Canvas.FillPath(TPathData(frxInteger(Caller.Params[0])), Single(Caller.Params[1]))
    else if MethodName = 'DRAWPATH' then
      _Canvas.DrawPath(TPathData(frxInteger(Caller.Params[0])), Single(Caller.Params[1]))
    else if MethodName = 'DRAWBITMAP' then
      _Canvas.DrawBitmap(TBitmap(frxInteger(Caller.Params[0])), TfsRectF(frxInteger(Caller.Params[1])).GetRect, TfsRectF(frxInteger(Caller.Params[2])).GetRect, Single(Caller.Params[3]), Boolean(Caller.Params[4]))
    else if MethodName = 'DRAWRECTSIDES' then
      _Canvas.DrawRectSides(TfsRectF(frxInteger(Caller.Params[0])).GetRect, Single(Caller.Params[1]), Single(Caller.Params[2]), TCorners(Byte(Caller.Params[3])), Single(Caller.Params[4]), TSides(Byte(Caller.Params[5])), TCornerType(Caller.Params[6]))
    else if MethodName = 'FILLPOLYGON' then
    begin
       nLo := VarArrayLowBound(Caller.Params[0], 1);
       Cnt := VarArrayHighBound(Caller.Params[0], 1) - nLo;
       SetLength(mPoly, Cnt);
       for Idx := 0 to Cnt - 1 do
          mPoly[Idx] := TfsPointF(frxInteger(Caller.Params[0][Idx + nLo])).GetRectP^;
       _Canvas.FillPolygon(TPolygon(Caller.Params[0]), Single(Caller.Params[1]));
      SetLength(mPoly, 0);
    end
    else if MethodName = 'DRAWPOLYGON' then
    begin
       nLo := VarArrayLowBound(Caller.Params[0], 1);
       Cnt := VarArrayHighBound(Caller.Params[0], 1) - nLo;
       SetLength(mPoly, Cnt);
       for Idx := 0 to Cnt - 1 do
          mPoly[Idx] := TfsPointF(frxInteger(Caller.Params[0][Idx + nLo])).GetRectP^;
      _Canvas.DrawPolygon(TPolygon(Caller.Params[0]), Single(Caller.Params[1]));
      SetLength(mPoly, 0);
    end
    else if MethodName = 'LOADFONTFROMSTREAM' then
      Result := Boolean(_Canvas.LoadFontFromStream(TStream(frxInteger(Caller.Params[0]))))
    else if MethodName = 'FILLTEXT' then
      _Canvas.FillText(TfsRectF(frxInteger(Caller.Params[0])).GetRect, String(Caller.Params[1]), Boolean(Caller.Params[2]), Single(Caller.Params[3]), TFillTextFlags(Byte(Caller.Params[4])), TTextAlign(Caller.Params[5]), TTextAlign(Caller.Params[6]))
    else if MethodName = 'MEASURETEXT' then
      _Canvas.MeasureText(TfsRectF(frxInteger(Caller.Params[0])).GetRectP^, String(Caller.Params[1]), Boolean(Caller.Params[2]), TFillTextFlags(Byte(Caller.Params[3])), TTextAlign(Caller.Params[4]), TTextAlign(Caller.Params[5]))
    else if MethodName = 'MEASURELINES' then
      _Canvas.MeasureLines(TLineMetricInfo(frxInteger(Caller.Params[0])), TfsRectF(frxInteger(Caller.Params[1])).GetRect, String(Caller.Params[2]), Boolean(Caller.Params[3]), TFillTextFlags(Byte(Caller.Params[4])), TTextAlign(Caller.Params[5]), TTextAlign(Caller.Params[6]))
    else if MethodName = 'TEXTTOPATH' then
      Result := Boolean(_Canvas.TextToPath(TPathData(frxInteger(Caller.Params[0])), TfsRectF(frxInteger(Caller.Params[1])).GetRect, String(Caller.Params[2]), Boolean(Caller.Params[3]), TTextAlign(Caller.Params[4]), TTextAlign(Caller.Params[5])))
    else if MethodName = 'TEXTWIDTH' then
      Result := Single(_Canvas.TextWidth(String(Caller.Params[0])))
    else if MethodName = 'TEXTHEIGHT' then
      Result := Single(_Canvas.TextHeight(String(Caller.Params[0])))
    else if MethodName = 'SETCUSTOMDASH' then
    begin
       nLo := VarArrayLowBound(Caller.Params[0], 1);
       Cnt := VarArrayHighBound(Caller.Params[0], 1) - nLo;
       SetLength(mDashs, Cnt);
       for Idx := 0 to Cnt - 1 do
          mDashs[Idx] := Single(Caller.Params[0][Idx + nLo]);
       _Canvas.SetCustomDash(mDashs, Single(Caller.Params[1]));
      SetLength(mDashs, 0);
    end
{$IFNDEF CLX}
  {  else if MethodName = 'PIXELS.GET' then
      Result := _Canvas.Pixels[Caller.Params[0], Caller.Params[1]]
    else if MethodName = 'PIXELS.SET' then
      _Canvas.Pixels[Caller.Params[0], Caller.Params[1]] := Caller.Params[2] }
{$ENDIF}
  end
end;

function TFunctions.GetProp(Instance: TObject; ClassType: TClass;
  const PropName: String): Variant;
begin
  Result := 0;
  if ClassType = TBitmap then
  begin
    if PropName = 'CANVAS' then
      Result := frxInteger(TBitmap(Instance).Canvas)
{$IFNDEF Delphi21}
    else if PropName = 'RESOURCEBITMAP' then
      Result := frxInteger(TBitmap(Instance).ResourceBitmap)
{$ENDIF}
    else if PropName = 'WIDTH' then
      Result := Integer(TBitmap(Instance).Width)
    else if PropName = 'HEIGHT' then
      Result := Integer(TBitmap(Instance).Height)
  end
  else if ClassType = TCanvas then
  begin
    if PropName = 'STROKE' then
      Result := frxInteger(TCanvas(Instance).Stroke)
    else if PropName = 'WIDTH' then
      Result := Integer(TCanvas(Instance).Width)
    else if PropName = 'HEIGHT' then
      Result := Integer(TCanvas(Instance).Height)
    else if PropName = 'FONT' then
      Result := frxInteger(TCanvas(Instance).Font)
    else if PropName = 'FILL' then
      Result := frxInteger(TCanvas(Instance).Fill)
    else if PropName = 'STROKETHICKNESS' then
      Result := Single(TCanvas(Instance).StrokeThickness)
{$IFNDEF Delphi17}
    else if PropName = 'STROKECAP' then
      Result := Integer(TCanvas(Instance).StrokeCap)
    else if PropName = 'STROKEDASH' then
      Result := Integer(TCanvas(Instance).StrokeDash)
    else if PropName = 'STROKEJOIN' then
      Result := Integer(TCanvas(Instance).StrokeJoin)
{$ENDIF}
  end;
end;

procedure TFunctions.SetProp(Instance: TObject; ClassType: TClass;
  const PropName: String; Value: Variant);
begin
  if ClassType = TBitmap then
  begin
    if PropName = 'WIDTH' then
      TBitmap(Instance).Width := Integer(Value)
    else if PropName = 'HEIGHT' then
      TBitmap(Instance).Height:= Integer(Value)
  end
  else if ClassType = TCanvas then
  begin
    if PropName = 'STROKETHICKNESS' then
      TCanvas(Instance).StrokeThickness := Single(Value)
    else if PropName = 'STROKECAP' then
      TCanvas(Instance).StrokeCap := TStrokeCap(Value)
    else if PropName = 'STROKEDASH' then
      TCanvas(Instance).StrokeDash := TStrokeDash(Value)
    else if PropName = 'STROKEJOIN' then
      TCanvas(Instance).StrokeJoin := TStrokeJoin(Value)
  end;
end;

procedure TFunctions.GetColorProc(const Name: String);
var
  c: Integer;
begin
  IdentToAlphaColor('cla' + Name, c);
  Script.AddConst('cla' + Name, 'Integer', c);
end;

initialization
  StartClassGroup(TFmxObject);
  ActivateClassGroup(TFmxObject);
  GroupDescendentsWith(TfsGraphicsRTTI, TFmxObject);
  fsRTTIModules.Add(TFunctions);


finalization
  fsRTTIModules.Remove(TFunctions);

end.
