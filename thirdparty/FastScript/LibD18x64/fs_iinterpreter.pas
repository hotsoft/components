
{******************************************}
{                                          }
{             FastScript v1.9              }
{               Main module                }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_iinterpreter;

interface

{$I fs.inc}

uses
  SysUtils, Classes, fs_xml
{$IFDEF Delphi6}
, Variants
{$ENDIF}

, SyncObjs;


type
  TfsStatement = class;
  TfsDesignator = class;
  TfsCustomVariable = class;
  TfsClassVariable = class;
  TfsProcVariable = class;
  TfsMethodHelper = class;
  TfsPropertyHelper = class;
  TfsScript = class;

{ List of supported types. Actually all values are variants; types needed
  only to know what kind of operations can be implemented to the variable }

  TfsVarType = (fvtInt, fvtBool, fvtFloat, fvtChar, fvtString, fvtClass,
    fvtArray, fvtVariant, fvtEnum, fvtConstructor);

  TfsTypeRec = {$IFDEF Delphi12}{$ELSE}packed{$ENDIF} record
    Typ: TfsVarType;
{$IFDEF Delphi12}
    TypeName: String;
{$ELSE}
    TypeName: String[32];
{$ENDIF}
  end;

{ Events for get/set non-published property values and call methods }

  TfsGetValueEvent = function(Instance: TObject; ClassType: TClass;
    const PropName: String): Variant of object;
  TfsSetValueEvent = procedure(Instance: TObject; ClassType: TClass;
    const PropName: String; Value: Variant) of object;

  TfsGetValueNewEvent = function(Instance: TObject; ClassType: TClass;
    const PropName: String; Caler: TfsPropertyHelper): Variant of object;
  TfsSetValueNewEvent = procedure(Instance: TObject; ClassType: TClass;
    const PropName: String; Value: Variant; Caller: TfsPropertyHelper) of object;

  TfsCallMethodNewEvent = function(Instance: TObject; ClassType: TClass;
    const MethodName: String; Caller: TfsMethodHelper): Variant of object;
  TfsCallMethodEvent = function(Instance: TObject; ClassType: TClass;
    const MethodName: String; var Params: Variant): Variant of object;
  TfsRunLineEvent = procedure(Sender: TfsScript;
    const UnitName, SourcePos: String) of object;
  TfsGetUnitEvent = procedure(Sender: TfsScript;
    const UnitName: String; var UnitText: String) of object;
  TfsGetVariableValueEvent = function(VarName: String;
    VarTyp: TfsVarType; OldValue: Variant): Variant of object;

{ List of objects. Unlike TList, Destructor frees all objects in the list }

  TfsItemList = class(TObject)
  protected
    FItems: TList;
  protected
    procedure Clear; virtual;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(Item: TObject);
    function Count: Integer;
    procedure Remove(Item: TObject);
  end;


{ TfsScript represents the main script. It holds the list of local variables,
  constants, procedures in the Items. Entry point is the Statement.

  There is one global object fsGlobalUnit: TfsScript that holds all information
  about external classes, global variables, methods and constants. To use
  such globals, pass fsGlobalUnit to the TfsScript.Create.
  If you want, you can add classes/variables/methods to the TfsScript - they
  will be local for it and not visible in other programs.

  To execute a program, compile it first by calling Compile method. If error
  occurs, the ErrorMsg will contain the error message and ErrorPos will point
  to an error position in the source text. For example:

    if not Prg.Compile then
    begin
      ErrorLabel.Caption := Prg.ErrorMsg;
      Memo1.SetFocus;
      Memo1.Perform(EM_SETSEL, Prg.ErrorPos - 1, Prg.ErrorPos - 1);
      Memo1.Perform(EM_SCROLLCARET, 0, 0);
    end;

  If no errors occured, call Execute method to execute the program }


  TfsScript = class(TComponent)

  private
    FAddedBy: TObject;
    FBreakCalled: Boolean;
    FContinueCalled: Boolean;
    FExitCalled: Boolean;
    FErrorMsg: String;
    FErrorPos: String;
    FErrorUnit: String;
    FExtendedCharset: Boolean;
    FItems: TStringList;
    FIsRunning: Boolean;
    FLines: TStrings;
    FMacros: TStrings;
    FMainProg: Boolean;
    FOnGetILUnit: TfsGetUnitEvent;
    FOnGetUnit: TfsGetUnitEvent;
    FOnRunLine: TfsRunLineEvent;
    FOnGetVarValue: TfsGetVariableValueEvent;
    FParent: TfsScript;
    FProgRunning: TfsScript;
    FRTTIAdded: Boolean;
    FStatement: TfsStatement;
    FSyntaxType: String;
    FTerminated: Boolean;
    FUnitLines: TStringList;
    FIncludePath: TStrings;
    FUseClassLateBinding: Boolean;
    FEvaluteRiseError: Boolean;
    function GetItem(Index: Integer): TfsCustomVariable;
    procedure RunLine(const UnitName, Index: String);
    function GetVariables(Index: String): Variant;
    procedure SetVariables(Index: String; const Value: Variant);
    procedure SetLines(const Value: TStrings);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Add(const Name: String; Item: TObject);
    procedure AddCodeLine(const UnitName, APos: String);
    procedure AddRTTI;
    procedure Remove(Item: TObject);
    procedure RemoveItems(Owner: TObject);
    procedure Clear;
    procedure ClearItems(Owner: TObject);
    procedure ClearRTTI;
    function Count: Integer;

    { Adds a class. Example:
        with AddClass(TComponent, 'TPersistent') do
        begin
          ... add properties and methods ...
        end }
    function AddClass(AClass: TClass; const Ancestor: String): TfsClassVariable; dynamic;
    { Adds a constant. Example:
        AddConst('pi', 'Double', 3.14159) }
    procedure AddConst(const Name, Typ: String; const Value: Variant); dynamic;
    { Adds an enumeration constant. Example:
        AddEnum('TFontPitch', 'fpDefault, fpFixed, fpVariable')
      all constants gets type fvtEnum and values 0,1,2,3.. }
    procedure AddEnum(const Typ, Names: String); dynamic;
    { Adds an set constant. Example:
        AddEnumSet('TFontStyles', 'fsBold, fsItalic, fsUnderline')
      all constants gets type fvtEnum and values 1,2,4,8,.. }
    procedure AddEnumSet(const Typ, Names: String); dynamic;
    { Adds a form or datamodule with all its child components }
    procedure AddComponent(Form: TComponent); dynamic;
    procedure AddForm(Form: TComponent); dynamic;
    { Adds a method. Syntax is the same as for TfsClassVariable.AddMethod }
    procedure AddMethod(const Syntax: String; CallEvent: TfsCallMethodNewEvent;
      const Category: String = ''; const Description: String = ''); overload; dynamic;
    procedure AddMethod(const Syntax: String; CallEvent: TfsCallMethodEvent;
      const Category: String = ''; const Description: String = ''); overload; dynamic;
    { Adds an external object. Example:
        AddObject('Memo1', Memo1) }
    procedure AddObject(const Name: String; Obj: TObject); dynamic;
    { Adds a variable. Example:
        AddVariable('n', 'Variant', 0) }
    procedure AddVariable(const Name, Typ: String; const Value: Variant); dynamic;
    { Adds a type. Example:
        AddType('TDateTime', fvtFloat) }
    procedure AddType(const TypeName: String; ParentType: TfsVarType); dynamic;
    { Calls internal procedure or function. Example:
        val := CallFunction('ScriptFunc1', VarArrayOf([2003, 3])) }
    function CallFunction(const Name: String; const Params: Variant): Variant;
    function CallFunction1(const Name: String; var Params: Variant): Variant;
    function CallFunction2(const Func: TfsProcVariable; const Params: Variant): Variant;

    { Compiles the source code. Example:
        Lines.Text := 'begin i := 0 end.';
        SyntaxType := 'PascalScript';
        if Compile then ... }
    function Compile: Boolean;
    { Executes compiled code }
    procedure Execute;
    { Same as if Compile then Execute. Returns False if compile failed }
    function Run: Boolean;
    { terminates the script }
    procedure Terminate;
    { Evaluates an expression (useful for debugging purposes). Example:
        val := Evaluate('i+1'); }
    function Evaluate(const Expression: String): Variant;
    { checks whether is the line is executable }
    function IsExecutableLine(LineN: Integer; const UnitName: String = ''): Boolean;

    { Generates intermediate language. You can save it and compile later
      by SetILCode method }
    function GetILCode(Stream: TStream): Boolean;
    { Compiles intermediate language }
    function SetILCode(Stream: TStream): Boolean;

    function Find(const Name: String): TfsCustomVariable;
    function FindClass(const Name: String): TfsClassVariable;
    function FindLocal(const Name: String): TfsCustomVariable;

    property AddedBy: TObject read FAddedBy write FAddedBy;
    property ErrorMsg: String read FErrorMsg write FErrorMsg;
    property ErrorPos: String read FErrorPos write FErrorPos;
    property ErrorUnit: String read FErrorUnit write FErrorUnit;
    property ExtendedCharset: Boolean read FExtendedCharset write FExtendedCharset;
    property Items[Index: Integer]: TfsCustomVariable read GetItem;
    property IsRunning: Boolean read FIsRunning;
    property Macros: TStrings read FMacros;
    property MainProg: Boolean read FMainProg write FMainProg;
    property Parent: TfsScript read FParent write FParent;
    property ProgRunning: TfsScript read FProgRunning;
    property Statement: TfsStatement read FStatement;
    property Variables[Index: String]: Variant read GetVariables write SetVariables;
    property IncludePath: TStrings read FIncludePath;
    property UseClassLateBinding: Boolean read FUseClassLateBinding write FUseClassLateBinding;
    property EvaluteRiseError: Boolean read FEvaluteRiseError;
  published
    { the source code }
    property Lines: TStrings read FLines write SetLines;
    { the language name }
    property SyntaxType: String read FSyntaxType write FSyntaxType;
    property OnGetILUnit: TfsGetUnitEvent read FOnGetILUnit write FOnGetILUnit;
    property OnGetUnit: TfsGetUnitEvent read FOnGetUnit write FOnGetUnit;
    property OnRunLine: TfsRunLineEvent read FOnRunLine write FOnRunLine;
    property OnGetVarValue: TfsGetVariableValueEvent read FOnGetVarValue write FOnGetVarValue;
  end;


  TfsCustomExpression = class;
  TfsSetExpression = class;

