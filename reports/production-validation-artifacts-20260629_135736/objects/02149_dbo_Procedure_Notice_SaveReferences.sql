-- ─── PROCEDURE→FUNCTION: notice_savereferences ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.notice_savereferences(integer);
CREATE OR REPLACE FUNCTION public.notice_savereferences(
    IN userno integer
) RETURNS void
AS $function$
BEGIN


   insert into NoticeReference(NoticeNo,UserID,ReadDate,Department,Position,Name)
   Select NoticeNo, u.UserID,  NOW(), d.Name, p.Name, u.Name
   from  Organization_Users u 
   left JOIN  (SELECT MAX(DepartNo) DepartNo, MAX(PositionNo) PositionNo, UserNo FROM Organization_BelongToDepartment where UserNo = notice_savereferences.userno  GROUP BY UserNo) B ON B.UserNo = u.UserNo
	LEFT JOIN Organization_Positions P  ON P.PositionNo = B.PositionNo
	LEFT JOIN Organization_Departments D  ON D.DepartNo = B.DepartNo
   where u.UserNo = notice_savereferences.userno;;
   update Notices set TotalViews = TotalViews + 1, CurrentViews = CurrentViews + 1 where NoticeNo = NoticeNo;
	IF (SELECT COUNT(UserNo) FROM NoticeReferences WHERE NoticeNo = NoticeNo AND UserNo = notice_savereferences.userno) = 0 THEN
		-- INSERT INTO statements for procedure here;
		INSERT INTO NoticeReferences
		(NoticeNo, UserNo, ReadDate)
		VALUES
		(NoticeNo, UserNo, NOW())
	END IF;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
