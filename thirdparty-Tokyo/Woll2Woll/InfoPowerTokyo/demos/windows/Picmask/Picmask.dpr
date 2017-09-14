program Picmask;

uses
  Forms,
  Pictures in 'PICTURES.PAS' {PictureForm};

{$R *.RES}

begin
  Application.CreateForm(TPictureForm, PictureForm);
  Application.Run;
end.
