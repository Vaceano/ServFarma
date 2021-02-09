unit DServicos;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADPadrao, Db, DBTables, DBClient, Grids;

type
  TPosicionaCamposFServicos = (
    pcFServicosNenhum,
    pcFServicosCODServico,
    pcFServicosDesServico,
    pcFServicosCODFarmaceutico,
    pcFServicosCODPaciente);

  TPosicionaCamposFServicosItem = (
    pcFServicosItemNenhum,
    pcFServicosItemCodMedicamento,
    pcFServicosItemVlrMedicamento);

  TServicoItem = class(TCollectionItem)
  private
    FIteMedicamento: Integer;
    FCodMedicamento: Integer;
    FDesMedicamento: String;
    FVlrMedicamento: Extended;
    FObsMedicamento: String;
    procedure SetIteMedicamento(const Value: Integer);
    procedure SetCodMedicamento(const Value: Integer);
    procedure SetDesMedicamento(const Value: String);
    procedure SetVlrMedicamento(const Value: Extended);
    procedure SetObsMedicamento(const Value: String);
    { private declarations }
  protected
    { protected declarations }
  public
    property IteMedicamento: Integer read FIteMedicamento write SetIteMedicamento;
    property CodMedicamento: Integer read FCodMedicamento write SetCodMedicamento;
    property DesMedicamento: String read FDesMedicamento write SetDesMedicamento;
    property VlrMedicamento: Extended read FVlrMedicamento write SetVlrMedicamento;
    property ObsMedicamento: String read FObsMedicamento write SetObsMedicamento;
    { public declarations }
  published
    { published declarations }
  end;

  TListaServicoItem = class(TCollection)
  private
    FStgServicoItem: TStringGrid;
    procedure SetStgServicoItem(const Value: TStringGrid);
    procedure AtualizaSequenciaIteMedicamento;
    { private declarations }
  protected
    { protected declarations }
  public
    procedure InicializaCabecalhoStg(vptStgServicoItem: TStringGrid);
    procedure RefreshStgServicoItem;
    property StgServicoItem: TStringGrid read FStgServicoItem write SetStgServicoItem;
    procedure Delete(Index: Integer); 
    { public declarations }
  published
    { published declarations }
  end;

  TDmServicos = class(TADmPadrao)
    QryCadastroCODSERVICO: TIntegerField;
    QryCadastroDESSERVICO: TStringField;
    QryCadastroDATSERVICO: TDateTimeField;
    QryCadastroCODFARMACEUTICO: TIntegerField;
    QryCadastroCODPACIENTE: TIntegerField;
    QryCadastroNUMPRESSAO1: TIntegerField;
    QryCadastroNUMPRESSAO2: TIntegerField;
    QryCadastroNUMGLICEMIA: TIntegerField;
    QryCadastroVLRTOTAL: TFloatField;
    QryCadastroNOMFARMACEUTICO: TStringField;
    QryCadastroNOMPACIENTE: TStringField;
    QryCadastroNUMTEMPERATURA: TFloatField;
    QryCadastroTIPATENCAODOMICILIAR: TStringField;
    QryCadastroOBSSERVICO: TStringField;
    procedure QryCadastroBeforePost(DataSet: TDataSet);
    procedure QryCadastroAfterPost(DataSet: TDataSet);
    procedure QryCadastroCalcFields(DataSet: TDataSet);
    procedure QryCadastroNewRecord(DataSet: TDataSet);
    procedure DmPadraoDestroy(Sender: TObject);
    procedure QryCadastroAfterScroll(DataSet: TDataSet);
    procedure QryCadastroBeforeCancel(DataSet: TDataSet);
    procedure QryCadastroBeforeDelete(DataSet: TDataSet);
  private
    FPosicionaCamposFServicos: TPosicionaCamposFServicos;
    FListaServicoItem: TListaServicoItem;
    FPosicionaCamposFServicosItem: TPosicionaCamposFServicosItem;
    function GetListaServicoItem: TListaServicoItem;
    procedure ValidaCampos(DataSet: TDataSet);
    procedure SetPosicionaCamposFServicos(
      const Value: TPosicionaCamposFServicos);
    procedure SetPosicionaCamposFServicosItem(
      const Value: TPosicionaCamposFServicosItem);
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure GravaTodasTabelas;
    property PosicionaCamposFServicos: TPosicionaCamposFServicos
      read FPosicionaCamposFServicos write SetPosicionaCamposFServicos;
    property PosicionaCamposFServicosItem: TPosicionaCamposFServicosItem
      read FPosicionaCamposFServicosItem write SetPosicionaCamposFServicosItem;
    procedure PopulaCodFarmaceutico(vpsCod: String);
    procedure PopulaCodPaciente(vpsCod: String);
    procedure EditServico;
    function Pesquisa(vpsChaveDeBusca: String;
      vptBtnCadastro: TObject = nil): String;
    property ListaServicoItem: TListaServicoItem read GetListaServicoItem;
    procedure ListaServicoItemFree;
    procedure AtualizaValorTotal;
    function ValidaCamposServicoItem(
      vpsConteudo: String;
      vptPosicionaCamposFServicosItem: TPosicionaCamposFServicosItem): String;
    procedure AlteraServicoItem(
      vpiIteServico: Integer;
      vpsCodMedicamento,
      vpsDesMedicamento,
      vpsVlrMedicamento,
      vpsObsMedicamento: String);
    procedure AdicionaServicoItem(
      vpsCodMedicamento,
      vpsDesMedicamento,
      vpsVlrMedicamento,
      vpsObsMedicamento: String;
      vptStgServicoItem: TStringGrid);
    procedure PopulaCampos(
      vpiItemIndex: Integer;
      var vpsCodMedicamento: String;
      var vpsDesMedicamento: String;
      var vpsVlrMedicamento: String;
      var vpsObsMedicamento: String);
    procedure GravaListaServicoItem;
    procedure PopulaListaServicoItem;
    procedure DeletaListaServicoItem;
    { Public declarations }
  end;

