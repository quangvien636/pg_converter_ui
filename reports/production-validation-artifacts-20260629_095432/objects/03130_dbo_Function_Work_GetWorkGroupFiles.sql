-- ─── FUNCTION: work_getworkgroupfiles ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getworkgroupfiles(integer);
CREATE OR REPLACE FUNCTION public.work_getworkgroupfiles(
    historyno integer
) RETURNS TABLE(
    fileno text,
    historyno text,
    name text,
    length text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT FileNo, HistoryNo, Name, Length
	FROM WorkGroupFiles WHERE HistoryNo = work_getworkgroupfiles.historyno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
