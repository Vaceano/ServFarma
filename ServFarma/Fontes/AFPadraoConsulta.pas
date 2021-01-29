unit AFPadraoConsulta;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AFPadrao, Db, DBTables, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls;

type
  TAFrmPadraoConsulta = class(TAFrmPadrao)
    PnlControle: TPanel;
    PnlGeral: TPanel;
    PnlControleFiltro: TPanel;
    PnlControleBotoes: TPanel;
    BtnRelatorio: TBitBtn;
    BtnInicializar: TBitBtn;
    BtnSair: TBitBtn;
    DbgQryConsulta: TDBGrid;
    QryConsulta: TQuery;
    DtsQryConsulta: TDataSource;
    procedure BtnSairClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AFrmPadraoConsulta: TAFrmPadraoConsulta;

implementation

{$R *.DFM}

procedure TAFrmPadraoConsulta.BtnSairClick(Sender: TObject);
begin
  inherited;
  Close
end;

procedure TAFrmPadraoConsulta.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
  AFrmPadraoConsulta := Nil;
end;

procedure TAFrmPadraoConsulta.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  inherited;
  if Key = 40 then // 40=seta para baixo
    if DbgQryConsulta.CanFocus then
      DbgQryConsulta.SetFocus;
end;

end.
