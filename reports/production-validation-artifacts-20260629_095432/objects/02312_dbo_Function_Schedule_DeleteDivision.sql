-- ─── FUNCTION: schedule_deletedivision ───────────────────────────────
DROP FUNCTION IF EXISTS public.schedule_deletedivision();
CREATE OR REPLACE FUNCTION public.schedule_deletedivision(
) RETURNS void
AS $function$
DECLARE
    ndivisionno integer;
BEGIN




	OPEN Divis_Cursor;
	FETCH NEXT FROM Divis_Cursor INTO nDivisionNo;
	WHILE @FETCH_STATUS = 0
	BEGIN;
		DELETE FROM ScheduleDivisions WHERE DivisionNo = CONVERT(INT,nDivisionNo)
		FETCH NEXT FROM Divis_Cursor INTO nDivisionNo;		
	END
	CLOSE Divis_Cursor;
	DEALLOCATE Divis_Cursor;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
