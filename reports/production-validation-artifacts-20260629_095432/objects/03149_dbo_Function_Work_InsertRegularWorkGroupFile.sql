-- ─── FUNCTION: work_insertregularworkgroupfile ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_insertregularworkgroupfile(bigint, integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.work_insertregularworkgroupfile(
    fileno bigint,
    historyno integer,
    name character varying,
    length integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO RegularWorkGroupFiles
	VALUES(FileNo, HistoryNo, Name, Length);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
