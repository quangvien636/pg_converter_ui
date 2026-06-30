-- ─── PROCEDURE→FUNCTION: workingtime_deleteholiday ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.workingtime_deleteholiday();
CREATE OR REPLACE FUNCTION public.workingtime_deleteholiday(
) RETURNS void
AS $function$
DECLARE
    nholino integer;
BEGIN


	
		FOR _rec IN SELECT VALUE FROM public."UF_TEXT_SPLIT"(HolidayNo,',')
LOOP
    nholino := _rec.value;

	BEGIN;
		DELETE FROM WorkingTimeHoliday WHERE HolidayNo = CONVERT(INT,nHoliNo)
			END;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
