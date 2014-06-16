unit osClientDataset;

interface

uses
  sysutils, classes, dbtables, typinfo, contnrs, dbclient, dialogs,
  db, provider, variants;

type
  TosClientDataset = class(TClientDataset)
  private
    FDataProvider : TCustomProvider;
    FIDHighValue: integer;
    FIDLowValue: integer;
    FIDField: TField;
    FRootClientDS: TosClientDataset;
    //FOnUserReconcileError: TReconcileErrorEvent;
    FClosedLookup: boolean;
    FDataLink: TDataLink;
    FHasKey: boolean;
    FBizDatamoduleName: string;
    FIDName: string;
    FDeleteDetails: boolean;
    procedure InitAppServer;
    procedure SetDataProvider(Value : TCustomProvider);
    procedure SetClosedLookup(const Value: boolean);
    procedure RefreshParams;
    function GetMasterDataSource: TDataSource;
    procedure SetMasterDataSource(const Value: TDataSource);
    function GetHasKey: boolean;
    function GetIDField: TField;
    function GetQuotedString(const PStr: string): string;

    procedure ClearDataSet(DataSet: TDataSet);
    procedure ClearDetails(DataSet: TDataSet);

    function ReadColuna(pos:Integer):String;
    function ReadNomeColuna(pos:Integer):String;
    function ReadColuna1: string;
    function ReadNomeColuna1: string;
    function ReadColuna2: string;
    function ReadNomeColuna2: string;
    function ReadColuna3: string;
    function ReadNomeColuna3: string;
    function ReadColuna4: string;
    function ReadNomeColuna4: string;
    function ReadColuna5: string;
    function ReadNomeColuna5: string;
    function ReadColuna6: string;
    function ReadNomeColuna6: string;
    function ReadColuna7: string;
    function ReadNomeColuna7: string;
    function ReadColuna8: string;
    function ReadNomeColuna8: string;
    function ReadColuna9: string;
    function ReadNomeColuna9: string;
    function ReadColuna10: string;
    function ReadNomeColuna10: string;
    function ReadColuna11: string;
    function ReadNomeColuna11: string;
    function ReadColuna12: string;
    function ReadNomeColuna12: string;
    function ReadColuna13: string;
    function ReadNomeColuna13: string;
    function ReadColuna14: string;
    function ReadNomeColuna14: string;
    function ReadColuna15: string;
    function ReadNomeColuna15: string;
    function ReadColuna16: string;
    function ReadNomeColuna16: string;
    function ReadColuna17: string;
    function ReadNomeColuna17: string;
    function ReadColuna18: string;
    function ReadNomeColuna18: string;
    function ReadColuna19: string;
    function ReadNomeColuna19: string;
    function ReadColuna20: string;
    function ReadNomeColuna20: string;
    function ReadColuna21: string;
    function ReadNomeColuna21: string;
    function ReadColuna22: string;
    function ReadNomeColuna22: string;
    function ReadColuna23: string;
    function ReadNomeColuna23: string;
    function ReadColuna24: string;
    function ReadNomeColuna24: string;
    function ReadColuna25: string;
    function ReadNomeColuna25: string;
    function ReadColuna26: string;
    function ReadNomeColuna26: string;
    function ReadColuna27: string;
    function ReadNomeColuna27: string;
    function ReadColuna28: string;
    function ReadNomeColuna28: string;
    function ReadColuna29: string;
    function ReadNomeColuna29: string;
    function ReadColuna30: string;
    function ReadNomeColuna30: string;
    function ReadColuna31: string;
    function ReadNomeColuna31: string;
    function ReadColuna32: string;
    function ReadNomeColuna32: string;
    function ReadColuna33: string;
    function ReadNomeColuna33: string;
    function ReadColuna34: string;
    function ReadNomeColuna34: string;
    function ReadColuna35: string;
    function ReadNomeColuna35: string;
    function ReadColuna36: string;
    function ReadNomeColuna36: string;
    function ReadColuna37: string;
    function ReadNomeColuna37: string;
    function ReadColuna38: string;
    function ReadNomeColuna38: string;
    function ReadColuna39: string;
    function ReadNomeColuna39: string;
    function ReadColuna40: string;
    function ReadNomeColuna40: string;
    function ReadColuna41: string;
    function ReadNomeColuna41: string;
    function ReadColuna42: string;
    function ReadNomeColuna42: string;
    function ReadColuna43: string;
    function ReadNomeColuna43: string;
    function ReadColuna44: string;
    function ReadNomeColuna44: string;
    function ReadColuna45: string;
    function ReadNomeColuna45: string;
    function ReadColuna46: string;
    function ReadNomeColuna46: string;
    function ReadColuna47: string;
    function ReadNomeColuna47: string;
    function ReadColuna48: string;
    function ReadNomeColuna48: string;
    function ReadColuna49: string;
    function ReadNomeColuna49: string;
    function ReadColuna50: string;
    function ReadNomeColuna50: string;

  protected
    FClearing : boolean;
    procedure Notification(AComponent : TComponent; Operation : TOperation); override;
    procedure DoBeforePost; override;
    procedure DoOnNewRecord; override;
    procedure DoBeforeOpen; override;
    procedure DoBeforeDelete; override;
    procedure OpenCursor(InfoQuery: Boolean = False); override;
    {procedure HandleReconcileError(DataSet: TClientDataSet;
      E: EReconcileError; UpdateKind: TUpdateKind;
      var Action: TReconcileAction); }
    procedure Loaded; override;

    property RootClientDS: TosClientDataset read FRootClientDS;
    property DataLink: TDataLink read FDataLink;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetNewID: integer;
    procedure RefreshCalcFields;
    function Lookup(const KeyFields: string; const KeyValues: Variant;
      const ResultFields: string): Variant; override;
    procedure GetRecordByID(const PID: integer);
    procedure CloseCursor; override;
    procedure Post; override;
    //procedure LoadFromDataset(PDataset: TDataset);
    property IDField: TField read GetIDField;
  published
    property DataProvider : TCustomProvider read FDataProvider write SetDataProvider;
    property ClosedLookup: boolean read FClosedLookup write SetClosedLookup default False;
    property MasterDataSource: TDataSource read GetMasterDataSource write SetMasterDataSource;
    property HasKey: boolean read GetHasKey;
    property BizDatamoduleName: string read FBizDatamoduleName write FBizDatamoduleName;
    property IDName: string read FIDName write FIDName;
    property DeleteDetails: boolean read FDeleteDetails write FDeleteDetails default True;
    property Active stored False;

    // informações para o TestComplete
    property Coluna01: String read ReadColuna1;
    property Coluna01Nome: String read ReadNomeColuna1;
    property Coluna02: String read ReadColuna2;
    property Coluna02Nome: String read ReadNomeColuna2;
    property Coluna03: String read ReadColuna3;
    property Coluna03Nome: String read ReadNomeColuna3;
    property Coluna04: String read ReadColuna4;
    property Coluna04Nome: String read ReadNomeColuna4;
    property Coluna05: String read ReadColuna5;
    property Coluna05Nome: String read ReadNomeColuna5;
    property Coluna06: String read ReadColuna6;
    property Coluna06Nome: String read ReadNomeColuna6;
    property Coluna07: String read ReadColuna7;
    property Coluna07Nome: String read ReadNomeColuna7;
    property Coluna08: String read ReadColuna8;
    property Coluna08Nome: String read ReadNomeColuna8;
    property Coluna09: String read ReadColuna9;
    property Coluna09Nome: String read ReadNomeColuna9;
    property Coluna10: String read ReadColuna10;
    property Coluna10Nome: String read ReadNomeColuna10;
    property Coluna11: String read ReadColuna11;
    property Coluna11Nome: String read ReadNomeColuna11;
    property Coluna12: String read ReadColuna12;
    property Coluna12Nome: String read ReadNomeColuna12;
    property Coluna13: String read ReadColuna13;
    property Coluna13Nome: String read ReadNomeColuna13;
    property Coluna14: String read ReadColuna14;
    property Coluna14Nome: String read ReadNomeColuna14;
    property Coluna15: String read ReadColuna15;
    property Coluna15Nome: String read ReadNomeColuna15;
    property Coluna16: String read ReadColuna16;
    property Coluna16Nome: String read ReadNomeColuna16;
    property Coluna17: String read ReadColuna17;
    property Coluna17Nome: String read ReadNomeColuna17;
    property Coluna18: String read ReadColuna18;
    property Coluna18Nome: String read ReadNomeColuna18;
    property Coluna19: String read ReadColuna19;
    property Coluna19Nome: String read ReadNomeColuna19;
    property Coluna20: String read ReadColuna20;
    property Coluna20Nome: String read ReadNomeColuna20;
    property Coluna21: String read ReadColuna21;
    property Coluna21Nome: String read ReadNomeColuna21;
    property Coluna22: String read ReadColuna22;
    property Coluna22Nome: String read ReadNomeColuna22;
    property Coluna23: String read ReadColuna23;
    property Coluna23Nome: String read ReadNomeColuna23;
    property Coluna24: String read ReadColuna24;
    property Coluna24Nome: String read ReadNomeColuna24;
    property Coluna25: String read ReadColuna25;
    property Coluna25Nome: String read ReadNomeColuna25;
    property Coluna26: String read ReadColuna26;
    property Coluna26Nome: String read ReadNomeColuna26;
    property Coluna27: String read ReadColuna27;
    property Coluna27Nome: String read ReadNomeColuna27;
    property Coluna28: String read ReadColuna28;
    property Coluna28Nome: String read ReadNomeColuna28;
    property Coluna29: String read ReadColuna29;
    property Coluna29Nome: String read ReadNomeColuna29;
    property Coluna30: String read ReadColuna30;
    property Coluna30Nome: String read ReadNomeColuna30;
    property Coluna31: String read ReadColuna31;
    property Coluna31Nome: String read ReadNomeColuna31;
    property Coluna32: String read ReadColuna32;
    property Coluna32Nome: String read ReadNomeColuna32;
    property Coluna33: String read ReadColuna33;
    property Coluna33Nome: String read ReadNomeColuna33;
    property Coluna34: String read ReadColuna34;
    property Coluna34Nome: String read ReadNomeColuna34;
    property Coluna35: String read ReadColuna35;
    property Coluna35Nome: String read ReadNomeColuna35;
    property Coluna36: String read ReadColuna36;
    property Coluna36Nome: String read ReadNomeColuna36;
    property Coluna37: String read ReadColuna37;
    property Coluna37Nome: String read ReadNomeColuna37;
    property Coluna38: String read ReadColuna38;
    property Coluna38Nome: String read ReadNomeColuna38;
    property Coluna39: String read ReadColuna39;
    property Coluna39Nome: String read ReadNomeColuna39;
    property Coluna40: String read ReadColuna40;
    property Coluna40Nome: String read ReadNomeColuna40;
    property Coluna41: String read ReadColuna41;
    property Coluna41Nome: String read ReadNomeColuna41;
    property Coluna42: String read ReadColuna42;
    property Coluna42Nome: String read ReadNomeColuna42;
    property Coluna43: String read ReadColuna43;
    property Coluna43Nome: String read ReadNomeColuna43;
    property Coluna44: String read ReadColuna44;
    property Coluna44Nome: String read ReadNomeColuna44;
    property Coluna45: String read ReadColuna45;
    property Coluna45Nome: String read ReadNomeColuna45;
    property Coluna46: String read ReadColuna46;
    property Coluna46Nome: String read ReadNomeColuna46;
    property Coluna47: String read ReadColuna47;
    property Coluna47Nome: String read ReadNomeColuna47;
    property Coluna48: String read ReadColuna48;
    property Coluna48Nome: String read ReadNomeColuna48;
    property Coluna49: String read ReadColuna49;
    property Coluna49Nome: String read ReadNomeColuna49;
    property Coluna50: String read ReadColuna50;
    property Coluna50Nome: String read ReadNomeColuna50;


  end;

  // Utilizada para estabelecer relacionamentos mestre-detalhe
  TccClientDataLink = class(TDetailDataLink)
  private
    FClientDataset: TosClientDataset;
  protected
    procedure ActiveChanged; override;
    procedure RecordChanged(Field: TField); override;
    function GetDetailDataSet: TDataSet; override;
    procedure CheckBrowseMode; override;
  public
    constructor Create(AClientDataset: TosClientDataset);
  end;

  TStringListExt = class(TStringList)
  private
    FElementFormat: string;
    FSeparator: string;
    function GetAsFmtText: string;
    procedure SetElementFormat(const Value: string);
    procedure SetSeparator(const Value: string);
  public
    constructor Create; virtual;
    procedure PrepareForID;
  published
    property Separator: string read FSeparator write SetSeparator;
    property ElementFormat: string read FElementFormat write SetElementFormat;
    property AsFmtText: string read GetAsFmtText;
  end;

  procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('OS Controls', [TosClientDataset]);
