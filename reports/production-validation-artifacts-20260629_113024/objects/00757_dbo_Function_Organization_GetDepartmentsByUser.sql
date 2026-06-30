-- ─── FUNCTION: organization_getdepartmentsbyuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getdepartmentsbyuser(integer);
CREATE OR REPLACE FUNCTION public.organization_getdepartmentsbyuser(
    userno integer
) RETURNS TABLE(
    departno integer
)
AS $function$
#variable_conflict use_column
DECLARE
    belongtodepartments table (
			rownum		int identity,
			departno	int,
			parentno	int
		);
BEGIN


	

		INSERT INTO BelongToDepartments
		RETURN QUERY
		SELECT DepartNo, ParentNo FROM Organization_Departments
		WHERE DepartNo IN (
			SELECT DepartNo FROM Organization_BelongToDepartment
			WHERE UserNo = organization_getdepartmentsbyuser.userno
		)


		SET RowIndex = 1
		SET MaxIndex = (SELECT MAX(RowNum) FROM BelongToDepartments)



		WHILE (RowIndex <= MaxIndex) BEGIN

			SELECT DepartNo = DepartNo, ParentNo = ParentNo
			FROM BelongToDepartments
			WHERE RowNum = RowIndex

			INSERT INTO ListOfDepartNos
			RETURN QUERY
			SELECT DepartNo

			WHILE (ParentNo != 0) BEGIN

				SELECT DepartNo = DepartNo, ParentNo = ParentNo FROM Organization_Departments
				WHERE DepartNo = ParentNo

				INSERT INTO ListOfDepartNos
				RETURN QUERY
				SELECT DepartNo

			END

			SET RowIndex = RowIndex + 1

		END
	
	RETURN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
