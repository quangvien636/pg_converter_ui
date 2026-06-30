-- ─── PROCEDURE→FUNCTION: notice_addwidgetdivisions ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.notice_addwidgetdivisions(integer);
CREATE OR REPLACE FUNCTION public.notice_addwidgetdivisions(
    IN divisionno integer
) RETURNS void
AS $function$
BEGIN
UPDATE NoticeDivisions SET ViewMode = 1 WHERE DivisionNo = notice_addwidgetdivisions.divisionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
