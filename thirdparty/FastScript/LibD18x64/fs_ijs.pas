
{******************************************}
{                                          }
{             FastScript v1.9              }
{             JScript grammar              }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_ijs;

interface

{$i fs.inc}

uses
  SysUtils, Classes, fs_itools;

type
  TfsJScript = class(TComponent);


implementation

const
  JS_GRAMMAR = 
  '<?xml version="1.0"?><language text="JScript"><parser><commentline1 text' +
  '="//"/><commentblock1 text="/*,*/"/><commentblock2 text="/*,*/"/><string' +
  'quotes text="&#34;"/><hexsequence text="0x"/><specstrchar text="1"/>' +
  '<declarevars text="0"/><key' +
  'words><break/><case/><continue/><default/><delete/><do/><else/><except/>' +
  '<finally/><for/><function/><import/><in/><is/><if/><new/><return/><switc' +
  'h/><try/><var/><while/><with/></keywords><errors><err1 text="Identifier ' +
  'expected"/><err2 text="Expression expected"/><err3 text="Statement expec' +
  'ted"/><err4 text="'':'' expected"/><err5 text="'';'' expected"/><err6 te' +
  'xt="''.'' expected"/><err7 text="'')'' expected"/><err8 text="'']'' expe' +
  'cted"/><err9 text="''='' expected"/><err10 text="''{'' expected"/><err11' +
  ' text="''}'' expected"/><err12 text="''('' expected"/><err14 text="''WHI' +
  'LE'' expected"/><err17 text="''FINALLY'' or ''EXCEPT'' expected"/><err18' +
  ' text="''['' expected"/><err19 text="''..'' expected"/><err20 text="''&#' +
  '62;'' expected"/></errors></parser><types/><empty/><program><statements/' +
  '></program><statements node="compoundstmt"><optionalloop><statement/></o' +
  'ptionalloop></statements><block><char text="{"/><statements/><char text=' +
  '"}" err="err11"/></block><importstmt node="uses"><keyword text="IMPORT"/' +
  '><loop text=","><string add="file" err="err1"/></loop></importstmt><vars' +
  'tmt><keyword text="VAR"/><loop text=","><vardecl/></loop></varstmt><vard' +
  'ecl node="var"><ident add="ident"/><optional><array/></optional><optiona' +
  'l><initvalue/></optional></vardecl><array node="array"><char text="["/><' +
  'loop text=","><arraydim err="err2"/></loop><char text="]" err="err8"/></' +
  'array><arraydim node="dim"><expression/></arraydim><initvalue node="init' +
  '"><char text="="/><expression err="err2"/></initvalue><expression node="' +
  'expr"><simpleexpression/><optionalloop><relop/><simpleexpression/></opti' +
  'onalloop></expression><simpleexpression><optional><char text="-" add="op' +
  '" addtext="unminus"/></optional><term/><optionalloop><addop/><term/></op' +
  'tionalloop></simpleexpression><term><factor/><optionalloop><mulop/><fact' +
  'or/></optionalloop></term><factor><switch><designator/><number add="numb' +
  'er"/><string add="string"/><sequence><char text="(" add="op"/><expressio' +
  'n err="err2"/><char text=")" add="op" err="err7"/></sequence><sequence><' +
  'char text="!" add="op" addtext="not"/><factor err="err2"/></sequence><se' +
  'quence><char text="["/><setconstructor err="err2"/><char text="]" err="e' +
  'rr8"/></sequence><newoperator/><sequence><char text="&#60;"/><frstring/>' +
  '<char text="&#62;" err="err20"/></sequence></switch></factor><setconstru' +
  'ctor node="set"><loop text=","><setnode/></loop></setconstructor><setnod' +
  'e><expression/><optional><char text="."/><char text="." add="range"/><ex' +
  'pression/></optional></setnode><newoperator node="new"><keyword text="NE' +
  'W"/><designator err="err2"/></newoperator><relop><switch><sequence><char' +
  ' text="&#62;"/><char text="=" skip="0" add="op" addtext="&#62;="/></sequ' +
  'ence><sequence><char text="&#60;"/><char text="=" skip="0" add="op" addt' +
  'ext="&#60;="/></sequence><char text="&#62;" add="op" addtext="&#62;"/><c' +
  'har text="&#60;" add="op" addtext="&#60;"/><sequence><char text="="/><ch' +
  'ar text="=" skip="0" add="op" addtext="="/></sequence><sequence><char te' +
  'xt="!"/><char text="=" skip="0" add="op" addtext="&#60;&#62;"/></sequenc' +
  'e><keyword text="IN" add="op" addtext="in"/><keyword text="IS" add="op" ' +
  'addtext="is"/></switch></relop><addop><switch><char text="+" add="op"/><' +
  'char text="-" add="op"/><sequence><char text="|"/><char text="|" add="op' +
  '" addtext="or"/></sequence><char text="^" add="op" addtext="xor"/></swit' +
  'ch></addop><mulop><switch><char text="*" add="op"/><char text="/" add="o' +
  'p"/><keyword text="DIV" add="op" addtext="div"/><char text="%" add="op" ' +
  'addtext="mod"/><sequence><char text="&#38;"/><char text="&#38;" add="op"' +
  ' addtext="and"/></sequence><sequence><char text="&#60;"/><char text="&#6' +
  '0;" skip="0" add="op" addtext="shl"/></sequence><sequence><char text="&#' +
  '62;"/><char text="&#62;" skip="0" add="op" addtext="shr"/></sequence></s' +
  'witch></mulop><designator node="dsgn"><optional><char text="&#38;" add="' +
  'addr"/></optional><ident add="node"/><optionalloop><switch><sequence><ch' +
  'ar text="."/><keyword add="node"/></sequence><sequence><char text="[" ad' +
  'd="node"/><exprlist err="err2"/><char text="]" err="err8"/></sequence><s' +
  'equence><char text="("/><optional><exprlist/></optional><char text=")" e' +
  'rr="err7"/></sequence></switch></optionalloop></designator><exprlist><lo' +
  'op text=","><expression/></loop></exprlist><statement><switch><breakstmt' +
  '/><continuestmt/><deletestmt/><dowhilestmt/><forstmt/><functionstmt/><if' +
  'stmt/><importstmt/><returnstmt/><switchstmt/><trystmt/><varstmt/><whiles' +
  'tmt/><withstmt/><assignstmt/><callstmt/><block/></switch><optional><char' +
  ' text=";"/></optional></statement><breakstmt><keyword text="BREAK" node=' +
  '"break"/></breakstmt><continuestmt><keyword text="CONTINUE" node="contin' +
  'ue"/></continuestmt><deletestmt node="delete"><keyword text="DELETE"/><d' +
  'esignator err="err2"/></deletestmt><assignstmt node="assignstmt"><design' +
  'ator/><switch><sequence><char text="+" add="modificator"/><char text="="' +
  ' skip="0"/></sequence><sequence><char text="-" add="modificator"/><char ' +
  'text="=" skip="0"/></sequence><sequence><char text="*" add="modificator"' +
  '/><char text="=" skip="0"/></sequence><sequence><char text="/" add="modi' +
  'ficator"/><char text="=" skip="0"/></sequence><char text="="/></switch><' +
  'expression err="err2"/></assignstmt><callstmt node="callstmt"><designato' +
  'r/><optionalswitch><sequence><char text="+"/><char text="+" skip="0" add' +
  '="modificator"/></sequence><sequence><char text="-"/><char text="-" skip' +
  '="0" add="modificator"/></sequence></optionalswitch></callstmt><returnst' +
  'mt node="return"><keyword text="RETURN"/><optional><expression/></option' +
  'al></returnstmt><ifstmt node="ifstmt"><keyword text="IF"/><char text="("' +
  ' err="err12"/><expression err="err2"/><char text=")" err="err7"/><statem' +
  'ent node="thenstmt"/><optional><keyword text="ELSE"/><statement node="el' +
  'sestmt"/></optional></ifstmt><switchstmt node="casestmt"><keyword text="' +
  'SWITCH"/><char text="(" err="err12"/><expression err="err2"/><char text=' +
  '")" err="err7"/><char text="{" err="err10"/><loop><caseselector/></loop>' +
  '<optional><keyword text="DEFAULT"/><char text=":" err="err4"/><statement' +
  '/></optional><char text="}" err="err11"/></switchstmt><caseselector node' +
  '="caseselector"><keyword text="CASE"/><setconstructor err="err2"/><char ' +
  'text=":" err="err4"/><statement/></caseselector><dowhilestmt node="repea' +
  'tstmt"><keyword text="DO"/><statement/><optional><char text=";"/></optio' +
  'nal><keyword text="WHILE" err="err14"/><char text="(" err="err12"/><expr' +
  'ession err="err2"/><empty add="inverse"/><char text=")" err="err7"/><cha' +
  'r text=";" err="err5"/></dowhilestmt><whilestmt node="whilestmt"><keywor' +
  'd text="WHILE"/><char text="(" err="err12"/><expression err="err2"/><cha' +
  'r text=")" err="err7"/><statement/></whilestmt><forstmt node="cppforstmt' +
  '"><keyword text="FOR"/><char text="(" err="err12"/><forstmtitem/><char t' +
  'ext=";" err="err5"/><expression err="err2"/><char text=";" err="err5"/><' +
  'forstmtitem/><char text=")" err="err7"/><statement/></forstmt><forstmtit' +
  'em><switch><assignstmt/><callstmt/><varstmt/><empty node="empty"/></swit' +
  'ch></forstmtitem><trystmt node="trystmt"><keyword text="TRY"/><statement' +
  '/><switch err="err17"><sequence><keyword text="FINALLY"/><statement node' +
  '="finallystmt"/></sequence><sequence><keyword text="EXCEPT"/><statement ' +
  'node="exceptstmt"/></sequence></switch></trystmt><functionstmt node="fun' +
  'ction"><functionheading/><block/></functionstmt><functionheading><keywor' +
  'd text="FUNCTION"/><ident add="name" err="err2"/><formalparameters/></fu' +
  'nctionheading><formalparameters node="parameters"><char text="("/><optio' +
  'nalloop text=","><formalparam/></optionalloop><char text=")" err="err7"/' +
  '></formalparameters><formalparam node="var"><optional><char text="&#38;"' +
  ' add="varparam"/></optional><ident add="ident"/></formalparam><withstmt ' +
  'node="with"><keyword text="WITH"/><char text="("/><designator err="err2"' +
  '/><char text=")" err="err7"/><statement/></withstmt></language>';


initialization
  fsRegisterLanguage('JScript', JS_GRAMMAR);

end.
