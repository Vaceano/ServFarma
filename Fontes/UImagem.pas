unit UImagem;
{-------------------------------------------------------------------------------
Objetivo...: Unit que contem funções para imagens
--------------------------------------------------------------------------------
Programador: Vaceano Ittner
Data e Hora: 25/03/2015 02:30
01) Criação do programa
-------------------------------------------------------------------------------}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Db,
  ExtCtrls, Mask, StdCtrls, ComCtrls, Buttons, DBCtrls, DGeral, ExtDlgs, jpeg,
  clipbrd;

type
  TRGBTripleArray = array[0..32767] of TRGBTriple;
  PRGBTripleArray = ^TRGBTripleArray;


procedure RedimensionarImagem(Imagen:TBitmap);// Ancho, Alto: Integer);

implementation

// Esta cambia el alto y ancho, estirando la imagen si es necesario
procedure RedimensionarImagem(Imagen:TBitmap);// Ancho, Alto: Integer);
var
  Bitmap: TBitmap;
  //····························································
  // Procedimiento de Antialiasing con Distancia=1
  procedure Antialiasing(bmp1, bmp2:TBitmap);
  var
    r1,g1,b1:Integer;
    Y, X, j:integer;
    SL1, SL2, SL3: PRGBTripleArray;
  begin

    // Tamaño del bitmap destino
    bmp2.Height := bmp1.Height;
    bmp2.Width := bmp1.Width;
    // SCANLINE
    SL1 := bmp1.ScanLine[0];
    SL2 := bmp1.ScanLine[1];
    SL3 := bmp1.ScanLine[2];

    // reorrido para todos los pixels
    for Y := 1 to (bmp1.Height - 2) do begin
      for X := 1 to (bmp1.Width - 2) do begin
        R1 := 0;  G1 := 0; B1 := 0;
        // los 9 pixels a tener en cuenta
        for j := -1 to 1 do begin
          // FIla anterior
          R1 := R1 + SL1[X+j].rgbtRed    + SL2[X+j].rgbtRed    + SL3[X+j].rgbtRed;
          G1 := G1 + SL1[X+j].rgbtGreen  + SL2[X+j].rgbtGreen  + SL3[X+j].rgbtGreen;
          B1 := B1 + SL1[X+j].rgbtBlue   + SL2[X+j].rgbtBlue   + SL3[X+j].rgbtBlue;
        end;
        // Nuevo color
        R1:=Round(R1 div 9);
        G1:=Round(G1 div 9);
        B1:=Round(B1 div 9);
        // Asignar el nuevo
        bmp2.Canvas.Pixels[X, Y] := RGB(R1,G1,B1);
      end;
      // Siguientes...
      SL1 := SL2;
      SL2 := SL3;
      SL3 := bmp1.ScanLine[Y+1];
    end;
  end;
  //····························································  
begin
 
  Bitmap:= TBitmap.Create;
 
  // Aplicamos antialiasing
  Antialiasing(Imagen, Bitmap);
  Imagen.Assign(Bitmap);

  // reducir
  try
    Bitmap.Width:= 200;//Ancho;
    Bitmap.Height:= 200;//Alto;
    Bitmap.Canvas.StretchDraw(Bitmap.Canvas.ClipRect, Imagen);
    Imagen.Assign(Bitmap);
  finally
    Bitmap.Free;
  end;
end;

end.
