-- ─── FUNCTION: noticesyn_insertviewnotice ───────────────────────────────
DROP FUNCTION IF EXISTS public.noticesyn_insertviewnotice(character varying, integer);
CREATE OR REPLACE FUNCTION public.noticesyn_insertviewnotice(
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
BEGIN

	

	SELECT UserList = noticesyn_insertviewnotice.userid FROM public."NoticeSyn_Reference" WHERE USERID = noticesyn_insertviewnotice.userid AND NoticeNo = noticesyn_insertviewnotice.noticeno
	
	IF UserList != ''
		BEGIN
			Print(UserList)
		END
	ELSE
		BEGIN






			SELECT DepartNo = B.DepartNo, PositionNo = B.POSITIONNO
			FROM Organization_Users A INNER JOIN Organization_BelongToDepartment B
			ON A.UserNo = B.USERNO
			WHERE A.UserID = noticesyn_insertviewnotice.userid
			
			SELECT DEPTName = NAME FROM Organization_Departments WHERE DepartNo = DepartNo
			SELECT PsName = NAME FROM Organization_Positions WHERE POSITIONNO = PositionNo
			SELECT NAME = NAME FROM Organization_Users WHERE USERID = noticesyn_insertviewnotice.userid

			INSERT INTO public."NoticeSyn_Reference" (NoticeNo, UserID, Department, Position, Name)
			VALUES(NoticeNo, UserID, DEPTName, PsName, NAME)
		END
	
	
END;
---------------------------------------------
-- USE CrewCloud_Core
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
