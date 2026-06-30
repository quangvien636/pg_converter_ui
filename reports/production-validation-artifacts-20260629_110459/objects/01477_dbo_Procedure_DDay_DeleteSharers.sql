-- ─── PROCEDURE→FUNCTION: dday_deletesharers ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.dday_deletesharers(bigint);
CREATE OR REPLACE FUNCTION public.dday_deletesharers(
    IN dayno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM DDay_Sharers WHERE DayNo = dday_deletesharers.dayno

	PERFORM dday_deletecountofappbadge(DayNo);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
