-- ─── PROCEDURE→FUNCTION: quicklink_update ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.quicklink_update(bigint, integer, character varying, character varying, integer);
CREATE OR REPLACE FUNCTION public.quicklink_update(
    IN seq bigint,
    IN userno integer,
    IN title character varying,
    IN url character varying,
    IN orderid integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	UPDATE public."QuickLink"
	Title := quicklink_update.title,;
		Url = quicklink_update.url
	WHERE UserNo=quicklink_update.userno and IsActive = TRUE
		AND Seq = quicklink_update.seq
			 

	RETURN QUERY
	SELECT * FROM public."QuickLink"  WHERE UserNo=quicklink_update.userno and IsActive = TRUE 
		ORDER BY OrderId ASC;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
