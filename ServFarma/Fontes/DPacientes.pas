unit DPacientes;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADPadrao, Db, DBTables;

type
  TPosicionaCamposFPacientes = (
    pcFPacientesNenhum,
    pcFPacientesCODPaciente,
    pcFPacientesNomPaciente);

  TDmPacientes = class(TADmPadrao)
    QryCadastroCODPACIENTE: TIntegerField;
    QryCadastroNOMPACIENTE: TStringField;
    procedure QryCadastroBeforePost(DataSet: TDataSet);
    procedure QryCadastroAfterPost(DataSet: TDataSet);
  private
    FPosicionaCamposFPacientes: TPosicionaCamposFPacientes;
    procedure ValidaCampos(DataSet: TDataSet);
    procedure SetPosicionaCamposFPacientes(
      const Value: TPosicionaCamposFPacientes);
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure GravaTodasTabelas;
    property PosicionaCamposFPacientes: TPosicionaCamposFPacientes
      read FPosicionaCamposFPacientes write SetPosicionaCamposFPacientes;
    procedure ValidaExistePaciente(vpiCodPaciente: Integer);
    function ExistePaciente(vpiCodPaciente: Integer): Boolean;
    function Pesquisa(vpsChaveDeBusca: String; vptBtnCadastro: TObject = nil): String;
    { Public declarations }
  end;

var
  DmPacientes: TDmPacientes;

implementation

uses
  UFerramentas, UFerramentasB, DConexao, SPesquisa;

{$R *.DFM}

constructor TDmPacientes.Create(AOwner: TComponent);
begin
  NomeCampoChave := 'CodPaciente';
  inherited Create(AOwner);
end;

procedure TDmPacientes.QryCadastroBeforePost(DataSet: TDataSet);
begin
  inherited;
  ValidaCampos(DataSet);
end;

procedure TDmPacientes.ValidaCampos(DataSet: TDataSet);
begin
  PosicionaCamposFPacientes := pcFPacientesNenhum;
  if (DataSet.State in [dsEdit]) then
  begin
    if DataSet.FieldByName('CodPaciente').AsString = '' then
    begin
      PosicionaCamposFPacientes := pcFPacientesCodPaciente;
      raise Exception.Create('O código do Paciente é obrigatório! ');
    end;
  end;

  if DataSet.FieldByName('NomPaciente').AsString = '' then
  begin
    PosicionaCamposFPacientes := pcFPacientesNomPaciente;
    raise Exception.Create('O nome do Paciente é obrigatório! ');
  end;

end;

procedure TDmPacientes.GravaTodasTabelas;
begin
  if (QryCadastro.State in [dsEdit, dsInsert]) then
    QryCadastro.Post;
  Atualizar;
end;

procedure TDmPacientes.ValidaExistePaciente(vpiCodPaciente: Integer);
begin
  if not (ExistePaciente(vpiCodPaciente)) then
    raise Exception.Create(
      'Código do Paciente [' + IntToStr(vpiCodPaciente) + '] inexistente! ');
end;

function TDmPacientes.ExistePaciente(vpiCodPaciente: Integer): Boolean;
var
  vltQryPaciente: TQuery;
begin
  vltQryPaciente := TQuery.Create(nil);
  try
    with vltQryPaciente do
    begin
      Close;
      Databasename:= DmConexao.DbsConexao.DatabaseName;
      Sql.Clear;
      Sql.Add('SELECT *');
      Sql.Add('FROM Paciente ');
      Sql.Add('WHERE CODPaciente = :CODPaciente ');
      ParamByName('CODPaciente').AsInteger := vpiCodPaciente;
      Open;
      Result := not IsEmpty;
    end;
  finally
    if Assigned(vltQryPaciente) then
      vltQryPaciente.Free;
  end;
end;

procedure TDmPacientes.SetPosicionaCamposFPacientes(
  const Value: TPosicionaCamposFPacientes);
begin
  FPosicionaCamposFPacientes := Value;
end;

procedure TDmPacientes.QryCadastroAfterPost(DataSet: TDataSet);
begin
  inherited;
  QryCadastro.Last;
end;

function TDmPacientes.Pesquisa(vpsChaveDeBusca: String; vptBtnCadastro: TObject = nil): String;
begin
  try
    Result :=
      FNCPesquisa(
        vptBtnCadastro,
        'Cadastro dos pacientes',
        vpsChaveDeBusca,
        'CODPaciente AS Codigo',
        DmConexao.DbsConexao.DatabaseName,
        'Paciente',
        'CODPaciente AS Codigo',
        'NOMPaciente AS Nome',
        '',
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

