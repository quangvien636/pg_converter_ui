-- ─── FUNCTION: work_getworkcount ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getworkcount(integer, integer);
CREATE OR REPLACE FUNCTION public.work_getworkcount(
    userno integer,
    groupno integer
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT COUNT(*)
	FROM Works W
	INNER JOIN WorkHistorys H ON H.HistoryNo = W.HistoryNo
	WHERE W.GroupNo = work_getworkcount.groupno AND Enabled = TRUE;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
