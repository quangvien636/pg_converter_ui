-- ─── PROCEDURE→FUNCTION: dday_getnotificationdaylist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.dday_getnotificationdaylist();
CREATE OR REPLACE FUNCTION public.dday_getnotificationdaylist(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



RETURN QUERY
SELECT  DD.dayno,
		DD.reguserno  ,
		DD.moduserno  ,
		DD.moddate ,
		DD.groupno  ,
		DD.typeno  ,
		DD.repeatoptions  ,
		DD.title  ,
		DD.content  ,
		DD.canhide ,
		DN.NotificationType,
		DN.NotificationTime
	FROM dday_days DD
	INNER JOIN Dday_Notifications DN ON DN.DayNo=DD.DayNo
	WHERE  DN.NotificationType<2;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
