-- ─── FUNCTION: work_getworkprojectfiles ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getworkprojectfiles(integer);
CREATE OR REPLACE FUNCTION public.work_getworkprojectfiles(
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
	FROM WorkProjectFiles WHERE HistoryNo = work_getworkprojectfiles.historyno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
