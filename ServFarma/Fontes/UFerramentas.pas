unit UFerramentas;

interface

uses
  Forms, SysUtils, Classes, StdCtrls, Dialogs, Windows, Registry, FileCtrl,
  Math, ShellApi;

procedure CriaScrollBar(vptForm: TForm);
procedure ValidaCGC(vpsCgc: String);
procedure ValidaCPF(vpsCpf: String);
function RedimencionaCampo(vptCampo: TComponent; vpsConteudo: String): Integer;
function DelChar(vpsPalavra: String; vpsDelChar: String): String;
function DoubleExtenso(Numero: Double; Moeda: String): String;
function RealStr(Numero: Double; Decimais: Byte): String;
function IfThen(AValue: Boolean; const ATrue: String; AFalse: String = ''): String; overload;
function IfThen(AValue: Boolean; const ATrue: Integer; const AFalse: Integer = 0): Integer; overload;
function IfThen(AValue: Boolean; const ATrue: Int64; const AFalse: Int64 = 0): Int64; overload;
function IfThen(AValue: Boolean; const ATrue: Double; const AFalse: Double = 0.0): Double; overload;
function StrToValor(vpsValor: String): Extended;
function RoundFloat(vpeVlr: Extended; vpiPrecision: Integer = 2): Extended;
function TruncFloat(vpeVlr: Extended; vpiPrecision: Integer = 2): Extended;
function RoundUpFloat(vpeVlr: Extended; vpiPrecision: Integer = 2): Extended;
function DataIni(vptDataIni: TDateTime): TDateTime;
function DataFin(vptDataFin: TDateTime): TDateTime;
function LogTxt(vpsTexto: String; vpsNomeArq: String = 'LogTxt'): String;
procedure AbreArqTxt(vpsNomeArq: String);
procedure ExecAppWin(vpsNomeProg: String; vpsParametro: String = '');
function Criptografa(const vpsPalavra: String): String;
function Descriptografa(const vpsPalavra: String): String;
function VersaoExe(vpsArqExe: String): String;
function VersaoDoWindows: Integer;
function EhWindows64: Boolean;
function Barra(vpsPasta: String; vpbInclui: Boolean = True): String;
procedure GeraArqTxt(vpsDirArq, vpsNomArq, vpsExtArq, vpsConteudo: String);
function ExecutaProgramaEEspera(vpsPrograma: String): Boolean;
procedure ExecutaPrograma(vpsPrograma: String);
procedure DeletaPrograma(vpsPrograma: String);
procedure CriaCompatibilidadeWin64NoWin32(vpsPrograma: String);
procedure CriaODBCFireBird(vpsAliasDB, vpsPastaDB, vpsNomeDB: String);
function NomeProgramaSemExt(vpsPrograma: String): String;
function SistemaAAADriveCorrente: String;
function DeletaCharAlfanumerico(vpsTexto: String; vpsExcecao: String = ''): String;
function ContemNumeros(vpsTexto: String): Boolean;

implementation

procedure CriaScrollBar(vptForm: TForm);
begin
  vptForm.HorzScrollBar.Visible := True;
  vptForm.VertScrollBar.Visible := True;
  vptForm.HorzScrollBar.Tracking := True;
  vptForm.VertScrollBar.Tracking := True;
  vptForm.HorzScrollBar.Range := vptForm.ClientWidth;
  vptForm.VertScrollBar.Range := vptForm.ClientHeight;
end;

procedure ValidaCGC(vpsCgc: String);
var
  i,
  Digito1,
  Digito2,
  Operador1,
  Operador2: Byte;
  Acumulado: Integer;
const
  Multiplicador: Array[1..13] of byte = (6,5,4,3,2,9,8,7,6,5,4,3,2);
