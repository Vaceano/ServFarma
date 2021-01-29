unit SException;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, StdCtrls, Buttons, ComCtrls, ExtCtrls, DBTables, DB;

type
  TTipoMsg = (
    tmPadrao,
    tmErro,
    tmAviso,
    tmInformacao,
    tmPergunta);

  TFrmSException = class(TForm)
    PnlMsg: TPanel;
    RedMsg: TRichEdit;
    RedMsgDetalhada: TRichEdit;
    PnlIcone: TPanel;
    BtnGeraLogTxt: TSpeedButton;
    Splitter1: TSplitter;
    PnlControle: TPanel;
    BtnOK: TBitBtn;
    BtnDetalhes: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnGeraLogTxtClick(Sender: TObject);
    procedure BtnDetalhesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Splitter1CanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
  private
    FTipoMsg: TTipoMsg;
    procedure SetTipoMsg(const Value: TTipoMsg);
    procedure TrataTodosOsErros(E: Exception; vpsMsgErro: String; vptTipoMsg: TTipoMsg);
    procedure TrataErroJaCatalogado(E: Exception);
    procedure MostraDetalhes(vpbMostraDetalhes: Boolean);
    { Private declarations }
  protected
    property TipoMsg: TTipoMsg read FTipoMsg write SetTipoMsg;
    { Protected declarations }
  public
    { Public declarations }
  end;

  { TSException }
  TSException = class(Exception)
  private
    FSender: TObject;
    FTipoMsg: TTipoMsg;
    { Private declarations }
  protected
    { Protected declarations }
  public
    constructor Create(const vptSender: TObject; vpsMsg: String); overload;
    constructor Create(const vptSender: TObject; vpsMsg: String; vptTipoMsg: TTipoMsg); overload;
    property Sender: TObject read FSender default Nil;
    property TipoMsg: TTipoMsg read FTipoMsg;
    { Public declarations }
  end;

  { TSExceptionError }
  TSExceptionError = class(TSException)
  end;

  { TSExceptionWarning }
  TSExceptionWarning = class(TSException)
  end;

  { TSExceptionMessage }
  TSExceptionMessage = class(TSException)
  end;

procedure MsgErro(E: Exception); overload;
procedure MsgErro(E: Exception; vpsMsgErro: String; vptTipoMsg: TTipoMsg); overload;

var
  FrmSException: TFrmSException;
  vliHeightForm: Integer;
  vliHeightPnlMsg: Integer;

implementation

{$R *.DFM}

uses
  UConst, UFerramentas;

procedure MsgErro(E: Exception);
begin
  MsgErro(E, '', tmPadrao);
end;

procedure MsgErro(E: Exception; vpsMsgErro: String; vptTipoMsg: TTipoMsg); overload;
begin
  FrmSException := TFrmSException.Create(Application);
  FrmSException.TrataTodosOsErros(E, vpsMsgErro, vptTipoMsg);
  FrmSException.Free;
end;

{ TSException }

constructor TSException.Create(const vptSender: TObject; vpsMsg: String);
begin
  Create(Sender, vpsMsg, tmPadrao);
end;

constructor TSException.Create(const vptSender: TObject; vpsMsg: String; vptTipoMsg: TTipoMsg);
begin
  FSender := vptSender;
  FTipoMsg := vptTipoMsg;
  inherited Create(vpsMsg);
end;

procedure TFrmSException.TrataTodosOsErros(E: Exception; vpsMsgErro: String; vptTipoMsg: TTipoMsg);
begin
  RedMsg.Lines.Text := E.Message;
  RedMsgDetalhada.Lines.Text := E.Message;

  if (vptTipoMsg = tmPadrao) then
    Self.TipoMsg := tmErro
  else
    Self.TipoMsg := TipoMsg;

  if (Trim(vpsMsgErro) <> '') then
    RedMsg.Lines.Text := vpsMsgErro
  else
    TrataErroJaCatalogado(E);

  MostraDetalhes(False);
//  MostraDetalhes(RedMsg.Lines.Text <> RedMsgDetalhada.Lines.Text);

  ShowModal;
end;

procedure TFrmSException.TrataErroJaCatalogado(E: Exception);
begin
  if (Pos('Couldn', E.Message) > 0)
  and (Pos('t perform the edit because another user changed the record.', E.Message) > 0) then
  begin
    RedMsg.Text :=
      'Não foi possível realizar a edição porque outro usuário alterou o registro.' + #13 +
      'Para atualizar as informações, feche a tela e tente novamente!!!';
    Exit;
  end;

  if (Pos('violation of FOREIGN KEY constraint', E.Message) > 0)
  and (Pos('present for the record', E.Message) > 0) then
  begin
    RedMsg.Lines.Text := 'Este registro já está sendo utilizado.';
    Exit;
  end;

  if (Pos('violation of FOREIGN KEY constraint', E.Message) > 0)
  and (Pos('does not exist', E.Message) > 0) then
  begin
    RedMsg.Lines.Text := 'Registro pai inexistente.';
    Exit;
  end;

  if (Pos('Key violation.', E.Message) > 0)
  and (Pos('violation of PRIMARY or UNIQUE KEY constraint', E.Message) > 0) then
  begin
    RedMsg.Lines.Text := 'Registro já existe.';
    Exit;
  end;

  if (Pos('Record/Key deleted.', E.Message) > 0) then
  begin
    RedMsg.Lines.Text :=
      'Registro já foi eliminado por outro usuário.' + #13 +
      'Para atualizar as informações, feche a tela e tente novamente!!!';
    Exit;
  end;
end;

procedure TFrmSException.SetTipoMsg(const Value: TTipoMsg);
begin
  FTipoMsg := Value;
end;

procedure TFrmSException.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
  FrmSException := nil;
end;

procedure TFrmSException.BtnGeraLogTxtClick(Sender: TObject);
begin
  AbreArqTxt(LogTxt(RedMsgDetalhada.Text));
end;

procedure TFrmSException.BtnDetalhesClick(Sender: TObject);
begin
  MostraDetalhes(Height <> vliHeightForm);
end;

procedure TFrmSException.MostraDetalhes(vpbMostraDetalhes: Boolean);
begin
  if vpbMostraDetalhes then
  begin
    Height := vliHeightForm;
    RedMsgDetalhada.Visible := True;
    BtnDetalhes.Caption := '<< Detalhes';
  end
  else
  begin
    Height := PnlMsg.Height + 30;
    RedMsgDetalhada.Visible := False;
    BtnDetalhes.Caption := 'Detalhes >>';
  end;
end;

procedure TFrmSException.FormCreate(Sender: TObject);
begin
  vliHeightForm := Height;
  vliHeightPnlMsg := PnlMsg.Height;
end;

procedure TFrmSException.Splitter1CanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
begin
  if NewSize < vliHeightPnlMsg then
    Accept := False;
end;

end.
