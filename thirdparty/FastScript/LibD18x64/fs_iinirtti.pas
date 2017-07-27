
{******************************************}
{                                          }
{             FastScript v1.9              }
{    IniFiles.pas classes and functions    }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{        Copyright (c) 2004-2007           }
{          by Stalker SoftWare             }
{                                          }
{******************************************}

unit fs_iinirtti;

interface

{$i fs.inc}

uses
  SysUtils, Classes, fs_iinterpreter, IniFiles;

type
  TfsIniRTTI = class(TComponent); // fake component


implementation

type
  TFunctions = class(TfsRTTIModule)
  private
    function CallMethod(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
    function GetProp(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
    procedure SaveIniFileToStream(oIniFile: TCustomIniFile; oStream: TStream);
    procedure LoadIniFileFromStream(oIniFile :TCustomIniFile; oStream :TStream);
    procedure WriteTStrings(oIniFile: TCustomIniFile; const Section: String; Values: TStrings; IsClear :Boolean = True);
    procedure ReadTStrings(oIniFile: TCustomIniFile; const Section: String; Values: TStrings; IsClear :Boolean = True);
  public
    constructor Create(AScript: TfsScript); override;
  end;


{ TFunctions }

constructor TFunctions.Create(AScript: TfsScript);
begin
  inherited Create(AScript);

  with AScript do
  begin
    with AddClass(TCustomIniFile, 'TObject') do
    begin
      AddConstructor('constructor Create(const FileName: String)', CallMethod);
      AddMethod('function ReadInteger(const Section, Ident: String; Default: LongInt): LongInt', CallMethod);
      AddMethod('procedure WriteInteger(const Section, Ident: String; Value: LongInt)', CallMethod);
      AddMethod('function ReadBool(const Section, Ident: String; Default: Boolean): Boolean', CallMethod);
      AddMethod('procedure WriteBool(const Section, Ident: String; Value: Boolean)', CallMethod);
      AddMethod('function ReadDate(const Section, Name: String; Default: TDateTime): TDateTime', CallMethod);
      AddMethod('procedure WriteDate(const Section, Name: String; Value: TDateTime)', CallMethod);
      AddMethod('function ReadDateTime(const Section, Name: String; Default: TDateTime): TDateTime', CallMethod);
      AddMethod('procedure WriteDateTime(const Section, Name: String; Value: TDateTime)', CallMethod);
      AddMethod('function ReadFloat(const Section, Name: String; Default: Double): Double', CallMethod);
      AddMethod('procedure WriteFloat(const Section, Name: String; Value: Double)', CallMethod);
      AddMethod('function ReadTime(const Section, Name: String; Default: TDateTime): TDateTime', CallMethod);
      AddMethod('procedure WriteTime(const Section, Name: String; Value: TDateTime);', CallMethod);
{$IFDEF DELPHI6}
      AddMethod('function ReadBinaryStream(const Section, Name: String; Value: TStream): Integer', CallMethod);
      AddMethod('procedure WriteBinaryStream(const Section, Name: String; Value: TStream)', CallMethod);
{$ENDIF}
      AddMethod('function SectionExists(const Section: String): Boolean', CallMethod);
      AddMethod('function ValueExists(const Section, Ident: String): Boolean', CallMethod);

      AddMethod('procedure WriteTStrings(const Section :String; Value :TStrings; IsClear :Boolean = True)', CallMethod);
      AddMethod('function ReadTStrings(const Section :String; Value :TStrings; IsClear :Boolean = True): String;', CallMethod);

      AddProperty('FileName', 'String', GetProp);
    end;

    with AddClass(TMemIniFile, 'TCustomIniFile') do
    begin
      AddConstructor('constructor Create(const FileName: String)', CallMethod);
      AddMethod('procedure WriteString(const Section, Ident, Value: String)', CallMethod);
      AddMethod('function ReadString(const Section, Ident, Default: String): String;', CallMethod);
{$IFDEF DELPHI6}
      AddMethod('procedure ReadSectionValuesEx(const Section: String; Strings: TStrings)', CallMethod);
{$ENDIF}
      AddMethod('procedure DeleteKey(const Section, Ident: String)', CallMethod);
      AddMethod('procedure ReadSection(const Section: String; Strings: TStrings)', CallMethod);
      AddMethod('procedure ReadSections(Strings: TStrings)', CallMethod);
      AddMethod('procedure ReadSectionValues(const Section: String; Strings: TStrings)', CallMethod);
      AddMethod('procedure EraseSection(const Section: String)', CallMethod);
      AddMethod('procedure Clear', CallMethod);
      AddMethod('procedure GetStrings(List: TStrings)', CallMethod);
      AddMethod('procedure SetStrings(List: TStrings)', CallMethod);
      AddMethod('procedure SaveIniFileToStream(oStream: TStream)', CallMethod);
      AddMethod('procedure LoadIniFileFromStream(oStream: TStream)', CallMethod);
    end;

    with AddClass(TIniFile, 'TCustomIniFile') do
    begin
      AddMethod('procedure WriteString(const Section, Ident, Value: String)', CallMethod);
      AddMethod('function ReadString(const Section, Ident, Default: String): String;', CallMethod);
{$IFDEF DELPHI6}
      AddMethod('procedure ReadSectionValuesEx(const Section: String; Strings: TStrings)', CallMethod);
{$ENDIF}
      AddMethod('procedure DeleteKey(const Section, Ident: String)', CallMethod);
      AddMethod('procedure ReadSection(const Section: String; Strings: TStrings)', CallMethod);
      AddMethod('procedure ReadSections(Strings: TStrings)', CallMethod);
      AddMethod('procedure ReadSectionValues(const Section: String; Strings: TStrings)', CallMethod);
      AddMethod('procedure EraseSection(const Section: String)', CallMethod);
      AddMethod('procedure SaveIniFileToStream(oStream: TStream)', CallMethod);
      AddMethod('procedure LoadIniFileFromStream(oStream: TStream)', CallMethod);
    end;

  end;

end;

{$HINTS OFF}
function TFunctions.CallMethod(Instance: TObject; ClassType: TClass; const MethodName: String; Caller: TfsMethodHelper): Variant;
var
  oCustomIniFile: TCustomIniFile;
  oMemIniFile:    TMemIniFile;
  oIniFile:       TIniFile;
  oList:          TStrings;
  nCou:           Integer;

begin

  Result := 0;

  if ClassType = TCustomIniFile then
  begin
    oCustomIniFile := TCustomIniFile(Instance);
    if MethodName = 'CREATE' then
      Result := Integer(oCustomIniFile.Create(Caller.Params[0]))
    else if MethodName = 'WRITEINTEGER' then
      oCustomIniFile.WriteInteger(Caller.Params[0], Caller.Params[1], Caller.Params[2])
    else if MethodName = 'READINTEGER' then
      Result := oCustomIniFile.ReadInteger(Caller.Params[0], Caller.Params[1], Caller.Params[2])
    else if MethodName = 'WRITEBOOL' then
      oCustomIniFile.WriteBool(Caller.Params[0], Caller.Params[1], Caller.Params[2])
    else if MethodName = 'READBOOL' then
      Result := oCustomIniFile.ReadBool(Caller.Params[0], Caller.Params[1], Caller.Params[2])
    else if MethodName = 'WRITEDATE' then
      oCustomIniFile.WriteDate(Caller.Params[0], Caller.Params[1], Caller.Params[2])
    else if MethodName = 'READDATE' then
      Result := oCustomIniFile.ReadDate(Caller.Params[0], Caller.Params[1], Caller.Params[2])
    else if MethodName = 'WRITEDATETIME' then
      oCustomIniFile.WriteDateTime(Caller.Params[0], Caller.Params[1], Caller.Params[2])
    else if MethodName = 'READDATETIME' then
      Result := oCustomIniFile.ReadDateTime(Caller.Params[0], Caller.Params[1], Caller.Params[2])
    else if MethodName = 'WRITEFLOAT' then
      oCustomIniFile.WriteFloat(Caller.Params[0], Caller.Params[1], Caller.Params[2])
    else if MethodName = 'READFLOAT' then
      Result := oCustomIniFile.ReadFloat(Caller.Params[0], Caller.Params[1], Caller.Params[2])
    else if MethodName = 'WRITETIME' then
      oCustomIniFile.WriteTime(Caller.Params[0], Caller.Params[1], Caller.Params[2])
    else if MethodName = 'READTIME' then
      Result := oCustomIniFile.ReadTime(Caller.Params[0], Caller.Params[1], Caller.Params[2])
{$IFDEF DELPHI6}
    else if MethodName = 'WRITEBINARYSTREAM' then
      oCustomIniFile.WriteBinaryStream(Caller.Params[0], Caller.Params[1], TStream(Integer(Caller.Params[2])))
    else if MethodName = 'READBINARYSTREAM' then
      Result := oCustomIniFile.ReadBinaryStream(Caller.Params[0], Caller.Params[1], TStream(Integer(Caller.Params[2])))
{$ENDIF}
    else if MethodName = 'SECTIONEXISTS' then
      Result := oCustomIniFile.SectionExists(Caller.Params[0])
    else if MethodName = 'VALUEEXISTS' then
      Result := oCustomIniFile.ValueExists(Caller.Params[0], Caller.Params[1])
    else if MethodName = 'WRITETSTRINGS' then
      WriteTStrings(oCustomIniFile, Caller.Params[0], TStrings(Integer(Caller.Params[1])), Caller.Params[2])
    else if MethodName = 'READTSTRINGS' then
      ReadTStrings(oCustomIniFile, Caller.Params[0], TStrings(Integer(Caller.Params[1])), Caller.Params[2])

  end;

  if ClassType = TMemIniFile then
  begin
    oMemIniFile := TMemIniFile(Instance);
    if MethodName = 'CREATE' then
      Result := Integer(oMemIniFile.Create(Caller.Params[0]))
    else if MethodName = 'WRITESTRING' then
      oMemIniFile.WriteString(Caller.Params[0], Caller.Params[1], Caller.Params[2])
    else if MethodName = 'READSTRING' then
      Result := oMemIniFile.ReadString(Caller.Params[0], Caller.Params[1], Caller.Params[2])
    else if MethodName = 'DELETEKEY' then
      oMemIniFile.DeleteKey(Caller.Params[0], Caller.Params[1])
    else if MethodName = 'READSECTION' then
      oMemIniFile.ReadSection(Caller.Params[0], TStrings(Integer(Caller.Params[1])))
    else if MethodName = 'READSECTIONS' then
      oMemIniFile.ReadSections(TStrings(Integer(Caller.Params[0])))
    else if MethodName = 'READSECTIONVALUES' then
      oMemIniFile.ReadSectionValues(Caller.Params[0], TStrings(Integer(Caller.Params[1])))
    else if MethodName = 'ERASESECTION' then
      oMemIniFile.EraseSection(Caller.Params[0])
{$IFDEF DELPHI6}
    else if MethodName = 'READSECTIONVALUESEX' then
    begin
      oList := TStringList.Create;
      try
        oMemIniFile.ReadSectionValues(Caller.Params[0], oList);
        TStrings(Integer(Caller.Params[1])).Clear;
        for nCou := 0 to oList.Count-1 do
//          TStrings(Integer(Caller.Params[1])).Add(oList.ValueFromIndex[nCou]); 
          TStrings(Integer(Caller.Params[1])).Add(oList.Values[oList.Names[nCou]]);
      finally
        oList.Free;
      end;
    end
{$ENDIF}
    else if MethodName = 'CLEAR' then
      oMemIniFile.Clear
    else if MethodName = 'GETSTRINGS' then
      oMemIniFile.GetStrings(TStrings(Integer(Caller.Params[0])))
    else if MethodName = 'SETSTRINGS' then
      oMemIniFile.SetStrings(TStrings(Integer(Caller.Params[0])))
    else if MethodName = 'SAVEINIFILETOSTREAM' then
      SaveIniFileToStream(oMemIniFile, TStream(Integer(Caller.Params[0])))
    else if MethodName = 'LOADINIFILEFROMSTREAM' then
      LoadIniFileFromStream(oMemIniFile, TStream(Integer(Caller.Params[0])))
  end;

  if ClassType = TIniFile then
  begin
    oIniFile := TIniFile(Instance);
    if MethodName = 'WRITESTRING' then
      oIniFile.WriteString(Caller.Params[0], Caller.Params[1], Caller.Params[2])
    else if MethodName = 'READSTRING' then
      Result := oIniFile.ReadString(Caller.Params[0], Caller.Params[1], Caller.Params[2])
    else if MethodName = 'DELETEKEY' then
      oIniFile.DeleteKey(Caller.Params[0], Caller.Params[1])
    else if MethodName = 'READSECTION' then
      oIniFile.ReadSection(Caller.Params[0], TStrings(Integer(Caller.Params[1])))
    else if MethodName = 'READSECTIONS' then
      oIniFile.ReadSections(TStrings(Integer(Caller.Params[0])))
    else if MethodName = 'READSECTIONVALUES' then
      oIniFile.ReadSectionValues(Caller.Params[0], TStrings(Integer(Caller.Params[1])))
    else if MethodName = 'ERASESECTION' then
      oIniFile.EraseSection(Caller.Params[0])
{$IFDEF DELPHI6}
    else if MethodName = 'READSECTIONVALUESEX' then
    begin
      oList := TStringList.Create;
      try
        oIniFile.ReadSectionValues(Caller.Params[0], oList);
        TStrings(Integer(Caller.Params[1])).Clear;
        for nCou := 0 to oList.Count-1 do
//          TStrings(Integer(Caller.Params[1])).Add(oList.ValueFromIndex[nCou]);
          TStrings(Integer(Caller.Params[1])).Add(oList.Values[oList.Names[nCou]]);
      finally
        oList.Free;
      end;
    end
{$ENDIF}
    else if MethodName = 'SAVEINIFILETOSTREAM' then
      SaveIniFileToStream(oIniFile, TStream(Integer(Caller.Params[0])))
    else if MethodName = 'LOADINIFILEFROMSTREAM' then
      LoadIniFileFromStream(oIniFile, TStream(Integer(Caller.Params[0])))
  end;

end;
{$HINTS ON}

function TFunctions.GetProp(Instance: TObject; ClassType: TClass; const PropName: String): Variant;
begin
  Result := 0;

  if ClassType = TCustomIniFile then
  begin
    if PropName = 'FILENAME' then
      Result := TIniFile(Instance).FileName
  end;
end;

procedure TFunctions.SaveIniFileToStream(oIniFile :TCustomIniFile; oStream :TStream);
var
  oStrings :TStrings;

begin

  if (not Assigned(oIniFile)) or (not Assigned(oStream)) then Exit;

  if not ((oIniFile is TIniFile) or (oIniFile is TMemIniFile)) then Exit;

  oStrings:= TStringList.Create;
  try

    if oIniFile is TIniFile then
      oStrings.LoadFromFile(oIniFile.FileName)
    else
    if oIniFile is TMemIniFile then
      TMemIniFile(oIniFile).GetStrings(oStrings);

    oStrings.SaveToStream(oStream);

  finally
    oStrings.Free;
  end;

end;

procedure TFunctions.LoadIniFileFromStream(oIniFile :TCustomIniFile; oStream :TStream);
var
  oStrings :TStrings;

begin

  if (not Assigned(oIniFile)) or (not Assigned(oStream)) then Exit;

  if not ((oIniFile is TIniFile) or (oIniFile is TMemIniFile)) then Exit;

  oStrings:= TStringList.Create;
  try

    oStrings.LoadFromStream(oStream);

    if oIniFile is TIniFile then
      oStrings.SaveToFile(oIniFile.FileName)
    else
    if oIniFile is TMemIniFile then
      TMemIniFile(oIniFile).SetStrings(oStrings);

  finally
    oStrings.Free;
  end;

end;

procedure TFunctions.WriteTStrings(oIniFile :TCustomIniFile; const Section :String; Values :TStrings; IsClear :Boolean = True);
var
  nCou :Integer;

begin

 if IsClear then oIniFile.EraseSection(Section);

 for nCou := 0 to Values.Count-1 do
   oIniFile.WriteString(Section, 'Items'+IntToStr(nCou), Values[nCou]);

 oIniFile.WriteInteger(Section, 'Count', Values.Count);

end;

procedure TFunctions.ReadTStrings(oIniFile :TCustomIniFile; const Section :String; Values :TStrings; IsClear :Boolean = True);
var
  nCou, nCount :Integer;

begin

 nCount := oIniFile.ReadInteger(Section, 'Count', 0);

 if IsClear then Values.Clear;

 for nCou := 0 to nCount-1 do
   Values.Add(oIniFile.ReadString(Section, 'Items'+IntToStr(nCou), ''));

end;

initialization
  fsRTTIModules.Add(TFunctions);

finalization
  fsRTTIModules.Remove(TFunctions);

end.
