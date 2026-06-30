-- ─── FUNCTION: noticesyn_getpermission ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_getpermission(integer);
CREATE OR REPLACE FUNCTION public.noticesyn_getpermission(
    userno integer
) RETURNS TABLE(
    auth_grp_id text,
    auth_grp_nm text
)
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
