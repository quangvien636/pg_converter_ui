-- ─── PROCEDURE→FUNCTION: dday_deleteday ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.dday_deleteday(bigint);
CREATE OR REPLACE FUNCTION public.dday_deleteday(
    IN dayno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM DDay_Days WHERE DayNo = dday_deleteday.dayno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
