-- ─── FUNCTION: dday_deletedirector ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_deletedirector(bigint);
CREATE OR REPLACE FUNCTION public.dday_deletedirector(
    dayno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM DDay_Directors WHERE DayNo = dday_deletedirector.dayno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