{ Statements }

  TfsStatement = class(TfsItemList)
  private
    FProgram: TfsScript;
    FSourcePos: String;
    FUnitName: String;
    function GetItem(Index: Integer): TfsStatement;
    procedure RunLine;
  public
    constructor Create(AProgram: TfsScript; const UnitName, SourcePos: String); virtual;
    procedure Execute; virtual;
    property Items[Index: Integer]: TfsStatement read GetItem;
  end;

  TfsAssignmentStmt = class(TfsStatement)
  private
    FDesignator: TfsDesignator;
    FExpression: TfsCustomExpression;
    FVar: TfsCustomVariable;
    FExpr: TfsCustomVariable;
  public
    destructor Destroy; override;
    procedure Execute; override;
    procedure Optimize;
    property Designator: TfsDesignator read FDesignator write FDesignator;
    property Expression: TfsCustomExpression read FExpression write FExpression;
  end;

  TfsAssignPlusStmt = class(TfsAssignmentStmt)
  public
    procedure Execute; override;
  end;

  TfsAssignMinusStmt = class(TfsAssignmentStmt)
  public
    procedure Execute; override;
  end;

  TfsAssignMulStmt = class(TfsAssignmentStmt)
  public
    procedure Execute; override;
  end;

  TfsAssignDivStmt = class(TfsAssignmentStmt)
  public
    procedure Execute; override;
  end;

  TfsCallStmt = class(TfsStatement)
  private
    FDesignator: TfsDesignator;
    FModificator: String;
  public
    destructor Destroy; override;
    procedure Execute; override;
    property Designator: TfsDesignator read FDesignator write FDesignator;
    property Modificator: String read FModificator write FModificator;
  end;

  TfsIfStmt = class(TfsStatement)
  private
    FCondition: TfsCustomExpression;
    FElseStmt: TfsStatement;
  public
    constructor Create(AProgram: TfsScript; const UnitName, SourcePos: String); override;
    destructor Destroy; override;
    procedure Execute; override;
    property Condition: TfsCustomExpression read FCondition write FCondition;
    property ElseStmt: TfsStatement read FElseStmt write FElseStmt;
  end;

  TfsCaseSelector = class(TfsStatement)
  private
    FSetExpression: TfsSetExpression;
  public
    destructor Destroy; override;
    function Check(const Value: Variant): Boolean;
    property SetExpression: TfsSetExpression read FSetExpression write FSetExpression;
  end;

  TfsCaseStmt = class(TfsStatement)
  private
    FCondition: TfsCustomExpression;
    FElseStmt: TfsStatement;
  public
    constructor Create(AProgram: TfsScript; const UnitName, SourcePos: String); override;
    destructor Destroy; override;
    procedure Execute; override;
    property Condition: TfsCustomExpression read FCondition write FCondition;
    property ElseStmt: TfsStatement read FElseStmt write FElseStmt;
  end;

  TfsRepeatStmt = class(TfsStatement)
  private
    FCondition: TfsCustomExpression;
    FInverseCondition: Boolean;
  public
    destructor Destroy; override;
    procedure Execute; override;
    property Condition: TfsCustomExpression read FCondition write FCondition;
    property InverseCondition: Boolean read FInverseCondition write FInverseCondition;
  end;

  TfsWhileStmt = class(TfsStatement)
  private
    FCondition: TfsCustomExpression;
  public
    destructor Destroy; override;
    procedure Execute; override;
    property Condition: TfsCustomExpression read FCondition write FCondition;
  end;

  TfsForStmt = class(TfsStatement)
  private
    FBeginValue: TfsCustomExpression;
    FDown: Boolean;
    FEndValue: TfsCustomExpression;
    FVariable: TfsCustomVariable;
  public
    destructor Destroy; override;
    procedure Execute; override;
    property BeginValue: TfsCustomExpression read FBeginValue write FBeginValue;
    property Down: Boolean read FDown write FDown;
    property EndValue: TfsCustomExpression read FEndValue write FEndValue;
    property Variable: TfsCustomVariable read FVariable write FVariable;
  end;

  TfsVbForStmt = class(TfsStatement)
  private
    FBeginValue: TfsCustomExpression;
    FEndValue: TfsCustomExpression;
    FStep: TfsCustomExpression;
    FVariable: TfsCustomVariable;
  public
    destructor Destroy; override;
    procedure Execute; override;
    property BeginValue: TfsCustomExpression read FBeginValue write FBeginValue;
    property EndValue: TfsCustomExpression read FEndValue write FEndValue;
    property Step: TfsCustomExpression read FStep write FStep;
    property Variable: TfsCustomVariable read FVariable write FVariable;
  end;

  TfsCppForStmt = class(TfsStatement)
  private
    FFirstStmt: TfsStatement;
    FExpression: TfsCustomExpression;
    FSecondStmt: TfsStatement;
  public
    constructor Create(AProgram: TfsScript; const UnitName, SourcePos: String); override;
    destructor Destroy; override;
    procedure Execute; override;
    property FirstStmt: TfsStatement read FFirstStmt write FFirstStmt;
    property Expression: TfsCustomExpression read FExpression write FExpression;
    property SecondStmt: TfsStatement read FSecondStmt write FSecondStmt;
  end;

  TfsTryStmt = class(TfsStatement)
  private
    FIsExcept: Boolean;
    FExceptStmt: TfsStatement;
  public
    constructor Create(AProgram: TfsScript; const UnitName, SourcePos: String); override;
    destructor Destroy; override;
    procedure Execute; override;
    property IsExcept: Boolean read FIsExcept write FIsExcept;
    property ExceptStmt: TfsStatement read FExceptStmt write FExceptStmt;
  end;

  TfsBreakStmt = class(TfsStatement)
  public
    procedure Execute; override;
  end;

  TfsContinueStmt = class(TfsStatement)
  public
    procedure Execute; override;
  end;

  TfsExitStmt = class(TfsStatement)
  public
    procedure Execute; override;
  end;

  TfsWithStmt = class(TfsStatement)
  private
    FDesignator: TfsDesignator;
    FVariable: TfsCustomVariable;
  public
    destructor Destroy; override;
    procedure Execute; override;
    property Designator: TfsDesignator read FDesignator write FDesignator;
    property Variable: TfsCustomVariable read FVariable write FVariable;
  end;

{ TfsCustomVariable is the generic class for variables, constants, arrays,
  properties, methods and procedures/functions }

  TfsParamItem = class;

  TfsCustomVariable = class(TfsItemList)
  private
    FAddedBy: TObject;
    FIsMacro: Boolean;
    FIsReadOnly: Boolean;
    FName: String;
    FNeedResult: Boolean;
    FRefItem: TfsCustomVariable;
    FSourcePos: String;
    FSourceUnit: String;
    FTyp: TfsVarType;
    FTypeName: String;
    FUppercaseName: String;
    FValue: Variant;
    FOnGetVarValue: TfsGetVariableValueEvent;
    function GetParam(Index: Integer): TfsParamItem;
    function GetPValue: PVariant;
  protected
    procedure SetValue(const Value: Variant); virtual;
    function GetValue: Variant; virtual;
  public
    constructor Create(const AName: String; ATyp: TfsVarType;
      const ATypeName: String);
    function GetFullTypeName: String;
    function GetNumberOfRequiredParams: Integer;

    property AddedBy: TObject read FAddedBy write FAddedBy;
    property IsMacro: Boolean read FIsMacro write FIsMacro;
    property IsReadOnly: Boolean read FIsReadOnly write FIsReadOnly;
    property Name: String read FName;
    property NeedResult: Boolean read FNeedResult write FNeedResult;
    property Params[Index: Integer]: TfsParamItem read GetParam; default;
    property PValue: PVariant read GetPValue;
    property RefItem: TfsCustomVariable read FRefItem write FRefItem;
    property SourcePos: String read FSourcePos write FSourcePos;
    property SourceUnit: String read FSourceUnit write FSourceUnit;
    property Typ: TfsVarType read FTyp write FTyp;
    property TypeName: String read FTypeName write FTypeName;
    property Value: Variant read GetValue write SetValue;
    property OnGetVarValue: TfsGetVariableValueEvent read FOnGetVarValue write FOnGetVarValue;
  end;

{ TfsVariable represents constant or variable }

  TfsVariable = class(TfsCustomVariable)
  protected
    procedure SetValue(const Value: Variant); override;
    function GetValue: Variant; override;
  end;

  TfsTypeVariable = class(TfsCustomVariable)
  end;

  TfsStringVariable = class(TfsVariable)
  private
    FStr: String;
  protected
    procedure SetValue(const Value: Variant); override;
    function GetValue: Variant; override;
  end;

{ TfsParamItem describes one parameter of procedure/function/method call }

  TfsParamItem = class(TfsCustomVariable)
  private
    FDefValue: Variant;
    FIsOptional: Boolean;
    FIsVarParam: Boolean;
  public
    constructor Create(const AName: String; ATyp: TfsVarType;
      const ATypeName: String; AIsOptional, AIsVarParam: Boolean);
    property DefValue: Variant read FDefValue write FDefValue;
    property IsOptional: Boolean read FIsOptional;
    property IsVarParam: Boolean read FIsVarParam;
  end;

{ TfsProcVariable is a local internal procedure/function. Formal parameters
  are in Params, and statement to execute is in Prog: TfsScript }

  TfsProcVariable = class(TfsCustomVariable)
  private
    FExecuting: Boolean;
    FIsFunc: Boolean;
    FProgram: TfsScript;
  protected
    function GetValue: Variant; override;
  public
    constructor Create(const AName: String; ATyp: TfsVarType;
      const ATypeName: String; AParent: TfsScript; AIsFunc: Boolean = True);
    destructor Destroy; override;

    property Executing: Boolean read FExecuting;
    property IsFunc: Boolean read FIsFunc;
    property Prog: TfsScript read FProgram;
  end;

  TfsCustomExpression = class(TfsCustomVariable)
  end;

{ TfsCustomHelper is the generic class for the "helpers". Helper is
  a object that takes the data from the parent object and performs some
  actions. Helpers needed for properties, methods and arrays }

  TfsCustomHelper = class(TfsCustomVariable)
  private
    FParentRef: TfsCustomVariable;
    FParentValue: Variant;
    FProgram: TfsScript;
  public
    property ParentRef: TfsCustomVariable read FParentRef write FParentRef;

    property ParentValue: Variant read FParentValue write FParentValue;

    property Prog: TfsScript read FProgram write FProgram;
  end;

{ TfsArrayHelper performs access to array elements }

  TfsArrayHelper = class(TfsCustomHelper)
  protected
    procedure SetValue(const Value: Variant); override;
    function GetValue: Variant; override;
  public
    constructor Create(const AName: String; DimCount: Integer; Typ: TfsVarType;
      const TypeName: String);
    destructor Destroy; override;
  end;

{ TfsStringHelper performs access to string elements }

  TfsStringHelper = class(TfsCustomHelper)
  protected
    procedure SetValue(const Value: Variant); override;
    function GetValue: Variant; override;
  public
    constructor Create;
  end;

{ TfsPropertyHelper gets/sets the property value. Object instance is
  stored as Integer in the ParentValue property }

  TfsPropertyHelper = class(TfsCustomHelper)
  private
    FClassRef: TClass;
    FIsPublished: Boolean;
    FOnGetValue: TfsGetValueEvent;
    FOnSetValue: TfsSetValueEvent;
    FOnGetValueNew: TfsGetValueNewEvent;
    FOnSetValueNew: TfsSetValueNewEvent;
  protected
    procedure SetValue(const Value: Variant); override;
    function GetValue: Variant; override;
  public
    property IsPublished: Boolean read FIsPublished;
    property OnGetValue: TfsGetValueEvent read FOnGetValue write FOnGetValue;
    property OnSetValue: TfsSetValueEvent read FOnSetValue write FOnSetValue;
    property OnGetValueNew: TfsGetValueNewEvent read FOnGetValueNew write FOnGetValueNew;
    property OnSetValueNew: TfsSetValueNewEvent read FOnSetValueNew write FOnSetValueNew;
  end;

{ TfsMethodHelper gets/sets the method value. Object instance is
  stored as Integer in the ParentValue property. SetValue is called
  if the method represents the indexes property. }

  TfsMethodHelper = class(TfsCustomHelper)
  private
    FCategory: String;
    FClassRef: TClass;
    FDescription: String;
    FIndexMethod: Boolean;
    FOnCall: TfsCallMethodEvent;
    FOnCallNew: TfsCallMethodNewEvent;
    FSetValue: Variant;
    FSyntax: String;
    FVarArray: Variant;
    function GetVParam(Index: Integer): Variant;
    procedure SetVParam(Index: Integer; const Value: Variant);
  protected
    procedure SetValue(const Value: Variant); override;
    function GetValue: Variant; override;
  public
    constructor Create(const Syntax: String; Script: TfsScript);
    destructor Destroy; override;

    property Category: String read FCategory write FCategory;
    property Description: String read FDescription write FDescription;
    property IndexMethod: Boolean read FIndexMethod;
    property Params[Index: Integer]: Variant read GetVParam write SetVParam; default;
    property Syntax: String read FSyntax;
    property OnCall: TfsCallMethodEvent read FOnCall write FOnCall;
    property OnCallNew: TfsCallMethodNewEvent read FOnCallNew write FOnCallNew;
  end;