end;

{ TosClientDataset }

procedure TosClientDataset.CloseCursor;
begin
  inherited CloseCursor;
  if Assigned(DataProvider) then // Only reset AppServer if we're using a local connection
    InitAppServer;
end;

constructor TosClientDataset.Create(AOwner: TComponent);
begin
  inherited;
  FIDHighValue := -1;
  FIDLowValue := 0;
  FClosedLookup := False;
  FetchOnDemand := False;
  FDataLink := TccClientDataLink.Create(Self);
  FIDField := nil;
  FHasKey := False;
  FClearing := False;
  FDeleteDetails := True;
end;

destructor TosClientDataset.Destroy;
begin
  FDataLink.Free;
  inherited;
end;

procedure TosClientDataset.DoBeforeOpen;
begin
  inherited;
  if Assigned(DatasetField) then
    if Assigned(TosClientDataset(DatasetField.Dataset).RootClientDS) then
      FRootClientDS := TosClientDataset(DatasetField.Dataset).RootClientDS
    else
      FRootClientDS := TosClientDataset(DatasetField.Dataset);
end;

procedure TosClientDataset.DoOnNewRecord;
begin
  if Assigned(FIDField) then
    FIDField.Value := GetNewID;
    //FIDField.AsString := IntToHex(GetNewID, 12);
  inherited;
