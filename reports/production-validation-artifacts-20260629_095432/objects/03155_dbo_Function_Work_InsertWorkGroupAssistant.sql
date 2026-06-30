-- ─── FUNCTION: work_insertworkgroupassistant ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_insertworkgroupassistant(integer, integer);
CREATE OR REPLACE FUNCTION public.work_insertworkgroupassistant(
    historyno integer,
    userno integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO WorkGroupAssistants(HistoryNo, UserNo)
	VALUES(HistoryNo, UserNo);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
