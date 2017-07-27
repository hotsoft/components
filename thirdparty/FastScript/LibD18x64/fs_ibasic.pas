
{******************************************}
{                                          }
{             FastScript v1.9              }
{              Basic grammar               }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_ibasic;

interface

{$i fs.inc}

uses
  SysUtils, Classes, fs_itools;

type
  TfsBasic = class(TComponent);


implementation

const
  BASIC_GRAMMAR = 
  '<?xml version="1.0"?><language text="BasicScript"><parser><commentline1 ' +
  'text="''"/><commentline2 text="rem"/><commentblock1 text="/\,/\"/><comme' +
  'ntblock2 text="/\,/\"/><stringquotes text="&#34;"/><hexsequence text="0x' +
  '"/><declarevars text="0"/><skipeol text="0"/><skipchar text="_"/><keywor' +
  'ds><addressof/><and/><as/><byref/><byval/><case/><catch/><delete/><dim/>' +
  '<do/><else/><elseif/><end/><endif/><exit/><finally/><for/><function/><if' +
  '/><imports/><is/><loop/><mod/><new/><next/><not/><or/><rem/><return/><se' +
  'lect/><set/><step/><sub/><then/><to/><try/><wend/><while/><with/><xor/><' +
  '/keywords><errors><err1 text="Identifier expected"/><err2 text="Expressi' +
  'on expected"/><err3 text="End of line expected"/><err4 text="'':'' expec' +
  'ted"/><err5 text="'';'' expected"/><err6 text="''.'' expected"/><err7 te' +
  'xt="'')'' expected"/><err8 text="'']'' expected"/><err9 text="''='' expe' +
  'cted"/><err10 text="''TO'' expected"/><err11 text="''END'' expected"/><e' +
  'rr12 text="''('' expected"/><err13 text="''THEN'' expected"/><err14 text' +
  '="''WHILE'' expected"/><err15 text="''CASE'' expected"/><err16 text="''S' +
  'ELECT'' expected"/><err17 text="''FINALLY'' or ''CATCH'' expected"/><err' +
  '18 text="''['' expected"/><err19 text="''..'' expected"/><err20 text="''' +
  '&#62;'' expected"/><err21 text="''WEND'' expected"/><err22 text="''NEXT' +
  ''' expected"/><err23 text="''WITH'' expected"/><err24 text="''TRY'' expe' +
  'cted"/><err25 text="''SUB'' expected"/><err26 text="''FUNCTION'' expecte' +
  'd"/><err27 text="''ELSE'' expected"/><err28 text="''IF'' expected"/></er' +
  'rors></parser><types><decimal type="extended"/></types><empty/><program>' +
  '<statements/></program><statements node="compoundstmt"><loop><switch><eo' +
  'l/><sequence><statementlist/><eol err="err3"/></sequence></switch></loop' +
  '></statements><statementlist><loop text=":"><statement/></loop></stateme' +
  'ntlist><importstmt node="uses"><keyword text="IMPORTS"/><loop text=","><' +
  'string add="file" err="err1"/></loop></importstmt><dimstmt><keyword text' +
  '="DIM"/><loop text=","><vardecl/></loop></dimstmt><vardecl node="var"><i' +
  'dent add="ident" err="err1" term="1"/><optional><array/></optional><opti' +
  'onal><asclause/></optional><optional><initvalue/></optional></vardecl><a' +
  'sclause><keyword text="AS"/><ident add="type" err="err1"/></asclause><ar' +
  'ray node="array"><char text="["/><loop text=","><arraydim err="err2"/></' +
  'loop><char text="]" err="err8"/></array><arraydim node="dim"><expression' +
  '/></arraydim><initvalue node="init"><char text="="/><expression err="err' +
  '2"/></initvalue><expression node="expr"><simpleexpression/><optionalloop' +
  '><relop/><simpleexpression/></optionalloop></expression><simpleexpressio' +
  'n><optional><char text="-" add="op" addtext="unminus"/></optional><term/' +
  '><optionalloop><addop/><term/></optionalloop></simpleexpression><term><f' +
  'actor/><optionalloop><mulop/><factor/></optionalloop></term><factor><swi' +
  'tch><designator/><number add="number"/><string add="string"/><sequence><' +
  'char text="(" add="op"/><expression err="err2"/><char text=")" add="op" ' +
  'err="err7"/></sequence><sequence><keyword text="NOT" add="op" addtext="n' +
  'ot"/><factor err="err2"/></sequence><sequence><char text="["/><setconstr' +
  'uctor err="err2"/><char text="]" err="err8"/></sequence><newoperator/><s' +
  'equence><char text="&#60;"/><frstring/><char text="&#62;" err="err20"/><' +
  '/sequence></switch></factor><setconstructor node="set"><loop text=","><s' +
  'etnode/></loop></setconstructor><setnode><expression/><optional><char te' +
  'xt="."/><char text="." add="range"/><expression/></optional></setnode><n' +
  'ewoperator node="new"><keyword text="NEW"/><designator err="err2"/></new' +
  'operator><relop><switch><sequence><char text="&#62;"/><char text="=" ski' +
  'p="0" add="op" addtext="&#62;="/></sequence><sequence><char text="&#60;"' +
  '/><char text="&#62;" skip="0" add="op" addtext="&#60;&#62;"/></sequence>' +
  '<sequence><char text="&#60;"/><char text="=" skip="0" add="op" addtext="' +
  '&#60;="/></sequence><char text="&#62;" add="op" addtext="&#62;"/><char t' +
  'ext="&#60;" add="op" addtext="&#60;"/><char text="=" add="op" addtext="=' +
  '"/><keyword text="IN" add="op" addtext="in"/><keyword text="IS" add="op"' +
  ' addtext="is"/></switch></relop><addop><switch><char text="+" add="op"/>' +
  '<char text="-" add="op"/><char text="&#38;" add="op" addtext="strcat"/><' +
  'keyword text="OR" add="op" addtext="or"/><keyword text="XOR" add="op" ad' +
  'dtext="xor"/></switch></addop><mulop><switch><char text="*" add="op"/><c' +
  'har text="/" add="op"/><char text="\" add="op" addtext="div"/><keyword t' +
  'ext="MOD" add="op" addtext="mod"/><keyword text="AND" add="op" addtext="' +
  'and"/></switch></mulop><designator node="dsgn"><optional><keyword text="' +
  'ADDRESSOF" add="addr"/></optional><ident add="node"/><optionalloop><swit' +
  'ch><sequence><char text="."/><keyword add="node"/></sequence><sequence><' +
  'char text="[" add="node"/><exprlist err="err2"/><char text="]" err="err8' +
  '"/></sequence><sequence><char text="("/><optional><exprlist/></optional>' +
  '<char text=")" err="err7"/></sequence></switch></optionalloop></designat' +
  'or><exprlist><loop text=","><expression/></loop></exprlist><statement><s' +
  'witch><breakstmt/><casestmt/><continuestmt/><deletestmt/><dimstmt/><dost' +
  'mt/><exitstmt/><forstmt/><funcstmt/><ifstmt/><importstmt/><procstmt/><re' +
  'turnstmt/><setstmt/><trystmt/><whilestmt/><withstmt/><assignstmt/><calls' +
  'tmt/></switch></statement><breakstmt><keyword text="BREAK" node="break"/' +
  '></breakstmt><continuestmt><keyword text="CONTINUE" node="continue"/></c' +
  'ontinuestmt><exitstmt><keyword text="EXIT" node="exit"/></exitstmt><dele' +
  'testmt node="delete"><keyword text="DELETE"/><designator err="err2"/></d' +
  'eletestmt><setstmt node="assignstmt"><keyword text="SET"/><assignstmt er' +
  'r="err2"/></setstmt><assignstmt node="assignstmt"><designator/><switch><' +
  'sequence><char text="+" add="modificator"/><char text="=" skip="0"/></se' +
  'quence><sequence><char text="-" add="modificator"/><char text="=" skip="' +
  '0"/></sequence><sequence><char text="*" add="modificator"/><char text="=' +
  '" skip="0"/></sequence><sequence><char text="/" add="modificator"/><char' +
  ' text="=" skip="0"/></sequence><char text="="/></switch><expression err=' +
  '"err2"/></assignstmt><callstmt node="callstmt"><designator/><optionalswi' +
  'tch><sequence><char text="+"/><char text="+" skip="0" add="modificator"/' +
  '></sequence><sequence><char text="-"/><char text="-" skip="0" add="modif' +
  'icator"/></sequence></optionalswitch></callstmt><returnstmt node="return' +
  '"><keyword text="RETURN"/><optional><expression/></optional></returnstmt' +
  '><ifstmt node="ifstmt"><keyword text="IF"/><expression err="err2"/><keyw' +
  'ord text="THEN" err="err13"/><thenstmt/></ifstmt><thenstmt><switch><sequ' +
  'ence><eol/><optional><statements node="thenstmt"/></optional><optionalsw' +
  'itch><elseifstmt node="elsestmt"/><elsestmt node="elsestmt"/></optionals' +
  'witch><keyword text="END" err="err11"/><keyword text="IF" err="err28"/><' +
  '/sequence><statementlist node="thenstmt"/></switch></thenstmt><elseifstm' +
  't node="ifstmt"><keyword text="ELSEIF"/><expression err="err2"/><keyword' +
  ' text="THEN" err="err13"/><switch><sequence><eol/><optional><statements ' +
  'node="thenstmt"/></optional><optionalswitch><elseifstmt node="elsestmt"/' +
  '><elsestmt node="elsestmt"/></optionalswitch></sequence><statement node=' +
  '"thenstmt"/></switch></elseifstmt><elsestmt><keyword text="ELSE"/><switc' +
  'h><sequence><eol/><optional><statements/></optional></sequence><statemen' +
  't/></switch></elsestmt><casestmt node="casestmt"><keyword text="SELECT"/' +
  '><keyword text="CASE" err="err15"/><expression err="err2"/><eol/><loop><' +
  'caseselector/></loop><optional><keyword text="CASE"/><keyword text="ELSE' +
  '" err="err27"/><char text=":" err="err4"/><statements/></optional><keywo' +
  'rd text="END" err="err11"/><keyword text="SELECT" err="err16"/></casestm' +
  't><caseselector node="caseselector"><keyword text="CASE"/><setconstructo' +
  'r/><char text=":" err="err4"/><statements/></caseselector><dostmt node="' +
  'repeatstmt"><keyword text="DO"/><optional><statements/></optional><keywo' +
  'rd text="LOOP"/><switch><sequence><keyword text="UNTIL"/><expression err' +
  '="err2"/></sequence><sequence><keyword text="WHILE" err="err14"/><expres' +
  'sion err="err2"/><empty add="inverse"/></sequence></switch></dostmt><whi' +
  'lestmt node="whilestmt"><keyword text="WHILE"/><expression err="err2"/><' +
  'optional><statements/></optional><keyword text="WEND" err="err21"/></whi' +
  'lestmt><forstmt node="vbforstmt"><keyword text="FOR"/><ident add="ident"' +
  ' err="err1"/><char text="=" err="err9"/><expression err="err2"/><keyword' +
  ' text="TO" err="err10"/><expression err="err2"/><optional><keyword text=' +
  '"STEP"/><expression err="err2"/></optional><eol/><optional><statements/>' +
  '</optional><keyword text="NEXT" err="err22"/></forstmt><trystmt node="tr' +
  'ystmt"><keyword text="TRY"/><statements/><switch err="err17"><sequence><' +
  'keyword text="FINALLY"/><optional><statements node="finallystmt"/></opti' +
  'onal></sequence><sequence><keyword text="CATCH"/><optional><statements n' +
  'ode="exceptstmt"/></optional></sequence></switch><keyword text="END"/><k' +
  'eyword text="TRY" err="err24"/></trystmt><withstmt node="with"><keyword ' +
  'text="WITH"/><designator err="err2"/><eol/><statements/><keyword text="E' +
  'ND"/><keyword text="WITH" err="err23"/></withstmt><procstmt node="proced' +
  'ure"><keyword text="SUB"/><ident add="name" err="err1"/><optional><forma' +
  'lparameters/></optional><eol/><optional><statements/></optional><keyword' +
  ' text="END" err="err11"/><empty node="exit"/><keyword text="SUB" err="er' +
  'r25"/></procstmt><funcstmt node="function"><keyword text="FUNCTION"/><id' +
  'ent add="name" err="err1"/><optional><formalparameters/></optional><opti' +
  'onal><asclause/></optional><eol/><optional><statements/></optional><keyw' +
  'ord text="END" err="err11"/><empty node="exit"/><keyword text="FUNCTION"' +
  ' err="err26"/></funcstmt><formalparameters node="parameters"><char text=' +
  '"("/><optionalloop text=","><formalparam/></optionalloop><char text=")" ' +
  'err="err7"/></formalparameters><formalparam><optionalswitch><keyword tex' +
  't="BYREF" node="varparams"/><keyword text="BYVAL"/></optionalswitch><var' +
  'decl/></formalparam></language>';

  
initialization
  fsRegisterLanguage('BasicScript', BASIC_GRAMMAR);

end.
