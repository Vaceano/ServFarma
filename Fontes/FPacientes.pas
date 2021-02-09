unit FPacientes;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AFPadraoCadastro, StdCtrls, Buttons, DBCtrls, ExtCtrls, ComCtrls, Mask, Db,
  DBTables, ExtDlgs;

type
  TFrmPacientes = class(TAFrmPadraoCadastro)
    LblEdtCODPaciente: TLabel;
    LblEdtNOMPaciente: TLabel;
    EdtCodPaciente: TDBEdit;
    EdtNomPaciente: TDBEdit;
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
  FrmPacientes: TFrmPacientes;

implementation

uses
  DConexao, DPacientes, SPesquisa, UFerramentas, UFerramentasB,
  SException;

{$R *.DFM}

procedure TFrmPacientes.FormCreate(Sender: TObject);
begin
  inherited;
  DbnCadastro.DataSource := DmlG.DmlPacientes.DtsQryCadastro;
  SetaDataSource(DmlG.DmlPacientes.DtsQryCadastro, Self);
end;

procedure TFrmPacientes.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
  FrmPacientes := nil;
end;

procedure TFrmPacientes.BtnPesquisarClick(Sender: TObject);
var
  vlsResultConteudoInicialChave: String;
  vlsChaveDeBusca: String;
begin
  inherited;
  vlsChaveDeBusca := 'CODPaciente AS Codigo';
  if Sender = LblEdtNOMPaciente then
    vlsChaveDeBusca := 'NOMPaciente AS Nome';
  vlsResultConteudoInicialChave :=
    DmlG.DmlPacientes.Pesquisa(vlsChaveDeBusca);
  if (vlsResultConteudoInicialChave > '0') then
    DmlG.DmlPacientes.QryCadastro.Locate(
      'CODPaciente', vlsResultConteudoInicialChave, [loCaseInsensitive]);
end;

procedure TFrmPacientes.GravaTodasTabelas;
begin
  inherited;
  try
    DmlG.DmlPacientes.GravaTodasTabelas;
  except
    on E: Exception do
    begin
      Self.WindowState := wsNormal;
      case DmlG.DmlPacientes.PosicionaCamposFPacientes of
        pcFPacientesCODPaciente:
        begin
          if EdtCodPaciente.CanFocus then
            EdtCodPaciente.SetFocus;
        end;
        pcFPacientesNomPaciente:
        begin
          if EdtNomPaciente.CanFocus then
            EdtNomPaciente.SetFocus;
        end;
      end;
      raise Exception.Create(E.Message)
    end;
  end;
end;

procedure TFrmPacientes.DbnCadastroBeforeAction(Sender: TObject;
  Button: TNavigateBtn);
begin
  inherited;
  case Button of
    nbInsert:
    begin
      if EdtNomPaciente.CanFocus then
        EdtNomPaciente.SetFocus;
    end;
    nbPost:
    begin
      try
        GravaTodasTabelas;
        if not (DmlG.DmlPacientes.QryCadastro.State in [dsEdit, dsInsert]) then
          DmlG.DmlPacientes.QryCadastro.Edit;
      except
        on E: Exception do
          raise Exception.Create(E.Message);
      end;
    end;
  end;
end;

end.
