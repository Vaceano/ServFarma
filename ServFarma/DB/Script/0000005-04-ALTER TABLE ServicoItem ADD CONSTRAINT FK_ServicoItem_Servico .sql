ALTER TABLE ServicoItem ADD CONSTRAINT FK_ServicoItem_Servico 
  FOREIGN KEY (CodServico) REFERENCES Servico (CodServico);

