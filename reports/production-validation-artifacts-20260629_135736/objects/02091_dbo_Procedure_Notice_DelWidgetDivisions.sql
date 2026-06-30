-- ─── PROCEDURE→FUNCTION: notice_delwidgetdivisions ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
DROP FUNCTION IF EXISTS public.notice_delwidgetdivisions(integer);
CREATE OR REPLACE FUNCTION public.notice_delwidgetdivisions(
    IN divisionno integer
) RETURNS void
AS $function$
BEGIN
UPDATE NoticeDivisions SET ViewMode = 0 WHERE DivisionNo = notice_delwidgetdivisions.divisionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