end;

function TosClientDataset.GetHasKey: boolean;
begin
  Result := Assigned(IDField);
end;

function TosClientDataset.GetMasterDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

function TosClientDataset.GetNewID: integer;
var
  v: variant;
  vCmd: OleVariant;
  sName: string;
begin
  // Se estourou a faixa, lê um novo HighValue
  if Assigned(FRootClientDS) then  // Se é detalhe pede o valor para o "raiz"
    Result := FRootClientDS.GetNewID
  else // é o raiz, fornece o valor
  begin
    if (FIDLowValue = 10) or (FIDHighValue = -1) then
    begin
      sName := IDName;
      if sName = '' then
        sName := 'Geral';
      vCmd := VarArrayOf(['_CMD','GET_IDHIGH',sName]);
      v := DataRequest(vCmd);
      if v = NULL then
        raise Exception.Create('Não conseguiu obter o ID do server para inclusão');
      FIDHighValue := v; // por convenção
      FIDLowValue := 0;
    end;                        
    Result := FIDHighValue * 10 + FIDLowValue;
    Inc(FIDLowValue);
  end;
end;

function TosClientDataset.GetIDField: TField;
var
  i: integer;
begin
  if not Assigned(FIDField) then
  begin
    for i:=0 to Fields.Count-1 do
      if pfInKey in Fields[i].ProviderFlags then
      begin
        FIDField := Fields[i];
        break;
      end;
    if not Assigned(FIDField) then
      FIDField := FindField('ID');
  end;
  Result := FIDField;
