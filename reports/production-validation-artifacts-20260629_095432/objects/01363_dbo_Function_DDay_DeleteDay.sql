-- ─── FUNCTION: dday_deleteday ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_deleteday(bigint);
CREATE OR REPLACE FUNCTION public.dday_deleteday(
    dayno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM DDay_Days WHERE DayNo = dday_deleteday.dayno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
