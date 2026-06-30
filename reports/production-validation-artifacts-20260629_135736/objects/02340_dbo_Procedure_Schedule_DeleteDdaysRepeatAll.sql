-- ─── PROCEDURE→FUNCTION: schedule_deleteddaysrepeatall ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_deleteddaysrepeatall();
CREATE OR REPLACE FUNCTION public.schedule_deleteddaysrepeatall(
) RETURNS void
AS $function$
BEGIN

	DELETE FROM ScheduleDdaysRepeat 
	WHERE DdayNo = DdayNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
