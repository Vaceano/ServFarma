unit FServicos;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AFPadraoCadastro, StdCtrls, Buttons, DBCtrls, ExtCtrls, ComCtrls, Mask, Db,
  DBTables, ExtDlgs, Grids, DBGrids;

type
  TFrmServicos = class(TAFrmPadraoCadastro)
    GbxOBSSERVICO: TGroupBox;
    MemOBSSERVICO: TDBMemo;
    PnlCabecaho: TPanel;
    PnlServicoItens: TPanel;
    LblEdtCODSERVICO: TLabel;
    LblEdtDESSERVICO: TLabel;
    EdtCODSERVICO: TDBEdit;
    EdtDESSERVICO: TDBEdit;
    GbxFarmaceutico: TGroupBox;
    LblEdtCODFARMACEUTICO: TLabel;
    LblEdtNOMFARMACEUTICO: TLabel;
    EdtNOMFARMACEUTICO: TDBEdit;
    EdtCODFARMACEUTICO: TDBEdit;
    BtnCODFARMACEUTICO: TBitBtn;
    GbxPaciente: TGroupBox;
    LblCODPACIENTE: TLabel;
    EdtNOMPACIENTE: TDBEdit;
    EdtCODPACIENTE: TDBEdit;
    BtnCODPACIENTE: TBitBtn;
    LblDATSERVICO: TLabel;
    LblEdtVLRTOTAL: TLabel;
    EdtDATSERVICO: TDBEdit;
    EdtVLRTOTAL: TDBEdit;
    LblNUMPRESSAO: TLabel;
    EdtNUMPRESSAO1: TDBEdit;
    LblNUMPRESSAO2: TLabel;
    EdtNUMPRESSAO2: TDBEdit;
    LblNUMTEMPERATURA: TLabel;
    EdtNUMTEMPERATURA: TDBEdit;
    LblEdtNUMGLICEMIA: TLabel;
    EdtNUMGLICEMIA: TDBEdit;
    CkbTIPATENCAODOMICILIAR: TDBCheckBox;
    BtnEdtDATSERVICO: TBitBtn;
    LblNOMPACIENTE: TLabel;
    GbxMedicamentos: TGroupBox;
    LblEdtCodMedicamento: TLabel;
    LblEdtDesMedicamento: TLabel;
    LblEdtVlrMedicamento: TLabel;
    EdtCodMedicamento: TEdit;
    EdtDesMedicamento: TEdit;
    BtnCodMedicamento: TBitBtn;
    GbxObsServicoItem: TGroupBox;
    MemObsMedicamento: TMemo;
    BtnAdicionaServicoItem: TBitBtn;
    BtnRemoveMedicamento: TBitBtn;
    EdtVlrMedicamento: TEdit;
    PnlGridMedicamentos: TPanel;
    StgServicoItem: TStringGrid;
    LblIteServico_EmAlteracao: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnPesquisarClick(Sender: TObject);
    procedure DbnCadastroBeforeAction(Sender: TObject;
      Button: TNavigateBtn);
    procedure BtnCODFARMACEUTICOClick(Sender: TObject);
    procedure BtnCODPACIENTEClick(Sender: TObject);
    procedure BtnEdtDATSERVICOClick(Sender: TObject);
    procedure BtnCodMedicamentoClick(Sender: TObject);
    procedure BtnAdicionaServicoItemClick(Sender: TObject);
    procedure BtnRemoveMedicamentoClick(Sender: TObject);
    procedure EdtVlrMedicamentoExit(Sender: TObject);
    procedure StgServicoItemDblClick(Sender: TObject);
    procedure EdtCodMedicamentoExit(Sender: TObject);
    procedure EdtCODFARMACEUTICOExit(Sender: TObject);
    procedure EdtCODPACIENTEExit(Sender: TObject);
  private
    procedure LimpaCamposServicoItem;
    { Private declarations }
  public
    procedure GravaTodasTabelas; override;
    { Public declarations }
  end;

var
  FrmServicos: TFrmServicos;

implementation

uses
  DConexao, DServicos, SPesquisa, UFerramentas, UFerramentasB, SDataOpcao,
  SException, FMenu, DGeral;

{$R *.DFM}

