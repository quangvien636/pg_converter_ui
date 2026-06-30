-- ─── FUNCTION: notice_insertviewnotice ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_insertviewnotice(character varying, integer);
CREATE OR REPLACE FUNCTION public.notice_insertviewnotice(
    userid character varying,
    noticeno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
DECLARE
    userlist character varying;
    departno integer;
    positionno integer;
    name character varying;
    deptname character varying;
    psname character varying;
    userno integer;
BEGIN

	

	SELECT UserList = notice_insertviewnotice.userid FROM public."NoticeReference" WHERE USERID = notice_insertviewnotice.userid AND NoticeNo = notice_insertviewnotice.noticeno
	
	IF UserList != ''
		BEGIN;
			UPDATE Notices
			SET
				CurrentViews = (SELECT COUNT(*) FROM NoticeReference WHERE NoticeNo = notice_insertviewnotice.noticeno)
			WHERE NoticeNo = notice_insertviewnotice.noticeno
			--Print(UserList)
		END
	ELSE
		BEGIN







			SELECT DepartNo = B.DepartNo, PositionNo = B.POSITIONNO
			FROM Organization_Users A INNER JOIN Organization_BelongToDepartment B
			ON A.UserNo = B.USERNO
			WHERE A.UserID = notice_insertviewnotice.userid
			
			SELECT DEPTName = NAME FROM Organization_Departments WHERE DepartNo = DepartNo
			SELECT PsName = NAME FROM Organization_Positions WHERE POSITIONNO = PositionNo
			SELECT UserNo = UserNo, NAME = NAME FROM Organization_Users WHERE USERID = notice_insertviewnotice.userid

			INSERT INTO public."NoticeReference" (NoticeNo, UserID, Department, Position, Name)
			VALUES(NoticeNo, UserID, DEPTName, PsName, NAME)

			INSERT INTO public."NoticeReferences"(NoticeNo, UserNo, ReadDate)
			VALUES(NoticeNo, UserNo, NOW())

			UPDATE Notices
			SET
				CurrentViews = (SELECT COUNT(*) FROM NoticeReference WHERE NoticeNo = notice_insertviewnotice.noticeno)
			WHERE NoticeNo = notice_insertviewnotice.noticeno
		END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
