unit AFPadraoCadastro;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, DBCtrls, ExtCtrls, Grids, DGeral, Db, DBTables,
  AFPadrao;

type
  TAFrmPadraoCadastro = class(TAFrmPadrao)
    PnlControle: TPanel;
    DbnCadastro: TDBNavigator;
    BtnPesquisar: TBitBtn;
    BtnSair: TBitBtn;
    PnlGeral: TPanel;
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDeactivate(Sender: TObject);
    procedure BtnPesquisarClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    FDmlG: TDmGeral;
    function GetDmlG: TDmGeral;
    procedure SetaLabelDePesquisa;
    { Private declarations }
  public
    property DmlG: TDmGeral read GetDmlG;
    procedure GravaTodasTabelas; virtual;
    procedure RefreshNoCampo;
    { Public declarations }
  end;

var
  AFrmPadraoCadastro: TAFrmPadraoCadastro;

implementation

uses
  UConst;
  
{$R *.DFM}

procedure TAFrmPadraoCadastro.FormCreate(Sender: TObject);
begin
  inherited;
  SetaLabelDePesquisa;
end;

procedure TAFrmPadraoCadastro.SetaLabelDePesquisa;
var
  vli1: Integer;
begin
  for vli1 := 0 to ComponentCount - 1 do
    if Components[vli1] is TLabel then
      if (fsUnderline in TLabel(Components[vli1]).Font.Style) then
      begin
        TLabel(Components[vli1]).Cursor := crHandPoint;
        TLabel(Components[vli1]).Hint :=
          cgsDuploClickParaConsultarORegistroPorEsteCampo;
        TLabel(Components[vli1]).ShowHint := True;
      end;
end;

function TAFrmPadraoCadastro.GetDmlG: TDmGeral;
begin
  if not Assigned(FDmlG) then
    FDmlG := TDmGeral.Create(nil);
  Result := FDmlG;
end;

procedure TAFrmPadraoCadastro.FormDestroy(Sender: TObject);
begin
  inherited;
  if Assigned(FDmlG) then
    FDmlG.Free;
end;

procedure TAFrmPadraoCadastro.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
  AFrmPadraoCadastro := nil;
end;

procedure TAFrmPadraoCadastro.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  inherited;
  try
    GravaTodasTabelas;
  except
    on E: Exception do
    begin
      CanClose := False;
      raise Exception.Create(E.Message)
    end;
  end;
end;

procedure TAFrmPadraoCadastro.FormDeactivate(Sender: TObject);
begin
  inherited;
  GravaTodasTabelas;
end;

procedure TAFrmPadraoCadastro.BtnPesquisarClick(Sender: TObject);
begin
  inherited;
  GravaTodasTabelas;
end;

procedure TAFrmPadraoCadastro.BtnSairClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TAFrmPadraoCadastro.RefreshNoCampo;
var
  vltActiveControl: TWinControl;
begin
  vltActiveControl := ActiveControl;
  PnlControle.SetFocus;
  ActiveControl := vltActiveControl;
end;

procedure TAFrmPadraoCadastro.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if (Shift = [ssCtrl]) then
    if (Key = 83) then // 83=S
    begin
      RefreshNoCampo;
      GravaTodasTabelas;
    end;

  if (Shift = [ssCtrl]) then
    if Key = 45 then // 45=Insert
      DbnCadastro.BtnClick(nbInsert);

  if Shift = [ssShift] then
    if Key = 27 then // 27=Esc
      DbnCadastro.BtnClick(nbCancel);

{
  if (Key = 13)        //  13 » Enter
  and (Key = 17)       //  17 » Control
  and (Key = 18)       //  18 » Alt
  and (Key = 19)       //  19 » Pause
  and (Key = 20)       //  20 » Caps Lock
  and (Key = 27)       //  27 » Esc
  and (Key = 33)       //  33 » Page Up
  and (Key = 34)       //  34 » Page Down
  and (Key = 35)       //  35 » End
  and (Key = 36)       //  36 » Home
  and (Key = 37)       //  37 » Seta Esquerda
  and (Key = 38)       //  38 » Seta Acima
  and (Key = 39)       //  39 » Seta Direita
  and (Key = 40)       //  40 » Seta Abaixo
  and (Key = 45)       //  45 » Insert
  and (Key = 67)       //  67 » Ctrl + C
  and (Key = 91)       //  91 » Iniciar Windows Esquerdo
  and (Key = 92)       //  92 » Iniciar Windows Direito
  and (Key = 93)       //  93 » Popup Windows
  and (Key = 112)      // 112 » F1
  and (Key = 113)      // 113 » F2
  and (Key = 114)      // 114 » F3
  and (Key = 115)      // 115 » F4
  and (Key = 116)      // 116 » F5
  and (Key = 117)      // 117 » F6
  and (Key = 118)      // 118 » F7
  and (Key = 119)      // 119 » F8
  and (Key = 120)      // 120 » F9
  and (Key = 121)      // 121 » F10
  and (Key = 122)      // 122 » F11
  and (Key = 123)      // 123 » F12
  and (Key = 144)      // 144 » Num Lock
  and (Key = 145) then // 145 » Scroll Lock
}
end;

procedure TAFrmPadraoCadastro.GravaTodasTabelas;
begin
  // TABELAS QUE SERRÃO GRAVADAS
end;

end.
