{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

{
  Converted from org.apache.xml.security.c14n;
}

{*
 * Copyright  1999-2008 The Apache Software Foundation.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *}

{
Author

Christian Geuer-Pollmann geuer-pollmann@nue.et-inf.uni-siegen.de
University of Siegen
Institute for Data Communications Systems
}

unit clXmlCanonicalizerUtils;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Windows, Variants, msxml{$IFDEF DELPHI2009}, WideStrings{$ENDIF},
{$ELSE}
  System.Classes, System.SysUtils, Winapi.Windows, System.Variants, Winapi.msxml, System.WideStrings,
{$ENDIF}
  clUtils;

type
  EclXmlCanonicalizeError = class(Exception)
  private
    FErrorCode: Integer;
  public
    constructor Create(const AErrorMsg: string; AErrorCode: Integer; ADummy: Boolean = False);
    property ErrorCode: Integer read FErrorCode;
  end;

{**
 * A stack based Symble Table.
 * For speed reasons all the symbols are introduced in the same map,
 * and at the same time in a list so it can be removed when the frame is pop back.
 * @author Raul Benito
 **}
  TclNameSpaceSymbEntry = class(TPersistent)
  private
    FRendered: Boolean;
    FUri: WideString;
    FAttr: IXMLDOMAttribute;
    FPrefix: WideString;
    FLevel: Integer;
    FLastRendered: WideString;
  public
    constructor Create; overload;
    constructor Create(const AUri: WideString; const Attr: IXMLDOMAttribute;
      ARendered: Boolean; const APrefix: WideString); overload;

    procedure Assign(Source: TPersistent); override;

    property Uri: WideString read FUri;
    property Attr: IXMLDOMAttribute read FAttr;
    property Prefix: WideString read FPrefix;

    property Rendered: Boolean read FRendered write FRendered;
    property Level: Integer read FLevel write FLevel;
    property LastRendered: WideString read FLastRendered write FLastRendered;
  end;

  TclSymbMap = class(TPersistent)
  private
    FEntries: TWideStringList;

    function GetCount: Integer;
    function GetItem(Index: Integer): TclNameSpaceSymbEntry;
    procedure Clear;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;

    procedure Put(const AKey: WideString; AValue: TclNameSpaceSymbEntry);
    function Get(const AKey: WideString): TclNameSpaceSymbEntry;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TclNameSpaceSymbEntry read GetItem; default;
  end;

  TclNameSpaceSymbTable = class
  private
    FNameSpaces: Integer;
    FLevel: TList;
    FSymb: TclSymbMap;
    FCloned: Boolean;

    procedure SetSymb(ASymb: TclSymbMap);
    procedure ClearLevel;
    procedure NeedsClone;
    procedure HandleParent(const AElement: IXMLDOMElement);
  public
    constructor Create;
    destructor Destroy; override;

    procedure GetParentNameSpaces(const AElement: IXMLDOMElement);
    function GetMappingWithoutRendered(const APrefix: WideString): IXMLDOMAttribute;
    function AddMappingAndRender(const APrefix, AUri: WideString; const Attr: IXMLDOMAttribute): IXMLDOMNode;
    function AddMapping(const APrefix, AUri: WideString; const Attr: IXMLDOMAttribute): Boolean;
    function GetMapping(const APrefix: WideString): IXMLDOMAttribute;
    procedure OutputNodePush;
    procedure OutputNodePop;
    procedure Push;
    procedure Pop;
  end;

  TclCanonicalizerUtfHelper = class
  public
    class procedure WriteCharToUtf8(C: WideChar; AOutput: TStream);
    class procedure WriteStringToUtf8(const AStr: WideString; AOutput: TStream);
  end;

  TclInclusiveNamespaces = class
  public
    class procedure PrefixStr2Set(const AInclusiveNamespaces: WideString; AInclusiveNSSet: TWideStringList);
  end;

{**
 * Temporary swapped static functions from the normalizer Section
 *
 * @author Christian Geuer-Pollmann
 *}
  TclC14nHelper = class
  public
    class function NamespaceIsRelative(const ANamespaceValue: WideString): Boolean;
    class function NamespaceIsAbsolute(const ANamespaceValue: WideString): Boolean;
  end;

{**
 * Compares two attributes based on the C14n specification.
 *
 *  Namespace nodes have a lesser document order position than attribute
 *   nodes.
 *  An element's namespace nodes are sorted lexicographically by
 *   local name (the default namespace node, if one exists, has no
 *   local name and is therefore lexicographically least).
 *  An element's attribute nodes are sorted lexicographically with
 *   namespace URI as the primary key and local name as the secondary
 *   key (an empty namespace URI is lexicographically least).
 *
 * @author Christian Geuer-Pollmann
 *}
  TclAttrCompare = class
  public
    function Compare(Obj0, Obj1: IInterface): Integer;
  end;

const
  ALGO_ID_C14N_OMIT_COMMENTS = 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315';
  ALGO_ID_C14N_WITH_COMMENTS = 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315#WithComments';
  ALGO_ID_C14N_EXCL_OMIT_COMMENTS = 'http://www.w3.org/2001/10/xml-exc-c14n#';
  ALGO_ID_C14N_EXCL_WITH_COMMENTS = 'http://www.w3.org/2001/10/xml-exc-c14n#WithComments';
  ALGO_ID_C14N11_OMIT_COMMENTS = 'http://www.w3.org/2006/12/xml-c14n11';
  ALGO_ID_C14N11_WITH_COMMENTS = 'http://www.w3.org/2006/12/xml-c14n11#WithComments';

resourcestring
  XmlC14nBadNodeType = 'Illegal node type during traversal';
  XmlC14nRelativeNamespace = 'Relative namespace found';

const
  XmlC14nBadNodeTypeCode = -10;
  XmlC14nRelativeNamespaceCode = -11;

implementation

uses
  clTranslator, clXmlUtils;

{ TclNameSpaceSymbTable }

function TclNameSpaceSymbTable.AddMapping(const APrefix, AUri: WideString; const Attr: IXMLDOMAttribute): Boolean;
var
  ob, ne: TclNameSpaceSymbEntry;
begin
  ob := FSymb.Get(APrefix);
  if (ob <> nil) and (AUri = ob.Uri) then
  begin
    Result := False;
    Exit;
  end;

  ne := TclNameSpaceSymbEntry.Create(AUri, Attr, False, APrefix);
  if (ob <> nil) then
  begin
    ne.LastRendered := ob.LastRendered;
    if (ob.LastRendered = AUri) then
    begin
      ne.Rendered := True;
    end;
  end;

  NeedsClone();
  FSymb.Put(APrefix, ne);

  Result := True;
end;

function TclNameSpaceSymbTable.AddMappingAndRender(const APrefix, AUri: WideString;
  const Attr: IXMLDOMAttribute): IXMLDOMNode;
var
  ob, newOb, ne: TclNameSpaceSymbEntry;
begin
  ob := FSymb.Get(APrefix);

  if ((ob <> nil) and (AUri = ob.Uri)) then
  begin
    if (not ob.Rendered) then
    begin
      newOb := TclNameSpaceSymbEntry.Create();
      newOb.Assign(ob);
      NeedsClone();
      FSymb.Put(APrefix, newOb);

      newOb.LastRendered := AUri;
      newOb.Rendered := True;
      
      Result := newOb.Attr;
    end else
    begin
      Result := nil;
    end;
  end else
  begin
    ne := TclNameSpaceSymbEntry.Create(AUri, Attr, True, APrefix);
    ne.LastRendered := AUri;
    if (ob <> nil) and (ob.LastRendered = AUri) then
    begin
      ne.Rendered := True;
      Result := nil;
    end else
    begin
      Result := ne.Attr;
    end;

    NeedsClone();
    FSymb.Put(APrefix, ne);
  end;
end;

procedure TclNameSpaceSymbTable.ClearLevel;
var
  i: Integer;
begin
  for i := 0 to FLevel.Count - 1 do
  begin
    TObject(FLevel[i]).Free();
  end;
  FLevel.Clear();
end;

constructor TclNameSpaceSymbTable.Create;
var
  ne: TclNameSpaceSymbEntry;
begin
  inherited Create();

  FLevel := TList.Create();

  FSymb := TclSymbMap.Create();
  FNameSpaces := 0;
  FCloned := True;

  ne := TclNameSpaceSymbEntry.Create('', nil, True, cXMLNS);
  FSymb.Put(cXMLNS, ne);
end;

destructor TclNameSpaceSymbTable.Destroy;
begin
  SetSymb(nil);

  ClearLevel();
  FLevel.Free();

  inherited Destroy();
end;

function TclNameSpaceSymbTable.GetMapping(const APrefix: WideString): IXMLDOMAttribute;
var
  entry, newEntry: TclNameSpaceSymbEntry;
begin
  entry := FSymb.Get(APrefix);
  if (entry = nil) then
  begin
    Result := nil;
    Exit;
  end;

  if (entry.Rendered) then
  begin
    Result := nil;
    Exit;
  end;

  newEntry := TclNameSpaceSymbEntry.Create();
  newEntry.Assign(entry);
  NeedsClone();
  FSymb.Put(APrefix, newEntry);
  newEntry.Rendered := True;
  newEntry.Level := FNameSpaces;
  newEntry.LastRendered := newEntry.Uri;

  Result := newEntry.Attr;
end;

function TclNameSpaceSymbTable.GetMappingWithoutRendered(const APrefix: WideString): IXMLDOMAttribute;
var
  entry: TclNameSpaceSymbEntry;
begin
  entry := FSymb.Get(APrefix);
  if (entry = nil) then
  begin
    Result := nil;
  end else
  if (entry.Rendered) then
  begin
    Result := nil;
  end else
  begin
    Result := entry.Attr;
  end;
end;

procedure TclNameSpaceSymbTable.GetParentNameSpaces(const AElement: IXMLDOMElement);
var
  i: Integer;
  parents: TInterfaceList;
  parent, ele: IXMLDOMElement;
  nsprefix: IXMLDOMAttribute;
begin
  parents := TInterfaceList.Create();
  try
    if (AElement.parentNode = nil) or (AElement.parentNode.nodeType <> NODE_ELEMENT) then Exit;

    parent := AElement.parentNode as IXMLDOMElement;
    while (parent <> nil) do
    begin
      parents.Add(parent);
      if (parent.parentNode = nil) or (parent.parentNode.nodeType <> NODE_ELEMENT) then Break;
      parent := parent.parentNode as IXMLDOMElement;
    end;


    for i := parents.Count - 1 downto 0 do
    begin
      ele := parents[i] as IXMLDOMElement;
      HandleParent(ele);
    end;

    nsprefix := GetMappingWithoutRendered(cXMLNS);
    if (nsprefix <> nil) and (nsprefix.value = '') then
    begin
      AddMappingAndRender(cXMLNS, '', nil{TODO nullNode});
    end;
  finally
    parents.Free();
  end;
end;

procedure TclNameSpaceSymbTable.HandleParent(const AElement: IXMLDOMElement);
var
  i: Integer;
  N: IXMLDOMAttribute;
  NName, NValue: WideString;
begin
  for i := 0 to AElement.attributes.length - 1 do
  begin
    N := AElement.attributes.item[i] as IXMLDOMAttribute;
    if (cXMLNS_URI <> GetNamespaceURI(N)) then
    begin
      Continue;
    end;
    NName := GetAttributeLocalName(N);
    NValue := VarToWideStr(N.value);

    if (cXML = NName) and (cXML_LANG_URI = NValue) then
    begin
      Continue;
    end;
    AddMapping(NName, NValue, N);
  end;
end;

procedure TclNameSpaceSymbTable.NeedsClone;
var
  newSymb: TclSymbMap;
begin
  if (not FCloned) then
  begin
    newSymb := TclSymbMap.Create();
    FLevel[FLevel.Count - 1] := newSymb;
    newSymb.Assign(FSymb);
    FCloned := True;
  end;
end;

procedure TclNameSpaceSymbTable.OutputNodePop;
begin
  Dec(FNameSpaces);
  Pop();
end;

procedure TclNameSpaceSymbTable.OutputNodePush;
begin
  Inc(FNameSpaces);
  Push();
end;

procedure TclNameSpaceSymbTable.Pop;
var
  size: Integer;
  ob: TclSymbMap;
begin
  size := FLevel.Count - 1;

  ob := TclSymbMap(FLevel[size]);
  FLevel.Delete(size);
  if (ob <> nil) then
  begin
    SetSymb(ob);
    if (size = 0) then
    begin
      FCloned := False;
    end else
    begin
      FCloned := (FLevel[size - 1] <> FSymb); //TODO possible bug, comparing of pointers, Delphi implementation has always different pointers - only nulls are equal
    end;
  end else
  begin
    FCloned := False;
  end;
end;

procedure TclNameSpaceSymbTable.Push;
begin
  FLevel.Add(nil);
  FCloned := False;
end;

procedure TclNameSpaceSymbTable.SetSymb(ASymb: TclSymbMap);
begin
  FSymb.Free();
  FSymb := ASymb;
end;

{ TclCanonicalizerUtfHelper }

class procedure TclCanonicalizerUtfHelper.WriteCharToUtf8(C: WideChar; AOutput: TStream);
begin
  WriteStringToUtf8(C, AOutput);
end;

class procedure TclCanonicalizerUtfHelper.WriteStringToUtf8(const AStr: WideString; AOutput: TStream);
var
  buf: TclByteArray;
begin
  buf := TclTranslator.GetUtf8Bytes(AStr);
  if (Length(buf) > 0) then
  begin
    AOutput.Write(buf[0], Length(buf));
  end;
end;

{ TclInclusiveNamespaces }

class procedure TclInclusiveNamespaces.PrefixStr2Set(const AInclusiveNamespaces: WideString; AInclusiveNSSet: TWideStringList);
var
  i: Integer;
begin
  if (AInclusiveNamespaces = '') then Exit;

  SplitText(AInclusiveNamespaces, AInclusiveNSSet, [#9, #13, #10]);

  for i := 0 to AInclusiveNSSet.Count - 1 do
  begin
    if ('#default' = AInclusiveNSSet[i]) then
    begin
      AInclusiveNSSet[i] := cXMLNS;
    end;
  end;
end;

{ TclC14nHelper }

class function TclC14nHelper.NamespaceIsRelative(const ANamespaceValue: WideString): Boolean;
begin
  Result := not NamespaceIsAbsolute(ANamespaceValue);
end;

class function TclC14nHelper.NamespaceIsAbsolute(const ANamespaceValue: WideString): Boolean;
begin
  if (ANamespaceValue = '') then
  begin
    Result := True;
  end else
  begin
    Result := (system.Pos(':', ANamespaceValue) > 1);
  end;
end;

{ TclSymbMap }

procedure TclSymbMap.Assign(Source: TPersistent);
var
  i: Integer;
  src: TclSymbMap;
  ent: TclNameSpaceSymbEntry;
begin
  if (Source is TclSymbMap) then
  begin
    src := TclSymbMap(Source);

    FEntries.Clear();    
    for i := 0 to src.FEntries.Count - 1 do
    begin
      ent := TclNameSpaceSymbEntry.Create();
      FEntries.AddObject(src.FEntries[i], ent);
      ent.Assign(TclNameSpaceSymbEntry(src.FEntries.Objects[i]));
    end;
  end else
  begin
    inherited Assign(Source);
  end;
end;

procedure TclSymbMap.Clear;
var
  i: Integer;
begin
  for i := 0 to FEntries.Count - 1 do
  begin
    GetItem(i).Free();
  end;
  FEntries.Clear();
end;

constructor TclSymbMap.Create;
begin
  inherited Create();

  FEntries := TWideStringList.Create();
end;

destructor TclSymbMap.Destroy;
begin
  Clear();
  FEntries.Free();

  inherited Destroy();
end;

function TclSymbMap.Get(const AKey: WideString): TclNameSpaceSymbEntry;
var
  ind: Integer;
begin
  ind := FEntries.IndexOf(AKey);
  if (ind < 0) then
  begin
    Result := nil;
  end else
  begin
    Result := GetItem(ind);
  end;
end;

function TclSymbMap.GetCount: Integer;
begin
  Result := FEntries.Count;
end;

function TclSymbMap.GetItem(Index: Integer): TclNameSpaceSymbEntry;
begin
  Result := TclNameSpaceSymbEntry(FEntries.Objects[Index]);
end;

procedure TclSymbMap.Put(const AKey: WideString; AValue: TclNameSpaceSymbEntry);
var
  ind: Integer;
begin
  ind := FEntries.IndexOf(AKey);
  if (ind < 0) then
  begin
    FEntries.AddObject(AKey, AValue);
  end else
  begin
    FEntries.Objects[ind].Free();
    FEntries.Objects[ind] := AValue;
  end;
end;

{ TclNameSpaceSymbEntry }

procedure TclNameSpaceSymbEntry.Assign(Source: TPersistent);
var
  src: TclNameSpaceSymbEntry;
begin
  if (Source is TclNameSpaceSymbEntry) then
  begin
    src := TclNameSpaceSymbEntry(Source);

    FUri := src.Uri;
    FAttr := src.Attr;
    FRendered := src.Rendered;
    FPrefix := src.Prefix;

    FLevel := src.Level;
    FLastRendered := src.LastRendered;
  end else
  begin
    inherited Assign(Source);
  end;
end;

constructor TclNameSpaceSymbEntry.Create(const AUri: WideString; const Attr: IXMLDOMAttribute;
  ARendered: Boolean; const APrefix: WideString);
begin
  inherited Create();

  FUri := AUri;
  FAttr := Attr;
  FRendered := ARendered;
  FPrefix := APrefix;

  FLevel := 0;
  FLastRendered := '';
end;

constructor TclNameSpaceSymbEntry.Create;
begin
  inherited Create();
end;

{ TclAttrCompare }

function TclAttrCompare.Compare(Obj0, Obj1: IInterface): Integer;
const
  ATTR0_BEFORE_ATTR1 = -1;
  ATTR1_BEFORE_ATTR0 = 1;

var
  attr0, attr1: IXMLDOMAttribute;
  namespaceURI0, namespaceURI1,
  localname0, localname1,
  name0, name1: WideString;
  isNamespaceAttr0, isNamespaceAttr1: Boolean;
  a: Integer;
begin
  attr0 := Obj0 as IXMLDOMAttribute;
  attr1 := Obj1 as IXMLDOMAttribute;

  namespaceURI0 := GetNamespaceURI(attr0);
  namespaceURI1 := GetNamespaceURI(attr1);

  isNamespaceAttr0 := (cXMLNS_URI = namespaceURI0);
  isNamespaceAttr1 := (cXMLNS_URI = namespaceURI1);

  if (isNamespaceAttr0) then
  begin
    if (isNamespaceAttr1) then
    begin
      localname0 := GetAttributeLocalName(attr0);
      localname1 := GetAttributeLocalName(attr1);

      if (cXMLNS = localname0) then
      begin
        localname0 := '';
      end;

      if (cXMLNS = localname1) then
      begin
        localname1 := '';
      end;

      Result := WideCompareText(localname0, localname1);
      Exit;
    end;

    Result := ATTR0_BEFORE_ATTR1;
    Exit;
  end;

  if (isNamespaceAttr1) then
  begin
    Result := ATTR1_BEFORE_ATTR0;
    Exit;
  end;

  if (namespaceURI0 = '') then
  begin
    if (namespaceURI1 = '') then
    begin
      name0 := attr0.name;
      name1 := attr1.name;

      Result := WideCompareText(name0, name1);
      Exit;
    end;

    Result := ATTR0_BEFORE_ATTR1;
    Exit;
  end;

  if (namespaceURI1 = '') then
  begin
    Result := ATTR1_BEFORE_ATTR0;
    Exit;
  end;

  a := WideCompareText(namespaceURI0, namespaceURI1);
  if (a <> 0) then
  begin
    Result := a;
    Exit;
  end;

  Result := WideCompareText(GetAttributeLocalName(attr0), GetAttributeLocalName(attr1));
end;

{ EclXmlCanonicalizeError }

constructor EclXmlCanonicalizeError.Create(const AErrorMsg: string; AErrorCode: Integer; ADummy: Boolean);
begin
  inherited Create(AErrorMsg);
  FErrorCode := AErrorCode;
end;

end.
