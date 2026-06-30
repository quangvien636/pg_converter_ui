-- ─── FUNCTION: work_getworkfiles ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getworkfiles(integer);
CREATE OR REPLACE FUNCTION public.work_getworkfiles(
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
	FROM WorkFiles WHERE HistoryNo = work_getworkfiles.historyno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
