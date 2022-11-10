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

unit clXmlCanonicalizer20010315Excl;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Variants, msxml{$IFDEF DELPHI2009}, WideStrings{$ENDIF},
{$ELSE}
  System.Classes, System.SysUtils, System.Variants, Winapi.msxml, System.WideStrings,
{$ENDIF}
  clUtils, clXmlCanonicalizerBase, clXmlCanonicalizerUtils;

type

{**
 * Implements http://www.w3.org/TR/2002/REC-xml-exc-c14n-20020718
 * Exclusive XML Canonicalization, Version 1.0
 * Credits: During restructuring of the Canonicalizer framework, Ren??
 * Kollmorgen from Software AG submitted an implementation of ExclC14n which
 * fitted into the old architecture and which based heavily on my old (and slow)
 * implementation of "Canonical XML". A big "thank you" to Ren?? for this.
 * THIS implementation is a complete rewrite of the algorithm.
 *
 * @author Christian Geuer-Pollmann <geuerp@apache.org>
 * @version $Revision: 1023243 $
 * @see href="http://www.w3.org/TR/2002/REC-xml-exc-c14n-20020718/Exclusive#"
 *          XML Canonicalization, Version 1.0
 *}
  TclCanonicalizer20010315Excl = class(TclCanonicalizerBase)
  private
    FInclusiveNSSet: TWideStringList;
    FCompare: TclAttrCompare;
  protected
    function EngineCanonicalizeSubTree(const ARootNode: IXMLDOMNode; const AInclusiveNamespaces: WideString;
      const AExcludeNode: IXMLDOMNode): TclByteArray; overload;

    function HandleAttributesSubtree(const AElement: IXMLDOMElement; ANamespace: TclNameSpaceSymbTable): IInterfaceList; override;
  public
    constructor Create(AIncludeComments: Boolean);
    destructor Destroy; override;

    function EngineCanonicalizeSubTree(const ARootNode: IXMLDOMNode): TclByteArray; overload; override;
    function EngineCanonicalizeSubTree(const ARootNode: IXMLDOMNode; const AInclusiveNamespaces: WideString): TclByteArray; overload; override;
  end;

  TclCanonicalizer20010315ExclOmitComments = class(TclCanonicalizer20010315Excl)
  public
    constructor Create();

    function EngineGetIncludeComments: Boolean; override;
    function EngineGetURI: WideString; override;
  end;

{**
 * Class Canonicalizer20010315ExclWithComments
 *
 * @version $Revision: 351115 $
 *}
  TclCanonicalizer20010315ExclWithComments = class(TclCanonicalizer20010315Excl)
  public
    constructor Create;

    function EngineGetIncludeComments: Boolean; override;
    function EngineGetURI: WideString; override;
  end;

implementation

uses
  clXmlUtils;

{ TclCanonicalizer20010315ExclOmitComments }

constructor TclCanonicalizer20010315ExclOmitComments.Create;
begin
  inherited Create(False);
end;

function TclCanonicalizer20010315ExclOmitComments.EngineGetURI: WideString;
begin
  Result := ALGO_ID_C14N_EXCL_OMIT_COMMENTS;
end;

function TclCanonicalizer20010315ExclOmitComments.EngineGetIncludeComments: Boolean;
begin
  Result := False;
end;

{ TclCanonicalizer20010315ExclWithComments }

constructor TclCanonicalizer20010315ExclWithComments.Create;
begin
  inherited Create(True);
end;

function TclCanonicalizer20010315ExclWithComments.EngineGetIncludeComments: Boolean;
begin
  Result := True;
end;

function TclCanonicalizer20010315ExclWithComments.EngineGetURI: WideString;
begin
  Result := ALGO_ID_C14N_EXCL_WITH_COMMENTS;
end;

{ TclCanonicalizer20010315Excl }

function TclCanonicalizer20010315Excl.EngineCanonicalizeSubTree(const ARootNode: IXMLDOMNode): TclByteArray;
begin
  Result := EngineCanonicalizeSubTree(ARootNode, '', nil);
end;

constructor TclCanonicalizer20010315Excl.Create(AIncludeComments: Boolean);
begin
  inherited Create(AIncludeComments);
  
  FInclusiveNSSet := TWideStringList.Create();
  FCompare := TclAttrCompare.Create();
end;

destructor TclCanonicalizer20010315Excl.Destroy;
begin
  FCompare.Free();
  FInclusiveNSSet.Free();

  inherited Destroy();
end;

function TclCanonicalizer20010315Excl.EngineCanonicalizeSubTree(const ARootNode: IXMLDOMNode;
  const AInclusiveNamespaces: WideString): TclByteArray;
begin
  Result := EngineCanonicalizeSubTree(ARootNode, AInclusiveNamespaces, nil);
end;

function TclCanonicalizer20010315Excl.HandleAttributesSubtree(const AElement: IXMLDOMElement;
  ANamespace: TclNameSpaceSymbTable): IInterfaceList;
var
  attrs: IXMLDOMNamedNodeMap;
  attrsLength, i: Integer;
  visiblyUtilized: TWideStringList;
  N: IXMLDOMAttribute;
  prefix, NName, NNodeValue: WideString;
  key: IXMLDOMAttribute;
begin
  Result := TInterfaceList.Create();

  attrs := AElement.attributes;
  attrsLength := attrs.length;

  visiblyUtilized := TWideStringList.Create();
  try
    visiblyUtilized.Assign(FInclusiveNSSet);

    for i := 0 to attrsLength - 1 do
    begin
      N := attrs.item[i] as IXMLDOMAttribute;

      if (cXMLNS_URI <> GetNamespaceURI(N)) then
      begin
        prefix := N.prefix;
        if ((prefix <> '') and (cXML <> prefix) and (cXMLNS <> prefix)) then
        begin
          visiblyUtilized.Add(prefix);
        end;
        Result.Add(N);
        Continue;
      end;

      NName := GetAttributeLocalName(N);
      NNodeValue := N.value;
      if ((cXML = NName) and (cXML_LANG_URI = NNodeValue)) then
      begin
        Continue;
      end;

      if (ANamespace.AddMapping(NName, NNodeValue, N)) then
      begin
        if (TclC14nHelper.NamespaceIsRelative(NNodeValue)) then
        begin
          raise EclXmlCanonicalizeError.Create(XmlC14nRelativeNamespace, XmlC14nRelativeNamespaceCode);
        end;
      end;
    end;

    if (AElement.namespaceURI <> '') then//TODO works only when loading Dom, and does not work when adding elements
    begin
      prefix := AElement.prefix;
      if (prefix = '') then
      begin
        prefix := cXMLNS;
      end;
    end else
    begin
      prefix := cXMLNS;
    end;
    visiblyUtilized.Add(prefix);

    for i := 0 to visiblyUtilized.Count - 1 do
    begin
      key := ANamespace.GetMapping(visiblyUtilized[i]);
      if (key <> nil) then
      begin
        Result.Add(key);
      end;
    end;
  finally
    visiblyUtilized.Free();
  end;

  TclInterfaceListHelper.Sort(Result, FCompare.Compare);
end;

function TclCanonicalizer20010315Excl.EngineCanonicalizeSubTree(const ARootNode: IXMLDOMNode;
  const AInclusiveNamespaces: WideString; const AExcludeNode: IXMLDOMNode): TclByteArray;
begin
  TclInclusiveNamespaces.PrefixStr2Set(AInclusiveNamespaces, FInclusiveNSSet);
  Result := EngineCanonicalizeSubTree(ARootNode, AExcludeNode);
end;

end.
