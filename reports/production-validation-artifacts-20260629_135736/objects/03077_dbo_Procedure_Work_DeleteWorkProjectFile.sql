-- ─── PROCEDURE→FUNCTION: work_deleteworkprojectfile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.work_deleteworkprojectfile(integer);
CREATE OR REPLACE FUNCTION public.work_deleteworkprojectfile(
    IN historyno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM WorkProjectFiles where HistoryNo = work_deleteworkprojectfile.historyno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
