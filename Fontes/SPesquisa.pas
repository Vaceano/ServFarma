unit SPesquisa;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, DBTables, Grids, DBGrids, DBCtrls, ExtCtrls, StdCtrls, Buttons, DConexao;

type
  TFrmSPesquisa = class(TForm)
    PnlControle: TPanel;
    PnlComandoAuxiliar: TPanel;
    gbPesquisa: TGroupBox;
    RdbPesquisaChave1: TRadioButton;
    RdbPesquisaChave2: TRadioButton;
    RdbPesquisaChave3: TRadioButton;
    EdtProcura: TEdit;
    RdbPesquisaChave4: TRadioButton;
    RdbPesquisaChave5: TRadioButton;
    BtnCadastro: TBitBtn;
    PnlLocalizacaoEOrdenacao: TPanel;
    RgLocalDaConsulta: TRadioGroup;
    RgOrdenacao: TRadioGroup;
    PnlNavegador: TPanel;
    DbnDtsQryCadastro: TDBNavigator;
    BtnCancela: TBitBtn;
    BtnOk: TBitBtn;
    PnlGeral: TPanel;
    DbgDtsQryPesquisa: TDBGrid;
    QryPesquisa: TQuery;
    DtsQryPesquisa: TDataSource;
    procedure EdtProcuraChange(Sender: TObject);
    procedure DbgDtsQryPesquisaDblClick(Sender: TObject);
    procedure DbgDtsQryPesquisaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnCadastroClick(Sender: TObject);
    procedure RdbPesquisaChave1Click(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure EdtProcuraKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FSqlAtivo: Boolean;
    FChaveInvisivel: String;
    FChaveInvisivel2: String;
    FBtnCadastro: TObject;
    FNomePesquisa: String;
    FNomeCampoInicioPesquisa: String;
    FNomeCampoRetornoPesquisa: String;
    FNomeAlias: String;
    FNomeTabela: String;
    FNomeCampoChave1: String;
    FAliasCampoChave1: String;
    FNomeCampoChave2: String;
    FAliasCampoChave2: String;
    FNomeCampoChave3: String;
    FAliasCampoChave3: String;
    FNomeCampoChave4: String;
    FAliasCampoChave4: String;
    FNomeCampoChave5: String;
    FAliasCampoChave5: String;
    FWhere: String;
    FNomeCampoRetornoPesquisa2ComResult: String;
    function NomeCampo(vpsNomeCompleto: String): String;
    function NomeAlias(vpsNomeCompleto: String): String;
    { Private declarations }
  public
    { Public declarations }
  end;


function FNCPesquisa(
  vptBtnCadastro: TObject;
  vpsNomePesquisa,
  vpsNomeCampoInicioPesquisa,
  vpsNomeCampoRetornoPesquisa,
  vpsNomeAlias,
  vpsNomeTabela,
  vpsNomeCampoChave1,
  vpsNomeCampoChave2,
  vpsNomeCampoChave3,
  vpsNomeCampoChave4,
  vpsNomeCampoChave5,
  vpsWhere: String): String; overload;

function FNCPesquisa(
  vptBtnCadastro: TObject;
  vpsNomePesquisa,
  vpsNomeCampoInicioPesquisa,
  vpsNomeCampoRetornoPesquisa,
  vpsNomeAlias,
  vpsNomeTabela,
  vpsNomeCampoChave1,
  vpsNomeCampoChave2,
  vpsNomeCampoChave3,
  vpsNomeCampoChave4,
  vpsNomeCampoChave5,
  vpsWhere: String;
  var vpsNomeCampoRetornoPesquisa2ComResult: String): String; overload;

var
  FrmSPesquisa: TFrmSPesquisa;
  AUXResultadoPesquisa: String;
  AUXResultadoPesquisa2: String;

implementation

uses
  UFerramentas;

{$R *.DFM}

{ TFrmSPesquisa }

function FNCPesquisa(
  vptBtnCadastro: TObject;
  vpsNomePesquisa,
  vpsNomeCampoInicioPesquisa,
  vpsNomeCampoRetornoPesquisa,
  vpsNomeAlias,
  vpsNomeTabela,
  vpsNomeCampoChave1,
  vpsNomeCampoChave2,
  vpsNomeCampoChave3,
  vpsNomeCampoChave4,
  vpsNomeCampoChave5,
  vpsWhere: String): String;
var
  vpsNomeCampoRetornoPesquisa2ComResult: String;
begin
  vpsNomeCampoRetornoPesquisa2ComResult := vpsNomeCampoRetornoPesquisa;
  Result :=
    FNCPesquisa(
      vptBtnCadastro,
      vpsNomePesquisa,
      vpsNomeCampoInicioPesquisa,
      vpsNomeCampoRetornoPesquisa,
      vpsNomeAlias,
      vpsNomeTabela,
      vpsNomeCampoChave1,
      vpsNomeCampoChave2,
      vpsNomeCampoChave3,
      vpsNomeCampoChave4,
      vpsNomeCampoChave5,
      vpsWhere,
      vpsNomeCampoRetornoPesquisa2ComResult);
end;

function FNCPesquisa(
  vptBtnCadastro: TObject;
  vpsNomePesquisa,
  vpsNomeCampoInicioPesquisa,
  vpsNomeCampoRetornoPesquisa,
  vpsNomeAlias,
  vpsNomeTabela,
  vpsNomeCampoChave1,
  vpsNomeCampoChave2,
  vpsNomeCampoChave3,
  vpsNomeCampoChave4,
  vpsNomeCampoChave5,
  vpsWhere: String;
  var vpsNomeCampoRetornoPesquisa2ComResult: String): String;
begin
  Result := '';
  FrmSPesquisa := TFrmSPesquisa.Create(Application);
  with FrmSPesquisa do
  begin
    FSqlAtivo := False;
    FBtnCadastro := vptBtnCadastro;
    FNomePesquisa := vpsNomePesquisa;
    FNomeCampoInicioPesquisa := NomeCampo(vpsNomeCampoInicioPesquisa);
    FNomeCampoRetornoPesquisa := NomeCampo(vpsNomeCampoRetornoPesquisa);
    FChaveInvisivel := 'ChaveInvisivel';
    FNomeAlias := vpsNomeAlias;
    FNomeTabela := vpsNomeTabela;
    FNomeCampoChave1 := NomeCampo(vpsNomeCampoChave1);
    FAliasCampoChave1 := NomeAlias(vpsNomeCampoChave1);
    FNomeCampoChave2 := NomeCampo(vpsNomeCampoChave2);
    FAliasCampoChave2 := NomeAlias(vpsNomeCampoChave2);
    FNomeCampoChave3 := NomeCampo(vpsNomeCampoChave3);
    FAliasCampoChave3 := NomeAlias(vpsNomeCampoChave3);
    FNomeCampoChave4 := NomeCampo(vpsNomeCampoChave4);
    FAliasCampoChave4 := NomeAlias(vpsNomeCampoChave4);
    FNomeCampoChave5 := NomeCampo(vpsNomeCampoChave5);
    FAliasCampoChave5 := NomeAlias(vpsNomeCampoChave5);
    FWhere := vpsWhere;
    FNomeCampoRetornoPesquisa2ComResult :=
      NomeCampo(vpsNomeCampoRetornoPesquisa2ComResult);
    FChaveInvisivel2 := 'ChaveInvisivel2';
    if ShowModal = mrOK then
    begin
      Result := AUXResultadoPesquisa;
      vpsNomeCampoRetornoPesquisa2ComResult := AUXResultadoPesquisa2;
    end
  end;
end;

procedure TFrmSPesquisa.FormShow(Sender: TObject);
begin
  BtnCadastro.Visible := not (FBtnCadastro = nil);
  BtnCadastro.hint := 'Abrir ' + FNomePesquisa;

  QryPesquisa.DatabaseName := FNomeAlias;

  RdbPesquisaChave1.Checked := UpperCase(FNomeCampoInicioPesquisa) = UpperCase(FNomeCampoChave1);
  RdbPesquisaChave2.Checked := UpperCase(FNomeCampoInicioPesquisa) = UpperCase(FNomeCampoChave2);
  RdbPesquisaChave3.Checked := UpperCase(FNomeCampoInicioPesquisa) = UpperCase(FNomeCampoChave3);
  RdbPesquisaChave4.Checked := UpperCase(FNomeCampoInicioPesquisa) = UpperCase(FNomeCampoChave4);
  RdbPesquisaChave5.Checked := UpperCase(FNomeCampoInicioPesquisa) = UpperCase(FNomeCampoChave5);

  RdbPesquisaChave3.Visible := FNomeCampoChave3 > '';
  RdbPesquisaChave4.Visible := FNomeCampoChave4 > '';
  RdbPesquisaChave5.Visible := FNomeCampoChave5 > '';

  RdbPesquisaChave1.Caption := DelChar(FAliasCampoChave1, '"');
  RdbPesquisaChave2.Caption := DelChar(FAliasCampoChave2, '"');
  RdbPesquisaChave3.Caption := DelChar(FAliasCampoChave3, '"');
  RdbPesquisaChave4.Caption := DelChar(FAliasCampoChave4, '"');
  RdbPesquisaChave5.Caption := DelChar(FAliasCampoChave5, '"');

  RdbPesquisaChave1.Width :=
    RedimencionaCampo(RdbPesquisaChave1, RdbPesquisaChave1.Caption);
  RdbPesquisaChave2.Width :=
    RedimencionaCampo(RdbPesquisaChave1, RdbPesquisaChave2.Caption);
  RdbPesquisaChave3.Width :=
    RedimencionaCampo(RdbPesquisaChave1, RdbPesquisaChave3.Caption);
  RdbPesquisaChave4.Width :=
    RedimencionaCampo(RdbPesquisaChave1, RdbPesquisaChave4.Caption);
  RdbPesquisaChave5.Width :=
    RedimencionaCampo(RdbPesquisaChave1, RdbPesquisaChave5.Caption);

  EdtProcuraChange(nil);
end;

procedure TFrmSPesquisa.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
  FrmSPesquisa := Nil;
end;

procedure TFrmSPesquisa.EdtProcuraChange(Sender: TObject);
var
  vlsNomeCampoChave,
  vlsAliasCampoChave,
  vls1: String;
  vli1: Integer;
begin
  try
    vls1 := EdtProcura.Text;
    vli1 := Length(vls1);

    RdbPesquisaChave1.Font.Color := clBlack;
    RdbPesquisaChave2.Font.Color := clBlack;
    RdbPesquisaChave3.Font.Color := clBlack;
    RdbPesquisaChave4.Font.Color := clBlack;
    RdbPesquisaChave5.Font.Color := clBlack;
    if RdbPesquisaChave1.Checked then
    begin
      vlsNomeCampoChave := FNomeCampoChave1;
      vlsAliasCampoChave := FAliasCampoChave1;
      RdbPesquisaChave1.Font.Color := clRed;
    end
    else
      if RdbPesquisaChave2.Checked then
      begin
        vlsNomeCampoChave := FNomeCampoChave2;
        vlsAliasCampoChave := FAliasCampoChave2;
        RdbPesquisaChave2.Font.Color := clRed;
      end
      else
        if RdbPesquisaChave3.Checked then
        begin
          vlsNomeCampoChave := FNomeCampoChave3;
          vlsAliasCampoChave := FAliasCampoChave3;
          RdbPesquisaChave3.Font.Color := clRed;
        end
        else
          if RdbPesquisaChave4.Checked then
          begin
            vlsNomeCampoChave := FNomeCampoChave4;
            vlsAliasCampoChave := FAliasCampoChave4;
            RdbPesquisaChave4.Font.Color := clRed;
          end
          else
          begin
            vlsNomeCampoChave := FNomeCampoChave5;
            vlsAliasCampoChave := FAliasCampoChave5;
            RdbPesquisaChave5.Font.Color := clRed;
          end;

    FSqlAtivo := True;
    with QryPesquisa do
    begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT ');
      SQL.Add('  ' + FNomeCampoChave1 + ' AS ' + FAliasCampoChave1);
      SQL.Add(', ' + FNomeCampoChave2 + ' AS ' + FAliasCampoChave2);
      if FNomeCampoChave3 > '' then
        SQL.Add(', ' + FNomeCampoChave3 + ' AS ' + FAliasCampoChave3);
      if FNomeCampoChave4 > '' then
        SQL.Add(', ' + FNomeCampoChave4 + ' AS ' + FAliasCampoChave4);
      if FNomeCampoChave5 > '' then
        SQL.Add(', ' + FNomeCampoChave5 + ' AS ' + FAliasCampoChave5);
      SQL.Add(', ' + FNomeCampoRetornoPesquisa + ' AS ' + FChaveInvisivel);
      SQL.Add(', ' + FNomeCampoRetornoPesquisa2ComResult + ' AS ' + FChaveInvisivel2);
      SQL.Add('FROM ' + FNomeTabela);
      if vli1 > 0 then
      begin
        SQL.Add('WHERE Upper(');
        case rgLocalDaConsulta.ItemIndex of
          0: SQL.Add(vlsNomeCampoChave + ') LIKE Upper(''' + Copy(vls1, 1, vli1) + '%'') ');
          1: SQL.Add(vlsNomeCampoChave + ') LIKE Upper(''%' + Copy(vls1, 1, vli1) + '%'') ');
          2: SQL.Add(vlsNomeCampoChave + ') LIKE Upper(''%' + Copy(vls1, 1, vli1) + ''') ');
        end;
        if Length({Trim(}FWhere{)}) > 0 then
          SQL.Add('AND ' + FWhere);
      end
      else
        if Length({Trim(}FWhere{)}) > 0 then
          SQL.Add('Where ' + FWhere);
      SQL.Add('ORDER BY ' + vlsNomeCampoChave);
      if RgOrdenacao.ItemIndex = 1 then
        SQL.Add(' Desc ');
      Open;
    end;

    QryPesquisa.FieldByName(FChaveInvisivel).Visible := False;
    QryPesquisa.FieldByName(FChaveInvisivel2).Visible := False;
    DbgDtsQryPesquisa.Fields[0].DisplayWidth := 8;
    if (FNomeCampoChave3 = '')
    and (fNomeCampoChave4 = '')
    and (fNomeCampoChave5 = '') then
    begin
      DbgDtsQryPesquisa.Fields[1].DisplayWidth := 90;
    end;
    if (FNomeCampoChave3 > '')
    and (fNomeCampoChave4 = '')
    and (fNomeCampoChave5 = '') then
    begin
      DbgDtsQryPesquisa.Fields[1].DisplayWidth := 60;
      DbgDtsQryPesquisa.Fields[2].DisplayWidth := 30;
    end;
    if (FNomeCampoChave3 > '')
    and (fNomeCampoChave4 > '')
    and (fNomeCampoChave5 = '') then
    begin
      DbgDtsQryPesquisa.Fields[1].DisplayWidth := 30;
      DbgDtsQryPesquisa.Fields[2].DisplayWidth := 30;
      DbgDtsQryPesquisa.Fields[3].DisplayWidth := 30;
    end;
    if (FNomeCampoChave3 > '')
    and (fNomeCampoChave4 > '')
    and (fNomeCampoChave5 > '') then
    begin
      DbgDtsQryPesquisa.Fields[1].DisplayWidth := 30;
      DbgDtsQryPesquisa.Fields[2].DisplayWidth := 20;
      DbgDtsQryPesquisa.Fields[3].DisplayWidth := 20;
      DbgDtsQryPesquisa.Fields[4].DisplayWidth := 20;
    end;

    // formata campo decimal
    if (Pos('VLR', UpperCase(FNomeCampoChave2)) > 0) then
      TFloatField(QryPesquisa.Fields[1]).DisplayFormat := '#,##0.00';
    if (Pos('VLR', UpperCase(FNomeCampoChave3)) > 0) then
      TFloatField(QryPesquisa.Fields[2]).DisplayFormat := '#,##0.00';
    if (Pos('VLR', UpperCase(FNomeCampoChave4)) > 0) then
      TFloatField(QryPesquisa.Fields[3]).DisplayFormat := '#,##0.00';
    if (Pos('VLR', UpperCase(FNomeCampoChave5)) > 0) then
      TFloatField(QryPesquisa.Fields[4]).DisplayFormat := '#,##0.00';

    Caption :=
      'Pesquisa ' + LowerCase(FNomePesquisa) + ' - ' +
      'Quantidade de registros [' + IntToStr(QryPesquisa.RecordCount) + ']';
    FSqlAtivo := False;
  except
    on E: Exception do
      raise Exception.Create(
        'Erro ao criar a pesquisa dinamica! ' + #13 + #13 +
        '[' + E.Message + '] ' + #13 + #13 +
        'Sql [' + #13 + QryPesquisa.SQL.Text + '] ');
  end;
end;

function TFrmSPesquisa.NomeAlias(vpsNomeCompleto: String): String;
var
  vli1: Integer;
  vls1: String;
begin
  Result := '';
  if vpsNomeCompleto = '' then
    Exit;
  vls1 := '';
  for vli1 := Length(vpsNomeCompleto) DownTo 0 do
    if not (UpperCase(Copy(vpsNomeCompleto, vli1 - 3, 4)) = ' AS ') then
      vls1 := Copy(vpsNomeCompleto, vli1, 1) + vls1
    else
      Break;
  Result := vls1;
end;

function TFrmSPesquisa.NomeCampo(vpsNomeCompleto: String): String;
var
  vli1,
  vli2: Integer;
  vls1: String;
begin
  Result := '';
  if vpsNomeCompleto = '' then
    Exit;
  vls1 := '';
  for vli1 := Length(vpsNomeCompleto) - 1 DownTo 1 do
    if (UpperCase(Copy(vpsNomeCompleto, vli1 - 3, 4)) = ' AS ') then
    begin
      for vli2 := vli1 - 4 DownTo 1 do
        vls1 := Copy(vpsNomeCompleto, vli2, 1) + vls1;
      Break;
    end;
  Result := Trim(vls1);
end;

procedure TFrmSPesquisa.DbgDtsQryPesquisaDblClick(Sender: TObject);
begin
  BtnOk.Click;
end;

procedure TFrmSPesquisa.DbgDtsQryPesquisaKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if ((Shift = [ssCtrl])
  and (Key = VK_Return)) then
    DbgDtsQryPesquisaDblClick(nil)
  else
    if Key = 40 then
      DbgDtsQryPesquisa.SetFocus;
end;

procedure TFrmSPesquisa.BtnCadastroClick(Sender: TObject);
begin
  if EdtProcura.CanFocus then // Colocado antes do click para funcionar o show do cadastro
    EdtProcura.SetFocus;
  TBitBtn(FBtnCadastro).Click;
end;

procedure TFrmSPesquisa.RdbPesquisaChave1Click(Sender: TObject);
begin
  if not FSqlAtivo then
  begin
    EdtProcura.Text := '';
    RdbPesquisaChave1.Checked := Sender = RdbPesquisaChave1;
    RdbPesquisaChave2.Checked := Sender = RdbPesquisaChave2;
    RdbPesquisaChave3.Checked := Sender = RdbPesquisaChave3;
    RdbPesquisaChave4.Checked := Sender = RdbPesquisaChave4;
    RdbPesquisaChave5.Checked := Sender = RdbPesquisaChave5;
    EdtProcuraChange(nil);
  end;
  if EdtProcura.CanFocus then
    EdtProcura.SetFocus;
end;

procedure TFrmSPesquisa.BtnOkClick(Sender: TObject);
begin
  AUXResultadoPesquisa := QryPesquisa.FieldByName(FChaveInvisivel).AsString;
  AUXResultadoPesquisa2 := QryPesquisa.FieldByName(FChaveInvisivel2).AsString;
end;

procedure TFrmSPesquisa.FormActivate(Sender: TObject);
begin
  EdtProcuraChange(nil);
end;

procedure TFrmSPesquisa.EdtProcuraKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 40 then // 40=seta para baixo
    if DbgDtsQryPesquisa.CanFocus then
      DbgDtsQryPesquisa.SetFocus;
end;

end.
