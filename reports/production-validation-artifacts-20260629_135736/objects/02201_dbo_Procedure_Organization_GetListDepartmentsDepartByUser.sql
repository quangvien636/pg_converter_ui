-- ─── PROCEDURE→FUNCTION: organization_getlistdepartmentsdepartbyuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.organization_getlistdepartmentsdepartbyuser(integer);
CREATE OR REPLACE FUNCTION public.organization_getlistdepartmentsdepartbyuser(
    IN userno integer
) RETURNS SETOF record
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
-- !! WARNING: output needs manual review — see TODO comments
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


		RowIndex := 1;
		MaxIndex := (SELECT MAX(RowNum) FROM BelongToDepartments);


		WHILE RowIndex <= MaxIndex LOOP

			SELECT DepartNo, ParentNo INTO departno, parentno FROM BelongToDepartments
			WHERE RowNum = RowIndex

			INSERT INTO ListOfDepartNos
			RETURN QUERY
			SELECT DepartNo,DepartName

			WHILE ParentNo != 0 LOOP

				SELECT DepartNo, ParentNo, name INTO departno, parentno, departname FROM Organization_Departments
				WHERE DepartNo = ParentNo

				INSERT INTO ListOfDepartNos
				RETURN QUERY
				SELECT DepartNo,DepartName

			END LOOP;

			RowIndex := RowIndex + 1;
		END LOOP;
	RETURN QUERY
	select * from ListOfDepartNos;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
