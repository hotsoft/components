{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clXmlUtils;

interface
//TODO test Widestring-string typecasts
{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Windows, ActiveX, Classes, SysUtils, Variants, msxml,
{$ELSE}
  Winapi.Windows, Winapi.ActiveX, System.Classes, System.SysUtils, System.Variants, Winapi.msxml,
{$ENDIF}
  clUtils;

procedure StringsToXml(AStrings: TStrings; ANode: IXMLDOMNode);
procedure XmlToStrings(AStrings: TStrings; ANode: IXMLDOMNode);

procedure SaveXmlToStrings(AList: TStrings; ADomDoc: IXMLDOMDocument); overload;
procedure SaveXmlToStrings(AList: TStrings; ADomDoc: IXMLDOMDocument; const ACDataNodeNames: array of string); overload;
procedure SaveXmlToFile(const AFileName: string; ADomDoc: IXMLDOMDocument); overload;
procedure SaveXmlToFile(const AFileName: string; ADomDoc: IXMLDOMDocument; const ACDataNodeNames: array of string); overload;
procedure SaveXmlToStream(AStream: TStream; ADomDoc: IXMLDOMDocument); overload;
procedure SaveXmlToStream(AStream: TStream; ADomDoc: IXMLDOMDocument; const ACDataNodeNames: array of string); overload;
procedure LoadXmlFromStream(AStream: TStream; ADomDoc: IXMLDOMDocument);

function GetXmlCharSet(const ADom: IXMLDomDocument): string; overload;
function GetXmlCharSet(const AXml: string): string; overload;
function GetXmlCharSet(const AXml, ADefaultCharSet: string): string; overload;
function GetNamespaceURI(const Attr: IXMLDOMAttribute): WideString;
function GetAttributeLocalName(const Attr: IXMLDOMAttribute): WideString;
function GetAttributeValue(const ANode: IXMLDOMNode; const AName: string): string;
procedure SetAttributeValue(const ANode: IXMLDOMNode; const AName, AValue: string);
function GetAttributeText(const AName, AValue: string): string;

function GetAttributeValueByName(const ANode: IXMLDOMNode; const AName: string): string;

function GetNodeByName(const ARoot: IXMLDomNode; const AName, ANameSpace: string): IXMLDomNode; overload;
function GetNodeByName(const ARoot: IXMLDomNode; const AName: string): IXMLDomNode; overload;
function GetNodeByAttributeName(const ARoot: IXMLDomNode; const AttributeName, AttributeValue: string): IXMLDomNode;

function GetNodeValueByName(const ARoot: IXMLDomNode; const AName, ANameSpace: string): string; overload;
function GetNodeValueByName(const ARoot: IXMLDomNode; const AName: string): string; overload;
function GetNodeXmlByName(const ARoot: IXMLDomNode; const AName, ANameSpace: string): string; overload;
function GetNodeXmlByName(const ARoot: IXMLDomNode; const AName: string): string; overload;

procedure GetNodeValueListByName(const ARoot: IXMLDomNode; const AName, ANameSpace: string; AList: TStrings); overload;
procedure GetNodeValueListByName(const ARoot: IXMLDomNode; const AName: string; AList: TStrings); overload;

function GetNodeText(const ANode: IXMLDomNode): string;
function GetNodeXml(const ANode: IXMLDomNode): string;
procedure SetNodeText(const ANode: IXMLDomNode; const AValue: string);
procedure AddNodeValue(const ARoot: IXMLDomNode; const AName, AValue: string);
procedure RemoveNode(ANode: IXMLDOMNode);

function SameNodes(const ANode1, ANode2: IXMLDomNode): Boolean;

function ReplaceXmlNode(const AXml, ANodeName, ANewXml: string): string;

function XmlCrlfEncode(const ASource: WideString): WideString;
function XmlCrlfDecode(const ASource: WideString): WideString; overload;
function XmlCrlfDecode(const ASource: TclByteArray): TclByteArray; overload;

function UriReference2Id(const AValue: string): string;
function Id2UriReference(const AValue: string): string;

const
  cXMLNS_URI = 'http://www.w3.org/2000/xmlns/';
  cXML_LANG_URI = 'http://www.w3.org/XML/1998/namespace';

  cXMLNS = 'xmlns';
  cXML = 'xml';

implementation

uses
  clTranslator;

const
  CDataXMLFormat = '<xsl:output indent="yes" method="xml" encoding="%s" cdata-section-elements="%s"/>';
  XMLFormat = '<?xml version="1.0" encoding="%s"?>' +
              '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">' +
              '  <xsl:output indent="yes" method="xml" encoding="%s"/> %s ' +
              '    <xsl:template match="/ | @* | node()">' +
              '  <xsl:copy>' +
              '  <xsl:apply-templates select="@* | node()"/>' +
              '    </xsl:copy>' +
              '  </xsl:template>' +
              '</xsl:stylesheet>';

function GetXMLFormat(const ACharSet: string; const ACDataNodeNames: array of string): string;
var
  i: Integer;
  enc: string;
begin
  enc := ACharSet;
  if (enc = '') then
  begin
    enc := 'UTF-8';
  end;
  
  Result := '';
  for i := Low(ACDataNodeNames) to High(ACDataNodeNames) do
  begin
    Result := Result + #32 + Format(CDataXMLFormat, [enc, ACDataNodeNames[i]]);
  end;
  Result := Format(XMLFormat, [enc, enc, Result]);
end;

procedure SaveXmlToFile(const AFileName: string; ADomDoc: IXMLDOMDocument);
begin
  SaveXmlToFile(AFileName, ADomDoc, []);
end;

procedure SaveXmlToFile(const AFileName: string; ADomDoc: IXMLDOMDocument; const ACDataNodeNames: array of string);
var
  b: Boolean;
  TransDoc, ResDoc: IXMLDOMDocument;
begin
  TransDoc := CoDOMDocument.Create();
  ResDoc := CoDOMDocument.Create();
  TransDoc.loadXML(GetXMLFormat(GetXmlCharSet(ADomDoc), ACDataNodeNames));
  try
    ADomDoc.transformNodeToObject(TransDoc, ResDoc);
    b := (ResDoc.xml <> '');
  except
    b := False;
  end;
  if b then
  begin
    ResDoc.save(AFileName);
  end else
  begin
    ADomDoc.save(AFileName);
  end;
end;

procedure SaveXmlToStream(AStream: TStream; ADomDoc: IXMLDOMDocument);
begin
  SaveXmlToStream(AStream, ADomDoc, []);
end;

procedure SaveXmlToStream(AStream: TStream; ADomDoc: IXMLDOMDocument; const ACDataNodeNames: array of string);
var
  b: Boolean;
  TransDoc, ResDoc: IXMLDOMDocument;
  sa: IStream;
begin
  TransDoc := CoDOMDocument.Create();
  ResDoc := CoDOMDocument.Create();
  TransDoc.loadXML(GetXMLFormat(GetXmlCharSet(ADomDoc), ACDataNodeNames));
  try
    ADomDoc.transformNodeToObject(TransDoc, ResDoc);
    b := (ResDoc.xml <> '');
  except
    b := False;
  end;

  sa := TStreamAdapter.Create(AStream, soReference);
  if b then
  begin
    ResDoc.save(sa);
  end else
  begin
    ADomDoc.save(sa);
  end;
end;

procedure LoadXmlFromStream(AStream: TStream; ADomDoc: IXMLDOMDocument);
var
  sa: IStream;
begin
  sa := TStreamAdapter.Create(AStream, soReference);
  ADomDoc.load(sa);
end;

procedure SaveXmlToStrings(AList: TStrings; ADomDoc: IXMLDOMDocument);
begin
  SaveXmlToStrings(AList, ADomDoc, []);
end;

procedure SaveXmlToStrings(AList: TStrings; ADomDoc: IXMLDOMDocument; const ACDataNodeNames: array of string);
var
  b: Boolean;
  TransDoc, ResDoc: IXMLDOMDocument;
begin
  TransDoc := CoDOMDocument.Create();
  ResDoc := CoDOMDocument.Create();
  TransDoc.loadXML(GetXMLFormat(GetXmlCharSet(ADomDoc), ACDataNodeNames));
  try
    ADomDoc.transformNodeToObject(TransDoc, ResDoc);
    b := (ResDoc.xml <> '');
  except
    b := False;
  end;
  if b then
  begin
    AList.Text := string(ResDoc.xml);
  end else
  begin
    AList.Text := string(ADomDoc.xml);
  end;
end;

procedure StringsToXml(AStrings: TStrings; ANode: IXMLDOMNode);
var
  ChildNode: IXMLDOMNode;
begin
  ChildNode := ANode.ownerDocument.createCDATASection(AStrings.Text);
  ANode.appendChild(ChildNode);
end;

procedure XmlToStrings(AStrings: TStrings; ANode: IXMLDOMNode);
begin
  AStrings.Text := ANode.text;
end;

function GetXmlCharSet(const ADom: IXMLDomDocument): string;
var
  pi: IXMLDOMProcessingInstruction;
  attr: IXMLDOMNode;
begin
  Result := '';

  if (ADom.hasChildNodes) then
  begin
    if (ADom.firstChild.QueryInterface(IID_IXMLDOMProcessingInstruction, pi) = S_OK) then
    begin
      attr := pi.attributes.getNamedItem('encoding');
      if (attr <> nil) then
      begin
        Result := VarToStr(attr.nodeValue);
      end;
    end;
  end;
end;

function GetXmlCharSet(const AXml: string): string;
var
  doc: IXMLDomDocument;
begin
  doc := CoDOMDocument.Create();
  doc.loadXML(WideString(AXml));

  Result := GetXmlCharSet(doc);
end;

function GetXmlCharSet(const AXml, ADefaultCharSet: string): string;
begin
  Result := GetXmlCharSet(AXml);
  if (Trim(Result) = '') then
  begin
    Result := ADefaultCharSet;
  end;
end;

function GetNamespaceURI(const Attr: IXMLDOMAttribute): WideString;
begin
  if (Attr.prefix = cXMLNS) then
  begin
    Result := cXMLNS_URI;
  end else
  begin
    Result := Attr.namespaceURI;
  end;
end;

function GetAttributeLocalName(const Attr: IXMLDOMAttribute): WideString;
begin
  if (Attr.name = cXMLNS) then
  begin
    Result := cXMLNS;
  end else
  begin
    Result := Attr.baseName;
  end;
end;

function GetAttributeValueByName(const ANode: IXMLDOMNode; const AName: string): string;
var
  i: Integer;
  att: IXMLDOMAttribute;
  element: IXMLDOMElement;
begin
  Result := '';
  if (ANode = nil) then Exit;

  element := (ANode as IXMLDOMElement);
  for i := 0 to element.attributes.length - 1 do
  begin
    att := (element.attributes.item[i] as IXMLDOMAttribute);
    if (att.baseName = AName) then
    begin
      Result := Trim(string(att.value));
      Exit;
    end;
  end;
end;

function GetAttributeValue(const ANode: IXMLDOMNode; const AName: string): string;
begin
  Result := VarToStr((ANode as IXMLDOMElement).getAttribute(WideString(AName)));
end;

function GetAttributeText(const AName, AValue: string): string;
begin
  Result := Trim(AValue);
  if (Result = '') then Exit;
  Result := AName + '="' + Result + '"';
end;

procedure SetAttributeValue(const ANode: IXMLDOMNode; const AName, AValue: string);
begin
  if (AValue <> '') then
  begin
    (ANode as IXMLDOMElement).setAttribute(WideString(AName), AValue);
  end else
  begin
    (ANode as IXMLDOMElement).removeAttribute(WideString(AName));
  end;
end;

function GetNodeByName(const ARoot: IXMLDomNode; const AName, ANameSpace: string): IXMLDomNode;
var
  list: IXMLDomNodeList;
begin
  list := ARoot.childNodes;
  Result := list.nextNode;
  while (Result <> nil) do
  begin
    if (Result.baseName = AName) and (Result.namespaceURI = ANameSpace) then Exit;
    Result := list.nextNode;
  end;
  Result := nil;
end;

function GetNodeByName(const ARoot: IXMLDomNode; const AName: string): IXMLDomNode; overload;
var
  list: IXMLDomNodeList;
begin
  if (ARoot = nil) then
  begin
    Result := nil;
    Exit;
  end;

  list := ARoot.childNodes;
  Result := list.nextNode;
  while (Result <> nil) do
  begin
    if (Result.baseName = AName) then Exit;
    Result := list.nextNode;
  end;
  Result := nil;
end;

function GetNodeByAttributeName(const ARoot: IXMLDomNode; const AttributeName, AttributeValue: string): IXMLDomNode;
var
  list: IXMLDomNodeList;
begin
  if (ARoot = nil) then
  begin
    Result := nil;
    Exit;
  end;

  list := ARoot.childNodes;
  Result := list.nextNode;
  while (Result <> nil) do
  begin
    if (GetAttributeValueByName(Result, AttributeName) = AttributeValue) then Exit;
    Result := list.nextNode;
  end;
  Result := nil;
end;

function GetNodeValueByName(const ARoot: IXMLDomNode; const AName, ANameSpace: string): string;
var
  node: IXMLDomNode;
begin
  node := GetNodeByName(ARoot, AName, ANameSpace);
  if (node <> nil) then
  begin
    Result := GetNodeText(node);
  end else
  begin
    Result := '';
  end;
end;

function GetNodeValueByName(const ARoot: IXMLDomNode; const AName: string): string; overload;
var
  node: IXMLDomNode;
begin
  node := GetNodeByName(ARoot, AName);
  if (node <> nil) then
  begin
    Result := GetNodeText(node);
  end else
  begin
    Result := '';
  end;
end;

function GetNodeXmlByName(const ARoot: IXMLDomNode; const AName, ANameSpace: string): string; overload;
var
  node: IXMLDomNode;
begin
  node := GetNodeByName(ARoot, AName, ANameSpace);
  if (node <> nil) then
  begin
    Result := GetNodeXml(node);
  end else
  begin
    Result := '';
  end;
end;

function GetNodeXmlByName(const ARoot: IXMLDomNode; const AName: string): string; overload;
var
  node: IXMLDomNode;
begin
  node := GetNodeByName(ARoot, AName);
  if (node <> nil) then
  begin
    Result := GetNodeXml(node);
  end else
  begin
    Result := '';
  end;
end;

procedure GetNodeValueListByName(const ARoot: IXMLDomNode; const AName, ANameSpace: string; AList: TStrings);
var
  list: IXMLDomNodeList;
  node: IXMLDomNode;
begin
  AList.Clear();

  list := ARoot.childNodes;
  if (list = nil) then Exit;

  node := list.nextNode;
  while (node <> nil) do
  begin
    if (node.baseName = AName) and (node.namespaceURI = ANameSpace) then
    begin
      AList.Add(GetNodeText(node));
    end;
    node := list.nextNode;
  end;
  node := nil;
end;

procedure GetNodeValueListByName(const ARoot: IXMLDomNode; const AName: string; AList: TStrings);
var
  list: IXMLDomNodeList;
  node: IXMLDomNode;
begin
  AList.Clear();

  list := ARoot.childNodes;
  if (list = nil) then Exit;

  node := list.nextNode;
  while (node <> nil) do
  begin
    if (node.baseName = AName) then
    begin
      AList.Add(GetNodeText(node));
    end;
    node := list.nextNode;
  end;
  node := nil;
end;

function GetNodeText(const ANode: IXMLDomNode): string;
begin
  Result := Trim(string(ANode.text));
end;

function GetNodeXml(const ANode: IXMLDomNode): string;
begin
  Result := Trim(string(ANode.xml));
end;

procedure SetNodeText(const ANode: IXMLDomNode; const AValue: string);
var
  text: IXMLDomNode;
begin
  if (AValue = '') then Exit;

  text := ANode.ownerDocument.createTextNode(WideString(AValue));
  ANode.appendChild(text);
end;

procedure RemoveNode(ANode: IXMLDOMNode);
begin
  if (ANode <> nil) and (ANode.parentNode <> nil) then
  begin
    ANode.parentNode.removeChild(ANode);
  end;
end;

procedure AddNodeValue(const ARoot: IXMLDomNode; const AName, AValue: string);
var
  node: IXMLDomNode;
begin
  if (AValue = '') then Exit;

  node := ARoot.ownerDocument.CreateElement(AName);
  ARoot.appendChild(node);

  SetNodeText(node, AValue);
end;

function SameNodes(const ANode1, ANode2: IXMLDomNode): Boolean;
var
  node1, node2: IUnknown;
begin
  node1 := nil;
  if (ANode1 <> nil) then
  begin
    ANode1.QueryInterface(IUnknown, node1);
  end;
  node2 := nil;
  if (ANode2 <> nil) then
  begin
    ANode2.QueryInterface(IUnknown, node2);
  end;

  Result := (node1 = node2);
end;

function ReplaceXmlNode(const AXml, ANodeName, ANewXml: string): string;
var
  ind: Integer;
begin
  ind := TextPos('<' + ANodeName, AXml);
  if (ind > 0) then
  begin
    Result := System.Copy(AXml, 1, ind - 1);
    Result := Result + ANewXml;
    ind := TextPos('</' + ANodeName + '>', AXml, ind + Length(ANodeName) + 1);
    if (ind > 0) then
    begin
      Result := Result + System.Copy(AXml, ind + Length(ANodeName) + 3, MaxInt);
    end else
    begin
      Result := AXml;
    end;
  end else
  begin
    Result := AXml;
  end;
end;

const
  XmlReplaceLexem = '_6adfa1049e6e_';

function XmlCrlfEncode(const ASource: WideString): WideString;
var
  checkLexems: array of WideString;
begin
  SetLength(checkLexems, 3);
  checkLexems[0] := '&#13;';
  checkLexems[1] := '&#xd;';
  checkLexems[2] := '&#x0d;';

  Result := StrArrayReplace(ASource, checkLexems, XmlReplaceLexem);
end;

function XmlCrlfDecode(const ASource: WideString): WideString;
var
  checkLexems: array of WideString;
begin
  SetLength(checkLexems, 1);
  checkLexems[0] := XmlReplaceLexem;

  Result := StrArrayReplace(ASource, checkLexems, '&#xD;');
end;

function XmlCrlfDecode(const ASource: TclByteArray): TclByteArray;
var
  old, new: TclByteArray;
begin
  old := TclTranslator.GetBytes(XmlReplaceLexem);
  new := TclTranslator.GetBytes('&#xD;');
  Result := ByteArrayReplace(ASource, old, new);
end;

function UriReference2Id(const AValue: string): string;
begin
  Result := AValue;
  if (Result <> '') and (Result[1] = '#') then
  begin
    System.Delete(Result, 1, 1);
  end;
end;

function Id2UriReference(const AValue: string): string;
begin
  Result := AValue;
  if (Result <> '') then
  begin
    Result := '#' + Result;
  end;
end;

end.
