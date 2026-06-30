-- ─── PROCEDURE→FUNCTION: bslg_getorglogyyyy ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.bslg_getorglogyyyy(character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_getorglogyyyy(
    IN departid character varying,
    IN date character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	
	RETURN QUERY
	SELECT DepartID, RegDate, SLog, ELog,UserNo, att1, att2, att3, att4, att5 FROM 
	BSLG_OrgLogYYYY WHERE RegDate=bslg_getorglogyyyy.date AND DepartID=bslg_getorglogyyyy.departid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
