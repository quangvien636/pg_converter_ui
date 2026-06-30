-- ─── PROCEDURE→FUNCTION: dday_getcompletedrecordsfordays ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: Dynamic SQL detected. Manual rewrite required for PostgreSQL.
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.dday_getcompletedrecordsfordays();
CREATE OR REPLACE FUNCTION public.dday_getcompletedrecordsfordays(
) RETURNS SETOF record
AS $function$
DECLARE
    query character varying;
    result table (
		recordno		bigint,
		dayno			bigint,
		completeddate	date
	);
-- !! WARNING: output needs manual review — see TODO comments
BEGIN



	Query := 'SELECT RecordNo, DayNo, CompletedDate FROM DDay_CompletedRecords ' +;
		'WHERE DayNo IN (' || ListOfDays || ') ' +
		'ORDER BY CompletedDate DESC'


	INSERT INTO Result
	PERFORM query();
	RETURN QUERY
	SELECT * FROM Result;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
