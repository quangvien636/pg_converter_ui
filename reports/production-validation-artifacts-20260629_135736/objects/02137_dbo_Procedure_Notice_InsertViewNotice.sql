-- ─── PROCEDURE→FUNCTION: notice_insertviewnotice ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.notice_insertviewnotice(character varying, integer);
CREATE OR REPLACE FUNCTION public.notice_insertviewnotice(
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
    userno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	

	SELECT UserID INTO userlist FROM public."NoticeReference" WHERE USERID = notice_insertviewnotice.userid AND NoticeNo = notice_insertviewnotice.noticeno
	
	IF UserList != '' THEN;
			UPDATE Notices
			CurrentViews := (SELECT COUNT(*) FROM NoticeReference WHERE NoticeNo = notice_insertviewnotice.noticeno);
			WHERE NoticeNo = notice_insertviewnotice.noticeno
			--Print(UserList)
		END IF;
	ELSE







			SELECT B.DepartNo INTO departno FROM Organization_Users A INNER JOIN Organization_BelongToDepartment B
			ON A.UserNo = B.USERNO
			WHERE A.UserID = notice_insertviewnotice.userid
			
			SELECT NAME INTO deptname FROM Organization_Departments WHERE DepartNo = DepartNo
			SELECT NAME INTO psname FROM Organization_Positions WHERE POSITIONNO = PositionNo
			SELECT UserNo, NAME INTO userno, name FROM Organization_Users WHERE USERID = notice_insertviewnotice.userid

			INSERT INTO public."NoticeReference" (NoticeNo, UserID, Department, Position, Name)
			VALUES(NoticeNo, UserID, DEPTName, PsName, NAME)

			INSERT INTO public."NoticeReferences"(NoticeNo, UserNo, ReadDate)
			VALUES(NoticeNo, UserNo, NOW())

			UPDATE Notices
			CurrentViews := (SELECT COUNT(*) FROM NoticeReference WHERE NoticeNo = notice_insertviewnotice.noticeno);
			WHERE NoticeNo = notice_insertviewnotice.noticeno
		END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
