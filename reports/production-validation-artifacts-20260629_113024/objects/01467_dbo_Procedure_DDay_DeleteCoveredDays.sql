-- ─── PROCEDURE→FUNCTION: dday_deletecovereddays ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.dday_deletecovereddays(bigint);
CREATE OR REPLACE FUNCTION public.dday_deletecovereddays(
    IN dayno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM DDay_CoveredDays WHERE DayNo = dday_deletecovereddays.dayno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
