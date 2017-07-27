msWord = CreateOleObject("Word.Application")
msWord.Visible = True

doc = msWord.Documents.Add
sel = msWord.Selection

sel.TypeText("Some System Parameters:")
sel.HomeKey(5, 1)
sel.Font.Bold = True
sel.EndKey(5, 0)
sel.Font.Bold = False

tab = doc.Tables.Add(sel.Range, 3, 2)

sel.TypeText("Operating System")
sel.MoveRight(12)
sel.TypeText(msWord.System.OperatingSystem)
sel.MoveLeft(12)
sel.MoveDown(5)

sel.TypeText("Processor")
sel.MoveRight(12)
sel.TypeText(msWord.System.ProcessorType)
sel.MoveLeft(12)
sel.MoveDown(5)

sel.TypeText("Word Version")
sel.MoveRight(12)
sel.TypeText(MsWord.Version)
sel.MoveLeft(12)
sel.MoveDown(5)

