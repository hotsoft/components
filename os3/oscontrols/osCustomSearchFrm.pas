unit osCustomSearchFrm;
                     
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, Grids, DBGrids, Buttons, StdCtrls, ImgList, ComCtrls,
  ToolWin, ActnList, Db, DBClient, MConnect, SConnect,
  osActionList, Mask, wwdbedit, Wwdotdot, Wwdbcomb,
  osComboFilter, Wwintl, osClientDataset, provider, Wwdbigrd, Wwdbgrid,
  osFilterInspectorFrame, osExtStringList, wwDataInspector, osUtils,
  wwCheckBox, System.UITypes;

type
  TTipoAviso = (taInformar, taNaoEncontrado);
  TTipoOperacao = (toMostrarResultado, toRetornarQuery);
  TCustomSearchForm = class(TForm)
    ControlBar1: TControlBar;
    ImageList: TImageList;
    pnlConsulta: TPanel;                                               
    lblConsulta: TLabel;
    FilterDatasource: TDataSource;
    tbrFilter: TToolBar;
    PopupMenu: TPopupMenu;
    ConsultaCombo: TosComboFilter;
    FilterDataset: TosClientDataset;
    ArrowsImageList: TImageList;
    pnlCriterios: TPanel;
    AvisosPanel: TPanel;
    FilterInspectorFrame: TFilterInspectorFrame;
    GridPanel: TPanel;
    Grid: TwwDBGrid;
    Label1: TLabel;
    BotoesPanel: TPanel;
    OkButton: TButton;
    CancelaButton: TButton;
    InformarLabel: TLabel;
    NaoEncontradoLabel: TLabel;
    Timer: TTimer;
    procedure FilterDatasetAfterOpen(DataSet: TDataSet);
    procedure cbConsultaCloseUp(Sender: TwwDBComboBox; Select: Boolean);
    procedure GridDblClick(Sender: TObject);
    procedure FilterDatasetBeforeClose(DataSet: TDataSet);
    procedure GridCalcTitleImage(Sender: TObject; Field: TField;
      var TitleImageAttributes: TwwTitleImageAttributes);
    procedure GridTitleButtonClick(Sender: TObject;
      AFieldName: String);
    procedure FilterDatasetAfterScroll(DataSet: TDataSet);
    procedure GridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GridKeyPress(Sender: TObject; var Key: Char);
    procedure FilterInspectorFramePesquisarButtonClick(Sender: TObject);
    procedure FilterInspectorFrameDataInspectorEnter(Sender: TObject);
    procedure GridEnter(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TimerTimer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
  protected
    tipo: TTipoOperacao;
    FExecuteFilter: boolean;

    // Field que est� sendo usado para ordena��o
    SortField: TField;
    // Sentido da ordena��o
    AscendingSort: boolean;

    // Armazena a string que ser� usada na busca incremental do grid
    CurrentSearchString: string;
    // Indica quando o m�todo de busca incremental est� rolando o dataset,
    // para impedir que este, quando tiver um evento OnScroll executado, esvazie
    // CurrentSearchString
    IncrementalSearchScrolling: boolean;
    // O evento OnKeyDown do grid liga esta vari�vel toda vez que a tecla Alt ou
    // Ctrl estiver pressionada. O evento OnKeyPress, que � executado ap�s o
    // OnKeyDown, pode determinar, assim, se uma dessas teclas est� pressionada
    // e ignorar o caractere se desejado
    CtrlOrAltPressed: boolean;
    AltPressed: boolean;

    function GetFilterDefName: string;
    procedure SetFilterDefName(const Value: string);
    function GetDataProvider: TCustomProvider;
    procedure SetDataProvider(const Value: TCustomProvider);
    function GetSelected: boolean;
    procedure PrepareFilterInspector(comboFilter: TosComboFilter; naoAchou: boolean = false);

    procedure CreateConstraint(const PStr: string; PInspItem: TwwInspectorItem);
    procedure CreateOrder(POrderList: TStrings);
    function GetWord(const PStr: string; PIndex: integer;
      PSeparator: char = ';'): string;
    procedure DatePickerOnEnter(Sender: TObject);
    procedure CreateDateList(PInspItem: TwwInspectorItem);
    procedure DateListItemChanged(Sender: TwwDataInspector;
      Item: TwwInspectorItem; NewValue: String);
    function LastDayMonth(PDate: TDatetime): TDatetime;
    function SQLDateFromStr(PStr: string): string;
    procedure ReplaceSpecialChars(var PStr: string);
    procedure MostrarAviso(tipo: TTipoAviso);
    function CamposObrigatoriosPreenchidos(): Boolean;
  public
    sqlResult: TStringList;
    RuntimeFilter: string;
    constructor Create(AOwner: TComponent); override;
    function GetOrder: string;
    function Execute(const PValue: string;
  const PAutoSearchNumber: integer; tipo: TTipoOperacao = toMostrarResultado): boolean;
    function GetFieldValue(const PFieldName: string): variant;
    procedure ClearFilter;
    procedure getUserFills(fills: TStringList);
    function GetExpressions: string;    
  published
    property DataProvider : TCustomProvider read GetDataProvider write SetDataProvider;
    property FilterDefName: string read GetFilterDefName write SetFilterDefName;
    property Selected: boolean read GetSelected;
    //property SelectedID: integer read GetSelectedID;
  end;

var
  CustomSearchForm: TCustomSearchForm;

implementation

uses osDBDateTimePicker, osComboSearch, osCustomFilterFunctionUn, Variants;

{$R *.DFM}

const
  // Nome do �ndice usado para ordenar os registros do filtro
  SortIndexName = 'SortIndex';

constructor TCustomSearchForm.Create(AOwner: TComponent);
begin
  inherited;
  sqlResult := TStringList.Create;
end;

procedure TCustomSearchForm.FilterDatasetAfterOpen(DataSet: TDataSet);
begin
  inherited;
  // O filtro deve ter mais de uma coluna para ser mostrado ao usu�rio, j� que
  // a primeira � sempre o field 'ID'
   Assert(FilterDataset.Fields.Count > 1);

  // Define o field de ordena��o. Como a primeira coluna � o field 'ID', deve-se
  // escolher a segunda coluna do dataset
  SortField := FilterDataSet.Fields[1];
  // Define a ordem (ascendente)
  AscendingSort := True;

  // Cria um �ndice para o field e a ordem estabelecidos
  FilterDataSet.AddIndex(SortIndexName, SortField.FieldName,
      [ixCaseInsensitive]);
  // Define o nome do �ndice a ser usado pelo dataset
  FilterDataset.IndexName := SortIndexName;

  // Redesenha o grid para que seja mostrada a seta na coluna apropriada
  Grid.RedrawGrid;
end;

procedure TCustomSearchForm.cbConsultaCloseUp(Sender: TwwDBComboBox;
  Select: Boolean);
begin
  inherited;
  if Select then
  begin
    Screen.Cursor := crHourglass;
    try
      PrepareFilterInspector(ConsultaCombo);
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

function TCustomSearchForm.GetFilterDefName: string;
begin
  Result := ConsultaCombo.FilterDefName;
end;

procedure TCustomSearchForm.SetFilterDefName(const Value: string);
begin
  if ConsultaCombo.FilterDefName <> Value then
    ConsultaCombo.FilterDefName := Value;
end;

function TCustomSearchForm.GetFieldValue(const PFieldName: string): variant;
begin
  if FilterDataset.RecordCount > 0 then
  begin
    if PFieldName = '' then
      Result := FilterDataset.Fields[0].Value
    else
      Result := FilterDataset.FieldByName(PFieldName).Value;
  end
  else
    Result := -1;
end;

function TCustomSearchForm.Execute(const PValue: string;
  const PAutoSearchNumber: integer; tipo: TTipoOperacao = toMostrarResultado): boolean;
var
  constraintId, i: integer;
  bShow: boolean;
  InspItem: TwwInspectorItem;
  slConstr: TStrings;
  sNome: String;
  naoAchou: boolean;
  viewDef: TViewDef;
begin
  Self.tipo := tipo;
  //Ajustes visuais conforme o tipo
  if tipo = toRetornarQuery then
  begin
    BotoesPanel.Visible := false;
    pnlCriterios.Height := pnlCriterios.Height + 150;
  end;
  constraintID := 0;
  FexecuteFilter := true;
  
  if ConsultaCombo.Items.Count = 0 then
  begin
    ConsultaCombo.GetViews;
    if RuntimeFilter <> '' then
    begin
      for i := 0 to ConsultaCombo.Items.Count - 1 do
      begin
        viewDef := TViewDef(ConsultaCombo.Items.Objects[i]);
        if viewDef.ExprList.Text <> '' then
          viewDef.ExprList.Add(RuntimeFilter)
        else
          viewDef.ExprList.Add('1=1 '+RuntimeFilter);
      end;
    end;
  end;

  bShow := True;
  if PValue <> '' then
  begin
    for i:=0 to PAutoSearchNumber - 1 do
    begin
      if ConsultaCombo.ExecuteView(-1, i, PValue) then
      begin
        if FilterDataset.RecordCount >= 1 then
        begin
          if FilterDataset.RecordCount = 1 then
            bShow := False
          else
          begin
            ConsultaCombo.ConfigFields(ConsultaCombo.Items.Count - 1); // Ajusta os cabe�alhos, etc.
            ConsultaCombo.ItemIndex := ConsultaCombo.Items.Count - 1;
          end;
          FExecuteFilter := False;
          constraintID := i;
          break;
        end;
      end;
    end;
  end;

  NaoAchou := ((PValue<>'') and FExecuteFilter);

  if bShow then
  begin
    if FExecuteFilter then
    begin
      ConsultaCombo.ResetToItemDefault;
      PrepareFilterInspector(ConsultaCombo, naoAchou);
    end;

    slConstr := ConsultaCombo.fbaseview.constrlist;
    if slConstr.Count<1 then
      raise Exception.Create('O filtro gen�rico deve conter ao menos uma Restri��o de Usu�rio');
    sNome := GetWord(slConstr[constraintID],1);
    PrepareFilterInspector(ConsultaCombo, naoAchou);
    InspItem := FilterInspectorFrame.DataInspector.GetItemByCaption(sNome);
    if InspItem <> nil then
      InspItem.EditText := PValue;
    if pnlCriterios.Visible OR (tipo = toMostrarResultado) then
      ShowModal;
    Result := (ModalResult = mrOK);
  end
  else
    Result := True;

end;

procedure TCustomSearchForm.GridDblClick(Sender: TObject);
begin
  inherited;
  OkButton.Click;
end;

function TCustomSearchForm.GetDataProvider: TCustomProvider;
begin
  Result := FilterDataset.DataProvider;
end;

procedure TCustomSearchForm.SetDataProvider(const Value: TCustomProvider);
begin
  if Value <> FilterDataset.DataProvider then
    FilterDataset.DataProvider := Value;
end;

function TCustomSearchForm.GetSelected: boolean;
begin
  Result := (FilterDataset.Active) AND (FilterDataset.RecordCount > 0);
end;

procedure TCustomSearchForm.ClearFilter;
begin
  ConsultaCombo.Items.Clear;
end;

procedure TCustomSearchForm.FilterDatasetBeforeClose(DataSet: TDataSet);
begin
  // Limpa o nome do �ndice porque os �ndices se tornam inv�lidos quando o
  // dataset � fechado
  FilterDataset.IndexName := '';

  // SortField conter� um endere�o inv�lido aqui
  SortField := nil;
end;

procedure TCustomSearchForm.GridCalcTitleImage(Sender: TObject;
  Field: TField; var TitleImageAttributes: TwwTitleImageAttributes);
begin
  // Se a coluna que est� sendo desenhada for aquela escolhida pelo usu�rio...
  if Field = SortField then
  begin
    // ... desenha a seta correspondente ao sentido da ordena��o desejado
    if AscendingSort then
      TitleImageAttributes.ImageIndex := 0
    else
      TitleImageAttributes.ImageIndex := 1;
  end
  else
    // Sen�o n�o desenha imagem alguma
    TitleImageAttributes.ImageIndex := -1;
end;

procedure TCustomSearchForm.GridTitleButtonClick(Sender: TObject;
  AFieldName: String);
var
  Field: TField;
  IndexOptions: TIndexOptions;
begin
  // Considera-se inv�lido o buffer da string de busca incremental quando um
  // novo field � selecionado para ordena��o
  CurrentSearchString := '';

  // Obt�m o Field correspondente do DataSet (FieldByName retorna uma exce��o
  // caso o field n�o seja encontrado. Todavia isso n�o deve acontecer, uma vez
  // que este evento ser� disparado apenas quando o dataset estiver aberto e com
  // fields v�lidos)
  Field := Grid.DataSource.DataSet.FieldByName(AFieldName);
  // Se o usu�rio clicou no mesmo field de antes ent�o...
  if Field = SortField then
    // ... muda o sentido da seta
    AscendingSort := not AscendingSort
  else
  // Sen�o se o Field � diferente ent�o...
  begin
    // ... define o novo field e redesenha o grid para remover as setas das
    // outras colunas
    SortField := Field;
    AscendingSort := True;
    Grid.RedrawGrid;
  end;

  // Garante que exista um �ndice no dataset antes de tentar apag�-lo. Esta
  // propriedade conta o n�mero de fields que comp�em o �ndice atual. Se existir
  // um �ndice ent�o ele ser� composto de pelo menos um field. E n�o �
  // necess�rio procurar pelo nome, pois o �nico �ndice do dataset ser� sempre
  // esse. (Na verdade, a pesquisa n�o foi feita pelo nome porque, no momento em
  // que isso foi escrito, eu n�o sabia faz�-la)
  Assert(FilterDataset.IndexFieldCount > 0);

  // Apaga o �ndice atual
  FilterDataset.DeleteIndex(SortIndexName);

  // Define as op��es do �ndice para n�o-sens�vel � caixa e ordena��o ascendente
  // ou descendente, de acordo com a sele��o atual
  if AscendingSort then
    IndexOptions := [ixCaseInsensitive]
  else
    IndexOptions := [ixDescending, ixCaseInsensitive];
  // Cria o �ndice no field selecionado
  FilterDataset.AddIndex(SortIndexName, AFieldName, IndexOptions);

  // Define o nome do �ndice e ordena novamente o dataset (caso j� seja aquele
  // o nome do �ndice)
  FilterDataset.IndexName := SortIndexName;
end;

procedure TCustomSearchForm.FilterDatasetAfterScroll(DataSet: TDataSet);
begin
  // Toda vez que um registro for selecionado manualmente pelo usu�rio a string
  // de busca incremental � esvaziada. Quando o m�todo de busca estiver rolando
  // o dataset a vari�vel IncrementalSearchScrolling ser� ligada para informar
  // este m�todo
  if not IncrementalSearchScrolling then
    CurrentSearchString := '';
end;

procedure TCustomSearchForm.GridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  // A tecla ESC n�o pode ser usada da mesma forma que no osCustomMainForm
  // porque aqui ela j� � usada para cancelar a caixa de di�logo

  // Sinaliza, para o evento OnKeyPress, que a tecla Alt ou Ctrl est�
  // pressionada. Isto � necess�rio porque o evento OnKeyPress n�o reconhece
  // se uma dessas teclas est� pressionada quando um caractere � recebido do
  // teclado. A tecla Shift n�o interessa ao evento OnKeyPress porque a busca
  // incremental n�o � sens�vel � caixa
  CtrlOrAltPressed := Shift * [ssAlt, ssCtrl] <> [];
end;

procedure TCustomSearchForm.GridKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  // O �ndice de ordena��o � criado no evento AfterOpen do dataset e, por isso,
  // ele deve estar obrigatoriamente criado quando este m�todo for executado e
  // o dataset estiver ativo
  Assert((not FilterDataset.Active) or Assigned(SortField));

  // N�o faz sentido usar a busca incremental enquanto o dataset est� fechado;
  // deve-se ignorar teclas como TAB e ESC, que acionam o evento OnKeyPress; a
  // tecla deve ser ignorada se Alt Ou Ctrl estiver pressionado; e, por fim, o
  // field deve ser do tipo string, porque o FindNearest n�o funciona de outro
  // modo. O teste que verifica se o dataset est� ativo deve ser feito antes
  // daquele que verifica o tipo do field para impedir que seja feito o acesso a
  // uma propriedade cujo objeto n�o existe
  if (not CtrlOrAltPressed) and (Ord(Key) >= 32) and FilterDataset.Active
      and ((SortField.DataType = ftString) or (SortField.DataType = ftWideString)) then
  begin
    // Adiciona o novo caractere � string de busca incremental
    CurrentSearchString := CurrentSearchString + Key;
    // Sinaliza para os eventos OnScroll que ir� rolar o dataset
    IncrementalSearchScrolling := True;
    try
      // Procura o registro mais semelhante, baseado na string de busca
      // acumulada at� o momento e no �ndice selecionado atualmente
      FilterDataset.FindNearest([CurrentSearchString]);
    finally
      // Restaura o valor da vari�vel
      IncrementalSearchScrolling := False;
    end;
  end;

  timer.Enabled := false;
  timer.Enabled := true;
end;


//---------nova vers�o a partir daqui

procedure TCustomSearchForm.PrepareFilterInspector(comboFilter: TosComboFilter; naoAchou: boolean);
var
  slConstr, slOrder: TStrings;
  iIndex: integer;
//  InspectorForm: TosFilterInspector;
  PNewFilter: boolean;
  i: integer;
begin
  with comboFilter do
  begin
    PNewFilter := true;
    if Items.Count = 0 then
      raise Exception.Create('N�o h� filtros na lista');
    if Text <> '' then
    begin
      iIndex := Items.IndexOf(Text);

      slConstr := GetConstrList(iIndex);
      slOrder := GetOrderList(iIndex);
      FLastOrder := '';
      if (slOrder.Count > 0) and
         (Copy(UpperCase(slOrder.Text), 1, 5) <> 'FALSE') then
          FLastOrder := GetWord(slOrder[0], 2, '=');
      if PNewFilter then
      begin
        FilterInspectorFrame.DataInspector.Items.Clear;
        if (Copy(UpperCase(slConstr.Text), 1, 5) <> 'FALSE') and (Trim(slConstr.Text) <> '')  then
        begin
          for i:=0 to slConstr.Count - 1 do
            CreateConstraint(slConstr[i], nil);

        end;
        if (slOrder.Count > 0) AND (UpperCase(slOrder[0])<>'FALSE') then
          CreateOrder(slOrder);
        FilterInspectorFrame.DataInspector.Repaint;
      end //if PNewFilter
    end;//if Text <> ''
  end;//with comboFilter do
  if FExecuteFilter then
  begin
    pnlCriterios.Visible := FilterInspectorFrame.DataInspector.Items.Count > 0;
    if pnlCriterios.Visible then
    begin
      if naoAchou then
        MostrarAviso(taNaoEncontrado)
      else
        MostrarAviso(taInformar);
      ActiveControl := FilterInspectorFrame.DataInspector;
    end
    else
    begin
      FilterInspectorFramePesquisarButtonClick(nil);
      if grid.datasource.dataset.state in [dsInactive] then
        MostrarAviso(taNaoEncontrado)
      else
        if tipo = toMostrarResultado then
          ActiveControl := grid;
    end;
  end
  else
  begin
    AvisosPanel.Visible := false;
    GridPanel.Visible := true;
    ActiveControl := grid;
  end;
  FExecuteFilter := true;
end;

procedure TCustomSearchForm.FilterInspectorFramePesquisarButtonClick(Sender: TObject);
var
  slQuery: TSQLStringList;
  iIndex: integer;
  slExpr: TStrings;
  LastExpressions: string;
  SaveCursor : TCursor;
  customFilterFunctionClass: TosCustomFilterFunctionClass;
  customFilterFunction: TosCustomFilterFunction;
begin
  with ConsultaCombo do
  begin
    slQuery := TSQLStringList.Create;
    SaveCursor := Screen.Cursor;
    try
      Screen.Cursor := crHourGlass;
      iIndex := Items.IndexOf(Text);
      if iIndex=-1 then
        raise exception.Create('Deve existir ao menos um filtro default (0)');
      slQuery.Assign(GetQueryText(iIndex));  // Copia o texto da query
      slExpr := GetExprList(iIndex);
      LastExpressions := GetExpressions;
      FLastOrder := GetOrder;
      PrepareQuery(slQuery, LastExpressions, FLastOrder, slExpr.Text);
      FParams.ParseSQL(slQuery.Text, True);
      //
      FClientDS.Close;
      if FParams.Count > 0 then
      begin
        if Assigned(FGetParams) then
          FGetParams(Self);
        FClientDS.Params.Assign(FParams);
      end
      else
        if FClientDS.Params.Count > 0 then
          FClientDS.Params.Clear;
      sqlResult.Assign(slQuery);

      FClientDS.CommandText := slQuery.Text;
      //por �ltimo faz o tratamento das fun��es definidas, dando a chance para uma classe que implemente
      //a interface ICustomFilterFunction
      customFilterFunctionClass := TosCustomFilterFunctionClass(OSGetClass('TFilterFunction'));
      if customFilterFunctionClass <> nil then
      begin
        customFilterFunction := customFilterFunctionClass.Create;
        FClientDS.CommandText :=
          customFilterFunction.evaluateFunctionValues(FClientDS.CommandText);
        sqlResult.Text := FClientDS.CommandText;
      end;
      FClientDS.DisableControls;
      FClientDS.Open;
      ConfigFields(iIndex);
      FClientDS.EnableControls;
      if FClientDS.RecordCount = 0 then
      begin
        MostrarAviso(taNaoEncontrado);
      end
      else
      begin
        if tipo = toMostrarResultado then
        begin
          AvisosPanel.Visible := False;
          GridPanel.Visible := True;
          ActiveControl := Grid;
        end;
        if tipo = toRetornarQuery then
          close;
      end;
    finally
      Screen.Cursor := SaveCursor;
      FreeAndNil(slQuery);
    end;
  end;
end;

procedure TCustomSearchForm.CreateConstraint(const PStr: string; PInspItem: TwwInspectorItem);
var
  iIniBlock, iNumWord: integer;
  InspItem: TwwInspectorItem;
  sTipoControle, sConteudo, sAux1, sAux2: string;
  sNome, sExpressao, sIdConstraint: string;
  sNomeFiltro, sNomeCampoRetorno, sNomeCampoTexto: string;
  sPStr: string;
  idConstraint: integer;
begin
  idConstraint := 0;
  if pos('#',PStr)<>0 then
  begin
    sPStr := copy(PStr,pos('#',PStr)+1,1000);
    sIdConstraint := copy(PStr,1,pos('#',PStr)-1);
    idConstraint := StrToInt(trim(sIdConstraint));
  end
  else
    sPStr := PStr;
  sNome := GetWord(sPStr, 1); // Nome
  sExpressao := GetWord(sPStr, 2); // Express�o

  if not Assigned(PInspItem) then
    InspItem := FilterInspectorFrame.DataInspector.Items.Add
  else
    InspItem := PInspItem.Items.Add;

  InspItem.Tag := idConstraint;

  {
  Formato:
  Nome;Express�o;Date
  Nome;Express�o;List;cod1,descr1,cod2,descr2,...
  Nome;Express�o;Dategroup;expr1 | expr2
  Nome;;Group Nome;Expressao[;...] | Nome;Expressao[;...] | ...
  Nome;Express�o;Filter;nome_filtro[,campo_retorno,campo_texto]
  Nome;Express�o1[~Expressao2];CONDITIONAL[,[TRUE|FALSE]]
  }

  InspItem.Caption := sNome;
  InspItem.TagString := sExpressao;
  sTipoControle := Trim(UpperCase(GetWord(sPStr, 3))); // Tipo de controle
  if sTipoControle = 'DATE' then
  begin
    InspItem.CustomControl := TosDBDateTimePicker.Create(Self);
    TosDBDateTimePicker(InspItem.CustomControl).RefObject := InspItem;
    TosDBDateTimePicker(InspItem.CustomControl).OnEnter := DatePickerOnEnter;  // Atribui o m�todo de tratamento do evento
  end
  else if sTipoControle = 'LIST' then
  begin
    InspItem.PickList.MapList := True;
    InspItem.PickList.AllowClearKey := True;
    InspItem.PickList.Style := csDropDownList;
    iNumWord := 1;
    sConteudo := GetWord(sPStr, 4); // Conte�do
    sAux1 := GetWord(sConteudo, iNumWord, ',');
    while Trim(sAux1) <> '' do
    begin
      Inc(iNumWord);
      sAux2 := GetWord(sConteudo, iNumWord, ',');
      InspItem.PickList.Items.Add(sAux2 + #9 + sAux1);
      Inc(iNumWord);
      sAux1 := GetWord(sConteudo, iNumWord, ',');
    end;
  end
  else if sTipoControle = 'DATEGROUP' then
  begin
    CreateDateList(InspItem);
    InspItem.OnItemChanged := DateListItemChanged;
    iIniBlock := Pos('DATEGROUP', UpperCase(sPStr)) + 10;
    sConteudo := Copy(sPStr, iIniBlock, Length(sPStr) - iIniBlock + 1);
    iNumWord := 1;
    sAux1 := GetWord(sConteudo, iNumWord, '|');
    while Trim(sAux1) <> '' do
    begin
      CreateConstraint(sAux1, InspItem);
      Inc(iNumWord);
      sAux1 := GetWord(sConteudo, iNumWord, '|');
    end;
  end
  else if sTipoControle = 'GROUP' then
  begin
    InspItem.DisableDefaultEditor := True;
    iIniBlock := Pos('GROUP', UpperCase(sPStr)) + 6;
    sConteudo := Copy(sPStr, iIniBlock, Length(sPStr) - iIniBlock + 1);
    iNumWord := 1;
    sAux1 := GetWord(sConteudo, iNumWord, '|');
    while Trim(sAux1) <> '' do
    begin
      CreateConstraint(sAux1, InspItem);
      Inc(iNumWord);
      sAux1 := GetWord(sConteudo, iNumWord, '|');
    end;
  end
  else if sTipoControle = 'FILTER' then
  begin
    sConteudo := GetWord(sPStr, 4); // Dados do filtro
    if Pos(',',sConteudo) <> 0 then
    begin
      sNomeFiltro := GetWord(sConteudo, 1, ',');
      sNomeCampoRetorno := GetWord(sConteudo, 2, ',');
      sNomeCampoTexto := GetWord(sConteudo, 3, ',');
    end
    else
    begin
      sNomeFiltro := sExpressao;
      sNomeCampoRetorno := '';
      sNomeCampoTexto := '';
    end;
    InspItem.CustomControl := TosComboSearch.Create(Self);
    TosComboSearch(InspItem.CustomControl).FilterDataProvider :=
      TosClientDataSet(application.mainform.FindComponent('FilterDataSet')).DataProvider;
    TosComboSearch(InspItem.CustomControl).FilterDefName := sNomeFiltro;
    TosComboSearch(InspItem.CustomControl).ReturnLookupField := sNomeCampoRetorno;
    TosComboSearch(InspItem.CustomControl).ReturnTextField := sNomeCampoTexto;
  end
  else if sTipoControle = 'CONDITIONAL' then
  begin
    sConteudo := GetWord(sPStr, 4); // Dados do filtro
    InspItem.CustomControl := TwwCheckBox.Create(self);
    (InspItem.CustomControl as TwwCheckBox).Checked :=
      not((sConteudo='') or (UpperCase(sConteudo)='FALSE'));
  end;
end;

procedure TCustomSearchForm.CreateOrder(POrderList: TStrings);
var
  InspItem: TwwInspectorItem;
  sAux1, sAux2: string;
  i: integer;
begin
  InspItem := FilterInspectorFrame.DataInspector.Items.Add;
  InspItem.Caption := 'Ordem';
  InspItem.TagString := 'ORDER';

  InspItem.PickList.MapList := True;
  InspItem.PickList.AllowClearKey := True;
  InspItem.PickList.Style := csDropDownList;

  for i:=0 to POrderList.Count - 1 do
  begin
    sAux1 := GetWord(POrderList[i], 1, '=');
    sAux2 := GetWord(POrderList[i], 2, '=');
    InspItem.PickList.Items.Add(sAux1 + #9 + sAux2);
  end;
end;

function TCustomSearchForm.GetWord(const PStr: string; PIndex: integer; PSeparator: char): string;
var
  iNumWord, i, iLen, iIni: integer;
begin
  iLen := Length(PStr);
  iNumWord := 1;
  iIni := 1;
  for i:=1 to iLen do
    if (PStr[i] = PSeparator) then
      if iNumWord = PIndex then
        break
      else
      begin
        iIni := i + 1;
        Inc(iNumWord);
      end;

  if iNumWord = PIndex then
    Result := Trim(Copy(PStr, iIni, i - iIni))
  else
    Result := '';
end;

procedure TCustomSearchForm.DatePickerOnEnter(Sender: TObject);
var
  dtPicker: TosDBDatetimePicker;
begin
  dtPicker := TosDBDatetimePicker(Sender);
  if TwwInspectorItem(dtPicker.RefObject).EditText <> '' then
    dtPicker.Date := StrToDate(TwwInspectorItem(dtPicker.RefObject).EditText);
end;

procedure TCustomSearchForm.CreateDateList(PInspItem: TwwInspectorItem);
begin
  PInspItem.PickList.MapList := True;
  PInspItem.PickList.AllowClearKey := True;
  PInspItem.PickList.Style := csDropDownList;
  PInspItem.PickList.Items.Add('Hoje' + #9 + '1');
  PInspItem.PickList.Items.Add('Ontem' + #9 + '2');
  PInspItem.PickList.Items.Add('�ltimos 3 dias' + #9 + '3');
  PInspItem.PickList.Items.Add('�ltimos 7 dias' + #9 + '4');
  PInspItem.PickList.Items.Add('�ltimos 30 dias' + #9 + '5');
  PInspItem.PickList.Items.Add('M�s atual' + #9 + '6');
  PInspItem.PickList.Items.Add('Ano atual' + #9 + '7');
  PInspItem.PickList.Items.Add('M�s anterior' + #9 + '8');
  PInspItem.PickList.Items.Add('Ano anterior' + #9 + '9');
end;

procedure TCustomSearchForm.DateListItemChanged(Sender: TwwDataInspector;
  Item: TwwInspectorItem; NewValue: String);
var
  dtIni, dtFim: TDatetime;
  dia, mes, ano: word;
begin
  case NewValue[1] of
  '1':  // Hoje
    begin
      dtIni := date;
      dtFim := date;
    end;
  '2': // Ontem
    begin
      dtIni := date-1;
      dtFim := date-1;
    end;
  '3': // �ltimos 3 dias
    begin
      dtIni := date-2;
      dtFim := date;
    end;
  '4': // �ltimos 7 dias
    begin
      dtIni := date-6;
      dtFim := date;
    end;
  '5': // �ltimos 30 dias
    begin
      dtIni := date-29;
      dtFim := date;
    end;
  '6': // M�s atual
    begin
      DecodeDate(date, ano, mes, dia);
      dtIni := EncodeDate(ano, mes, 1);
      dtFim := LastDayMonth(date);
    end;
  '7': // Ano atual
    begin
      DecodeDate(date, ano, mes, dia);
      dtIni := EncodeDate(ano, 1, 1);
      dtFim := EncodeDate(ano, 12, 31);
    end;
  '8': // M�s anterior
    begin
      DecodeDate(date, ano, mes, dia);
      Dec(mes);
      if Mes = 0 then
      begin
        Mes := 12;
        Dec(ano);
      end;
      dtIni := EncodeDate(ano, mes, 1);
      dtFim := LastDayMonth(dtIni);
    end;
  '9': // Ano anterior
    begin
      DecodeDate(date, ano, mes, dia);
      dtIni := EncodeDate(ano-1, 1, 1);
      dtFim := EncodeDate(ano-1, 12, 31);
    end;
  else
    begin
      dtIni := 0;
      dtFim := 0;
    end;
  end;

  Item.Items[0].CustomControlAlwaysPaints := False;
  Item.Items[0].EditText := FormatDatetime('dd/mm/yyyy', dtIni);
  Item.Items[1].CustomControlAlwaysPaints := False;
  Item.Items[1].EditText := FormatDatetime('dd/mm/yyyy', dtFim);
  if Item.Expanded then
  begin
    {
    //if TwwDBDateTimePicker(Item.Items[0].CustomControl).ParentWindow <> 0 then
      TwwDBDateTimePicker(Item.Items[0].CustomControl).Date := dtIni;
    //if TwwDBDateTimePicker(Item.Items[1].CustomControl).ParentWindow <> 0 then
      TwwDBDateTimePicker(Item.Items[1].CustomControl).Date := dtFim;
    }
  end;
end;

function TCustomSearchForm.LastDayMonth(PDate: TDatetime): TDatetime;
var
  ano, mes, dia: word;
begin
  DecodeDate(PDate, ano, mes, dia);
  Result := PDate + 35 - dia;
  DecodeDate(Result, ano, mes, dia);
  Result := Result - dia;
end;

function TCustomSearchForm.GetExpressions: string;
var
  i, j: integer;
  sCon, sAux: string;
  InspItem, InspItemChild: TwwInspectorItem;
  comboSearch: TosComboSearch;
  listaRestricoesPreenchidas: TList;
  restricao, restricaoChild: TRestricaoUsuario;
begin
  if not CamposObrigatoriosPreenchidos then
  begin
    ShowMessage('Preencha as informa��es obrigat�rias.');
    Abort;
  end;

  listaRestricoesPreenchidas := TList.Create;

  Result := '';
  sCon := '';
  for i:=0 to FilterInspectorFrame.DataInspector.Items.Count-1 do
  begin
    InspItem := FilterInspectorFrame.DataInspector.Items[i];
    restricao := TRestricaoUsuario.Create;
    restricao.IdRestricao := InspItem.tag;
    restricao.Texto := InspItem.editText;
    if InspItem.Items.Count > 0 then
    begin
      for j:=0 to InspItem.Items.Count - 1 do
      begin
        InspItemChild := InspItem.Items[j];
        if Trim(InspItemChild.EditText) <> '' then
        begin
          restricaoChild := TRestricaoUsuario.Create;
          restricaoChild.IdRestricao := InspItemChild.Tag;
          restricaoChild.Id          := 0;
          restricaoChild.Texto := InspItemChild.EditText;
          if InspItemChild.CustomControl is TosDBDateTimePicker then
            sAux := sCon + Format(InspItemChild.TagString,[SQLDateFromStr(InspItemChild.EditText)])
          else
            if InspItemChild.CustomControl is TosComboSearch then
            begin
              comboSearch := (InspItemChild.CustomControl as TosComboSearch);
              sAux := '';
              if VarToStr(comboSearch.ReturnedValue)<>'-1' then
                sAux := sCon + Format(InspItemChild.TagString,[VarToStr(comboSearch.ReturnedValue)]);
              restricao.id := comboSearch.ReturnedValue;
            end
            else
              sAux := sCon + Format(InspItemChild.TagString,[InspItemChild.EditText]);
          listaRestricoesPreenchidas.Add(restricaoChild);
          ReplaceSpecialChars(sAux); // M�todo privado \
          if sAux<>'' then
          begin
            Result := Result + sAux;
            sAux := '';
            sCon := ' AND ';
          end;
        end;
      end;
    end
    else if ((Trim(InspItem.EditText) <> '') and (InspItem.TagString <> 'ORDER')) OR (InspItem.CustomControl is TwwCheckBox) then
    begin
      if InspItem.CustomControl is TosDBDateTimePicker then
        sAux := sCon + Format(InspItem.TagString,[SQLDateFromStr(InspItem.EditText)])
      else
        if InspItem.CustomControl is TosComboSearch then
        begin
          comboSearch := (InspItem.CustomControl as TosComboSearch);
          sAux := '';
          if VarToStr(comboSearch.ReturnedValue)<>'-1' then
            sAux := sCon + Format(InspItem.TagString,[VarToStr(comboSearch.ReturnedValue)]);
          restricao.id := comboSearch.ReturnedValue;
        end
        else
        if InspItem.CustomControl is TwwCheckBox then
        begin
          if TwwCheckBox(InspItem.CustomControl).checked then
            restricao.Texto := 'S'
          else
            restricao.Texto := 'N';
          //se possui as duas senten�as usa a mais adequada
          if pos('~',InspItem.TagString)<>0 then
          begin
            if (InspItem.CustomControl as TwwCheckBox).Checked then
              sAux := sCon + copy(InspItem.TagString,1,pos('~',InspItem.TagString)-1)
            else
              sAux := sCon + copy(InspItem.TagString,pos('~',InspItem.TagString)+1,1000);
          end
          else //se possui s� uma senten�a, s� a insere se estiver checkado
            if (InspItem.CustomControl as TwwCheckBox).Checked then
              sAux := sCon + Format(InspItem.TagString,[InspItem.EditText]);
        end
        else
          sAux := sCon + Format(InspItem.TagString,[InspItem.EditText]);
      ReplaceSpecialChars(sAux); // M�todo privado
      if sAux<>'' then
      begin
        Result := Result + sAux;
        sAux := '';
        sCon := ' AND ';
      end;
    end;
    listaRestricoesPreenchidas.Add(restricao);
  end;
  if GlobalListaRestricoesUsuario<>nil then
    FreeAndNil(GlobalListaRestricoesUsuario);
  GlobalListaRestricoesUsuario := listaRestricoesPreenchidas;
end;

function TCustomSearchForm.GetOrder: string;
var
  InspItem: TwwInspectorItem;
begin
  InspItem := FilterInspectorFrame.DataInspector.GetItemByTagString('ORDER');
  if Assigned(InspItem) then
    Result := InspItem.EditText
  else
    Result := '';
end;

function TCustomSearchForm.SQLDateFromStr(PStr: string): string;
begin
  Result := FormatDatetime('yyyy/mm/dd', StrToDate(PStr));
end;

procedure  TCustomSearchForm.ReplaceSpecialChars(var PStr: string);
var
  i, iLen: integer;
begin
  iLen := Length(PStr);
  for i:=1 to iLen do
    if PStr[i] = '*' then
      PStr[i] := '%';
end;

procedure TCustomSearchForm.MostrarAviso(tipo: TTipoAviso);
begin
  GridPanel.Visible := False;
  AvisosPanel.Visible := true;
  FilterDataset.Close;
  case tipo of
    taInformar:
      begin
        NaoEncontradoLabel.Visible := false;
        InformarLabel.Top := 4;
        InformarLabel.Visible := true;
      end;
    taNaoEncontrado:
      begin
        InformarLabel.Visible := false;
        NaoEncontradoLabel.Top := 4;
        NaoEncontradoLabel.Visible := True;
      end;
  end;
end;

procedure TCustomSearchForm.FilterInspectorFrameDataInspectorEnter(Sender: TObject);
begin
  OkButton.Enabled := False;
  OkButton.Default := False;
  FilterInspectorFrame.PesquisarButton.Default := True;
end;

procedure TCustomSearchForm.GridEnter(Sender: TObject);
begin
  OkButton.Enabled := True;
  OkButton.Default := True;
  FilterInspectorFrame.PesquisarButton.Default := False;
end;

procedure TCustomSearchForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key  = #27 then
  begin
    ModalResult := mrCancel;
    Close;
  end;

  if AltPressed then
  begin
    if key=#15 then
      MessageDlg('o', mtWarning, [mbOK], 0);
  end;

end;

procedure TCustomSearchForm.TimerTimer(Sender: TObject);
begin
  CurrentSearchString := '';
  Timer.Enabled := false;
end;

procedure TCustomSearchForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  AltPressed := ssAlt in Shift;
end;

procedure TCustomSearchForm.getUserFills(fills: TStringList);
var
  di: TwwDataInspector;
begin
  di := FilterInspectorFrame.DataInspector;
  if di=nil then
    exit;
  fills.clear;
end;

function TCustomSearchForm.CamposObrigatoriosPreenchidos: Boolean;
var
  i, j: Integer;
  InspItem, InspChild: TwwInspectorItem;
begin
  Result := True;
  for i:=0 to FilterinspectorFrame.DataInspector.Items.Count-1 do
  begin
    InspItem := FilterinspectorFrame.DataInspector.Items[i];
    if (InspItem.Caption[Length(InspItem.Caption)] = '*') and
       (not (InspItem.CustomControl is TwwCheckBox)) then
    begin
      if InspItem.Items.Count > 0 then
      begin
        for j := 0 to InspItem.Items.Count - 1 do
        begin
          InspChild := InspItem.Items[j];
          if Trim(InspChild.EditText) = '' then
            Result := False;
        end;
      end
      else
      begin
        if Trim(InspItem.EditText) = '' then
          Result := False;
      end;
    end;
  end;
end;

end.
