unit SCarregaProjeto;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls;

type
  TFrmSCarregaProjeto = class(TForm)
    PnlInicial: TPanel;
    ImgLogoAAA: TImage;
    LblEmpresaCriadoraDoSistema: TLabel;
    BevSeparacao: TBevel;
    LblCarregando: TLabel;
  end;

var
  FrmSCarregaProjeto: TFrmSCarregaProjeto;

implementation

{$R *.DFM}

end.
