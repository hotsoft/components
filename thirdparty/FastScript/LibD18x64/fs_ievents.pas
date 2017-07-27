
{******************************************}
{                                          }
{             FastScript v1.9              }
{             Standard events              }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_ievents;

interface

{$i fs.inc}

uses SysUtils, Classes, fs_iinterpreter
{$IFDEF CLX}
, QControls, QForms
{$ELSE}
, Controls, Forms
{$ENDIF};

type
  TfsNotifyEvent = class(TfsCustomEvent)
  public
    procedure DoEvent(Sender: TObject);
    function GetMethod: Pointer; override;
  end;

  TfsMouseEvent = class(TfsCustomEvent)
  public
    procedure DoEvent(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    function GetMethod: Pointer; override;
  end;

  TfsMouseMoveEvent = class(TfsCustomEvent)
  public
    procedure DoEvent(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    function GetMethod: Pointer; override;
  end;

  TfsKeyEvent = class(TfsCustomEvent)
  public
    procedure DoEvent(Sender: TObject; var Key: Word; Shift: TShiftState);
    function GetMethod: Pointer; override;
  end;

  TfsKeyPressEvent = class(TfsCustomEvent)
  public
    procedure DoEvent(Sender: TObject; var Key: Char);
    function GetMethod: Pointer; override;
  end;

  TfsCloseEvent = class(TfsCustomEvent)
  public
    procedure DoEvent(Sender: TObject; var Action: TCloseAction);
    function GetMethod: Pointer; override;
  end;

  TfsCloseQueryEvent = class(TfsCustomEvent)
  public
    procedure DoEvent(Sender: TObject; var CanClose: Boolean);
    function GetMethod: Pointer; override;
  end;

  TfsCanResizeEvent = class(TfsCustomEvent)
  public
    procedure DoEvent(Sender: TObject; var NewWidth, NewHeight: Integer;
      var Resize: Boolean);
    function GetMethod: Pointer; override;
  end;


implementation


type
  TByteSet = set of 0..7;
  PByteSet = ^TByteSet;


{ TfsNotifyEvent }

procedure TfsNotifyEvent.DoEvent(Sender: TObject);
begin
  CallHandler([Sender]);
end;

function TfsNotifyEvent.GetMethod: Pointer;
begin
  Result := @TfsNotifyEvent.DoEvent;
end;

{ TfsMouseEvent }

procedure TfsMouseEvent.DoEvent(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
{$IFNDEF FPC}
  b: Byte;
{$ELSE}
  i: integer;
{$ENDIF}
begin
{$IFNDEF FPC}
  b := Byte(PByteSet(@Shift)^);
  CallHandler([Sender, Integer(Button), b, X, Y]);
{$ELSE}
  i := Integer(PByteSet(@Shift)^);
  CallHandler([Sender, Integer(Button), i, X, Y]);
{$ENDIF}
end;

function TfsMouseEvent.GetMethod: Pointer;
begin
  Result := @TfsMouseEvent.DoEvent;
end;

{ TfsMouseMoveEvent }

procedure TfsMouseMoveEvent.DoEvent(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
{$IFNDEF FPC}
  b: Byte;
{$ELSE}
  i: integer;
{$ENDIF}
begin
{$IFNDEF FPC}
  b := Byte(PByteSet(@Shift)^);
  CallHandler([Sender, b, X, Y]);
{$ELSE}
  i := Integer(PByteSet(@Shift)^);
  CallHandler([Sender, i, X, Y]);
{$ENDIF}
end;

function TfsMouseMoveEvent.GetMethod: Pointer;
begin
  Result := @TfsMouseMoveEvent.DoEvent;
end;

{ TfsKeyEvent }

procedure TfsKeyEvent.DoEvent(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
{$IFNDEF FPC}
  b: Byte;
{$ELSE}
  i: integer;
{$ENDIF}
begin
{$IFNDEF FPC}
  b := Byte(PByteSet(@Shift)^);
  CallHandler([Sender, Key, b]);
{$ELSE}
  i := Integer(PByteSet(@Shift)^);
  CallHandler([Sender, Key, i]);
{$ENDIF}
  Key := Handler.Params[1].Value;
end;

function TfsKeyEvent.GetMethod: Pointer;
begin
  Result := @TfsKeyEvent.DoEvent;
end;

{ TfsKeyPressEvent }

procedure TfsKeyPressEvent.DoEvent(Sender: TObject; var Key: Char);
begin
  CallHandler([Sender, Key]);
  Key := String(Handler.Params[1].Value)[1];
end;

function TfsKeyPressEvent.GetMethod: Pointer;
begin
  Result := @TfsKeyPressEvent.DoEvent;
end;

{ TfsCloseEvent }

procedure TfsCloseEvent.DoEvent(Sender: TObject; var Action: TCloseAction);
begin
  CallHandler([Sender, Integer(Action)]);
  Action := Handler.Params[1].Value;
end;

function TfsCloseEvent.GetMethod: Pointer;
begin
  Result := @TfsCloseEvent.DoEvent;
end;

{ TfsCloseQueryEvent }

procedure TfsCloseQueryEvent.DoEvent(Sender: TObject; var CanClose: Boolean);
begin
  CallHandler([Sender, CanClose]);
  CanClose := Handler.Params[1].Value;
end;

function TfsCloseQueryEvent.GetMethod: Pointer;
begin
  Result := @TfsCloseQueryEvent.DoEvent;
end;

{ TfsCanResizeEvent }

procedure TfsCanResizeEvent.DoEvent(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  CallHandler([Sender, NewWidth, NewHeight, Resize]);
  NewWidth := Handler.Params[1].Value;
  NewHeight := Handler.Params[2].Value;
  Resize := Handler.Params[3].Value;
end;

function TfsCanResizeEvent.GetMethod: Pointer;
begin
  Result := @TfsCanResizeEvent.DoEvent;
end;

end.
