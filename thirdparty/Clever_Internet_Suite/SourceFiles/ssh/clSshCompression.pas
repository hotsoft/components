{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSshCompression;

interface

{$I ..\common\clVer.inc}

uses
  clUtils, clConfig;

type
  TclCompressionType = (ctInflater, ctDeflater);

  TclCompression = class(TclConfigObject)
  public
    procedure Init(AType: TclCompressionType; ALevel: Integer); virtual; abstract;
    function Compress(var ABuf: TclByteArray; AStart, ALen: Integer): Integer; virtual; abstract;
    function Uncompress(const ABuf: TclByteArray; AStart: Integer; const ALen: Integer): TclByteArray; virtual; abstract;
  end;

implementation

end.
