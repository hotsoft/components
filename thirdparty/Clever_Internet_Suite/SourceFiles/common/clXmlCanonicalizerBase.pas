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

unit clXmlCanonicalizerBase;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Variants, msxml,
{$ELSE}
  System.Classes, System.SysUtils, System.Variants, Winapi.msxml,
{$ENDIF}
  clXmlCanonicalizerUtils, clUtils;

type
{**
 * Base class which all Caninicalization algorithms extend.
 *
 * $todo$ cange JavaDoc
 * @author Christian Geuer-Pollmann
 *}
  TclCanonicalizerSpi = class
  public
    function EngineGetURI: WideString; virtual; abstract;
    function EngineGetIncludeComments: Boolean; virtual; abstract;

    function EngineCanonicalizeSubTree(const ARootNode: IXMLDOMNode): TclByteArray; overload; virtual; abstract;
    function EngineCanonicalizeSubTree(const ARootNode: IXMLDOMNode; const AInclusiveNamespaces: WideString): TclByteArray; overload; virtual; abstract;
  end;

{**
 *
 * @author Christian Geuer-Pollmann
 *}
  TclCanonicalizerBase = class(TclCanonicalizerSpi)
  private
    FIncludeComments: Boolean;
    FExcludeNode: IXMLDOMNode;
    FWriter: TStream;
  protected
    function EngineCanonicalizeSubTree(const ARootNode: IXMLDOMNode; const AExcludeNode: IXMLDOMNode): TclByteArray; overload;
    procedure CanonicalizeSubTree(const ACurrentNode: IXMLDOMNode; ANamespace: TclNameSpaceSymbTable; const AEndnode: IXMLDOMNode; ADocumentLevel: Integer);
    function IsVisibleInt(const ACurrentNode: IXMLDOMNode): Integer;

    function HandleAttributesSubtree(const AElement: IXMLDOMElement; ANamespace: TclNameSpaceSymbTable): IInterfaceList; virtual; abstract;

    class procedure OutputCommentToWriter(const ACurrentComment: IXMLDOMComment; AWriter: TStream; APosition: Integer);
    class procedure OutputPItoWriter(const ACurrentPI: IXMLDOMProcessingInstruction; AWriter: TStream; APosition: Integer);
    class procedure OutputTextToWriter(const AText: WideString; AWriter: TStream);
    class procedure OutputAttrToWriter(const AName, AValue: WideString; AWriter: TStream);
  public
    constructor Create(AIncludeComments: Boolean);
    destructor Destroy; override;
  end;

implementation

uses
  clWUtils, clXmlUtils;

const
  _END_PI: array[0..1] of TclChar = ('?','>');
  _BEGIN_PI: array[0..1] of TclChar = ('<','?');
  _END_COMM: array[0..2] of TclChar = ('-','-','>');
  _BEGIN_COMM: array[0..3] of TclChar = ('<','!','-','-');
  __XA_: array[0..4] of TclChar = ('&','#','x','A',';');
  __X9_: array[0..4] of TclChar = ('&','#','x','9',';');
  _QUOT_: array[0..5] of TclChar = ('&','q','u','o','t',';');
  __XD_: array[0..4] of TclChar = ('&','#','x','D',';');
  _GT_: array[0..3] of TclChar = ('&','g','t',';');
  _LT_: array[0..3] of TclChar = ('&','l','t',';');
  _END_TAG: array[0..1] of TclChar = ('<','/');
  _AMP_: array[0..4] of TclChar = ('&','a','m','p',';');

  EQUALS_STR: array[0..1] of TclChar = ('=','"');

  NODE_BEFORE_DOCUMENT_ELEMENT = -1;
  NODE_NOT_BEFORE_OR_AFTER_DOCUMENT_ELEMENT = 0;
  NODE_AFTER_DOCUMENT_ELEMENT = 1;

{ TclCanonicalizerBase }

procedure TclCanonicalizerBase.CanonicalizeSubTree(const ACurrentNode: IXMLDOMNode; ANamespace: TclNameSpaceSymbTable;
  const AEndnode: IXMLDOMNode; ADocumentLevel: Integer);
var
  sibling, parentNode, currentNode: IXMLDOMNode;
  documentLevel, i: Integer;
  currentElement: IXMLDOMElement;
  symbol: TclChar;
  name: WideString;
  attrs: IInterfaceList;
  attr: IXMLDOMAttribute;
