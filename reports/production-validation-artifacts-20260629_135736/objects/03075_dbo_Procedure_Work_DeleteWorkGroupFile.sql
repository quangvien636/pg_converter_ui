-- ─── PROCEDURE→FUNCTION: work_deleteworkgroupfile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.work_deleteworkgroupfile(integer);
CREATE OR REPLACE FUNCTION public.work_deleteworkgroupfile(
    IN historyno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM WorkGroupFiles where HistoryNo = work_deleteworkgroupfile.historyno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
