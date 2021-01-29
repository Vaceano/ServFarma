unit UFerramentasB;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, StdCtrls,
  Forms, DBCtrls, DB, DBTables, Buttons, ExtCtrls, Dialogs, DConexao, Grids,
  DBGrids, TeeProcs, TeEngine, Chart, DBChart, DBCGrids, Dbiprocs, DBClient;

procedure AbreQry(vptQry: TQuery);
procedure AbreTbl(vptTbl: TTable);
procedure AbreCds(vptCds: TClientDataSet);
function ProxCod(vpsTabela, vpsNomeCampo, vpsWhere: String): Integer;
function UltimoGeneratorCriado(vpsTabela: String): Integer;
function RegistroJaExiste(vpsTabela, vpsNomeCampo, vpsConteudo: String): Boolean;
function DataHoraAtual: TDateTime;
procedure SetaDataSource(vptDataSource: TDataSource; vptForm: TForm);
procedure SetaListSource(vptListSource: TDataSource; vptForm: TForm);
procedure BeginTransaction;
procedure CommitTransaction;
procedure RollbackTransaction;
function SomaAnosNaData(vpiQtdAnos: Integer; vptDataHora: TDateTime): TDateTime;
function SomaMesesNaData(vpiQtdMeses: Integer; vptDataHora: TDateTime): TDateTime;
function SomaDiasNaData(vpiQtdDias: Integer; vptDataHora: TDateTime): TDateTime;
function SomaHorasNaData(vpiQtdHoras: Integer; vptDataHora: TDateTime): TDateTime;
function SomaMinutosNaData(vpiQtdMinutos: Integer; vptDataHora: TDateTime): TDateTime;
function SomaSegundosNaData(vpiQtdSegundos: Integer; vptDataHora: TDateTime): TDateTime;

implementation

uses
  uFerramentas;

procedure AbreQry(vptQry: TQuery);
begin
  try
    vptQry.Active := False;
    vptQry.Active := True;
  except
    on E: Exception do
    begin
      Screen.Cursor:= crDefault;
      MessageBeep(0);
      MessageDlg(
        'Erro ao abrir a query [' + vptQry.Name + '] ' + #13 + #13 +
        '[' + E.message + '] ' + #13 + #13 +
        'SQL [' + vptQry.SQL.Text + ']!',
        mtWarning, [mbAbort], 0);
      Halt;
    end;
  end;
end;

procedure AbreTbl(vptTbl: TTable);
begin
  try
    vptTbl.Open;
  except
    on E: Exception do
    begin
      Screen.Cursor:= crDefault;
      MessageBeep(0);
      MessageDlg(
        'Não foi possível abrir a tabela [' + vptTbl.TableName + '] ' + #13 + #13 +
        '[' + E.message + ']!',
        mtWarning, [mbAbort], 0);
      Halt;
    end;
  end;
end;

procedure AbreCds(vptCds: TClientDataSet);
begin
  try
    vptCds.Open;
  except
    on E: Exception do
    begin
      Screen.Cursor:= crDefault;
      MessageBeep(0);
      MessageDlg(
        'Não foi possível abrir o ClientDataSet [' + vptCds.Name + '] ' + #13 + #13 +
        '[' + E.message + ']!',
        mtWarning, [mbAbort], 0);
      Halt;
    end;
  end;
end;

function ProxCod(vpsTabela, vpsNomeCampo, vpsWhere: String): Integer;
var
  vltQry: TQuery;
begin
  vltQry := TQuery.Create(nil);
  try
    with vltQry do
    begin
      Close;
      Databasename := DmConexao.DbsConexao.DatabaseName;
      Sql.Clear;
      Sql.Add('SELECT  ');
      Sql.Add('  MAX(' + vpsNomeCampo + ') ');
      Sql.Add('FROM    ');
      Sql.Add(vpsTabela);
      if vpsWhere > '' then
        Sql.Add('WHERE ' + vpsWhere);
      Open;
      Result := vltQry.Fields[0].AsInteger + 1;
    end;
  finally
    if Assigned(vltQry) then
      vltQry.Free;
  end;