begin
  if Length(vpsCgc) <> 14 then
  begin
    if Length(vpsCgc) < 14 then
      raise Exception.Create(
        'C.G.C. está incompleto')
    else
      raise Exception.Create(
        'Numero do C.G.C. muito grande');
  end
  else
  begin
    // calcula o primeiro digito
    Acumulado := 0;
    for i := 2 to 13 do
      Acumulado := Acumulado + (Multiplicador[i] * StrToInt(vpsCgc[i-1]));
    Operador1 := Acumulado mod 11;

    if (Operador1 = 0) or (Operador1 = 1) then
      Digito1 := 0
    else
      Digito1 := 11-Operador1;

    // calcula o segundo digito
    Acumulado := 0;
    for i := 1 to 12 do
      Acumulado := Acumulado+(Multiplicador[i] * StrToInt(vpsCgc[i]));
    Acumulado := Acumulado + (Multiplicador[13] * Digito1);
    Operador2 := Acumulado mod 11;

    if (Operador2 = 0) or (Operador2 = 1) then
      Digito2 := 0
    else
      Digito2 := 11-Operador2;
    if (Digito1 = StrToInt(vpsCgc[13]))
    and (Digito2 = StrToInt(vpsCgc[14])) then
    begin
    end
    else
    begin
      raise Exception.Create(
        'Número do C.G.C. está incorreto');
    end;
  end;
end;

procedure ValidaCPF(vpsCpf: String);
var
  acum,
  i,
  dig1,
  dig2: Integer;
begin
  if Length(vpsCpf) <> 11 then
  begin
    if Length(vpsCpf) < 11 then
      raise Exception.Create(
        'C.P.F. está incompleto')
    else
      raise Exception.Create(
         'Numero do C.P.F. muito grande');
  end
  else
  begin
    acum := 0;
    // Calcula o primeiro digito
    for i := 10 downto 2 do
      acum := acum + StrToInt(vpsCpf[11-i]) * i;
    dig1 := 11-(acum mod 11);
    if dig1 > 9 then
      dig1 := 0;
    if dig1 <> StrToInt(vpsCpf[10]) then
    begin
      raise Exception.Create(
        'Número do C.P.F. está incorreto');
    end
    else
    // Calcula o segundo digito
    begin
      acum := 0;
      for i := 9 downto 2 do
        acum := acum + StrToInt(vpsCpf[11-i]) * (i+1);
      acum := acum + dig1 * 2;
      dig2 := 11-(acum mod 11);
      if dig2 > 9 then
        dig2 := 0;
      if dig2 <> StrToInt(vpsCpf[11]) then
      begin
        raise Exception.Create(
          'Número do C.P.F. está incorreto');
      end;
    end;
  end;
end;

function RedimencionaCampo(
  vptCampo: TComponent;
  vpsConteudo: String): Integer;
var
  vltCampoRedimencionado: TLabel;
begin
  vltCampoRedimencionado := TLabel.Create(nil);
  vltCampoRedimencionado.AutoSize := True;
  vltCampoRedimencionado.Font.Size := TLabel(vptCampo).Font.Size;
  vltCampoRedimencionado.Font.Style := TLabel(vptCampo).Font.Style;
  vltCampoRedimencionado.Font.Color := TLabel(vptCampo).Font.Color;
  vltCampoRedimencionado.Font.Pitch := TLabel(vptCampo).Font.Pitch;
  vltCampoRedimencionado.Font.PixelsPerInch :=
    TLabel(vptCampo).Font.PixelsPerInch;
  vltCampoRedimencionado.Caption := vpsConteudo;
  Result := vltCampoRedimencionado.Width + 20;
  vltCampoRedimencionado.Free;
end;

function DelChar(vpsPalavra: String; vpsDelChar: String): String;
var
  vli1: byte;
begin
  Result := '';
  for vli1 := 1 to Length(vpsPalavra) do
    if vpsPalavra[vli1] <> vpsDelChar then
      Result := Result + vpsPalavra[vli1];
end;

function DoubleExtenso(Numero: Double; Moeda: String): String;
const
  UNIDADE: array['0'..'9'] of String[10] =
    ('', ' HUM', ' DOIS', ' TREIS', ' QUATRO', ' CINCO', ' SEIS', ' SETE', ' OITO', ' NOVE');
  DEZENA: array['0'..'9'] of String[10] =
    ('', ' DEZ', ' VINTE', ' TRINTA', ' QUARENTA', ' CINQUENTA', ' SESSENTA', ' SETENTA', ' OITENTA', ' NOVENTA');
  DEZ_A_VINTE: array['0'..'9'] of String[10]=
    (' DEZ', ' ONZE', ' DOZE', ' TREZE', ' QUATORZE', ' QUINZE', ' DEZESSEIS', ' DEZESSETE', ' DEZOITO', ' DEZENOVE');
  CENTENA: array['0'..'9'] of string[13] =
    ('',' CENTO', ' DUZENTOS', ' TREZENTOS', ' QUATROCENTOS', ' QUINHENTOS', ' SEISCENTOS', ' SETECENTOS', ' OITOCENTOS', ' NOVECENTOS');
  CEM: array[0..3] of String = ('',' CEM',' CENTO',' CENTO');
  MIL: array[0..1] of String = ('',' MIL');
  MILHAO: array[0..2] of String =
    ('', ' MILHAO', ' MILHOES');
  BILHAO: array[0..2] of String =
    ('', ' BILHAO', ' BILHOES');
  TRILHAO: array[0..2] of String =
    ('', ' TRiLHAO', ' TRILHOES');
  LIGACAO: array[0..2] of String =
    ('', ' E',' DE');
  CENTAVO: array[0..1] of String =
    ('', ' CENTAVOS');
  WNumeroExtenso: String = '';
