ALTER TABLE Servico ADD CONSTRAINT FK_Servico_Farmaceutico 
  FOREIGN KEY (CodFarmaceutico) REFERENCES Farmaceutico (CodFarmaceutico);
