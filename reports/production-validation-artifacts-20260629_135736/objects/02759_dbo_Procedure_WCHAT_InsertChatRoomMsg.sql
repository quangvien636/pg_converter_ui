-- ─── PROCEDURE→FUNCTION: wchat_insertchatroommsg ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.wchat_insertchatroommsg(integer, integer);
CREATE OR REPLACE FUNCTION public.wchat_insertchatroommsg(
    IN chatno integer,
    IN userno integer
) RETURNS SETOF record
AS $function$
DECLARE
    msgno integer;
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	
	INSERT INTO WCHATContents (ChatNo, UserNo, Content) VALUES
	(ChatNo, UserNo, Msg)
	

	MsgNo := lastval();
	RETURN QUERY
	SELECT MsgNo;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