var
  DmServicos: TDmServicos;

implementation

uses
  UFerramentas, UFerramentasB, DConexao, SPesquisa, DGeral;

{$R *.DFM}

constructor TDmServicos.Create(AOwner: TComponent);
begin
  NomeEntidade := 'Serviço';
  NomeCampoChave := 'CodServico';
  inherited Create(AOwner);
end;

procedure TDmServicos.DmPadraoDestroy(Sender: TObject);
begin
  inherited;
  ListaServicoItemFree;
end;

procedure TDmServicos.ListaServicoItemFree;
//var
//  vli1: Integer;
begin
  if Assigned(FListaServicoItem) then
  begin
    //for vli1 := 0 to FListaServicoItem.Count -1 do
    //  FListaServicoItem.Items[vli1].Free;
    FListaServicoItem.Free;
    FListaServicoItem := nil;
  end
end;

function TDmServicos.GetListaServicoItem: TListaServicoItem;
begin
  if not Assigned(FListaServicoItem) then
    FListaServicoItem := TListaServicoItem.Create(TServicoItem);
  Result := FListaServicoItem;
end;

procedure TDmServicos.QryCadastroBeforePost(DataSet: TDataSet);
begin
  inherited;
  ValidaCampos(DataSet);
end;

procedure TDmServicos.ValidaCampos(DataSet: TDataSet);
begin
  PosicionaCamposFServicos := pcFServicosNenhum;
  if (DataSet.State in [dsEdit]) then
  begin
    if DataSet.FieldByName('CodServico').AsString = '' then
    begin
      PosicionaCamposFServicos := pcFServicosCodServico;
      raise Exception.Create('O código do Serviço é obrigatório! ');
    end;
  end;

  if DataSet.FieldByName('DesServico').AsString = '' then
  begin
    PosicionaCamposFServicos := pcFServicosDesServico;
    raise Exception.Create('O Descrição do Serviço é obrigatório! ');
  end;

  if DataSet.FieldByName('CodFarmaceutico').AsString = '' then
  begin
    PosicionaCamposFServicos := pcFServicosCodFarmaceutico;
    raise Exception.Create('O código do farmaceutico é obrigatório! ');
  end;

  if DataSet.FieldByName('CodPaciente').AsString = '' then
  begin
    PosicionaCamposFServicos := pcFServicosCodPaciente;
    raise Exception.Create('O código do paciente é obrigatório! ');
  end;

end;

procedure TDmServicos.GravaTodasTabelas;
begin
  if (QryCadastro.State in [dsEdit, dsInsert]) then
    QryCadastro.Post;
  Atualizar;
end;

procedure TDmServicos.SetPosicionaCamposFServicos(
  const Value: TPosicionaCamposFServicos);