end;

procedure TosClientDataset.GetRecordByID(const PID: integer);
begin
  if Assigned(FIDField) then
  begin
    Close;
    Params.ParamByName('ID').AsInteger := PID;
    Open;
  end;
end;

{
procedure TosClientDataset.HandleReconcileError(DataSet: TClientDataSet;
  E: EReconcileError; UpdateKind: TUpdateKind;
  var Action: TReconcileAction);
begin
  if Assigned(FOnUserReconcileError) then
    FOnUserReconcileError(DataSet, E, UpdateKind, Action);
  ShowMessage(E.Message);
end;
}

procedure TosClientDataset.InitAppServer;
begin
try
  if FDataProvider is TCustomProvider then
    AppServer := TLocalAppServer.Create(TCustomProvider(FDataProvider))
  else
    AppServer := TLocalAppServer.Create(TDataset(FDataProvider));
except
  on EDatabaseError do
    Abort;
end;

end;

procedure TosClientDataset.Loaded;
//var
//  TempParam: TParam;
//  TempComp: TComponent;
begin
  inherited;
  {
  if (not Assigned(DataProvider)) and (Trim(BizDatamoduleName)<>'') then
  begin
    TempComp := GetComponentByName(GetDatamoduleByName(BizDatamoduleName),'prvMaster', TCustomProvider);
    if Assigned(Tempcomp) then
      DataProvider := TCustomProvider(TempComp);
  end;
  }
  {
  if Assigned(OnReconcileError) then
    FOnUserReconcileError := OnReconcileError;
  OnReconcileError := HandleReconcileError;
  }

  { Ex de parâmetros automáticos
  if cfEmpresa in FCustomFilterOptions then
  begin
    TempParam := Params.FindParam('Empresa');
    if not Assigned(TempParam) then
      TempParam := Params.CreateParam(ftString, 'Empresa', ptInput);
    TempParam.AsString := GlobalEmpresa;
  end;
  }
end;

{
procedure TosClientDataset.LoadFromDataset(PDataset: TDataset);
var
  prvTemp: TDataSetProvider;
  bActive: boolean;
begin
  bActive := PDataset.Active;
  prvTemp := TDataSetProvider.Create(Self);
  try
    prvTemp.DataSet := PDataset;
    if not bActive then
      PDataset.Open;
    Self.Data := prvTemp.Data;
    if not bActive then
      PDataset.Close;
  finally
    prvTemp.Free;
  end;
end;
}

