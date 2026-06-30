-- ─── FUNCTION: workingtime_deleteholiday ───────────────────────────────
DROP FUNCTION IF EXISTS public.workingtime_deleteholiday();
CREATE OR REPLACE FUNCTION public.workingtime_deleteholiday(
) RETURNS void
AS $function$
DECLARE
    nholino integer;
BEGIN



	OPEN Holi_Cursor;
	FETCH NEXT FROM Holi_Cursor INTO nHoliNo;
	WHILE @FETCH_STATUS = 0
	BEGIN;
		DELETE FROM WorkingTimeHoliday WHERE HolidayNo = CONVERT(INT,nHoliNo)
		FETCH NEXT FROM Holi_Cursor INTO nHoliNo;		
	END
	CLOSE Holi_Cursor;
	DEALLOCATE Holi_Cursor;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
