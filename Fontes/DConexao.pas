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
//  SetPrecisionMode(pmExtended);   { Precis�o no Arredondamento }
  CurrencyString := '';           { S�mbolo da moeda }
  CurrencyFormat := 0;            { Posi��o do s�mbolo da moeda = �1,1 }
  NegCurrFormat := 2;             { Formato de n�mero negativo = �-1,1 }
  ThousandSeparator := '.';       { S�mbolo de agrupamento de d�gitos }
  DecimalSeparator := ',';        { S�mbolo decimal }
  CurrencyDecimals := 2;          { No. de d�gitos decimais }
  DateSeparator := '/';           { Separador de data }
  ShortDateFormat := 'dd/mm/yyyy';{ Estilo de data abreviada }
  LongDateFormat :=               { Estilo de data por extenso }
    'dddd, d'#39' de '#39'mmmm'#39' de '#39'yyyy';
  TimeSeparator := ':';           { Separador de hora }
  TimeAMString := '';             { S�mbolo AM }
  TimePMString := '';             { S�mbolo PM }
  ShortTimeFormat := 'hh:mm';     { Estilo de hora curta }
  LongTimeFormat := 'hh:mm:ss';   { Estilo de hora longa }
  ListSeparator := ';';           { Separador de listas }
  { UpdateFormatSettings � atribuido False para evitar que quando
    o sistema esteja carregado as vari�veis acima sejam novamente
    inicializadas pelo Windows. Por exemplo se eu alterar a cor do
    desktop ou alguma configura��o da impressora o sistema perde a
    Configura��es Regionais que foram setadas. }
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
            'Erro ao criar conex�o com o BDE! ' + #13 + #13 +
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
