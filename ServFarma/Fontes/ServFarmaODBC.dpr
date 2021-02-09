program ServFarmaODBC;
{-------------------------------------------------------------------------------
Objetivo...: Sistema Serviços Farmacêuticos
--------------------------------------------------------------------------------
Programador: Vaceano Ittner
Data e Hora: 19/01/2021 00:10
01) Criação do programa
-------------------------------------------------------------------------------}

uses
  Forms,
  SCarregaProjeto in 'SCarregaProjeto.PAS' {FrmSCarregaProjeto},
  FMenu in 'FMenu.pas' {FrmMenu},
  DConexao in 'DConexao.pas' {DmConexao: TDataModule},
  DGeral in 'DGeral.pas' {DmGeral: TDataModule},
  UConst in 'UConst.pas',
  UFerramentas in 'UFerramentas.pas',
  UFerramentasB in 'UFerramentasB.pas',
  SDataOpcao in 'SDataOpcao.pas' {FrmSDataOpcao},
  SPesquisa in 'SPesquisa.pas' {FrmSPesquisa},
  SException in 'SException.pas' {FrmSException},
  SSobreSistema in 'SSobreSistema.PAS' {FrmSSobreSistema},
  AFPadrao in 'AFPadrao.pas' {AFrmPadrao},
  AFPadraoCadastro in 'AFPadraoCadastro.pas' {AFrmPadraoCadastro},
  ADPadrao in 'ADPadrao.pas' {ADmPadrao: TDataModule},
  AFPadraoConsulta in 'AFPadraoConsulta.pas' {AFrmPadraoConsulta},
  FFarmaceuticos in 'FFarmaceuticos.pas' {FrmFarmaceuticos},
  DFarmaceuticos in 'DFarmaceuticos.pas' {DmFarmaceuticos: TDataModule},
  DPacientes in 'DPacientes.pas' {DmPacientes: TDataModule},
  FPacientes in 'FPacientes.pas' {FrmPacientes},
  FMedicamentos in 'FMedicamentos.pas' {FrmMedicamentos},
  DMedicamentos in 'DMedicamentos.pas' {DmMedicamentos: TDataModule},
  DServicos in 'DServicos.pas' {DmServicos: TDataModule},
  FServicos in 'FServicos.pas';

{$R *.RES}

//tamanho maximo do form 530 x 780
begin
  FrmSCarregaProjeto := TFrmSCarregaProjeto.Create(Application);
  FrmSCarregaProjeto.Show;
  FrmSCarregaProjeto.Update;
  Application.Initialize;
  Application.Title := 'Serviços Farmacêuticos';
  Application.CreateForm(TDmConexao, DmConexao);
  Application.CreateForm(TFrmMenu, FrmMenu);
  FrmSCarregaProjeto.Hide;
  FrmSCarregaProjeto.Free;
  Application.Run;
end.
