-- ─── PROCEDURE→FUNCTION: edmsgettransferfile ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.edmsgettransferfile(integer);
CREATE OR REPLACE FUNCTION public.edmsgettransferfile(
    IN docid integer
) RETURNS SETOF record
AS $function$
DECLARE
    docid integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN
/*

--*/	

 	RETURN QUERY
 	SELECT ID
	,	DOCID
	,	ATTACHPATH
	,	ATTACHNAME
	,	ATTACHFLAG
	,	ISPDF
	FROM EDMSFILE 	
	WHERE DOCID = edmsgettransferfile.docid
	AND		ISPDF = '';
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
