-- ─── FUNCTION: work_deleteworkprojectfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_deleteworkprojectfile(integer);
CREATE OR REPLACE FUNCTION public.work_deleteworkprojectfile(
    historyno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM WorkProjectFiles where HistoryNo = work_deleteworkprojectfile.historyno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
