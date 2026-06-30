-- ─── PROCEDURE→FUNCTION: integrated_getfile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.integrated_getfile(bigint);
CREATE OR REPLACE FUNCTION public.integrated_getfile(
    IN fileno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT ContentNo, Name, Size
	FROM Integrated_Files
	WHERE FileNo = integrated_getfile.fileno

END;

------------------------//////////////////
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