begin
  if (IsVisibleInt(ACurrentNode) = -1) then Exit;

  documentLevel := ADocumentLevel;
  currentNode := ACurrentNode;

  repeat
    case (currentNode.nodeType) of
      NODE_DOCUMENT_TYPE: ;

      NODE_ENTITY: raise EclXmlCanonicalizeError.Create(XmlC14nBadNodeType, XmlC14nBadNodeTypeCode);

      NODE_NOTATION: raise EclXmlCanonicalizeError.Create(XmlC14nBadNodeType, XmlC14nBadNodeTypeCode);

      NODE_ATTRIBUTE: raise EclXmlCanonicalizeError.Create(XmlC14nBadNodeType, XmlC14nBadNodeTypeCode);

      NODE_DOCUMENT_FRAGMENT:
      begin
        ANamespace.OutputNodePush();
        sibling := currentNode.firstChild;
      end;

      NODE_DOCUMENT:
      begin
        ANamespace.OutputNodePush();
        sibling := currentNode.firstChild;
      end;

      NODE_COMMENT:
      begin
        if (FIncludeComments) then
        begin
          OutputCommentToWriter(currentNode as IXMLDOMComment, FWriter, documentLevel);
        end;
      end;

      NODE_PROCESSING_INSTRUCTION:
      begin
        OutputPItoWriter(currentNode as IXMLDOMProcessingInstruction, FWriter, documentLevel);
      end;

      NODE_TEXT:
      begin
        OutputTextToWriter(VarToWideStr(currentNode.nodeValue), FWriter);
      end;

      NODE_CDATA_SECTION:
      begin
        OutputTextToWriter(VarToWideStr(currentNode.nodeValue), FWriter);
      end;

      NODE_ENTITY_REFERENCE:
      begin
        OutputTextToWriter(VarToWideStr(currentNode.text), FWriter);
      end;

      NODE_ELEMENT:
      begin
        documentLevel := NODE_NOT_BEFORE_OR_AFTER_DOCUMENT_ELEMENT;
        if (currentNode <> FExcludeNode) then
        begin
          currentElement := currentNode as IXMLDOMElement;
          ANamespace.OutputNodePush();
          symbol := '<'; 
          FWriter.Write(symbol, 1);

          name := currentElement.tagName;
          TclCanonicalizerUtfHelper.WriteStringToUtf8(name, FWriter);

          attrs := HandleAttributesSubtree(currentElement, ANamespace);
          for i := 0 to attrs.Count - 1 do
          begin
            attr := attrs[i] as IXMLDOMAttribute;
            OutputAttrToWriter(attr.nodeName, attr.nodeValue, FWriter);
          end;
            
          symbol := '>'; 
          FWriter.Write(symbol, 1);

          sibling := currentNode.firstChild;
          if (sibling = nil) then
          begin
            FWriter.Write(_END_TAG[0], Length(_END_TAG));

            TclCanonicalizerUtfHelper.WriteStringToUtf8(name, FWriter);

            symbol := '>';
            FWriter.Write(symbol, 1);

            ANamespace.OutputNodePop();
            if (parentNode <> nil) then
            begin
              sibling := currentNode.nextSibling;
            end;
          end else
          begin
            parentNode := currentElement;
          end;
        end;
      end;
    end;
    while (sibling = nil) and (parentNode <> nil) do
    begin
      FWriter.Write(_END_TAG[0], Length(_END_TAG));

      TclCanonicalizerUtfHelper.WriteStringToUtf8((parentNode as IXMLDOMElement).tagName, FWriter);

      symbol := '>';
      FWriter.Write(symbol, 1);

      ANamespace.OutputNodePop();
      if SameNodes(parentNode, AEndnode) then Exit;

      sibling := parentNode.nextSibling;
      parentNode := parentNode.parentNode;
      if (parentNode = nil) or (NODE_ELEMENT <> parentNode.nodeType) then
      begin
        documentLevel := NODE_AFTER_DOCUMENT_ELEMENT;
        parentNode := nil;
      end;
    end;

    if (sibling = nil) then Exit;

    currentNode := sibling;
    sibling := currentNode.nextSibling;
  until False;
end;

constructor TclCanonicalizerBase.Create(AIncludeComments: Boolean);
begin
  inherited Create();

  FWriter := TMemoryStream.Create();
  FIncludeComments := AIncludeComments;
end;

destructor TclCanonicalizerBase.Destroy;
begin
  FWriter.Free();
  
  inherited Destroy();
end;

function TclCanonicalizerBase.EngineCanonicalizeSubTree(const ARootNode: IXMLDOMNode; const AExcludeNode: IXMLDOMNode): TclByteArray;
var
  nodeLevel, len: Integer;
  ns: TclNameSpaceSymbTable;
begin
  FExcludeNode := AExcludeNode;
  ns := TclNameSpaceSymbTable.Create();
  try
    nodeLevel := NODE_BEFORE_DOCUMENT_ELEMENT;

    if (ARootNode <> nil) and (NODE_ELEMENT = ARootNode.nodeType) then
    begin
      ns.GetParentNameSpaces(ARootNode as IXMLDOMElement);
      nodeLevel := NODE_NOT_BEFORE_OR_AFTER_DOCUMENT_ELEMENT;
    end;

    CanonicalizeSubTree(ARootNode, ns, ARootNode, nodeLevel);

    FWriter.Position := 0;
    len := FWriter.Size;
    SetLength(Result, len);
    if (len > 0) then
    begin
      len := FWriter.Read(Result[0], len);
      SetLength(Result, len);
    end;
  finally
    ns.Free();
  end;
end;

function TclCanonicalizerBase.IsVisibleInt(const ACurrentNode: IXMLDOMNode): Integer;
begin
  Result := 1;
end;

class procedure TclCanonicalizerBase.OutputAttrToWriter(const AName, AValue: WideString; AWriter: TStream);
var
  symbol: TclChar;
  i, len: Integer;
  c: WideChar;
