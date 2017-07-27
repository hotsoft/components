
{******************************************}
{                                          }
{             FastScript v1.9              }
{               C++ grammar                }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_icpp;

interface

{$i fs.inc}

uses
  SysUtils, Classes, fs_itools;

type
  TfsCPP = class(TComponent);


implementation

const
  CPP_GRAMMAR = 
  '<?xml version="1.0"?><language text="C++Script"><parser><commentline1 te' +
  'xt="//"/><commentblock1 text="/*,*/"/><commentblock2 text="/*,*/"/><stri' +
  'ngquotes text="&#34;"/><hexsequence text="0x"/><specstrchar text="1"/>' +
  '<casesensitive text="1"/>' +
  '<keywords><break/><case/><continue/><define/><default/><delete/><do/><el' +
  'se/><except/><finally/><for/><in/><is/><if/><new/><return/><switch/><try' +
  '/><while/></keywords><errors><err1 text="Identifier expected"/><err2 tex' +
  't="Expression expected"/><err3 text="Statement expected"/><err4 text="''' +
  ':'' expected"/><err5 text="'';'' expected"/><err6 text="''.'' expected"/' +
  '><err7 text="'')'' expected"/><err8 text="'']'' expected"/><err9 text="' +
  '''='' expected"/><err10 text="''{'' expected"/><err11 text="''}'' expect' +
  'ed"/><err12 text="''('' expected"/><err13 text="''DEFINE'' expected"/><e' +
  'rr14 text="''WHILE'' expected"/><err17 text="''FINALLY'' or ''EXCEPT'' e' +
  'xpected"/><err18 text="''['' expected"/><err19 text="''..'' expected"/><' +
  'err20 text="''&#62;'' expected"/></errors></parser><types><int type="int' +
  'eger"/><long type="integer"/><void type="integer"/><bool type="boolean"/' +
  '><float type="extended"/></types><empty/><program><optional><usesclause/' +
  '></optional><optionalloop><declsection/></optionalloop><compoundstmt err' +
  '="err10"/></program><usesclause node="uses"><char text="#"/><keyword tex' +
  't="INCLUDE"/><loop text=","><string add="file" err="err1"/></loop></uses' +
  'clause><declsection><switch><constsection/><functiondecl/><sequence><var' +
  'stmt/><char text=";" err="err5"/></sequence></switch></declsection><cons' +
  'tsection><char text="#"/><keyword text="DEFINE" err="err13"/><constantde' +
  'cl/></constsection><constantdecl node="const"><ident add="ident" err="er' +
  'r1"/><expression err="err2"/></constantdecl><varstmt node="var"><ident a' +
  'dd="type"/><loop text=","><ident add="ident"/><optional><array/></option' +
  'al><optional><initvalue/></optional></loop></varstmt><array node="array"' +
  '><loop><char text="["/><optionalloop text=","><arraydim err="err2"/></op' +
  'tionalloop><char text="]" err="err8"/></loop></array><arraydim node="dim' +
  '"><expression/></arraydim><initvalue node="init"><char text="="/><expres' +
  'sion err="err2"/></initvalue><expression node="expr"><simpleexpression/>' +
  '<optionalloop><relop/><simpleexpression/></optionalloop></expression><si' +
  'mpleexpression><optional><char text="-" add="op" addtext="unminus"/></op' +
  'tional><term/><optionalloop><addop/><term/></optionalloop></simpleexpres' +
  'sion><term><factor/><optionalloop><mulop/><factor/></optionalloop></term' +
  '><factor><switch><designator/><number add="number"/><string add="string"' +
  '/><sequence><char text="(" add="op"/><expression err="err2"/><char text=' +
  '")" add="op" err="err7"/></sequence><sequence><char text="!" add="op" ad' +
  'dtext="not"/><factor err="err2"/></sequence><sequence><char text="["/><s' +
  'etconstructor err="err2"/><char text="]" err="err8"/></sequence><newoper' +
  'ator/><sequence><char text="&#60;"/><frstring/><char text="&#62;" err="e' +
  'rr20"/></sequence></switch></factor><setconstructor node="set"><loop tex' +
  't=","><setnode/></loop></setconstructor><setnode><expression/><optional>' +
  '<char text="."/><char text="." add="range"/><expression/></optional></se' +
  'tnode><newoperator node="new"><keyword text="NEW"/><designator err="err2' +
  '"/></newoperator><relop><switch><sequence><char text="&#62;"/><char text' +
  '="=" skip="0" add="op" addtext="&#62;="/></sequence><sequence><char text' +
  '="&#60;"/><char text="=" skip="0" add="op" addtext="&#60;="/></sequence>' +
  '<char text="&#62;" add="op" addtext="&#62;"/><char text="&#60;" add="op"' +
  ' addtext="&#60;"/><sequence><char text="="/><char text="=" skip="0" add=' +
  '"op" addtext="="/></sequence><sequence><char text="!"/><char text="=" sk' +
  'ip="0" add="op" addtext="&#60;&#62;"/></sequence><keyword text="IN" add=' +
  '"op" addtext="in"/><keyword text="IS" add="op" addtext="is"/></switch></' +
  'relop><addop><switch><char text="+" add="op"/><char text="-" add="op"/><' +
  'sequence><char text="|"/><char text="|" add="op" addtext="or"/></sequenc' +
  'e><char text="^" add="op" addtext="xor"/></switch></addop><mulop><switch' +
  '><char text="*" add="op"/><char text="/" add="op"/><keyword text="DIV" a' +
  'dd="op" addtext="div"/><char text="%" add="op" addtext="mod"/><sequence>' +
  '<char text="&#38;"/><char text="&#38;" add="op" addtext="and"/></sequenc' +
  'e><sequence><char text="&#60;"/><char text="&#60;" skip="0" add="op" add' +
  'text="shl"/></sequence><sequence><char text="&#62;"/><char text="&#62;" ' +
  'skip="0" add="op" addtext="shr"/></sequence></switch></mulop><designator' +
  ' node="dsgn"><optional><char text="&#38;" add="addr"/></optional><ident ' +
  'add="node"/><optionalloop><switch><sequence><char text="."/><keyword add' +
  '="node"/></sequence><sequence><char text="[" add="node"/><exprlist err="' +
  'err2"/><char text="]" err="err8"/><optionalloop><char text="["/><exprlis' +
  't err="err2"/><char text="]" err="err8"/></optionalloop></sequence><sequ' +
  'ence><char text="("/><optional><exprlist/></optional><char text=")" err=' +
  '"err7"/></sequence></switch></optionalloop></designator><exprlist><loop ' +
  'text=","><expression/></loop></exprlist><statement><optionalswitch><sequ' +
  'ence><simplestatement/><char text=";" err="err5"/></sequence><structstmt' +
  '/><emptystmt/></optionalswitch></statement><emptystmt node="empty"><char' +
  ' text=";"/></emptystmt><stmtlist><loop><statement/></loop></stmtlist><si' +
  'mplestatement><switch><deletestmt/><varstmt/><returnstmt/><keyword text=' +
  '"BREAK" node="break"/><keyword text="CONTINUE" node="continue"/><keyword' +
  ' text="EXIT" node="exit"/><assignstmt/><callstmt/></switch></simplestate' +
  'ment><deletestmt node="delete"><keyword text="DELETE"/><designator err="' +
  'err2"/></deletestmt><assignstmt node="assignstmt"><designator/><switch><' +
  'sequence><char text="+" opt="1" add="modificator"/><char text="=" skip="' +
  '0"/></sequence><sequence><char text="-" opt="1" add="modificator"/><char' +
  ' text="=" skip="0"/></sequence><sequence><char text="*" opt="1" add="mod' +
  'ificator"/><char text="=" skip="0"/></sequence><sequence><char text="/" ' +
  'opt="1" add="modificator"/><char text="=" skip="0"/></sequence><char tex' +
  't="="/></switch><expression err="err2"/></assignstmt><callstmt node="cal' +
  'lstmt"><designator/><optionalswitch><sequence><char text="+"/><char text' +
  '="+" skip="0" add="modificator"/></sequence><sequence><char text="-"/><c' +
  'har text="-" skip="0" add="modificator"/></sequence></optionalswitch></c' +
  'allstmt><returnstmt node="return"><keyword text="RETURN"/><optional><exp' +
  'ression/></optional></returnstmt><structstmt><switch><compoundstmt/><con' +
  'ditionalstmt/><loopstmt/><trystmt/></switch></structstmt><compoundstmt n' +
  'ode="compoundstmt"><char text="{"/><optional><stmtlist/></optional><char' +
  ' text="}" err="err11"/></compoundstmt><conditionalstmt><switch><ifstmt/>' +
  '<casestmt/></switch></conditionalstmt><ifstmt node="ifstmt"><keyword tex' +
  't="IF"/><char text="(" err="err12"/><expression err="err2"/><char text="' +
  ')" err="err7"/><statement node="thenstmt"/><optional><keyword text="ELSE' +
  '"/><statement node="elsestmt"/></optional></ifstmt><casestmt node="cases' +
  'tmt"><keyword text="SWITCH"/><char text="(" err="err12"/><expression err' +
  '="err2"/><char text=")" err="err7"/><char text="{" err="err10"/><loop><c' +
  'aseselector/></loop><optional><keyword text="DEFAULT"/><char text=":" er' +
  'r="err4"/><statement/></optional><char text="}" err="err11"/></casestmt>' +
  '<caseselector node="caseselector"><keyword text="CASE"/><setconstructor ' +
  'err="err2"/><char text=":" err="err4"/><statement/></caseselector><loops' +
  'tmt><switch><repeatstmt/><whilestmt/><forstmt/></switch></loopstmt><repe' +
  'atstmt node="repeatstmt"><keyword text="DO"/><statement/><optional><char' +
  ' text=";"/></optional><keyword text="WHILE" err="err14"/><char text="(" ' +
  'err="err12"/><expression err="err2"/><empty add="inverse"/><char text=")' +
  '" err="err7"/><char text=";" err="err5"/></repeatstmt><whilestmt node="w' +
  'hilestmt"><keyword text="WHILE"/><char text="(" err="err12"/><expression' +
  ' err="err2"/><char text=")" err="err7"/><statement/></whilestmt><forstmt' +
  ' node="cppforstmt"><keyword text="FOR"/><char text="(" err="err12"/><for' +
  'compoundstmt/><char text=";" err="err5"/><expression err="err2"/><char t' +
  'ext=";" err="err5"/><forcompoundstmt/><char text=")" err="err7"/><statem' +
  'ent/></forstmt><forcompoundstmt node="compoundstmt"><loop text=","><fors' +
  'tmtitem/></loop></forcompoundstmt><forstmtitem><switch><assignstmt/><var' +
  'stmt/><callstmt/><empty node="empty"/></switch></forstmtitem><trystmt no' +
  'de="trystmt"><keyword text="TRY"/><compoundstmt/><switch err="err17"><se' +
  'quence><keyword text="FINALLY"/><compoundstmt node="finallystmt"/></sequ' +
  'ence><sequence><keyword text="EXCEPT"/><compoundstmt node="exceptstmt"/>' +
  '</sequence></switch></trystmt><functiondecl node="function"><functionhea' +
  'ding/><compoundstmt/></functiondecl><functionheading><ident add="type"/>' +
  '<ident add="name"/><formalparameters/></functionheading><formalparameter' +
  's node="parameters"><char text="("/><optionalloop text=","><formalparam/' +
  '></optionalloop><char text=")" err="err7"/></formalparameters><formalpar' +
  'am node="var"><ident add="type"/><optional><char text="&#38;" add="varpa' +
  'ram"/></optional><ident add="ident" err="err1"/><optional><initvalue/></' +
  'optional></formalparam></language>';


initialization
  fsRegisterLanguage('C++Script', CPP_GRAMMAR);

end.
