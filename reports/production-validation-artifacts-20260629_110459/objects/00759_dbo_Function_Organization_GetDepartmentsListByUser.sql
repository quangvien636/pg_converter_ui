-- ─── FUNCTION: organization_getdepartmentslistbyuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getdepartmentslistbyuser(integer);
CREATE OR REPLACE FUNCTION public.organization_getdepartmentslistbyuser(
    userno integer
) RETURNS TABLE(
    departno integer,
    departname character varying
)
AS $function$
#variable_conflict use_column
DECLARE
    belongtodepartments table (
			rownum		int identity,
			departno	int,
			parentno	int,
			name nvarchar(200);
BEGIN


	

		)

		INSERT INTO BelongToDepartments
		RETURN QUERY
		SELECT DepartNo, ParentNo,Name FROM Organization_Departments
		WHERE DepartNo IN (
			SELECT DepartNo FROM Organization_BelongToDepartment
			WHERE UserNo = organization_getdepartmentslistbyuser.userno
		)


		SET RowIndex = 1
		SET MaxIndex = (SELECT MAX(RowNum) FROM BelongToDepartments)



		WHILE (RowIndex <= MaxIndex) BEGIN

			SELECT DepartNo = DepartNo, ParentNo = ParentNo, DepartName = Name
			FROM BelongToDepartments
			WHERE RowNum = RowIndex

			INSERT INTO ListOfDepartNos
			RETURN QUERY
			SELECT DepartNo,DepartName

			WHILE (ParentNo != 0) BEGIN

				SELECT DepartNo = DepartNo, ParentNo = ParentNo,DepartName=name FROM Organization_Departments
				WHERE DepartNo = ParentNo

				INSERT INTO ListOfDepartNos
				RETURN QUERY
				SELECT DepartNo,DepartName

			END

			SET RowIndex = RowIndex + 1

		END
	
	RETURN;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