var
  Centavos,
  S: String;
  C: integer;
begin
  DoubleExtenso := '';

  if Numero = 0 then
    Exit;

  S := RealStr(Numero, 2);
  C := Pos('.', S);
  Centavos := Copy(S, C + 1, 2);

  while Length(Centavos) < 2 do
    Centavos := Centavos + '0';

  Delete(S, c, 3);

  while length(S) < 13 do
    S := '0' + S;

  WNumeroExtenso := Unidade[S[1]];
  WNumeroExtenso :=
    WNumeroExtenso +
    Trilhao[ord(S[1] = '1') + 2 * ord(S[1] > '1')] +
    Ligacao[Ord(S[2] <> '0')];

  if S[2] + S[3] + S[4] = '100' then
    WNumeroExtenso := WNumeroExtenso + ' CEM'
  else
    WNumeroExtenso := WNumeroExtenso + Centena[S[2]];

  WNumeroExtenso := WNumeroExtenso + Ligacao[Ord(S[3] <> '0')];

  if S[3] = '1' then
    WNumeroExtenso := WNumeroExtenso + DEZ_A_VINTE[S[4]]
  else
  begin
    WNumeroExtenso :=
      WNumeroExtenso + Dezena[S[3]] +
      Ligacao[Ord(S[4] <> '0')] + Unidade[S[4]];
  end;

  WNumeroExtenso :=
    WNumeroExtenso +
    Bilhao[Ord(S[2] + S[3] + S[4] = '001') +
    2 * Ord(S[2] + S[3] + S[4] > '001')] +
    Ligacao[Ord(S[5] <> '0')];

  if S[5] + S[6] + S[7] = '100' then
    WNumeroExtenso := WNumeroExtenso + ' CEM'
  else
    WNumeroExtenso := WNumeroExtenso + Centena[S[5]];

  WNumeroExtenso := WNumeroExtenso + Ligacao[Ord(S[6] <> '0')];

  if S[6] = '1' then
    WNumeroExtenso := WNumeroExtenso + DEZ_A_VINTE[S[7]]
  else
  begin
    WNumeroExtenso :=
      WNumeroExtenso + Dezena[S[6]] +
      Ligacao[Ord(S[7] <> '0')] + Unidade[S[7]];
  end;

  WNumeroExtenso :=
    WNumeroExtenso +
    Milhao[Ord(S[5] + S[6] + S[7] = '001') +
    2 * Ord(S[5] + S[6] + S[7] > '001')] +
    Ligacao[Ord(S[8] <> '0')];

  if S[8] + S[9] + S[10] = '100' then
    WNumeroExtenso := WNumeroExtenso + ' CEM'
  else
    WNumeroExtenso := WNumeroExtenso + Centena[S[8]];

  WNumeroExtenso := WNumeroExtenso + Ligacao[Ord(S[9] <> '0')];

  if S[9] = '1' then
    WNumeroExtenso := WNumeroExtenso + DEZ_A_VINTE[S[10]]
  else
  begin
    WNumeroExtenso := WNumeroExtenso + Dezena[S[9]] +
    Ligacao[Ord(S[10] <> '0')] + Unidade[S[10]];
  end;

  WNumeroExtenso :=
    WNumeroExtenso +
    Mil[Ord(S[8] + S[9] + S[10] > '000')]+
    Ligacao[Ord(S[11] <> '0')];

  if S[11] + S[12] + S[13] = '100' then
    WNumeroExtenso := WNumeroExtenso + ' CEM'
  else
    WNumeroExtenso := WNumeroExtenso + Centena[S[11]];

  WNumeroExtenso := WNumeroExtenso + Ligacao[Ord(S[12] <> '0')];

  if S[12] = '1' then
    WNumeroExtenso := WNumeroExtenso + DEZ_A_VINTE[S[13]]
  else
  begin
    WNumeroExtenso := WNumeroExtenso + Dezena[S[12]] +
    Ligacao[Ord(S[13] <> '0')] + Unidade[S[13]];
  end;

  WNumeroExtenso :=
    WNumeroExtenso + Ligacao[ 2 * Ord(Copy(S, 8, 6) = '000000')] +
    ' ' + Moeda + Ligacao[ord(Centavos[1] <> '0')];

  if Centavos[1] = '1' then
    WNumeroExtenso :=
      WNumeroExtenso + DEZ_A_VINTE[Centavos[2]] + ' CENTAVOS'
  else
    WNumeroExtenso :=
      WNumeroExtenso + Dezena[Centavos[1]] +
      Ligacao[Ord(Centavos[2] <> '0')] + Unidade[Centavos[2]] +
      Centavo[Ord(Centavos[1] + Centavos[2] <> '00')];

  if WNumeroExtenso[2] = 'E' then
    Delete(WNumeroExtenso, 1, 3);

  if Numero < 1 then
    Delete(WNumeroExtenso, 1, Pos(' E ',WNumeroExtenso) + 2);

  DoubleExtenso := WNumeroExtenso;
