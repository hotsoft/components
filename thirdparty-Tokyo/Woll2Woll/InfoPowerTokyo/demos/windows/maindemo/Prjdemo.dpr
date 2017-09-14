program Prjdemo;



uses
  Forms,
  COMBOS in '..\combos\COMBOS.PAS' {LookupForm},
  DEMOLOC in '..\locate\DEMOLOC.PAS' {Locate},
  GRDMEMO in '..\gridmemo\GRDMEMO.PAS' {GridMemoApp},
  Isearch in '..\isrchdlg\Isearch.pas' {SearchForm},
  SEARCH in '..\search\SEARCH.PAS' {IncrSearch},
  GRDLOOK in '..\grid\GRDLOOK.PAS' {GridDemo},
  GRDBITMP in '..\GRID\GRDBITMP.PAS' {BitmapForm},
  Pictures in '..\PICMASK\Pictures.pas',
  Multi in '..\multidel\Multi.pas',
  filtdlg in '..\fltdlg\filtdlg.PAS',
  lkdtl in '..\combos\lkdtl.pas',
  GRDBTTN in '..\grid\GRDBTTN.PAS',
  rcdvw in '..\rcdvw\rcdvw.pas' {RecordViewDemoForm},
  savefilt in '..\savefilt\savefilt.pas' {SaveFilterDemo},
  selfilt in '..\savefilt\selfilt.pas' {SelectSaveFilter},
  wwsavflt in '..\savefilt\wwsavflt.pas',
  rcdpnldemo in '..\rcdpanel\rcdpnldemo.pas' {RecordPanelDemo},
  demo in 'demo.pas' {MainDemo},
  monthcalu in '..\DtPicker\monthcalu.pas' {MonthCalendarForm},
  mnthyear in '..\DtPicker\mnthyear.pas' {YearCalendar},
  NavMany in '..\Navigator\NavMany.pas' {NavigatorForm1},
  NavigatorComb in '..\Navigator\NavigatorComb.pas' {CombinedForm},
  dtpick in '..\DtPicker\dtpick.pas' {DateTimePickerForm},
  rcdpnldemo2 in '..\rcdpanel\rcdpnldemo2.pas' {RecordViewPanelForm2},
  dbchecku in '..\framing\dbchecku.pas' {CustomFramingForm},
  DataInspectorU in '..\Inspector\DataInspectorU.pas' {DataInspectorDemo},
  GrdIniHint in '..\GRID\GrdIniHint.pas' {GridHintIniDemo},
  gridmasterdetailpanel in '..\gridmast\gridmasterdetailpanel.pas' {MasterDetailPanelForm},
  gridcontrols in '..\Grid\gridcontrols.pas' {GridControlsForm},
  inspectormulti in '..\inspector\inspectormulti.pas' {MultiInspectorForm},
  exportdemou in '..\export\exportdemou.pas' {ExportForm},
  rcdvw2 in '..\rcdvw\rcdvw2.pas' {RecordViewCustomForm},
  checkboxu in '..\checkbox\checkboxu.pas' {CheckBoxDemo},
  combodemou in '..\Combos\combodemou.pas' {ComboDemoForm},
  radiou in '..\radio\radiou.pas' {RadioDemoForm},
  formatu in '..\numerics\formatu.pas' {FormatForm},
  richlabelu in '..\richedit\richlabelu.pas' {RichLabelDemo},
  gridexpand in '..\Grid\gridexpand.pas' {GridExpandForm},
  lkcustom in '..\Combos\lkcustom.pas' {CustomComboForm},
  gridexpandpanel in '..\Grid\gridexpandpanel.pas' {FormExpandPanel},
  gridlargeedit in '..\Grid\gridlargeedit.pas' {LargeGridEditForm},
  gridmasterdetail in '..\gridmast\gridmasterdetail.pas' {MasterDetailGridForm},
  griddatagroup in '..\Grid\griddatagroup.pas' {DataGroupForm},
  converter in '..\richedit\converter.pas' {RTFImportExportForm},
  printheader in '..\richedit\printheader.pas' {PrintHeaderForm},
  mailmerge in '..\richedit\mailmerge.pas' {RichEditMerge},
  dittou in '..\Grid\dittou.pas' {DittoForm},
  rtfbardemo in '..\richedit\rtfbardemo.pas' {RTFBarForm},
  gridsortfilter in '..\Grid\gridsortfilter.pas' {GridSortFilterDemo},
  Vcl.Themes,
  Vcl.Styles;

{$R *.RES}

begin
  Application.Initialize;
  TStyleManager.TrySetStyle('Aqua Graphite');
  Application.CreateForm(TMainDemo, MainDemo);
  Application.Run;
end.
