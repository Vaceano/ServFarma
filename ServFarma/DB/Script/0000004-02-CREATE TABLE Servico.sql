CREATE TABLE Servico
(
  CodServico INTEGER NOT NULL,
  DesServico VARCHAR(100) NOT NULL,
  DatServico TIMESTAMP NOT NULL,
  CodFarmaceutico INTEGER NOT NULL,
  CodPaciente INTEGER NOT NULL,
  TipAtencaoDomiciliar CHAR(1) NOT NULL,
  NumPressao1 INTEGER,
  NumPressao2 INTEGER,
  NumTemperatura DOUBLE PRECISION,
  NumGlicemia INTEGER,
  OBSServico VARCHAR(255),
  VlrTotal DOUBLE PRECISION,
 PRIMARY KEY (CodServico)
);
