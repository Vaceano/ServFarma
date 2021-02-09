unit FMedicamentos;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AFPadraoCadastro, StdCtrls, Buttons, DBCtrls, ExtCtrls, ComCtrls, Mask, Db,
  DBTables, ExtDlgs;

type
  TFrmMedicamentos = class(TAFrmPadraoCadastro)
    LblEdtCODMedicamento: TLabel;
    LblEdtDesMedicamento: TLabel;
    EdtCODMedicamento: TDBEdit;
    EdtDesMedicamento: TDBEdit;
    LblEdtVlrMedicamento: TLabel;
    EdtVlrMedicamento: TDBEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnPesquisarClick(Sender: TObject);
    procedure DbnCadastroBeforeAction(Sender: TObject;
      Button: TNavigateBtn);
  private
    { Private declarations }
  public
    procedure GravaTodasTabelas; override;
    { Public declarations }
  end;

var
  FrmMedicamentos: TFrmMedicamentos;

implementation

uses
  DConexao, DMedicamentos, SPesquisa, UFerramentas, UFerramentasB,
  SException;

{$R *.DFM}

procedure TFrmMedicamentos.FormCreate(Sender: TObject);
begin
  inherited;
  DbnCadastro.DataSource := DmlG.DmlMedicamentos.DtsQryCadastro;
  SetaDataSource(DmlG.DmlMedicamentos.DtsQryCadastro, Self);
end;

procedure TFrmMedicamentos.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
  FrmMedicamentos := nil;
end;

procedure TFrmMedicamentos.BtnPesquisarClick(Sender: TObject);
var
  vlsResultConteudoInicialChave: String;
  vlsChaveDeBusca: String;
begin
  inherited;
  vlsChaveDeBusca := 'CODMedicamento AS Codigo';
  if Sender = LblEdtDesMedicamento then
    vlsChaveDeBusca := 'DesMedicamento AS Nome';
  vlsResultConteudoInicialChave :=
    DmlG.DmlMedicamentos.Pesquisa(vlsChaveDeBusca);
  if (vlsResultConteudoInicialChave > '0') then
    DmlG.DmlMedicamentos.QryCadastro.Locate(
      'CODMedicamento', vlsResultConteudoInicialChave, [loCaseInsensitive]);
end;

procedure TFrmMedicamentos.GravaTodasTabelas;
begin
  inherited;
  try
    DmlG.DmlMedicamentos.GravaTodasTabelas;
  except
    on E: Exception do
    begin
      Self.WindowState := wsNormal;
      case DmlG.DmlMedicamentos.PosicionaCamposFMedicamentos of
        pcFMedicamentosCODMedicamento:
        begin
          if EdtCodMedicamento.CanFocus then
            EdtCodMedicamento.SetFocus;
        end;
        pcFMedicamentosDesMedicamento:
        begin
          if EdtDesMedicamento.CanFocus then
            EdtDesMedicamento.SetFocus;
        end;
      end;
      raise Exception.Create(E.Message)
    end;
  end;
end;

procedure TFrmMedicamentos.DbnCadastroBeforeAction(Sender: TObject;
  Button: TNavigateBtn);
begin
  inherited;
  case Button of
    nbInsert:
    begin
      if EdtDesMedicamento.CanFocus then
        EdtDesMedicamento.SetFocus;
    end;
    nbPost:
    begin
      try
        GravaTodasTabelas;
        if not (DmlG.DmlMedicamentos.QryCadastro.State in [dsEdit, dsInsert]) then
          DmlG.DmlMedicamentos.QryCadastro.Edit;
      except
        on E: Exception do
          raise Exception.Create(E.Message);
      end;
    end;
  end;
end;

end.
