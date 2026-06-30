-- ─── FUNCTION: work_deleteworkgroupfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_deleteworkgroupfile(integer);
CREATE OR REPLACE FUNCTION public.work_deleteworkgroupfile(
    historyno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM WorkGroupFiles where HistoryNo = work_deleteworkgroupfile.historyno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
