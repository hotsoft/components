{ This file was automatically created by Lazarus. do not edit!
  This source is only used to compile and install the package.
 }

unit fs_lazarus; 

interface

uses
  fs_ipascal, fs_icpp, fs_ijs, fs_ibasic, fs_iclassesrtti, fs_iconst, 
  fs_idialogsrtti, fs_ievents, fs_iexpression, fs_iextctrlsrtti, 
  fs_iformsrtti, fs_igraphicsrtti, fs_iilparser, fs_iinirtti, fs_iinterpreter, 
  fs_iparser, fs_isysrtti, fs_itools, fs_xml, fs_ireg, fs_synmemo, fs_tree, 
  LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('fs_ireg', @fs_ireg.Register); 
end; 

initialization
  RegisterPackage('fs_lazarus', @Register); 
end.
