CREATE OR ALTER TRIGGER TR_Medicamento_BI0 FOR Medicamento
ACTIVE BEFORE INSERT POSITION 0
AS
begin
  new.CodMedicamento = gen_id(gn_Medicamento, 1);
end;