begin
  FPosicionaCamposFServicos := Value;
end;

procedure TDmServicos.QryCadastroAfterPost(DataSet: TDataSet);
begin
  try
    BeginTransaction;
    inherited;
    GravaListaServicoItem;
    CommitTransaction;
  except
    RollbackTransaction;
    raise;
  end;
  QryCadastro.Last;
end;

procedure TDmServicos.EditServico;
begin
  if not (QryCadastro.State in [dsEdit, dsInsert]) then
    QryCadastro.Edit;
end;

procedure TDmServicos.PopulaCodFarmaceutico(vpsCod: String);
var
  vltQry: TQuery;
begin
  if vpsCod = QryCadastroCODFARMACEUTICO.AsString then
    Exit;

  if vpsCod = '' then
  begin
    EditServico;
    QryCadastroCODFARMACEUTICO.Clear;
    Exit;
  end;

  vltQry := TQuery.Create(nil);
  try
    try
      vltQry.Close;
      vltQry.Databasename := DmConexao.DbsConexao.DatabaseName;
      vltQry.Sql.Text :=
        'SELECT * '+#13+
        'FROM Farmaceutico '+#13+
        'WHERE CODFarmaceutico = :CODFarmaceutico '+#13;
      vltQry.ParamByName('CODFarmaceutico').AsString := vpsCod;
      vltQry.Open;
      if vltQry.IsEmpty then
        raise Exception.Create(
          'Farmaceutico [' + vpsCod + '] inexistente! ');

      EditServico;
      QryCadastroCODFarmaceutico.AsString :=
        vltQry.FieldByName('CODFarmaceutico').AsString;
    except
      on E: Exception do
        raise Exception.Create(
          'Erro na pesquisa! ' + #13 + #13 +
          '[' + E.Message + ']!');
    end;
  finally
    if Assigned(vltQry) then
      vltQry.Free;
  end;
end;

procedure TDmServicos.PopulaCodPaciente(vpsCod: String);
var
  vltQry: TQuery;
begin
  if vpsCod = QryCadastroCODPaciente.AsString then
    Exit;

  if vpsCod = '' then
  begin
    EditServico;
    QryCadastroCODPaciente.Clear;
    Exit;
  end;

  vltQry := TQuery.Create(nil);
  try
    try
      vltQry.Close;
      vltQry.Databasename := DmConexao.DbsConexao.DatabaseName;
      vltQry.Sql.Text :=
        'SELECT * '+#13+
        'FROM Paciente '+#13+
        'WHERE CODPaciente = :CODPaciente '+#13;
      vltQry.ParamByName('CODPaciente').AsString := vpsCod;
      vltQry.Open;
      if vltQry.IsEmpty then
        raise Exception.Create(
          'Paciente [' + vpsCod + '] inexistente! ');

      EditServico;
      QryCadastroCODPaciente.AsString :=
        vltQry.FieldByName('CODPaciente').AsString;
    except
      on E: Exception do
        raise Exception.Create(
          'Erro na pesquisa! ' + #13 + #13 +
          '[' + E.Message + ']!');
    end;
  finally
    if Assigned(vltQry) then
      vltQry.Free;
  end;
end;

procedure TDmServicos.QryCadastroCalcFields(DataSet: TDataSet);
var
  vltQry: TQuery;
begin
  inherited;
  vltQry := TQuery.Create(nil);
  try
    try
      vltQry.Close;
      vltQry.Databasename := DmConexao.DbsConexao.DatabaseName;
      vltQry.Sql.Text :=
        'SELECT * '+#13+
        'FROM Farmaceutico '+#13+
        'WHERE CODFarmaceutico = ' + IntToStr(QryCadastroCODFarmaceutico.AsInteger) + ' '+#13;
      vltQry.Open;
      QryCadastroNOMFARMACEUTICO.AsString := '';
      if not vltQry.IsEmpty then
        QryCadastroNOMFARMACEUTICO.AsString := vltQry.FieldByName('NOMFARMACEUTICO').AsString;
    except
      on E: Exception do
        raise Exception.Create(
          'Erro ao localizar registros no CalcFields! ' + #13 + #13 +
          '[' + vltQry.Sql.Text + '] ' + #13 + #13 +
          '[' + E.Message + ']!');
    end;

    try
      vltQry.Close;
      vltQry.Databasename := DmConexao.DbsConexao.DatabaseName;
      vltQry.Sql.Text :=
        'SELECT * '+#13+
        'FROM Paciente '+#13+
        'WHERE CODPaciente = ' + IntToStr(QryCadastroCODPACIENTE.AsInteger) + ' '+#13;
      vltQry.Open;
      QryCadastroNOMPACIENTE.AsString := '';
      if not vltQry.IsEmpty then
        QryCadastroNOMPACIENTE.AsString := vltQry.FieldByName('NOMPACIENTE').AsString;
    except
      on E: Exception do
        raise Exception.Create(
          'Erro ao localizar registros no CalcFields! ' + #13 + #13 +
          '[' + vltQry.Sql.Text + '] ' + #13 + #13 +
          '[' + E.Message + ']!');
    end;
  finally
    if Assigned(vltQry) then
      vltQry.Free;
  end;