end;

function RealStr(Numero: Double; Decimais: Byte): String;
var
  S: String;
begin
  Str(Numero: 40: Decimais, S);
  RealStr := Trim(S);
end;

function IfThen(AValue: Boolean; const ATrue: String;
  AFalse: String = ''): String;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

function IfThen(AValue: Boolean; const ATrue: Integer; const AFalse: Integer): Integer;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

function IfThen(AValue: Boolean; const ATrue: Int64; const AFalse: Int64): Int64;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

function IfThen(AValue: Boolean; const ATrue: Double; const AFalse: Double): Double;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

function StrToValor(vpsValor: String): Extended;
var
  vli1: Integer;
  vlsValor,
  vlsResult: String;
begin
  vlsValor := Trim(vpsValor);

  if vlsValor = '' then
  begin
    Result := 0.0;
    Exit;
  end;

  vlsResult := '';
  for vli1 := 1 to Length(vlsValor) do
    if ((Copy(vlsValor, vli1, 1) >= '0')
    and (Copy(vlsValor, vli1, 1) <= '9'))
    or (Copy(vlsValor, vli1, 1) = ',') then
      vlsResult := vlsResult + Copy(vlsValor, vli1, 1);

  Result := StrToFloat(vlsResult);
end;

function RoundFloat(vpeVlr: Extended; vpiPrecision: Integer = 2): Extended;
var
  vliInteiro: Int64;
  vleDecimal,
  vleExp: Extended;
begin
  try
    vliInteiro := Trunc(vpeVlr);
    vleDecimal := vpeVlr - vliInteiro;
    vleExp := Power(10, vpiPrecision);
    Result := Round(vleDecimal * vleExp) / vleExp;
    Result := vliInteiro + Result;
  except
    on E: Exception do
      raise Exception.Create('Resultado [' + E.message + '] muito grande!!!');
  end;
end;

function TruncFloat(vpeVlr: Extended; vpiPrecision: Integer = 2): Extended;
var
  vlsPrecisao: String;
  vli1,
  vliPrecisao,
  vliInteiro: Integer;
  vle1,
  vleResult: Extended;
begin
  vlsPrecisao := '1';
  for vli1 := 1 to vpiPrecision do
    vlsPrecisao := vlsPrecisao + '0';
  vliPrecisao := StrToInt(vlsPrecisao);
  vle1 := vpeVlr * vliPrecisao;
  vliInteiro := Trunc(vle1);
  vleResult := vliInteiro / vliPrecisao;
  Result := vleResult;
end;

function RoundUpFloat(vpeVlr: Extended; vpiPrecision: Integer = 2): Extended;
var
  vliInteiro: Int64;
  vleDecimal,
  vleExp: Extended;
begin
  try
    vliInteiro := Trunc(vpeVlr);
    vleDecimal := vpeVlr - vliInteiro;
    vleExp := Power(10, vpiPrecision);
    Result := (Trunc((vleDecimal * vleExp)) + 1) / vleExp;
    Result := vliInteiro + Result;
  except
    on E:Exception do
    begin
      raise Exception.Create('Resultado [' + E.message + '] muito grande!!!');
    end;
  end;
