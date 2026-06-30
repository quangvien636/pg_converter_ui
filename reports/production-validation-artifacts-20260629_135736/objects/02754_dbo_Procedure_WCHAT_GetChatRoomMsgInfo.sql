-- ─── PROCEDURE→FUNCTION: wchat_getchatroommsginfo ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.wchat_getchatroommsginfo(integer);
CREATE OR REPLACE FUNCTION public.wchat_getchatroommsginfo(
    IN contentno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	RETURN QUERY
	SELECT ContentNo, ChatNo, Content, 
	UserNo, IsAttach, AttachNo, RegDate FROM WCHATContents WHERE ContentNo = wchat_getchatroommsginfo.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