end;

procedure TDmServicos.QryCadastroNewRecord(DataSet: TDataSet);
begin
  inherited;
  QryCadastroDESSERVICO.AsString := 'Consulta ' + DateTimeToStr(DataHoraAtual);
  QryCadastroTIPATENCAODOMICILIAR.AsString := 'N';
  QryCadastroDATSERVICO.Value := DataHoraAtual;
end;

function TDmServicos.Pesquisa(vpsChaveDeBusca: String; vptBtnCadastro: TObject = nil): String;
begin
  try
    Result :=
      FNCPesquisa(
        vptBtnCadastro,
        'Cadastro dos serviços',
        vpsChaveDeBusca,
        'CODServico AS Codigo',
        DmConexao.DbsConexao.DatabaseName,
        'Servico, Paciente ',
        'Servico.CODServico AS Codigo',
        'Servico.DesServico AS Nome',
        'Servico.DatServico as Data',
        'paciente.nompaciente as Paciente',
        'Servico.VlrTotal as Total',
        'Servico.codpaciente = paciente.codpaciente');
  except
    on E: Exception do
      raise Exception.Create(
        'Erro na pesquisa! ' + #13 + #13 +
        '[' + E.Message + ']!');
  end;
end;

procedure TDmServicos.AlteraServicoItem(
  vpiIteServico: Integer;
  vpsCodMedicamento,
  vpsDesMedicamento,
  vpsVlrMedicamento,
  vpsObsMedicamento: String);
var
  vli1: Integer;
begin
  for vli1 := 0 to ListaServicoItem.Count -1 do
  begin
    if TServicoItem(ListaServicoItem.Items[vli1]).IteMedicamento = vpiIteServico then
    begin
      TServicoItem(ListaServicoItem.Items[vli1]).CodMedicamento :=
        StrToInt(ValidaCamposServicoItem(vpsCodMedicamento, pcFServicosItemCodMedicamento));
      TServicoItem(ListaServicoItem.Items[vli1]).DesMedicamento := vpsDesMedicamento;
      TServicoItem(ListaServicoItem.Items[vli1]).VlrMedicamento :=
        StrToFloat(ValidaCamposServicoItem(vpsVlrMedicamento, pcFServicosItemVlrMedicamento));
      TServicoItem(ListaServicoItem.Items[vli1]).ObsMedicamento := vpsObsMedicamento;
      Break;
    end;
  end;
  ListaServicoItem.RefreshStgServicoItem;
  AtualizaValorTotal;
end;

procedure TDmServicos.AtualizaValorTotal;
var
  vli1: Integer;
  vleValorTotal: Extended;
begin
  if not (QryCadastro.State in [dsEdit, dsInsert]) then
    Exit;
  vleValorTotal := 0.0;
  for vli1 := 0 to ListaServicoItem.Count -1 do
    vleValorTotal := vleValorTotal + TServicoItem(ListaServicoItem.Items[vli1]).VlrMedicamento;
  QryCadastroVLRTOTAL.Value := vleValorTotal;
end;

function TDmServicos.ValidaCamposServicoItem(
  vpsConteudo: String;
  vptPosicionaCamposFServicosItem: TPosicionaCamposFServicosItem): String;
begin
  case vptPosicionaCamposFServicosItem of
    pcFServicosItemCodMedicamento:
    begin
      try
        Result := TDmGeral(DmlG).DmlMedicamentos.ValidaExisteRegistro(vpsConteudo);
      except
        on E: Exception do
        begin
          PosicionaCamposFServicosItem := vptPosicionaCamposFServicosItem;
          raise Exception.Create(E.Message);
        end;
      end;
    end;
    pcFServicosItemVlrMedicamento:
    begin
      Result := vpsConteudo;
      Result := DeletaCharAlfanumerico(Result, ',');
      if not ContemNumeros(Result) then
        Result := '0.00';
    end
  else
    Result := vpsConteudo;
  end;
