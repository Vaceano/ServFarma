unit DFarmaceuticos;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADPadrao, Db, DBTables;

type
  TPosicionaCamposFFarmaceuticos = (
    pcFFarmaceuticosNenhum,
    pcFFarmaceuticosCODFarmaceutico,
    pcFFarmaceuticosNomFarmaceutico);

  TDmFarmaceuticos = class(TADmPadrao)
    QryCadastroCODFARMACEUTICO: TIntegerField;
    QryCadastroNOMFARMACEUTICO: TStringField;
    procedure QryCadastroBeforePost(DataSet: TDataSet);
    procedure QryCadastroAfterPost(DataSet: TDataSet);
  private
    FPosicionaCamposFFarmaceuticos: TPosicionaCamposFFarmaceuticos;
    procedure ValidaCampos(DataSet: TDataSet);
    procedure SetPosicionaCamposFFarmaceuticos(
      const Value: TPosicionaCamposFFarmaceuticos);
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    procedure GravaTodasTabelas;
    property PosicionaCamposFFarmaceuticos: TPosicionaCamposFFarmaceuticos
      read FPosicionaCamposFFarmaceuticos write SetPosicionaCamposFFarmaceuticos;
    function Pesquisa(vpsChaveDeBusca: String; vptBtnCadastro: TObject = nil): String;
    { Public declarations }
  end;

var
  DmFarmaceuticos: TDmFarmaceuticos;

implementation

uses
  UFerramentas, UFerramentasB, DConexao, SPesquisa;

{$R *.DFM}

constructor TDmFarmaceuticos.Create(AOwner: TComponent);
begin
  NomeEntidade := 'Farmacêutico';
  NomeCampoChave := 'CodFarmaceutico';
  inherited Create(AOwner);
end;

procedure TDmFarmaceuticos.QryCadastroBeforePost(DataSet: TDataSet);
begin
  inherited;
  ValidaCampos(DataSet);
end;

procedure TDmFarmaceuticos.ValidaCampos(DataSet: TDataSet);
begin
  PosicionaCamposFFarmaceuticos := pcFFarmaceuticosNenhum;
  if (DataSet.State in [dsEdit]) then
  begin
    if DataSet.FieldByName('CodFarmaceutico').AsString = '' then
    begin
      PosicionaCamposFFarmaceuticos := pcFFarmaceuticosCodFarmaceutico;
      raise Exception.Create('O código do Farmacêutico é obrigatório! ');
    end;
  end;

  if DataSet.FieldByName('NomFarmaceutico').AsString = '' then
  begin
    PosicionaCamposFFarmaceuticos := pcFFarmaceuticosNomFarmaceutico;
    raise Exception.Create('O nome do Farmacêutico é obrigatório! ');
  end;

end;

procedure TDmFarmaceuticos.GravaTodasTabelas;
begin
  if (QryCadastro.State in [dsEdit, dsInsert]) then
    QryCadastro.Post;
  Atualizar;
end;

procedure TDmFarmaceuticos.SetPosicionaCamposFFarmaceuticos(
  const Value: TPosicionaCamposFFarmaceuticos);
begin
  FPosicionaCamposFFarmaceuticos := Value;
end;

procedure TDmFarmaceuticos.QryCadastroAfterPost(DataSet: TDataSet);
begin
  inherited;
  QryCadastro.Last;
end;

function TDmFarmaceuticos.Pesquisa(vpsChaveDeBusca: String; vptBtnCadastro: TObject = nil): String;
begin
  try
    Result :=
      FNCPesquisa(
        vptBtnCadastro,
        'cadastro de farmaceuticos',
        vpsChaveDeBusca,
        'CODFARMACEUTICO AS Codigo',
        DmConexao.DbsConexao.DatabaseName,
        'FARMACEUTICO',
        'CODFARMACEUTICO AS Codigo',
        'NOMFARMACEUTICO AS Nome',
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

