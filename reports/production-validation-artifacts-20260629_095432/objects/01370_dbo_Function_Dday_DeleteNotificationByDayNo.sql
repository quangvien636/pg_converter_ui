-- ─── FUNCTION: dday_deletenotificationbydayno ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_deletenotificationbydayno(bigint);
CREATE OR REPLACE FUNCTION public.dday_deletenotificationbydayno(
    dayno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Dday_Notifications
	WHERE DayNo = dday_deletenotificationbydayno.dayno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
