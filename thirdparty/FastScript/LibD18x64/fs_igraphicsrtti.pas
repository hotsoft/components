
{******************************************}
{                                          }
{             FastScript v1.9              }
{    Graphics.pas classes and functions    }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_igraphicsrtti;

interface

{$i fs.inc}

uses
  SysUtils, Classes, fs_iinterpreter, fs_iclassesrtti
{$IFDEF CLX}
, QGraphics
{$ELSE}
, Graphics
{$ENDIF};

type
  TfsGraphicsRTTI = class(TComponent); // fake component


implementation

type
  THackGraphic = class(TGraphic)
  end;

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
    GetColorValues(GetColorProc);
    AddEnumSet('TFontStyles', 'fsBold, fsItalic, fsUnderline, fsStrikeout');
    AddEnum('TFontPitch', 'fpDefault, fpVariable, fpFixed');
    AddEnum('TPenStyle', 'psSolid, psDash, psDot, psDashDot, psDashDotDot, psClear, psInsideFrame');
    AddEnum('TPenMode', 'pmBlack, pmWhite, pmNop, pmNot, pmCopy, pmNotCopy, pmMergePenNot, ' +
      'pmMaskPenNot, pmMergeNotPen, pmMaskNotPen, pmMerge, pmNotMerge, pmMask, pmNotMask, pmXor, pmNotXor');
    AddEnum('TBrushStyle', 'bsSolid, bsClear, bsHorizontal, bsVertical, ' +
      'bsFDiagonal, bsBDiagonal, bsCross, bsDiagCross');

    with AddClass(TFont, 'TPersistent') do
      AddConstructor('constructor Create', CallMethod);
    with AddClass(TPen, 'TPersistent') do
      AddConstructor('constructor Create', CallMethod);
    with AddClass(TBrush, 'TPersistent') do
      AddConstructor('constructor Create', CallMethod);
    with AddClass(TCanvas, 'TPersistent') do
    begin
      AddConstructor('constructor Create', CallMethod);
      AddMethod('procedure Draw(X, Y: Integer; Graphic: TGraphic)', CallMethod);
      AddMethod('procedure Ellipse(X1, Y1, X2, Y2: Integer)', CallMethod);
      AddMethod('procedure LineTo(X, Y: Integer)', CallMethod);
      AddMethod('procedure MoveTo(X, Y: Integer)', CallMethod);
      AddMethod('procedure Rectangle(X1, Y1, X2, Y2: Integer)', CallMethod);
      AddMethod('procedure RoundRect(X1, Y1, X2, Y2, X3, Y3: Integer)', CallMethod);
      AddMethod('procedure StretchDraw(X1, Y1, X2, Y2: Integer; Graphic: TGraphic)', CallMethod);
      AddMethod('function TextHeight(const Text: string): Integer', CallMethod);
      AddMethod('procedure TextOut(X, Y: Integer; const Text: string)', CallMethod);
      AddMethod('function TextWidth(const Text: string): Integer', CallMethod);
{$IFNDEF CLX}
      AddIndexProperty('Pixels', 'Integer, Integer', 'TColor', CallMethod);
{$ENDIF}
    end;
    with AddClass(TGraphic, 'TPersistent') do
    begin
      AddConstructor('constructor Create', CallMethod);
      AddMethod('procedure LoadFromFile(const Filename: string)', CallMethod);
      AddMethod('procedure SaveToFile(const Filename: string)', CallMethod);
      AddProperty('Height', 'Integer', GetProp, SetProp);
      AddProperty('Width', 'Integer', GetProp, SetProp);
    end;
    with AddClass(TPicture, 'TPersistent') do
    begin
      AddMethod('procedure LoadFromFile(const Filename: string)', CallMethod);
      AddMethod('procedure SaveToFile(const Filename: string)', CallMethod);
      AddProperty('Height', 'Integer', GetProp, nil);
      AddProperty('Width', 'Integer', GetProp, nil);
    end;
{$IFNDEF CROSS_COMPILE}
    AddClass(TMetafile, 'TGraphic');
    with AddClass(TMetafileCanvas, 'TCanvas') do
      AddConstructor('constructor Create(AMetafile: TMetafile; ReferenceDevice: Integer)', CallMethod);
{$ENDIF}
    with AddClass(TBitmap, 'TGraphic') do
      AddProperty('Canvas', 'TCanvas', GetProp);
  end;
end;

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;
var
  _Canvas: TCanvas;
