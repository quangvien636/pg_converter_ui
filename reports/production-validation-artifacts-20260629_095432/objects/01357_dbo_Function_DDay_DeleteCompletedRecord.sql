-- ─── FUNCTION: dday_deletecompletedrecord ───────────────────────────────
DROP FUNCTION IF EXISTS public.dday_deletecompletedrecord(bigint);
CREATE OR REPLACE FUNCTION public.dday_deletecompletedrecord(
    recordno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM DDay_CompletedRecords WHERE RecordNo = dday_deletecompletedrecord.recordno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
