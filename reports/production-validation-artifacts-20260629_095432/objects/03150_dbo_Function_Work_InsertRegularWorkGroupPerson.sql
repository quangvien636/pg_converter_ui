-- ─── FUNCTION: work_insertregularworkgroupperson ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_insertregularworkgroupperson(integer, integer);
CREATE OR REPLACE FUNCTION public.work_insertregularworkgroupperson(
    historyno integer,
    userno integer
) RETURNS void
AS $function$
BEGIN


	INSERT INTO RegularWorkGroupPersons(HistoryNo, UserNo)
	VALUES(HistoryNo, UserNo);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
