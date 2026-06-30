-- ─── PROCEDURE→FUNCTION: notice_getdivision ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.notice_getdivision(integer);
CREATE OR REPLACE FUNCTION public.notice_getdivision(
    IN divisionno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT DivisionNo, RegUserNo, RegDate, ModUserNo, ModDate, Name,Sort, ViewMode
	FROM NoticeDivisions
	WHERE DivisionNo= notice_getdivision.divisionno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
