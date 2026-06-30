-- ─── FUNCTION: fn_getchilddepartnobydepartno ───────────────────────────────
DROP FUNCTION IF EXISTS public.fn_getchilddepartnobydepartno(character varying, character varying);
CREATE OR REPLACE FUNCTION public.fn_getchilddepartnobydepartno(
    listdepartno character varying,
    delimiter character varying
) RETURNS TABLE(
    departno integer
)
AS $function$
#variable_conflict use_column
DECLARE
    tempdepartments table (
			rownum		int identity,
			departno	int			
		);
    parentno integer;
BEGIN

	

		if(ListDepartNo<>'') begin;
		INSERT INTO TempDepartments
		RETURN QUERY
		select * from public."fn_split_array"(ListDepartNo,Delimiter)


		SET RowIndex = 1
		SET MaxIndex = (SELECT MAX(RowNum) FROM TempDepartments)


		WHILE(RowIndex <= MaxIndex) BEGIN

			SELECT ParentNo = DepartNo
				FROM TempDepartments
				WHERE RowNum = RowIndex

			if((select count(*) from Organization_Departments where parentNo=ParentNo) = 0 ) begin
				SET RowIndex = RowIndex + 1
				continue
			end		

			INSERT INTO TempDepartments				
			RETURN QUERY
			SELECT * from public."fn_getchilddepartnolist"(ParentNo)

			SET RowIndex = RowIndex + 1
		END

		INSERT INTO ListOfDepartNos		
		RETURN QUERY
		SELECT DISTINCT DepartNo FROM TempDepartments
	end
	RETURN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