{ TfsComponentHelper gets the component inside an owner, e.g. Form1.Button1 }

  TfsComponentHelper = class(TfsCustomHelper)
  private
    FComponent: TComponent;
  protected
    function GetValue: Variant; override;
  public
    constructor Create(Component: TComponent);
  end;

{ Event helper maintains VCL events }

  TfsCustomEvent = class(TObject)
  private
    FHandler: TfsProcVariable;
    FInstance: TObject;
  protected
    procedure CallHandler(Params: array of const);
  public
    constructor Create(AObject: TObject; AHandler: TfsProcVariable); virtual;
    function GetMethod: Pointer; virtual; abstract;
    property Handler: TfsProcVariable read FHandler;
    property Instance: TObject read FInstance;
  end;

  TfsEventClass = class of TfsCustomEvent;

  TfsEventHelper = class(TfsCustomHelper)
  private
    FClassRef: TClass;
    FEvent: TfsEventClass;
  protected
    procedure SetValue(const Value: Variant); override;
    function GetValue: Variant; override;
  public
    constructor Create(const Name: String; AEvent: TfsEventClass);
  end;

{ TfsClassVariable holds information about external class. Call to
  AddXXX methods adds properties and methods items to the items list }

  TfsClassVariable = class(TfsCustomVariable)
  private
    FAncestor: String;
    FClassRef: TClass;
    FDefProperty: TfsCustomHelper;
    FMembers: TfsItemList;
    FProgram: TfsScript;
    procedure AddComponent(c: TComponent);
    procedure AddPublishedProperties(AClass: TClass);
    function GetMembers(Index: Integer): TfsCustomHelper;
    function GetMembersCount: Integer;
  protected
    function GetValue: Variant; override;
  public
    constructor Create(AClass: TClass; const Ancestor: String);
    destructor Destroy; override;

    { Adds a contructor. Example:
        AddConstructor('constructor Create(AOwner: TComponent)', MyCallEvent) }
    procedure AddConstructor(Syntax: String; CallEvent: TfsCallMethodNewEvent); overload;
    procedure AddConstructor(Syntax: String; CallEvent: TfsCallMethodEvent); overload;
    { Adds a property. Example:
        AddProperty('Font', 'TFont', MyGetEvent, MySetEvent) }
    procedure AddProperty(const Name, Typ: String;
      GetEvent: TfsGetValueEvent; SetEvent: TfsSetValueEvent = nil);
    procedure AddPropertyEx(const Name, Typ: String;
      GetEvent: TfsGetValueNewEvent; SetEvent: TfsSetValueNewEvent = nil);
    { Adds a default property. Example:
        AddDefaultProperty('Cell', 'Integer,Integer', 'String', MyCallEvent)
      will describe real property Cell[Index1, Index2: Integer]: String
      Note: in the CallEvent you'll get the MethodName parameter
      'CELL.GET' and 'CELL.SET', not 'CELL' }
    procedure AddDefaultProperty(const Name, Params, Typ: String;
      CallEvent: TfsCallMethodNewEvent; AReadOnly: Boolean = False); overload;
    procedure AddDefaultProperty(const Name, Params, Typ: String;
      CallEvent: TfsCallMethodEvent; AReadOnly: Boolean = False); overload;
    { Adds an indexed property. Example and behavior are the same as
      for AddDefaultProperty }
    procedure AddIndexProperty(const Name, Params, Typ: String;
      CallEvent: TfsCallMethodNewEvent; AReadOnly: Boolean = False); overload;
    procedure AddIndexProperty(const Name, Params, Typ: String;
      CallEvent: TfsCallMethodEvent; AReadOnly: Boolean = False); overload;
    { Adds a method. Example:
        AddMethod('function IsVisible: Boolean', MyCallEvent) }
    procedure AddMethod(const Syntax: String; CallEvent: TfsCallMethodNewEvent); overload;
    procedure AddMethod(const Syntax: String; CallEvent: TfsCallMethodEvent); overload;
    { Adds an event. Example:
        AddEvent('OnClick', TfsNotifyEvent) }
    procedure AddEvent(const Name: String; AEvent: TfsEventClass);
    function Find(const Name: String): TfsCustomHelper;

    property Ancestor: String read FAncestor;
    property ClassRef: TClass read FClassRef;
    property DefProperty: TfsCustomHelper read FDefProperty;
    property Members[Index: Integer]: TfsCustomHelper read GetMembers;
    property MembersCount: Integer read GetMembersCount;
  end;

{ TfsDesignator holds the parts of function/procedure/variable/method/property
  calls. Items are of type TfsDesignatorItem.
  For example, Table1.FieldByName('N').AsString[1] will be represented as
    items[0]: name 'Table1', no params
    items[1]: name 'FieldByName', 1 param: 'N'
    items[2]: name 'AsString', no params
    items[3]: name '[', 1 param: '1'
  Call to Value calculates and returns the designator value }

  TfsDesignatorKind = (dkOther, dkVariable, dkStringArray, dkArray);

  TfsDesignatorItem = class(TfsItemList)
  private
    FFlag: Boolean;          { needed for index methods }
    FRef: TfsCustomVariable;
    FSourcePos: String;
    function GetItem(Index: Integer): TfsCustomExpression;
  public
    property Items[Index: Integer]: TfsCustomExpression read GetItem; default;
    property Flag: Boolean read FFlag write FFlag;
    property Ref: TfsCustomVariable read FRef write FRef;
    property SourcePos: String read FSourcePos write FSourcePos;
  end;

  TfsDesignator = class(TfsCustomVariable)
  private
    FKind: TfsDesignatorKind;
    FMainProg: TfsScript;
    FProgram: TfsScript;
    FRef1: TfsCustomVariable;
    FRef2: TfsDesignatorItem;
    FLateBindingXmlSource: TfsXMLItem;
    procedure CheckLateBinding;
    function DoCalc(const AValue: Variant; Flag: Boolean): Variant;
    function GetItem(Index: Integer): TfsDesignatorItem;
  protected
    function GetValue: Variant; override;
    procedure SetValue(const Value: Variant); override;
  public
    constructor Create(AProgram: TfsScript);
    destructor Destroy; override;
    procedure Borrow(ADesignator: TfsDesignator);
    procedure Finalize;
    property Items[Index: Integer]: TfsDesignatorItem read GetItem; default;
    property Kind: TfsDesignatorKind read FKind;
    property LateBindingXmlSource: TfsXMLItem read FLateBindingXmlSource
      write FLateBindingXmlSource;
  end;

  TfsVariableDesignator = class(TfsDesignator)
  protected
    function GetValue: Variant; override;
    procedure SetValue(const Value: Variant); override;
  end;

  TfsStringDesignator = class(TfsDesignator)
  protected
    function GetValue: Variant; override;
    procedure SetValue(const Value: Variant); override;
  end;

  TfsArrayDesignator = class(TfsDesignator)
  protected
    function GetValue: Variant; override;
    procedure SetValue(const Value: Variant); override;
  end;

{ TfsSetExpression represents a set of values like ['_', '0'..'9'] }

  TfsSetExpression = class(TfsCustomVariable)
  private
    function GetItem(Index: Integer): TfsCustomExpression;
  protected
    function GetValue: Variant; override;
  public
    function Check(const Value: Variant): Boolean;
    property Items[Index: Integer]: TfsCustomExpression read GetItem;
  end;

  TfsRTTIModule = class(TObject)
  private
    FScript: TfsScript;
  public
    constructor Create(AScript: TfsScript); virtual;
    property Script: TfsScript read FScript;
  end;


function fsGlobalUnit: TfsScript;
function fsRTTIModules: TList;


implementation

uses
  TypInfo, fs_isysrtti, fs_iexpression, fs_iparser, fs_iilparser,
  fs_itools, fs_iconst
{$IFDEF CLX}
, QForms, QDialogs, Types
{$ELSE}
  {$IFDEF FPC}
    {$IFDEF NOFORMS}
      // nothing
    {$ELSE}
      , Forms, Dialogs
    {$ENDIF}
  {$ELSE}
    , Windows
    {$IFDEF NOFORMS}
      , Messages
    {$ELSE}
      , Forms, Dialogs
    {$ENDIF}
  {$ENDIF}
{$ENDIF};

var
  FGlobalUnit: TfsScript = nil;
  FGlobalUnitDestroyed: Boolean = False;
  FRTTIModules: TList = nil;
  FRTTIModulesDestroyed: Boolean = False;


{ TfsItemsList }

constructor TfsItemList.Create;
begin
  FItems := TList.Create;
end;

destructor TfsItemList.Destroy;
begin
  Clear;
  FItems.Free;
  inherited;
end;

procedure TfsItemList.Clear;
begin
  while FItems.Count > 0 do
  begin
    TObject(FItems[0]).Free;
    FItems.Delete(0);
  end;
end;

function TfsItemList.Count: Integer;
begin
  Result := FItems.Count;
end;

procedure TfsItemList.Add(Item: TObject);
begin
  FItems.Add(Item);
end;

procedure TfsItemList.Remove(Item: TObject);
begin
  FItems.Remove(Item);
end;


{ TfsCustomVariable }

constructor TfsCustomVariable.Create(const AName: String; ATyp: TfsVarType;
  const ATypeName: String);
begin
  inherited Create;
  FName := AName;
  FTyp := ATyp;
  FTypeName := ATypeName;
  FValue := Null;
  FNeedResult := True;
  FUppercaseName := AnsiUppercase(FName);
end;

function TfsCustomVariable.GetValue: Variant;
begin
  Result := FValue;
end;

procedure TfsCustomVariable.SetValue(const Value: Variant);
begin
  if not FIsReadOnly then
    FValue := Value;
end;

function TfsCustomVariable.GetParam(Index: Integer): TfsParamItem;
begin
  Result := FItems[Index];
end;

function TfsCustomVariable.GetPValue: PVariant;
begin
  Result := @FValue;
end;

function TfsCustomVariable.GetFullTypeName: String;
begin
  case FTyp of
    fvtInt: Result := 'Integer';
    fvtBool: Result := 'Boolean';
    fvtFloat: Result := 'Extended';
    fvtChar: Result := 'Char';
    fvtString: Result := 'String';
    fvtClass: Result := FTypeName;
    fvtArray: Result := 'Array';
    fvtEnum: Result := FTypeName;
  else
    Result := 'Variant';
  end;
end;

function TfsCustomVariable.GetNumberOfRequiredParams: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to Count - 1 do
    if not Params[i].IsOptional then
      Inc(Result);
end;


{ TfsStringVariable }

function TfsStringVariable.GetValue: Variant;
begin
  Result := FStr;
  if Assigned(FOnGetVarValue) then
  begin
    Result := FOnGetVarValue(FName, FTyp, FStr);
    if Result = null then Result := FStr;
  end;
end;

procedure TfsStringVariable.SetValue(const Value: Variant);
begin
  FStr := Value;
end;


{ TfsParamItem }

constructor TfsParamItem.Create(const AName: String; ATyp: TfsVarType;
  const ATypeName: String; AIsOptional, AIsVarParam: Boolean);
begin
  inherited Create(AName, ATyp, ATypeName);
  FIsOptional := AIsOptional;
  FIsVarParam := AIsVarParam;
  FDefValue := Null;
end;


{ TfsProcVariable }

constructor TfsProcVariable.Create(const AName: String; ATyp: TfsVarType;
  const ATypeName: String; AParent: TfsScript; AIsFunc: Boolean = True);
begin
  inherited Create(AName, ATyp, ATypeName);
  FIsReadOnly := True;
  FIsFunc := AIsFunc;
  FProgram := TfsScript.Create(nil);
  FProgram.Parent := AParent;
  if FProgram.Parent <> nil then
    FProgram.UseClassLateBinding := FProgram.Parent.UseClassLateBinding;
  if FIsFunc then
  begin
    FRefItem := TfsVariable.Create('Result', ATyp, ATypeName);
    FProgram.Add('Result', FRefItem);
  end;
