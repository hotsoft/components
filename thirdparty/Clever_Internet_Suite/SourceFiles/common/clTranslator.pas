{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clTranslator;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils,
{$ELSE}
  System.Classes, System.SysUtils, System.Types,
{$ENDIF}
  clUtils, clWUtils;

type
  TclXLATTable = record
    Name: string[20];
    Table: array [0..255] of Byte;
    ReverseTable: array [0..255] of Byte;
  end;

  TclTranslator = class
  private
    class function GetXLATByID(const ATableID: string): TclXLATTable;
    class function ToUtf8(Source: PWideChar; SourceLength: Integer;
      Dest: PclChar; DestLength: Integer): Integer;
    class function FromUtf8(Source: PclChar; SourceLength: Integer;
      Dest: PWideChar; DestLength: Integer): Integer;
{$IFDEF DELPHI2009}
    class function GetEncoding(const ACharSet: string): TEncoding;
    class function WideStringToString(const ws: WideString; codePage: Word): AnsiString;
    class function StringToWideString(const s: AnsiString; codePage: Word): WideString;
{$ELSE}
    class function WideStringToString(const ws: WideString; codePage: Word): string;
    class function StringToWideString(const s: string; codePage: Word): WideString;
{$ENDIF}
  public
    class function TranslateToUtf8(const ASource: WideString): string;
    class function TranslateFromUtf8(const ASource: string): WideString;

    class function TranslateTo(const ACharSet, ASource: string): string; overload;
    class function TranslateFrom(const ACharSet, ASource: string): string; overload;

    class procedure TranslateTo(const ACharSet: string; ASource, ADestination: TStream); overload;
    class procedure TranslateFrom(const ACharSet: string; ASource, ADestination: TStream); overload;

    class procedure GetSupportedCharSets(ACharSets: TStrings);

    class function GetString(const ABytes: TclByteArray; AIndex, ACount: Integer; const ACharSet: string): string; overload;
    class function GetString(const ABytes: TclByteArray; AIndex, ACount: Integer): string; overload;
    class function GetString(const ABytes: TclByteArray; const ACharSet: string): string; overload;
    class function GetString(const ABytes: TclByteArray): string; overload;
    class function GetString(ABytes: PclChar; ACount: Integer; const ACharSet: string): string; overload;

    class function GetBytes(const AText: string; const ACharSet: string): TclByteArray; overload;
    class function GetBytes(const AText: string): TclByteArray; overload;
    class procedure GetBytes(const AText: string; ABytes: PclChar; AByteCount: Integer; const ACharSet: string); overload;

    class function GetByteCount(const AText, ACharSet: string): Integer; overload;
    class function GetByteCount(const AText: string): Integer; overload;

    class function GetUtf8Bytes(const AText: WideString): TclByteArray;
    class function GetUtf8ByteCount(const AText: WideString): Integer;
    class function GetStringFromUtf8(const ABytes: TclByteArray): WideString;

    class function IsUtf8(AStream: TStream): Boolean; overload;
    class function IsUtf8(const ABytes: TclByteArray): Boolean; overload;
    class function IsUtf8(const ABytes: TclByteArray; AIndex, ACount: Integer): Boolean; overload;
  end;

implementation

uses
{$IFNDEF DELPHIXE2}
  Windows;
{$ELSE}
  Winapi.Windows;
{$ENDIF}

const
  CharSetTables: array [0..11] of TclXLATTable = (
  (
  Name: 'ISO-8859-1';
  Table:
  	($00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$13,$14,$15,$16,$17
        ,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f
        ,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,$40,$41,$42,$43,$44,$45,$46,$47
        ,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f
        ,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,$70,$71,$72,$73,$74,$75,$76,$77
        ,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f
        ,$90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f,$a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7
        ,$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af,$b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9,$ba,$bb,$bc,$bd,$be,$bf
        ,$c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9,$ca,$cb,$cc,$cd,$ce,$cf,$d0,$d1,$d2,$d3,$d4,$d5,$d6,$d7
        ,$d8,$d9,$da,$db,$dc,$dd,$de,$df,$e0,$e1,$e2,$e3,$e4,$e5,$e6,$e7,$e8,$e9,$ea,$eb,$ec,$ed,$ee,$ef
        ,$f0,$f1,$f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9,$fa,$fb,$fc,$fd,$fe,$ff);
  ReverseTable:
        ($00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$13,$14,$15,$16,$17
        ,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f
        ,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,$40,$41,$42,$43,$44,$45,$46,$47
        ,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f
        ,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,$70,$71,$72,$73,$74,$75,$76,$77
        ,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f
        ,$90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f,$a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7
        ,$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af,$b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9,$ba,$bb,$bc,$bd,$be,$bf
        ,$c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9,$ca,$cb,$cc,$cd,$ce,$cf,$d0,$d1,$d2,$d3,$d4,$d5,$d6,$d7
        ,$d8,$d9,$da,$db,$dc,$dd,$de,$df,$e0,$e1,$e2,$e3,$e4,$e5,$e6,$e7,$e8,$e9,$ea,$eb,$ec,$ed,$ee,$ef
        ,$f0,$f1,$f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9,$fa,$fb,$fc,$fd,$fe,$ff)
  ),
  (
  Name: 'ISO-8859-2';
  Table:
    ($00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,
    $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,
    $20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f,
    $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,
    $40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,
    $50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f,
    $60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,
    $70,$71,$72,$73,$74,$75,$76,$77,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f,
    $80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f,
    $90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f,
    $a0,$a1,$a2,$a3,$a4,$a5,$8c,$a7,$a8,$8a,$aa,$ab,$8f,$ad,$8e,$af,
    $b0,$b1,$b2,$b3,$b4,$b5,$9c,$a1,$b8,$9a,$ba,$bb,$9f,$bd,$9e,$bf,
    $c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9,$ca,$cb,$cc,$cd,$ce,$cf,
    $d0,$d1,$d2,$d3,$d4,$d5,$d6,$d7,$d8,$d9,$da,$db,$dc,$dd,$de,$df,
    $e0,$e1,$e2,$e3,$e4,$e5,$e6,$e7,$e8,$e9,$ea,$eb,$ec,$ed,$ee,$ef,
    $f0,$f1,$f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9,$fa,$fb,$fc,$fd,$fe,$ff);
  ReverseTable:
    ($00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,
    $10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,
    $20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f,
    $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,
    $40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,
    $50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f,
    $60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,
    $70,$71,$72,$73,$74,$75,$76,$77,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f,
    $80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$a9,$8b,$a6,$8d,$ae,$ac,
    $90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$b9,$9b,$b6,$9d,$be,$bc,
    $a0,$b7,$a2,$a3,$a4,$a5,$a6,$a7,$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af,
    $b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9,$ba,$bb,$bc,$bd,$be,$bf,
    $c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9,$ca,$cb,$cc,$cd,$ce,$cf,
    $d0,$d1,$d2,$d3,$d4,$d5,$d6,$d7,$d8,$d9,$da,$db,$dc,$dd,$de,$df,
    $e0,$e1,$e2,$e3,$e4,$e5,$e6,$e7,$e8,$e9,$ea,$eb,$ec,$ed,$ee,$ef,
    $f0,$f1,$f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9,$fa,$fb,$fc,$fd,$fe,$ff)
  ),
  (
  Name:	'Windows-1250';
  Table:
  	($00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$13,$14,$15,$16,$17
        ,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f
        ,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,$40,$41,$42,$43,$44,$45,$46,$47
        ,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f
        ,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,$70,$71,$72,$73,$74,$75,$76,$77
        ,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f
        ,$90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f,$a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7
        ,$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af,$b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9,$ba,$bb,$bc,$bd,$be,$bf
        ,$c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9,$ca,$cb,$cc,$cd,$ce,$cf,$d0,$d1,$d2,$d3,$d4,$d5,$d6,$d7
        ,$d8,$d9,$da,$db,$dc,$dd,$de,$df,$e0,$e1,$e2,$e3,$e4,$e5,$e6,$e7,$e8,$e9,$ea,$eb,$ec,$ed,$ee,$ef
        ,$f0,$f1,$f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9,$fa,$fb,$fc,$fd,$fe,$ff);
  ReverseTable:
  	($00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$13,$14,$15,$16,$17
        ,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f
        ,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,$40,$41,$42,$43,$44,$45,$46,$47
        ,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f
        ,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,$70,$71,$72,$73,$74,$75,$76,$77
        ,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f
        ,$90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f,$a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7
        ,$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af,$b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9,$ba,$bb,$bc,$bd,$be,$bf
        ,$c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9,$ca,$cb,$cc,$cd,$ce,$cf,$d0,$d1,$d2,$d3,$d4,$d5,$d6,$d7
        ,$d8,$d9,$da,$db,$dc,$dd,$de,$df,$e0,$e1,$e2,$e3,$e4,$e5,$e6,$e7,$e8,$e9,$ea,$eb,$ec,$ed,$ee,$ef
        ,$f0,$f1,$f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9,$fa,$fb,$fc,$fd,$fe,$ff)
  ),
  (
  Name: 'ibm866';
  Table:
  	($00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$13,$14//21
        ,$15,$16,$17,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29//42
        ,$2a,$2b,$2c,$2d,$2e,$2f,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e//63
        ,$3f,$40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,$50,$51,$52,$53//84
        ,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f,$60,$61,$62,$63,$64,$65,$66,$67,$68//105
        ,$69,$6a,$6b,$6c,$6d,$6e,$6f,$70,$71,$72,$73,$74,$75,$76,$77,$78,$79,$7a,$7b,$7c,$7d//126
        ,$7e,$7f,$c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9,$ca,$cb,$cc,$cd,$ce,$cf,$d0,$d1,$d2//147
        ,$d3,$d4,$d5,$d6,$d7,$d8,$d9,$da,$db,$dc,$dd,$de,$df,$e0,$e1,$e2,$e3,$e4,$e5,$e6,$e7//168
        ,$e8,$e9,$ea,$eb,$ec,$ed,$ee,$ef,$b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9,$ba,$bb,$bc//189
        ,$bd,$be,$bf,$c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9,$ca,$cb,$cc,$cd,$ce,$cf,$d0,$d1//210
        ,$d2,$d3,$d4,$d5,$d6,$d7,$d8,$d9,$da,$db,$dc,$dd,$de,$df,$f0,$f1,$f2,$f3,$f4,$f5,$f6//231
        ,$f7,$f8,$f9,$fa,$fb,$fc,$fd,$fe,$ff,$a8,$a3,$f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9,$fa,$fb//252
        ,$fc,$fd,$fe,$ff);
  ReverseTable:
  	($00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$13,$14//21
        ,$15,$16,$17,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29//42
        ,$2a,$2b,$2c,$2d,$2e,$2f,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e//63
        ,$3f,$40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,$50,$51,$52,$53//84
        ,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f,$60,$61,$62,$63,$64,$65,$66,$67,$68//105
        ,$69,$6a,$6b,$6c,$6d,$6e,$6f,$70,$71,$72,$73,$74,$75,$76,$77,$78,$79,$7a,$7b,$7c,$7d//126
        ,$7e,$7f,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f,$90,$91,$92//147
        ,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f,$a0,$a1,$a2,$f1,$a4,$a5,$a6,$a7//168
        ,$f0,$a9,$aa,$ab,$ac,$ad,$ae,$af,$b0,$b1,$b2,$f0,$b4,$b5,$b6,$b7,$b8,$b9,$ba,$bb,$bc//189
        ,$bd,$be,$bf,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f,$90,$91//210
        ,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f,$a0,$a1,$a2,$a3,$a4,$a5,$a6//231
        ,$a7,$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af,$e0,$e1,$e2,$e3,$e4,$e5,$e6,$e7,$e8,$e9,$ea,$eb//252
        ,$ec,$ed,$ee,$ef)
  ),
  (
  Name: 'ISO-8859-5';
  Table:
  	($00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$13,$14,$15,$16,$17
        ,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f
        ,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,$40,$41,$42,$43,$44,$45,$46,$47
        ,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f
        ,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,$70,$71,$72,$73,$74,$75,$76,$77
        ,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f
        ,$a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7,$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af,$b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7
        ,$b8,$b9,$ba,$bb,$bc,$bd,$be,$bf,$c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9,$ca,$cb,$cc,$cd,$ce,$cf
        ,$d0,$d1,$d2,$d3,$d4,$d5,$d6,$d7,$d8,$d9,$da,$db,$dc,$dd,$de,$df,$e0,$e1,$e2,$e3,$e4,$e5,$e6,$e7
        ,$e8,$e9,$ea,$eb,$ec,$ed,$ee,$ef,$f0,$f1,$f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9,$fa,$fb,$fc,$fd,$fe,$ff
        ,$f0,$f1,$f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9,$fa,$fb,$fc,$fd,$fe,$ff);
  ReverseTable:
  	($00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$13,$14,$15,$16,$17
        ,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f
        ,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,$40,$41,$42,$43,$44,$45,$46,$47
        ,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f
        ,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,$70,$71,$72,$73,$74,$75,$76,$77
        ,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f
        ,$90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f,$90,$91,$92,$93,$94,$95,$96,$97
        ,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f,$a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7,$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af
        ,$b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9,$ba,$bb,$bc,$bd,$be,$bf,$c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7
        ,$c8,$c9,$ca,$cb,$cc,$cd,$ce,$cf,$d0,$d1,$d2,$d3,$d4,$d5,$d6,$d7,$d8,$d9,$da,$db,$dc,$dd,$de,$df
        ,$e0,$e1,$e2,$e3,$e4,$e5,$e6,$e7,$e8,$e9,$ea,$eb,$ec,$ed,$ee,$ef)
  ),
  (
  Name:	'koi8-r';
  Table:
  	($00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$13,$14,$15,$16,$17
        ,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f
        ,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,$40,$41,$42,$43,$44,$45,$46,$47
        ,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f
        ,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,$70,$71,$72,$73,$74,$75,$76,$77
        ,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f
        ,$90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f,$a0,$a1,$a2,$b8,$a4,$a5,$a6,$a7
        ,$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af,$b0,$b1,$b2,$a8,$b4,$b5,$b6,$b7,$a3,$b9,$ba,$bb,$bc,$bd,$be,$bf
        ,$fe,$e0,$e1,$f6,$e4,$e5,$f4,$e3,$f5,$e8,$e9,$ea,$eb,$ec,$ed,$ee,$ef,$ff,$f0,$f1,$f2,$f3,$e6,$e2
        ,$fc,$fb,$e7,$f8,$fd,$f9,$f7,$fa,$de,$c0,$c1,$d6,$c4,$c5,$d4,$c3,$d5,$c8,$c9,$ca,$cb,$cc,$cd,$ce
        ,$cf,$df,$d0,$d1,$d2,$d3,$c6,$c2,$dc,$db,$c7,$d8,$dd,$d9,$d7,$da);
  ReverseTable:
  	($00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$13,$14,$15,$16,$17
        ,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f
        ,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,$40,$41,$42,$43,$44,$45,$46,$47
        ,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f
        ,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,$70,$71,$72,$73,$74,$75,$76,$77
        ,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f
        ,$90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f,$a0,$a1,$a2,$b8,$a4,$a5,$a6,$a7
        ,$b3,$a9,$aa,$ab,$ac,$ad,$ae,$af,$b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7,$a3,$b9,$ba,$bb,$bc,$bd,$be,$bf
        ,$e1,$e2,$f7,$e7,$e4,$e5,$f6,$fa,$e9,$ea,$eb,$ec,$ed,$ee,$ef,$f0,$f2,$f3,$f4,$f5,$e6,$e8,$e3,$fe
        ,$fb,$fd,$ff,$f9,$f8,$fc,$e0,$f1,$c1,$c2,$d7,$c7,$c4,$c5,$d6,$da,$c9,$ca,$cb,$cc,$cd,$ce,$cf,$d0
        ,$d2,$d3,$d4,$d5,$c6,$c8,$c3,$de,$db,$dd,$df,$d9,$d8,$dc,$c0,$d1)
  ),
  (
  Name:	'koi8-u';
  Table:
  	($00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$13,$14,$15,$16,$17
        ,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f
        ,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,$40,$41,$42,$43,$44,$45,$46,$47
        ,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f
        ,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,$70,$71,$72,$73,$74,$75,$76,$77
        ,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f
        ,$90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f,$a0,$a1,$a2,$b8,$ba,$a5,$b3,$bf
        ,$a8,$a9,$aa,$ab,$ac,$b4,$ae,$af,$b0,$b1,$b2,$a8,$aa,$b5,$b2,$af,$b8,$b9,$ba,$bb,$bc,$a5,$be,$bf
        ,$fe,$e0,$e1,$f6,$e4,$e5,$f4,$e3,$f5,$e8,$e9,$ea,$eb,$ec,$ed,$ee,$ef,$ff,$f0,$f1,$f2,$f3,$e6,$e2
        ,$fc,$fb,$e7,$f8,$fd,$f9,$f7,$fa,$de,$c0,$c1,$d6,$c4,$c5,$d4,$c3,$d5,$c8,$c9,$ca,$cb,$cc,$cd,$ce
        ,$cf,$df,$d0,$d1,$d2,$d3,$c6,$c2,$dc,$db,$c7,$d8,$dd,$d9,$d7,$da);
  ReverseTable:
  	($00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$13,$14,$15,$16,$17
        ,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f
        ,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,$40,$41,$42,$43,$44,$45,$46,$47
        ,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f
        ,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,$70,$71,$72,$73,$74,$75,$76,$77
        ,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f
        ,$90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f,$a0,$a1,$a2,$a3,$a4,$bd,$a6,$a7
        ,$b3,$a9,$b4,$ab,$ac,$ad,$ae,$b7,$b0,$b1,$b6,$a6,$ad,$b5,$b6,$b7,$a3,$b9,$a4,$bb,$bc,$bd,$be,$a7
        ,$e1,$e2,$f7,$e7,$e4,$e5,$f6,$fa,$e9,$ea,$eb,$ec,$ed,$ee,$ef,$f0,$f2,$f3,$f4,$f5,$e6,$e8,$e3,$fe
        ,$fb,$fd,$ff,$f9,$f8,$fc,$e0,$f1,$c1,$c2,$d7,$c7,$c4,$c5,$d6,$da,$c9,$ca,$cb,$cc,$cd,$ce,$cf,$d0
        ,$d2,$d3,$d4,$d5,$c6,$c8,$c3,$de,$db,$dd,$df,$d9,$d8,$dc,$c0,$d1)
  ),
  (
  Name:	'KOI8-WIN';
  Table:
  	($00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$13,$14,$15,$16,$17
        ,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f
        ,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,$40,$41,$42,$43,$44,$45,$46,$47
        ,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f
        ,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,$70,$71,$72,$73,$74,$75,$76,$77
        ,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f
        ,$90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$da,$9b,$9c,$9d,$9e,$9f,$a0,$e7,$a2,$a3,$a4,$a5,$a6,$a7
        ,$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af,$b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9,$ba,$bb,$bc,$bd,$be,$bf
        ,$d7,$de,$c0,$c6,$c4,$c5,$d2,$d6,$d3,$d5,$c8,$c9,$ca,$cb,$cc,$cd,$ce,$d1,$cf,$df,$d0,$d1,$d4,$c1
        ,$dd,$d8,$c3,$dc,$d9,$db,$c2,$c7,$f7,$fe,$e0,$e6,$e4,$e5,$f2,$f6,$f3,$f5,$e8,$e9,$ea,$eb,$ec,$ed
        ,$ee,$fa,$ef,$ff,$f0,$f1,$f4,$e1,$fd,$f8,$e3,$fc,$f9,$fb,$e2,$ff);
  ReverseTable:
  	($00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$13,$14,$15,$16,$17
        ,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f
        ,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,$40,$41,$42,$43,$44,$45,$46,$47
        ,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f
        ,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,$70,$71,$72,$73,$74,$75,$76,$77
        ,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f
        ,$90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f,$a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7
        ,$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af,$b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9,$ba,$bb,$bc,$bd,$be,$bf
        ,$c2,$d7,$de,$da,$c4,$c5,$c3,$df,$ca,$cb,$cc,$cd,$ce,$cf,$d0,$d2,$d4,$d5,$c6,$c8,$d6,$c9,$c7,$c0
        ,$d9,$dc,$9a,$dd,$db,$d8,$c1,$d3,$e2,$f7,$fe,$fa,$e4,$e5,$e3,$a1,$ea,$eb,$ec,$ed,$ee,$ef,$f0,$f2
        ,$f4,$f5,$e6,$e8,$f6,$e9,$e7,$e0,$f9,$fc,$f1,$fd,$fb,$f8,$e1,$f3)
  ),
  (
  Name:	'WIN-KOI8';
  Table:
  	($00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$13,$14,$15,$16,$17
        ,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f
        ,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,$40,$41,$42,$43,$44,$45,$46,$47
        ,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f
        ,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,$70,$71,$72,$73,$74,$75,$76,$77
        ,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f
        ,$90,$91,$92,$93,$94,$ff,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f,$a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7
        ,$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af,$b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9,$ba,$bb,$bc,$bd,$be,$bf
        ,$e1,$e2,$f7,$e7,$e4,$e5,$f6,$fa,$c8,$ea,$eb,$ec,$ed,$ee,$ef,$f0,$f2,$f3,$f4,$f5,$e6,$e8,$e3,$fe
        ,$fb,$fd,$da,$f9,$f8,$fc,$e0,$f1,$c1,$c2,$d7,$c7,$c4,$c5,$d6,$ff,$e8,$ca,$cb,$cc,$cd,$ce,$cf,$d0
        ,$d2,$d3,$d4,$d5,$c6,$c8,$c3,$de,$db,$dd,$df,$d9,$d8,$dc,$c0,$d1);
  ReverseTable:
  	($00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$13,$14,$15,$16,$17 //23
        ,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f//47
        ,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,$40,$41,$42,$43,$44,$45,$46,$47//71
        ,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f//95
        ,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,$70,$71,$72,$73,$74,$75,$76,$77//119
        ,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f//143
        ,$90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f,$a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7//167
        ,$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af,$b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9,$ba,$bb,$bc,$bd,$be,$bf//191
        ,$fe,$e0,$e1,$f6,$e4,$e5,$f4,$e3,$f5,$c9,$e9,$ea,$eb,$ec,$ed,$ee,$ef,$ff,$f0,$f1,$f2,$f3,$e6,$e2//215
        ,$fc,$fb,$da,$f8,$fd,$f9,$f7,$fa,$de,$c0,$c1,$d6,$c4,$c5,$d4,$c3,$d5,$e9,$c9,$ca,$cb,$cc,$cd,$ce//239
        ,$cf,$df,$d0,$d1,$d2,$d3,$c6,$c2,$dc,$db,$c7,$d8,$dd,$d9,$d7,$e7)
  ),
  (
  Name:	'Windows-1251';
  Table:
  	($00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$13,$14,$15,$16,$17
        ,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f
        ,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,$40,$41,$42,$43,$44,$45,$46,$47
        ,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f
        ,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,$70,$71,$72,$73,$74,$75,$76,$77
        ,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f
        ,$90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f,$a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7
        ,$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af,$b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9,$ba,$bb,$bc,$bd,$be,$bf
        ,$c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9,$ca,$cb,$cc,$cd,$ce,$cf,$d0,$d1,$d2,$d3,$d4,$d5,$d6,$d7
        ,$d8,$d9,$da,$db,$dc,$dd,$de,$df,$e0,$e1,$e2,$e3,$e4,$e5,$e6,$e7,$e8,$e9,$ea,$eb,$ec,$ed,$ee,$ef
        ,$f0,$f1,$f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9,$fa,$fb,$fc,$fd,$fe,$ff);
  ReverseTable:
  	($00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$13,$14,$15,$16,$17
        ,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f
        ,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,$40,$41,$42,$43,$44,$45,$46,$47
        ,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f
        ,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,$70,$71,$72,$73,$74,$75,$76,$77
        ,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f
        ,$90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f,$a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7
        ,$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af,$b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9,$ba,$bb,$bc,$bd,$be,$bf
        ,$c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9,$ca,$cb,$cc,$cd,$ce,$cf,$d0,$d1,$d2,$d3,$d4,$d5,$d6,$d7
        ,$d8,$d9,$da,$db,$dc,$dd,$de,$df,$e0,$e1,$e2,$e3,$e4,$e5,$e6,$e7,$e8,$e9,$ea,$eb,$ec,$ed,$ee,$ef
        ,$f0,$f1,$f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9,$fa,$fb,$fc,$fd,$fe,$ff)
  ),
  (
  Name:	'x-mac-cyrillic';
  Table:
  	($00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$13,$14,$15,$16,$17
        ,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f
        ,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,$40,$41,$42,$43,$44,$45,$46,$47
        ,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f
        ,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,$70,$71,$72,$73,$74,$75,$76,$77
        ,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f,$c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9,$ca,$cb,$cc,$cd,$ce,$cf
        ,$d0,$d1,$d2,$d3,$d4,$d5,$d6,$d7,$d8,$d9,$da,$db,$dc,$dd,$de,$df,$a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7
        ,$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af,$b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9,$ba,$bb,$bc,$bd,$be,$bf
        ,$c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9,$ca,$cb,$cc,$cd,$ce,$cf,$d0,$d1,$d2,$d3,$d4,$d5,$d6,$d7
        ,$d8,$d9,$da,$db,$dc,$a8,$b8,$ff,$e0,$e1,$e2,$e3,$e4,$e5,$e6,$e7,$e8,$e9,$ea,$eb,$ec,$ed,$ee,$ef
        ,$f0,$f1,$f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9,$fa,$fb,$fc,$fd,$fe,$ff);
  ReverseTable:
  	($00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$13,$14,$15,$16,$17
        ,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f
        ,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,$40,$41,$42,$43,$44,$45,$46,$47
        ,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f
        ,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,$70,$71,$72,$73,$74,$75,$76,$77
        ,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f
        ,$90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f,$a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7
        ,$dd,$a9,$aa,$ab,$ac,$ad,$ae,$af,$b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7,$de,$b9,$ba,$bb,$bc,$bd,$be,$bf
        ,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f,$90,$91,$92,$93,$94,$95,$96,$97
        ,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f,$e0,$e1,$e2,$e3,$e4,$e5,$e6,$e7,$e8,$e9,$ea,$eb,$ec,$ed,$ee,$ef
        ,$f0,$f1,$f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9,$fa,$fb,$fc,$fd,$fe,$df)
  ),
  (
  Name: 'Latin1';
  Table:
  	($00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$13,$14,$15,$16,$17
        ,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f
        ,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,$40,$41,$42,$43,$44,$45,$46,$47
        ,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f
        ,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,$70,$71,$72,$73,$74,$75,$76,$77
        ,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f
        ,$90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f,$a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7
        ,$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af,$b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9,$ba,$bb,$bc,$bd,$be,$bf
        ,$c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9,$ca,$cb,$cc,$cd,$ce,$cf,$d0,$d1,$d2,$d3,$d4,$d5,$d6,$d7
        ,$d8,$d9,$da,$db,$dc,$dd,$de,$df,$e0,$e1,$e2,$e3,$e4,$e5,$e6,$e7,$e8,$e9,$ea,$eb,$ec,$ed,$ee,$ef
        ,$f0,$f1,$f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9,$fa,$fb,$fc,$fd,$fe,$ff);
  ReverseTable:
        ($00,$01,$02,$03,$04,$05,$06,$07,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$13,$14,$15,$16,$17
        ,$18,$19,$1a,$1b,$1c,$1d,$1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f
        ,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$3f,$40,$41,$42,$43,$44,$45,$46,$47
        ,$48,$49,$4a,$4b,$4c,$4d,$4e,$4f,$50,$51,$52,$53,$54,$55,$56,$57,$58,$59,$5a,$5b,$5c,$5d,$5e,$5f
        ,$60,$61,$62,$63,$64,$65,$66,$67,$68,$69,$6a,$6b,$6c,$6d,$6e,$6f,$70,$71,$72,$73,$74,$75,$76,$77
        ,$78,$79,$7a,$7b,$7c,$7d,$7e,$7f,$80,$81,$82,$83,$84,$85,$86,$87,$88,$89,$8a,$8b,$8c,$8d,$8e,$8f
        ,$90,$91,$92,$93,$94,$95,$96,$97,$98,$99,$9a,$9b,$9c,$9d,$9e,$9f,$a0,$a1,$a2,$a3,$a4,$a5,$a6,$a7
        ,$a8,$a9,$aa,$ab,$ac,$ad,$ae,$af,$b0,$b1,$b2,$b3,$b4,$b5,$b6,$b7,$b8,$b9,$ba,$bb,$bc,$bd,$be,$bf
        ,$c0,$c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9,$ca,$cb,$cc,$cd,$ce,$cf,$d0,$d1,$d2,$d3,$d4,$d5,$d6,$d7
        ,$d8,$d9,$da,$db,$dc,$dd,$de,$df,$e0,$e1,$e2,$e3,$e4,$e5,$e6,$e7,$e8,$e9,$ea,$eb,$ec,$ed,$ee,$ef
        ,$f0,$f1,$f2,$f3,$f4,$f5,$f6,$f7,$f8,$f9,$fa,$fb,$fc,$fd,$fe,$ff)
  )
  );

{$IFDEF DELPHI2009}
{$IFNDEF DELPHIXE}
type
  TclCharSetCodePage = record
    CodePage: Integer;
    Name: string[20];
  end;

const
  CharSetCodePages: array [0..34] of TclCharSetCodePage = (
    (CodePage: 1250; Name: 'windows-1250'),
    (CodePage: 1251; Name: 'windows-1251'),
    (CodePage: 1252; Name: 'windows-1252'),
    (CodePage: 1253; Name: 'windows-1253'),
    (CodePage: 1254; Name: 'windows-1254'),
    (CodePage: 1255; Name: 'windows-1255'),
    (CodePage: 1256; Name: 'windows-1256'),
    (CodePage: 1257; Name: 'windows-1257'),
    (CodePage: 1258; Name: 'windows-1258'),
    (CodePage: 28591; Name: 'iso-8859-1'),
    (CodePage: 28592; Name: 'iso-8859-2'),
    (CodePage: 28593; Name: 'iso-8859-3'),
    (CodePage: 28594; Name: 'iso-8859-4'),
    (CodePage: 28595; Name: 'iso-8859-5'),
    (CodePage: 28596; Name: 'iso-8859-6'),
    (CodePage: 28597; Name: 'iso-8859-7'),
    (CodePage: 28598; Name: 'iso-8859-8'),
    (CodePage: 28599; Name: 'iso-8859-9'),
    (CodePage: 28603; Name: 'iso-8859-13'),
    (CodePage: 28605; Name: 'iso-8859-15'),
    (CodePage: 866; Name: 'ibm866'),
    (CodePage: 866; Name: 'cp866'),
    (CodePage: 1200; Name: 'utf-16'),
    (CodePage: 12000; Name: 'utf-32'),
    (CodePage: 65000; Name: 'utf-7'),
    (CodePage: 65001; Name: 'utf-8'),
    (CodePage: 20127; Name: 'us-ascii'),
    (CodePage: 28591; Name: 'Latin1'),
    (CodePage: 10007; Name: 'x-mac-cyrillic'),
    (CodePage: 21866; Name: 'koi8-u'),
    (CodePage: 20866; Name: 'koi8-r'),
    (CodePage: 932; Name: 'shift-jis'),
    (CodePage: 932; Name: 'shift_jis'),
    (CodePage: 50220; Name: 'iso-2022-jp'),
    (CodePage: 50220; Name: 'csISO2022JP')
  );
{$ENDIF}

class function TclTranslator.GetEncoding(const ACharSet: string): TEncoding;
  {$IFNDEF DELPHIXE}
  function GetCodePage(const ACharSet: string): Integer;
  var
    i: Integer;
  begin
    for i := Low(CharSetCodePages) to High(CharSetCodePages) do
    begin
      if SameText(string(CharSetCodePages[i].Name), ACharSet) then
      begin
        Result := CharSetCodePages[i].CodePage;
        Exit;
      end;
    end;
    Result := GetACP();
  end;
  {$ENDIF}
begin
  {$IFNDEF DELPHIXE}
    try
      Result := TEncoding.GetEncoding(GetCodePage(ACharSet));
    except
      Result := TEncoding.GetEncoding(GetACP());
    end;
  {$ELSE}
    try
      if (Trim(ACharSet) = '') then
      begin
        Result := TEncoding.Default.Clone();
      end else
      begin
        Result := TEncoding.GetEncoding(ACharSet);
      end;
    except
      Result := TEncoding.Default.Clone();
    end;
  {$ENDIF}
end;
{$ENDIF}

{ TclTranslator }

class function TclTranslator.GetByteCount(const AText, ACharSet: string): Integer;
var
{$IFDEF DELPHI2009}
  enc: TEncoding;
{$ENDIF}
  res: string;
begin
{$IFDEF DELPHI2009}
  try
    enc := GetEncoding(ACharSet);
    try
      Result := enc.GetByteCount(AText);
    finally
      enc.Free();
    end;

    Exit;
  except
    on EEncodingError do;
  end;
{$ENDIF}
  if SameText('utf-8', ACharSet) then
  begin
    res := TranslateToUtf8(StringToWideString(GetTclString(AText), CP_ACP));
  end else
  begin
    res := TranslateTo(ACharSet, AText);
  end;

  Result := Length(res);
end;

class function TclTranslator.GetBytes(const AText, ACharSet: string): TclByteArray;
var
  len: Integer;
begin
  len := GetByteCount(AText, ACharSet);
  SetLength(Result, len);
  GetBytes(AText, PclChar(Result), len, ACharSet);
end;

class function TclTranslator.GetBytes(const AText: string): TclByteArray;
begin
  Result := GetBytes(AText, '');
end;

class function TclTranslator.GetByteCount(const AText: string): Integer;
begin
  Result := GetByteCount(AText, '');
end;

class procedure TclTranslator.GetBytes(const AText: string; ABytes: PclChar; AByteCount: Integer; const ACharSet: string);
var
  cnt: Integer;
{$IFDEF DELPHI2009}
  enc: TEncoding;
  buf: TBytes;
{$ENDIF}
  res: string;
begin
{$IFDEF DELPHI2009}
  try
    enc := GetEncoding(ACharSet);
    try
      cnt := enc.GetByteCount(AText);

      if (cnt > AByteCount) then
      begin
        cnt := AByteCount;
      end;

      SetLength(buf, cnt);
      enc.GetBytes(AText, 1, Length(AText), buf, 0);
      if (cnt > 0) then
      begin
        system.Move(buf[0], ABytes[0], cnt);
      end;
    finally
      enc.Free();
    end;
    
    Exit;
  except
    on EEncodingError do;
  end;
{$ENDIF}
  if SameText('utf-8', ACharSet) then
  begin
    res := TranslateToUtf8(StringToWideString(GetTclString(AText), CP_ACP));
  end else
  begin
    res := TranslateTo(ACharSet, AText);
  end;

  cnt := Length(res);

  if (cnt > AByteCount) then
  begin
    cnt := AByteCount;
  end;

  if (cnt > 0) then
  begin
    system.Move(PChar(res)^, ABytes^, cnt);
  end;
end;

{$IFDEF DELPHI2009}
class function TclTranslator.WideStringToString(const ws: WideString; codePage: Word): AnsiString;
{$ELSE}
class function TclTranslator.WideStringToString(const ws: WideString; codePage: Word): string;
{$ENDIF}
var
  len: Integer;
begin
  if (ws = '') then
  begin
    Result := '';
  end else
  begin
    len := WideCharToMultiByte(codePage, WC_COMPOSITECHECK or WC_DISCARDNS or WC_SEPCHARS or WC_DEFAULTCHAR,
      @ws[1], -1, nil, 0, nil, nil);
    SetLength(Result, len - 1);
    if (len > 1) then
    begin
      WideCharToMultiByte(codePage, WC_COMPOSITECHECK or WC_DISCARDNS or WC_SEPCHARS or WC_DEFAULTCHAR,
        @ws[1], -1, @Result[1], len - 1, nil, nil);
    end;
  end;
end;

{$IFDEF DELPHI2009}
class function TclTranslator.StringToWideString(const s: AnsiString; codePage: Word): WideString;
{$ELSE}
class function TclTranslator.StringToWideString(const s: string; codePage: Word): WideString;
{$ENDIF}
var
  len: integer;
begin
  if (s = '') then
  begin
    Result := '';
  end else
  begin
    len := MultiByteToWideChar(codePage, MB_PRECOMPOSED, PclChar(@s[1]), -1, nil, 0);
    SetLength(Result, len - 1);
    if (len > 1) then
    begin
      MultiByteToWideChar(CodePage, MB_PRECOMPOSED, PclChar(@s[1]), -1, PWideChar(@Result[1]), len - 1);
    end;
  end;
end;

class function TclTranslator.GetString(ABytes: PclChar; ACount: Integer; const ACharSet: string): string;
{$IFDEF DELPHI2009}
var
  enc: TEncoding;
  cnt: Integer;
  buf: TBytes;
{$ENDIF}
begin
  if (ACount = 0) then
  begin
    Result := '';
    Exit;
  end;

{$IFDEF DELPHI2009}
  try
    enc := GetEncoding(ACharSet);
    try
      cnt := ACount;
      if (ABytes[ACount - 1] = #0) then
      begin
        Dec(cnt);
      end;

      SetLength(buf, cnt);
      if (cnt > 0) then
      begin
        Move(ABytes[0], buf[0], cnt);
      end;

      Result := enc.GetString(buf, 0, cnt);

      if (cnt > 0) and (Result = '') then
      begin
        Result := TEncoding.ASCII.GetString(buf, 0, cnt);
      end;
    finally
      enc.Free();
    end;

    Exit;
  except
    on EEncodingError do;
  end;
{$ENDIF}
  if SameText('utf-8', ACharSet) then
  begin
    Result := GetString_(WideStringToString(TranslateFromUtf8(system.Copy(string(ABytes), 1, ACount)), CP_ACP));
  end else
  begin
    Result := TranslateFrom(ACharSet, system.Copy(string(ABytes), 1, ACount));
  end;
end;

class function TclTranslator.GetStringFromUtf8(const ABytes: TclByteArray): WideString;
var
  len: Integer;
begin
  if (Length(ABytes) = 0) then Exit;

  SetLength(Result, Length(ABytes));

  len := FromUtf8(PclChar(ABytes), Length(ABytes), PWideChar(Result), Length(Result) + 1);

  if (len > 0) then
  begin
    SetLength(Result, len - 1);
  end else
  begin
    Result := '';
  end;
end;

class function TclTranslator.GetString(const ABytes: TclByteArray; const ACharSet: string): string;
begin
  Result := GetString(ABytes, 0, Length(ABytes), ACharSet);
end;

class function TclTranslator.GetString(const ABytes: TclByteArray): string;
begin
  Result := GetString(ABytes, 0, Length(ABytes), '');
end;

class function TclTranslator.GetString(const ABytes: TclByteArray; AIndex, ACount: Integer; const ACharSet: string): string;
begin
  if (ACount > 0) then
  begin
    Result := GetString(PclChar(@ABytes[AIndex]), ACount, ACharSet);
  end else
  begin
    Result := '';
  end;
end;

class function TclTranslator.GetString(const ABytes: TclByteArray; AIndex, ACount: Integer): string;
begin
  Result := GetString(ABytes, AIndex, ACount, '');
end;

class procedure TclTranslator.GetSupportedCharSets(ACharSets: TStrings);
{$IFNDEF DELPHIXE}
var
  i: Integer;
{$ENDIF}
begin
  ACharSets.Clear();
{$IFNDEF DELPHI2009}
  for i := Low(CharSetTables) to High(CharSetTables) do
  begin
    ACharSets.Add(string(CharSetTables[i].Name));
  end;
{$ELSE}
  {$IFNDEF DELPHIXE}
  for i := Low(CharSetCodePages) to High(CharSetCodePages) do
  begin
    ACharSets.Add(string(CharSetCodePages[i].Name));
  end;
  {$ELSE}
  {$ENDIF}
{$ENDIF}
end;

class function TclTranslator.GetUtf8ByteCount(const AText: WideString): Integer;
var
  res: TclByteArray;
begin
  res := GetUtf8Bytes(AText);
  Result := Length(res);
end;

class function TclTranslator.GetUtf8Bytes(const AText: WideString): TclByteArray;
var
  len: Integer;
begin
  SetLength(Result, Length(AText) * 3);
  if (AText = '') then Exit;

  len := ToUtf8(PWideChar(AText), Length(AText), PclChar(Result), Length(Result) + 1);
  if (len > 0) then
  begin
    SetLength(Result, len - 1);
  end else
  begin
    SetLength(Result, 0);
  end;
end;

class function TclTranslator.GetXLATByID(const ATableID: string): TclXLATTable;
var
  i: Integer;
begin
  Result.Name := '';
  for i := Low(CharSetTables) to High(CharSetTables) do
  begin
    if CompareText(string(CharSetTables[i].Name), ATableID) = 0 then
    begin
      Result := CharSetTables[i];
      Break;
    end;
  end;
end;

class function TclTranslator.IsUtf8(AStream: TStream): Boolean;
var
  oldPos: Int64;
  buf: TclByteArray;
  len: Integer;
begin
  Result := False;

  oldPos := AStream.Position;
  try
    len := AStream.Size - AStream.Position;
    SetLength(buf, len);

    if (len > 0) then
    begin
      AStream.Read(buf[0], len);
      Result := IsUtf8(buf);
    end;
  finally
    AStream.Position := oldPos;
  end;
end;

class function TclTranslator.IsUtf8(const ABytes: TclByteArray): Boolean;
begin
  Result := IsUtf8(ABytes, 0, Length(ABytes));
end;

class function TclTranslator.IsUtf8(const ABytes: TclByteArray; AIndex, ACount: Integer): Boolean;
var
  c: Byte;
  ind, cnt: Integer;
begin
  Result := False;

  cnt := ACount;
  if (cnt + AIndex > Length(ABytes)) then
  begin
    cnt := Length(ABytes) - AIndex;
  end;

  ind := 0;
  while (ind < cnt) do
  begin
    if ABytes[AIndex + ind] >= $80 then Break;
    Inc(ind);
  end;

  if (ind = cnt) then Exit;

  while (ind < cnt) do
  begin
    c := ABytes[AIndex + ind];
    case c of
      $00..$7F:
        Inc(ind);
      $C2..$DF:
        if (ind + 1 < cnt)
          and ((ABytes[AIndex + ind + 1]) in [$80..$BF]) then
        begin
          Inc(ind, 2);
        end else
        begin
          Break;
        end;
      $E0:
        if (ind + 2 < cnt)
          and (ABytes[AIndex + ind + 1] in [$A0..$BF])
          and (ABytes[AIndex + ind + 2] in [$80..$BF]) then
        begin
          Inc(ind, 3);
        end else
        begin
          Break;
        end;
      $E1..$EF:
        if (ind + 2 < cnt)
          and (ABytes[AIndex + ind + 1] in [$80..$BF])
          and (ABytes[AIndex + ind + 2] in [$80..$BF]) then
        begin
          Inc(ind, 3);
        end else
        begin
          Break;
        end;
      $F0:
        if (ind + 3 < cnt)
          and (ABytes[AIndex + ind + 1] in [$90..$BF])
          and (ABytes[AIndex + ind + 2] in [$80..$BF])
          and (ABytes[AIndex + ind + 3] in [$80..$BF]) then
        begin
          Inc(ind, 4);
        end else
        begin
          Break;
        end;
      $F1..$F3:
        if (ind + 3 < cnt)
          and (ABytes[AIndex + ind + 1] in [$80..$BF])
          and (ABytes[AIndex + ind + 2] in [$80..$BF])
          and (ABytes[AIndex + ind + 3] in [$80..$BF]) then
        begin
          Inc(ind, 4);
        end else
        begin
          Break;
        end;
      $F4:
        if (ind + 3 < cnt)
          and (ABytes[AIndex + ind + 1] in [$80..$8F])
          and (ABytes[AIndex + ind + 2] in [$80..$BF])
          and (ABytes[AIndex + ind + 3] in [$80..$BF]) then
        begin
          Inc(ind, 4);
        end else
        begin
          Break;
        end;
    else
      Break;
    end;
  end;

  Result := (ind = cnt);
end;

class procedure TclTranslator.TranslateTo(const ACharSet: string;
  ASource, ADestination: TStream);
var
  i: Integer;
  Xlat: TclXLATTable;
  Ch: Byte;
  PrevSourcePos, PrevDestPos: Integer;
begin
  Xlat := GetXLATByID(ACharSet);
  PrevSourcePos := ASource.Position;
  PrevDestPos := ADestination.Position;
  ASource.Position := 0;
  ADestination.Position := 0;
  if (Xlat.Name <> '') then
  begin
    for i := 0 to ASource.Size - 1 do
    begin
      ASource.Read(Ch, 1);
      Ch := Xlat.ReverseTable[Ch];
      ADestination.Write(Ch, 1);
    end;
  end else
  begin
    ADestination.CopyFrom(ASource, ASource.Size);
  end;
  ASource.Position := PrevSourcePos;
  ADestination.Position := PrevDestPos;
end;

class procedure TclTranslator.TranslateFrom(const ACharSet: string;
  ASource, ADestination: TStream);
var
  i: Integer;
  Xlat: TclXLATTable;
  Ch: Byte;
  PrevSourcePos, PrevDestPos: Integer;
begin
  Xlat := GetXLATByID(ACharSet);
  PrevSourcePos := ASource.Position;
  PrevDestPos := ADestination.Position;
  ASource.Position := 0;
  ADestination.Position := 0;
  if (Xlat.Name <> '') then
  begin
    for i := 0 to ASource.Size - 1 do
    begin
      ASource.Read(Ch, 1);
      Ch := Xlat.Table[Ch];
      ADestination.Write(Ch, 1);
    end;
  end else
  begin
    ADestination.CopyFrom(ASource, ASource.Size);
  end;
  ASource.Position := PrevSourcePos;
  ADestination.Position := PrevDestPos;
end;

class function TclTranslator.TranslateTo(const ACharSet, ASource: string): string;
var
  src, dst: TStringStream;
begin
  src := nil;
  dst := nil;
  try
    src := TStringStream.Create(ASource);
    dst := TStringStream.Create('');
    TranslateTo(ACharSet, src, dst);
    Result := dst.DataString;
  finally
    dst.Free();
    src.Free();
  end;
end;

class function TclTranslator.TranslateFrom(const ACharSet, ASource: string): string;
var
  src, dst: TStringStream;
begin
  src := nil;
  dst := nil;
  try
    src := TStringStream.Create(ASource);
    dst := TStringStream.Create('');
    TranslateFrom(ACharSet, src, dst);
    Result := dst.DataString;
  finally
    dst.Free();
    src.Free();
  end;
end;

class function TclTranslator.ToUtf8(Source: PWideChar; SourceLength: Integer;
  Dest: PclChar; DestLength: Integer): Integer;
var
  i, count: Integer;
  c: Cardinal;
begin
  count := 0;
  i := 0;
  while (i < SourceLength) and (count < DestLength) do
  begin
    c := Cardinal(Source[i]);
    Inc(i);
    if c <= $7F then
    begin
      Dest[count] := TclChar(c);
      Inc(count);
    end else
    if c > $7FF then
    begin
      if count + 3 > DestLength then Break;
      Dest[count] := TclChar($E0 or (c shr 12));
      Dest[count+1] := TclChar($80 or ((c shr 6) and $3F));
      Dest[count+2] := TclChar($80 or (c and $3F));
      Inc(count,3);
    end else
    begin
      if count + 2 > DestLength then Break;
      Dest[count] := TclChar($C0 or (c shr 6));
      Dest[count + 1] := TclChar($80 or (c and $3F));
      Inc(count, 2);
    end;
  end;
  if count >= DestLength then
  begin
    count := DestLength - 1;
  end;
  Dest[count] := #0;
  Result := count + 1;
end;

class function TclTranslator.FromUtf8(Source: PclChar;
  SourceLength: Integer; Dest: PWideChar; DestLength: Integer): Integer;
var
  i, count: Integer;
  c: Byte;
  wc: Cardinal;
begin
  Result := -1;
  count := 0;
  i := 0;
  while (i < SourceLength) and (count < DestLength) do
  begin
    wc := Cardinal(Source[i]);
    Inc(i);
    if (wc and $80) <> 0 then
    begin
      wc := wc and $3F;
      if i > SourceLength then Exit;
      if (wc and $20) <> 0 then
      begin
        c := Byte(Source[i]);
        Inc(i);
        if (c and $C0) <> $80 then
        begin
          if (c = $20) then
          begin
            Dest[count] := #32;
          end else
          begin
            Dest[count] := #128;
          end;
          Inc(count);
          continue;
        end;
        if i > SourceLength then Exit;
        wc := (wc shl 6) or (c and $3F);
      end;
      c := Byte(Source[i]);
      Inc(i);
      if (c and $C0) <> $80 then
      begin
        if (c = $20) then
        begin
          Dest[count] := #32;
        end else
        begin
          Dest[count] := #128;
        end;
        Inc(count);
        continue;
      end;

      Dest[count] := WideChar((wc shl 6) or (c and $3F));
    end else
    begin
      Dest[count] := WideChar(wc);
    end;
    Inc(count);
  end;
  if count >= DestLength then
  begin
    count := DestLength - 1;
  end;
  Dest[count] := #0;
  Result := count + 1;
end;

class function TclTranslator.TranslateFromUtf8(const ASource: string): WideString;
var
  len: Integer;
  ws: WideString;
  s: TclString;
begin
  Result := '';
  if (ASource = '') then Exit;

  s := GetTclString(ASource);
  SetLength(ws, Length(s));

  len := FromUtf8(PclChar(s), Length(s), PWideChar(ws), Length(ws) + 1);

  if (len > 0) then
  begin
    SetLength(ws, len - 1);
  end else
  begin
    ws := '';
  end;
  Result := ws;
end;

class function TclTranslator.TranslateToUtf8(const ASource: WideString): string;
var
  len: Integer;
  s: TclString;
begin
  Result := '';
  if (ASource = '') then Exit;

  SetLength(s, Length(ASource) * 3);

  len := ToUtf8(PWideChar(ASource), Length(ASource), PclChar(s), Length(s) + 1);
  if (len > 0) then
  begin
    SetLength(s, len - 1);
  end else
  begin
    s := '';
  end;
  Result := string(s);
end;

end.
