-- ─── PROCEDURE→FUNCTION: edms_getsecuritylevel ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.edms_getsecuritylevel(integer);
CREATE OR REPLACE FUNCTION public.edms_getsecuritylevel(
    IN levelno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT LevelNo, ModUserNo, ModDate, Name
	FROM EDMS_SecurityLevels
	WHERE LevelNo = edms_getsecuritylevel.levelno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
