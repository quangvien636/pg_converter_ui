-- ─── PROCEDURE→FUNCTION: dday_insertcompletedrecord ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.dday_insertcompletedrecord(bigint, integer, timestamp without time zone, date);
CREATE OR REPLACE FUNCTION public.dday_insertcompletedrecord(
    IN dayno bigint,
    IN reguserno integer,
    IN regdate timestamp without time zone,
    IN completeddate date
) RETURNS SETOF record
AS $function$
DECLARE
    recordno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO DDay_CompletedRecords VALUES (DayNo, RegUserNo, RegDate, CompletedDate, Comment)


	RecordNo := lastval();
	RETURN QUERY
	SELECT RecordNo

	PERFORM dday_deletecountofappbadge(DayNo);
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
