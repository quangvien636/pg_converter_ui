-- ─── FUNCTION: dday_deletesharers ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_deletesharers(bigint);
CREATE OR REPLACE FUNCTION public.dday_deletesharers(
    dayno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM DDay_Sharers WHERE DayNo = dday_deletesharers.dayno

	EXEC DDay_DeleteCountOfAppBadge DayNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
