-- ─── PROCEDURE→FUNCTION: dday_deletecoveredday ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.dday_deletecoveredday(bigint);
CREATE OR REPLACE FUNCTION public.dday_deletecoveredday(
    IN datano bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM DDay_CoveredDays WHERE DataNo = dday_deletecoveredday.datano;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
