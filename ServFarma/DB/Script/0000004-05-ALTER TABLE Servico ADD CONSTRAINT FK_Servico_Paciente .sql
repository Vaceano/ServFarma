ALTER TABLE Servico ADD CONSTRAINT FK_Servico_Paciente 
  FOREIGN KEY (CodPaciente) REFERENCES Paciente (CodPaciente);
