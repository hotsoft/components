
{******************************************}
{                                          }
{             FastScript v1.9              }
{                  Chart                   }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_ichartrtti;

interface

{$i fs.inc}

uses
  SysUtils, Classes, fs_iinterpreter, fs_itools, fs_iformsrtti, Chart,
  Series, TeEngine, TeeProcs, TeCanvas;


type
  TfsChartRTTI = class(TComponent); // fake component


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
  public
    constructor Create(AScript: TfsScript); override;
  end;


{ TFunctions }

constructor TFunctions.Create(AScript: TfsScript);
begin
  inherited Create(AScript);
  with AScript do
  begin
    AddType('TChartValue', fvtFloat);
    AddEnum('TLegendStyle', 'lsAuto, lsSeries, lsValues, lsLastValues');
    AddEnum('TLegendAlignment', 'laLeft, laRight, laTop, laBottom');
    AddEnum('TLegendTextStyle', 'ltsPlain, ltsLeftValue, ltsRightValue, ltsLeftPercent,' +
      'ltsRightPercent, ltsXValue');
    AddEnum('TChartListOrder', 'loNone, loAscending, loDescending');
    AddEnum('TGradientDirection', 'gdTopBottom, gdBottomTop, gdLeftRight, gdRightLeft');
    AddEnum('TSeriesMarksStyle', 'smsValue, smsPercent, smsLabel, smsLabelPercent, ' +
      'smsLabelValue, smsLegend, smsPercentTotal, smsLabelPercentTotal, smsXValue');
    AddEnum('TAxisLabelStyle', 'talAuto, talNone, talValue, talMark, talText');
    AddEnum('THorizAxis', 'aTopAxis, aBottomAxis');
    AddEnum('TVertAxis', 'aLeftAxis, aRightAxis');
    AddEnum('TTeeBackImageMode', 'pbmStretch, pbmTile, pbmCenter');
    AddEnum('TPanningMode', 'pmNone, pmHorizontal, pmVertical, pmBoth');
    AddEnum('TSeriesPointerStyle', 'psRectangle, psCircle, psTriangle, ' +
      'psDownTriangle, psCross, psDiagCross, psStar, psDiamond, psSmallDot');
    AddEnum('TMultiArea', 'maNone, maStacked, maStacked100');
    AddEnum('TMultiBar', 'mbNone, mbSide, mbStacked, mbStacked100');
    AddEnum('TBarStyle', 'bsRectangle, bsPyramid, bsInvPyramid, bsCilinder, ' +
      'bsEllipse, bsArrow, bsRectGradient');

    AddEnum('TPenEndStyle', 'esRound, esSquare, esFlat');
    AddEnum('TPenMode', 'pmBlack, pmWhite, pmNop, pmNot, pmCopy, pmNotCopy, ' +
            'pmMergePenNot, pmMaskPenNot, pmMergeNotPen, pmMaskNotPen, pmMerge, ' +
            'pmNotMerge, pmMask, pmNotMask, pmXor, pmNotXor');
    AddEnum('TPenStyle', 'psSolid, psDash, psDot, psDashDot, psDashDotDot, psClear, psInsideFrame');
    AddClass(TChartValueList, 'TPersistent');
    AddClass(TChartAxisTitle, 'TPersistent');
    AddClass(TChartAxis, 'TPersistent');
    AddClass(TCustomChartLegend, 'TPersistent');
    AddClass(TChartLegend, 'TCustomChartLegend');
    AddClass(TSeriesMarks, 'TPersistent');
    AddClass(TChartGradient, 'TPersistent');
    AddClass(TChartWall, 'TPersistent');
    AddClass(TChartBrush, 'TBrush');
    AddClass(TChartTitle, 'TPersistent');
    AddClass(TView3DOptions, 'TPersistent');
    AddClass(TChartPen, 'TComponent');
    with AddClass(TChartSeries, 'TComponent') do
    begin
      AddMethod('procedure Clear', CallMethod);
      AddMethod('procedure Delete(Index: Integer)', CallMethod);
      AddMethod('function Count: Integer', CallMethod);
      AddMethod('procedure Add(const AValue: Double; const ALabel: String; AColor: TColor)', CallMethod);
      AddProperty('Active','Boolean', GetProp, SetProp);
    end;
    AddClass(TSeriesPointer, 'TPersistent');
    AddClass(TCustomSeries, 'TChartSeries');
    AddClass(TLineSeries, 'TCustomSeries');
    AddClass(TPointSeries, 'TCustomSeries');
    AddClass(TAreaSeries, 'TCustomSeries');
    with AddClass(TCustomBarSeries, 'TChartSeries') do
    begin
      AddProperty('Title','String', GetProp, SetProp);
    end;
    AddClass(TBarSeries, 'TCustomBarSeries');
    AddClass(THorizBarSeries, 'TCustomBarSeries');
    AddClass(TCircledSeries, 'TChartSeries');
    AddClass(TPieSeries, 'TCircledSeries');
    AddClass(TFastLineSeries, 'TChartSeries');
    AddClass(TCustomChart, 'TWinControl');
    AddClass(TChart, 'TCustomChart');
  end;
end;

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  Result := 0;

  if ClassType = TChartSeries then
  begin
    if MethodName = 'CLEAR' then
      TChartSeries(Instance).Clear
    else if MethodName = 'ADD' then
      TChartSeries(Instance).Add(Caller.Params[0], String(Caller.Params[1]), Caller.Params[2])
    else if MethodName = 'DELETE' then
      TChartSeries(Instance).Delete(Caller.Params[0])
    else if MethodName = 'COUNT' then
      Result := TChartSeries(Instance).Count
  end
end;

function TFunctions.GetProp(Instance: TObject; ClassType: TClass;
  const PropName: String): Variant;
begin
  Result := 0;

  if ClassType = TChartSeries then
  begin
    if PropName = 'ACTIVE' then
      Result := TChartSeries(Instance).Active
  end else
  if ClassType = TCustomBarSeries then
  begin
    if PropName = 'Title' then
      Result := TCustomBarSeries(Instance).Title
  end;
end;

procedure TFunctions.SetProp(Instance: TObject; ClassType: TClass;
  const PropName: String; Value: Variant);
begin
  if ClassType = TChartSeries then
  begin
    if PropName = 'ACTIVE' then
      TChartSeries(Instance).Active := Value
  end else
  if ClassType = TCustomBarSeries then
  begin
    if PropName = 'Title' then
      TCustomBarSeries(Instance).Title := Value
  end
end;

initialization
  fsRTTIModules.Add(TFunctions);

finalization
  if fsRTTIModules <> nil then
    fsRTTIModules.Remove(TFunctions);

end.
