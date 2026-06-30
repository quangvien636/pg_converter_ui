-- ─── PROCEDURE→FUNCTION: quicklink_delete ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.quicklink_delete(bigint);
CREATE OR REPLACE FUNCTION public.quicklink_delete(
    IN seq bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	

	SELECT Seq INTO exist FROM  public."QuickLink" WHERE Seq = quicklink_delete.seq

	DELETE FROM public."QuickLink" 
		WHERE Seq = quicklink_delete.seq

	RETURN QUERY
	SELECT exist;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
