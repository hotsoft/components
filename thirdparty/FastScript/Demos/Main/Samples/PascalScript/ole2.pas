var 
  msWord: Variant;
  doc, sel, tab: Variant;
begin
  msWord := CreateOleObject('Word.Application');
  msWord.Visible := True;

  doc := msWord.Documents.Add;
  sel := msWord.Selection;

  sel.TypeText('Some System Parameters:');
  sel.HomeKey(5 {wdLine}, 1 {wdExtend});
  sel.Font.Bold := True;
  sel.EndKey(5 {wdLine}, 0 {wdMove});
  sel.Font.Bold := False;

  tab := doc.Tables.Add(sel.Range, 3, 2);

  sel.TypeText('Operating System');
  sel.MoveRight(12 {wdCell});
  sel.TypeText(msWord.System.OperatingSystem);
  sel.MoveLeft(12 {wdCell});
  sel.MoveDown(5 {wdLine});

  sel.TypeText('Processor');
  sel.MoveRight(12 {wdCell});
  sel.TypeText(msWord.System.ProcessorType);
  sel.MoveLeft(12 {wdCell});
  sel.MoveDown(5 {wdLine});

  sel.TypeText('Word Version');
  sel.MoveRight(12 {wdCell});
  sel.TypeText(MsWord.Version);
  sel.MoveLeft(12 {wdCell});
  sel.MoveDown(5 {wdLine});
end.
