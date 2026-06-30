-- ─── PROCEDURE→FUNCTION: mail_getmailbccuserlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.mail_getmailbccuserlist();
CREATE OR REPLACE FUNCTION public.mail_getmailbccuserlist(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
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
