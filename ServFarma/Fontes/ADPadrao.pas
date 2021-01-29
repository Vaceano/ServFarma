unit ADPadrao;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables;

type
  TADmPadrao = class(TDataModule)
    QryCadastro: TQuery;
    DtsQryCadastro: TDataSource;
    procedure DmPadraoDestroy(Sender: TObject);
  private
    FDmlG: TDataModule;
    FFormOrigem: TComponent;
    FNomeCampoChave: String;
    function GetDmlG: TDataModule;
    procedure SetFormOrigem(const Value: TComponent);
    procedure SetNomeCampoChave(const Value: String);
    { Private declarations }
  public
    constructor Create(AOwner: TComponent); override;
    property DmlG: TDataModule read GetDmlG;
    property FormOrigem: TComponent read FFormOrigem write SetFormOrigem;
    procedure Atualizar(vpsCod: String = ''); dynamic;
    property NomeCampoChave: String read FNomeCampoChave write SetNomeCampoChave;
    { Public declarations }
  end;

var
  ADmPadrao: TADmPadrao;

implementation

uses
  DGeral, UFerramentasB;

{$R *.DFM}

constructor TADmPadrao.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Atualizar;
end;

procedure TADmPadrao.DmPadraoDestroy(Sender: TObject);
begin
  if Assigned(FDmlG) then
    FDmlG.Free;
end;

function TADmPadrao.GetDmlG: TDataModule;
begin
  if not Assigned(FDmlG) then
    FDmlG := TDmGeral.Create(nil);
  Result := FDmlG;
end;

procedure TADmPadrao.SetFormOrigem(const Value: TComponent);
begin
  FFormOrigem := Value;
end;


procedure TADmPadrao.Atualizar(vpsCod: String = '');
var
  vlsCod: String;
begin
  if Trim(NomeCampoChave) = '' then
    raise Exception.Create(
      'MENSAGEM AO DESENVOLVIMENTO!!!' + #13 + #13 +
      '¨NomeCampoChave¨ não preenchido!');

  if Trim(vpsCod) > '' then
    vlsCod := vpsCod
  else
    vlsCod := QryCadastro.FieldByName(NomeCampoChave).AsString;

  try
    QryCadastro.DisableControls;
    AbreQry(QryCadastro);
    if Trim(vlsCod) > '' then
      if not (QryCadastro.IsEmpty) then
        if not (QryCadastro.Locate(NomeCampoChave, vlsCod, [loCaseInsensitive])) then
          QryCadastro.Last;
  finally
    QryCadastro.EnableControls;
  end;
end;

procedure TADmPadrao.SetNomeCampoChave(const Value: String);
begin
  FNomeCampoChave := Value;
end;

end.
