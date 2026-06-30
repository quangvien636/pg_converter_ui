-- ─── FUNCTION: dday_deletecovereddays ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_deletecovereddays(bigint);
CREATE OR REPLACE FUNCTION public.dday_deletecovereddays(
    dayno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM DDay_CoveredDays WHERE DayNo = dday_deletecovereddays.dayno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
