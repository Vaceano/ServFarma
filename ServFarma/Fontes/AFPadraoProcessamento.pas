unit AFPadraoProcessamento;
{-------------------------------------------------------------------------------
Objetivo...: Form base para processamentos
--------------------------------------------------------------------------------
Programador: Vaceano Ittner
Data e Hora: 05/08/2015 15:06
01) Criação do programa
-------------------------------------------------------------------------------}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  AFPadrao, StdCtrls, Buttons, ExtCtrls;

type
  TAFrmPadraoProcessamento = class(TAFrmPadrao)
    PnlControle: TPanel;
    PnlGeral: TPanel;
    PnlControleFiltro: TPanel;
    PnlControleProcessamento: TPanel;
    BtnExecutaProcessamento: TBitBtn;
    BtnInicializar: TBitBtn;
    BtnSair: TBitBtn;
    procedure BtnSairClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure BtnInicializarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AFrmPadraoProcessamento: TAFrmPadraoProcessamento;

implementation

{$R *.DFM}

procedure TAFrmPadraoProcessamento.FormCreate(Sender: TObject);
begin
  inherited;
  BtnInicializar.Click;
end;

procedure TAFrmPadraoProcessamento.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
  AFrmPadraoProcessamento := Nil;
end;

procedure TAFrmPadraoProcessamento.BtnSairClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TAFrmPadraoProcessamento.BtnInicializarClick(Sender: TObject);
begin
  inherited;
//  
end;

end.
