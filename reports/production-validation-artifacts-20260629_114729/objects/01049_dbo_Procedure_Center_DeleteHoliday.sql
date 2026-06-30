-- ─── PROCEDURE→FUNCTION: center_deleteholiday ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.center_deleteholiday(integer);
CREATE OR REPLACE FUNCTION public.center_deleteholiday(
    IN holidayno integer
) RETURNS void
AS $function$
BEGIN


	DELETE FROM Center_Holidays WHERE HolidayNo = center_deleteholiday.holidayno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
