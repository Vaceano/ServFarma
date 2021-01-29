unit DMedicamento;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADPadrao, Db, DBTables;

type
  TPosicionaCamposFMedicamentos = (
    pcFMedicamentosNenhum,
    pcFMedicamentosCODMedicamento,
    pcFMedicamentosNomMedicamento);

  TDmMedicamentos = class(TADmPadrao)
    QryCadastroCODMedicamento: TIntegerField;
    QryCadastroNOMMedicamento: TStringField;
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
    { Public declarations }
  end;

var
  DmMedicamentos: TDmMedicamentos;

implementation

uses
  UFerramentas, UFerramentasB, DConexao;

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

  if DataSet.FieldByName('NomMedicamento').AsString = '' then
  begin
    PosicionaCamposFMedicamentos := pcFMedicamentosNomMedicamento;
    raise Exception.Create('O nome do Medicamento é obrigatório! ');
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
  Atualizar(IntToStr(UltimoGeneratorCriado('Medicamento')));
end;

end.