end;

function UltimoGeneratorCriado(vpsTabela: String): Integer;
var
  vltQry: TQuery;
begin
  vltQry := TQuery.Create(nil);
  try
    vltQry.Close;
    vltQry.Databasename := DmConexao.DbsConexao.DatabaseName;
    vltQry.Sql.Text :=
      'SELECT GEN_ID(GN_' + vpsTabela + ',0) as GEN_ID '+#13+
      'FROM RDB$DATABASE '+#13;
    vltQry.Open;
    Result := vltQry.FieldByName('GEN_ID').AsInteger;
  finally
    if Assigned(vltQry) then
      vltQry.Free;
  end;
end;

function RegistroJaExiste(vpsTabela, vpsNomeCampo, vpsConteudo: String): Boolean;
var
  vltQry: TQuery;
begin
  vltQry := TQuery.Create(nil);
  try
    with vltQry do
    begin
      Close;
      Databasename := DmConexao.DbsConexao.DatabaseName;
      Sql.Clear;
      Sql.Add('SELECT  ');
      Sql.Add('  ' + vpsNomeCampo + ' as "COD" ');
      Sql.Add('FROM    ');
      Sql.Add(vpsTabela);
      Sql.Add('WHERE ' + vpsNomeCampo + ' = ' + vpsConteudo);
      Open;
      Result := not vltQry.IsEmpty;
    end;
  finally
    if Assigned(vltQry) then
      vltQry.Free;
  end;
end;

function DataHoraAtual: TDateTime;
var
  vltQry: TQuery;
begin
  vltQry := TQuery.Create(nil);
  try
    with vltQry do
    begin
      Close;
      Databasename := DmConexao.DbsConexao.DatabaseName;
      Sql.Clear;
      Sql.Add('SELECT                               ');
      Sql.Add('  CURRENT_TIMESTAMP AS DATAHORAATUAL ');
      Sql.Add('FROM                                 ');
      Sql.Add('  RDB$DATABASE                       ');
      Open;
      Result := vltQry.Fields[0].AsDateTime;
    end;
  finally
    if Assigned(vltQry) then
      vltQry.Free;
  end;
end;

// SetaDataSource >> força o DataSource ser o Dml instaciado e não do Dm
// pois quando abre mais de uma vez o Dm ele utiliza o visual
procedure SetaDataSource(vptDataSource: TDataSource; vptForm: TForm);
var
  vlb1: Boolean;
  vli1,
  vli2: Integer;
  vltForm: TForm;
