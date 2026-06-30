-- ─── PROCEDURE→FUNCTION: mail_getmailbccuser ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_getmailbccuser(integer);
CREATE OR REPLACE FUNCTION public.mail_getmailbccuser(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
