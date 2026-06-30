-- ─── FUNCTION: work_getregularworkgroupfiles ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getregularworkgroupfiles(integer);
CREATE OR REPLACE FUNCTION public.work_getregularworkgroupfiles(
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
	FROM RegularWorkGroupFiles WHERE HistoryNo = work_getregularworkgroupfiles.historyno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
