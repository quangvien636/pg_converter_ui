-- ─── PROCEDURE→FUNCTION: dday_insertcoveredday ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.dday_insertcoveredday(integer, bigint, date);
CREATE OR REPLACE FUNCTION public.dday_insertcoveredday(
    IN userno integer,
    IN dayno bigint,
    IN covereddate date
) RETURNS SETOF record
AS $function$
DECLARE
    datano bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO DDay_CoveredDays (UserNo, DayNo, CoveredDate)
	VALUES (UserNo, DayNo, CoveredDate)


	DataNo := lastval();
	RETURN QUERY
	SELECT DataNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
