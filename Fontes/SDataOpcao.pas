unit SDataOpcao;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls;

type
  TFrmSDataOpcao = class(TForm)
    CalDataOpcao: TMonthCalendar;
    BtnOk: TBitBtn;
    BtnCancel: TBitBtn;
    BtnLimpar: TBitBtn;
    procedure CalDataOpcaoDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function FNCDataOpcao(vpsData: String; vpbPodeLimparData: Boolean = False): String;

var
  FrmSDataOpcao: TFrmSDataOpcao;

implementation

{$R *.DFM}

function FNCDataOpcao(vpsData: String; vpbPodeLimparData: Boolean = False): String;
var
  vltDate: TDate;
begin
  Result := '';
  FrmSDataOpcao := TFrmSDataOpcao.Create(Application);
  with FrmSDataOpcao do
  begin
    BtnLimpar.Visible := vpbPodeLimparData;
    
    try
      vltDate := StrToDate(vpsData);
      if vltDate < StrToDate('01/01/1990') then
        vltDate := Date;
    except
      vltDate := Date;
    end;
    CalDataOpcao.Date := vltDate;
    case ShowModal of
      mrOK: Result := DateToStr(CalDataOpcao.Date);
      mrRetry: Result := '';
      else
        if Trim(vpsData) <> '/  /' then
          Result := vpsData;
    end;
  end;
end;

procedure TFrmSDataOpcao.CalDataOpcaoDblClick(Sender: TObject);
begin
  BtnOk.Click;
end;

end.