procedure TFrmServicos.FormCreate(Sender: TObject);
begin
  inherited;
  DbnCadastro.DataSource := DmlG.DmlServicos.DtsQryCadastro;
  SetaDataSource(DmlG.DmlServicos.DtsQryCadastro, Self);
  DmlG.DmlServicos.ListaServicoItem.InicializaCabecalhoStg(StgServicoItem);
  DmlG.DmlServicos.QryCadastro.Last;
end;

procedure TFrmServicos.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
  FrmServicos := nil;
end;

procedure TFrmServicos.BtnPesquisarClick(Sender: TObject);
var
  vlsResultConteudoInicialChave: String;
  vlsChaveDeBusca: String;
begin
  inherited;
  vlsChaveDeBusca := 'Servico.CODServico AS Codigo';
  if Sender = LblEdtDesServico then
    vlsChaveDeBusca := 'Servico.DesServico AS Descricao';
  if Sender = LblNOMPACIENTE then
    vlsChaveDeBusca := 'Paciente.NomPaciente AS Paciente';
  vlsResultConteudoInicialChave :=
    DmlG.DmlServicos.Pesquisa(vlsChaveDeBusca);
  if (vlsResultConteudoInicialChave > '0') then
    DmlG.DmlServicos.QryCadastro.Locate(
      'CODServico', vlsResultConteudoInicialChave, [loCaseInsensitive]);
end;

procedure TFrmServicos.GravaTodasTabelas;
begin
  inherited;
  try
    DmlG.DmlServicos.GravaTodasTabelas;
  except
    on E: Exception do
    begin
      Self.WindowState := wsNormal;
      case DmlG.DmlServicos.PosicionaCamposFServicos of
        pcFServicosCODServico:
        begin
          if EdtCodServico.CanFocus then
            EdtCodServico.SetFocus;
        end;
        pcFServicosDesServico:
        begin
          if EdtDesServico.CanFocus then
            EdtDesServico.SetFocus;
        end;
        pcFServicosCODFarmaceutico:
        begin
          if EdtCODFARMACEUTICO.CanFocus then
            EdtCODFARMACEUTICO.SetFocus;
        end;
        pcFServicosCODPaciente:
        begin
          if EdtCODPACIENTE.CanFocus then
            EdtCODPACIENTE.SetFocus;
        end;
      end;
      raise Exception.Create(E.Message)
    end;
  end;
end;

procedure TFrmServicos.DbnCadastroBeforeAction(Sender: TObject;
  Button: TNavigateBtn);
begin
  inherited;
  case Button of
    nbInsert:
    begin
      if EdtDesServico.CanFocus then
        EdtDesServico.SetFocus;
    end;
    nbPost:
    begin
      try
        GravaTodasTabelas;
        if not (DmlG.DmlServicos.QryCadastro.State in [dsEdit, dsInsert]) then
          DmlG.DmlServicos.QryCadastro.Edit;
      except
        on E: Exception do
          raise Exception.Create(E.Message);
      end;
    end;
  end;
end;

procedure TFrmServicos.BtnCODFARMACEUTICOClick(Sender: TObject);
var
  vlsResultConteudoInicialChave: String;
  vlsChaveDeBusca: String;
begin
  inherited;
  vlsChaveDeBusca := 'NomFarmaceutico AS Nome';
  vlsResultConteudoInicialChave :=
    DmlG.DmlFarmaceuticos.Pesquisa(vlsChaveDeBusca, FrmMenu.BtnFarmaceuticos);
  if (vlsResultConteudoInicialChave > '0') then
    DmlG.DmlServicos.PopulaCodFarmaceutico(vlsResultConteudoInicialChave);
end;

procedure TFrmServicos.BtnCODPACIENTEClick(Sender: TObject);
var
  vlsResultConteudoInicialChave: String;
  vlsChaveDeBusca: String;
begin
  inherited;
  vlsChaveDeBusca := 'NomPaciente AS Nome';
  vlsResultConteudoInicialChave :=
    DmlG.DmlPacientes.Pesquisa(vlsChaveDeBusca, FrmMenu.BtnPacientes);
  if (vlsResultConteudoInicialChave > '0') then
    DmlG.DmlServicos.PopulaCodPaciente(vlsResultConteudoInicialChave);
