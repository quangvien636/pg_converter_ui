-- ─── PROCEDURE→FUNCTION: workingtime_getworkingtime_defaultnotices ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_getworkingtime_defaultnotices();
CREATE OR REPLACE FUNCTION public.workingtime_getworkingtime_defaultnotices(
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT W.NoticeNo, W.RegUserNo, U.Name AS UserName, W.RegDate,
		W.TimeType, W.Content
	FROM WorkingTime_DefaultNotices W
	INNER JOIN Organization_Users U ON U.UserNo = W.RegUserNo
	ORDER BY TimeType ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