begin
  vlb1 := False;
  vltForm := nil;
  with Application do
    for vli1 := ComponentCount - 1 downto 0 do
      if Components[vli1] is TForm then
        if TForm(Components[vli1]).Name = vptForm.Name then
        begin
          vltForm := TForm(Components[vli1]);
          vlb1 := True;
          Break;
        end;

  if not vlb1 then
    Exit;

  for vli2 := vltForm.ComponentCount - 1 downto 0 do
  begin
    if vltForm.Components[vli2] is TDBGrid then
      if (TDBGrid(vltForm.Components[vli2]).DataSource <> nil) then
        if TDBGrid(vltForm.Components[vli2]).DataSource.Name = vptDataSource.Name then
          TDBGrid(vltForm.Components[vli2]).DataSource := vptDataSource;
    if vltForm.Components[vli2] is TDBNavigator then
      if (TDBNavigator(vltForm.Components[vli2]).DataSource <> nil) then
        if TDBNavigator(vltForm.Components[vli2]).DataSource.Name = vptDataSource.Name then
          TDBNavigator(vltForm.Components[vli2]).DataSource := vptDataSource;
    if vltForm.Components[vli2] is TDBText then
      if (TDBText(vltForm.Components[vli2]).DataSource <> nil) then
        if TDBText(vltForm.Components[vli2]).DataSource.Name = vptDataSource.Name then
          TDBText(vltForm.Components[vli2]).DataSource := vptDataSource;
    if vltForm.Components[vli2] is TDBEdit then
      if (TDBEdit(vltForm.Components[vli2]).DataSource <> nil) then
        if TDBEdit(vltForm.Components[vli2]).DataSource.Name = vptDataSource.Name then
          TDBEdit(vltForm.Components[vli2]).DataSource := vptDataSource;
    if vltForm.Components[vli2] is TDBMemo then
      if (TDBMemo(vltForm.Components[vli2]).DataSource <> nil) then
        if TDBMemo(vltForm.Components[vli2]).DataSource.Name = vptDataSource.Name then
          TDBMemo(vltForm.Components[vli2]).DataSource := vptDataSource;
    if vltForm.Components[vli2] is TDBImage then
      if (TDBImage(vltForm.Components[vli2]).DataSource <> nil) then
        if TDBImage(vltForm.Components[vli2]).DataSource.Name = vptDataSource.Name then
          TDBImage(vltForm.Components[vli2]).DataSource := vptDataSource;
    if vltForm.Components[vli2] is TDBListBox then
      if (TDBListBox(vltForm.Components[vli2]).DataSource <> nil) then
        if TDBListBox(vltForm.Components[vli2]).DataSource.Name = vptDataSource.Name then
          TDBListBox(vltForm.Components[vli2]).DataSource := vptDataSource;
    if vltForm.Components[vli2] is TDBComboBox then
      if (TDBComboBox(vltForm.Components[vli2]).DataSource <> nil) then
        if TDBComboBox(vltForm.Components[vli2]).DataSource.Name = vptDataSource.Name then
          TDBComboBox(vltForm.Components[vli2]).DataSource := vptDataSource;
    if vltForm.Components[vli2] is TDBCheckBox then
      if (TDBCheckBox(vltForm.Components[vli2]).DataSource <> nil) then
        if TDBCheckBox(vltForm.Components[vli2]).DataSource.Name = vptDataSource.Name then
          TDBCheckBox(vltForm.Components[vli2]).DataSource := vptDataSource;
    if vltForm.Components[vli2] is TDBRadioGroup then
      if (TDBRadioGroup(vltForm.Components[vli2]).DataSource <> nil) then
        if TDBRadioGroup(vltForm.Components[vli2]).DataSource.Name = vptDataSource.Name then
          TDBRadioGroup(vltForm.Components[vli2]).DataSource := vptDataSource;
    if vltForm.Components[vli2] is TDBLookupListBox then
    begin
      if (TDBLookupListBox(vltForm.Components[vli2]).DataSource <> nil) then
        if TDBLookupListBox(vltForm.Components[vli2]).DataSource.Name = vptDataSource.Name then
          TDBLookupListBox(vltForm.Components[vli2]).DataSource := vptDataSource;
// Utilizar o SetaListSource para o ListSource
//      if TDBLookupListBox(vltForm.Components[vli2]).ListSource.Name = vptListSource.Name then
//        TDBLookupListBox(vltForm.Components[vli2]).ListSource.Name := vptListSource;
    end;
    if vltForm.Components[vli2] is TDBLookupComboBox then
    begin
      if (TDBLookupComboBox(vltForm.Components[vli2]).DataSource <> nil) then
        if TDBLookupComboBox(vltForm.Components[vli2]).DataSource.Name = vptDataSource.Name then
          TDBLookupComboBox(vltForm.Components[vli2]).DataSource := vptDataSource;
// Utilizar o SetaListSource para o ListSource
//      if TDBLookupComboBox(vltForm.Components[vli2]).ListSource.Name = vptListSource.Name then
//        TDBLookupComboBox(vltForm.Components[vli2]).ListSource.Name := vptListSource;
    end;
    if vltForm.Components[vli2] is TDBRichEdit then
      if (TDBRichEdit(vltForm.Components[vli2]).DataSource <> nil) then
        if TDBRichEdit(vltForm.Components[vli2]).DataSource.Name = vptDataSource.Name then
          TDBRichEdit(vltForm.Components[vli2]).DataSource := vptDataSource;
    if vltForm.Components[vli2] is TDBCtrlGrid then
      if (TDBCtrlGrid(vltForm.Components[vli2]).DataSource <> nil) then
        if TDBCtrlGrid(vltForm.Components[vli2]).DataSource.Name = vptDataSource.Name then
          TDBCtrlGrid(vltForm.Components[vli2]).DataSource := vptDataSource;
  end;