function TosClientDataset.Lookup(const KeyFields: string;
  const KeyValues: Variant; const ResultFields: string): Variant;
var
  Param: TParam;
begin
  Result := Null;
  if KeyValues <> Null then
  begin
    if FClosedLookup then
    begin
      //if not ((HasKey) and (KeyFields = IDField.FieldName)) then
      //  raise Exception.Create('Não é possivel fazer ClosedLookup de fields diferentes de ID.');

      if IDField.AsString <> VarToStr(KeyValues) then // Se já estiver na memória
      begin
        Param := Params.FindParam(KeyFields);
        if not Assigned(Param) then
          raise Exception.CreateFmt('O parâmetro chave é necessário para se fazer ClosedLookup - Componente: %s', [Self.Name]);
        Close;
        Param.Value := KeyValues;
        Open;
      end;
      if LocateRecord(KeyFields, KeyValues, [], False) then
      begin
        SetTempState(dsCalcFields);
        try
          CalculateFields(TempBuffer);
          Result := FieldValues[ResultFields];
        finally
          RestoreState(dsBrowse);
        end;
      end;
    end
    else  // Executa o lookup padrão (do ancestral), ou seja com os dados armazenados internamente
    begin
      Result := inherited Lookup(KeyFields, KeyValues, ResultFields);
    end;
  end;
end;

procedure TosClientDataset.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (AComponent = FDataProvider) then
    AppServer := nil;
end;

procedure TosClientDataset.OpenCursor(InfoQuery: Boolean);
begin
  inherited OpenCursor(InfoQuery);
   if not InfoQuery then
    GetIDField;
end;

function TosClientDataset.ReadColuna(pos: Integer): String;
begin
  if Fields.Count >= pos then
    Result := Fields[pos-1].AsString
  else
    Result := '';
end;

function TosClientDataset.ReadColuna1: string;
begin
  Result := ReadColuna(1);
end;

function TosClientDataset.ReadColuna10: string;
begin
  Result := ReadColuna(10);
end;

function TosClientDataset.ReadColuna11: string;
begin
  Result := ReadColuna(11);
end;

function TosClientDataset.ReadColuna12: string;
begin
  Result := ReadColuna(12);
end;

function TosClientDataset.ReadColuna13: string;
begin
  Result := ReadColuna(13);
end;

function TosClientDataset.ReadColuna14: string;
begin
  Result := ReadColuna(14);
end;

function TosClientDataset.ReadColuna15: string;
begin
  Result := ReadColuna(15);
end;

function TosClientDataset.ReadColuna16: string;
begin
  Result := ReadColuna(16);
end;

function TosClientDataset.ReadColuna17: string;
begin
  Result := ReadColuna(17);
end;

function TosClientDataset.ReadColuna18: string;
begin
  Result := ReadColuna(18);
end;

function TosClientDataset.ReadColuna19: string;
begin
  Result := ReadColuna(19);
end;

function TosClientDataset.ReadColuna2: string;
begin
  Result := ReadColuna(2);
end;

function TosClientDataset.ReadColuna20: string;
begin
  Result := ReadColuna(20);
end;

function TosClientDataset.ReadColuna21: string;
begin
  Result := ReadColuna(21);
end;

function TosClientDataset.ReadColuna22: string;
begin
  Result := ReadColuna(22);
end;

function TosClientDataset.ReadColuna23: string;
begin
  Result := ReadColuna(23);
end;

function TosClientDataset.ReadColuna24: string;
begin
  Result := ReadColuna(24);
end;

function TosClientDataset.ReadColuna25: string;
begin
  Result := ReadColuna(25);
end;

function TosClientDataset.ReadColuna26: string;
begin
  Result := ReadColuna(26);
end;

function TosClientDataset.ReadColuna27: string;
begin
  Result := ReadColuna(27);
end;

function TosClientDataset.ReadColuna28: string;
begin
  Result := ReadColuna(28);
end;

function TosClientDataset.ReadColuna29: string;
begin
  Result := ReadColuna(29);
end;

function TosClientDataset.ReadColuna3: string;
begin
  Result := ReadColuna(3);
end;

function TosClientDataset.ReadColuna30: string;
begin
  Result := ReadColuna(30);
end;

function TosClientDataset.ReadColuna31: string;
begin
  Result := ReadColuna(31);
end;

