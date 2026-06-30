-- ─── FUNCTION: dday_deletemanagers ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_deletemanagers(bigint);
CREATE OR REPLACE FUNCTION public.dday_deletemanagers(
    dayno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM DDay_Managers WHERE DayNo = dday_deletemanagers.dayno

	EXEC DDay_DeleteCountOfAppBadge DayNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
