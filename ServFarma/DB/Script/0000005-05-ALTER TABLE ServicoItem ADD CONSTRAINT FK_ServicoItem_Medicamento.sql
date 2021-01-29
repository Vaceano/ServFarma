ALTER TABLE ServicoItem ADD CONSTRAINT FK_ServicoItem_Medicamento 
  FOREIGN KEY (CodMedicamento) REFERENCES Medicamento (CodMedicamento);