end;



destructor TfsProcVariable.Destroy;
var
  i: Integer;
begin
  { avoid destroying the param objects twice }
  for i := 0 to Count - 1 do
    FProgram.FItems.Delete(FProgram.FItems.IndexOfObject(Params[i]));

  FProgram.Free;
  inherited;
end;

function TfsProcVariable.GetValue: Variant;
var
  Temp: Boolean;
  ParentProg, SaveProg: TfsScript;
begin
  Temp := FExecuting;
  FExecuting := True;
  if FIsFunc then
    FRefItem.Value := Unassigned;

  ParentProg := FProgram;
  SaveProg := nil;
  while ParentProg <> nil do
    if ParentProg.FMainProg then
    begin
      SaveProg := ParentProg.FProgRunning;
      ParentProg.FProgRunning := FProgram;
      break;
    end
    else
      ParentProg := ParentProg.FParent;

  try
// avoid trial message
// same as FProgram.Execute
    with FProgram do
    begin
      FExitCalled := False;
      FTerminated := False;
      FIsRunning := True;
      try
        FStatement.Execute;
      finally
        FExitCalled := False;
        FTerminated := False;
        FIsRunning := False;
      end;
    end;
//

    if FIsFunc then
      Result := FRefItem.Value else
      Result := Null;
  finally
    if ParentProg <> nil then
      ParentProg.FProgRunning := SaveProg;
    FExecuting := Temp;
  end;
end;


{ TfsPropertyHelper }

function TfsPropertyHelper.GetValue: Variant;
var
  p: PPropInfo;
  Instance: TObject;
begin

  Result := Null;
  Instance := TObject(Integer(ParentValue));

  if FIsPublished and Assigned(Instance) then
  begin
    p := GetPropInfo(Instance.ClassInfo, Name);
    if p <> nil then
      case p.PropType^.Kind of
        tkInteger, tkSet, tkEnumeration, tkClass:
          Result := GetOrdProp(Instance, p);

        tkFloat:
          Result := GetFloatProp(Instance, p);

//        tkString, tkLString, tkWString{$IFDEF Delphi12}, tkUString{$ENDIF}:
//          Result := GetStrProp(Instance, p);

        tkChar, tkWChar:
          Result := Chr(GetOrdProp(Instance, p));

        tkVariant:
          Result := GetVariantProp(Instance, p);
{$IFDEF Delphi12}
        tkString, tkLString:
          Result := GetAnsiStrProp(Instance, p);
        tkWString, tkUString:
          Result := GetUnicodeStrProp(Instance, p);
{$ELSE}
        tkString, tkLString, tkWString:
          Result := GetStrProp(Instance, p);
{$ENDIF}
      end;
  end
  else if Assigned(FOnGetValue) then
    Result := FOnGetValue(Instance, FClassRef, FUppercaseName)
  else if Assigned(FOnGetValueNew) then
    Result := FOnGetValueNew(Instance, FClassRef, FUppercaseName, Self);

  if Typ = fvtBool then
    if Result = 0 then
      Result := False else
      Result := True;

end;

procedure TfsPropertyHelper.SetValue(const Value: Variant);
var
  p: PPropInfo;
  Instance: TObject;
  IntVal: Integer;
begin

  if IsReadOnly then Exit;
  Instance := TObject(Integer(ParentValue));



  if FIsPublished then
  begin
    p := GetPropInfo(Instance.ClassInfo, Name);
    if p <> nil then
      case p.PropType^.Kind of
        tkInteger, tkSet, tkEnumeration, tkClass:
        begin
{$IFNDEF Delphi4}
          if VarType(Value) <> varInteger then
          begin
            SetSetProp(Instance, p, fsSetToString(p, Value));
          end
          else
{$ENDIF}
          begin
            if Typ = fvtBool then
              if Value = True then
                IntVal := 1 else
                IntVal := 0
            else
              IntVal := Integer(Value);
            SetOrdProp(Instance, p, IntVal);
          end;
        end;

        tkFloat:
          SetFloatProp(Instance, p, Extended(Value));

//        tkString, tkLString:
//          SetStrProp(Instance, p, String(Value));

//        tkWString{$IFDEF Delphi12}, tkUString{$ENDIF}:
//          SetStrProp(Instance, p, WideString(Value));

        tkChar, tkWChar:
          SetOrdProp(Instance, p, Ord(String(Value)[1]));

        tkVariant:
          SetVariantProp(Instance, p, Value);

{$IFDEF Delphi12}
        tkString, tkLString:
          SetAnsiStrProp(Instance, p, AnsiString(Value));
        tkWString, tkUString:
          SetUnicodeStrProp(Instance, p, WideString(Value));
{$ELSE}
        tkString, tkLString, tkWString:
          SetStrProp(Instance, p, String(Value));
{$ENDIF}
      end;
  end
  else if Assigned(FOnSetValue) then
    FOnSetValue(Instance, FClassRef, FUppercaseName, Value)
  else if Assigned(FOnSetValueNew) then
    FOnSetValueNew(Instance, FClassRef, FUppercaseName, Value, Self);

end;


{ TfsMethodHelper }

constructor TfsMethodHelper.Create(const Syntax: String; Script: TfsScript);
var
  i: Integer;
  v: TfsCustomVariable;
begin
  v := ParseMethodSyntax(Syntax, Script);
  inherited Create(v.Name, v.Typ, v.TypeName);
  FIsReadOnly := True;
  FSyntax := Syntax;
  IsMacro := v.IsMacro;

  { copying params }
  for i := 0 to v.Count - 1 do
    Add(v.Params[i]);
  while v.Count > 0 do
    v.FItems.Delete(0);
  v.Free;

  // FPC and Delphi do this different way. FPC implementation more honest, so
  // if Count = 0 then we get exception about bad bounds
  if Count > 0 then
    FVarArray := VarArrayCreate([0, Count - 1], varVariant);
end;

destructor TfsMethodHelper.Destroy;
begin
  FVarArray := Null;
  inherited;
end;

function TfsMethodHelper.GetVParam(Index: Integer): Variant;
begin
  if Index = Count then
    Result := FSetValue
  else
    Result := TfsParamItem(FItems[Index]).Value;
end;

procedure TfsMethodHelper.SetVParam(Index: Integer; const Value: Variant);
begin
  TfsParamItem(FItems[Index]).Value := Value;
end;

function TfsMethodHelper.GetValue: Variant;
var
  i: Integer;
  Instance: TObject;
begin
  if Assigned(FOnCall) then
  begin
    for i := 0 to Count - 1 do
      FVarArray[i] := inherited Params[i].Value;

    Instance := nil;
    if not VarIsNull(ParentValue) then
      Instance := TObject(Integer(ParentValue));

    if FIndexMethod then
      Result := FOnCall(Instance, FClassRef, FUppercaseName + '.GET', FVarArray)
    else
      Result := FOnCall(Instance, FClassRef, FUppercaseName, FVarArray);
    for i := 0 to Count - 1 do
      if inherited Params[i].IsVarParam then
        inherited Params[i].Value := FVarArray[i];
  end
  else if Assigned(FOnCallNew) then
  begin
    Instance := nil;
    if not VarIsNull(ParentValue) then
      Instance := TObject(Integer(ParentValue));

    if FIndexMethod then
      Result := FOnCallNew(Instance, FClassRef, FUppercaseName + '.GET', Self)
    else
      Result := FOnCallNew(Instance, FClassRef, FUppercaseName, Self);
  end
  else
    Result := 0;
end;

procedure TfsMethodHelper.SetValue(const Value: Variant);
var
  v: Variant;
  i: Integer;
begin
  if FIndexMethod then
    if Assigned(FOnCall) then
    begin
      v := VarArrayCreate([0, Count], varVariant);
      for i := 0 to Count - 1 do
        v[i] := inherited Params[i].Value;
      v[Count] := Value;

      FOnCall(TObject(Integer(ParentValue)), FClassRef, FUppercaseName + '.SET', v);
      v := Null;
    end
    else if Assigned(FOnCallNew) then
    begin
      FSetValue := Value;
      FOnCallNew(TObject(Integer(ParentValue)), FClassRef, FUppercaseName + '.SET', Self);
      FSetValue := Null;
    end;
end;


{ TfsComponentHelper }

constructor TfsComponentHelper.Create(Component: TComponent);
begin
  inherited Create(Component.Name, fvtClass, Component.ClassName);
  FComponent := Component;
end;

function TfsComponentHelper.GetValue: Variant;
begin
  Result := Integer(FComponent);
end;


{ TfsEventHelper }

constructor TfsEventHelper.Create(const Name: String; AEvent: TfsEventClass);
begin
  inherited Create(Name, fvtString, '');
  FEvent := AEvent;
end;

function TfsEventHelper.GetValue: Variant;
begin
  Result := '';
end;

procedure TfsEventHelper.SetValue(const Value: Variant);
var
  Instance: TPersistent;
  v: TfsCustomVariable;
  e: TfsCustomEvent;
  p: PPropInfo;
  m: TMethod;
begin

  Instance := TPersistent(Integer(ParentValue));
  if VarToStr(Value) = '0' then
  begin
    m.Code := nil;
    m.Data := nil;
  end
  else
  begin
    v := FProgram.Find(Value);
    if (v = nil) or not (v is TfsProcVariable) then
      raise Exception.Create(SEventError);

    e := TfsCustomEvent(FEvent.NewInstance);
    e.Create(Instance, TfsProcVariable(v));
    FProgram.Add('', e);
    m.Code := e.GetMethod;
    m.Data := e;
  end;

  p := GetPropInfo(Instance.ClassInfo, Name);
  SetMethodProp(Instance, p, m);
end;


{ TfsClassVariable }

constructor TfsClassVariable.Create(AClass: TClass; const Ancestor: String);
begin
  inherited Create(AClass.ClassName, fvtClass, AClass.ClassName);
  FMembers := TfsItemList.Create;
  FAncestor := Ancestor;
  FClassRef := AClass;

  AddPublishedProperties(AClass);
  Add(TfsParamItem.Create('', fvtVariant, '', True, False));
end;

destructor TfsClassVariable.Destroy;
begin
  FMembers.Free;
  inherited;
end;

function TfsClassVariable.GetMembers(Index: Integer): TfsCustomHelper;
begin
  Result := FMembers.FItems[Index];
end;

function TfsClassVariable.GetMembersCount: Integer;
begin
  Result := FMembers.Count;
end;

procedure TfsClassVariable.AddConstructor(Syntax: String; CallEvent: TfsCallMethodEvent);
var
  i: Integer;
begin
  i := Pos(' ', Syntax);
  Delete(Syntax, 1, i - 1);
  Syntax := 'function' + Syntax + ': ' + 'Constructor';
  AddMethod(Syntax, CallEvent);
end;

procedure TfsClassVariable.AddConstructor(Syntax: String;
  CallEvent: TfsCallMethodNewEvent);
var
  i: Integer;
begin
  i := Pos(' ', Syntax);
  Delete(Syntax, 1, i - 1);
  Syntax := 'function' + Syntax + ': ' + 'Constructor';
  AddMethod(Syntax, CallEvent);
end;

procedure TfsClassVariable.AddMethod(const Syntax: String; CallEvent: TfsCallMethodEvent);
var
  m: TfsMethodHelper;
begin
  m := TfsMethodHelper.Create(Syntax, FProgram);
  m.FOnCall := CallEvent;
  m.FClassRef := FClassRef;
  FMembers.Add(m);
end;

procedure TfsClassVariable.AddMethod(const Syntax: String; CallEvent: TfsCallMethodNewEvent);
var
  m: TfsMethodHelper;
begin
  m := TfsMethodHelper.Create(Syntax, FProgram);
  m.FOnCallNew := CallEvent;
  m.FClassRef := FClassRef;
  FMembers.Add(m);