end;

function DataIni(vptDataIni: TDateTime): TDateTime;
begin
  Result :=
    StrToDateTime(FormatDateTime('dd/mm/yyyy', vptDataIni) + ' 00:00:00.0000');
end;

function DataFin(vptDataFin: TDateTime): TDateTime;
begin
  Result :=
    StrToDateTime(FormatDateTime('dd/mm/yyyy', vptDataFin) + ' 23:59:59.9999');
end;

function LogTxt(vpsTexto: String; vpsNomeArq: String = 'LogTxt'): String;
var
  vltLista: TStringList;
  vlsNomeArq: String;
  vliSeq: Integer;

//------------------------------------------------------------------------------
  procedure MontaNomeArq;
  var
    vlsNomeExe: String;
  begin
    vlsNomeExe := NomeProgramaSemExt(Application.ExeName);
    vlsNomeArq :=
      ExtractFilePath(Application.ExeName) +
      vlsNomeExe + '_' +
      vpsNomeArq + '_' +
      FormatDateTime('yyyymmdd"_"hhmmss"_"zzz', Now) +
      '(' + FormatFloat('000', vliSeq) + ').txt'
  end;

//------------------------------------------------------------------------------
//function LogTxt(vpsTexto: String; vpsNomeArq: String = 'LogTxt'): String;
//------------------------------------------------------------------------------
begin
  vltLista := TStringList.Create;
  vltLista.Add(vpsTexto);
  vliSeq := 0;
  repeat
    Inc(vliSeq);
    MontaNomeArq;
  until not FileExists(vlsNomeArq);
  vltLista.SaveToFile(vlsNomeArq);
  vltLista.Free;
  Result := vlsNomeArq;
end;

procedure AbreArqTxt(vpsNomeArq: String);
begin
  ExecAppWin('\NotePad.exe', vpsNomeArq);
end;

procedure ExecAppWin(vpsNomeProg: String; vpsParametro: String = '');
var
  vltReg: TRegistry;
  vlsPastaPadraoWindows,
  vlsPrograma: String;
  vltLista: TStringList;
  vli1: Integer;
begin
  vlsPrograma := '';

  vlsPastaPadraoWindows := SistemaAAADriveCorrente + '\windows' + vpsNomeProg;
  if FileExists(vlsPastaPadraoWindows) then
    vlsPrograma := vlsPastaPadraoWindows;

  if not (Trim(vlsPrograma) > '') then
  begin
    vlsPastaPadraoWindows := SistemaAAADriveCorrente + 'windows\system32' + vpsNomeProg;
    if FileExists(vlsPastaPadraoWindows) then
      vlsPrograma := vlsPastaPadraoWindows;
  end;

  if not (Trim(vlsPrograma) > '') then
  begin
    vlsPastaPadraoWindows := SistemaAAADriveCorrente + 'windows\SysWOW64' + vpsNomeProg;
    if FileExists(vlsPastaPadraoWindows) then
      vlsPrograma := vlsPastaPadraoWindows;
  end;

  if not (Trim(vlsPrograma) > '') then
  begin
    vltReg := TRegistry.Create;
    vltLista := TStringList.Create;
    try
      vltReg.RootKey := HKEY_CURRENT_USER;
      vltReg.OpenKey('\Software\Microsoft\Windows\ShellNoRoam\MUICache', True);
      vltReg.GetValueNames(vltLista);
      for vli1 := 0 to vltLista.Count - 1 do
        if (Pos(UpperCase(vpsNomeProg), UpperCase(vltLista.Strings[vli1])) > 0)
        and (Copy(UpperCase(vltLista.Strings[vli1]), 1, 3) = Barra(SistemaAAADriveCorrente)) then
        begin
          vlsPrograma := vltLista.Strings[vli1];
          Break;
        end;
      vltReg.CloseKey;
    finally
      vltReg.Free;
      vltLista.Free;
    end;
  end;

  if not FileExists(vlsPrograma) then
  begin
    MessageDlg(
      'Aplicativo [' + vlsPrograma + '] Inexistente!',
      mtWarning, [mbOk], 0);
    Exit;
  end;

  if Trim(vpsParametro) > '' then
    vlsPrograma := vlsPrograma + ' ' + vpsParametro;

  WinExec(PChar(vlsPrograma), SW_Normal);
end;