end;

procedure TFrmServicos.BtnEdtDATSERVICOClick(Sender: TObject);
begin
  inherited;
  DmlG.DmlServicos.EditServico;
  EdtDATSERVICO.Text := FNCDataOpcao(EdtDATSERVICO.Text);
end;

procedure TFrmServicos.BtnCodMedicamentoClick(Sender: TObject);
var
  vlsResultConteudoInicialChave: String;
  vlsChaveDeBusca: String;
begin
  inherited;
  vlsChaveDeBusca := 'DesMedicamento AS Descricao';
  vlsResultConteudoInicialChave :=
    DmlG.DmlMedicamentos.Pesquisa(vlsChaveDeBusca, FrmMenu.BtnMedicamentos);
  if (vlsResultConteudoInicialChave > '0') then
  begin
    DmlG.DmlMedicamentos.QryCadastro.Close;
    DmlG.DmlMedicamentos.QryCadastro.Open;
    DmlG.DmlMedicamentos.QryCadastro.Locate(
      'CODMedicamento', vlsResultConteudoInicialChave, [loCaseInsensitive]);
    EdtCodMedicamento.Text := DmlG.DmlMedicamentos.QryCadastroCODMEDICAMENTO.AsString;
    EdtDesMedicamento.Text := DmlG.DmlMedicamentos.QryCadastroDESMEDICAMENTO.AsString;
    EdtVlrMedicamento.Text := DmlG.DmlMedicamentos.QryCadastroVLRMEDICAMENTO.AsString;
  end;
end;

procedure TFrmServicos.BtnAdicionaServicoItemClick(Sender: TObject);
begin
  inherited;
  EdtVlrMedicamentoExit(nil);
  if not (DmlG.DmlServicos.QryCadastro.State in [dsEdit, dsInsert]) then
    DmlG.DmlServicos.QryCadastro.Edit;
  try
    if LblIteServico_EmAlteracao.Tag = 0 then
    begin
      DmlG.DmlServicos.AdicionaServicoItem(
        EdtCodMedicamento.Text,
        EdtDesMedicamento.Text,
        EdtVlrMedicamento.Text,
        MemObsMedicamento.Text,
        StgServicoItem);
    end
    else
    begin
      DmlG.DmlServicos.AlteraServicoItem(
        LblIteServico_EmAlteracao.Tag,
        EdtCodMedicamento.Text,
        EdtDesMedicamento.Text,
        EdtVlrMedicamento.Text,
        MemObsMedicamento.Text);
    end;
  except
    on E: Exception do
    begin
      Self.WindowState := wsNormal;
      case DmlG.DmlServicos.PosicionaCamposFServicosItem of
        pcFServicosItemCodMedicamento:
        begin
          if EdtCodMedicamento.CanFocus then
            EdtCodMedicamento.SetFocus;
        end;
      end;
      DmlG.DmlServicos.PosicionaCamposFServicosItem := pcFServicosItemNenhum;
      raise Exception.Create(E.Message)
    end;
  end;
  LimpaCamposServicoItem;
end;

procedure TFrmServicos.BtnRemoveMedicamentoClick(Sender: TObject);
begin
  inherited;
  if LblIteServico_EmAlteracao.Tag = 0 then
  begin
    DmlG.DmlServicos.ListaServicoItem.Delete(StgServicoItem.Row-1);
    if not (DmlG.DmlServicos.QryCadastro.State in [dsEdit, dsInsert]) then
      DmlG.DmlServicos.QryCadastro.Edit;
    DmlG.DmlServicos.AtualizaValorTotal;
  end
  else
    if DmlG.DmlServicos.QryCadastro.State = dsEdit then
      DmlG.DmlServicos.QryCadastro.Cancel;
  LimpaCamposServicoItem;
end;

procedure TFrmServicos.LimpaCamposServicoItem;
begin
  EdtCodMedicamento.Text := '';
  EdtDesMedicamento.Text := '';
  EdtVlrMedicamento.Text := '';
  MemObsMedicamento.Text := '';
  LblIteServico_EmAlteracao.Visible := False;
  LblIteServico_EmAlteracao.Tag := 0;
  BtnAdicionaServicoItem.ShowHint := True;
  BtnRemoveMedicamento.ShowHint := True;
