unit AFPadrao;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TAFrmPadrao = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AFrmPadrao: TAFrmPadrao;

implementation

uses
  UFerramentas;

{$R *.DFM}

procedure TAFrmPadrao.FormCreate(Sender: TObject);
begin
  CriaScrollBar(Self);
end;

procedure TAFrmPadrao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  AFrmPadrao := nil;
end;

end.