function Criptografa(const vpsPalavra: String): String;
var
  vli1,
  Letra,
  vliTamanho,
  vliPosicao: Integer;
  vlsSubPalavra: String;
begin
  Result := '';
  vliTamanho := Length(vpsPalavra);
  if vliTamanho > 14 then
  begin
    vlsSubPalavra := '';
    for vliPosicao := 1 to vliTamanho do
    begin
      vlsSubPalavra := vlsSubPalavra + vpsPalavra[vliPosicao];
      if Length(vlsSubPalavra) = 14 then
      begin
        Result := Result + Criptografa(vlsSubPalavra);
        vlsSubPalavra := '';
      end;
    end;
    if Length(vlsSubPalavra) > 0 then
    begin
      Result := Result + Criptografa(vlsSubPalavra);
    end;
  end
  else
  begin
    for vliPosicao := 1 to vliTamanho do
    begin
      Letra := ord(vpsPalavra[vliPosicao]);
      vli1 := Letra - 33 + SQR(vliPosicao);
      if (vli1 > 224) then
        vli1 := vli1 - 224;
      vli1 := vli1 + 33;
      Result := Result + CHR(vli1);
    end;
  end;
end;

function Descriptografa(const vpsPalavra: String): String;
var
  vli1,
  vliLetra,
  vliTamanho,
  vliPosicao: Integer;
  vlsSubPalavra: String;
begin
  Result := '';
  vliTamanho := Length(vpsPalavra);
  if vliTamanho > 14 then
  begin
    vlsSubPalavra := '';
    for vliPosicao := 1 to vliTamanho do
    begin
      vlsSubPalavra := vlsSubPalavra + vpsPalavra[vliPosicao];
      if Length(vlsSubPalavra) = 14 then
      begin
        Result := Result + Descriptografa(vlsSubPalavra);
        vlsSubPalavra := '';
      end;
    end;
    if Length(vlsSubPalavra) > 0 then
    begin
      Result := Result + Descriptografa(vlsSubPalavra);
    end;
  end
  else
  begin
    for vliPosicao := 1 to vliTamanho do
    begin
      vli1 := ord(vpsPalavra[vliPosicao]);
      vliLetra := vli1 - 33 - SQR(vliPosicao);
      if  (vliLetra < 0) then
        vliLetra := 224 + vliLetra;
      vliLetra := vliLetra + 33;
      Result := Result + CHR(vliLetra);
    end;
  end;
end;

function VersaoExe(vpsArqExe: String): String;
var
  // seta ponteiros e buffers utilizados para recolher a versão da package
  vldWnd,
  vldVerInfoSize,
  vldVerValueSize: DWORD;
  vlpVerInfo: Pointer;
  vlpVerValue: PVSFixedFileInfo;
  vlsVersao: String;