function TosClientDataset.ReadColuna32: string;
begin
  Result := ReadColuna(32);
end;

function TosClientDataset.ReadColuna33: string;
begin
  Result := ReadColuna(33);
end;

function TosClientDataset.ReadColuna34: string;
begin
  Result := ReadColuna(34);
end;

function TosClientDataset.ReadColuna35: string;
begin
  Result := ReadColuna(35);
end;

function TosClientDataset.ReadColuna36: string;
begin
  Result := ReadColuna(36);
end;

function TosClientDataset.ReadColuna37: string;
begin
  Result := ReadColuna(37);
end;

function TosClientDataset.ReadColuna38: string;
begin
  Result := ReadColuna(38);
end;

function TosClientDataset.ReadColuna39: string;
begin
  Result := ReadColuna(39);
end;

function TosClientDataset.ReadColuna4: string;
begin
  Result := ReadColuna(4);
end;

function TosClientDataset.ReadColuna40: string;
begin
  Result := ReadColuna(40);
end;

function TosClientDataset.ReadColuna41: string;
begin
  Result := ReadColuna(41);
end;

function TosClientDataset.ReadColuna42: string;
begin
  Result := ReadColuna(42);
end;

function TosClientDataset.ReadColuna43: string;
begin
  Result := ReadColuna(43);
end;

function TosClientDataset.ReadColuna44: string;
begin
  Result := ReadColuna(44);
end;

function TosClientDataset.ReadColuna45: string;
begin
  Result := ReadColuna(45);
end;

function TosClientDataset.ReadColuna46: string;
begin
  Result := ReadColuna(46);
end;

function TosClientDataset.ReadColuna47: string;
begin
  Result := ReadColuna(47);
end;

function TosClientDataset.ReadColuna48: string;
begin
  Result := ReadColuna(48);
end;

function TosClientDataset.ReadColuna49: string;
begin
  Result := ReadColuna(49);
end;

function TosClientDataset.ReadColuna5: string;
begin
  Result := ReadColuna(5);
end;

function TosClientDataset.ReadColuna50: string;
begin
  Result := ReadColuna(50);
end;

function TosClientDataset.ReadColuna6: string;
begin
  Result := ReadColuna(6);
end;

function TosClientDataset.ReadColuna7: string;
begin
  Result := ReadColuna(7);
end;

function TosClientDataset.ReadColuna8: string;
begin
  Result := ReadColuna(8);
end;

function TosClientDataset.ReadColuna9: string;
begin
  Result := ReadColuna(9);
end;

function TosClientDataset.ReadNomeColuna(pos: Integer): String;
begin
  if Fields.Count >= pos then
    Result := Fields[pos-1].FieldName
  else
    Result := '';
end;

function TosClientDataset.ReadNomeColuna1: string;
begin
  Result := ReadNomeColuna(1);
end;

function TosClientDataset.ReadNomeColuna10: string;
begin
  Result := ReadNomeColuna(10);
end;

function TosClientDataset.ReadNomeColuna11: string;
begin
  Result := ReadNomeColuna(11);
end;

function TosClientDataset.ReadNomeColuna12: string;
begin
  Result := ReadNomeColuna(12);
end;

function TosClientDataset.ReadNomeColuna13: string;
begin
  Result := ReadNomeColuna(13);
end;

function TosClientDataset.ReadNomeColuna14: string;
begin
  Result := ReadNomeColuna(14);
end;

function TosClientDataset.ReadNomeColuna15: string;
begin
  Result := ReadNomeColuna(15);
end;

function TosClientDataset.ReadNomeColuna16: string;
begin
  Result := ReadNomeColuna(16);
end;

function TosClientDataset.ReadNomeColuna17: string;
begin
  Result := ReadNomeColuna(17);
end;

function TosClientDataset.ReadNomeColuna18: string;
begin
  Result := ReadNomeColuna(18);
end;

function TosClientDataset.ReadNomeColuna19: string;
begin
  Result := ReadNomeColuna(19);
end;

function TosClientDataset.ReadNomeColuna2: string;
begin
  Result := ReadNomeColuna(2);
end;

function TosClientDataset.ReadNomeColuna20: string;
begin
  Result := ReadNomeColuna(20);
end;

function TosClientDataset.ReadNomeColuna21: string;
begin
  Result := ReadNomeColuna(21);
end;

function TosClientDataset.ReadNomeColuna22: string;
begin
  Result := ReadNomeColuna(22);
end;

function TosClientDataset.ReadNomeColuna23: string;
begin
  Result := ReadNomeColuna(23);
end;

