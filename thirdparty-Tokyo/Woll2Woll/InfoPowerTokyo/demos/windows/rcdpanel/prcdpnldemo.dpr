program prcdpnldemo;

uses
  Forms,
  rcdpnldemo in 'rcdpnldemo.pas' {RecordPanelDemo};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TRecordPanelDemo, RecordPanelDemo);
  Application.Run;
end.
