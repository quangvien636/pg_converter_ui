-- ─── PROCEDURE→FUNCTION: dday_deletedirector ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.dday_deletedirector(bigint);
CREATE OR REPLACE FUNCTION public.dday_deletedirector(
    IN dayno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM DDay_Directors WHERE DayNo = dday_deletedirector.dayno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