end;

procedure TfsClassVariable.AddEvent(const Name: String; AEvent: TfsEventClass);
var
  e: TfsEventHelper;
begin
  e := TfsEventHelper.Create(Name, AEvent);
  e.FClassRef := FClassRef;
  FMembers.Add(e);
end;

procedure TfsClassVariable.AddProperty(const Name, Typ: String;
  GetEvent: TfsGetValueEvent; SetEvent: TfsSetValueEvent);
var
  p: TfsPropertyHelper;
begin
  p := TfsPropertyHelper.Create(Name, StrToVarType(Typ, FProgram), Typ);
  p.FClassRef := FClassRef;
  p.FOnGetValue := GetEvent;
  p.FOnSetValue := SetEvent;
  p.IsReadOnly := not Assigned(SetEvent);
  FMembers.Add(p);
end;

procedure TfsClassVariable.AddPropertyEx(const Name, Typ: String;
  GetEvent: TfsGetValueNewEvent; SetEvent: TfsSetValueNewEvent);
var
  p: TfsPropertyHelper;
begin
  p := TfsPropertyHelper.Create(Name, StrToVarType(Typ, FProgram), Typ);
  p.FClassRef := FClassRef;
  p.FOnGetValueNew := GetEvent;
  p.FOnSetValueNew := SetEvent;
  p.IsReadOnly := not Assigned(SetEvent);
  FMembers.Add(p);
end;

procedure TfsClassVariable.AddDefaultProperty(const Name, Params, Typ: String;
  CallEvent: TfsCallMethodEvent; AReadOnly: Boolean = False);
begin
  AddIndexProperty(Name, Params, Typ, CallEvent, AReadOnly);
  FDefProperty := Members[FMembers.Count - 1];
end;

procedure TfsClassVariable.AddDefaultProperty(const Name, Params,
  Typ: String; CallEvent: TfsCallMethodNewEvent; AReadOnly: Boolean);
begin
  AddIndexProperty(Name, Params, Typ, CallEvent, AReadOnly);
  FDefProperty := Members[FMembers.Count - 1];
end;

procedure TfsClassVariable.AddIndexProperty(const Name, Params,
  Typ: String; CallEvent: TfsCallMethodEvent; AReadOnly: Boolean = False);
var
  i: Integer;
  sl: TStringList;
  s: String;
begin
  sl := TStringList.Create;
  sl.CommaText := Params;

  s := '';
  for i := 0 to sl.Count - 1 do
    s := s + 'p' + IntToStr(i) + ': ' + sl[i] + '; ';

  SetLength(s, Length(s) - 2);
  try
    AddMethod('function ' + Name + '(' + s + '): ' + Typ, CallEvent);
    with TfsMethodHelper(Members[FMembers.Count - 1]) do
    begin
      IsReadOnly := AReadOnly;
      FIndexMethod := True;
    end;
  finally
    sl.Free;
  end;
end;

procedure TfsClassVariable.AddIndexProperty(const Name, Params,
  Typ: String; CallEvent: TfsCallMethodNewEvent; AReadOnly: Boolean);
var
  i: Integer;
  sl: TStringList;
  s: String;
begin
  sl := TStringList.Create;
  sl.CommaText := Params;

  s := '';
  for i := 0 to sl.Count - 1 do
    s := s + 'p' + IntToStr(i) + ': ' + sl[i] + '; ';

  SetLength(s, Length(s) - 2);
  try
    AddMethod('function ' + Name + '(' + s + '): ' + Typ, CallEvent);
    with TfsMethodHelper(Members[FMembers.Count - 1]) do
    begin
      IsReadOnly := AReadOnly;
      FIndexMethod := True;
    end;
  finally
    sl.Free;
  end;
end;

procedure TfsClassVariable.AddComponent(c: TComponent);
begin
  FMembers.Add(TfsComponentHelper.Create(c));
end;

procedure TfsClassVariable.AddPublishedProperties(AClass: TClass);
var
  TypeInfo: PTypeInfo;
  PropCount: Integer;
  PropList: PPropList;
  i: Integer;
  cl: String;
  t: TfsVarType;
  FClass: TClass;
  p: TfsPropertyHelper;
begin
  TypeInfo := AClass.ClassInfo;
  if TypeInfo = nil then Exit;

  PropCount := GetPropList(TypeInfo, tkProperties, nil);
  GetMem(PropList, PropCount * SizeOf(PPropInfo));
  GetPropList(TypeInfo, tkProperties, PropList);

  try
    for i := 0 to PropCount - 1 do
    begin
      t := fvtInt;
      cl := '';

      case PropList[i].PropType^.Kind of
        tkInteger:
          t := fvtInt;
        tkSet:
          begin
            t := fvtEnum;
            cl := String(PropList[i].PropType^.Name);
          end;
        tkEnumeration:
          begin
            t := fvtEnum;
            cl := String(PropList[i].PropType^.Name);
            if (CompareText(cl, 'Boolean') = 0) or (CompareText(cl, 'bool') = 0) then
              t := fvtBool;
          end;
        tkFloat:
          t := fvtFloat;
        tkChar, tkWChar:
          t := fvtChar;
        tkString, tkLString, tkWString{$IFDEF Delphi12}, tkUString{$ENDIF}:
          t := fvtString;
        tkVariant:
          t := fvtVariant;
        tkClass:
          begin
            t := fvtClass;
          {$IFNDEF FPC}
            FClass := GetTypeData(PropList[i].PropType^).ClassType;
          {$ELSE}
            FClass := GetTypeData(PropList[i].PropType).ClassType;
          {$ENDIF}
            cl := FClass.ClassName;
          end;
      end;

      p := TfsPropertyHelper.Create(String(PropList[i].Name), t, cl);
      p.FClassRef := FClassRef;
      p.FIsPublished := True;
      FMembers.Add(p);
    end;

  finally
    FreeMem(PropList, PropCount * SizeOf(PPropInfo));
  end;
end;

function TfsClassVariable.Find(const Name: String): TfsCustomHelper;
var
  cl: TfsClassVariable;

  function DoFind(const Name: String): TfsCustomHelper;
  var
    i: Integer;
  begin
    Result := nil;
    for i := 0 to FMembers.Count - 1 do
      if CompareText(Name, Members[i].Name) = 0 then
      begin
        Result := Members[i];
        Exit;
      end;
  end;

begin
  Result := DoFind(Name);
  if Result = nil then
  begin
    cl := FProgram.FindClass(FAncestor);
    if cl <> nil then
      Result := cl.Find(Name);
  end;
end;

function TfsClassVariable.GetValue: Variant;
begin
  if Params[0].Value = Null then
    Result := Integer(FClassRef.NewInstance) else        { constructor call }
    Result := Params[0].Value;                           { typecast }
  Params[0].Value := Null;
end;


{ TfsDesignatorItem }

function TfsDesignatorItem.GetItem(Index: Integer): TfsCustomExpression;
begin
  Result := FItems[Index];
end;


{ TfsDesignator }

constructor TfsDesignator.Create(AProgram: TfsScript);
var
  ParentProg: TfsScript;
begin
  inherited Create('', fvtInt, '');
  FProgram := AProgram;
  FMainProg := FProgram;
  ParentProg := FProgram;
  while ParentProg <> nil do
    if ParentProg.FMainProg then
    begin
      FMainProg := ParentProg;
      break;
    end
    else
      ParentProg := ParentProg.FParent;
  FProgram.UseClassLateBinding := FMainProg.UseClassLateBinding;
end;

destructor TfsDesignator.Destroy;
begin
  if FLateBindingXMLSource <> nil then
    FLateBindingXMLSource.Free;
  inherited;
end;

procedure TfsDesignator.Borrow(ADesignator: TfsDesignator);
var
  SaveItems: TList;
begin
  SaveItems := FItems;
  FItems := ADesignator.FItems;
  ADesignator.FItems := SaveItems;
  FKind := ADesignator.FKind;
  FRef1 := ADesignator.FRef1;
  FRef2 := ADesignator.FRef2;
  FTyp := ADesignator.Typ;
  FTypeName := ADesignator.TypeName;
  FIsReadOnly := ADesignator.IsReadOnly;
  RefItem := ADesignator.RefItem;
end;

procedure TfsDesignator.Finalize;
var
  Item: TfsDesignatorItem;
begin
  Item := Items[Count - 1];
  FTyp := Item.Ref.Typ;
  FTypeName := Item.Ref.TypeName;
  if FTyp = fvtConstructor then
  begin
    FTyp := fvtClass;
    FTypeName := Items[Count - 2].Ref.TypeName;
  end;

  FIsReadOnly := Item.Ref.IsReadOnly;

  { speed optimization for access to single variable, string element or array }
  if (Count = 1) and (Items[0].Ref is TfsVariable) then
  begin
    RefItem := Items[0].Ref;
    FKind := dkVariable;
  end
  else if (Count = 2) and (Items[0].Ref is TfsStringVariable) then
  begin
    RefItem := Items[0].Ref;
    FRef1 := Items[1][0];
    FKind := dkStringArray;
  end
  else if (Count = 2) and (Items[0].Ref is TfsVariable) and (Items[0].Ref.Typ = fvtArray) then
  begin
    RefItem := Items[0].Ref;
    FRef1 := RefItem.RefItem;
    FRef2 := Items[1];
    FKind := dkArray;
  end
  else
    FKind := dkOther;
end;

function TfsDesignator.GetItem(Index: Integer): TfsDesignatorItem;
begin
  Result := FItems[Index];
end;

function TfsDesignator.DoCalc(const AValue: Variant; Flag: Boolean): Variant;
var
  i, j: Integer;
  Item: TfsCustomVariable;
  Val: Variant;
  Ref: TfsCustomVariable;
  Temp, Temp1: array of Variant;

  { copy local variables to Temp }
  procedure SaveLocalVariables(Item: TfsCustomVariable);
  var
    i: Integer;
  begin
    with TfsProcVariable(Item) do
    begin
      SetLength(Temp, Prog.Count);

      for i := 0 to Prog.Count - 1 do
        if (Prog.Items[i] is TfsVariable) or (Prog.Items[i] is TfsParamItem) then
          Temp[i] := Prog.Items[i].Value;
    end;
  end;

  { restore local variables from Temp}
  procedure RestoreLocalVariables(Item: TfsCustomVariable);
  var
    i: Integer;
  begin
    with TfsProcVariable(Item) do
      for i := 0 to Prog.Count - 1 do
        if (Prog.Items[i] is TfsVariable) or (Prog.Items[i] is TfsParamItem) then
          Prog.Items[i].Value := Temp[i];

    Temp := nil;
  end;

begin
  Ref := nil;
  Val := Null;

  for i := 0 to Count - 1 do
  begin
    Item := Items[i].Ref;

    if Item is TfsDesignator then { it is true for "WITH" statements }
    begin
      Ref := Item;
      Val := Item.Value;
      continue;
    end;

    try
      { we're trying to call the local procedure that is already executing -
        i.e. we have a recursion }
      if (Item is TfsProcVariable) and TfsProcVariable(Item).Executing then
        SaveLocalVariables(Item);

      if Item.Count > 0 then
      begin
        SetLength(Temp1, Item.Count);
        try
          { calculate params and copy param values to the temp1 array }
          for j := 0 to Item.Count - 1 do
            if Item.IsMacro then
              Temp1[j] := TfsExpression(Items[i][j]).Source
            else
              Temp1[j] := Items[i][j].Value;
          { copy calculated values to the item params }
          for j := 0 to Item.Count - 1 do
            Item.Params[j].Value := Temp1[j];
        finally
          Temp1 := nil;
        end;
      end;

      { copy value and var reference to the helper object }
      if Item is TfsCustomHelper then
      begin
        TfsCustomHelper(Item).ParentRef := Ref;
        TfsCustomHelper(Item).ParentValue := Val;
        TfsCustomHelper(Item).Prog := FProgram;
      end;

      Ref := Item;
      { assign a value to the last designator node if called from SetValue }
      if Flag and (i = Count - 1) then
      begin
        Item.Value := AValue
      end
      else
      begin
        Item.NeedResult := (i <> Count - 1) or NeedResult;
        Val := Item.Value;
      end;

      { copy back var params }
      for j := 0 to Item.Count - 1 do
        if Item.Params[j].IsVarParam then
          Items[i][j].Value := Item.Params[j].Value;

    finally
      { restore proc variables if it was called from itself }
      if (Item is TfsProcVariable) and TfsProcVariable(Item).Executing then
        RestoreLocalVariables(Item);
    end;
  end;

  Result := Val;
