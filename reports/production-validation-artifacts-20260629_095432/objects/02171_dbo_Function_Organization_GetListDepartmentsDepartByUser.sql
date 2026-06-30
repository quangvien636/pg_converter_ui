-- ─── FUNCTION: organization_getlistdepartmentsdepartbyuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.organization_getlistdepartmentsdepartbyuser(integer);
CREATE OR REPLACE FUNCTION public.organization_getlistdepartmentsdepartbyuser(
    userno integer
) RETURNS TABLE(
    departno text,
    col2 text
)
AS $function$
DECLARE
    listofdepartnos table (
	departno	int,
	departname nvarchar(200);
    belongtodepartments table (
			rownum		int identity,
			departno	int,
			parentno	int,
			name nvarchar(200);
BEGIN



)



		)

		INSERT INTO BelongToDepartments
		RETURN QUERY
		SELECT DepartNo, ParentNo,Name FROM Organization_Departments
		WHERE DepartNo IN (
			SELECT DepartNo FROM Organization_BelongToDepartment
			WHERE UserNo = organization_getlistdepartmentsdepartbyuser.userno
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
	RETURN QUERY
	select * from ListOfDepartNos;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
