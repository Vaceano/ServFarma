unit FFarmaceuticos;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AFPadraoCadastro, StdCtrls, Buttons, DBCtrls, ExtCtrls, ComCtrls, Mask, Db,
  DBTables, ExtDlgs;

type
  TFrmFarmaceuticos = class(TAFrmPadraoCadastro)
    LblEdtCODFarmaceutico: TLabel;
    LblEdtNOMFarmaceutico: TLabel;
    EdtCodFarmaceutico: TDBEdit;
    EdtNomFarmaceutico: TDBEdit;
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
  FrmFarmaceuticos: TFrmFarmaceuticos;

implementation

uses
  DConexao, DFarmaceuticos, SPesquisa, UFerramentas, UFerramentasB,
  SException;

{$R *.DFM}

procedure TFrmFarmaceuticos.FormCreate(Sender: TObject);
begin
  inherited;
  DbnCadastro.DataSource := DmlG.DmlFarmaceuticos.DtsQryCadastro;
  SetaDataSource(DmlG.DmlFarmaceuticos.DtsQryCadastro, Self);
end;

procedure TFrmFarmaceuticos.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
  FrmFarmaceuticos := nil;
end;

procedure TFrmFarmaceuticos.BtnPesquisarClick(Sender: TObject);
var
  vlsResultConteudoInicialChave: String;
  vlsChaveDeBusca: String;
begin
  inherited;
  vlsChaveDeBusca := 'CODFARMACEUTICO AS Codigo';
  if Sender = LblEdtNOMFarmaceutico then
    vlsChaveDeBusca := 'NOMFARMACEUTICO AS Nome';
  vlsResultConteudoInicialChave :=
    DmlG.DmlFarmaceuticos.Pesquisa(vlsChaveDeBusca);
  if (vlsResultConteudoInicialChave > '0') then
    DmlG.DmlFarmaceuticos.QryCadastro.Locate(
      'CODFARMACEUTICO', vlsResultConteudoInicialChave, [loCaseInsensitive]);
end;

procedure TFrmFarmaceuticos.GravaTodasTabelas;
begin
  inherited;
  try
    DmlG.DmlFarmaceuticos.GravaTodasTabelas;
  except
    on E: Exception do
    begin
      Self.WindowState := wsNormal;
      case DmlG.DmlFarmaceuticos.PosicionaCamposFFarmaceuticos of
        pcFFarmaceuticosCODFarmaceutico:
        begin
          if EdtCodFarmaceutico.CanFocus then
            EdtCodFarmaceutico.SetFocus;
        end;
        pcFFarmaceuticosNomFarmaceutico:
        begin
          if EdtNomFarmaceutico.CanFocus then
            EdtNomFarmaceutico.SetFocus;
        end;
      end;
      raise Exception.Create(E.Message)
    end;
  end;
end;

procedure TFrmFarmaceuticos.DbnCadastroBeforeAction(Sender: TObject;
  Button: TNavigateBtn);
begin
  inherited;
  case Button of
    nbInsert:
    begin
      if EdtNomFarmaceutico.CanFocus then
        EdtNomFarmaceutico.SetFocus;
    end;
    nbPost:
    begin
      try
        GravaTodasTabelas;
        if not (DmlG.DmlFarmaceuticos.QryCadastro.State in [dsEdit, dsInsert]) then
          DmlG.DmlFarmaceuticos.QryCadastro.Edit;
      except
        on E: Exception do
          raise Exception.Create(E.Message);
      end;
    end;
  end;
end;

end.
