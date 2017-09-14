program BuildEnt;

uses
  Forms,
  ppRegPro in 'ppRegPro.pas',
  raReg in 'raReg.pas',
  daReg in 'daReg.pas',
  myReg in 'myReg.pas',
  ppJPEG in 'ppJPEG.pas',
  ppGIF in 'ppGIF.pas',
  ppPNG in 'ppPNG.pas',
  ppPDFDevice in 'ppPDFDevice.pas',
  daDatMan in '..\DADE\daDatMan.pas',
  daDatMod in '..\DADE\daDatMod.pas',
  daDataVw in '..\DADE\daDataVw.pas',
  daQClass in '..\DADE\daQClass.pas',
  daQuery in '..\DADE\daQuery.pas',
  ppSMTPOutlook in 'ppSMTPOutlook.pas',
  ppSMTPIndy10 in 'ppSMTPIndy10.pas',
  ppSMTPThunderbird in 'ppSMTPThunderbird.pas',
  ppRESTMailGmail in 'ppRESTMailGmail.pas',
  ppRESTMailOutlook365 in 'ppRESTMailOutlook365.pas';

{$R *.RES}

begin
  Application.Run;
end.
