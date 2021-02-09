unit DConexao;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DBTables, Db, SException;

type
  TDmConexao = class(TDataModule)
    DbsConexao: TDatabase;
    procedure DmPrincipalCreate(Sender: TObject);
    procedure DmPrincipalDestroy(Sender: TObject);
  private
    procedure InicializaAplicacao;
    procedure InicializaConexaoBde;
    procedure AppException(Sender: TObject; E: Exception);
    { Private declarations }
  public
    procedure AtualizaVersaoDoSistema;
    { Public declarations }
  end;

var
  DmConexao: TDmConexao;
  vgiTransaction: Integer;
  vgsVersao: string;

implementation

uses
  UConst, UFerramentas, UFerramentasB;

{$R *.DFM}

procedure TDmConexao.DmPrincipalCreate(Sender: TObject);

begin
  vgiTransaction := 0;
  InicializaAplicacao;
  InicializaConexaoBde;
end;

procedure TDmConexao.InicializaAplicacao;
begin
  { Inicio da inicializacao da formatacao }
  Application.OnException := AppException;
  Application.HintHidePause := 100000;
//  SetPrecisionMode(pmExtended);   { Precisão no Arredondamento }
  CurrencyString := '';           { Símbolo da moeda }
  CurrencyFormat := 0;            { Posição do símbolo da moeda = ¤1,1 }
  NegCurrFormat := 2;             { Formato de número negativo = ¤-1,1 }
  ThousandSeparator := '.';       { Símbolo de agrupamento de dígitos }
  DecimalSeparator := ',';        { Símbolo decimal }
  CurrencyDecimals := 2;          { No. de dígitos decimais }
  DateSeparator := '/';           { Separador de data }
  ShortDateFormat := 'dd/mm/yyyy';{ Estilo de data abreviada }
  LongDateFormat :=               { Estilo de data por extenso }
    'dddd, d'#39' de '#39'mmmm'#39' de '#39'yyyy';
  TimeSeparator := ':';           { Separador de hora }
  TimeAMString := '';             { Símbolo AM }
  TimePMString := '';             { Símbolo PM }
  ShortTimeFormat := 'hh:mm';     { Estilo de hora curta }
  LongTimeFormat := 'hh:mm:ss';   { Estilo de hora longa }
  ListSeparator := ';';           { Separador de listas }
  { UpdateFormatSettings é atribuido False para evitar que quando
    o sistema esteja carregado as variáveis acima sejam novamente
    inicializadas pelo Windows. Por exemplo se eu alterar a cor do
    desktop ou alguma configuração da impressora o sistema perde a
    Configurações Regionais que foram setadas. }
  Application.UpdateFormatSettings := False;
  Application.HelpFile :=
    ExtractFilePath(Application.ExeName) + Application.Title + '.HLP';
  vgsVersao := cgsVersao + ': ' + VersaoExe(Application.ExeName);

  { Fim da inicializacao da formatacao }
end;

procedure TDmConexao.InicializaConexaoBde;
var
  vltStrLstAlias: TStringList;
begin
  DbsConexao.Connected := False;
  DbsConexao.Connected := True;
  Exit;

  vltStrLstAlias := TStringList.Create;
  try
    vltStrLstAlias.Clear;
    DbsConexao.Session.DeleteAlias(DbsConexao.AliasName);
    DbsConexao.Session.AddStandardAlias(
      DbsConexao.AliasName,
      DbsConexao.AliasName,
      'Firebird/InterBase(r) driver');
    vltStrLstAlias.Add('DATABASE NAME=');
    vltStrLstAlias.Add('USER NAME=SYSDBA');
    vltStrLstAlias.Add('ODBC DSN=' + DbsConexao.AliasName);
    vltStrLstAlias.Add('OPEN MODE=READ/WRITE');
    vltStrLstAlias.Add('BATCH COUNT=200');
    vltStrLstAlias.Add('LANGDRIVER=Borland PTG Latin-1');
    vltStrLstAlias.Add('MAX ROWS=1');
    vltStrLstAlias.Add('SCHEMA CACHE DIR=');
    vltStrLstAlias.Add('SCHEMA CACHE SIZE=8');
    vltStrLstAlias.Add('SCHEMA CACHE TIME=-1');
    vltStrLstAlias.Add('SQLPASSTHRU MODE=SHARED AUTOCOMMIT');
    vltStrLstAlias.Add('SQLQRYMODE=SERVER');
    vltStrLstAlias.Add('ENABLE SCHEMA CACHE=FALSE');
    vltStrLstAlias.Add('ENABLE BCD=FALSE');
    vltStrLstAlias.Add('ROWSET SIZE=1000000');
    vltStrLstAlias.Add('BLOBS TO CACHE=20000');
    vltStrLstAlias.Add('BLOB SIZE=20000');
    DbsConexao.Session.ModifyAlias(DbsConexao.AliasName, vltStrLstAlias);
//    DbsConexao.Session.SaveConfigFile;  // funciona sem salvar e trava no windows 10
    if not DbsConexao.Connected then
      try
        DbsConexao.Connected := True;
      except
        on E: Exception do
          raise Exception.Create(
            'Erro ao criar conexão com o BDE! ' + #13 + #13 +
            '[' + E.message + '] ' + #13 + #13 +
            'Alias [' + vltStrLstAlias.Text + '] ')
      end;
  finally
    vltStrLstAlias.Free
  end;
  AtualizaVersaoDoSistema;
end;

procedure TDmConexao.DmPrincipalDestroy(Sender: TObject);
begin
  DbsConexao.Connected := False;
end;

procedure TDmConexao.AppException(Sender: TObject; E: Exception);
begin
  MsgErro(E);
end;

procedure TDmConexao.AtualizaVersaoDoSistema;
begin
  vgsVersao := cgsVersao + ': ' + VersaoExe(Application.ExeName);
end;

end.
