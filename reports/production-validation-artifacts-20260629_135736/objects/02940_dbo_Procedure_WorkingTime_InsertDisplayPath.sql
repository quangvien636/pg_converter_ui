-- ─── PROCEDURE→FUNCTION: workingtime_insertdisplaypath ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.workingtime_insertdisplaypath(integer, integer, character varying, integer);
CREATE OR REPLACE FUNCTION public.workingtime_insertdisplaypath(
    IN startworkingno integer,
    IN endworkingno integer,
    IN paths character varying,
    IN distance integer
) RETURNS SETOF record
AS $function$
DECLARE
    pathno bigint;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	INSERT INTO WorkingTime_DisplayPaths (StartWorkingNo, EndWorkingNo, Paths, Distance)
	VALUES (StartWorkingNo, EndWorkingNo, Paths, Distance)


	PathNo := lastval();
	RETURN QUERY
	SELECT PathNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
