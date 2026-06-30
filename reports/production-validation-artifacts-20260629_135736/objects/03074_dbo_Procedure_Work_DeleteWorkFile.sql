-- ─── PROCEDURE→FUNCTION: work_deleteworkfile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.work_deleteworkfile(integer);
CREATE OR REPLACE FUNCTION public.work_deleteworkfile(
    IN historyno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM WorkFiles where HistoryNo = work_deleteworkfile.historyno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