function TosClientDataset.ReadNomeColuna24: string;
begin
  Result := ReadNomeColuna(24);
end;

function TosClientDataset.ReadNomeColuna25: string;
begin
  Result := ReadNomeColuna(25);
end;

function TosClientDataset.ReadNomeColuna26: string;
begin
  Result := ReadNomeColuna(26);
end;

function TosClientDataset.ReadNomeColuna27: string;
begin
  Result := ReadNomeColuna(27);
end;

function TosClientDataset.ReadNomeColuna28: string;
begin
  Result := ReadNomeColuna(28);
end;

function TosClientDataset.ReadNomeColuna29: string;
begin
  Result := ReadNomeColuna(29);
end;

function TosClientDataset.ReadNomeColuna3: string;
begin
  Result := ReadNomeColuna(3);
end;

function TosClientDataset.ReadNomeColuna30: string;
begin
  Result := ReadNomeColuna(30);
end;

function TosClientDataset.ReadNomeColuna31: string;
begin
  Result := ReadNomeColuna(31);
end;

function TosClientDataset.ReadNomeColuna32: string;
begin
  Result := ReadNomeColuna(32);
end;

function TosClientDataset.ReadNomeColuna33: string;
begin
  Result := ReadNomeColuna(33);
end;

function TosClientDataset.ReadNomeColuna34: string;
begin
  Result := ReadNomeColuna(34);
end;

function TosClientDataset.ReadNomeColuna35: string;
begin
  Result := ReadNomeColuna(35);
end;

function TosClientDataset.ReadNomeColuna36: string;
begin
  Result := ReadNomeColuna(36);
end;

function TosClientDataset.ReadNomeColuna37: string;
begin
  Result := ReadNomeColuna(37);
end;

function TosClientDataset.ReadNomeColuna38: string;
begin
  Result := ReadNomeColuna(38);
end;

function TosClientDataset.ReadNomeColuna39: string;
begin
  Result := ReadNomeColuna(39);
end;

function TosClientDataset.ReadNomeColuna4: string;
begin
  Result := ReadNomeColuna(4);
end;

function TosClientDataset.ReadNomeColuna40: string;
begin
  Result := ReadNomeColuna(40);
end;

function TosClientDataset.ReadNomeColuna41: string;
begin
  Result := ReadNomeColuna(41);
end;

function TosClientDataset.ReadNomeColuna42: string;
begin
  Result := ReadNomeColuna(42);
end;

function TosClientDataset.ReadNomeColuna43: string;
begin
  Result := ReadNomeColuna(43);
end;

function TosClientDataset.ReadNomeColuna44: string;
begin
  Result := ReadNomeColuna(44);
end;

function TosClientDataset.ReadNomeColuna45: string;
begin
  Result := ReadNomeColuna(45);
end;

function TosClientDataset.ReadNomeColuna46: string;
begin
  Result := ReadNomeColuna(46);
end;

function TosClientDataset.ReadNomeColuna47: string;
begin
  Result := ReadNomeColuna(47);
end;

function TosClientDataset.ReadNomeColuna48: string;
begin
  Result := ReadNomeColuna(48);
end;

function TosClientDataset.ReadNomeColuna49: string;
begin
  Result := ReadNomeColuna(49);
end;

function TosClientDataset.ReadNomeColuna5: string;
begin
  Result := ReadNomeColuna(5);
end;

function TosClientDataset.ReadNomeColuna50: string;
begin
  Result := ReadNomeColuna(50);
end;

function TosClientDataset.ReadNomeColuna6: string;
begin
  Result := ReadNomeColuna(6);
end;

function TosClientDataset.ReadNomeColuna7: string;
begin
  Result := ReadNomeColuna(7);
end;

function TosClientDataset.ReadNomeColuna8: string;
begin
  Result := ReadNomeColuna(8);
end;

function TosClientDataset.ReadNomeColuna9: string;
begin
  Result := ReadNomeColuna(9);
end;

procedure TosClientDataset.RefreshCalcFields;
begin
  GetCalcFields(ActiveBuffer);
end;

procedure TosClientDataset.RefreshParams;
var
  DataSet: TDataSet;
  i: integer;
  sFieldName: string;
begin
  DisableControls;
  try
    if FDataLink.DataSource <> nil then
    begin
      DataSet := FDataLink.DataSource.DataSet;
      if DataSet <> nil then
        if DataSet.Active and (DataSet.State <> dsSetKey) then
        begin
          Close;
          for i := 0 to Params.Count - 1 do
          begin
            sFieldName := Params[i].Name;
            sFieldName := Trim(StringReplace(sFieldName, '*', '', []));
            if not Dataset.FieldByName(sFieldName).IsNull then
              Params[i].Value := Dataset.FieldByName(sFieldName).Value;
          end;
          Open;
        end;
    end;
  finally
    EnableControls;
  end;
