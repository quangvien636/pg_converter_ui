-- ─── PROCEDURE→FUNCTION: board_authority_select ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
-- TODO: TOP was preserved as comment; add LIMIT manually
DROP FUNCTION IF EXISTS public.board_authority_select(integer);
CREATE OR REPLACE FUNCTION public.board_authority_select(
    IN user_no integer
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




		INSERT INTO BelongToDepartments
		RETURN QUERY
		SELECT DepartNo, ParentNo FROM Organization_Departments
		WHERE DepartNo IN (
			SELECT DepartNo FROM Organization_BelongToDepartment
			WHERE UserNo = board_authority_select.user_no
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
SELECT  /* TOP 1 */
	bu.USERGROUP_ID AS "Id", 
		bu.USER_NO AS "UserNo",
		CASE 
		  WHEN bu.USER_NO >0  THEN ou.Name 
		  ELSE od.Name || ' (' || od.Name_EN || ')'
		END AS "Name" ,
		ou.ModUserNo,
		(Select MENU_TITLE FROM Board_Menu WHERE MENU_IDX =bu.MENU_ID) as MenuTitle,
   (Select AUTH_GRP_NM FROM Board_AuthoGroup WHERE AUTH_GRP_ID =bu.AUTH_GRP_ID) as Authority,
		bu.DEPARTMENT_ID AS "DepartmentId"

   --ou.UserNo,
   --ou.Name,
   --ou.ModUserNo,
   --(Select MENU_TITLE FROM Board_Menu WHERE MENU_IDX =bu.MENU_ID) as MenuTitle,
   --(Select AUTH_GRP_NM FROM Board_AuthoGroup WHERE AUTH_GRP_ID =bu.AUTH_GRP_ID) as Authority
  FROM 
  Board_UserByGroup bu LEFT JOIN
	  Organization_Users ou  
	  on ou.UserNo = bu.USER_NO inner join Board_AuthoGroup ag on bu.AUTH_GRP_ID=ag.AUTH_GRP_ID 

	  LEFT JOIN Organization_Departments od on od.DepartNo=bu.DEPARTMENT_ID
  where (UserNo=board_authority_select.user_no OR DEPARTMENT_ID IN (SELECT DepartNo FROM ListOfDepartNos)) and MENU_ID=(Select MENU_IDX From Board_Menu Where MENU_ID='MAIN')
  AND NOT (bu.USER_NO >0 AND ou.UserNo Is null)
  ORDER BY ag.AUTH_GRP_ID ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
