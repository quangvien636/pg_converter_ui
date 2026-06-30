-- ─── PROCEDURE→FUNCTION: work_getregularworkjournaldivisions ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_getregularworkjournaldivisions(integer);
CREATE OR REPLACE FUNCTION public.work_getregularworkjournaldivisions(
    IN parentno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT DivisionNo, RegUserNo, REGDATE, ModUserNo, ModDate, Name, ParentNo, SortNo, Enabled
	FROM RegularWorkJournalDivisions
	WHERE ParentNo = work_getregularworkjournaldivisions.parentno AND Enabled = TRUE
	ORDER BY SortNo ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
