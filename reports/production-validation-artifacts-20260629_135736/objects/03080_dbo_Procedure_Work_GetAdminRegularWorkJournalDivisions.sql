-- ─── PROCEDURE→FUNCTION: work_getadminregularworkjournaldivisions ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_getadminregularworkjournaldivisions(integer);
CREATE OR REPLACE FUNCTION public.work_getadminregularworkjournaldivisions(
    IN parentno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT *
	FROM RegularWorkJournalDivisions
	WHERE ParentNo = work_getadminregularworkjournaldivisions.parentno
	ORDER BY SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
