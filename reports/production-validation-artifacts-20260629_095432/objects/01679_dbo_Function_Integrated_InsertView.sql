-- ─── FUNCTION: integrated_insertview ───────────────────────────────
DROP FUNCTION IF EXISTS public.integrated_insertview(character varying, integer);
CREATE OR REPLACE FUNCTION public.integrated_insertview(
    userid character varying,
    no integer
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

	

	SELECT UserList = integrated_insertview.userid FROM public."Integrated_Reference" WHERE USERID = integrated_insertview.userid AND IntegratedNo = integrated_insertview.no
	
	IF UserList != ''
		BEGIN
			Print(UserList)
		END
	ELSE
		BEGIN






			SELECT DepartNo = B.DepartNo, PositionNo = B.POSITIONNO
			FROM Organization_Users A INNER JOIN Organization_BelongToDepartment B
			ON A.UserNo = B.USERNO
			WHERE A.UserID = integrated_insertview.userid
			
			SELECT DEPTName = NAME FROM Organization_Departments WHERE DepartNo = DepartNo
			SELECT PsName = NAME FROM Organization_Positions WHERE POSITIONNO = PositionNo
			SELECT NAME = NAME FROM Organization_Users WHERE USERID = integrated_insertview.userid

			INSERT INTO public."Integrated_Reference" (IntegratedNo, UserID, Department, Position, Name)
			VALUES(No, UserID, DEPTName, PsName, NAME)
		END
	
	
END;
-------------------/////////////////---------------------------
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
