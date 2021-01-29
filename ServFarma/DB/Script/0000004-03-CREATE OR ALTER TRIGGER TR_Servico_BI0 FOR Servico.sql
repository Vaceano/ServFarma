CREATE OR ALTER TRIGGER TR_Servico_BI0 FOR Servico
ACTIVE BEFORE INSERT POSITION 0
AS
begin
  new.CodServico = gen_id(gn_Servico, 1);
end;
