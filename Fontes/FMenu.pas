unit FMenu;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, IniFiles, StdCtrls, DBCtrls, Menus, TabNotBk, DB,
  Tabs, DBTables, ComCtrls;

type
  TFrmMenu = class(TForm)
    pnMenuAuxiliar: TPanel;
    StbSistema: TStatusBar;
    BtnFarmaceuticos: TBitBtn;
    BtnPacientes: TBitBtn;
    BtnMedicamentos: TBitBtn;
    BtnServicos: TBitBtn;
    BtnBtnSobre1: TBitBtn;
    BtnBtnSaidaSistema1: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure BtnBtnSaidaSistema1Click(Sender: TObject);
    procedure BtnBtnSobre1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnFarmaceuticosClick(Sender: TObject);
    procedure BtnPacientesClick(Sender: TObject);
    procedure BtnMedicamentosClick(Sender: TObject);
    procedure BtnServicosClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMenu: TFrmMenu;

implementation

uses
  DConexao, UFerramentas, SSobreSistema, SDataOpcao, FFarmaceuticos,
  FPacientes, FMedicamentos, FServicos;

{$R *.DFM}

procedure TFrmMenu.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;
  StbSistema.Panels.Items[0].Text := vgsVersao;
  StbSistema.Panels.Items[1].Text := '';
end;

procedure TFrmMenu.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TFrmMenu.BtnBtnSobre1Click(Sender: TObject);
begin
  FNCSobreSistema;
end;

procedure TFrmMenu.BtnBtnSaidaSistema1Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmMenu.BtnFarmaceuticosClick(Sender: TObject);
begin
  if FrmFarmaceuticos = nil then
    Application.CreateForm(TFrmFarmaceuticos, FrmFarmaceuticos)
  else
    if FrmFarmaceuticos.WindowState = wsMinimized then
      FrmFarmaceuticos.WindowState := wsNormal;
  FrmFarmaceuticos.Show;
end;

procedure TFrmMenu.BtnPacientesClick(Sender: TObject);
begin
  if FrmPacientes = nil then
    Application.CreateForm(TFrmPacientes, FrmPacientes)
  else
    if FrmPacientes.WindowState = wsMinimized then
      FrmPacientes.WindowState := wsNormal;
  FrmPacientes.Show;
end;

procedure TFrmMenu.BtnMedicamentosClick(Sender: TObject);
begin
  if FrmMedicamentos = nil then
    Application.CreateForm(TFrmMedicamentos, FrmMedicamentos)
  else
    if FrmMedicamentos.WindowState = wsMinimized then
      FrmMedicamentos.WindowState := wsNormal;
  FrmMedicamentos.Show;
end;

procedure TFrmMenu.BtnServicosClick(Sender: TObject);
begin
  if FrmServicos = nil then
    Application.CreateForm(TFrmServicos, FrmServicos)
  else
    if FrmServicos.WindowState = wsMinimized then
      FrmServicos.WindowState := wsNormal;
  FrmServicos.Show;
end;

end.