end;

procedure TFrmServicos.EdtVlrMedicamentoExit(Sender: TObject);
begin
  inherited;
  EdtVlrMedicamento.Text := DeletaCharAlfanumerico(EdtVlrMedicamento.Text, ',');
  if not ContemNumeros(EdtVlrMedicamento.Text) then
    EdtVlrMedicamento.Text := '0,00';
end;

procedure TFrmServicos.StgServicoItemDblClick(Sender: TObject);
var
  vlsCodMedicamento,
  vlsDesMedicamento,
  vlsVlrMedicamento,
  vlsObsMedicamento: String;
begin
  inherited;
  if not (DmlG.DmlServicos.QryCadastro.State in [dsEdit, dsInsert]) then
    DmlG.DmlServicos.QryCadastro.Edit;
  DmlG.DmlServicos.QryCadastro.Edit;
  DmlG.DmlServicos.PopulaCampos(
    StgServicoItem.Row-1,
    vlsCodMedicamento,
    vlsDesMedicamento,
    vlsVlrMedicamento,
    vlsObsMedicamento);
  EdtCodMedicamento.Text := vlsCodMedicamento;
  EdtDesMedicamento.Text := vlsDesMedicamento;
  EdtVlrMedicamento.Text := vlsVlrMedicamento;
  MemObsMedicamento.Text := vlsObsMedicamento;
  if Trim(EdtCodMedicamento.Text) <> '' then
  begin
    LblIteServico_EmAlteracao.Visible := True;
    LblIteServico_EmAlteracao.Tag := StrToInt(StgServicoItem.Cells[1,StgServicoItem.Row]);
    BtnAdicionaServicoItem.ShowHint := False;
    BtnRemoveMedicamento.ShowHint := False;
  end;
end;

procedure TFrmServicos.EdtCodMedicamentoExit(Sender: TObject);
begin
  inherited;
  try
    EdtCodMedicamento.Text := TDmGeral(DmlG).DmlMedicamentos.ValidaExisteRegistro(EdtCodMedicamento.Text);
    if Trim(EdtCodMedicamento.Text) = '' then
      Exit;
    EdtDesMedicamento.Text := TDmGeral(DmlG).DmlMedicamentos.QryCadastroDESMEDICAMENTO.AsString;
    EdtVlrMedicamento.Text := FormatFloat('#,##0.00', TDmGeral(DmlG).DmlMedicamentos.QryCadastroVLRMEDICAMENTO.AsFloat);
  except
    on E: Exception do
    begin
      if EdtCodMedicamento.CanFocus then
        EdtCodMedicamento.SetFocus;
      raise Exception.Create(E.Message);
    end;
  end;
end;

procedure TFrmServicos.EdtCODFARMACEUTICOExit(Sender: TObject);
begin
  inherited;
  try
    EdtCODFARMACEUTICO.Text := TDmGeral(DmlG).DmlFarmaceuticos.ValidaExisteRegistro(EdtCODFARMACEUTICO.Text);
    if Trim(EdtCODFARMACEUTICO.Text) = '' then
      Exit;
    EdtNOMFARMACEUTICO.Text := TDmGeral(DmlG).DmlFarmaceuticos.QryCadastroNOMFARMACEUTICO.AsString;
  except
    on E: Exception do
    begin
      if EdtCODFARMACEUTICO.CanFocus then
        EdtCODFARMACEUTICO.SetFocus;
      raise Exception.Create(E.Message);
    end;
  end;
end;

procedure TFrmServicos.EdtCODPACIENTEExit(Sender: TObject);
begin
  inherited;
  try
    EdtCODPACIENTE.Text := TDmGeral(DmlG).DmlPacientes.ValidaExisteRegistro(EdtCODPACIENTE.Text);
    if Trim(EdtCODPACIENTE.Text) = '' then
      Exit;
    EdtNOMPACIENTE.Text := TDmGeral(DmlG).DmlPacientes.QryCadastroNOMPACIENTE.AsString;
  except
    on E: Exception do
    begin
      if EdtCODPACIENTE.CanFocus then
        EdtCODPACIENTE.SetFocus;
      raise Exception.Create(E.Message);
    end;
  end;
end;

end.
