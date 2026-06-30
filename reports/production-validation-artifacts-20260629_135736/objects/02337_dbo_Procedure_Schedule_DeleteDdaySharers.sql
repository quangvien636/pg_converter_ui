-- ─── PROCEDURE→FUNCTION: schedule_deleteddaysharers ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.schedule_deleteddaysharers();
CREATE OR REPLACE FUNCTION public.schedule_deleteddaysharers(
) RETURNS void
AS $function$
BEGIN

	DELETE FROM ScheduleDdaySharers WHERE DdayNo = DdayNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
