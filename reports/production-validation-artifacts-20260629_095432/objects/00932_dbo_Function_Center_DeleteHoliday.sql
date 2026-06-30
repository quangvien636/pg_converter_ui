-- ─── FUNCTION: center_deleteholiday ───────────────────────────────
DROP FUNCTION IF EXISTS public.center_deleteholiday(integer);
CREATE OR REPLACE FUNCTION public.center_deleteholiday(
    holidayno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Center_Holidays WHERE HolidayNo = center_deleteholiday.holidayno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