end;

procedure TosClientDataset.SetClosedLookup(const Value: boolean);
begin
  FClosedLookup := Value;
end;

procedure TosClientDataset.SetDataProvider(Value: TCustomProvider);
begin

  if Value <> FDataProvider then
  begin
    FDataProvider := Value;
    {Calling FreeNotification ensures that this component will receive an}
    {opRemove when Value is either removed from its owner or when it is destroyed.}
    if FDataProvider <> nil then
    begin
      FDataProvider.FreeNotification(Self);
      {Assign the provider from the host provider component to the ClientDataset (ourself)}
      InitAppServer;
    end
    else
      AppServer := nil;
  end;
end;

procedure TosClientDataset.SetMasterDataSource(const Value: TDataSource);
begin
  if IsLinkedTo(Value) then
    DatabaseError('Referência circular', Self);
  FDataLink.DataSource := Value;
end;

procedure TosClientDataset.DoBeforePost;
begin
  inherited;

end;

procedure TosClientDataset.Post;
begin
  try
    inherited;
  except
    On E: EDatabaseError do
    begin
      if Pos('must have', E.Message) <> 0 then
        raise Exception.Create('Obrigatório: ' + GetQuotedString(E.Message))
      else
        raise;
    end;
  end;

end;

function TosClientDataset.GetQuotedString(const PStr: string): string;
var
  i, iLen: integer;
  bCapture: boolean;
begin
  Result := '';
  bCapture := False;
  iLen := Length(PStr);
  for i:=1 to iLen do
    if bCapture then
      if PStr[i] <> '''' then
        Result := Result + PStr[i]
      else
        break
    else
      if PStr[i] = '''' then
        bCapture := True;
end;

procedure TosClientDataset.DoBeforeDelete;
begin
  inherited;
  if FDeleteDetails and not FClearing then
    ClearDetails(Self);

  if DataSetField <> nil then
    DataSetField.DataSet.Edit;
end;

procedure TosClientDataset.ClearDataSet(DataSet: TDataSet);
begin
  if DataSet is TosClientDataSet then
    TosClientDataSet(DataSet).FClearing := True;
  try
    DataSet.First;
    while not DataSet.Eof do
    begin
      ClearDetails(DataSet);
      DataSet.Delete;
    end;
  finally
    if DataSet is TosClientDataSet then
      TosClientDataSet(DataSet).FClearing := False;
  end;
end;

procedure TosClientDataset.ClearDetails(DataSet: TDataSet);
var
  i: integer;
begin
  for i := 0 to DataSet.FieldCount - 1 do
    if ftDataSet = DataSet.Fields[i].DataType then
      ClearDataSet(TDataSetField(DataSet.Fields[i]).NestedDataSet);
end;

{ TccClientDataLink }

procedure TccClientDataLink.ActiveChanged;
begin
  if FClientDataset.Active then FClientDataset.RefreshParams;
end;

procedure TccClientDataLink.CheckBrowseMode;
begin
  if FClientDataset.Active then FClientDataset.CheckBrowseMode;
end;

constructor TccClientDataLink.Create(AClientDataset: TosClientDataset);
begin
  inherited Create;
  FClientDataset := AClientDataset;
end;

function TccClientDataLink.GetDetailDataSet: TDataSet;
begin
  Result := FClientDataset;
end;

procedure TccClientDataLink.RecordChanged(Field: TField);
begin
  if (Field = nil) and FClientDataset.Active then FClientDataset.RefreshParams;
end;

{ TStringListExt }

constructor TStringListExt.Create;
begin
  inherited;
  FSeparator := '';
  FElementFormat := '';
end;

function TStringListExt.GetAsFmtText: string;
var
  i: integer;
  sSep: string;
begin
  Result := '';
  sSep := '';
  for i:=0 to Count - 1 do
  begin
    Result := Result + sSep + Format(FElementFormat, [Strings[i]]);
    sSep := FSeparator;
  end;
end;

procedure TStringListExt.PrepareForID;
begin
  FSeparator := ',';
  FElementFormat := '''%s''';
end;

procedure TStringListExt.SetElementFormat(const Value: string);
begin
  FElementFormat := Value;
end;

procedure TStringListExt.SetSeparator(const Value: string);
begin
  FSeparator := Value;
end;

end.


