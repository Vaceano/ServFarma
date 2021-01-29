unit ADPadraoCadastro;
{-------------------------------------------------------------------------------
Objetivo...: Data modulo padrão Cadastro
--------------------------------------------------------------------------------
Programador: Vaceano Ittner
Data e Hora: 05/08/2015 15:50
01) Criação do programa
-------------------------------------------------------------------------------}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ADPadrao, Db, DBTables;

type
  TADmPadraoCadastro = class(TADmPadrao)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ADmPadraoCadastro: TADmPadraoCadastro;

implementation

{$R *.DFM}

end.
