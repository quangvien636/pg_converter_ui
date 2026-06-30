-- ─── FUNCTION: dday_deletecompletedrecords ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_deletecompletedrecords(bigint);
CREATE OR REPLACE FUNCTION public.dday_deletecompletedrecords(
    dayno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM DDay_CompletedRecords WHERE DayNo = dday_deletecompletedrecords.dayno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