end;

procedure TfsDesignator.CheckLateBinding;
var
  NewDesignator: TfsDesignator;
  Parser: TfsILParser;
begin
  if FLateBindingXMLSource <> nil then
  begin
    Parser := TfsILParser.Create(FProgram);
    try
      NewDesignator := Parser.DoDesignator(FLateBindingXMLSource, FProgram);
      Borrow(NewDesignator);
      NewDesignator.Free;
    finally
      Parser.Free;
      FLateBindingXMLSource.Free;
      FLateBindingXMLSource := nil;
    end;
  end;
end;

function TfsDesignator.GetValue: Variant;
begin
  CheckLateBinding;
  Result := DoCalc(Null, False);
end;

procedure TfsDesignator.SetValue(const Value: Variant);
begin
  CheckLateBinding;
  DoCalc(Value, True);
end;


{ TfsVariableDesignator }

function TfsVariableDesignator.GetValue: Variant;
begin
  Result := RefItem.Value;
end;

procedure TfsVariableDesignator.SetValue(const Value: Variant);
begin
  RefItem.Value := Value;
end;


{ TfsStringDesignator }

function TfsStringDesignator.GetValue: Variant;
begin
  Result := TfsStringVariable(RefItem).FStr[Integer(FRef1.Value)];
end;

procedure TfsStringDesignator.SetValue(const Value: Variant);
begin
  TfsStringVariable(RefItem).FStr[Integer(FRef1.Value)] := VarToStr(Value)[1];
end;


{ TfsArrayDesignator }

function TfsArrayDesignator.GetValue: Variant;
var
  i: Integer;
begin
  TfsCustomHelper(FRef1).ParentRef := RefItem;
  for i := 0 to FRef2.Count - 1 do
    FRef1.Params[i].Value := FRef2[i].Value;
  Result := FRef1.Value;
end;

procedure TfsArrayDesignator.SetValue(const Value: Variant);
var
  i: Integer;
begin
  TfsCustomHelper(FRef1).ParentRef := RefItem;
  for i := 0 to FRef2.Count - 1 do
    FRef1.Params[i].Value := FRef2[i].Value;
  FRef1.Value := Value;
end;


{ TfsSetExpression }

function TfsSetExpression.Check(const Value: Variant): Boolean;
var
  i: Integer;
  Expr: TfsCustomExpression;
begin
  Result := False;

 (* TfsSetExpression encapsulates the set like [1,2,3..10]
    In the example above we'll have the following Items:
    TfsExpression {1}
    TfsExpression {2}
    TfsExpression {3}
    nil (indicates the range )
    TfsExpression {10} *)

  i := 0;
  while i < Count do
  begin
    Expr := Items[i];

    if (i < Count - 1) and (Items[i + 1] = nil) then { subrange }
    begin
      Result := (Value >= Expr.Value) and (Value <= Items[i + 2].Value);
      Inc(i, 2);
    end
    else
      Result := Value = Expr.Value;

    if Result then break;
    Inc(i);
  end;
end;

function TfsSetExpression.GetItem(Index: Integer): TfsCustomExpression;
begin
  Result := FItems[Index];
end;

function TfsSetExpression.GetValue: Variant;
var
  i: Integer;
begin
  Result := VarArrayCreate([0, Count - 1], varVariant);

  for i := 0 to Count - 1 do
    if Items[i] = nil then
      Result[i] := Null else
      Result[i] := Items[i].Value;
end;


{ TfsScript }

constructor TfsScript.Create(AOwner: TComponent);
begin
  inherited;
  FEvaluteRiseError := False;
  FItems := TStringList.Create;
  FItems.Sorted := True;
  FItems.Duplicates := dupAccept;
  FLines := TStringList.Create;
  FMacros := TStringList.Create;
  FIncludePath := TStringList.Create;
  FIncludePath.Add('');
  FStatement := TfsStatement.Create(Self, '', '');
  FSyntaxType := 'PascalScript';
  FUnitLines := TStringList.Create;
  FUseClassLateBinding := False;
end;

destructor TfsScript.Destroy;
begin
  inherited;
  Clear;
  ClearRTTI;
  FItems.Free;
  FLines.Free;
  FMacros.Free;
  FIncludePath.Free;
  FStatement.Free;
  FUnitLines.Free;
end;

procedure TfsScript.Add(const Name: String; Item: TObject);
begin
  FItems.AddObject(Name, Item);
  if Item is TfsCustomVariable then
    TfsCustomVariable(Item).AddedBy := FAddedBy;
end;

function TfsScript.Count: Integer;
begin
  Result := FItems.Count;
end;

procedure TfsScript.Remove(Item: TObject);
begin
  FItems.Delete(FItems.IndexOfObject(Item));
end;

procedure TfsScript.Clear;
var
  i: Integer;
  item: TObject;
begin
  i := 0;
  while i < FItems.Count do
  begin
    item := FItems.Objects[i];
    if (item is TfsRTTIModule) or
      ((item is TfsCustomVariable) and
       (TfsCustomVariable(item).AddedBy = TObject(1))) then
      Inc(i)
    else
    begin
      item.Free;
      FItems.Delete(i);
    end;
  end;
  FStatement.Clear;


  for i := 0 to FUnitLines.Count - 1 do
    FUnitLines.Objects[i].Free;

  FUnitLines.Clear;

  FErrorPos := '';
  FErrorMsg := '';
  FErrorUnit := '';
end;

procedure TfsScript.ClearItems(Owner: TObject);
var
    i: Integer;
begin
  RemoveItems(Owner);
  FStatement.Clear;

  for i := 0 to FUnitLines.Count - 1 do
    FUnitLines.Objects[i].Free;

  FUnitLines.Clear;
end;

procedure TfsScript.RemoveItems(Owner: TObject);
var
  i: Integer;
begin
  for i := Count - 1 downto 0 do
    if Items[i].AddedBy = Owner then
    begin
      Items[i].Free;
      Remove(Items[i]);
    end;
end;

function TfsScript.GetItem(Index: Integer): TfsCustomVariable;
begin
  Result := TfsCustomVariable(FItems.Objects[Index]);
end;

function TfsScript.Find(const Name: String): TfsCustomVariable;
begin
  Result := FindLocal(Name);

  { trying to find the identifier in all parent programs }
  if (Result = nil) and (FParent <> nil) then
    Result := FParent.Find(Name);
end;

function TfsScript.FindLocal(const Name: String): TfsCustomVariable;
var
  i: Integer;
begin
  Result := nil;
  i := FItems.IndexOf(Name);
  if (i <> -1) and (FItems.Objects[i] is TfsCustomVariable) then
    Result := TfsCustomVariable(FItems.Objects[i]);
end;

function TfsScript.Compile: Boolean;
var
  p: TfsILParser;
begin
  Result := False;
  FErrorMsg := '';

  p := TfsILParser.Create(Self);
  try
    p.SelectLanguage(FSyntaxType);
    if p.MakeILScript(FLines.Text) then
      p.ParseILScript;
  finally
    p.Free;
  end;

  if FErrorMsg = '' then
  begin
    Result := True;
    FErrorPos := '';
  end
end;

procedure TfsScript.Execute;
begin

  FExitCalled := False;
  FTerminated := False;
  FIsRunning := True;
  FMainProg := True;
  try
    FStatement.Execute;
  finally
    FExitCalled := False;
    FTerminated := False;
    FIsRunning := False;
  end;
end;

function TfsScript.Run: Boolean;
begin
  Result := Compile;
  if Result then
    Execute;
end;

function TfsScript.GetILCode(Stream: TStream): Boolean;
var
  p: TfsILParser;
begin
  Result := False;
  FErrorMsg := '';

  p := TfsILParser.Create(Self);
  try
    p.SelectLanguage(FSyntaxType);
    if p.MakeILScript(FLines.Text) then
      p.ILScript.SaveToStream(Stream);
  finally
    p.Free;
  end;

  if FErrorMsg = '' then
  begin
    Result := True;
    FErrorPos := '';
  end;
end;

function TfsScript.SetILCode(Stream: TStream): Boolean;
var
  p: TfsILParser;
begin
  Result := False;
  FErrorMsg := '';

  p := TfsILParser.Create(Self);
  try
    p.ILScript.LoadFromStream(Stream);
    p.ParseILScript;
  finally
    p.Free;
  end;

  if FErrorMsg = '' then
  begin
    Result := True;
    FErrorPos := '';
  end;
end;

procedure TfsScript.AddType(const TypeName: String; ParentType: TfsVarType);
var
  v: TfsTypeVariable;
begin
  if Find(TypeName) <> nil then Exit;
  v := TfsTypeVariable.Create(TypeName, ParentType, '');
  Add(TypeName, v);
end;

function TfsScript.AddClass(AClass: TClass; const Ancestor: String): TfsClassVariable;
var
  cl: TfsClassVariable;
begin
  Result := nil;
  if Find(AClass.ClassName) <> nil then Exit;

  Result := TfsClassVariable.Create(AClass, Ancestor);
  Result.FProgram := Self;
  Add(Result.Name, Result);

  cl := TfsClassVariable(Find(Ancestor));
  if cl <> nil then
    Result.FDefProperty := cl.DefProperty;
end;

procedure TfsScript.AddConst(const Name, Typ: String; const Value: Variant);
var
  v: TfsVariable;
begin
  if Find(Name) <> nil then Exit;

  v := TfsVariable.Create(Name, StrToVarType(Typ, Self), Typ);
  v.Value := Value;
  v.IsReadOnly := True;
  Add(v.Name, v);
end;

procedure TfsScript.AddEnum(const Typ, Names: String);
var
  i: Integer;
  v: TfsVariable;
  sl: TStringList;
begin
  v := TfsVariable.Create(Typ, fvtEnum, Typ);
  Add(v.Name, v);

  sl := TStringList.Create;
  sl.CommaText := Names;

  try
    for i := 0 to sl.Count - 1 do
    begin
      v := TfsVariable.Create(Trim(sl[i]), fvtEnum, Typ);
      v.Value := i;
      v.IsReadOnly := True;
      Add(v.Name, v);
    end;
  finally
    sl.Free;
  end;
end;

procedure TfsScript.AddEnumSet(const Typ, Names: String);
var
  i, j: Integer;
  v: TfsVariable;
  sl: TStringList;
begin
  v := TfsVariable.Create(Typ, fvtEnum, Typ);
  Add(v.Name, v);

  sl := TStringList.Create;
  sl.CommaText := Names;

  try
    j := 1;
    for i := 0 to sl.Count - 1 do
    begin
      v := TfsVariable.Create(Trim(sl[i]), fvtEnum, Typ);
      v.Value := j;
      v.IsReadOnly := True;
      Add(v.Name, v);
      j := j * 2;
    end;
  finally
    sl.Free;
  end;
end;

procedure TfsScript.AddMethod(const Syntax: String; CallEvent: TfsCallMethodEvent;
  const Category: String = ''; const Description: String = '');
var
  v: TfsMethodHelper;
begin
  v := TfsMethodHelper.Create(Syntax, Self);
  v.FOnCall := CallEvent;
  if Description = '' then
    v.FDescription := v.Name else
    v.FDescription := Description;
  v.FCategory := Category;
  Add(v.Name, v);
