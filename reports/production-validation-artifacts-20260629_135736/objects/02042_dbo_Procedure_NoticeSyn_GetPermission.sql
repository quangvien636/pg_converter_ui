-- ─── PROCEDURE→FUNCTION: noticesyn_getpermission ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.noticesyn_getpermission(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_getpermission(
    IN userno integer
) RETURNS SETOF record
AS $function$
DECLARE
    listofdepartnos table (
			departno	int
		);
    belongtodepartments table (
			rownum		int identity,
			departno	int,
			parentno	int
		);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.




		INSERT INTO BelongToDepartments
		RETURN QUERY
		SELECT DepartNo, ParentNo FROM Organization_Departments
		WHERE DepartNo IN (
			SELECT DepartNo FROM Organization_BelongToDepartment
			WHERE UserNo = noticesyn_getpermission.userno
		)


		RowIndex := 1;
		MaxIndex := (SELECT MAX(RowNum) FROM BelongToDepartments);


		WHILE RowIndex <= MaxIndex LOOP

			SELECT DepartNo INTO departno FROM BelongToDepartments
			WHERE RowNum = RowIndex

			INSERT INTO ListOfDepartNos
			RETURN QUERY
			SELECT DepartNo

			WHILE ParentNo != 0 LOOP

				SELECT DepartNo, ParentNo INTO departno, parentno FROM Organization_Departments
				WHERE DepartNo = ParentNo

				INSERT INTO ListOfDepartNos
				RETURN QUERY
				SELECT DepartNo

			END LOOP;

			RowIndex := RowIndex + 1;
		END LOOP;

    RETURN QUERY
    SELECT a.AUTH_GRP_ID, b.AUTH_GRP_NM FROM NoticeSyn_UserByGroup a
	LEFT JOIN NoticeSyn_AuthoGroup B ON a.AUTH_GRP_ID = b.AUTH_GRP_ID
	WHERE a.USER_NO = noticesyn_getpermission.userno OR DEPARTMENT_ID IN (SELECT DepartNo FROM ListOfDepartNos)

	RETURN QUERY
	SELECT a.AUTH_GRP_ID,a.AUTH_GRP_NM FROM NoticeSyn_AuthoGroup a WHERE a.USE_YN = 'Y'
END;
------------------------------ --------------------------------
--- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
