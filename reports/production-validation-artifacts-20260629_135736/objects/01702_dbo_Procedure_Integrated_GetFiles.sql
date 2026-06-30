-- ─── PROCEDURE→FUNCTION: integrated_getfiles ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.integrated_getfiles(bigint);
CREATE OR REPLACE FUNCTION public.integrated_getfiles(
    IN contentno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN


	RETURN QUERY
	SELECT FileNo, Name, Size
	FROM Integrated_Files
	WHERE ContentNo = integrated_getfiles.contentno

END;
-----------------------////////////////////////////////////-----------------------
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