end;

procedure TDmServicos.AdicionaServicoItem(
  vpsCodMedicamento,
  vpsDesMedicamento,
  vpsVlrMedicamento,
  vpsObsMedicamento: String;
  vptStgServicoItem: TStringGrid);
var
  vltServicoItem: TServicoItem;
begin
  vltServicoItem := TServicoItem.Create(ListaServicoItem);
  vltServicoItem.CodMedicamento := StrToInt(ValidaCamposServicoItem(vpsCodMedicamento, pcFServicosItemCodMedicamento));
  vltServicoItem.DesMedicamento := TDmGeral(DmlG).DmlMedicamentos.QryCadastroDESMEDICAMENTO.AsString;
  vltServicoItem.VlrMedicamento := StrToFloat(ValidaCamposServicoItem(vpsVlrMedicamento, pcFServicosItemVlrMedicamento));
  vltServicoItem.ObsMedicamento := vpsObsMedicamento;

  ListaServicoItem.AtualizaSequenciaIteMedicamento;

  ListaServicoItem.StgServicoItem := vptStgServicoItem;
  ListaServicoItem.RefreshStgServicoItem;
  AtualizaValorTotal;
end;

procedure TDmServicos.PopulaCampos(
  vpiItemIndex: Integer;
  var vpsCodMedicamento: String;
  var vpsDesMedicamento: String;
  var vpsVlrMedicamento: String;
  var vpsObsMedicamento: String);
begin
  if (vpiItemIndex < 0)
  or (ListaServicoItem.Count = 0) then
    Exit;
  vpsCodMedicamento := IntToStr(TServicoItem(ListaServicoItem.Items[vpiItemIndex]).CodMedicamento);
  vpsDesMedicamento := TServicoItem(ListaServicoItem.Items[vpiItemIndex]).DesMedicamento;
  vpsVlrMedicamento := FormatFloat('#,##0.00', TServicoItem(ListaServicoItem.Items[vpiItemIndex]).VlrMedicamento);
  vpsObsMedicamento := TServicoItem(ListaServicoItem.Items[vpiItemIndex]).ObsMedicamento;
end;

{ TServicoItem }

procedure TServicoItem.SetCodMedicamento(const Value: Integer);
begin
  FCodMedicamento := Value;
end;

procedure TServicoItem.SetVlrMedicamento(const Value: Extended);
begin
  FVlrMedicamento := Value;
end;

procedure TServicoItem.SetObsMedicamento(const Value: String);
begin
  FObsMedicamento := Value;
end;

procedure TServicoItem.SetDesMedicamento(const Value: String);
begin
  FDesMedicamento := Value;
end;

procedure TServicoItem.SetIteMedicamento(const Value: Integer);
begin
  FIteMedicamento := Value;
end;

{ TListaServicoItem }

procedure TListaServicoItem.RefreshStgServicoItem;
var
  vli1: Integer;
  vliQtdCol: Integer;

  function QtdCol(vpbSomaCol: Boolean = True): Integer;
  begin
    if vpbSomaCol then
      vliQtdCol := vliQtdCol + 1;
    Result := vliQtdCol;
  end;

begin
  if StgServicoItem = nil then
    Exit;

  InicializaCabecalhoStg(StgServicoItem);
  if Self.Count = 0 then
    Exit;

  StgServicoItem.RowCount := Self.Count + 1;
  for vli1 := 0 to Self.Count -1 do
  begin
    vliQtdCol := 0;
    StgServicoItem.Cells[QtdCol, vli1+1] := IntToStr(TServicoItem(Self.Items[vli1]).IteMedicamento);
    StgServicoItem.Cells[QtdCol, vli1+1] := IntToStr(TServicoItem(Self.Items[vli1]).CodMedicamento);
    StgServicoItem.Cells[QtdCol, vli1+1] := TServicoItem(Self.Items[vli1]).DesMedicamento;
    StgServicoItem.Cells[QtdCol, vli1+1] := FormatFloat('#,##0.00', TServicoItem(Self.Items[vli1]).VlrMedicamento);
    StgServicoItem.Cells[QtdCol, vli1+1] := TServicoItem(Self.Items[vli1]).ObsMedicamento;
  end;
  StgServicoItem.ColCount := QtdCol;
