-- ─── FUNCTION: work_getjournalcountforlist ───────────────────────────────
DROP FUNCTION IF EXISTS public.work_getjournalcountforlist(integer, date, date);
CREATE OR REPLACE FUNCTION public.work_getjournalcountforlist(
    userno integer,
    startdate date,
    enddate date
) RETURNS TABLE(
    col1 text
)
AS $function$
BEGIN


	RETURN QUERY
	SELECT COUNT(*)
	FROM WorkJournals WJ
	WHERE WJ.RegUserNo = work_getjournalcountforlist.userno AND CONVERT(DATE, WJ.CreationDate) = work_getjournalcountforlist.startdate;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
