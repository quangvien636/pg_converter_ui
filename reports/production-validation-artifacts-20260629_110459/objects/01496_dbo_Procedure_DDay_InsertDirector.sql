-- ─── PROCEDURE→FUNCTION: dday_insertdirector ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.dday_insertdirector(bigint, integer);
CREATE OR REPLACE FUNCTION public.dday_insertdirector(
    IN dayno bigint,
    IN userno integer
) RETURNS SETOF record
AS $function$
DECLARE
    directorno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	DELETE FROM DDay_Directors WHERE DayNo = dday_insertdirector.dayno

	INSERT INTO DDay_Directors VALUES (DayNo, UserNo)


	DirectorNo := COALESCE(lastval(), 0);
	RETURN QUERY
	SELECT DirectorNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