begin
  vlsVersao := '0.0.0.0';
  vldVerInfoSize := GetFileVersionInfoSize(PChar(vpsArqExe), vldWnd);
  if vldVerInfoSize <> 0 then
  begin
    // recolhe valor do ponteiro
    GetMem(vlpVerInfo, vldVerInfoSize);
    try
      // recolhe informacoes do sistema no ponteiro vlpVerInfo
      if GetFileVersionInfo(
        PChar(vpsArqExe), vldWnd, vldVerInfoSize, vlpVerInfo) then
        // recolhe informacoes do ponteiro na vlpVerValue
        if VerQueryValue(
          vlpVerInfo, '\', Pointer(vlpVerValue), vldVerValueSize) then
        begin
          vlsVersao := IntToStr(vlpVerValue.dwFileVersionMS shr 16);
          vlsVersao :=
            vlsVersao + '.' + IntToStr(vlpVerValue.dwFileVersionMS and $FFFF);
          vlsVersao :=
            vlsVersao + '.' + IntToStr(vlpVerValue.dwFileVersionLS shr 16);
          vlsVersao :=
            vlsVersao + '.' + IntToStr(vlpVerValue.dwFileVersionLS and $FFFF);
        end;
    finally
      FreeMem(vlpVerInfo);
    end;
  end;
  Result := vlsVersao;
end;

function VersaoDoWindows: Integer;
type
  TIsWow64Process = function(AHandle:THandle; var AIsWow64: BOOL): BOOL; stdcall;
var
  vKernel32Handle: DWORD;
  vIsWow64Process: TIsWow64Process;
  vIsWow64: BOOL;
begin
  Result := 32;

  vKernel32Handle := LoadLibrary('kernel32.dll');
  if (vKernel32Handle = 0) then
    Exit;
  try
    @vIsWow64Process := GetProcAddress(vKernel32Handle, 'IsWow64Process');

    if not Assigned(vIsWow64Process) then
      Exit;

    vIsWow64 := False;

    if (vIsWow64Process(GetCurrentProcess, vIsWow64)) then
      Result := IfThen(vIsWow64, 64, 32);

  finally
    FreeLibrary(vKernel32Handle);
  end;
end;

function EhWindows64: Boolean;
type
  TIsWow64Process = function(AHandle:THandle; var AIsWow64: BOOL): BOOL; stdcall;
var
  vKernel32Handle: DWORD;
  vIsWow64Process: TIsWow64Process;
  vIsWow64: BOOL;
begin
  vKernel32Handle := LoadLibrary('kernel32.dll');
  if (vKernel32Handle = 0) then
  begin
    Result := False;
    Exit;
  end;
  try
    @vIsWow64Process := GetProcAddress(vKernel32Handle, 'IsWow64Process');
    if not Assigned(vIsWow64Process) then
    begin
      Result := False;
      Exit;
    end;
    vIsWow64Process(GetCurrentProcess, vIsWow64);
    Result := vIsWow64;
  finally
    FreeLibrary(vKernel32Handle);
  end;
end;

function Barra(vpsPasta: String; vpbInclui: Boolean = True): String;
begin
  Result := Trim(vpsPasta);
  if vpbInclui then
  begin
    if not (Result[Length(Result)] = '\') then
      Result := Result + '\';
  end
  else
  begin
    if (Result[Length(Result)] = '\') then
      Result := Copy(Result, 1, Length(Result) - 1);
  end;
end;

procedure GeraArqTxt(vpsDirArq, vpsNomArq, vpsExtArq, vpsConteudo: String);
var
  vlsNomArq: String;
  vltTextFile: TextFile;
  vlsDirArq: String;
begin
  try
    vlsDirArq := Barra(vpsDirArq, False);
    if not DirectoryExists(vlsDirArq) then
      if not CreateDir(vlsDirArq) then
        raise Exception.Create(
          'Não foi possível criar a pasta [' + vlsDirArq + ']');
    vlsNomArq := Barra(vpsDirArq);
    vlsNomArq := vlsNomArq + vpsNomArq + '.' + vpsExtArq;
    AssignFile(vltTextFile, vlsNomArq);
    if not (FileExists(vlsNomArq)) then
      ReWrite(vltTextFile)
    else
      Append(vltTextFile);
    WriteLn(vltTextFile, vpsConteudo);
    CloseFile(vltTextFile);
  except
    raise Exception.Create(
      'Erro ao criar arquivo [' + vpsDirArq + vpsNomArq + '.' + vpsExtArq + ']');
  end;
end;

function ExecutaProgramaEEspera(vpsPrograma: String): Boolean;
var
  vltSh: TShellExecuteInfo;
  vldCodigoSaida: DWord;
begin
  FillChar(vltSh, SizeOf(vltSh), 0);
  vltSh.cbSize := SizeOf(TShellExecuteInfo);
  with vltSh do
  begin
    fMask := SEE_MASK_NOCLOSEPROCESS;
    Wnd := Application.Handle;
    lpVerb := nil;
    lpFile := PChar(vpsPrograma);
    nShow := SW_SHOWNORMAL;
  end;
  if ShellExecuteEx(@vltSh) then
  begin
    repeat
      Application.ProcessMessages;
      GetExitCodeProcess(vltSh.hProcess, vldCodigoSaida);
    until not(vldCodigoSaida = STILL_ACTIVE);
    Result := True;
  end
  else
    Result := False;
end;

procedure ExecutaPrograma(vpsPrograma: String);
begin
  if not FileExists(vpsPrograma) then
  begin
    raise Exception.Create(
      'Programa [' + vpsPrograma + '] não encontrado para executar!');
  end;
  WinExec(Pchar(vpsPrograma), SW_Normal);
end;

procedure DeletaPrograma(vpsPrograma: String);
begin
  if not FileExists(vpsPrograma) then
  begin
    raise Exception.Create(
      'Programa [' + vpsPrograma + '] inexistente para deletar!');
  end;
  DeleteFile(PChar(vpsPrograma));
end;

procedure CriaCompatibilidadeWin64NoWin32(vpsPrograma: String);
var
  vltReg: TRegistry;
begin
  if not FileExists(vpsPrograma) then
  begin
    raise Exception.Create(
      'Programa [' + vpsPrograma + '] inexistente para tornar compatível com Win32!');
  end;
  vltReg := TRegistry.Create;
  try
    vltReg.RootKey := HKEY_CURRENT_USER;
    vltReg.OpenKey('\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers', True);
    vltReg.WriteString(vpsPrograma, 'WINXPSP3');
    vltReg.CloseKey;
  finally
    vltReg.Free;
  end;
end;

procedure CriaODBCFireBird(vpsAliasDB, vpsPastaDB, vpsNomeDB: String);
var
  vltReg: TRegistry;
  vlsAliasDB,
  vlsPastaDB,
  vlsNomeDB,
  vlsDB: String;
begin
  vlsAliasDB := vpsAliasDB; //Exemplo: 'OdbcTx16';
  vlsPastaDB := vpsPastaDB; //Exemplo: 'C:\AAA\Tx16\db\';
  vlsNomeDB := vpsNomeDB; //Exemplo: 'Tx16.FDB';
  vlsDB := Barra(vlsPastaDB) + vlsNomeDB;
  vltReg := TRegistry.Create;
  try
    vltReg.RootKey := HKEY_LOCAL_MACHINE;
    vltReg.OpenKey('\Software\ODBC\ODBC.INI\' + vlsAliasDB, True);
    vltReg.WriteString('AutoQuotedIdentifier', 'N');
    vltReg.WriteString('CharacterSet', 'NONE');
    vltReg.WriteString('Client', '');
    vltReg.WriteString('Dbname', vlsDB);
    vltReg.WriteString('Description', '');
    vltReg.WriteString('Dialect', '3');
    vltReg.WriteString('Driver', SistemaAAADriveCorrente + '\WINDOWS\system32\OdbcFb.dll');
    vltReg.WriteString('JdbcDriver', 'IscDbc');
    vltReg.WriteString('LockTimeoutWaitTransactions', '');
    vltReg.WriteString('NoWait', 'N');
    vltReg.WriteString('Password', 'DKEBFJENHFCOBHGHLAIMNAAFICELEAEGDNMFNOGALAMHBBGCHFADNKCBPPGMANOGIEKENIOPHDIPBIECPLLLCBIKEJKMJLPLIB');
    vltReg.WriteString('QuotedIdentifier', 'Y');
    vltReg.WriteString('ReadOnly', 'N');
    vltReg.WriteString('Role', '');
    vltReg.WriteString('SafeThread', 'Y');
    vltReg.WriteString('SensitiveIdentifier', 'N');
    vltReg.WriteString('User', 'SYSDBA');
    vltReg.WriteString('UseSchemaIdentifier', '0');
    vltReg.CloseKey;

    vltReg.OpenKey('\Software\ODBC\ODBC.INI\ODBC Data Sources', True);
    vltReg.WriteString(vlsAliasDB, 'Firebird/InterBase(r) driver');
    vltReg.CloseKey;
  finally
    vltReg.Free;
  end;
end;

function NomeProgramaSemExt(vpsPrograma: String): String;
var
  vlsNomeExe: String;
begin
  vlsNomeExe := ExtractFileName(vpsPrograma);
  vlsNomeExe := Copy(vlsNomeExe, 1, Length(vlsNomeExe) - 4);
  Result := vlsNomeExe;
end;

function SistemaAAADriveCorrente: String;
begin
  Result := ExtractFileDrive(Application.ExeName);
end;

function DeletaCharAlfanumerico(vpsTexto: String; vpsExcecao: String = ''): String;
var
  vliPos: Integer;
begin
  Result := '';
  for vliPos := 1 to Length(vpsTexto) do
  begin
    if (Pos(vpsTexto[vliPos], vpsExcecao) > 0) then
      Result := Result + vpsTexto[vliPos]
    else
      if (Pos(vpsTexto[vliPos], '1234567890') > 0) then
        Result := Result + vpsTexto[vliPos];
  end;
end;

function ContemNumeros(vpsTexto: String): Boolean;
var
  vliPos: Integer;
begin
  Result := False;
  for vliPos := 1 to Length(vpsTexto) do
    if (Pos(vpsTexto[vliPos], '1234567890') > 0) then
    begin
      Result := True;
      Break;
    end;
end;

end.
