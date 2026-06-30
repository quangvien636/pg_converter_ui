-- ─── PROCEDURE→FUNCTION: noticesyn_insertviewnotice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.noticesyn_insertviewnotice(character varying, integer);
CREATE OR REPLACE FUNCTION public.noticesyn_insertviewnotice(
    IN userid character varying,
    IN noticeno integer
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

	

	SELECT UserID INTO userlist FROM public."NoticeSyn_Reference" WHERE USERID = noticesyn_insertviewnotice.userid AND NoticeNo = noticesyn_insertviewnotice.noticeno
	
	IF UserList != '' THEN
			Print(UserList)
		END IF;
	ELSE






			SELECT B.DepartNo INTO departno FROM Organization_Users A INNER JOIN Organization_BelongToDepartment B
			ON A.UserNo = B.USERNO
			WHERE A.UserID = noticesyn_insertviewnotice.userid
			
			SELECT NAME INTO deptname FROM Organization_Departments WHERE DepartNo = DepartNo
			SELECT NAME INTO psname FROM Organization_Positions WHERE POSITIONNO = PositionNo
			SELECT NAME INTO name FROM Organization_Users WHERE USERID = noticesyn_insertviewnotice.userid

			INSERT INTO public."NoticeSyn_Reference" (NoticeNo, UserID, Department, Position, Name)
			VALUES(NoticeNo, UserID, DEPTName, PsName, NAME)
		END IF;
	
	
END;
---------------------------------------------
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
