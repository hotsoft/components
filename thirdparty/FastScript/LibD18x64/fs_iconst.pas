
{******************************************}
{                                          }
{             FastScript v1.9              }
{                Resources                 }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_iconst;

interface

{$i fs.inc}

var
  SLangNotFound: String;
  SInvalidLanguage: String;
  SIdRedeclared: String;
  SUnknownType: String;
  SIncompatibleTypes: String;
  SIdUndeclared: String;
  SClassRequired: String;
  SIndexRequired: String;
  SStringError: String;
  SClassError: String;
  SArrayRequired: String;
  SVarRequired: String;
  SNotEnoughParams: String;
  STooManyParams: String;
  SLeftCantAssigned: String;
  SForError: String;
  SEventError: String;


implementation

initialization
  SLangNotFound := 'Language ''%s'' not found';
  SInvalidLanguage := 'Invalid language definition';
  SIdRedeclared := 'Identifier redeclared: ';
  SUnknownType := 'Unknown type: ';
  SIncompatibleTypes := 'Incompatible types';
  SIdUndeclared := 'Undeclared identifier: ';
  SClassRequired := 'Class type required';
  SIndexRequired := 'Index required';
  SStringError := 'Strings doesn''t have properties or methods';
  SClassError := 'Class %s does not have a default property';
  SArrayRequired := 'Array type required';
  SVarRequired := 'Variable required';
  SNotEnoughParams := 'Not enough actual parameters';
  STooManyParams := 'Too many actual parameters';
  SLeftCantAssigned := 'Left side cannot be assigned to';
  SForError := 'For loop variable must be numeric variable';
  SEventError := 'Event handler must be a procedure';

end.
