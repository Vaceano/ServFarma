unit SSobreSistema;

interface

uses
  WinTypes, WinProcs, Classes, Graphics, Forms, Controls, Buttons, SysUtils,
  StdCtrls, DB, DBTables, Grids, DBGrids, DBCtrls, ExtCtrls, Menus, Dialogs,
  ComCtrls;

type
  TFrmSSobreSistema = class(TForm)
    PnlSobreSistema: TPanel;
    LblSistema: TLabel;
    LblAnalistaDeSistemas: TLabel;
    LblAplicacoesDeAcaoAvancada: TLabel;
    PnlLogoAAA: TPanel;
    ImgLogoAAA: TImage;
    pnControle: TPanel;
    BtnOk: TBitBtn;
    LblCelular: TLabel;
    LblEmail: TLabel;
    EdtEmail: TEdit;
    procedure BtnOkClick(Sender: TObject);
  end;

procedure FNCSobreSistema; export;

implementation

uses
  DConexao;

{$R *.DFM}

procedure FNCSobreSistema;
var
  FrmSSobreSistema: TFrmSSobreSistema;
begin
  FrmSSobreSistema := TFrmSSobreSistema.Create(Application);
  try
    with FrmSSobreSistema do
      if ShowModal = mrOK then
      begin
      end;
  finally
    FrmSSobreSistema.Free;
  end;
end;

procedure TFrmSSobreSistema.BtnOkClick(Sender: TObject);
begin
  Close;
end;

end.
