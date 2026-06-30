-- ─── FUNCTION: fn_getchilddepartnolist ───────────────────────────────
DROP FUNCTION IF EXISTS public.fn_getchilddepartnolist(integer);
CREATE OR REPLACE FUNCTION public.fn_getchilddepartnolist(
    parentno integer
) RETURNS TABLE(
    id integer
)
AS $function$
#variable_conflict use_column
DECLARE
    belongtodepartments table (
			rownum		int identity,
			departno	int			
		);
    tempdepartno integer;
BEGIN



		INSERT INTO BelongToDepartments
		RETURN QUERY
		SELECT DepartNo FROM Organization_Departments
		WHERE ParentNo =fn_getchilddepartnolist.parentno



		SET RowIndex = 1

		insert into	ReturnTable
		RETURN QUERY
		select DepartNo from BelongToDepartments

	SET MaxIndex = (SELECT MAX(RowNum) FROM BelongToDepartments)

	WHILE (RowIndex <= MaxIndex) BEGIN
		SELECT TempDepartNo = DepartNo
			FROM BelongToDepartments
			WHERE RowNum = RowIndex

			if((select count(*) from public."fn_getchilddepartnolist"(TempDepartNo)) = 0) begin
				SET RowIndex = RowIndex + 1
				continue
			end

			insert into	ReturnTable
			RETURN QUERY
			select Id from public."fn_getchilddepartnolist"(TempDepartNo)

			SET RowIndex = RowIndex + 1

	END --end while

return;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
