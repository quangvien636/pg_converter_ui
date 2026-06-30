-- ─── PROCEDURE→FUNCTION: notice_deletedivision ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.notice_deletedivision(integer);
CREATE OR REPLACE FUNCTION public.notice_deletedivision(
    IN divisionno integer
) RETURNS void
AS $function$
BEGIN

	DELETE FROM NoticeDivisions WHERE DivisionNo = notice_deletedivision.divisionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
