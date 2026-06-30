-- ─── PROCEDURE→FUNCTION: webservice_gcmgetlistregids ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.webservice_gcmgetlistregids(integer);
CREATE OR REPLACE FUNCTION public.webservice_gcmgetlistregids(
    IN isdeleted integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT * FROM WebService_GCMRegistration
	WHERE isDeleted=webservice_gcmgetlistregids.isdeleted AND AppKey=AppKey;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
