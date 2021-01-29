CREATE TABLE ServicoItem
(
  CodServico INTEGER NOT NULL,
  IteServico INTEGER NOT NULL,
  CodMedicamento INTEGER NOT NULL,
  VlrMedicamento DOUBLE PRECISION,
  ObsMedicamento VARCHAR(255),
 PRIMARY KEY (CodServico, IteServico)
);


