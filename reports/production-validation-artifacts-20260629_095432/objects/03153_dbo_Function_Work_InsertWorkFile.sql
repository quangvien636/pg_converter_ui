-- ─── FUNCTION: work_insertworkfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_insertworkfile(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.work_insertworkfile(
    historyno integer,
    name character varying,
    length integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO WorkFiles
	VALUES(HistoryNo, Name, Length);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
