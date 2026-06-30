-- ─── PROCEDURE→FUNCTION: crewchat_getchatroomstartendmessageno ───────────────────────────────
-- NOTE: SQL Server stored procedure converted to PostgreSQL function.
-- TODO: Review converted output — stored procedure semantics differ; test before use in production.
-- TODO: replace SETOF record — procedure returns results; add RETURNS TABLE(col type, ...) manually
-- TODO: procedure contains result-returning SELECT; replace SETOF record with correct column types
DROP FUNCTION IF EXISTS public.crewchat_getchatroomstartendmessageno(bigint);
CREATE OR REPLACE FUNCTION public.crewchat_getchatroomstartendmessageno(
    IN roomno bigint
) RETURNS SETOF record
AS $function$
-- !! WARNING: output needs manual review — see TODO comments
BEGIN

	RETURN QUERY
	SELECT 
	MIN(MessageNo) as StartMessageNo, 
	MAX(MessageNo) as EndMessageNo
	FROM CrewChat_Messages
	WHERE RoomNo = crewchat_getchatroomstartendmessageno.roomno;
END;
$function$
LANGUAGE plpgsql;
-- TODO: Owner mapping skipped. Target role postgres not verified.
