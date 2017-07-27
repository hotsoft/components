{
  Variant MSWord = CreateOleObject("Word.Basic");
  MsWord.AppShow;
  MSWord.FileNew;
  MSWord.Insert("Test!");
  MSWord.LineUp(1, 1);
}