end;

procedure TfsScript.AddMethod(const Syntax: String; CallEvent: TfsCallMethodNewEvent;
  const Category: String = ''; const Description: String = '');
var
  v: TfsMethodHelper;
begin
  v := TfsMethodHelper.Create(Syntax, Self);
  v.FOnCallNew := CallEvent;
  if Description = '' then
    v.FDescription := v.Name else
    v.FDescription := Description;
  v.FCategory := Category;
  Add(v.Name, v);
end;

procedure TfsScript.AddObject(const Name: String; Obj: TObject);
begin
  AddVariable(Name, Obj.ClassName, Integer(Obj));
end;

procedure TfsScript.AddVariable(const Name, Typ: String; const Value: Variant);
var
  v: TfsVariable;
begin
  if Find(Name) <> nil then Exit;

  v := TfsVariable.Create(Name, StrToVarType(Typ, Self), Typ);
  v.Value := Value;
  v.OnGetVarValue := FOnGetVarValue;
  Add(v.Name, v);
end;

procedure TfsScript.AddForm(Form: TComponent);
begin
  AddComponent(Form);
end;

procedure TfsScript.AddComponent(Form: TComponent);
{$IFNDEF NOFORMS}
var
  i: Integer;
  v: TfsClassVariable;
{$ENDIF}
begin
{$IFNDEF NOFORMS}
  v := FindClass(Form.ClassName);
  if v = nil then
  begin
    if Form.InheritsFrom(TForm) then
      AddClass(Form.ClassType, 'TForm')
    else if Form.InheritsFrom(TDataModule) then
      AddClass(Form.ClassType, 'TDataModule')
{$IFDEF Delphi5}
    else if Form.InheritsFrom(TFrame) then
      AddClass(Form.ClassType, 'TFrame')
{$ENDIF}
    else
      Exit;
    v := FindClass(Form.ClassName);
  end;

  for i := 0 to Form.ComponentCount - 1 do
    v.AddComponent(Form.Components[i]);
  AddObject(Form.Name, Form);
{$ENDIF}
end;

procedure TfsScript.AddRTTI;
var
  i: Integer;
  rtti: TfsRTTIModule;
  obj: TClass;
begin
  if FRTTIAdded then Exit;

  AddedBy := TObject(1); // do not clear
  for i := 0 to FRTTIModules.Count - 1 do
  begin
    obj := TClass(FRTTIModules[i]);
    rtti := TfsRTTIModule(obj.NewInstance);
    rtti.Create(Self);
    Add('', rtti);
  end;
  AddedBy := nil;

  FRTTIAdded := True;
end;

procedure TfsScript.ClearRTTI;
var
  i: Integer;
  item: TObject;
begin
  if not FRTTIAdded then Exit;

  i := 0;
  while i < FItems.Count do
  begin
    item := FItems.Objects[i];
    if (item is TfsRTTIModule) or
      ((item is TfsCustomVariable) and
       (TfsCustomVariable(item).AddedBy = TObject(1))) then
    begin
      item.Free;
      FItems.Delete(i);
    end
    else
      Inc(i);
  end;

  FRTTIAdded := False;
end;

function TfsScript.CallFunction(const Name: String; const Params: Variant): Variant;
var
  i: Integer;
  v: TfsCustomVariable;
  p: TfsProcVariable;
begin
  v := FindLocal(Name);
  if (v <> nil) and (v is TfsProcVariable) then
  begin
    p := TfsProcVariable(v);

    if VarIsArray(Params) then
      for i := 0 to VarArrayHighBound(Params, 1) do
        p.Params[i].Value := Params[i];
    Result := p.Value;
  end
  else
  begin
    Result := Null;
  end
end;

function TfsScript.CallFunction1(const Name: String; var Params: Variant): Variant;
var
  i: Integer;
  v: TfsCustomVariable;
  p: TfsProcVariable;
begin
  v := FindLocal(Name);
  if (v <> nil) and (v is TfsProcVariable) then
  begin
    p := TfsProcVariable(v);

    if VarIsArray(Params) then
      for i := 0 to VarArrayHighBound(Params, 1) do
        p.Params[i].Value := Params[i];
    Result := p.Value;
    if VarIsArray(Params) then
      for i := 0 to VarArrayHighBound(Params, 1) do
        Params[i] := p.Params[i].Value;
  end
  else
    Result := Null;
end;

function TfsScript.CallFunction2(const Func: TfsProcVariable; const Params: Variant): Variant;
var
  i: Integer;
begin
  if (Func <> nil) then
  begin
    if VarIsArray(Params) then
      for i := 0 to VarArrayHighBound(Params, 1) do
        Func.Params[i].Value := Params[i];
    Result := Func.Value;
  end
  else
  begin
    Result := Null;
  end
end;

function TfsScript.Evaluate(const Expression: String): Variant;
var
  p: TfsScript;
  Prog: TfsScript;
  SaveEvent: TfsRunLineEvent;
begin
  FEvaluteRiseError := False;
  Result := Null;
  if FProgRunning = nil then
    p := Self else
    p := FProgRunning;

  Prog := TfsScript.Create(nil);
  if not p.FRTTIAdded then
    Prog.AddRTTI;
  Prog.Parent := p;
  Prog.OnGetVarValue := p.OnGetVarValue;
  SaveEvent := FOnRunLine;
  FOnRunLine := nil;
  try
    prog.SyntaxType := SyntaxType;
    if CompareText(SyntaxType, 'PascalScript') = 0 then
      Prog.Lines.Text := 'function fsEvaluateFUNC: Variant; begin Result := ' + Expression + ' end; begin end.'
    else if CompareText(SyntaxType, 'C++Script') = 0 then
      Prog.Lines.Text := 'Variant fsEvaluateFUNC() { return ' + Expression + '; } {}'
    else if CompareText(SyntaxType, 'BasicScript') = 0 then
      Prog.Lines.Text := 'function fsEvaluateFUNC' + #13#10 + 'return ' + Expression + #13#10 + 'end function'
    else if CompareText(SyntaxType, 'JScript') = 0 then
      Prog.Lines.Text := 'function fsEvaluateFUNC() { return (' + Expression + '); }';
    if not Prog.Compile then
    begin
      Result := Prog.ErrorMsg;
      FEvaluteRiseError := True;
    end
    else
      Result := Prog.FindLocal('fsEvaluateFUNC').Value;
  finally
    Prog.Free;
    FOnRunLine := SaveEvent;
  end;
end;

function TfsScript.FindClass(const Name: String): TfsClassVariable;
var
  Item: TfsCustomVariable;
begin
  Item := Find(Name);
  if (Item <> nil) and (Item is TfsClassVariable) then
    Result := TfsClassVariable(Item) else
    Result := nil
end;

procedure TfsScript.RunLine(const UnitName, Index: String);
var
  p: TfsScript;
begin
  p := Self;
  while p <> nil do
    if Assigned(p.FOnRunLine) then
    begin
      p.FOnRunLine(Self, UnitName, Index);
      break;
    end
    else
      p := p.FParent;
end;

function TfsScript.GetVariables(Index: String): Variant;
var
  v: TfsCustomVariable;
begin
  v := Find(Index);
  if v <> nil then
    Result := v.Value else
    Result := Null;
end;

procedure TfsScript.SetVariables(Index: String; const Value: Variant);
var
  v: TfsCustomVariable;
begin
  v := Find(Index);
  if v <> nil then
    v.Value := Value else
    AddVariable(Index, 'Variant', Value);
end;

procedure TfsScript.SetLines(const Value: TStrings);
begin
  FLines.Assign(Value);
end;

procedure TfsScript.Terminate;

  procedure TerminateAll(Script: TfsScript);
  var
    i: Integer;
  begin
    Script.FExitCalled := True;
    Script.FTerminated := True;
    for i := 0 to Script.Count - 1 do
      if Script.Items[i] is TfsProcVariable then
        TerminateAll(TfsProcVariable(Script.Items[i]).Prog);
  end;

begin
  TerminateAll(Self);
end;

procedure TfsScript.AddCodeLine(const UnitName, APos: String);
var
  sl: TStringList;
  LineN: String;
  i : Integer;
begin
  i := FUnitLines.IndexOf(UnitName);

  if (i = -1) then
  begin
    sl := TStringList.Create;
    sl.Sorted := True;
    FUnitLines.AddObject(UnitName, sl);
  end else
  begin
    sl := TStringList(FUnitLines.Objects[i]);
  end;

  LineN := Copy(APos, 1, Pos(':', APos) - 1);
  if sl.IndexOf(LineN) = -1 then
  begin
    sl.Add(LineN);
  end;
end;

function TfsScript.IsExecutableLine(LineN: Integer; const UnitName: String = ''): Boolean;
var
  sl: TStringList;
  i: Integer;
begin
  Result := False;

  i := FUnitLines.IndexOf(UnitName);
  if (i = -1) then Exit;

  sl := TStringList(FUnitLines.Objects[i]);
  if sl.IndexOf(IntToStr(LineN)) <> -1 then
    Result := True;
end;




{ TfsStatement }

constructor TfsStatement.Create(AProgram: TfsScript; const UnitName,
  SourcePos: String);
begin
  inherited Create;
  FProgram := AProgram;
  FSourcePos := SourcePos;
  FUnitName := UnitName;
end;

function TfsStatement.GetItem(Index: Integer): TfsStatement;
begin
  Result := FItems[Index];
end;

procedure TfsStatement.Execute;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    if FProgram.FTerminated then break;
    Items[i].Execute;
    if FProgram.FBreakCalled or FProgram.FContinueCalled or
      FProgram.FExitCalled then break;
  end;
end;

procedure TfsStatement.RunLine;
begin
  FProgram.RunLine(FUnitName, FSourcePos);
end;


{ TfsAssignmentStmt }

destructor TfsAssignmentStmt.Destroy;
begin
  FDesignator.Free;
  FExpression.Free;
  inherited;
end;

procedure TfsAssignmentStmt.Optimize;
begin
  FVar := FDesignator;
  FExpr := FExpression;

  if FDesignator is TfsVariableDesignator then
    FVar := FDesignator.RefItem;
  if TfsExpression(FExpression).SingleItem <> nil then
    FExpr := TfsExpression(FExpression).SingleItem;
end;

procedure TfsAssignmentStmt.Execute;
begin
  RunLine;
  if FProgram.FTerminated then Exit;
  FVar.Value := FExpr.Value;
end;

procedure TfsAssignPlusStmt.Execute;
begin
  RunLine;
  if FProgram.FTerminated then Exit;
  FVar.Value := FVar.Value + FExpr.Value;
end;

procedure TfsAssignMinusStmt.Execute;
begin
  RunLine;
  if FProgram.FTerminated then Exit;
  FVar.Value := FVar.Value - FExpr.Value;
end;

procedure TfsAssignMulStmt.Execute;
begin
  RunLine;
  if FProgram.FTerminated then Exit;
  FVar.Value := FVar.Value * FExpr.Value;
end;

procedure TfsAssignDivStmt.Execute;
begin
  RunLine;
  if FProgram.FTerminated then Exit;
  FVar.Value := FVar.Value / FExpr.Value;
end;


{ TfsCallStmt }

destructor TfsCallStmt.Destroy;
begin
  FDesignator.Free;
  inherited;
end;

procedure TfsCallStmt.Execute;
begin
  RunLine;
  if FProgram.FTerminated then Exit;
  if FModificator = '' then
  begin
    FDesignator.NeedResult := False;
    FDesignator.Value;
  end
  else if FModificator = '+' then
    FDesignator.Value := FDesignator.Value + 1
  else if FModificator = '-' then
    FDesignator.Value := FDesignator.Value - 1
end;


{ TfsIfStmt }

constructor TfsIfStmt.Create(AProgram: TfsScript; const UnitName,
  SourcePos: String);
