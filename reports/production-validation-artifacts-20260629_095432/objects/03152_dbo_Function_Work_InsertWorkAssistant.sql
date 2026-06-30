-- ─── FUNCTION: work_insertworkassistant ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_insertworkassistant(integer, integer);
CREATE OR REPLACE FUNCTION public.work_insertworkassistant(
    historyno integer,
    userno integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO WorkAssistants(HistoryNo, UserNo)
	VALUES(HistoryNo, UserNo);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
