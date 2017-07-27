
{******************************************}
{                                          }
{             FastScript v1.9              }
{              Pascal grammar              }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_ipascal;

interface

{$i fs.inc}

uses
  SysUtils, Classes, fs_itools;

type
  TfsPascal = class(TComponent);

procedure fsModifyPascalForFR2;

implementation

const
  PASCAL_GRAMMAR =
  '<?xml version="1.0"?><language text="PascalScript"><parser><commentline1' +
  ' text="//"/><commentblock1 text="{,}"/><commentblock2 text="(*,*)"/><str' +
  'ingquotes text="''"/><hexsequence text="$"/><keywords><and/><array/><beg' +
  'in/><break/><case/><const/><continue/><div/><do/><downto/><else/><end/><' +
  'except/><exit/><finally/><for/><function/><goto/><if/><in/><is/><label/>' +
  '<mod/><not/><of/><or/><procedure/><program/><repeat/><shl/><shr/><then/>' +
  '<to/><try/><until/><uses/><var/><while/><with/><xor/></keywords><errors>' +
  '<err1 text="Identifier expected"/><err2 text="Expression expected"/><err' +
  '3 text="Statement expected"/><err4 text="'':'' expected"/><err5 text="''' +
  ';'' expected"/><err6 text="''.'' expected"/><err7 text="'')'' expected"/' +
  '><err8 text="'']'' expected"/><err9 text="''='' expected"/><err10 text="' +
  '''BEGIN'' expected"/><err11 text="''END'' expected"/><err12 text="''OF''' +
  ' expected"/><err13 text="''THEN'' expected"/><err14 text="''UNTIL'' expe' +
  'cted"/><err15 text="''TO'' or ''DOWNTO'' expected"/><err16 text="''DO'' ' +
  'expected"/><err17 text="''FINALLY'' or ''EXCEPT'' expected"/><err18 text' +
  '="''['' expected"/><err19 text="''..'' expected"/><err20 text="''&#62;''' +
  ' expected"/></errors></parser><types/><empty/><program><optional><keywor' +
  'd text="PROGRAM"/><ident err="err1"/><char text=";" err="err5"/></option' +
  'al><optional><usesclause/></optional><block/><char text="." err="err6"/>' +
  '</program><usesclause node="uses"><keyword text="USES"/><loop text=","><' +
  'string add="file" err="err1"/></loop><char text=";" err="err5"/></usescl' +
  'ause><block><optionalloop><declsection/></optionalloop><compoundstmt err' +
  '="err10"/></block><declsection><switch><constsection' +
  '/><varsection/><proceduredeclsection/></switch></declsection><constsecti' +
  'on><keyword text="CONST"/><loop><constantdecl/></loop></constsection><co' +
  'nstantdecl node="const"><ident add="ident" err="err1" term="1"/><char te' +
  'xt="=" err="err9"/><expression err="err2"/><char text=";" err="err5"/></' +
  'constantdecl><varsection><keyword text="VAR"/><loop><varlist/><char text' +
  '=";" err="err5"/></loop></varsection><varlist node="var"><loop text=",">' +
  '<ident add="ident" err="err1" term="1"/></loop><char text=":" err="err4"' +
  '/><typeident err="err1"/><optional><initvalue/></optional></varlist><typ' +
  'eident><optional><array/></optional><ident add="type"/></typeident><arra' +
  'y node="array"><keyword text="ARRAY"/><optional><char text="["/><loop te' +
  'xt=","><arraydim err="err2"/></loop><char text="]" err="err8"/></optiona' +
  'l><keyword text="OF" err="err12"/></array><arraydim node="dim"><switch><' +
  'sequence><expression/><char text="."/><char text="." skip="0"/><expressi' +
  'on/></sequence><expression/></switch></arraydim><initvalue node="init"><' +
  'char text="="/><expression err="err2"/></initvalue><expression node="exp' +
  'r"><simpleexpression/><optionalloop><relop/><simpleexpression/></optiona' +
  'lloop></expression><simpleexpression><optional><char text="-" add="op" a' +
  'ddtext="unminus"/></optional><term/><optionalloop><addop/><term/></optio' +
  'nalloop></simpleexpression><term><factor/><optionalloop><mulop/><factor/' +
  '></optionalloop></term><factor><switch><designator/><number add="number"' +
  '/><string add="string"/><sequence><char text="(" add="op"/><expression e' +
  'rr="err2"/><char text=")" add="op" err="err7"/></sequence><sequence><key' +
  'word text="NOT" add="op" addtext="not"/><factor err="err2"/></sequence><' +
  'sequence><char text="["/><setconstructor err="err2"/><char text="]" err=' +
  '"err8"/></sequence><sequence><char text="&#60;"/><frstring/><char text="' +
  '&#62;" err="err20"/></sequence></switch></factor><setconstructor node="s' +
  'et"><loop text=","><setnode/></loop></setconstructor><setnode><expressio' +
  'n/><optional><char text="." add="range"/><char text="." err="err6"/><exp' +
  'ression/></optional></setnode><relop><switch><sequence><char text="&#62;' +
  '"/><char text="=" skip="0" add="op" addtext="&#62;="/></sequence><sequen' +
  'ce><char text="&#60;"/><char text="&#62;" skip="0" add="op" addtext="&#6' +
  '0;&#62;"/></sequence><sequence><char text="&#60;"/><char text="=" skip="' +
  '0" add="op" addtext="&#60;="/></sequence><char text="&#62;" add="op" add' +
  'text="&#62;"/><char text="&#60;" add="op" addtext="&#60;"/><char text="=' +
  '" add="op" addtext="="/><keyword text="IN" add="op" addtext="in"/><keywo' +
  'rd text="IS" add="op" addtext="is"/></switch></relop><addop><switch><cha' +
  'r text="+" add="op"/><char text="-" add="op"/><keyword text="OR" add="op' +
  '" addtext="or"/><keyword text="XOR" add="op" addtext="xor"/></switch></a' +
  'ddop><mulop><switch><char text="*" add="op"/><char text="/" add="op"/><k' +
  'eyword text="DIV" add="op" addtext="div"/><keyword text="MOD" add="op" a' +
  'ddtext="mod"/><keyword text="AND" add="op" addtext="and"/><keyword text=' +
  '"SHL" add="op" addtext="shl"/><keyword text="SHR" add="op" addtext="shr"' +
  '/></switch></mulop><designator node="dsgn"><optional><char text="@" add=' +
  '"addr"/></optional><ident add="node"/><optionalloop><switch><sequence><c' +
  'har text="."/><keyword add="node" err="err1"/></sequence><sequence><char' +
  ' text="[" add="node"/><exprlist err="err2"/><char text="]" err="err8"/><' +
  '/sequence><sequence><char text="("/><exprlist err="err2"/><char text=")"' +
  ' err="err7"/></sequence></switch></optionalloop></designator><exprlist><' +
  'optionalloop text=","><expression/></optionalloop></exprlist><statement>' +
  '<optionalswitch><simplestatement/><structstmt/></optionalswitch></statem' +
  'ent><stmtlist><loop text=";"><statement/></loop></stmtlist><simplestatem' +
  'ent><switch><assignstmt/><callstmt/><switch><keyword text="BREAK" node="' +
  'break"/><keyword text="CONTINUE" node="continue"/><keyword text="EXIT" n' +
  'ode="exit"/></switch></switch></simplestatement><assignstmt node="assign' +
  'stmt"><designator/><char text=":"/><char text="=" skip="0" err="err9"/><' +
  'expression err="err2"/></assignstmt><callstmt node="callstmt"><designato' +
  'r/></callstmt><structstmt><switch><compoundstmt/><conditionalstmt/><loop' +
  'stmt/><trystmt/><withstmt/></switch></structstmt><compoundstmt node="com' +
  'poundstmt"><keyword text="BEGIN"/><stmtlist/><keyword text="END" err="er' +
  'r5"/></compoundstmt><conditionalstmt><switch><ifstmt/><casestmt/></switc' +
  'h></conditionalstmt><ifstmt node="ifstmt"><keyword text="IF"/><expressio' +
  'n err="err2"/><keyword text="THEN" err="err13"/><statement node="thenstm' +
  't"/><optional><keyword text="ELSE"/><statement node="elsestmt"/></option' +
  'al></ifstmt><casestmt node="casestmt"><keyword text="CASE"/><expression ' +
  'err="err2"/><keyword text="OF" err="err12"/><loop text=";" skip="1"><cas' +
  'eselector/></loop><optional><keyword text="ELSE"/><statement/></optional' +
  '><optional><char text=";"/></optional><keyword text="END" err="err11"/><' +
  '/casestmt><caseselector node="caseselector"><setconstructor err="err2"/>' +
  '<char text=":" err="err4"/><statement/></caseselector><loopstmt><switch>' +
  '<repeatstmt/><whilestmt/><forstmt/></switch></loopstmt><repeatstmt node=' +
  '"repeatstmt"><keyword text="REPEAT"/><stmtlist/><keyword text="UNTIL" er' +
  'r="err14"/><expression err="err2"/></repeatstmt><whilestmt node="whilest' +
  'mt"><keyword text="WHILE"/><expression err="err2"/><keyword text="DO" er' +
  'r="err16"/><statement/></whilestmt><forstmt node="forstmt"><keyword text' +
  '="FOR"/><ident add="ident" err="err1"/><char text=":" err="err4"/><char ' +
  'text="=" skip="0" err="err9"/><expression err="err2"/><switch err="err15' +
  '"><keyword text="TO"/><keyword text="DOWNTO" add="downto"/></switch><exp' +
  'ression err="err2"/><keyword text="DO" err="err16"/><statement/></forstm' +
  't><trystmt node="trystmt"><keyword text="TRY"/><stmtlist/><switch err="e' +
  'rr17"><sequence><keyword text="FINALLY"/><stmtlist node="finallystmt"/><' +
  '/sequence><sequence><keyword text="EXCEPT"/><stmtlist node="exceptstmt"/' +
  '></sequence></switch><keyword text="END" err="err11"/></trystmt><withstm' +
  't node="with"><keyword text="WITH"/><loop text=","><designator err="err2' +
  '"/></loop><keyword text="DO" err="err16"/><statement/></withstmt><proced' +
  'uredeclsection><switch><proceduredecl/><functiondecl/></switch></procedu' +
  'redeclsection><proceduredecl node="procedure"><procedureheading/><char t' +
  'ext=";" err="err5"/><block/><char text=";" err="err5"/></proceduredecl><' +
  'procedureheading><keyword text="PROCEDURE"/><ident add="name" err="err1"' +
  '/><optional><formalparameters/></optional></procedureheading><functionde' +
  'cl node="function"><functionheading/><char text=";" err="err5"/><block/>' +
  '<char text=";" err="err5"/></functiondecl><functionheading><keyword text' +
  '="FUNCTION"/><ident add="name" err="err1"/><optional><formalparameters/>' +
  '</optional><char text=":" err="err4"/><ident add="type" err="err1"/></fu' +
  'nctionheading><formalparameters node="parameters"><char text="("/><optionalloop ' +
  'text=";"><formalparam/></optionalloop><char text=")" err="err7"/></formalparamet' +
  'ers><formalparam><optionalswitch><keyword text="VAR" node="varparams"/><' +
  'keyword text="CONST"/></optionalswitch><varlist/></formalparam></languag' +
  'e>';


procedure fsModifyPascalForFR2;
var
  i: Integer;
  s, s1: String;
begin
  s := PASCAL_GRAMMAR;
  s1 := '<char text="["/><setconstructor err="err2"/><char text="]" err="err8"/>';
  i := Pos(s1, s);
  if i <> 0 then
  begin
    Delete(s, i, Length(s1));
    s1 := '<char text="`"/><setconstructor err="err2"/><char text="`" err="err8"/>' +
      '</sequence><sequence><char text="["/><frstring/><char text="]" err="err8"/>';
    Insert(s1, s, i);
  end;

  i := Pos('<commentline1', s);
  if i <> 0 then
  begin
    s1 := '<declarevars text="0"/>';
    Insert(s1, s, i);
  end;

  fsRegisterLanguage('PascalScript', s);
end;


initialization
  fsRegisterLanguage('PascalScript', PASCAL_GRAMMAR);

end.