end;

procedure TListaServicoItem.InicializaCabecalhoStg(vptStgServicoItem: TStringGrid);
var
  vliQtdCol: Integer;

  function QtdCol(vpbSomaCol: Boolean = True): Integer;
  begin
    if vpbSomaCol then
      vliQtdCol := vliQtdCol + 1;
    Result := vliQtdCol;
  end;

begin
  if vptStgServicoItem = nil then
    Exit;
    
  StgServicoItem := vptStgServicoItem;
  vliQtdCol := 0;
  StgServicoItem.ColWidths[QtdCol(False)] := 10;

  StgServicoItem.Cells[QtdCol, 0] := 'Item';
  StgServicoItem.Cells[QtdCol(false), 1] := '';
  StgServicoItem.ColWidths[QtdCol(False)] := 30;

  StgServicoItem.Cells[QtdCol, 0] := 'Código';
  StgServicoItem.Cells[QtdCol(false), 1] := '';
  StgServicoItem.ColWidths[QtdCol(False)] := 40;

  StgServicoItem.Cells[QtdCol, 0] := 'Descrição';
  StgServicoItem.Cells[QtdCol(false), 1] := '';
  StgServicoItem.ColWidths[QtdCol(False)] := 150;

  StgServicoItem.Cells[QtdCol, 0] := 'Valor';
  StgServicoItem.Cells[QtdCol(false), 1] := '';
  StgServicoItem.ColWidths[QtdCol(False)] := 70;

  StgServicoItem.Cells[QtdCol, 0] := 'Observação';
  StgServicoItem.Cells[QtdCol(false), 1] := '';
  StgServicoItem.ColWidths[QtdCol(False)] := 210;

  StgServicoItem.ColCount := QtdCol;
  StgServicoItem.RowCount := 2;
end;

procedure TListaServicoItem.SetStgServicoItem(const Value: TStringGrid);
begin
  FStgServicoItem := Value;
end;

procedure TListaServicoItem.Delete(Index: Integer);
begin
  if Self.Count = 0 then
    Exit;
  inherited;
  AtualizaSequenciaIteMedicamento;
  RefreshStgServicoItem;
end;

procedure TListaServicoItem.AtualizaSequenciaIteMedicamento;
var
  vli1: Integer;
begin
  for vli1 := 0 to Self.Count -1 do
    TServicoItem(Self.Items[vli1]).IteMedicamento := vli1 + 1;
end;

procedure TDmServicos.GravaListaServicoItem;