begin
  Result := 0;

  if ClassType = TFont then
  begin
    if MethodName = 'CREATE' then
      Result := Integer(TFont(Instance).Create)
  end
  else if ClassType = TPen then
  begin
    if MethodName = 'CREATE' then
      Result := Integer(TPen(Instance).Create)
  end
  else if ClassType = TBrush then
  begin
    if MethodName = 'CREATE' then
      Result := Integer(TBrush(Instance).Create)
  end
  else if ClassType = TCanvas then
  begin
    _Canvas := TCanvas(Instance);

    if MethodName = 'CREATE' then
      Result := Integer(TCanvas(Instance).Create)
    else if MethodName = 'DRAW' then
      _Canvas.Draw(Caller.Params[0], Caller.Params[1], TGraphic(Integer(Caller.Params[2])))
    else if MethodName = 'ELLIPSE' then
      _Canvas.Ellipse(Caller.Params[0], Caller.Params[1], Caller.Params[2], Caller.Params[3])
    else if MethodName = 'LINETO' then
      _Canvas.LineTo(Caller.Params[0], Caller.Params[1])
    else if MethodName = 'MOVETO' then
      _Canvas.MoveTo(Caller.Params[0], Caller.Params[1])
    else if MethodName = 'RECTANGLE' then
      _Canvas.Rectangle(Caller.Params[0], Caller.Params[1], Caller.Params[2], Caller.Params[3])
    else if MethodName = 'ROUNDRECT' then
      _Canvas.RoundRect(Caller.Params[0], Caller.Params[1], Caller.Params[2], Caller.Params[3], Caller.Params[4], Caller.Params[5])
    else if MethodName = 'STRETCHDRAW' then
      _Canvas.StretchDraw(Rect(Caller.Params[0], Caller.Params[1], Caller.Params[2], Caller.Params[3]), TGraphic(Integer(Caller.Params[4])))      
    else if MethodName = 'TEXTHEIGHT' then
      Result := _Canvas.TextHeight(Caller.Params[0])
    else if MethodName = 'TEXTOUT' then
      _Canvas.TextOut(Caller.Params[0], Caller.Params[1], Caller.Params[2])
    else if MethodName = 'TEXTWIDTH' then
      Result := _Canvas.TextWidth(Caller.Params[0])
{$IFNDEF CLX}
    else if MethodName = 'PIXELS.GET' then
      Result := _Canvas.Pixels[Caller.Params[0], Caller.Params[1]]
    else if MethodName = 'PIXELS.SET' then
      _Canvas.Pixels[Caller.Params[0], Caller.Params[1]] := Caller.Params[2]
{$ENDIF}
  end
  else if ClassType = TGraphic then
  begin
    if MethodName = 'CREATE' then
      Result := Integer(THackGraphic(Instance).Create)
    else if MethodName = 'LOADFROMFILE' then
      TGraphic(Instance).LoadFromFile(Caller.Params[0])
    else if MethodName = 'SAVETOFILE' then
      TGraphic(Instance).SaveToFile(Caller.Params[0])
  end
  else if ClassType = TPicture then
  begin
    if MethodName = 'LOADFROMFILE' then
      TPicture(Instance).LoadFromFile(Caller.Params[0])
    else if MethodName = 'SAVETOFILE' then
      TPicture(Instance).SaveToFile(Caller.Params[0])
  end
{$IFNDEF CROSS_COMPILE}
  else if ClassType = TMetafileCanvas then
  begin
    if MethodName = 'CREATE' then
      Result := Integer(TMetafileCanvas(Instance).Create(TMetafile(Integer(Caller.Params[0])), Caller.Params[1]))
  end
{$ENDIF}
end;

function TFunctions.GetProp(Instance: TObject; ClassType: TClass;
  const PropName: String): Variant;
begin
  Result := 0;

  if ClassType = TGraphic then
  begin
    if PropName = 'HEIGHT' then
      Result := TGraphic(Instance).Height
    else if PropName = 'WIDTH' then
      Result := TGraphic(Instance).Width
  end
  else if ClassType = TPicture then
  begin
    if PropName = 'HEIGHT' then
      Result := TPicture(Instance).Height
    else if PropName = 'WIDTH' then
      Result := TPicture(Instance).Width
  end
  else if ClassType = TBitmap then
  begin
    if PropName = 'CANVAS' then
      Result := Integer(TBitmap(Instance).Canvas)
  end
end;

procedure TFunctions.SetProp(Instance: TObject; ClassType: TClass;
  const PropName: String; Value: Variant);
begin
  if ClassType = TGraphic then
  begin
    if PropName = 'HEIGHT' then
      TGraphic(Instance).Height := Value
    else if PropName = 'WIDTH' then
      TGraphic(Instance).Width := Value
  end
end;

procedure TFunctions.GetColorProc(const Name: String);
var
  c: Integer;
begin
  IdentToColor(Name, c);
  Script.AddConst(Name, 'Integer', c);
end;


initialization
  fsRTTIModules.Add(TFunctions);

finalization
  if fsRTTIModules <> nil then
    fsRTTIModules.Remove(TFunctions);

end.