end;

procedure SetaListSource(vptListSource: TDataSource; vptForm: TForm);
var
  vlb1: Boolean;
  vli1,
  vli2: Integer;
  vltForm: TForm;
begin
  vlb1 := False;
  vltForm := nil;
  with Application do
    for vli1 := ComponentCount - 1 downto 0 do
      if Components[vli1] is TForm then
        if TForm(Components[vli1]).Name = vptForm.Name then
        begin
          vltForm := TForm(Components[vli1]);
          vlb1 := True;
          Break;
        end;

  if not vlb1 then
    Exit;

  for vli2 := vltForm.ComponentCount - 1 downto 0 do
  begin
    if vltForm.Components[vli2] is TDBLookupListBox then
    begin
      if TDBLookupListBox(vltForm.Components[vli2]).ListSource.Name = vptListSource.Name then
        TDBLookupListBox(vltForm.Components[vli2]).ListSource := vptListSource;
    end;
    if vltForm.Components[vli2] is TDBLookupComboBox then
    begin
      if TDBLookupComboBox(vltForm.Components[vli2]).ListSource.Name = vptListSource.Name then
        TDBLookupComboBox(vltForm.Components[vli2]).ListSource := vptListSource;
    end;
  end;
end;

procedure BeginTransaction;
begin
  Inc(vgiTransaction);
  if not DmConexao.DbsConexao.InTransaction then
    DmConexao.DbsConexao.StartTransaction;
end;

procedure CommitTransaction;
begin
  Dec(vgiTransaction);
  if DmConexao.DbsConexao.InTransaction then
    if vgiTransaction = 0 then
      DmConexao.DbsConexao.Commit;
end;

procedure RollbackTransaction;
begin
  Dec(vgiTransaction);
  if DmConexao.DbsConexao.InTransaction then
    if vgiTransaction = 0 then
      DmConexao.DbsConexao.Rollback;
end;

function SomaAnosNaData(vpiQtdAnos: Integer; vptDataHora: TDateTime): TDateTime;
var
  vltQry: TQuery;
begin
  vltQry := TQuery.Create(nil);
  try
    with vltQry do
    begin
      Close;
      Databasename := DmConexao.DbsConexao.DatabaseName;
      Sql.Clear;
      Sql.Add('SELECT                                             ');
      Sql.Add('  DATEADD(:VPIQTDANOS YEAR TO :VPTDATAHORA) AS DTH ');
      Sql.Add('FROM                                               ');
      Sql.Add('  RDB$DATABASE                                     ');
      ParamByName('VPIQTDANOS').AsInteger := vpiQtdAnos;
      ParamByName('VPTDATAHORA').AsDateTime := vptDataHora;
      Open;
      Result := vltQry.Fields[0].AsDateTime;
    end;
  finally
    if Assigned(vltQry) then
      vltQry.Free;
  end;
end;

function SomaMesesNaData(vpiQtdMeses: Integer; vptDataHora: TDateTime): TDateTime;
var
  vltQry: TQuery;
begin
  vltQry := TQuery.Create(nil);
  try
    with vltQry do
    begin
      Close;
      Databasename := DmConexao.DbsConexao.DatabaseName;
      Sql.Clear;
      Sql.Add('SELECT                                               ');
      Sql.Add('  DATEADD(:VPIQTDMESES MONTH TO :VPTDATAHORA) AS DTH ');
      Sql.Add('FROM                                                 ');
      Sql.Add('  RDB$DATABASE                                       ');
      ParamByName('VPIQTDMESES').AsInteger := vpiQtdMeses;
      ParamByName('VPTDATAHORA').AsDateTime := vptDataHora;
      Open;
      Result := vltQry.Fields[0].AsDateTime;
    end;
  finally
    if Assigned(vltQry) then
      vltQry.Free;
  end;
