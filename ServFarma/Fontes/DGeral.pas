unit DGeral;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DFarmaceuticos, DPacientes, DMedicamentos, DServicos;

type
  TDmGeral = class(TDataModule)
    procedure DmGeralDestroy(Sender: TObject);
  private
    FDmlFarmaceuticos: TDmFarmaceuticos;
    FDmlPacientes: TDmPacientes;
    FDmlMedicamentos: TDmMedicamentos;
    FDmlServicos: TDmServicos;
    function GetDmlServicos: TDmServicos;
    function GetDmlMedicamentos: TDmMedicamentos;
    function GetDmlPacientes: TDmPacientes;
    function GetDmlFarmaceuticos: TDmFarmaceuticos;
    { Private declarations }
  public
    property DmlFarmaceuticos: TDmFarmaceuticos read GetDmlFarmaceuticos;
    property DmlPacientes: TDmPacientes read GetDmlPacientes;
    property DmlMedicamentos: TDmMedicamentos read GetDmlMedicamentos;
    property DmlServicos: TDmServicos read GetDmlServicos;
    procedure DmlServicosFree;
    procedure DmlMedicamentosFree;
    procedure DmlPacientesFree;
    procedure DmlFarmaceuticosFree;
    { Public declarations }
  end;

implementation

{$R *.DFM}

procedure TDmGeral.DmGeralDestroy(Sender: TObject);
begin
  DmlFarmaceuticosFree;
  DmlPacientesFree;
  DmlMedicamentosFree;
  DmlServicosFree;
end;

function TDmGeral.GetDmlServicos: TDmServicos;
begin
  if not Assigned(FDmlServicos) then
    FDmlServicos := TDmServicos.Create(nil);
  Result := FDmlServicos;
end;

procedure TDmGeral.DmlServicosFree;
begin
  if Assigned(FDmlServicos) then
  begin
    FDmlServicos.Free;
    FDmlServicos := nil;
  end
end;

function TDmGeral.GetDmlMedicamentos: TDmMedicamentos;
begin
  if not Assigned(FDmlMedicamentos) then
    FDmlMedicamentos := TDmMedicamentos.Create(nil);
  Result := FDmlMedicamentos;
end;

procedure TDmGeral.DmlMedicamentosFree;
begin
  if Assigned(FDmlMedicamentos) then
  begin
    FDmlMedicamentos.Free;
    FDmlMedicamentos := nil;
  end
end;

function TDmGeral.GetDmlPacientes: TDmPacientes;
begin
  if not Assigned(FDmlPacientes) then
    FDmlPacientes := TDmPacientes.Create(nil);
  Result := FDmlPacientes;
end;

procedure TDmGeral.DmlPacientesFree;
begin
  if Assigned(FDmlPacientes) then
  begin
    FDmlPacientes.Free;
    FDmlPacientes := nil;
  end
end;

function TDmGeral.GetDmlFarmaceuticos: TDmFarmaceuticos;
begin
  if not Assigned(FDmlFarmaceuticos) then
    FDmlFarmaceuticos := TDmFarmaceuticos.Create(nil);
  Result := FDmlFarmaceuticos;
end;

procedure TDmGeral.DmlFarmaceuticosFree;
begin
  if Assigned(FDmlFarmaceuticos) then
  begin
    FDmlFarmaceuticos.Free;
    FDmlFarmaceuticos := nil;
  end
end;

end.
