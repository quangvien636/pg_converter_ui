-- ─── PROCEDURE→FUNCTION: dday_deletecompletedrecord ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.dday_deletecompletedrecord(bigint);
CREATE OR REPLACE FUNCTION public.dday_deletecompletedrecord(
    IN recordno bigint
) RETURNS void
AS $function$
BEGIN


	DELETE FROM DDay_CompletedRecords WHERE RecordNo = dday_deletecompletedrecord.recordno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
