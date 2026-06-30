-- ─── PROCEDURE→FUNCTION: wchat_getchatroomnewmsg ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.wchat_getchatroomnewmsg(integer, integer);
CREATE OR REPLACE FUNCTION public.wchat_getchatroomnewmsg(
    IN chatno integer,
    IN contentno integer
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	RETURN QUERY
	SELECT ContentNo, ChatNo, Content, 
	UserNo, IsAttach, AttachNo, RegDate FROM WCHATContents WHERE ChatNo = wchat_getchatroomnewmsg.chatno
	AND ContentNo > wchat_getchatroomnewmsg.contentno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
