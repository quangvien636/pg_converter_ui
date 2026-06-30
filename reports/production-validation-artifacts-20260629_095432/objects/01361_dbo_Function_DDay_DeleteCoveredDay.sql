-- ─── FUNCTION: dday_deletecoveredday ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_deletecoveredday(bigint);
CREATE OR REPLACE FUNCTION public.dday_deletecoveredday(
    datano bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM DDay_CoveredDays WHERE DataNo = dday_deletecoveredday.datano;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
