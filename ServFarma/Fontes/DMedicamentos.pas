unit DMedicamentos;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADPadrao, Db, DBTables;

type
  TPosicionaCamposFMedicamentos = (
    pcFMedicamentosNenhum,
    pcFMedicamentosCODMedicamento,
    pcFMedicamentosDesMedicamento);

  TDmMedicamentos = class(TADmPadrao)
    QryCadastroCODMEDICAMENTO: TIntegerField;
    QryCadastroDESMEDICAMENTO: TStringField;
    QryCadastroVLRMEDICAMENTO: TFloatField;
    procedure QryCadastroBeforePost(DataSet: TDataSet);
    procedure QryCadastroAfterPost(DataSet: TDataSet);
  private
    FPosicionaCamposFMedicamentos: TPosicionaCamposFMedicamentos;
    procedure ValidaCampos(DataSet: TDataSet);
    procedure SetPosicionaCamposFMedicamentos(
      const Value: TPosicionaCamposFMedicamentos);
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure GravaTodasTabelas;
    property PosicionaCamposFMedicamentos: TPosicionaCamposFMedicamentos
      read FPosicionaCamposFMedicamentos write SetPosicionaCamposFMedicamentos;
    procedure ValidaExisteMedicamento(vpiCodMedicamento: Integer);
    function ExisteMedicamento(vpiCodMedicamento: Integer): Boolean;
    function Pesquisa(vpsChaveDeBusca: String; vptBtnCadastro: TObject = nil): String;
    { Public declarations }
  end;

var
  DmMedicamentos: TDmMedicamentos;

implementation

uses
  UFerramentas, UFerramentasB, DConexao, SPesquisa;

{$R *.DFM}

constructor TDmMedicamentos.Create(AOwner: TComponent);
begin
  NomeCampoChave := 'CodMedicamento';
  inherited Create(AOwner);
end;

procedure TDmMedicamentos.QryCadastroBeforePost(DataSet: TDataSet);
begin
  inherited;
  ValidaCampos(DataSet);
end;

procedure TDmMedicamentos.ValidaCampos(DataSet: TDataSet);
begin
  PosicionaCamposFMedicamentos := pcFMedicamentosNenhum;
  if (DataSet.State in [dsEdit]) then
  begin
    if DataSet.FieldByName('CodMedicamento').AsString = '' then
    begin
      PosicionaCamposFMedicamentos := pcFMedicamentosCodMedicamento;
      raise Exception.Create('O código do Medicamento é obrigatório! ');
    end;
  end;

  if DataSet.FieldByName('DesMedicamento').AsString = '' then
  begin
    PosicionaCamposFMedicamentos := pcFMedicamentosDesMedicamento;
    raise Exception.Create('O descrição do Medicamento é obrigatório! ');
  end;

end;

procedure TDmMedicamentos.GravaTodasTabelas;
begin
  if (QryCadastro.State in [dsEdit, dsInsert]) then
    QryCadastro.Post;
  Atualizar;
end;

procedure TDmMedicamentos.ValidaExisteMedicamento(vpiCodMedicamento: Integer);
begin
  if not (ExisteMedicamento(vpiCodMedicamento)) then
    raise Exception.Create(
      'Código do Medicamento [' + IntToStr(vpiCodMedicamento) + '] inexistente! ');
end;

function TDmMedicamentos.ExisteMedicamento(vpiCodMedicamento: Integer): Boolean;
var
  vltQryMedicamento: TQuery;
begin
  vltQryMedicamento := TQuery.Create(nil);
  try
    with vltQryMedicamento do
    begin
      Close;
      Databasename:= DmConexao.DbsConexao.DatabaseName;
      Sql.Clear;
      Sql.Add('SELECT *');
      Sql.Add('FROM Medicamento ');
      Sql.Add('WHERE CODMedicamento = :CODMedicamento ');
      ParamByName('CODMedicamento').AsInteger := vpiCodMedicamento;
      Open;
      Result := not IsEmpty;
    end;
  finally
    if Assigned(vltQryMedicamento) then
      vltQryMedicamento.Free;
  end;
end;

procedure TDmMedicamentos.SetPosicionaCamposFMedicamentos(
  const Value: TPosicionaCamposFMedicamentos);
begin
  FPosicionaCamposFMedicamentos := Value;
end;

procedure TDmMedicamentos.QryCadastroAfterPost(DataSet: TDataSet);
begin
  inherited;
  QryCadastro.Last;
end;

function TDmMedicamentos.Pesquisa(vpsChaveDeBusca: String; vptBtnCadastro: TObject = nil): String;
begin
  try
    Result :=
      FNCPesquisa(
        vptBtnCadastro,
        'Cadastro dos medicamento',
        vpsChaveDeBusca,
        'CODMedicamento AS Codigo',
        DmConexao.DbsConexao.DatabaseName,
        'Medicamento',
        'CODMedicamento AS Codigo',
        'DesMedicamento AS Nome',
        'VlrMedicamento as Valor',
        '',
        '',
        '');
  except
    on E: Exception do
      raise Exception.Create(
        'Erro na pesquisa! ' + #13 + #13 +
        '[' + E.Message + ']!');
  end;
end;

end.

