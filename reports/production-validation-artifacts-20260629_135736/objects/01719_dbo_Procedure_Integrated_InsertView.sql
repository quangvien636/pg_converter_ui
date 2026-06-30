-- ─── PROCEDURE→FUNCTION: integrated_insertview ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.integrated_insertview(character varying, integer);
CREATE OR REPLACE FUNCTION public.integrated_insertview(
    IN userid character varying,
    IN no integer
) RETURNS SETOF record
AS $function$
DECLARE
    userlist character varying;
    departno integer;
    positionno integer;
    name character varying;
    deptname character varying;
    psname character varying;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	

	SELECT UserID INTO userlist FROM public."Integrated_Reference" WHERE USERID = integrated_insertview.userid AND IntegratedNo = integrated_insertview.no
	
	IF UserList != '' THEN
			Print(UserList)
		END IF;
	ELSE






			SELECT B.DepartNo INTO departno FROM Organization_Users A INNER JOIN Organization_BelongToDepartment B
			ON A.UserNo = B.USERNO
			WHERE A.UserID = integrated_insertview.userid
			
			SELECT NAME INTO deptname FROM Organization_Departments WHERE DepartNo = DepartNo
			SELECT NAME INTO psname FROM Organization_Positions WHERE POSITIONNO = PositionNo
			SELECT NAME INTO name FROM Organization_Users WHERE USERID = integrated_insertview.userid

			INSERT INTO public."Integrated_Reference" (IntegratedNo, UserID, Department, Position, Name)
			VALUES(No, UserID, DEPTName, PsName, NAME)
		END IF;
	
	
END;
-------------------/////////////////---------------------------
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
