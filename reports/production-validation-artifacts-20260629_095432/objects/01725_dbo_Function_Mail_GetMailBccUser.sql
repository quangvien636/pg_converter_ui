-- ─── FUNCTION: mail_getmailbccuser ───────────────────────────────
DROP FUNCTION IF EXISTS public.mail_getmailbccuser(integer);
CREATE OR REPLACE FUNCTION public.mail_getmailbccuser(
    userno integer
) RETURNS TABLE(
    bccsettingno text,
    bccuserno text,
    userid text,
    name text,
    departname text,
    positionname text,
    mailaddress text
)
AS $function$
BEGIN

       
       RETURN QUERY
       SELECT B.BccSettingNo,B.BccUserNo,U.UserID,U.Name,D.Name as DepartName , P.Name as PositionName, U.MailAddress
       FROM Mail_BccSetting B
	   INNER JOIN Organization_Users U ON B.BccUserNo = U.UserNo
	   INNER JOIN Organization_BelongToDepartment BB ON B.BccUserNo = BB.UserNo and BB.IsDefault = TRUE
	   INNER JOIN Organization_Departments D ON D.DepartNo = BB.DepartNo
	   INNER JOIN Organization_Positions P ON P.PositionNo = BB.PositionNo
       WHERE B.UserNo = mail_getmailbccuser.userno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