//------------------------------------------------------------------------------
  procedure _SalvaListaServicoItem;
  var
    vli1: Integer;
    vltQry: TQuery;
    vliCodServico: Integer;
  begin
    if QryCadastroCODSERVICO.AsInteger = 0 then
      vliCodServico := UltimoGeneratorCriado('Servico')
    else
      vliCodServico := QryCadastroCODSERVICO.AsInteger;
    vltQry := TQuery.Create(nil);
    try
      for vli1 := 0 to ListaServicoItem.Count -1 do
      begin
        try
          vltQry.Close;
          vltQry.Databasename := DmConexao.DbsConexao.DatabaseName;
          vltQry.Sql.Text :=
            'INSERT INTO SERVICOITEM '+#13+
            '( CODSERVICO, '+#13+
            '  ITESERVICO, '+#13+
            '  CODMEDICAMENTO, '+#13+
            '  VLRMEDICAMENTO, '+#13+
            '  OBSMEDICAMENTO) '+#13+
            'VALUES '+#13+
            '( ' + IntToStr(vliCodServico) + ', '+#13+
            '  ' + IntToStr(TServicoItem(ListaServicoItem.Items[vli1]).IteMedicamento) + ', '+#13+
            '  ' + IntToStr(TServicoItem(ListaServicoItem.Items[vli1]).CodMedicamento) + ', '+#13+
            '  :VLRMEDICAMENTO, '+#13+
            '  ''' + TServicoItem(ListaServicoItem.Items[vli1]).ObsMedicamento + ''') '+#13;
          vltQry.ParamByName('VLRMEDICAMENTO').AsFloat := TServicoItem(ListaServicoItem.Items[vli1]).VlrMedicamento;
          vltQry.ExecSql;
        except
          on E: Exception do
            raise Exception.Create(
              'Erro ao salvar os itens do serviço! ' + #13 + #13 +
              '[' + vltQry.Sql.Text + ']!' + #13 + #13 +
              '[' + E.Message + ']!');
        end;
      end;
    finally
      if Assigned(vltQry) then
        vltQry.Free;
    end;
  end;

//------------------------------------------------------------------------------
//procedure TDmServicos.GravaListaServicoItem
//------------------------------------------------------------------------------
begin
  if QryCadastroCODSERVICO.AsInteger <> 0 then
    DeletaListaServicoItem;
  if ListaServicoItem.Count > 0 then
    _SalvaListaServicoItem;
end;

procedure TDmServicos.QryCadastroAfterScroll(DataSet: TDataSet);
begin
  inherited;
  PopulaListaServicoItem;
end;

procedure TDmServicos.PopulaListaServicoItem;
var
  vltQry: TQuery;
begin
  ListaServicoItem.Clear;
  ListaServicoItem.InicializaCabecalhoStg(ListaServicoItem.StgServicoItem);
  if QryCadastroCODSERVICO.AsInteger = 0 then
    Exit;
     
  vltQry := TQuery.Create(nil);
  try
    try
      vltQry.Close;
      vltQry.Databasename := DmConexao.DbsConexao.DatabaseName;
      vltQry.Sql.Text :=
        'SELECT '+#13+
        '  SERVICOITEM.CodMedicamento, '+#13+
        '  MEDICAMENTO.DesMedicamento, '+#13+
        '  SERVICOITEM.VlrMedicamento, '+#13+
        '  SERVICOITEM.ObsMedicamento '+#13+
        'FROM SERVICOITEM '+#13+
        'JOIN MEDICAMENTO '+#13+
        '   ON MEDICAMENTO.CODMEDICAMENTO = SERVICOITEM.CODMEDICAMENTO '+#13+
        'WHERE CODSERVICO = ' + QryCadastroCODSERVICO.AsString + ' '+#13+
        'ORDER BY CODSERVICO, ITESERVICO '+#13;
      vltQry.Open;
    except
      on E: Exception do
        raise Exception.Create(
          'Erro ao selecionar os itens do serviço! ' + #13 + #13 +
          '[' + vltQry.Sql.Text + ']!' + #13 + #13 +
          '[' + E.Message + ']!');
    end;
    if not vltQry.IsEmpty then
    begin
      vltQry.First;
      while not vltQry.Eof do
      begin
        AdicionaServicoItem(
          vltQry.FieldByName('CodMedicamento').AsString,
          vltQry.FieldByName('DesMedicamento').AsString,
          FormatFloat('#,##0.00', vltQry.FieldByName('VlrMedicamento').AsFloat),
          vltQry.FieldByName('ObsMedicamento').AsString,
          ListaServicoItem.StgServicoItem);
        vltQry.Next;
      end;
    end;
  finally
    if Assigned(vltQry) then
      vltQry.Free;
  end;
end;

procedure TDmServicos.QryCadastroBeforeCancel(DataSet: TDataSet);
begin
  inherited;
  PopulaListaServicoItem;
end;

procedure TDmServicos.DeletaListaServicoItem;
var
  vltQry: TQuery;
begin
  vltQry := TQuery.Create(nil);
  try
    try
      vltQry.Close;
      vltQry.Databasename := DmConexao.DbsConexao.DatabaseName;
      vltQry.Sql.Text :=
        'DELETE FROM SERVICOITEM '+#13+
        'WHERE CODSERVICO = ' + QryCadastroCODSERVICO.AsString + ' '+#13;
      vltQry.ExecSql;
    except
      on E: Exception do
        raise Exception.Create(
          'Erro ao excluir os itens do serviço! ' + #13 + #13 +
          '[' + vltQry.Sql.Text + ']!' + #13 + #13 +
          '[' + E.Message + ']!');
    end;
  finally
    if Assigned(vltQry) then
      vltQry.Free;
  end;
end;

procedure TDmServicos.QryCadastroBeforeDelete(DataSet: TDataSet);
begin
  inherited;
  DeletaListaServicoItem;
end;

procedure TDmServicos.SetPosicionaCamposFServicosItem(
  const Value: TPosicionaCamposFServicosItem);
begin
  FPosicionaCamposFServicosItem := Value;
end;

end.