end;

function SomaDiasNaData(vpiQtdDias: Integer; vptDataHora: TDateTime): TDateTime;
var
  vltQry: TQuery;
begin
  vltQry := TQuery.Create(nil);
  try
    with vltQry do
    begin
      Close;
      Databasename := DmConexao.DbsConexao.DatabaseName;
      Sql.Clear;
      Sql.Add('SELECT                                            ');
      Sql.Add('  DATEADD(:VPIQTDDIAS DAY TO :VPTDATAHORA) AS DTH ');
      Sql.Add('FROM                                              ');
      Sql.Add('  RDB$DATABASE                                    ');
      ParamByName('VPIQTDDIAS').AsInteger := vpiQtdDias;
      ParamByName('VPTDATAHORA').AsDateTime := vptDataHora;
      Open;
      Result := vltQry.Fields[0].AsDateTime;
    end;
  finally
    if Assigned(vltQry) then
      vltQry.Free;
  end;
end;

function SomaHorasNaData(vpiQtdHoras: Integer; vptDataHora: TDateTime): TDateTime;
var
  vltQry: TQuery;
begin
  vltQry := TQuery.Create(nil);
  try
    with vltQry do
    begin
      Close;
      Databasename := DmConexao.DbsConexao.DatabaseName;
      Sql.Clear;
      Sql.Add('SELECT                                              ');
      Sql.Add('  DATEADD(:VPIQTDHORAS HOUR TO :VPTDATAHORA) AS DTH ');
      Sql.Add('FROM                                                ');
      Sql.Add('  RDB$DATABASE                                      ');
      ParamByName('VPIQTDHORAS').AsInteger := vpiQtdHoras;
      ParamByName('VPTDATAHORA').AsDateTime := vptDataHora;
      Open;
      Result := vltQry.Fields[0].AsDateTime;
    end;
  finally
    if Assigned(vltQry) then
      vltQry.Free;
  end;
end;

function SomaMinutosNaData(vpiQtdMinutos: Integer; vptDataHora: TDateTime): TDateTime;
var
  vltQry: TQuery;
begin
  vltQry := TQuery.Create(nil);
  try
    with vltQry do
    begin
      Close;
      Databasename := DmConexao.DbsConexao.DatabaseName;
      Sql.Clear;
      Sql.Add('SELECT                                                  ');
      Sql.Add('  DATEADD(:VPIQTDMINUTOS MINUTE TO :VPTDATAHORA) AS DTH ');
      Sql.Add('FROM                                                    ');
      Sql.Add('  RDB$DATABASE                                          ');
      ParamByName('VPIQTDMINUTOS').AsInteger := vpiQtdMinutos;
      ParamByName('VPTDATAHORA').AsDateTime := vptDataHora;
      Open;
      Result := vltQry.Fields[0].AsDateTime;
    end;
  finally
    if Assigned(vltQry) then
      vltQry.Free;
  end;
end;

function SomaSegundosNaData(vpiQtdSegundos: Integer; vptDataHora: TDateTime): TDateTime;
var
  vltQry: TQuery;
begin
  vltQry := TQuery.Create(nil);
  try
    with vltQry do
    begin
      Close;
      Databasename := DmConexao.DbsConexao.DatabaseName;
      Sql.Clear;
      Sql.Add('SELECT                                                   ');
      Sql.Add('  DATEADD(:VPIQTDSEGUNDOS SECOND TO :VPTDATAHORA) AS DTH ');
      Sql.Add('FROM                                                     ');
      Sql.Add('  RDB$DATABASE                                           ');
      ParamByName('VPIQTDSEGUNDOS').AsInteger := vpiQtdSegundos;
      ParamByName('VPTDATAHORA').AsDateTime := vptDataHora;
      Open;
      Result := vltQry.Fields[0].AsDateTime;
    end;
  finally
    if Assigned(vltQry) then
      vltQry.Free;
  end;
end;

end.






























