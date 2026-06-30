-- ─── PROCEDURE→FUNCTION: work_getregularjournal ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_getregularjournal(integer);
CREATE OR REPLACE FUNCTION public.work_getregularjournal(
    IN journalno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT JournalNo, RegUserNo, RegDate, ModUserNo, ModDate,
		GroupNo, CreationDate, Title, DivisionNo, WorkTime, Content
	FROM RegularWorkJournals
	WHERE JournalNo = work_getregularjournal.journalno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
