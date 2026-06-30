-- ─── FUNCTION: notice_deletedivision ───────────────────────────────
DROP FUNCTION IF EXISTS public.notice_deletedivision(integer);
CREATE OR REPLACE FUNCTION public.notice_deletedivision(
    divisionno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM NoticeDivisions WHERE DivisionNo = notice_deletedivision.divisionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
