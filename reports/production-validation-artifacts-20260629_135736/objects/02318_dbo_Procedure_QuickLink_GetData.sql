-- ─── PROCEDURE→FUNCTION: quicklink_getdata ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.quicklink_getdata(integer);
CREATE OR REPLACE FUNCTION public.quicklink_getdata(
    IN userno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	RETURN QUERY
	SELECT * FROM public."QuickLink"  WHERE (UserNo=quicklink_getdata.userno OR UserNo = 0) and IsActive = TRUE 
		ORDER BY OrderId ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