begin
  symbol := #32;
  AWriter.Write(symbol, 1);

  TclCanonicalizerUtfHelper.WriteStringToUtf8(AName, AWriter);

  AWriter.Write(EQUALS_STR[0], Length(EQUALS_STR));
  len := Length(AValue);

  i := 0;
  while (i < len) do
  begin
    c := AValue[i + 1];
    Inc(i);

    case (c) of
      '&': AWriter.Write(_AMP_[0], Length(_AMP_));
      '<': AWriter.Write(_LT_[0], Length(_LT_));
      '"': AWriter.Write(_QUOT_[0], Length(_QUOT_));
      #9: AWriter.Write(__X9_[0], Length(__X9_));
      #10: AWriter.Write(__XA_[0], Length(__XA_));
      #13: AWriter.Write(__XD_[0], Length(__XD_));
    else
      begin
        if (Word(c) < $80) then
        begin
          symbol := TclChar(c);
          AWriter.Write(symbol, 1);
        end else
        begin
          TclCanonicalizerUtfHelper.WriteCharToUtf8(c, AWriter);
        end;
      end;
    end;
  end;

  symbol := '"';
  AWriter.Write(symbol, 1);
end;

class procedure TclCanonicalizerBase.OutputCommentToWriter(const ACurrentComment: IXMLDOMComment;
  AWriter: TStream; APosition: Integer);
var
  symbol: TclChar;
  data: WideString;
  i, len: Integer;
  c: WideChar;
begin
  if (APosition = NODE_AFTER_DOCUMENT_ELEMENT) then
  begin
    symbol := #10;
    AWriter.Write(symbol, 1);
  end;
  AWriter.Write(_BEGIN_COMM[0], Length(_BEGIN_COMM));

  data := ACurrentComment.data;
  len := Length(data);

  for i := 1 to len do
  begin
    c := data[i];
    if (c = #13) then
    begin
      AWriter.Write(__XD_[0], Length(__XD_));
    end else
    if (Word(c) < $80) then
    begin
      symbol := TclChar(c);
      AWriter.Write(symbol, 1);
    end else
    begin
      TclCanonicalizerUtfHelper.WriteCharToUtf8(c, AWriter);
    end;
  end;

  AWriter.Write(_END_COMM[0], Length(_END_COMM));
  if (APosition = NODE_BEFORE_DOCUMENT_ELEMENT) then
  begin
    symbol := #10;
    AWriter.Write(symbol, 1);
  end;
end;

class procedure TclCanonicalizerBase.OutputPItoWriter(const ACurrentPI: IXMLDOMProcessingInstruction;
  AWriter: TStream; APosition: Integer);
var
  symbol: TclChar;
  target, data: WideString;
  i, len: Integer;
  c: WideChar;
begin
  if (APosition = NODE_AFTER_DOCUMENT_ELEMENT) then
  begin
    symbol := #10;
    AWriter.Write(symbol, 1);
  end;
  AWriter.Write(_BEGIN_PI[0], Length(_BEGIN_PI));

  target := ACurrentPI.target;
  len := Length(target);

  for i := 1 to len do
  begin
    c := target[i];
    if (c = #13) then
    begin
      AWriter.Write(__XD_[0], Length(__XD_));
    end else
    if (Word(c) < $80) then
    begin
      symbol := TclChar(c);
      AWriter.Write(symbol, 1);
    end else
    begin
      TclCanonicalizerUtfHelper.WriteCharToUtf8(c, AWriter);
    end;
  end;

  data := ACurrentPI.data;
  len := Length(data);

  if (len > 0) then
  begin
    symbol := #32;
    AWriter.Write(symbol, 1);

    for i := 1 to len do
    begin
      c := data[i];
      if (c = #13) then
      begin
        AWriter.Write(__XD_[0], Length(__XD_));
      end else
      begin
        TclCanonicalizerUtfHelper.WriteCharToUtf8(c, AWriter);
      end;
    end;
  end;

  AWriter.write(_END_PI[0], Length(_END_PI));
  if (APosition = NODE_BEFORE_DOCUMENT_ELEMENT) then
  begin
    symbol := #10;
    AWriter.Write(symbol, 1);
  end;
end;

class procedure TclCanonicalizerBase.OutputTextToWriter(const AText: WideString; AWriter: TStream);
var
  symbol: TclChar;
  i, len: Integer;
  c: WideChar;
begin
  len := Length(AText);

  for i := 1 to len do
  begin
    c := AText[i];

    case (c) of
      '&': AWriter.Write(_AMP_[0], Length(_AMP_));
      '<': AWriter.Write(_LT_[0], Length(_LT_));
      '>': AWriter.Write(_GT_[0], Length(_GT_));
      #13: AWriter.Write(__XD_[0], Length(__XD_));
    else
      begin
        if (Word(c) < $80) then
        begin
          symbol := TclChar(c);
          AWriter.Write(symbol, 1);
        end else
        begin
          TclCanonicalizerUtfHelper.WriteCharToUtf8(c, AWriter);
        end;
      end;
    end;
  end;
end;

end.
