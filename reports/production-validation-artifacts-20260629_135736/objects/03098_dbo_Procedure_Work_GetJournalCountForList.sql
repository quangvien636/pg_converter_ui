-- ─── PROCEDURE→FUNCTION: work_getjournalcountforlist ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.work_getjournalcountforlist(integer, date, date);
CREATE OR REPLACE FUNCTION public.work_getjournalcountforlist(
    IN userno integer,
    IN startdate date,
    IN enddate date
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT COUNT(*)
	FROM WorkJournals WJ
	WHERE WJ.RegUserNo = work_getjournalcountforlist.userno AND CONVERT(DATE, WJ.CreationDate) = work_getjournalcountforlist.startdate;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
