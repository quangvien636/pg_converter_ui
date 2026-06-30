-- ─── FUNCTION: work_insertworkgroupfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_insertworkgroupfile(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.work_insertworkgroupfile(
    historyno integer,
    name character varying,
    length integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO WorkGroupFiles
	VALUES(HistoryNo, Name, Length);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