begin
  inherited;
  FElseStmt := TfsStatement.Create(FProgram, UnitName, SourcePos);
end;

destructor TfsIfStmt.Destroy;
begin
  FCondition.Free;
  FElseStmt.Free;
  inherited;
end;

procedure TfsIfStmt.Execute;
begin
  RunLine;
  if FProgram.FTerminated then Exit;
  if Boolean(FCondition.Value) = True then
    inherited Execute else
    FElseStmt.Execute;
end;


{ TfsRepeatStmt }

destructor TfsRepeatStmt.Destroy;
begin
  FCondition.Free;
  inherited;
end;

procedure TfsRepeatStmt.Execute;
begin
  RunLine;
  if FProgram.FTerminated then Exit;

  repeat
    inherited Execute;
    if FProgram.FBreakCalled or FProgram.FExitCalled then break;
    FProgram.FContinueCalled := False;
  until Boolean(FCondition.Value) = not FInverseCondition;

  FProgram.FBreakCalled := False;
end;


{ TfsWhileStmt }

destructor TfsWhileStmt.Destroy;
begin
  FCondition.Free;
  inherited;
end;

procedure TfsWhileStmt.Execute;
begin
  RunLine;
  if FProgram.FTerminated then Exit;

  while Boolean(FCondition.Value) = True do
  begin
    inherited Execute;
    if FProgram.FBreakCalled or FProgram.FExitCalled then break;
    FProgram.FContinueCalled := False;
  end;

  FProgram.FBreakCalled := False;
end;


{ TfsForStmt }

destructor TfsForStmt.Destroy;
begin
  FBeginValue.Free;
  FEndValue.Free;
  inherited;
end;

procedure TfsForStmt.Execute;
var
  i, bValue, eValue: Integer;
begin
  bValue := FBeginValue.Value;
  eValue := FEndValue.Value;
  RunLine;
  if FProgram.FTerminated then Exit;

  if FDown then
    for i := bValue downto eValue do
    begin
      FVariable.FValue := i;
      inherited Execute;
      if FProgram.FBreakCalled or FProgram.FExitCalled then break;
      FProgram.FContinueCalled := False;
    end
  else
    for i := bValue to eValue do
    begin
      FVariable.FValue := i;
      inherited Execute;
      if FProgram.FBreakCalled or FProgram.FExitCalled then break;
      FProgram.FContinueCalled := False;
    end;

  FProgram.FBreakCalled := False;
end;


{ TfsVbForStmt }

destructor TfsVbForStmt.Destroy;
begin
  FBeginValue.Free;
  FEndValue.Free;
  if FStep <> nil then
    FStep.Free;
  inherited;
end;

procedure TfsVbForStmt.Execute;
var
  i, bValue, eValue, sValue: Variant;
  Down: Boolean;
begin
  bValue := FBeginValue.Value;
  eValue := FEndValue.Value;
  if FStep <> nil then
    sValue := FStep.Value else
    sValue := 1;
  Down := sValue < 0;

  RunLine;
  if FProgram.FTerminated then Exit;
  i := bValue;
  if Down then
    while i >= eValue do
    begin
      FVariable.FValue := i;
      inherited Execute;
      if FProgram.FBreakCalled or FProgram.FExitCalled then break;
      FProgram.FContinueCalled := False;
      i := i + sValue;
    end
  else
    while i <= eValue do
    begin
      FVariable.FValue := i;
      inherited Execute;
      if FProgram.FBreakCalled or FProgram.FExitCalled then break;
      FProgram.FContinueCalled := False;
      i := i + sValue;
    end;

  FProgram.FBreakCalled := False;
end;


{ TfsCppForStmt }

constructor TfsCppForStmt.Create(AProgram: TfsScript; const UnitName,
  SourcePos: String);
begin
  inherited;
  FFirstStmt := TfsStatement.Create(FProgram, UnitName, SourcePos);
  FSecondStmt := TfsStatement.Create(FProgram, UnitName, SourcePos);
end;

destructor TfsCppForStmt.Destroy;
begin
  FFirstStmt.Free;
  FExpression.Free;
  FSecondStmt.Free;
  inherited;
end;

procedure TfsCppForStmt.Execute;
begin
  RunLine;
  if FProgram.FTerminated then Exit;
  FFirstStmt.Execute;
  if FProgram.FTerminated then Exit;
  while Boolean(FExpression.Value) = True do
  begin
    inherited Execute;
    if FProgram.FBreakCalled or FProgram.FExitCalled then break;
    FProgram.FContinueCalled := False;
    FSecondStmt.Execute;
  end;

  FProgram.FBreakCalled := False;
end;


{ TfsCaseSelector }

destructor TfsCaseSelector.Destroy;
begin
  FSetExpression.Free;
  inherited;
end;

function TfsCaseSelector.Check(const Value: Variant): Boolean;
begin
  Result := FSetExpression.Check(Value);
end;


{ TfsCaseStmt }

constructor TfsCaseStmt.Create(AProgram: TfsScript; const UnitName,
  SourcePos: String);
begin
  inherited;
  FElseStmt := TfsStatement.Create(FProgram, UnitName, SourcePos);
end;

destructor TfsCaseStmt.Destroy;
begin
  FCondition.Free;
  FElseStmt.Free;
  inherited;
end;

procedure TfsCaseStmt.Execute;
var
  i: Integer;
  Value: Variant;
  Executed: Boolean;
begin
  Value := FCondition.Value;
  Executed := False;

  RunLine;
  if FProgram.FTerminated then Exit;
  for i := 0 to Count - 1 do
    if TfsCaseSelector(Items[i]).Check(Value) then
    begin
      Items[i].Execute;
      Executed := True;
      break;
    end;

  if not Executed then
    FElseStmt.Execute;
end;


{ TfsTryStmt }

constructor TfsTryStmt.Create(AProgram: TfsScript; const UnitName,
  SourcePos: String);
begin
  inherited;
  FExceptStmt := TfsStatement.Create(AProgram, UnitName, SourcePos);
end;

destructor TfsTryStmt.Destroy;
begin
  FExceptStmt.Free;
  inherited;
end;

procedure TfsTryStmt.Execute;
var
  SaveExitCalled: Boolean;
begin
  RunLine;
  if FProgram.FTerminated then Exit;
  if IsExcept then
  begin
    try
      inherited Execute;
    except
      on E: Exception do
      begin
        FProgram.SetVariables('ExceptionClassName', E.ClassName);
        FProgram.SetVariables('ExceptionMessage', E.Message);
        ExceptStmt.Execute;
      end;
    end;
  end
  else
  begin
    try
      inherited Execute;
    finally
      SaveExitCalled := FProgram.FExitCalled;
      FProgram.FExitCalled := False;
      ExceptStmt.Execute;
      FProgram.FExitCalled := SaveExitCalled;
    end
  end;
end;


{ TfsBreakStmt }

procedure TfsBreakStmt.Execute;
begin
  FProgram.FBreakCalled := True;
end;


{ TfsContinueStmt }

procedure TfsContinueStmt.Execute;
begin
  FProgram.FContinueCalled := True;
end;


{ TfsExitStmt }

procedure TfsExitStmt.Execute;
begin
  RunLine;
  FProgram.FExitCalled := True;
end;


{ TfsWithStmt }

destructor TfsWithStmt.Destroy;
begin
  FDesignator.Free;
  inherited;
end;

procedure TfsWithStmt.Execute;
begin
  inherited;
  FVariable.Value := FDesignator.Value;
end;


{ TfsArrayHelper }

constructor TfsArrayHelper.Create(const AName: String; DimCount: Integer;
  Typ: TfsVarType; const TypeName: String);
var
  i: Integer;
begin
  inherited Create(AName, Typ, TypeName);

  if DimCount <> -1 then
  begin
    for i := 0 to DimCount - 1 do
      Add(TfsParamItem.Create('', fvtInt, '', False, False));
  end
  else
    for i := 0 to 2 do
      Add(TfsParamItem.Create('', fvtInt, '', i > 0, False));
end;

destructor TfsArrayHelper.Destroy;
begin
  inherited;
end;

function TfsArrayHelper.GetValue: Variant;
var
  DimCount: Integer;
begin
  DimCount := VarArrayDimCount(ParentRef.PValue^);
  case DimCount of
    1: Result := ParentRef.PValue^[Params[0].Value];
    2: Result := ParentRef.PValue^[Params[0].Value, Params[1].Value];
    3: Result := ParentRef.PValue^[Params[0].Value, Params[1].Value, Params[2].Value];
  else
    Result := Null;
  end;
end;

procedure TfsArrayHelper.SetValue(const Value: Variant);
var
  DimCount: Integer;
begin
  DimCount := VarArrayDimCount(ParentRef.PValue^);
  case DimCount of
    1: ParentRef.PValue^[Params[0].Value] := Value;
    2: ParentRef.PValue^[Params[0].Value, Params[1].Value] := Value;
    3: ParentRef.PValue^[Params[0].Value, Params[1].Value, Params[2].Value] := Value;
  end;
end;


{ TfsStringHelper }

constructor TfsStringHelper.Create;
begin
  inherited Create('__StringHelper', fvtChar, '');
  Add(TfsParamItem.Create('', fvtInt, '', False, False));
end;

function TfsStringHelper.GetValue: Variant;
begin
  Result := String(ParentValue)[Integer(Params[0].Value)];
end;

procedure TfsStringHelper.SetValue(const Value: Variant);
var
  s: String;
begin
  s := ParentValue;
  s[Integer(Params[0].Value)] := String(Value)[1];
  TfsCustomVariable(Integer(ParentRef)).Value := s;
end;


{ TfsCustomEvent }

constructor TfsCustomEvent.Create(AObject: TObject; AHandler: TfsProcVariable);
begin
  FInstance := AObject;
  FHandler := AHandler;
end;

procedure TfsCustomEvent.CallHandler(Params: array of const);
var
  i: Integer;
begin
  if FHandler.Executing then Exit;
  for i := 0 to FHandler.Count - 1 do
    FHandler.Params[i].Value := VarRecToVariant(Params[i]);
  FHandler.Value;
end;


{ TfsRTTIModule }

constructor TfsRTTIModule.Create(AScript: TfsScript);
begin
  FScript := AScript;
end;


function fsGlobalUnit: TfsScript;
begin
  if (FGlobalUnit = nil) and not FGlobalUnitDestroyed then
  begin
    FGlobalUnit := TfsScript.Create(nil);
    FGlobalUnit.AddRTTI;
  end;
  Result := FGlobalUnit;
end;

function fsRTTIModules: TList;
begin
  if (FRTTIModules = nil) and not FRTTIModulesDestroyed then
  begin
    FRTTIModules := TList.Create;
    FRTTIModules.Add(TfsSysFunctions);
  end;
  Result := FRTTIModules;
end;

{ TfsVariable }

function TfsVariable.GetValue: Variant;
begin
  Result := inherited GetValue;
  if Assigned(FOnGetVarValue) then
  begin
    Result := FOnGetVarValue(FName, FTyp, FValue);
    if Result = null then Result := FValue;
  end;
end;

procedure TfsVariable.SetValue(const Value: Variant);
begin
  if not FIsReadOnly then
    case FTyp of
      fvtInt: FValue := VarAsType(Value, varInteger);
      fvtBool: FValue := VarAsType(Value, varBoolean);
      fvtFloat: FValue := VarAsType(Value, varDouble);
      fvtString: FValue := VarAsType(Value, varString);
    else
      FValue := Value;
    end;
end;

initialization
  FGlobalUnitDestroyed := False;
  FRTTIModulesDestroyed := False;
  fsRTTIModules;

finalization
  if FGlobalUnit <> nil then
    FGlobalUnit.Free;
  FGlobalUnit := nil;
  FGlobalUnitDestroyed := True;
  FRTTIModules.Free;
  FRTTIModules := nil;
  FRTTIModulesDestroyed := True;

end.
