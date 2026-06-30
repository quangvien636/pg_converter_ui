-- ─── FUNCTION: noticesyn_getchilddepartno ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_getchilddepartno(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_getchilddepartno(
    userno integer
) RETURNS TABLE(
    departno integer
)
AS $function$
#variable_conflict use_column
DECLARE
    delimiter character varying;
    belongtodepartments table (
			rownum		int identity,
			departno	int			
		);
    parentno integer;
BEGIN


	Set Delimiter=':'

	SELECT DepartNo = DepartNo FROM Organization_BelongToDepartment
			WHERE UserNo =noticesyn_getchilddepartno.userno

	select TempParentNo = ParentNo from Organization_Departments where departno=DepartNo

		INSERT INTO BelongToDepartments
		RETURN QUERY
		SELECT DepartNo FROM Organization_Departments
		WHERE DepartNo IN (
			SELECT DepartNo FROM Organization_Departments where parentNo in (select * from public."fn_split_array"(TempParentNo,Delimiter))
		)

		insert into ListOfDepartNos
		RETURN QUERY
		select * from public."fn_split_array"(TempParentNo,Delimiter)

		


		SET RowIndex = 1
		SET MaxIndex = (SELECT MAX(RowNum) FROM BelongToDepartments)


		WHILE (RowIndex <= MaxIndex) BEGIN

			SELECT ParentNo = DepartNo
			FROM BelongToDepartments
			WHERE RowNum = RowIndex;
			INSERT INTO ListOfDepartNos
			RETURN QUERY
			select ParentNo

			INSERT INTO ListOfDepartNos
			RETURN QUERY
			SELECT * from public."fn_getchilddepartnolist"(ParentNo)
			
			SET RowIndex = RowIndex + 1

		END
	
	RETURN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
