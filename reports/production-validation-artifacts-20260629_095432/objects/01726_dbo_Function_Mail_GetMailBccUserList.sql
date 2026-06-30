-- ─── FUNCTION: mail_getmailbccuserlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmailbccuserlist();
CREATE OR REPLACE FUNCTION public.mail_getmailbccuserlist(
) RETURNS TABLE(
    userno text,
    bccusernocount text
)
AS $function$
BEGIN

       
       RETURN QUERY
       select U.UserNo,U.UserID,U.Name,P.Name as PositionName,B.BccUserNoCount as BccSettingCount from (
	   SELECT UserNo,count(*) as BccUserNoCount
       FROM Mail_BccSetting
	   group by UserNo) B
	   INNER JOIN Organization_Users U ON B.UserNo = U.UserNo
	   INNER JOIN Organization_BelongToDepartment BB ON B.UserNo = BB.UserNo and BB.IsDefault = TRUE
	   INNER JOIN Organization_Departments D ON D.DepartNo = BB.DepartNo
	   INNER JOIN Organization_Positions P ON P.PositionNo = BB.PositionNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
