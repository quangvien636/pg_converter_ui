-- ─── PROCEDURE→FUNCTION: bslg_getorglog_excel ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.bslg_getorglog_excel(character varying, character varying);
CREATE OR REPLACE FUNCTION public.bslg_getorglog_excel(
    IN departid character varying,
    IN date character varying
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
	
	RETURN QUERY
	SELECT 
	DepartID, 
	RegDate, 
	REPLACE(REPLACE(Convert(text,SLog),char(13),'<br>'),CHAR(10),'') as SLog, 
	REPLACE(REPLACE(Convert(text,ELog),char(13),'<br>'),CHAR(10),'')  as ELog, 
	att1, 
	att2, 
	att3, 
	att4, 
	att5 
	FROM BSLG_OrgLog 
	WHERE RegDate=bslg_getorglog_excel.date AND DepartID=bslg_getorglog_excel.departid;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
