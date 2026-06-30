-- ─── PROCEDURE→FUNCTION: dday_deletecompletedrecords ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.dday_deletecompletedrecords(bigint);
CREATE OR REPLACE FUNCTION public.dday_deletecompletedrecords(
    IN dayno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM DDay_CompletedRecords WHERE DayNo = dday_deletecompletedrecords.dayno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
