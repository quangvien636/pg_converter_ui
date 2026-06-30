-- ─── FUNCTION: work_insertworkprojectfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_insertworkprojectfile(integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.work_insertworkprojectfile(
    historyno integer,
    name character varying,
    length integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO WorkProjectFiles
	VALUES(HistoryNo, Name, Length);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
